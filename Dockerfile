FROM kmubigdata/ubuntu-hadoop:standalone

RUN wget http://apache.claz.org/hive/stable-2/apache-hive-2.3.3-bin.tar.gz
RUN tar -xvzf apache-hive-2.3.3-bin.tar.gz -C /usr/local/
RUN cd /usr/local && ln -s ./apache-hive-2.3.3-bin hive
RUN rm apache-hive-2.3.3-bin.tar.gz

#install mysql
RUN debconf-set-selections <<< 'mysql-server mysql-server/root_password password hive'
RUN debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password hive'
RUN apt-get -y install mysql-server
RUN wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.11.tar.gz
RUN tar -xvzf mysql-connector-java-8.0.11.tar.gz
RUN mv /mysql-connector-java-8.0.11/mysql-connector-java-8.0.11.jar /usr/local/hive/lib/
RUN rm -r /mysql-connector-java-8.0.11
RUN rm mysql-connector-java-8.0.11.tar.gz

ENV HIVE_HOME /usr/local/hive
ENV PATH $HIVE_HOME/bin:$PATH

EXPOSE 10000

