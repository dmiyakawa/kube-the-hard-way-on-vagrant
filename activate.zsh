#
# This is for zsh 
#

mypath=$(readlink -f $0)
mydirpath=$(dirname $mypath)

if ! $(echo $PATH | grep $mydirpath > /dev/null); then
  PATH=$mydirpath:$PATH
  rehash
fi

if [ -x "$(command -v kubectl)" ]; then
  source <(kubectl completion zsh)
  alias k=kubectl
  complete -F __start_kubectl k
fi
