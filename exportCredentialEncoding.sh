#!/bin/bash

USERNAME=$1
JENKINS_TOKEN=$2
URL=$3
BASE_DIR="$(echo $(dirname $0))"
controllerList="$BASE_DIR/controllerPathList"

if [ -z $USERNAME ] || [ -z $JENKINS_TOKEN ] || [ -z $URL ]
then
  echo "Execution parameters missing. Ignoring parameter inputs. Loading variables from config file."
  source $BASE_DIR/config
fi

downloadJenkinsCLI(){
  [ ! -f $BASE_DIR/jenkins-cli.jar ] && curl -s -u ${USERNAME}:${JENKINS_TOKEN} \
       "$URL/cjoc/jnlpJars/jenkins-cli.jar" --create-dirs --output $BASE_DIR/jenkins-cli.jar

  [ -f $BASE_DIR/jenkins-cli.jar ] && echo "Successful download of jenkins-cli.jar from Operations Center" || (echo "Error: Failed download of jenkins-cli.jar from Operations Center" && exit 1)
}

downloadCredentialEncoding(){

  while IFS= read -r line
  do
    controllerPath=`echo "${line}" | tr '[:upper:]' '[:lower:]'`
    mkdir -p $BASE_DIR/encodingOutputs
    GROOVY_SCRIPT=$(cat $BASE_DIR/groovy/export-credentials-system-level.groovy)
    groovyResponse=$(java -jar $BASE_DIR/jenkins-cli.jar -auth $USERNAME:$JENKINS_TOKEN -s "$URL/$controllerPath/" -webSocket groovy = <<< "$GROOVY_SCRIPT")

    echo $groovyResponse > encodingOutputs/$controllerPath
    echo "$controllerPath encoded credentials exported"
  done < "$controllerList"

}

downloadJenkinsCLI && downloadCredentialEncoding
