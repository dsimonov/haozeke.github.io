#!/usr/bin/env bash

if [ ! -f $HOME/save/$TAR ]; then

# With some inputs from https://github.com/pandoc-extras/pandoc-portable

  # Make the folder
  mkdir -p $HOME/save

  # url to pandoc version
  url="https://github.com/jgm/pandoc/releases/download/$VERSION/pandoc-$VERSION-linux-amd64.tar.gz"
  # debug msg
  if [[ "$DEBUG" == "true" ]]; then
    echo "Obtaining binaries from $url"
  fi

  # get url to pandoc binaries
  html=$(curl -L --fail "$url")
  if [[ $? != 0 ]]; then
    echo "Cannot retrieve $url. Check if version $VERSION is valid."
    exit 1
  fi

  # Only get tar.gz
  tarUrlPartial=$(printf '%s' "$html" | grep -o '/jgm/pandoc/releases/download/.*\.tar\.gz')

  if [[ ! -z "$tarUrlPartial" ]]; then
    # variables
    tarUrl="https://github.com$tarUrlPartial"
    TAR="${tarUrl##*/}"
    # download
    curl -L -o $HOME/save/$TAR "$tarUrl"
  fi
fi

tar -xvzf $HOME/save/$TAR -C $HOME/save/

mkdir -p $HOME/.local/

rsync -a $HOME/save/pandoc-$VERSION/ $HOME/.local/

export PATH=$HOME/.local/bin:$PATH
