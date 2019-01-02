#!/bin/bash
. .bash_profile
proxy () { # consistently set proxy environment values
       local host port
       case "$1" in
           (default|gatekeeper-w|-|mclean)
               host='gatekeeper-w.mitre.org'
               port='80'
               ;;
           (gatekeeper|bedford)
               host='gatekeeper.mitre.org'
               port='80'
               ;;
           (test)              # AnyConnect testing
               host='proxy-tstb1.mitre.org'
               port='80'
               ;;
           (clear|--)
               unset HTTP_PROXY http_proxy HTTPS_PROXY https_proxy NO_PROXY no_proxy
               unset ALL_PROXY all_proxy  FTP_PROXY ftp_proxy RSYNC_PROXY JAVA_PROXY
               return
               ;;
           *)
               echo "recognized proxys: default, -, gatekeeper{,-w}, test, clear, --"
               echo "current settings:"
               env | grep -i proxy
               return
               ;;
       esac
       # Various combos I've come across, sometimes case matters
       export http_proxy="http://${host}:${port}/"
       export HTTP_PROXY=${http_proxy} HTTPS_PROXY=${http_proxy} https_proxy=${http_proxy}
       export FTP_PROXY=${http_proxy} ftp_proxy=${http_proxy}
       export ALL_PROXY=${http_proxy} all_proxy=${http_proxy}
       export RSYNC_PROXY="${host}:${port}"
       # NO_PROXY - some docs say just domain names (wget) others include IP ranges (Firefox)
       export NO_PROXY=localhost,*.mitre.org,mitre.org,*.local,127.0.0.1
       export no_proxy=${NO_PROXY}
       # Use: e.g.; java $JAVA_PROXY ...
       export JAVA_PROXY="-Dhttp.proxyHost=${host} \
     -Dhttps.proxyHost=${host} \
     -Dhttp.proxyPort=${port} \
     -Dhttps.proxyPort=${port} \
     -Dhttp.nonProxyHosts=127.0.0.1|*.mitre.org|128.29.*|129.83.*|10."
   }
proxy
git config --global http.https://codev.mitre.org.sslVerify false
git config --global http.https://codev.mitre.org.proxy ${http_proxy}
alias h=history
alias pu=pushd

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
