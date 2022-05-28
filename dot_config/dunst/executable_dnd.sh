#!/bin/zsh
getargs() {
  while getopts "se" opt
  do
    case $opt in
      s) start="true";;
      e) end="true";;
    esac
  done
}
start_dnd() {
  dunstctl set-paused true
}
end_dnd() {
  dunstctl set-paused false
  notify-send "Do Not Disturb" 'Do Not Disturb mode ended. Notifications will be shown.';
}
main() {
  getargs "$@";
  [[ "$start" ]] && start_dnd;
  [[ "$end" ]] && end_dnd;
}
main "$@"
