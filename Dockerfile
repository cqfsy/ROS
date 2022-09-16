FROM ubuntu:18.04
RUN apt update \
    && apt-get install -y ca-certificates \
    && sed -i "s@http://.*archive.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list \
    && sed -i "s@http://.*security.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list \
    && apt-get clean \
    && apt-get update \
    && apt-get install vim curl git cmake gdb -y
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# COPY ros.key / 
RUN apt-get update \
    && apt-get install -y gnupg2 \
    && sh -c '. /etc/lsb-release && echo "deb http://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu/ $DISTRIB_CODENAME main" > /etc/apt/sources.list.d/ros-latest.list' \
    && apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 \
    # && sudo apt-key add /ros.key\
    # && rm -rf /ros.key \
    && apt update \
    && apt install ros-melodic-desktop-full -y\
    && echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc \
    && apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential -y\
    && apt install python-rosdep -y
RUN rosdep init \
    && rosdep update
RUN echo 'root:123456' |chpasswd \
    && apt update && apt install -y openssh-server \
	&& apt clean \
	&& rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp* \
	&& echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && echo "UsePAM no" >> /etc/ssh/sshd_config \
    && mkdir /var/run/sshd

EXPOSE 22
ENTRYPOINT ["/usr/sbin/sshd","-D"]
