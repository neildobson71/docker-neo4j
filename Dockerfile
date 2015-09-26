## Neo4J dependency: java
## get java from official repo
from java:latest
maintainer Neil Dobson, neil.dobson71@gmail.com

## install neo4j according to http://debian.neo4j.org/
# Import neo4j signing key
# Create an apt sources.list file
# Find out about the files in neo4j repo ; install neo4j community edition

run wget -O - http://debian.neo4j.org/neotechnology.gpg.key | apt-key add - && \
    echo 'deb http://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list && \
    apt-get update ; apt-get install neo4j -y ; apt-get install bsdmainutils -y

## add launcher and set execute property
## clean sources
# "allow_store_upgrade" Used to allow upgrade from eg. 1.9 to 2.x
# "remote_shell_host" enable shell server on all network interfaces

add launch.sh /
add build_auth_string.sh /
run chmod +x /launch.sh && chmod +x /build_auth_string.sh && \
    apt-get clean && \
    sed -i "s|#allow_store_upgrade|allow_store_upgrade|g" /var/lib/neo4j/conf/neo4j.properties && \
    echo "execution_guard_enabled=true" >> /var/lib/neo4j/conf/neo4j.properties && \
    echo "remote_shell_host=0.0.0.0" >> /var/lib/neo4j/conf/neo4j.properties && \
    echo "org.neo4j.server.webserver.limit.executiontime=120000" >> /var/lib/neo4j/conf/neo4j-server.properties && \
    echo "wrapper.java.additional.3=-Dfile.encoding=UTF-8" >> /var/lib/neo4j/conf/neo4j-wrapper.conf && \
    echo "wrapper.java.additional.1=-d64" >> /var/lib/neo4j/conf/neo4j-wrapper.conf && \
    echo "wrapper.java.additional.1=-server" >> /var/lib/neo4j/conf/neo4j-wrapper.conf && \
    echo "wrapper.java.additional.1=-Xss2048k" >> /var/lib/neo4j/conf/neo4j-wrapper.conf && \
    echo "wrapper.java.additional.1=-Xmx3072m" >> /var/lib/neo4j/conf/neo4j-wrapper.conf && \
    echo "wrapper.java.additional.2=-Dcom.sun.management.jmxremote.port=6666" >> /var/lib/neo4j/conf/neo4j-wrapper.conf && \
    echo "wrapper.java.additional.2=-Dcom.sun.management.jmxremote.ssl=false" >> /var/lib/neo4j/conf/neo4j-wrapper.conf && \
    echo "wrapper.java.additional.2=-Dcom.sun.management.jmxremote.authenticate=false" >> /var/lib/neo4j/conf/neo4j-wrapper.conf
    
# expose REST and shell server ports
expose 7474
expose 1337

workdir /

## entrypoint
cmd ["/bin/bash", "-c", "/launch.sh"]
