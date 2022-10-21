# Deploy Nginx on Bosh
https://github.com/cloudfoundry-community/nginx-release

Deploying Cloudfoundry on Bosh-Lite: https://docs.cloudfoundry.org/deploying/cf-deployment/deploy-cf.html

Spring-Music on Bosh-Lite: https://medium.com/@ravijagannathan/install-cloud-foundry-on-bosh-lite-6d3b9a1e416a

Cloud foundry on bosh-lite: https://fabianlee.org/2018/03/08/cloudfoundry-deploy-cloud-foundry-locally-using-bosh-lite-on-ubuntu/

## Nginx Deployment
1. Upload appropriate stemcell (Bionic) to `bosh` director
```bash
bosh -e $ENVIRONMENT_NAME upload-stemcell --sha1 19355b8bece54930f78077290b7c1562ef45c1ee \
  https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-bionic-go_agent?v=1.115
```

2. Clone `nginx` release repository and `cd` into it

```bash
cd ~/workspace
git clone https://github.com/cloudfoundry-community/nginx-release.git
cd nginx-release
```
3. Upload nginx release

```bash
bosh -e vbox ur https://github.com/cloudfoundry-community/nginx-release/releases/download/1.21.6/nginx-release-1.21.6.tgz

```

4. Deploy Nginx on stemcell

```bash
bosh -e $NAME -d nginx deploy manifests/nginx-lite.yml
```

5. Add route to make nginx accessible locally

```bash
sudo ip route add 10.244.0.0/24 via 192.168.56.6
```

## Scaling
Scaling can be down by editing the `nginx-lite.yml` file. You can add extra instances, etc. Additionally, you would be able to use the `cloud-config.yml` found in the `~/workspace/bosh-deployment/virtualbox`folder to assign more diskpace, RAM, etc to the bosh director. 

NOTE: In the `nginx-lite.yml` file, get rid of the `static ip` parameter and save `nginx-lite.yml` file.

