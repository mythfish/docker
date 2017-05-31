#!/bin/bash


fileName="/opt/atlassian/confluence/bin/bootstrap.jar"

# -----------------------------------------------------------------------------
# 判断文件是否存在
# -----------------------------------------------------------------------------
if [ ! -f "$fileName" ]
then
# -----------------------------------------------------------------------------
# 初始化 CONFLUENCE 的安装
# -----------------------------------------------------------------------------
    expect /home/work/_script/confluence-install.sh \
    && cd /home/work/_src \
    && unzip confluence6.2.0_hack.zip \
    && \cp -r /opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-api-3.2.jar /opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-api-3.2.jar.bak \
    && \cp -r /opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-common-3.2.jar /opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-common-3.2.jar.bak \
    && \cp -r /opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-core-3.2.jar /opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-core-3.2.jar.bak \
    && \cp -r /opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-decoder-api-3.2.jar /opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-decoder-api-3.2.jar.bak \
    && \cp -r /opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-decoder-v2-3.2.jar /opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-decoder-v2-3.2.jar.bak \
    && \cp -r /opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-legacy-3.2.jar /opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-legacy-3.2.jar.bak \
    && \cp -r /home/work/_src/confluence6.2.0/atlassian-extras-3.2.jar /opt/atlassian/confluence/confluence/WEB-INF/lib \
    && \cp -r /home/work/_src/confluence6.2.0/mysql-connector-java-5.1.39-bin.jar /opt/atlassian/confluence/confluence/WEB-INF/lib \
    && service confluence stop \
    && service confluence start
else
# -----------------------------------------------------------------------------
# 如果 CONFLUENCE 用户和用户组不存在则创建
# -----------------------------------------------------------------------------
    user=confluence  
    group=confluence
    egrep "^$group" /etc/group >& /dev/null  
    if [ $? -ne 0 ]  
    then  
        groupadd $group  
    fi 
    egrep "^$user" /etc/passwd >& /dev/null  
    if [ $? -ne 0 ]  
    then  
        useradd -g $group $user  
    fi

# -----------------------------------------------------------------------------
# 停止服务，并重新启动
# -----------------------------------------------------------------------------
    cd /opt/atlassian/confluence/bin/
    ./stop-confluence.sh
    ./start-confluence.sh
fi