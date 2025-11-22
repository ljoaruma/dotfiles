# vim: set expandtab ts=2 fenc=utf-8 ff=unix filetype=sh :

# Create XDB Base Directory
# ===

mkdir -vp "${XDG_CONFIG_HOME:-${HOME}/.config}"
mkdir -vp "${XDG_CACHE_HOME:-${HOME}/.cache}"
mkdir -vp "${XDG_DATA_HOME:-${HOME}/.local/share}"
mkdir -vp "${XDG_STATE_HOME:-${HOME}/.local/state}"

mkdir -vp ${HOME}/.local/{src,bin,lib,include,sbin,share,opt}

# setup profile source 
# ===

## my .profile to conf directory
readonly MY_DOT_PROFILE_DIRECTORY_="$(cd $(dirname ${BASH_SOURCE:-$0})/.. && pwd -P)"
readonly MY_DOT_PROFILE_="${MY_DOT_PROFILE_DIRECTORY_}/config/profile"
readonly MY_DOT_PROFILE_PLACED="${XDG_CONFIG_HOME:-${HOME}/.config}/profile"
ln -sf "${MY_DOT_PROFILE_}" "${MY_DOT_PROFILE_PLACED}"

## .profile add source .profile function 

### source .profile function

#### my .profile path replace /home/username -> ${HOME}
readonly MY_DOT_PROFILE_PATH="${MY_DOT_PROFILE_PLACED/#${HOME}/\$\{HOME\}}"
#### source function
readonly INSERT_PROFILE_COMMAND_="$(
cat - <<EOL

# source by my profile
if [ -f "${MY_DOT_PROFILE_PATH}" ]; then
  . "${MY_DOT_PROFILE_PATH}"
fi
EOL
)"

### original .profile backup
readonly STORED_CONF_DIRECTORY_="${XDG_DATA_HOME:-${HOME}/.local/share}/.storedconf/profile"
mkdir -vp "${STORED_CONF_DIRECTORY_}"
cp --backup=t -vpL $HOME/.profile "${STORED_CONF_DIRECTORY_}"

### add function
#echo "${INSERT_PROFILE_COMMAND_}"
echo "${INSERT_PROFILE_COMMAND_}" >> $HOME/.profile

