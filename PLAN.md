# PLAN

- Docker Mono Repo
  - Single-branch approach
    - Put version file right next to the Docker file
    - Docker lookup; every build we have to check if the version tag (defined in the file) exists in the ECR and if not we need to rebuild the image.
    - For the master build we tag the image with latest tag apart from the version
  
  - Make the build process compatible with buildx multi-arch image build.

## Tagging

1. increment current version -> A.B.(C+1)
1. tag image with:
    - commit id
    - new version
    - latest
1. push images

## Checking existing