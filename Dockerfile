FROM haproxy:1.7
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY run_test.sh /
EXPOSE 2379/tcp
