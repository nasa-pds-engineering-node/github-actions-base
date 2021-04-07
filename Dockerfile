# 🌄 PDS Engineering: GitHub Actions Base
# =======================================

FROM python:3.8.5-alpine3.12


# Support
# -------
#
# Commit-Specific Pins
# ~~~~~~~~~~~~~~~~~~~~

ENV github_changelog_commit 322e30a78115ab948e358cd916a9f78e55fe21c1


# Python Package Pins
# ~~~~~~~~~~~~~~~~~~~

ENV github3_py       1.3.0
ENV pds_github_util  0.16.8
ENV requests         2.23.0
ENV sphinx           3.2.1
ENV sphinx_argparse  0.2.5
ENV sphinx_rtd_theme 0.5.0
ENV twine            3.2.0


# Metadata
# ~~~~~~~~

LABEL "repository"="https://github.com/NASA-PDS/github-actions-base.git"
LABEL "homepage"="https://pds-engineering.jpl.nasa.gov/"
LABEL "maintainer"="Sean Kelly <kelly@seankelly.biz>"


# Image Details
# -------------
#
# Watch out for that ``pds-github-util``: its dependencies are *huge* 😮
# And they take forver to build 😫

COPY m2-repository.tar.bz2 /tmp
RUN : &&\
    mkdir /root/.m2 &&\
    tar x -C /root/.m2 -j -f /tmp/m2-repository.tar.bz2 &&\
    rm /tmp/m2-repository.tar.bz2 &&\
    apk update &&\
    apk add --no-progress --virtual /build openssl-dev libxml2-dev libxslt-dev libffi-dev ruby-dev make python3-dev cargo &&\
    apk add --no-progress git-lfs gcc g++ musl-dev libxml2 libxslt git ruby ruby-etc ruby-json ruby-multi_json ruby-io-console ruby-bigdecimal openssh-client maven openjdk11 gnupg &&\
    pip install --upgrade \
        pip setuptools wheel \
        github3.py==${github3_py} \
        pds-github-util==${pds_github_util} \
        requests==${requests} \
        sphinx-argparse==${sphinx_argparse} \
        sphinx-rtd-theme==${sphinx_rtd_theme} \
        sphinx==${sphinx} \
        twine==${twine} \
        &&\
    gem install github_changelog_generator --version 1.15.2 &&\
    apk del /build &&\
    rm -rf /var/cache/apk/* &&\
    : /
