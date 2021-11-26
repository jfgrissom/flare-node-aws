import * as cdk from '@aws-cdk/core'
import * as ec2 from '@aws-cdk/aws-ec2'
import * as iam from '@aws-cdk/aws-iam'
import { Asset } from '@aws-cdk/aws-s3-assets'
import * as path from 'path'

export class FlareNodeStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props)

    // This script is not meant to be run in a build pipeline.
    // It's meant to be run in by a trusted SA/SE.
    const accessIp = process.env.SSH_ACCESS_IP
    if (!accessIp) throw new Error('Please set SSH_ACCESS_IP')
    const accessCidr = `${accessIp}/32`

    const keyPairName = process.env.CDK_KEYPAIR_NAME
    if (!keyPairName) throw new Error('Please set CDK_KEYPAIR_NAME')

    const projectName = process.env.CDK_PROJECT_NAME
    if (!projectName) throw new Error('Please set CDK_PROJECT_NAME')

    // Create a new VPC
    const vpc = new ec2.Vpc(this, 'VPC', {
      natGateways: 0,
      subnetConfiguration: [
        {
          cidrMask: 24,
          name: `${projectName}-subnet`,
          subnetType: ec2.SubnetType.PUBLIC
        }
      ]
    })

    // Allow SSH (TCP Port 22) access from the public IP specified in SSH_ACCESS_IP.
    const securityGroup = new ec2.SecurityGroup(this, 'SecurityGroup', {
      vpc,
      description: 'Allow SSH (TCP port 22) in',
      allowAllOutbound: true
    })
    securityGroup.addIngressRule(
      ec2.Peer.ipv4(accessCidr),
      ec2.Port.tcp(22),
      'Allow SSH Access'
    )

    const role = new iam.Role(this, 'ec2Role', {
      assumedBy: new iam.ServicePrincipal('ec2.amazonaws.com')
    })

    role.addManagedPolicy(
      iam.ManagedPolicy.fromAwsManagedPolicyName('AmazonSSMManagedInstanceCore')
    )

    // Use Latest Amazon Linux Image - CPU Type ARM64
    const ami = new ec2.AmazonLinuxImage({
      generation: ec2.AmazonLinuxGeneration.AMAZON_LINUX_2,
      cpuType: ec2.AmazonLinuxCpuType.ARM_64
    })

    // Create the instance using the VPC, Security Group, AMI, and add the keyPair.
    const ec2Instance = new ec2.Instance(this, 'Instance', {
      vpc,
      instanceType: ec2.InstanceType.of(
        ec2.InstanceClass.M5,
        ec2.InstanceSize.LARGE
      ),
      machineImage: ami,
      securityGroup: securityGroup,
      keyName: keyPairName,
      role: role
    })

    // Create an asset that will be used as part of User Data to run on first load
    const asset = new Asset(this, 'Asset', {
      path: path.join(__dirname, '../bin/user-data/bootstrap.sh')
    })
    const localPath = ec2Instance.userData.addS3DownloadCommand({
      bucket: asset.bucket,
      bucketKey: asset.s3ObjectKey
    })

    ec2Instance.userData.addExecuteFileCommand({
      filePath: localPath,
      arguments: '--verbose -y'
    })
    asset.grantRead(ec2Instance.role)

    // Create outputs for connecting
    new cdk.CfnOutput(this, 'IP Address', {
      value: ec2Instance.instancePublicIp
    })
    new cdk.CfnOutput(this, 'Key Name', { value: keyPairName })
    new cdk.CfnOutput(this, 'ssh command', {
      value:
        `ssh -i ${keyPairName}.pem -o IdentitiesOnly=yes ec2-user@` +
        ec2Instance.instancePublicIp
    })
  }
}
