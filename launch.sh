#!/bin/bash

NEO4J_HOME=/var/lib/neo4j

if [ -n "$NEO4J_AUTH" ]; then
  if [ "$NEO4J_AUTH" == "none" ]; then
      echo 'disabling authentication'
      sed -i "s|dbms.security.auth_enabled=true|dbms.security.auth_enabled=false|g" $NEO4J_HOME/conf/neo4j-server.properties
  else
      echo "will use custom credentials"
      mkdir -p $NEO4J_HOME/data/dbms
      echo -n $NEO4J_AUTH | ./build_auth_string.sh > $NEO4J_HOME/data/dbms/auth
  fi
fi

# NEO4J_HEAP_MEMORY=2G
if [ -n "$NEO4J_HEAP_MEMORY" ]; then
	sed -i -e "s|.*wrapper.java.additional=.*|wrapper.java.additional=-Xmx${NEO4J_HEAP_MEMORY}|g" $NEO4J_HOME/conf/neo4j-wrapper.conf
fi

# NEO4J_CACHE_MEMORY=2G
if [ -n "$NEO4J_CACHE_MEMORY" ]; then
	sed -i -e "s|.*dbms.pagecache.memory=.*|dbms.pagecache.memory=${NEO4J_CACHE_MEMORY}|g" $NEO4J_HOME/conf/neo4j.properties
fi

sed -i "s|#org.neo4j.server.webserver.address=0.0.0.0|org.neo4j.server.webserver.address=$HOSTNAME|g" $NEO4J_HOME/conf/neo4j-server.properties

# doing this conditionally in case there is already a limit higher than what
# we're setting here. neo4j recommends at least 40000.
#
# (http://neo4j.com/docs/1.6.2/configuration-linux-notes.html#_setting_the_number_of_open_files)
limit=`ulimit -n`
if [ "$limit" -lt 65536 ]; then
    ulimit -n 65536;
fi

exec .$NEO4J_HOME/bin/neo4j console

