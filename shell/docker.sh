#
# Docker Related
#

alias d="docker"
alias dc="docker-compose"
alias co="docker-compose"

# alias redis-cli="docker run -it --net=host --rm redis redis-cli"
# alias mysql="docker run -it --net=host --rm mysql mysql"

docker_remove_exited () {
  docker rm $(docker ps -f="status=exited" -q)
}
