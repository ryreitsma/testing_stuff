#!/bin/bash

while getopts ":e:g:r:v:" opt ; do
    case ${opt} in
        e)
            gitemail=${OPTARG}
            ;;
        g)
            gituser=${OPTARG}
            ;;
        r)
            repo=${OPTARG}
            ;;
        v)
            version=${OPTARG}
            ;;
        \?)
            echo "Invalid option: -${OPTARG}"
            exit 1
            ;;
        :)
            echo "Option -${OPTARG} requires an argument"
            exit 1
            ;;
    esac
done

releaseJSON=`printf '{"tag_name": "%s","name": "%s","body": "Release of version %s","draft": false,"prerelease": false}' ${version} ${version} ${version}`
owner="coolblue-development"

echo "Set local git configuration"
git config user.name "${gituser}"
git config user.email "${gitemail}"
git config --global push.default matching

echo "Adding new and modified files, removing deleted files in git repo"
git add -A .
echo "Commiting ${repo} ${version}"
git commit -m "Release of ${repo} version ${version}"
echo "Pushing to public repository"
git push --progress

echo "Creating release tag ${version} on master"
git tag -a ${version} -m "Release of version ${version}"

echo "Push tags to public repository"
git push --tags

echo "Version ${version} of ${repo} released to public repository"
