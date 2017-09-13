OpenSCAP Release 0.1.34 

Make sure you check and replace with latest release:
https://github.com/OpenSCAP/scap-security-guide/releases

# How to Use

## NAME
oscap-docker \- Tool for running oscap within docker container or image

## DESCRIPTION
oscap-docker tool can asses vulnerabilities or security compliance of running Docker
containers or cold Docker images. OpenSCAP tool (oscap) is used underneath. Definition
of vulnerabilities (CVE stream) is downloaded from product vendor.

## Compliance scan of Docker image
Usage: 
```
oscap-docker image IMAGE_NAME OSCAP_ARGUMENT
```

Run any OpenSCAP (oscap) command within chroot of mounted docker image. Learn more
about oscap arguments in oscap(8) man page.

## Compliance scan of Docker container
Usage: 
```
oscap-docker container CONTAINER_NAME OSCAP_ARGUMENT
```

Run any OpenSCAP (oscap) command within chroot of mounted docker container. Result
of this command may differ from scanning just an image due to defined mount points.

## "Vulnerability scan of Docker image"
Usage: 

```
oscap-docker image-cve IMAGE_NAME --results oval-results-file.xml --report report.html
```

Attach docker image, determine OS variant/version, download CVE stream applicable to
the given OS, and finally run vulnerability scan.

## "Vulnerability scap of Docker container"

Usage: 
```
oscap-docker container-cve CONTAINER_NAME --results oval-results-file.xml --report report.html
```

Chroot to running container, determine OS variant/version, download CVE stream applicable
to the given OS and finally run a vulnerability scan.

## REPORTING BUGS
Please report bugs using https://github.com/OpenSCAP/openscap/issues

Source: [OpenSCAP](https://github.com/openscap)
