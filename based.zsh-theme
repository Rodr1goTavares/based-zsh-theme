get_ip_address() {
  output=""

  # SSH connection
  if [[ -n "$SSH_CONNECTION" ]]; then
    ssh_ip=$(echo "$SSH_CONNECTION" | awk '{print $3}')
    output+="%{$fg[cyan]%}SSH: $ssh_ip%{$reset_color%}"
  fi

  # WireGuard interfaces (wg*)
  wg_ips=$(ip -o -4 addr show 2>/dev/null | awk '/wg/ {print $2 ":" $4}' | cut -d/ -f1)
  if [[ -n "$wg_ips" ]]; then
    while IFS= read -r line; do
      ip=$(echo $line | cut -d':' -f2)
      output+="%{$fg[green]%}WireGuard: $ip%{$reset_color%}"
    done <<< "$wg_ips"
  fi

  # VPN tun* interfaces
  tun_ips=$(ip -o -4 addr show 2>/dev/null | awk '/tun/ {print $2 ":" $4}' | cut -d/ -f1)
  if [[ -n "$tun_ips" ]]; then
    while IFS= read -r line; do
      ip=$(echo $line | cut -d':' -f2)
      output+="%{$fg[green]%}VPN: $ip%{$reset_color%}"
    done <<< "$tun_ips"
  fi

  # VPN bridge tap* interfaces
  tap_ips=$(ip -o -4 addr show 2>/dev/null | awk '/tap/ {print $2 ":" $4}' | cut -d/ -f1)
  if [[ -n "$tap_ips" ]]; then
    while IFS= read -r line; do
      ip=$(echo $line | cut -d':' -f2)
      output+="%{$fg[green]%}VPN-Bridge: $ip%{$reset_color%}"
    done <<< "$tap_ips"
  fi

  # Print output or "No IP" if empty
  if [[ -n "$output" ]]; then
    echo "$output"
  else
    echo "%{$fg[red]%}No IP%{$reset_color%}"
  fi
}


PROMPT='
┌─《%F{blue} %~%f》  🪽⃤ 『%F{green} $(get_ip_address)%f』 $(git_prompt_info)
└─%F{yellow} ❍ %f'

RPROMPT='[%F{red}%?%f]'
