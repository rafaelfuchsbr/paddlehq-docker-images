#!/bin/bash

echo "========================================================="
echo "Building image from folder [${FOLDER}]\n"
echo ""

while IFS='=' read -r key value
do
  eval ${key}=\${value}
done < "${MANIFEST_FILE}"

echo "${MANIFEST_FILE} file:"
echo " - image_name   = ${image_name}"
echo " - platforms    = ${platforms:-(using default)}"
echo " - registry     = ${registry:-(using default)}"
echo " - tags         = ${tags:-(using default)}"
echo " - version      = ${version}"
echo ""

all_tags=""
if ([ ${GIT_BRANCH} == "master" ] || [ ${GIT_BRANCH} == "main" ])
then
    # if main branch, tag with commit, version and latest
    all_tags="${DEFAULT_TAGS},${version},latest,${tags}"  
else
    # if NOT main branch, tag with commit and `version-commit` (1.2.3-a1b2c3d)
    all_tags="${DEFAULT_TAGS},${version}-${GIT_SHORT_COMMIT},${tags}"
fi

registry="${registry:-${DEFAULT_REGISTRY}}"
image_full_name="${registry}/${image_name}"
platforms="${platforms:-${DEFAULT_PLATFORMS}}"

eval "${ROOT_FOLDER}/scripts/docker_login.sh ${registry}"

echo "Checking if image exists [${image_full_name}:${version}]"
image_exists_version=$(docker manifest inspect ${image_full_name}:${version} > /dev/null ; echo $?)
echo ""

echo "Checking if image exists [${image_full_name}:${GIT_SHORT_COMMIT}]"
image_exists_commit=$(docker manifest inspect ${image_full_name}:${GIT_SHORT_COMMIT} > /dev/null ; echo $?)
echo ""

if [[ ${image_exists_version} -eq 0 ]]
then
    echo "Image with version [${version}] already exists - skipping build." 
elif [[ ${image_exists_commit} -gt 0 ]]
    echo "Image with commit [${GIT_SHORT_COMMIT}] already exists - skipping build."
then
    IFS=',' read -r -a all_tags <<< ${all_tags}
    tags_option=""

    echo "Tags that will be added:"
    for tag in ${all_tags[@]}
    do
        tags_option="${tags_option} --tag ${image_full_name}:${tag}"
        echo " - ${tag}"
    done
    echo ""

    echo "Building image [${image_name}:${GIT_SHORT_COMMIT}] for platforms [${platforms}]"
    docker_build_cmd="""docker buildx build \
        --platform "${platforms}" \
        --push \
        ${tags_option} \
        ."""
    eval ${docker_build_cmd}
fi
echo ""
echo "Finished processing folder [${FOLDER}]."
echo "---------------------------------------------------------"
echo ""
cd ${ROOT_FOLDER}
