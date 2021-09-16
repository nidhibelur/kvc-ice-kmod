FROM quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:bb5c296b4a6125f475906f457cdf2ffd35d3d70d

WORKDIR /build/

RUN yum -y install git make sudo gcc wget \
&& yum clean all \
&& rm -rf /var/cache/dnf

# Expecting kmod software version as an input to the build
ARG KMODVER=1.6.4

RUN wget "https://sourceforge.net/projects/e1000/files/ice%20stable/$KMODVER/ice-$KMODVER.tar.gz"
RUN tar zxf ice-$KMODVER.tar.gz
WORKDIR /build/ice-$KMODVER/src

# Prep and build the module
RUN KVER=$(rpm -q --qf "%{VERSION}-%{RELEASE}.%{ARCH}"  kernel-rt-core) \
&& BUILD_KERNEL=${KVER} KSRC=/lib/modules/$KVER/build/ make modules_install

# Add the helper tools
WORKDIR /build
RUN git clone https://github.com/jianzzha/kvc-ice-kmod.git
WORKDIR /build/kvc-ice-kmod
RUN mkdir -p /usr/lib/kvc/ && mkdir -p /etc/kvc/ && make install

RUN systemctl enable kmods-via-containers@ice-kmod

