#!/bin/bash

firefoxUrl="https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US"
firefoxDir="/lib/firefox-dev"
workDir="$(cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
#workDir="/tmp"
checksumversion=512

ffExtractedDir="$workDir/firefox"

run=$(pgrep -af /usr/lib/firefox-dev)
if [[ -n "$run" ]]; then
  echo "Error: Something is running from the $firefoxDir directory."
  read -n 1 -s -r -p $'Press any key to continue\n'
  exit 2
fi

echo "Downloading $firefoxUrl"
content1=`curl -# "$firefoxUrl"`

set -f;IFS='"'; url2=($content1); url2=${url2[1]};set +f
IFS='/' read -r -a url2array <<< "$url2"
baseUrl="${url2array[0]}/${url2array[1]}/${url2array[2]}/${url2array[3]}/${url2array[4]}/${url2array[5]}"
ffArchivePath="$workDir/${url2array[9]}"
checksumUrl="$baseUrl/${url2array[6]}/SHA${checksumversion}SUMS"
checksumPath="$(dirname "$ffArchivePath")/checksum"

printf "\nDownloading $url2\nto $ffArchivePath\n"
curl -# "$url2" -o "$ffArchivePath"

printf "\nDownloading $checksumUrl\nto $checksumPath\n"
curl -# "$checksumUrl" -o "$checksumPath"

checksumValue=$(grep "${url2array[7]}/${url2array[8]}/${url2array[9]}" "$checksumPath")
IFS=' ' read -r -a checksumValueArray <<< "$checksumValue"

checksumArchive=$("sha${checksumversion}sum" $ffArchivePath)
IFS=' ' read -r -a checksumArchiveArray <<< "$checksumArchive"

if [ "${checksumValueArray[0]}" = "${checksumArchiveArray[0]}" ]; then
  printf "\nExtract ${url2array[9]}\n"
  pv=`command -v pv`
  if [[ -z "$pv" ]]; then
    tar -xjf "$ffArchivePath" -C "$workDir"
  else
    pv "$ffArchivePath" | tar xjf - -C "$workDir"
  fi

  printf "\nCopying."
  cp -R "$ffExtractedDir"/* "$firefoxDir"

  printf "\nCleaning.\n"
  rm -R "$ffExtractedDir"
  rm "$checksumPath"
  rm "$ffArchivePath"

  echo "Done."
else
  printf "\nChecksum error.\n"
  printf "Clean.\n"
  printf "${checksumArchiveArray[0]}\n${checksumValue}\n"
  rm "$checksumPath"
  rm "$ffArchivePath"
fi
