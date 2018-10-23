#!/bin/sh
set -e

uid=$(stat -c %u /srv)
gid=$(stat -c %g /srv)
user_name="docker"
group_name="docker"

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- docker "$@"
fi

# if our command is a valid Docker subcommand, let's invoke it through Docker instead
# (this allows for "docker run docker ps", etc)
if docker help "$1" > /dev/null 2>&1; then
	set -- docker "$@"
fi

# if we have "--link some-docker:docker" and not DOCKER_HOST, let's set DOCKER_HOST automatically
if [ -z "$DOCKER_HOST" -a "$DOCKER_PORT_2375_TCP" ]; then
	export DOCKER_HOST='tcp://docker:2375'
fi

if [ "$1" = 'dockerd' ]; then
	cat >&2 <<-'EOW'

		📎 Hey there!  It looks like you're trying to run a Docker daemon.

		   You probably should use the "dind" image variant instead, something like:

		     docker run --privileged --name some-overlay-docker -d docker:stable-dind --storage-driver=overlay

		   See https://hub.docker.com/_/docker/ for more documentation and usage examples.

	EOW
	sleep 3
fi

if [ $uid = 0 ] && [ $gid = 0 ]; then
    exec "$@"
else
	sed -i -r "s/$user_name:x:[[:digit:]]+:[[:digit:]]+:/$user_name:x:$uid:$gid:/g" /etc/passwd
	sed -i -r "s/$group_name:x:[[:digit:]]+:/$group_name:x:$gid:/g" /etc/group

	user=$(grep ":x:$uid:" /etc/passwd | cut -d: -f1)
	chown -Rf $uid:$gid /home

	su-exec $user "$@"
fi
