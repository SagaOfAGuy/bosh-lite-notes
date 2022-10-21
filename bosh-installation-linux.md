# BOSH Lite v2 installation

Environment: Ubuntu Linux

Docs: https://bosh.io/docs/bosh-lite/

## Installing CLI V2
Download CLI V2 from: https://github.com/cloudfoundry/bosh-cli/releases

1. Install `bosh` executable

```bash
wget https://github.com/cloudfoundry/bosh-cli/releases/download/v7.0.1/bosh-cli-7.0.1-linux-amd64
```

2. Check `sha256sum` value of executable as provided by downloads page on  https://github.com/cloudfoundry/bosh-cli/releases and make sure they match.

```bash
sha256sum bosh-cli-7.0.1-linux-amd64
```

3. Rename, add executable permissions and move executable to bin folder

```bash
chmod +x bosh-cli-7.0.1-linux-amd64 && sudo mv bosh-cli-7.0.1-linux-amd64 bosh && sudo mv bosh /usr/bin
```

4. Verify `bosh` version number

```bash
bosh -v
```

5. Install additional dependencies

```bash
sudo apt-get install -y build-essential zlib1g-dev ruby ruby-dev openssl libxslt1-dev libxml2-dev libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3
```

## Installing VirtualBox
1. VirtualBox Install

```bash
sudo apt install virtualbox virtualbox-ext-pack
```

2. Verify Virtualbox Version
```bash
VBoxManage --version
```
