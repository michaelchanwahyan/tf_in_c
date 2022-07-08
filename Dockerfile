# Dockerfile for building general development
# environment for Data Science Analytics
FROM ubuntu:20.04
LABEL maintainer "michaelchan_wahyan@yahoo.com.hk"

ENV SHELL=/bin/bash \
    TZ=Asia/Hong_Kong \
    PYTHONIOENCODING=UTF-8 \
    PATH=$PATH:/bin:/sbin:/usr/bin:/usr/lib:/usr/local/bin:/usr/local/lib:/usr/local/sbin:/usr/local/sbin:/usr/sbin

RUN apt-get -y update
RUN apt-get -y install \
        apt-transport-https \
        apt-utils \
        bc \
        cmake \
        curl \
        gcc \
        make \
        net-tools \
        screen \
        vim \
        wget

# prerequisites of Python 3.8
RUN apt-get -y update
RUN apt-get -y install \
        build-essential \
        libbz2-dev \
        libc6-dev \
        libcurl4-openssl-dev \
        libffi-dev \
        libgdbm-dev \
        libncursesw5-dev \
        libreadline-gplv2-dev \
        libsqlite3-dev \
        libssl-dev \
        openssl \
        zlib1g-dev
# build Python 3.8.12
# option --disable-test-modules : Install Options
# option --without-doc-strings  : Performance Options
RUN cd / ;\
    wget https://www.python.org/ftp/python/3.8.12/Python-3.8.12.tgz ;\
    tar -zxvf Python-3.8.12.tgz
RUN cd /Python-3.8.12 ;\
    ./configure --disable-test-modules --without-doc-strings ;\
    make -j8 ;\
    make install

# steps to intall tensorflow to in ubuntu
# cf https://www.simplilearn.com/tutorials/deep-learning-tutorial/how-to-install-tensorflow-on-ubuntu
RUN pip3 install --upgrade pip
RUN pip install --upgrade TensorFlow

# steps to install tensorflow C library
# cf https://github.com/tensorflow/docs/blob/master/site/en/install/lang_c.ipynb
RUN cd / ;\
    wget -q --no-check-certificate https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-linux-x86_64-2.8.0.tar.gz ;\
    tar -C /usr/local -xzf libtensorflow-cpu-linux-x86_64-2.8.0.tar.gz ;\
    ldconfig /usr/local/lib

RUN echo gcc -I/usr/local/include -L/usr/local/lib hello_tf.c -ltensorflow -o hello_tf > /tmp/01_build.sh ;\
    chmod +x /tmp/01_build.sh

RUN echo "#!/bin/bash" > /tmp/02_gen_model.sh ;\
    echo python3 model.py >> /tmp/02_gen_model.sh ;\
    chmod +x /tmp/02_gen_model.sh

RUN echo "#!/bin/bash" > /tmp/03_print_model_struct.sh ;\
    echo saved_model_cli show --dir /tmp/model >> /tmp/03_print_model_struct.sh ;\
    echo saved_model_cli show --dir /tmp/model --tag_set serve >> /tmp/03_print_model_struct.sh ;\
    echo saved_model_cli show --dir /tmp/model --tag_set serve --signature_def serving_default >> /tmp/03_print_model_struct.sh ;\
    chmod +x /tmp/03_print_model_struct.sh

# refer to the blog by AmirulOm, try integrate the TF model to c
# cf https://github.com/AmirulOm/tensorflow_capi_sample

COPY ["hello_tf.c", "/tmp/"]
COPY ["model.py", "/tmp/"]

COPY [".bashrc", ".vimrc", "/root/"]
#EXPOSE 8080 9090 9999

CMD [ "/bin/bash" ]
