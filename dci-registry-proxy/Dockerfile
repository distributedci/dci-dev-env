FROM registry.access.redhat.com/ubi9/ubi-minimal

RUN microdnf -y upgrade && \
    microdnf -y install python3 squid gettext openssl && \
    microdnf -y clean all && \
    mkdir -pv /opt/bin && \
    mkdir -pv /var/lib/squid && \
    /usr/lib64/squid/security_file_certgen -c -s /var/lib/squid/ssl_db -M 4MB && \
    chown -Rv squid:squid /var/lib/squid

COPY squid.conf /etc/squid/
COPY secrets.conf.template /etc/squid/
COPY acl-helper.py /opt/bin/
COPY entrypoint.sh /opt/bin/

RUN chmod +x /opt/bin/* && \
    chown squid:squid /opt/bin/*

ENTRYPOINT ["/opt/bin/entrypoint.sh"]

CMD ["squid", "-NYd", "1"]
