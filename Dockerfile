# 🌄 PDS Engineering: GitHub Actions Base
# =======================================

FROM python:3.9.7-alpine3.14


# Support
# -------
#
# Commit-Specific Pins
# ~~~~~~~~~~~~~~~~~~~~

ENV github_changelog_commit 322e30a78115ab948e358cd916a9f78e55fe21c1


# Python Package Pins
# ~~~~~~~~~~~~~~~~~~~

ENV github3_py       1.3.0
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
    apk add --no-progress bash git-lfs gcc g++ musl-dev libxml2 libxslt git ruby ruby-etc ruby-json ruby-multi_json ruby-io-console ruby-bigdecimal openssh-client maven openjdk8 gnupg libgit2-dev &&\
    pip install --upgrade \
        pip setuptools wheel \
        pds-github-util \
        github3.py==${github3_py} \
        requests==${requests} \
        sphinx-argparse==${sphinx_argparse} \
        sphinx-rtd-theme==${sphinx_rtd_theme} \
        sphinx==${sphinx} \
        twine==${twine} \
        &&\
    cd /usr/src &&\
    git clone https://github.com/github-changelog-generator/github-changelog-generator.git &&\
    cd github-changelog-generator &&\
    git checkout ${github_changelog_commit} &&\
    gem build github_changelog_generator.gemspec &&\
    gem install github_changelog_generator-1.15.2.gem --source https://rubygems.org &&\
    wget -qP /usr/local/bin https://github.com/X1011/git-directory-deploy/raw/master/deploy.sh &&\
    chmod +x /usr/local/bin/deploy.sh &&\
    cd .. &&\
    rm -r github-changelog-generator &&\
    apk del /build &&\
    rm -rf /var/cache/apk/* &&\
    : /
