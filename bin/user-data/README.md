# Purpose of startup.sh

This script should be run the first time your flare node is started. It bootstraps the system and sets up a flare node.

It's idempotent so you can run it over and over (as root) without fear of causing damage.

## Dependencies

This script assumes you're following installation instructions from the [Flare Readme](https://gitlab.com/flarenetwork/flare).

- You're running on Ubuntu 20.04.
- The script is running as root (as it would when a [user-data](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html) script is called on the first system startup).

# Usage

Run this script as root. Be sure to pass in compiler options (local | songbird). For example: `./startup.sh local`.
