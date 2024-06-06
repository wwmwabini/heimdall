# example usage:
# docker network create --driver bridge heimdall # this allows container name resolution
# docker build -t "heimdall:20.06.21.1" .
# for a central manager, and set the default admin user/password on init
# the diretory mount of /opt/heimdall/config provides a persistent location for the configuration
# docker run -d --name heimdallmanager --network heimdall --memory=2g -v /opt/heimdall/config:/opt/heimdall/config -e hduser='admin' -e hdpassword='some password' -p 8087 heimdall:20.06.21.1
# then configure a vdb named "proxy-vdb" in the central manager.  Once created, you can create a proxy container.  The configcache allows starting new proxies even if the central manager is offline
# docker run -d --name heimdallproxy1  --network heimdall --memory=4g -v /opt/heimdall/configcache:/opt/heimdall/configcache -e hduser='admin' -e hdpassword='some password' -e hdRole='proxy' -e vdbName='proxy-vdb' -e configcache='/opt/heimdall/configcache' -p 3306 -p 5432 -p 1433 heimdall:20.06.21.1

FROM ubuntu:latest
#FROM amazonlinux:latest

# for the Heimdall UI, only needed for the management server
EXPOSE 8087

# common ports for databases
EXPOSE 5432
EXPOSE 3306
EXPOSE 1433

RUN apt-get -y update && apt-get install -y curl
#RUN yum -y install curl
RUN bash -c 'bash <(curl https://s3.amazonaws.com/s3.heimdalldata.com/hdinstall.sh) server'

CMD ["/opt/heimdall/heimdall-entrypoint.sh"]
