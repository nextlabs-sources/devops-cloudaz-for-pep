 # Installing SQL server 2017 (Linux version of container) 
 docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=yourStrong(!)Password' -e 'MSSQL_PID=Express' -p 1433:1433 -v sqlvolume:/var/opt/mssql -d mcr.microsoft.com/mssql/server:2017-latest-ubuntu

 # RUN  
 docker exec -it a8ce9868dc82 /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'yourStrong(!)Password'

 # Copy files from a container
 docker cp <Container ID>:<Container path> <host path>
 e.g : docker cp d6b75213ef80:/var/opt/mssql/log/errorlog /tmp/errorlog

 # Copy files into a container
 docker cp <Host path> <Container ID>:<Container path>
 docker cp /tmp/mydb.mdf d6b75213ef80:/var/opt/mssql/data

 # SQL Server setup and error logs
 You can look at the SQL Server setup and error logs in /var/opt/mssql/log. If the container is not running, first start the container. Then use an interactive command-prompt to inspect the logs.

docker start e69e056c702d
docker exec -it e69e056c702d "bash"


# create login and assign user to login
## After login
conenct via SSM (GUI)

login using sa account
click security -> login -> create login
give login name: cclogin and password 123next!
default database choose ccdb (you should have created database at this point)

click use mapping
select database -> select roles -> db owner

# associating to User
associate login with DB user
Expand database -> click security -> right click -> create -> user
give user name as ccdbuser
select membership-> click db_owner

# login to db using login account (cclogin)
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=yourStrong(!)Password' -e 'MSSQL_PID=Express' -p 1433:1433 -v sqlvolume:/var/opt/mssql -d mcr.microsoft.com/mssql/server:2017-latest-ubuntu
docker exec -it a8ce9868dc82 /opt/mssql-tools/bin/sqlcmd -S localhost -U cclogin -P '123Next!'

# REFE: https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-2017&pivots=cs1-bash


# elastic search configuration is isn SYS_CONFIG table in Database
applicatgion: console
CONFIG_KEY: search.engine.cluster.name
VALUE: 

# when Changing server name have to chnage in 
APPLICATIOn: applicatin
server.name: https://dc.serviceops.cloudaz.net:443

and also in Server.XML  using linux find command

# then finally have to generate certificates

# elastic search version supported is 6.4.3

docker-compose up -d

check the cluster health status


curl http://127.0.0.1:9200/_cluster/health?pretty

## View the indices:
curl http://127.0.0.1:9200/_cat/indices?v

# View Indices with Kibana Dashboard (No need to do nginx redirection etc ..)
http://dc.serviceops.cloudaz.net:5601/


# Elastic Search documentation
https://blog.ruanbekker.com/blog/2018/04/29/running-a-3-node-elasticsearch-cluster-with-docker-compose-on-your-laptop-for-testing/

# get clarified on SQL Server Security (Login etc)
https://www.youtube.com/watch?v=IDxXUBNBxPA

# restarting docker-compose
docker-compose restart 

# SQL container with restart option
docker run --restart always -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=yourStrong(!)Password' -e 'MSSQL_PID=Express' -p 1433:1433 -v sqlvolume:/var/opt/mssql -d mcr.microsoft.com/mssql/server:2017-latest-ubuntu


# ALPINE CONTAIENR BEST PRACTICES

https://blog.gds-gov.tech/writing-effective-docker-images-more-efficiently-bf0129c3293b


# docker size reduce (RMS eng wiki - tips)
https://bitbucket.org/nxtlbs-devops/rightsmanagement-wiki/wiki/RMS/deployment/Docker/Configuration%20and%20Build%20Optimisation