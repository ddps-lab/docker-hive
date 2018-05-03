FROM kmubigdata/ubuntu-hadoop:standalone

RUN wget http://apache.claz.org/hive/stable-2/apache-hive-2.3.3-bin.tar.gz
RUN tar -xvzf apache-hive-2.3.3-bin.tar.gz -C /usr/local/
RUN cd /usr/local && ln -s ./apache-hive-2.3.3-bin hive
RUN rm apache-hive-2.3.3-bin.tar.gz

ENV HIVE_HOME /usr/local/hive
ENV PATH $HIVE_HOME/bin:$PATH

EXPOSE 10000

