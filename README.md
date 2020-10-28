# 🌄 PDS Engineering Actions: Base Image


[GitHub Actions](https://github.com/features/actions) let you run workflows for software repositories for such things as continuous integration, code quality, documentation extraction, continuous delivery, and so forth. The [Planetary Data System (PDS)](https://pds.nasa.gov/) uses GitHub actions for these purposes.

Workflows consist of _actions_, each of which can be executed using JavaScript, so-called "composite" actions (essentially shell macros), or as [Docker](https://www.docker.com/) containers. Docker-based actions give you the most flexibility, letting you define your action in whatever programming language you enjoy with access to whatever libraries and APIs are convenient (so long as it's a Linux-based container).

However, Docker-based actions are the slowest in GitHub Actions as GitHub spins up a new Docker machine, builds your image, installs it into a container, runs it, and then tears it all down for _every_ execution of your action. For actions that require a lot of setup (in terms of C libraries, Python dependencies, Java APIs, and so forth), this can make execution painfully slow.

Enter _this_ image. By deriving specific GitHub Actions from _this_ image, we make a "snapshot" of all the dependencies typically needed by GitHub actions in one place.

Of course, this makes a few assumptions:

- PDS GitHub actions will need Python 3.8.5.
- They'll run on Alpine Linux 3.12.
- They'll have access to development tools:
  - GCC
  - MUSL C library
  - OpenSSL
  - `libxml2`, `libxslt`, and `libffi`
  - GnuPG
- But wait there's more
  - Git
  - Ruby (yes, in addition to Python)
  - Java (yes, in addition to Ruby)

And we might expand on this in the future. (Yuck.)


## ℹ️ Using this Base

To use this base image in your own Docker-based action, simply derive from it in your action's `Dockerfile`:

```Dockerfile
FROM nasapds/pds-github-actions-base:latest

# Action-specific stuff here
```


## 🔧 Maintaining this Base

Well the only thing you really have to do is occasionally update the `Dockerfile` with new dependencies and then rebuild and republish the image to the [Docker Hub](https://hub.docker.com/), via:

```console
docker image build --tag pds-github-actions-base:latest .
docker image tag pds-github-actions-base:latest nasapds/pds-github-actions-base:latest
docker login
docker image push nasapds/pds-github-actions-base:latest
```


## ⏰ Future Work


- 🤡 Well, until the PDS makes its own group account on the Docker Hub, this stuff lives in `nasapds`'s account
- 😮 You'd think [GitHub Packages](https://github.com/features/packages) would be an alternative, but [GitHub Actions doesn't support using images from GitHub Packages](https://github.community/t/use-docker-image-from-github-packages-as-container/118709)!
- 💀 There isn't even [anonymous pulls of images from GitHub Packages](https://github.community/t/make-it-possible-to-pull-docker-images-anonymously-from-github-package-registry/16677)!
- 😑 Apparently engineers at GitHub are recommending to [migrate from GitHub Packages to the new GitHub Container Registry](https://docs.github.com/en/packages/getting-started-with-github-container-registry/migrating-to-github-container-registry-for-docker-images). The Container Registry is currently in public β.
- 💽 It's currently ~~213~~ ~~216~~ ~~579~~ 593
 MiB. Let's try and keep it around there 😲 (Thanks, Java.)
