#!/bin/bash

while getopts ":e:g:r:v:t:" opt ; do
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
        t)
            token=${OPTARG}
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

commit_sha="aa3578ef78b6114141364ac77e59a8f3df8ad162"
releaseJSON=`printf '{"tag_name": "%s","target_commitish": "%s","name": "%s","body": "Release of version %s","draft": false,"prerelease": false}' ${version} ${commit_sha} ${version} ${version}`
owner="ryreitsma"

echo "Creating release tag ${version} on master"
curl --data "${releaseJSON}" https://api.github.com/repos/${owner}/${repo}/releases?access_token=${token} -i

echo "Version ${version} of ${repo} released to public repository"

echo "Updating local directory with tag"
git pull
