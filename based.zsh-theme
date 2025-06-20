get_ip_address() {
  #  tun* or tap* (VPN)
  ip_vpn=$(ip -o -4 addr show | awk '/tun|tap/ {print $4}' | cut -d/ -f1)

  # Wi-Fi IP (wlan0)
  ip_wlan=$(ip -o -4 addr show wlan0 | awk '{print $4}' | cut -d/ -f1)

  # eth0
  ip_eth=$(ip -o -4 addr show eth0 2>/dev/null | awk '{print $4}' | cut -d/ -f1)

  if [[ -n "$ip_vpn" ]]; then
    echo "%{$fg[green]%}$ip_vpn%{$reset_color%}"
  elif [[ -n "$ip_wlan" ]]; then
    echo "%{$fg[green]%}$ip_wlan%{$reset_color%}"
  elif [[ -n "$ip_eth" ]]; then
    echo "%{$fg[green]%}$ip_eth%{$reset_color%}"
  else
    echo "%{$fg[red]%}No IP%{$reset_color%}"
  fi
}

PROMPT='
┌─《%F{blue} %~%f》  🪽⃤ 『%F{green} $(get_ip_address)%f 』 $(git_prompt_info)
└─%F{yellow} ❍ %f'

RPROMPT='[%F{red}%?%f]'
