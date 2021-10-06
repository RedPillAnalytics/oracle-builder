# Docker on Google Cloud Build
A template for building docker images in Google Cloud Build.

## Smart substitution

The substitution variables in the `cloudbuild.yaml` file automatically detect the image name from the built-in `$REPO_NAME` substitution variable.
We detect two different forms of the image name... the long and short forms.
I'm using the short form in this sample, because I want my image name to be `cloudbuild` instead `docker-cloudbuild`.
These are simple bash-style substitution patterns, so modify as you see fit.

For this `cloudbuild.yaml` file to work correctly, we have to use three separate triggers. This is not my fault... this is because of a major gap in the product. We have to have three separate triggers in any case if we want to build branches, PRs and tags.


Additionally... the substitution variables will use some simple logic to determine what the image tag should be:

* If Cloud Build is building a GitHub pull request (PR), then the head branch of that PR is used as the image tag, such as `develop` or `feature-101`.
Slashes in branch names are replaced with dashes, so `feature/101` becomes `feature-101`.
* If Cloud Build is building a git tag, then we simply use the git tag as the image tag.
* In any other situations, we use the `latest` tag. This may sound dangerous, but in my branch-based Cloud Build trigger, the branch regex is only matching `master`.

## Testing
I'm simply grabbing the just-published image and running a bash-style test against it.
Obviously this isn't ideal because, well, I've already published it.
But keep in mind, these tests are mainly for PRs, where the image tag is simply the head branch from the PR, so it's not terrible.
The overall solution is probably publishing tags to a Container Registry in another project until the final `latest` or `tag`.

## Kaniko
I use [Kaniko](https://github.com/GoogleContainerTools/kaniko) to build images in Cloud Build, mostly because the `--single-snapshot` options removes all the intermediate layers that would be included if building with a docker daemon.
So there's no reason to chain all those build commands together in our `Dockerfile` in the hopes of reducing image size.
It's not required with Kaniko, so we can write the `Dockerfile` for readability again.

It's worth noting that Kaniko does not squash all the intermediate layers from the source (`FROM`) container the way that [Buildah](https://buildah.io/) does with the `--squash` option. I need to look into Buildah.
