#!/bin/bash

current_path=`pwd`
case "`uname`" in
    Linux)
		bin_abs_path=$(readlink -f $(dirname $0))
		;;
	*)
		bin_abs_path=`cd $(dirname $0); pwd`
		;;
esac
base=${bin_abs_path}/..
otter_conf=$base/conf/otter.properties
logback_configurationFile=$base/conf/logback.xml

export LANG=en_US.UTF-8
export BASE=$base

if [ ! -d $base/logs ] ; then 
	mkdir -p $base/logs
fi

## set java path
if [ -z "$JAVA" ] ; then
  JAVA=$(which java)
fi

if [ -z "$JAVA" ]; then
        echo "Cannot find a Java JDK. Please set either set JAVA or put java (>=1.5) in your PATH." 2>&2
    	exit 1
fi


case "$#" 
in
0 ) 
	;;
1 )	
	var=$*
	if [ -f $var ] ; then 
		otter_conf=$var
	else
		echo "THE PARAMETER IS NOT CORRECT.PLEASE CHECK AGAIN."
        exit
	fi;;
2 )	
	var=$1
	if [ -f $var ] ; then
		otter_conf=$var
	else 
		if [ "$1" = "debug" ]; then
			DEBUG_PORT=$2
			DEBUG_SUSPEND="n"
			JAVA_DEBUG_OPT="-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=$DEBUG_PORT,server=y,suspend=$DEBUG_SUSPEND"
		fi
     fi;;
* )
	echo "THE PARAMETERS MUST BE TWO OR LESS.PLEASE CHECK AGAIN."
	exit;;
esac



if [ -z "$JAVA_OPTS" ]; then
	JAVA_OPTS="-server -Xms2048m -Xmx3072m -Xmn1024m -XX:SurvivorRatio=2 -XX:PermSize=96m -XX:MaxPermSize=256m -Xss256k -XX:-UseAdaptiveSizePolicy -XX:MaxTenuringThreshold=15 -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSCompactAtFullCollection -XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly -XX:+HeapDumpOnOutOfMemoryError"
fi

JAVA_OPTS=" $JAVA_OPTS -Djava.awt.headless=true -Djava.net.preferIPv4Stack=true -Dfile.encoding=UTF-8"
OTTER_OPTS="-DappName=otter-manager -Ddubbo.application.logger=slf4j -Dlogback.configurationFile=$logback_configurationFile -Dotter.conf=$otter_conf"

if [ -n OTTER_DOMAINNAME ];then
	sed -i "s/otter.domainName = 127.0.0.1/otter.domainName = $OTTER_DOMAINNAME/g" conf/otter.properties
fi

if [ -n OTTER_ZOOKEEPER_CLUSTER ];then
	sed -i "s/otter.zookeeper.cluster.default = 127.0.0.1:2181/otter.zookeeper.cluster.default = $OTTER_ZOOKEEPER_CLUSTER/g" conf/otter.properties
fi

if [ -n OTTER_DATABASE_URL ];then
	sed -i "s#127.0.0.1:3306/otter#$OTTER_DATABASE_URL#g" conf/otter.properties
fi
if [ -n OTTER_DATABASE_USERNAME ];then
	sed -i "s/otter.database.driver.username = root/otter.database.driver.username = $OTTER_DATABASE_USERNAME/g" conf/otter.properties
fi
if [ -n OTTER_DATABASE_PASSWORD ];then
	sed -i "s/otter.database.driver.password = hello/otter.database.driver.password = $OTTER_DATABASE_PASSWORD/g" conf/otter.properties
fi

if [ -e $otter_conf -a -e $logback_configurationFile ]
then 
	
	for i in $base/lib/*;
		do CLASSPATH=$i:"$CLASSPATH";
	done
 	CLASSPATH="$base:$base/conf:$CLASSPATH";
 	
 	echo "cd to $bin_abs_path for workaround relative path"
  	cd $bin_abs_path
 	
	echo LOG CONFIGURATION : $logback_configurationFile
	echo otter conf : $otter_conf 
	ln -sf /dev/stdout /opt/logs/manager.log
	$JAVA $JAVA_OPTS $JAVA_DEBUG_OPT $OTTER_OPTS -classpath .:$CLASSPATH com.alibaba.otter.manager.deployer.OtterManagerLauncher >>/opt/logs/manager.log 2>&1

else 
	echo "otter conf("$otter_conf") OR log configration file($logback_configurationFile) is not exist,please create then first!"
fi