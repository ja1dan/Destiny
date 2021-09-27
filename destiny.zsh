# Config
export DESTINY_TIMER_COLOR="cyan" # https://wiki.archlinux.org/title/zsh#Colors
export DESTINY_GIT_INFO_COLOR="red" # https://wiki.archlinux.org/title/zsh#Colors
export DESTINY_USERNAME_COLOR="172" #https://wiki.archlinux.org/title/zsh#Colors
export DESTINY_HOSTNAME_COLOR="214" #https://wiki.archlinux.org/title/zsh#Colors
export DESTINY_DIR_COLOR="208" # https://wiki.archlinux.org/title/zsh#Colors
export DESTINY_LEVEL_COLOR="202" # https://wiki.archlinux.org/title/zsh#Colors
export DESTINY_SEPARATOR_COLOR="203" # https://wiki.archlinux.org/title/zsh#Colors
export DESTINY_ARROW_COLOR="094" # https://wiki.archlinux.org/title/zsh#Colors
export DESTINY_ERROR_CODE_COLOR="124" # https://wiki.archlinux.org/title/zsh#Colors
export DESTINY_SHOW_USERNAME_IN_SSH="false" # true || false

# Get git info
autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst
add-zsh-hook precmd vcs_info

# Uses code from https://github.com/popstas/zsh-command-time/blob/master/command-time.plugin.zsh that I modified
zsh_command_time() {
    if [ -n "$ZSH_COMMAND_TIME" ]; then
        hours=$(($ZSH_COMMAND_TIME/3600))
        min=$(($ZSH_COMMAND_TIME/60))
        sec=$(($ZSH_COMMAND_TIME%60))
        if [ "$ZSH_COMMAND_TIME" -le 60 ]; then
            timer_show="$ZSH_COMMAND_TIME""s"
        elif [ "$ZSH_COMMAND_TIME" -gt 60 ] && [ "$ZSH_COMMAND_TIME" -le 180 ]; then
            timer_show="$min""m ""$sec""s"
        else
            if [ "$hours" -gt 0 ]; then
                min=$(($min%60))
                timer_show="$hours""h ""$min""m ""$sec""s"
            else
                timer_show="$min""m ""$sec""s"
            fi
        fi
        export RPROMPT='%F{$DESTINY_GIT_INFO_COLOR}${vcs_info_msg_0_}%f %F{$DESTINY_TIMER_COLOR}[$timer_show]%f'
    fi
}

preexec() {
  # check excluded
  if [ -n "$ZSH_COMMAND_TIME_EXCLUDE" ]; then
    cmd="$1"
    for exc ($ZSH_COMMAND_TIME_EXCLUDE) do;
      if [ "$(echo $cmd | grep -c "$exc")" -gt 0 ]; then
        # echo "command excluded: $exc"
        return
      fi
    done
  fi

  timer=${timer:-$SECONDS}
  export ZSH_COMMAND_TIME=""
}

precmd() {
  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
    if [ -n "$TTY" ] && [ $timer_show -ge ${ZSH_COMMAND_TIME_MIN_SECONDS:-3} ]; then
      export ZSH_COMMAND_TIME="$timer_show"
      zsh_command_time
    fi
    unset timer
  fi
}

# Format git message
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats '(%b%u%c)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'

# Create function to check last exit code
function check_last_exit_code() {
    local LAST_EXIT_CODE=$?
    if [[ $LAST_EXIT_CODE -ne 0 ]]; then
        echo "%F{124}[$LAST_EXIT_CODE]%f "
    fi
}

# SSH features
export PROMPT_PREFIX='%F{$DESTINY_USERNAME_COLOR}%n%f %F{$DESTINY_SEPARATOR_COLOR}on%f %F{$DESTINY_HOSTNAME_COLOR}%m%f'
if [ $SSH_CLIENT ] || [ $SSH_TTY ]; then 
    if [[ $DESTINY_SHOW_USERNAME_IN_SSH == "false" ]]; then PROMPT_PREFIX='%F{$DESTINY_SEPARATOR_COLOR}on%f %F{$DESTINY_HOSTNAME_COLOR}%m%f' fi
fi

# Add branch information to right of prompt
export RPROMPT='%F{$DESTINY_GIT_INFO_COLOR}${vcs_info_msg_0_}%f'
export ZLE_RPROMPT_INDENT=0
# Declare prompt
export PROMPT='$PROMPT_PREFIX %F{$DESTINY_SEPARATOR_COLOR}in%f %F{$DESTINY_DIR_COLOR}%1~%f %F{$DESTINY_LEVEL_COLOR}(%#)%f $(check_last_exit_code)%F{$DESTINY_ARROW_COLOR}->%f '
