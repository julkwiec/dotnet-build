#!/bin/bash

abort()
{
    echo "An error occurred. Exiting..." >&2
    exit 1
}
trap 'abort' 0
set -e

###############################################################################



STAGE=$1 # Travis CI job ID

DOCKER_REPO_NAME="julkwiec/test-repository" #"julkwiec/dotnet-mono-powershell-build"
ALL_TAGS=()

build_and_tag() {
    # $1: Dockerfile location
    # $2: context root directory
    # $3..n: tags
    echo "Building image from $1"
    docker build --pull --file $1 --iidfile ./id $2
    IMAGE_ID=$(cat ./id)
    rm ./id
    for TAG in "${@:3}"; do
        FULL_TAG="$DOCKER_REPO_NAME:$TAG"
        echo "Tagging image $IMAGE_ID as $FULL_TAG"
        docker tag "$IMAGE_ID" "$FULL_TAG"
        ALL_TAGS+=("$FULL_TAG")
    done
    echo "Done!"
}

echo "### Running stage $STAGE ###"

if [[ "$TRAVIS_TAG" != "" ]]; then
    echo "Found Git tag: $TRAVIS_TAG"
    if [[ "$TRAVIS_TAG" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        MAJOR=$(echo "$TRAVIS_TAG" | tr '.' '\n' | sed -n 1p)
        MINOR=$(echo "$TRAVIS_TAG" | tr '.' '\n' | sed -n 2p)
        REVISION=$(echo "$TRAVIS_TAG" | tr '.' '\n' | sed -n 3p)
        echo "Building and tagging images"
        
        if [[ $STAGE -eq 1 ]]; then
            build_and_tag ./docker/Dockerfile.jessie-mono-alpha ./docker \
                "jessie-mono-alpha-$MAJOR.$MINOR.$REVISION" \
                "jessie-mono-alpha-$MAJOR.$MINOR" \
                "jessie-mono-alpha-$MAJOR"
        fi

        if [[ $STAGE -eq 2 ]]; then
            build_and_tag ./docker/Dockerfile.jessie-mono-beta ./docker \
                "jessie-mono-beta-$MAJOR.$MINOR.$REVISION" \
                "jessie-mono-beta-$MAJOR.$MINOR" \
                "jessie-mono-beta-$MAJOR"
        fi

        if [[ $STAGE -eq 3 ]]; then
            build_and_tag ./docker/Dockerfile.jessie-mono-stable ./docker \
                "jessie-mono-stable-$MAJOR.$MINOR.$REVISION" \
                "jessie-mono-stable-$MAJOR.$MINOR" \
                "jessie-mono-stable-$MAJOR" \
                "jessie-$MAJOR.$MINOR.$REVISION" \
                "jessie-$MAJOR.$MINOR" \
                "jessie-$MAJOR"
        fi

        if [[ $STAGE -eq 4 ]]; then
            build_and_tag ./docker/Dockerfile.stretch-mono-alpha ./docker \
                "stretch-mono-alpha-$MAJOR.$MINOR.$REVISION" \
                "stretch-mono-alpha-$MAJOR.$MINOR" \
                "stretch-mono-alpha-$MAJOR"
        fi

        if [[ $STAGE -eq 5 ]]; then
            build_and_tag ./docker/Dockerfile.stretch-mono-beta ./docker \
                "stretch-mono-beta-$MAJOR.$MINOR.$REVISION" \
                "stretch-mono-beta-$MAJOR.$MINOR" \
                "stretch-mono-beta-$MAJOR"
        fi

        if [[ $STAGE -eq 6 ]]; then
            build_and_tag ./docker/Dockerfile.stretch-mono-stable ./docker \
                "stretch-mono-stable-$MAJOR.$MINOR.$REVISION" \
                "stretch-mono-stable-$MAJOR.$MINOR" \
                "stretch-mono-stable-$MAJOR" \
                "stretch-$MAJOR.$MINOR.$REVISION" \
                "stretch-$MAJOR.$MINOR" \
                "stretch-$MAJOR" \
                "$MAJOR.$MINOR.$REVISION" \
                "$MAJOR.$MINOR" \
                "$MAJOR"
        fi
    else
        echo "The tag $1 is not a valid version number"
        exit 1
    fi
else
    echo "Building on branch: $TRAVIS_BRANCH"
    echo "Building and tagging images"
    
    if [[ $STAGE -eq 1 ]]; then
        build_and_tag ./docker/Dockerfile.jessie-mono-alpha ./docker \
            "jessie-mono-alpha"
    fi

    if [[ $STAGE -eq 2 ]]; then
        build_and_tag ./docker/Dockerfile.jessie-mono-beta ./docker \
            "jessie-mono-beta"
    fi

    if [[ $STAGE -eq 3 ]]; then
        build_and_tag ./docker/Dockerfile.jessie-mono-stable ./docker \
            "jessie-mono-stable" \
            "jessie"
    fi

    if [[ $STAGE -eq 4 ]]; then
        build_and_tag ./docker/Dockerfile.stretch-mono-alpha ./docker \
            "stretch-mono-alpha"
    fi

    if [[ $STAGE -eq 5 ]]; then
        build_and_tag ./docker/Dockerfile.stretch-mono-beta ./docker \
            "stretch-mono-beta"
    fi

    if [[ $STAGE -eq 6 ]]; then
        build_and_tag ./docker/Dockerfile.stretch-mono-stable ./docker \
            "stretch-mono-stable" \
            "stretch" \
            "latest"
    fi
fi

echo "Pushing images to Docker Hub"
echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin
for TAG in "${ALL_TAGS[@]}"; do
    echo "Pushing $TAG"
    docker push $TAG
done
docker logout

###############################################################################

trap : 0
