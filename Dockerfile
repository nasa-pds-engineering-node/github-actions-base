# 🌄 PDS Engineering: GitHub Actions Base
# =======================================

FROM python:3.9.16-alpine3.16


# Support
# -------
#
# Python Package Pins
# ~~~~~~~~~~~~~~~~~~~

ENV github3_py       1.3.0
ENV lxml             4.6.3
ENV numpy            1.21.2
ENV pandas           1.3.4
ENV requests         2.23.0
ENV sphinx           3.2.1
ENV sphinx_argparse  0.2.5
ENV sphinx_rtd_theme 0.5.0
ENV twine            3.4.2


# Metadata
# ~~~~~~~~

LABEL "repository"="https://github.com/NASA-PDS/github-actions-base.git"
LABEL "homepage"="https://pds-engineering.jpl.nasa.gov/"
LABEL "maintainer"="Sean Kelly <kelly@seankelly.biz>"


# Image Details
# -------------
#
# Note we include some bigger Python packages used by other PDS projects.

COPY m2-repository.tar.bz2 /tmp
RUN : &&\
    mkdir /root/.m2 &&\
    tar x -C /root/.m2 -j -f /tmp/m2-repository.tar.bz2 &&\
    rm /tmp/m2-repository.tar.bz2 &&\
    apk update &&\
    apk add --no-progress --virtual /build ruby-dev make cargo &&\
    apk add --no-progress bash git-lfs gcc g++ musl-dev libxml2 libxslt git ruby ruby-etc ruby-json ruby-multi_json ruby-io-console ruby-bigdecimal openssh-client maven openjdk8 gnupg libgit2-dev libffi-dev libxml2-dev libxslt-dev python3-dev openssl-dev &&\
    pip install --upgrade \
        pip setuptools wheel build \
        github3.py==${github3_py} \
        lxml==${lxml} \
        numpy==${numpy} \
        pandas==${pandas} \
        requests==${requests} \
        sphinx==${sphinx} \
        sphinx-argparse==${sphinx_argparse} \
        sphinx-rtd-theme==${sphinx_rtd_theme} \
        twine==${twine} \
        &&\
    gem install github_changelog_generator --version 1.16.4 &&\
    wget -qP /usr/local/bin https://github.com/X1011/git-directory-deploy/raw/master/deploy.sh &&\
    chmod +x /usr/local/bin/deploy.sh &&\
    apk del /build &&\
    rm -rf /var/cache/apk/* &&\
    : /
