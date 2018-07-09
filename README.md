# docker-over-ssh

This container allows for a quick and easy control of a remote Docker host. It mounts remote docker.sock using ssh, and forwards any docker client commands to the remote host. In effect, docker client inside this container behaves the same way a docker client would when ran on the remote host.\
Can be very useful to manage remote docker hosts from a CI environment, etc.

## Usage
Use ENV variables for configuration:
 - SSH_KEY - SSH key used to authenticate against remote host. It needs to be properly formatted with breaklines replaced by commas. You can use ```cat my-ssh-key | tr "\n" ","``` to produce a valid string
 - DOCKER_REMOTE_HOST - Remote host to connect to. Accepts `user@host` format.
 - REMOTE_DOCKER_SOCK_PATH - optional, specify location of docker.sock on the remote host

Also, the user you're connecting to needs to be in docker group, otherwise it wont be able to forward remote docker.sock

## Examples

 - Run a single command and exit:\
`docker run -ti -e "SSH_KEY=-----BEGIN RSA PRIVATE KEY-----,xxx,xxx,-----END RSA PRIVATE KEY-----," -e "REMOTE_HOST=user@my-docker-host.com" docker info`
 - Start an interactive shell: \
 `docker run -ti -e "SSH_KEY=-----BEGIN RSA PRIVATE KEY-----,xxx,xxx,-----END RSA PRIVATE KEY-----," -e "REMOTE_HOST=user@my-docker-host.com" bash`\
 `# docker info`\
 `# docker run -ti ubuntu:xenial bash`
 - Docker build is alse supported. Keep in mind the build files need to be available inside the container and the build context will be sent over SSH to the remote host\
 `docker run -ti -e "SSH_KEY=-----BEGIN RSA PRIVATE KEY-----,xxx,xxx,-----END RSA PRIVATE KEY-----," -e "REMOTE_HOST=user@my-docker-host.com" -v "/path/to/buld-files:/build-files" bash`\
 `# cd /build-files` \
 `# docker build .`

 ## Caveats
 Right now, not all ssh failure modes are supported. The container can fail silently in some cases.