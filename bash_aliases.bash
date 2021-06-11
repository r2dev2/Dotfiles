alias restart="clear && source ~/.bashrc"
alias py="python3.8"
alias oct="octave --no-gui"
alias cg="cargo"
alias ps="powershell.exe"
alias cmd="cmd.exe"
alias wpy="powershell.exe -c python"
alias wjava="powershell.exe -c java"
alias wjavac="powershell.exe -c javac"
alias decache="sudo sh -c \"/bin/echo 3 > '/proc/sys/vm/drop_caches'\" && echo success"
alias swap_reset="sudo swapoff -a && sudo swapon -a && echo success"
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
alias krcp="powershell.exe -c 'cat C:\Users\ronak\Downloads\kr_settings.txt | clip'"
alias ngrok="~/ngrock/ngrok"
alias exp="explorer.exe"
alias raise-ulimit="su $(whoami) --shell /bin/bash"
alias catupload="/home/rbadhe/catuploader.bash"
alias snarf="/home/rbadhe/snarfer.bash"
alias zoom="/home/rbadhe/zoomselector.bash"
alias cim="sc-im"
alias post="curl --request POST --header \"Content-Type: application/json\""
alias sp="spdict"
alias license="/home/rbadhe/.get-license.bash"
alias ree="printf 'リーーーーーーー' | pbcopy"
alias kusa="printf '草' | pbcopy"
alias rick="DISPLAY= mpv --quiet -vo caca 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'"
alias zeros="powershell.exe -c python ~/Workspace/Schoology-grades/schoology/grades.py"
alias ssreset="echo 'taskkill /f /IM explorer.exe' | ps -c clip"
alias soattend="/home/rbadhe/sciolyattendance.bash"
function cs() { curl -m 7 "https://cheat.sh/$1"; }
alias opinion="printf 'https://www.youtube.com/watch?v=CXArovLJ60A' | powershell.exe -c clip"
alias create-svelte-app="npx degit sveltejs/template"
alias pdfcat="pdfunite"
alias gitlog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit" #Pretty git log
alias apy="python3.8 -m asyncio"
function wff() { powershell.exe -c "& \"C:\\Program Files\\Mozilla Firefox\\firefox.exe\" $1"; }
alias wpy9="powershell.exe -c \"C:\\Users\\ronak\\AppData\\Local\\Programs\\Python\\Python39\\python.exe\""
alias gsu="git submodule update --recursive"
alias gitp="git pull && gsu"
alias bb="byobu"
alias bbn="byobu new-session -s"
alias ferris="echo H4sIAGf2amAAA7WWyw3DIAyG76zAJSNAaKNWjJIZmCZSB+wkfYAKFONX1SiHyCbm84/B2N0ls8CP3cMlnuPqrvGUP9b0NLo0cS3ZOfHhzuKGUOQYQIjpaDsRgBu6nYDF/M5RnFMzgYxsIMSWDtcII8OjarEpaFIyo6tGTAwSGS1wNCaqc6eIrgYaRQnMuis0ysOKBF/GBJ/ut6OY/ZatfnsZqx0k4wdikGEVUGWqp4PyXPuSocecpKSQ58/hgRJa2tNaUAjDnJ9XlBvnRwi6Uqs3ERTXNCZpb2TvJUQI6m/qfKcbjxlB+Hl0DVJUZL9B9zcKukthK62HGO41tEZyDmMeUKQSrs0JAAA=|base64 -d|gzip -d"
alias bencode="hy ~/Workspace/Bottom/Hy/encode.hy"
alias bdecode="hy ~/Workspace/Bottom/Hy/decode.hy"
alias notgnu="cat ~/notgnu.txt | pbcopy"
alias vidview='powershell.exe -c mpv "$(pbpaste)"'
alias spstdin='pyp -i "translators as ts" "stdin | cmap ts.bing | map print | list"'
alias spcp='pbpaste | spstdin'
function ccmp() { gcc -lm -O3 -o $1 $1.c; }
function cpmp() { g++ -lm -O3 -o $1 $1.cpp; }
function crun() { ccmp $1 && cat $1.in | ./$1; }
function cprun() { cpmp $1 && cat $1.in | ./$1; }
function audio_download() { vid=$(echo $1 | sed 's|.*v\=\(.*\)|\1|g'); youtube-dl --extract-audio --audio-format=mp3 -o $vid.mp3 $1 &> /dev/null; }
function weather() { curl "http://wttr.in/sanjose"; }
