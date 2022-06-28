# Parent image
FROM redhat/ubi8:8.6

LABEL description="SenNet API Docker Base Image"

# When trying to run "yum updates" or "yum install" the "system is not registered with an entitlement server" error message is given
# To fix this issue:
RUN echo $'[main]\n\
enabled=0\n\\n\
# When following option is set to 1, then all repositories defined outside redhat.repo will be disabled\n\
# every time subscription-manager plugin is triggered by dnf or yum\n\
disable_system_repos=0\n'\
>> /etc/yum/pluginconf.d/subscription-manager.conf

# Reduce the number of layers in image by minimizing the number of separate RUN commands
# 1 - Install GCC, Git, Python 3.9, libraries needed for Python development, and pcre needed by uwsgi
# 2 - Set default Python version for `python` command, `python3` already points to the newly installed Python3.9
# 3 - Upgrade pip, after upgrading, both pip and pip3 are the same version
# 4 - Pip install wheel and uwsgi packages. Pip uses wheel to install uwsgi
# 5 - Clean all yum cache
RUN yum install -y gcc git python39 python39-devel pcre pcre-devel && \
    alternatives --set python /usr/bin/python3.9 && \
    pip3 install --upgrade pip && \
    pip install wheel uwsgi && \
    yum clean all 

# Install gosu for de-elevating root to hubmap user
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.14/gosu-amd64" && \
    curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.14/gosu-amd64.asc" && \
    rm -r /usr/local/bin/gosu.asc && \
    chmod +x /usr/local/bin/gosu
