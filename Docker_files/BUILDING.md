# Building this image

This processes is spilt in to 3 parts:

1. Acquire a bundle

    - Download a prebuilt bundle, for releases. (This is done when master is built)

        - You can use the [release Dockerfile](./Dockerfile.release) to download it into a temporary docker image. You can use the build argument `VERSION` to specify what release to download. IE `--build-arg VERSION=v1.109-Beta` on buildtime. The [Dockerfile](./Dockerfile#L2) defaults to use the tag `base:bundle` for the bundle.

    - Build a bundle.

        - You can use the [build Dockerfile](./Dockerfile.build) to build the bundle into a temporary docker image. The [Dockerfile](./Dockerfile#L2) defaults to use the tag `base:bundle` for the bundle.

2. Build binaries

    - You can use the [binary Dockerfile](./Dockerfile.binaries) to build the binaries with a temporary docker image. The [Dockerfile](./Dockerfile#L4) defaults to use the tag `base:binaries` for the binaries.

3. Build the final image

    - The final image houses the application from the bundle, binaries and the required packages to run Tdarr. It depends on there being a bundle and a binary image on your system.

## Makefile

There is a [Makefile](./Makefile) in this directory to easily build.

### master

The makefile requires the `VERSION` argument to be set when using the master target. The master target also makes sure that the binaries and a bundle is acquired, it will create the image `base:final` on your system.

```bash
make VERSION=v1.109-Beta master
```

### dev

The dev target also makes sure that the binaries and a bundle is acquired, it will create the image `base:final` on your system, unless the `tag` variable is set.

```bash
make tag=new_feature dev
```
