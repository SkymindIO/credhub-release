#!/bin/bash
set -e

if [ -z $1  ]
then
    echo "need to set the version as the first argument"
    echo "ex> ./release skil-1.1.0"
    exit -1
fi

version=$1
echo "start release process for ${version}"


echo "update credhub-skil"
./scripts/update
git submodule update --remote

echo "clean the previous release"
rm -rf dev_releases
rm -rf dist

echo "create release"
bosh create-release --name credhub-skil --version ${version} --tarball ./credhub-${version}.tgz

echo "extract tar ball"
mkdir dist
mv credhub-${version}.tgz dist
cd dist/
tar -xzf credhub-${version}.tgz 

echo "rename tarball and create its checksum"
dest="needToUpload"
mkdir ${dest}
cd ${dest}
mv ../packages/credhub.tgz credhub-${version}.tgz
md5sum credhub-${version}.tgz > credhub-${version}.sum

echo "done! upload tarball and checksum files under dist/${dest}"