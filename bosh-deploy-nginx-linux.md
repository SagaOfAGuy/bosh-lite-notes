# Deploy Nginx on Bosh

1. Upload appropriate stemcell to `bosh` director
```bash
bosh upload-stemcell --sha1 2234c87513356e2f038ab993ef508b8724893683 \
  https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-trusty-go_agent?v=3586.100
```

2. Clone `nginx` release repository and `cd` into it

```bash
cd ~/workspace
git clone https://github.com/cloudfoundry-community/nginx-release.git
cd nginx-release
```

3. Deploy Nginx on stemcell

```bash
bosh -e $NAME -d nginx deploy manifests/nginx-lite.yml
```


