# Marks that the common login environment is already loaded in this shell.
__BASH_PROFILE_SOURCED=1

# Common

# https://github.com/orgs/Homebrew/discussions/6798#discussioncomment-16604536
#export DYLD_LIBRARY_PATH="/opt/homebrew/opt/expat/lib"

# https://github.com/orgs/Homebrew/discussions/6309#discussioncomment-13898085
export LC_COLLATE=C

# https://github.com/heliomass/ConsoleDoNotTrack/tree/900e0164b7693175e0de634d7f2ec8aac3d1549c
export DO_NOT_TRACK=1

# Individual DNT variables for various services
export GATSBY_TELEMETRY_DISABLED=1; # Gatsby
export HOMEBREW_NO_ANALYTICS=1; # Homebrew
export STNOUPGRADE=1; # Syncthing
export DOTNET_CLI_TELEMETRY_OPTOUT=1; # .NET Core
export SAM_CLI_TELEMETRY=0; # AWS Serverless Application Model CLI
export AZURE_CORE_COLLECT_TELEMETRY=0; # Microsoft Azure CLI

export DISABLE_TELEMETRY=1 # https://code.claude.com/docs/en/env-vars.md

export HOMEBREW_NO_ANALYTICS=1
eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || :

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

export PATH="$HOME/bin:$PATH"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.bash 2>/dev/null || :

## tfenv
#export PATH="$HOME/.tfenv/bin:$PATH"

# https://terragrunt.gruntwork.io/docs/features/provider-cache-server/
export TG_PROVIDER_CACHE=1

# see the ~/soft/terragrunt-provider-cache-multiregistry-artifactory.md for details
export TG_PROVIDER_CACHE_REGISTRY_NAMES="registry.terraform.io,registry.opentofu.org"

# https://docs.terragrunt.com/reference/cli/commands/run/#tf-path
export TG_TF_PATH=terraform

# https://docs.terragrunt.com/reference/hcl/attributes/#download_dir
#export TG_DOWNLOAD_DIR="$HOME/.cache/.terragrunt-cache" #TODO: make our modules compatible

# /Common


# Nebius

# common
# The next line updates PATH for Nebius Private CLI.
if [ -f "$HOME/.config/newbius/path.bash.inc" ]; then source "$HOME/.config/newbius/path.bash.inc"; fi

# ik8s
# https://docs.nebius.dev/en/infrak8s/ik8s-platform/platform-binary#how-to-run
export IK8S_ENVS_PATH="$HOME/ik8s-envs"

# https://gitlab.nebius.dev/nebius/nebo/-/blob/d2f54c59b94feeb43ed9505f604effa59ff8d58a/nobi/serverinfra/setup-templates/Makefile#L28
export ENVS_DIR="$HOME/ik8s-envs"

# mk8s
# https://docs.nebius.dev/en/mk8s/how-to/develop/getting-started
export NEBO="$HOME/nebo"

# for executables inside Nebo root
export PATH="$HOME/nebo:$PATH"

# https://docs.nebius.dev/en/mk8s/tools/k9s#k9s-main-config
export K9S_CONFIG_DIR="$HOME/.config/k9s"
export K9S_LOGS_DIR="$HOME/.config/k9s"

# https://docs.nebius.dev/en/mk8s/tools/k9s#kubectl-tree
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

#export PATH="$HOME/nebo/k8s/bin/tools/darwin-arm64:$PATH"

alias sshi="ssh -o IdentitiesOnly=yes -i ~/.ssh/id_ed25519"
alias awsnn="aws --profile=aws_noc_nebius"
alias kk=kubectl

# https://docs.nebius.dev/en/mk8s/tools/shell-aliases
alias npcl="NPC_OVERRIDE_RESOLVERS='nebius.mk8s.*=localhost:30080' npc --profile testing --skip-tls-verification"
alias npct="npc --profile testing"
alias npcp="npc --profile prod"
alias npctd="npc --profile testing-duty"
alias npcpd="npc --profile prod-duty"

# /Nebius

[[ $- == *i* && -z "${__BASHRC_LOADING_PROFILE:-}" && -e ~/.bashrc ]] && . ~/.bashrc
