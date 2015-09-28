neo4j
=====

Neo4j is a highly scalable, robust (fully ACID) native graph database. Neo4j is used in mission-critical apps by thousands of leading, startups, enterprises, and governments around the world.

With the Dockerfile on repository you've a docker neo4j community edition image ready to go.

### Setup

Build and run:
```
git clone https://github.com/neildobson71/docker-neo4j
cd docker-neo4j
docker build .
```
Create and start the container (with no authorization, port 20001):
```
docker run -i -t -d -e NEO4J_AUTH=none --name neo4j -v $HOME/neo4j-data:/data --cap-add=SYS_RESOURCE -p 20001:7474 <image-id>
```
Access to http://127.0.0.1:20001 with your browser.

#### Authentication
You can add authorization credentials or disable authorization by passing `NEO4J_AUTH` as environment variable.

* To set username/password:
```
docker run -i -t -d -e NEO4J_AUTH=username:password --name neo4j --cap-add=SYS_RESOURCE -p 7474:7474 <image-id>
```
* To bypass authentication:
```
docker run -i -t -d -e NEO4J_AUTH=none --name neo4j --cap-add=SYS_RESOURCE -p 7474:7474 <image-id>
```
#### Volumes 
The neo4j data is stored in $HOME/neo4j-data.  
*  To use a volume to store the database:
```
docker run -i -t -d --name neo4j --cap-add=SYS_RESOURCE -v $HOME/neo4j-data:/data -p 7474:7474 <image-id>
```
