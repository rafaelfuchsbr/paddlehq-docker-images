# Docker base images

Repository for Docker base images.
Please check specific branches for details about each one of them.

## Current main branches

- `main-base-image-1`
- `main-base-image-2`
- `main-base-image-3`

> Commits to them must be done only through pull requests.

## How things work

### Multi main branch approach

Here we are using the multi main branch approach, which will isolate each base image files in a specific branch. This way, you can build each image individually without having to process anything and also make them dependant on others through job triggers.
When the upstream base image job is successfull the downstream one will be automatically triggered.

### Minimal repository organisation

Each base image's branch will have basically only 3 files, as nothing else is usually needed to build a simple image.

- Dockerfile
- Jenkinsfile
- README.md

Each base image may need additional resource, like configuration files, scripts, etc. 
They can live in the same repository/branch of the base image or in another repository/branch as appropriate.

### Example

`base-image-3` depends on `base-image-1`.
In the `base-image-3` Jenkinsfile, we will have this:

```groovy
dockerBaseImagePipeline([dependencies: "base-image-1"])
```

So when a build of `main-base-image-1` is successfull, it will trigger the `main-base-image-3` job.

Some things changed and now `base-image-3` depends on `base-image-2` as well.
We just need to update the Jenkinsfile like this:

```groovy
dockerBaseImagePipeline([dependencies: "base-image-1, base-image-2"])
```

Now when a build of `main-base-image-1` **OR** `main-base-image-2` is successfull, it will trigger the `main-base-image-3` job.

### Others branches and PR branches

Downstream base image jobs will not be triggered when non-main branches and PR branches are built.

### Defining dependencies

Dependencies are nothing but the name of the job related to the base image.
One example of a full job name is the `base-image-1` job name --> `paddlehq/docker-images/main-base-image-1`. `paddlehq` is the name of the organisation, `docker-images` is the name of the repository and `main-base-image-1` is the main branch for `base-image-1`.
When specifying dependencies, you can omit the part of the job name that will be common to all of them --> `paddlehq/docker-images/main`.

#### Examples of valid dependencies

The following examples are all valid when specifying dependencies.
`#1`, `#2`, `#3` are the preferred and simpler ways to work with.

1. `base-image-1`
1. `base-image-1,base-image-2`
1. `base-image-1, base-image-2`
1. `main-base-image-1`
1. `paddlehq/docker-images/main-base-image-1, base-image-2`
1. `main-base-image-1, base-image-2`

The pipeline will ajust the dependencies names so they are defined with the full job names under the hoods.

## Links

- [Details of the docker-mimages pipeline](docker-images-pipeline)
- [Jobs related to this POC](docker-images-jenkins)

[docker-images-pipeline]:https://github.com/PaddleHQ/paddle-jenkins-library/blob/master/vars/dockerBaseImagePipeline.groovy
[docker-images-jenkins]:https://development-athena.paddle.dev/job/paddlehq/job/docker-images/