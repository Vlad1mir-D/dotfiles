
[[ -n "${__BASHRC_SOURCED:-}" ]] && return
__BASHRC_SOURCED=1

if [[ $- == *i* && -z "${__BASH_PROFILE_SOURCED:-}" && -e ~/.bash_profile ]]; then
  __BASHRC_LOADING_PROFILE=1
  . ~/.bash_profile
  unset __BASHRC_LOADING_PROFILE
fi

#BASH_PREEXEC_SRC="/opt/homebrew/etc/profile.d/bash-preexec.sh"
BASH_PREEXEC_SRC="$HOME/soft/bash-preexec/bash-preexec.sh"
[ -f "${BASH_PREEXEC_SRC}" ] && . "${BASH_PREEXEC_SRC}"

# https://github.com/akinomyoga/ble.sh#13-set-up-bashrc
# Add this lines at the top of .bashrc:
#[[ $- == *i* ]] && source -- ~/.local/share/blesh/ble.sh --attach=none

[[ -e ~/.bashrc.local ]] && . ~/.bashrc.local

#[[ -t 0 ]] && eval "$(atuin pty-proxy init bash)" 2>/dev/null || :
[[ -t 0 ]] && eval "$(atuin init bash)" 2>/dev/null || :

[ -x "$HOMEBREW_PREFIX/share/forgit/forgit.plugin.sh" ] && source "$HOMEBREW_PREFIX/share/forgit/forgit.plugin.sh"

#000_bash_completion_compat.bash
#aria2c
#brew
#buf
#fd
#gapplication
#gdbus
#gio
#git-prompt.sh
#gresource
#gsettings
#helm
#httpie
#jf
#mas
#npm
#pipx
#rg
#timoni
#uv
#uvx
homebrew_bash_completions=$(cat - <<EOF
atuin
aws_bash_completer
git-completion.bash
git-forgit
git-lfs
kubectl
kubectx
kubens
npc
orbctl
procs
tig-completion.bash
yq
EOF
)

for homebrew_bash_completion in $homebrew_bash_completions; do
	homebrew_bash_completion_fullpath="${HOMEBREW_PREFIX}/etc/bash_completion.d/${homebrew_bash_completion}" && [ -f "${homebrew_bash_completion_fullpath}" ] && source "${homebrew_bash_completion_fullpath}" 2>/dev/null
done

complete -o default -F __start_kubectl kk

np()
{
	args=$@
	[[ -z "$1" ]] && args=$(npc profile list | sort -k2 -rs | fzf --header-lines=1 --accept-nth=1 --cycle --highlight-line)
	[[ -n "$args" ]] && npc profile activate $args || echo "No profile selected!" >&2
}
_np_completion()
{
	local curr_arg;
	curr_arg=${COMP_WORDS[COMP_CWORD]}
	COMPREPLY=( $(compgen -W "$(npc profile list | awk '{print $1}')" -- $curr_arg ) );
}
complete -F _np_completion np

for npc_alias in npc{l,t,p,td,pd}; do
	complete -o default -F __start_npc "$npc_alias"
	unset npc_alias
done

# Add this line at the end of .bashrc:
#[[ ! ${BLE_VERSION-} ]] || ble-attach
