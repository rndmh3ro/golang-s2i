
# golang-centos7
FROM openshift/base-centos7

# Yes, it's me
MAINTAINER Nicolas Masse <nicolas.masse@itix.fr>

# The Go version you would like to use (defaults to 1.8.1)
ARG GOLANG_VERSION
ENV GOLANG_VERSION ${GOLANG_VERSION:-1.8.1}

LABEL io.k8s.description="Platform for building golang applications. Based on GO ${GOLANG_VERSION}." \
      io.k8s.display-name="golang builder v${GOLANG_VERSION}" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,golang"

# Install go
RUN curl https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz -o /tmp/go.tar.gz && tar -C /usr/local -zxf /tmp/go.tar.gz

# Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# Set the default port for applications built using this image
EXPOSE 8080

# Set the default CMD for the image
CMD ["/usr/libexec/s2i/usage"]
