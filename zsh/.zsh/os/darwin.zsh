export DOCKER_HOST="unix://${HOME}/.config/colima/default/docker.sock"
export TESTCONTAINERS_HOST_OVERRIDE=127.0.0.1
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
export TESTCONTAINERS_RYUK_DISABLED=true

export JAVA_HOME=$(/usr/libexec/java_home -v 21)
