#!/usr/bin/env bash

while IFS='' read -r line || [[ -n "$line" ]]; do
    # echo "Text read from file: $line"
    plugin=$(echo $line | awk '{print $1}')
    version=$(echo $line | awk '{print $2}')


    if [ -d "/var/lib/jenkins/plugins/$plugin" ] || [ -f /var/lib/jenkins/plugins/$plugin.hpi ] ; then
        #  | \
        printf "%s installed\n" $plugin
    else
       url=$(printf "http://updates.jenkins-ci.org/download/plugins/%s/%s/%s.hpi\n" $plugin $version $plugin)
        sudo curl -L -o /var/lib/jenkins/plugins/$plugin.hpi $url
        sudo chown jenkins:jenkins /var/lib/jenkins/plugins/$plugin.hpi
    fi
done < "plugins.txt"
