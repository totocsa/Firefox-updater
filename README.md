<h1>Firefox Browser Developer updater bash script</h1>

<b>How the script works:</b>
1. Download the url of the configured version.
2. Download the appropriate version.
3. Download the cheksum file.
4. Checksum check.
5. Extracting.
7. Copy to the configured directory.
8. Deletes downloaded files. These files were created in steps 2 and 3. Deletes the created files. This directory was created in step 5.



<b>Usage:</b>
1. On https://www.mozilla.org/en-US/firefox/all/#product-desktop-developer site choose the version. But don't download it!
2. Right click on the <i>Download Now</i> button and <i>Copy link location</i>
3. Paste to ffbdu.sh file 2. line.<br />
   Example: firefoxUrl="https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US"
4. <i>firefoxDir</i> variable value. This value is your firefox path.<br />
   Example: /lib/firefox-dev
5. <i>workDir</i> variable value. In this directory will write the script.
   Example: /tmp
	 or directory of script: $(cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )
6. <i>checksumversion</i> variable value. 256 or 512
   Example: 512

<b>Example configuration:</b><br />
firefoxUrl="https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US"<br />
firefoxDir="/lib/firefox-dev"<br />
workDir="$(cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"<br />
checksumversion=512
