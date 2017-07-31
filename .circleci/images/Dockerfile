# OpenSCAP Docker Scanning Container
FROM centos/systemd

RUN yum install -y \
	openssl \
	openscap \
	openscap-utils \
	openscap-engine-sce \
    openscap-scanner\
    scap-security-guide \
	wget \
	which

VOLUME /var/run/docker.sock:/var/run/docker.sock

ENTRYPOINT ["/bin/bash"]
CMD ["help"]