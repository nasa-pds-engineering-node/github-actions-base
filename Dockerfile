# 🌄 PDS Engineering: GitHub Actions Base
# =======================================

FROM python:3.8.5-alpine3.12


# Support
# -------

ENV GITHUB_CHANGELOG_COMMIT 322e30a78115ab948e358cd916a9f78e55fe21c1


# Metadata
# --------

LABEL "repository"="https://github.com/NASA-PDS/github-actions-base.git"
LABEL "homepage"="https://pds-engineering.jpl.nasa.gov/"
LABEL "maintainer"="Sean Kelly <kelly@seankelly.biz>"


# Image Details
# -------------
#
# Watch out for that ``pds-github-util``: its dependencies are *huge* 😮
# And they take forver to build 😫

RUN : \
    apk update &&\
    apk add --virtual .build gcc musl-dev openssl-dev libxml2-dev libxslt-dev libffi-dev ruby-dev make &&\
    apk add libxml2 libxslt git ruby &&\
    pip install --upgrade pip setuptools wheel sphinx &&\
    cd /usr/src &&\
    git clone https://github.com/github-changelog-generator/github-changelog-generator.git &&\
    cd github-changelog-generator &&\
    git checkout ${GITHUB_CHANGELOG_COMMIT} &&\
    gem build github_changelog_generator.gemspec &&\
    gem install github_changelog_generator-1.15.2.gem  --source http://rubygems.org &&\
    pip install pds-github-util &&\
    apk del .build &&\
    rm -rf /var/cache/apk/* &&\
    : /
