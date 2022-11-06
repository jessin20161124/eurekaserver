#构建jar包
#FROM  maven:3.3-jdk-8 AS builder

FROM jessinguo/maven_java8_aliyun:0.0.1 as builder

##根据git项目名称填写
ARG BUILD_JAR=target/demo-0.0.1-SNAPSHOT.jar

ENV PROJECT_ROOT=/project
WORKDIR $PROJECT_ROOT

COPY . $PROJECT_ROOT

RUN  mvn clean package -Dmaven.test.skip=true -U \
	 &&  mkdir -pv output/ \
	 &&  cp -v ${BUILD_JAR} output/

RUN java -version

WORKDIR /data/app/

RUN cp -r /project/output/* .

ARG JAR_NAME=demo-0.0.1-SNAPSHOT.jar
ARG LOG_DIR=/data/logs/demo

RUN mkdir -pv ${LOG_DIR}


EXPOSE 8000

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-Xmx1536m", "-Xms1536m", "-XX:-OmitStackTraceInFastThrow", "-XX:+PrintGC","-XX:+PrintGCDateStamps", "-Xloggc:/data/logs/demo/gc-%t.log", "-XX:HeapDumpPath=/data/logs/demo/java.hprof", "-XX:-UseAdaptiveSizePolicy","-XX:+PrintAdaptiveSizePolicy", "-XX:+PrintGCDetails", "-XX:+PrintGCTimeStamps", "-XX:+UseGCLogFileRotation","-XX:MetaspaceSize=128M", "-XX:MaxMetaspaceSize=256m", "-XX:NumberOfGCLogFiles=5", "-XX:GCLogFileSize=128m", "-XX:+HeapDumpOnOutOfMemoryError", "-XX:SurvivorRatio=6", "-XX:NewRatio=1", "-XX:ReservedCodeCacheSize=512m","-XX:InitialCodeCacheSize=512m", "-XX:CMSInitiatingOccupancyFraction=70", "-XX:+UseCMSInitiatingOccupancyOnly","-XX:+UseCMSCompactAtFullCollection", "-XX:CMSFullGCsBeforeCompaction=0", "-XX:+CMSParallelInitialMarkEnabled","-XX:PrintCMSStatistics=1", "-XX:+CMSScavengeBeforeRemark", "-XX:+UseConcMarkSweepGC", "-XX:+PrintGCApplicationStoppedTime","-jar","demo-0.0.1-SNAPSHOT.jar","--spring.profiles.active=prd","--logging.file=/data/logs/demo/bps.log"]
