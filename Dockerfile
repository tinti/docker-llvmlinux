FROM pritunl/archlinux:2016-03-05
MAINTAINER Vinicius Tinti <viniciustinti@gmail.com>

COPY install /install
WORKDIR /install

RUN ./build.sh

CMD ["/usr/sbin/sshd", "-D"]
