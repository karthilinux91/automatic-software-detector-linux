#!/bin/bash 

###################################################################################################################
#                       AUTOMATIC SCRIPT FOR SOFTWARE AUDIT AND REPORT GENERATION            
#__________________________________________________________________________________________________________________
#
#          FILE: spotsw_automatic.sh
# 
#         USAGE: ./spotsw_automatic.sh 
# 
#   DESCRIPTION: Discover the software packages and version  on Linux
#                Generate JSON format report and HTML format report
#		         
#               Basic information : Hostname,IPAddress,MAC Address,Platform,OS Detail,Kernel Version
#               PACKAGES          : Apache, PHP, Apache Tomcat, JAVA, PostgreSQL Server and client, 
#                                   MYSQL & MARIADB (server & client),Python,Perl  
#               Security          : Firewalld status & SELinux status   
# 
#  REQUIREMENTS: RHEL 5,6,7 & CentOS 5,6,7  
#          BUGS: ---
#         NOTES: Need mlocate package for find the path of software packages
#        AUTHOR: karthi.linux.91@gmail.com	
#  ORGANIZATION: NIC - OTG , chennai
#       CREATED: Monday 14 August 2017 09:30:47  IST
#      REVISION: 0.1 
####################################################################################################################

begin=$(date +%s) 
set -o nounset                              # Treat unset variables as an error
>report.html 
>report.json
>/opt/spotsw_automatic-0.1/tempfiles/store.txt


######################################################
#    	Distribution Check - flag                    #
######################################################
lsb_release -a 2&>/opt/spotsw_automatic-0.1/tempfiles/1
check="$(echo $? )"
if [ $check -eq 0 ]
then
	name=`lsb_release -i | awk -F":" '{print $2}' | xargs`
        flag_version=`lsb_release -rs | cut -c1-1`
	#flag_version=`printf "%.0f" $flag_version`

else
	name=`cat /etc/os-release  | awk '/^ID=/{print}' | cut -d '"' -f 2`
	flag_version=`cat /etc/os-release  | awk '/^VERSION_ID/{print}' | cut -d '=' -f 2 |  tr -d '"'| cut -c1-1`
	#flag_version=`printf "%.0f" $flag_version`
fi

if [ "$name" = "CentOS" ] || [ "$name" = "centos"  ] || [ "$name" = "Red Hat Enterprise Linux Server" ] || [  "$name" = "RedHatEnterpriseServer" ] || [ "$name" = "Scientific" ] || [ "$name" = "rhel" ]
then 
   flag_os=rhel	
else 
   echo "Yet to implement for this....terminated." $name
   exit 
fi 

echo "Original OS name :" $name 
#echo $flag_version

flag=$flag_os$flag_version
echo "Flag : "$flag


echo ""
echo ""
echo "           Software Audit by AUTOMATICALLY "
echo "########################################################"
echo ""
echo ""

################################################
#        BASIC INFORMATION OF OS               #
################################################
echo "{"  >> report.json 

vhostname=`hostname`
echo "hostname:" $vhostname 
echo ""\"hostname"\"":"\"$vhostname"\" "," >> report.json



if [ "$flag" = "rhel7"  ] 
then
vipaddress=`hostname --all-ip-addresses`
echo "ipaddress:" $vipaddress
echo ""\"ipaddress"\"  ":  "\"$vipaddress"\" "," >> report.json

elif [ "$flag" = "rhel6" ] || [ "$flag" = "rhel5"  ]
then 
vipaddress=`ifconfig  | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}' | grep -v 127.0.0.1`
echo "ipaddress:" $vipaddress
echo ""\"ipaddress"\"  ":  "\"$vipaddress"\" "," >> report.json
fi




if [ "$flag" = "rhel7"  ] 
then
vmacaddress=`ip add  | grep link/ether | awk '{print $2}' ORS=' '` 
echo "macaddress:" $vmacaddress
echo ""\"macaddress"\" ":  "\"$vmacaddress"\" "," >> report.json
elif [ "$flag" = "rhel6" ] || [ "$flag" = "rhel5"  ]
then 
vmacaddress=`ifconfig  | awk -F"HWaddr" '{print $2}' | xargs`
echo "macaddress:" $vmacaddress
echo ""\"macaddress"\" ":  "\"$vmacaddress"\" "," >> report.json
fi



echo "osdetail:" `cat /etc/redhat-release` 
echo ""\"osdetail"\" ":"\"`cat /etc/redhat-release`"\" "," >> report.json

echo "platform:"  `uname`
echo ""\"platform"\"":"\"`uname`"\" ","  >> report.json

echo "kernelversion:" `uname -r` 
echo ""\"kernelversion"\"":"\"`uname -r`"\" ","  >> report.json

echo "uptime:" `uptime` 
echo ""\"uptime"\"":"\"`uptime`"\" ","  >> report.json



echo "date:" `date`
echo ""\"date"\":" "\"`date`"\" "," >> report.json




########################################################################
#                       HTML REPORT PART                               #
########################################################################
echo "	<html lang="en">	 "	>>	report.html
echo "	<head>	 "	>>	report.html
echo "	<meta charset="utf-8" />	 "	>>	report.html
echo "	<title>Software Audit</title>	 "	>>	report.html
echo "	<meta name="viewport" content="initial-scale=1.0\; maximum-scale=1.0\; width=device-width\;"> "	>> report.html
echo "	<style>	 "	>>	report.html
echo "	body {	 "	>>	report.html
echo "	  background-color: #3e94ec;	 "	>>	report.html
echo "	  font-family: "Roboto", helvetica, arial, sans-serif;	 "	>>	report.html
echo "	  font-size: 16px;	 "	>>	report.html
echo "	  font-weight: 400;	 "	>>	report.html
echo "	  text-rendering: optimizeLegibility;	 "	>>	report.html
echo "	}	 "	>>	report.html
echo "	div.table-title {	 "	>>	report.html
echo "	  display: block;	 "	>>	report.html
echo "	  margin: auto;	 "	>>	report.html
echo "	  max-width: 1000px;	 "	>>	report.html
echo "	  padding:5px;	 "	>>	report.html
echo "	  width: 100%;	 "	>>	report.html
echo "	}	 "	>>	report.html
echo "	.table-title h3 {	 "	>>	report.html
echo "	   color: #fafafa;	 "	>>	report.html
echo "	   font-size: 30px;	 "	>>	report.html
echo "	   font-weight: 400;	 "	>>	report.html
echo "	   font-style:normal;	 "	>>	report.html
echo "	   font-family: "Roboto", helvetica, arial, sans-serif;	 "	>>	report.html
echo "	   text-shadow: -1px -1px 1px rgba(0, 0, 0, 0.1);	 "	>>	report.html
echo "	   text-transform:uppercase;	 "	>>	report.html
echo "	}	 "	>>	report.html
echo "	/*** Table Styles 1 **/	 "	>>	report.html
echo "	.table-fill1 {	 "	>>	report.html
echo "	  background: white;	 "	>>	report.html
echo "	  border-radius:3px;	 "	>>	report.html
echo "	  border-collapse: collapse;	 "	>>	report.html
echo "	  height: 200px;	 "	>>	report.html
echo "	  margin: auto;	 "	>>	report.html
echo "	  max-width: 1100px;	 "	>>	report.html
echo "	  padding:5px;	 "	>>	report.html
echo "	  width: 100%;	 "	>>	report.html
echo "	  box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);	 "	>>	report.html
echo "	  animation: float 5s infinite;	 "	>>	report.html
echo "	}	 "	>>	report.html
echo "	/*** Table Styles 2 **/	 "	>>	report.html
echo "	.table-fill2 {	 "	>>	report.html
echo "	  background: white;	 "	>>	report.html
echo "	  border-radius:3px;	 "	>>	report.html
echo "	  border-collapse: collapse;	 "	>>	report.html
echo "	  height: 200px;	 "	>>	report.html
echo "	  margin: auto;	 "	>>	report.html
echo "	  max-width: 1100px;	 "	>>	report.html
echo "	  padding:5px;	 "	>>	report.html
echo "	  width: 100%;	 "	>>	report.html
echo "	  box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);	 "	>>	report.html
echo "	  animation: float 5s infinite;	 "	>>	report.html
echo "	} 	 "	>>	report.html
echo "	th {	 "	>>	report.html
echo "	  color:#D5DDE5;;	 "	>>	report.html
echo "	  background:#1b1e24;	 "	>>	report.html
echo "	  border-bottom:4px solid #9ea7af;	 "	>>	report.html
echo "	  border-right: 1px solid #343a45;	 "	>>	report.html
echo "	  font-size:23px;	 "	>>	report.html
echo "	  font-weight: 100;	 "	>>	report.html
echo "	  padding:6px;	 "	>>	report.html
echo "	  text-align:left;	 "	>>	report.html
echo "	  text-shadow: 0 1px 1px rgba(0, 0, 0, 0.1);	 "	>>	report.html
echo "	  vertical-align:middle;	 "	>>	report.html
echo "	}	 "	>>	report.html
echo "	th:first-child {  border-top-left-radius:3px;} 	 "	>>	report.html
echo "	th:last-child {  border-top-right-radius:3px;  border-right:none;}  	 "	>>	report.html
echo "	tr {	 "	>>	report.html
echo "	  border-top: 1px solid #C1C3D1;	 "	>>	report.html
echo "	  border-bottom-: 1px solid #C1C3D1;	 "	>>	report.html
echo "	  color:#666B85;	 "	>>	report.html
echo "	  font-size:16px;	 "	>>	report.html
echo "	  font-weight:normal;	 "	>>	report.html
echo "	  text-shadow: 0 1px 1px rgba(256, 256, 256, 0.1);	 "	>>	report.html
echo "	} 	 "	>>	report.html
echo "	tr:hover td {	 "	>>	report.html
echo "	  background:#4E5066; 	 "	>>	report.html
echo "	 /** background: burlywood; **/	 "	>>	report.html
echo "	  color:#FFFFFF;	 "	>>	report.html
echo "	  border-top: 1px solid #22262e;	 "	>>	report.html
echo "	  border-bottom: 1px solid #22262e;	 "	>>	report.html
echo "	} 	 "	>>	report.html
echo "	tr:first-child {  border-top:none;}	 "	>>	report.html
echo "	tr:last-child {  border-bottom:none;} 	 "	>>	report.html
echo "	tr:nth-child(odd) td {  background:#EBEBEB;} 	 "	>>	report.html
echo "	tr:nth-child(odd):hover td {  background:#4E5066;}	 "	>>	report.html
echo "	tr:last-child td:first-child {  border-bottom-left-radius:3px;} 	 "	>>	report.html
echo "	tr:last-child td:last-child {  border-bottom-right-radius:3px;} 	 "	>>	report.html
echo "	td {	 "	>>	report.html
echo "	  background:#FFFFFF;	 "	>>	report.html
echo "	  padding:5px;	 "	>>	report.html
echo "	  text-align:left;	 "	>>	report.html
echo "	  vertical-align:middle;	 "	>>	report.html
echo "	  font-weight:300;	 "	>>	report.html
echo "	  font-size:18px;	 "	>>	report.html
echo "	  text-shadow: -1px -1px 1px rgba(0, 0, 0, 0.1);	 "	>>	report.html
echo "	  border-right: 1px solid #C1C3D1;	 "	>>	report.html
echo "	}	 "	>>	report.html
echo "	td:last-child {  border-right: 0px;}	 "	>>	report.html
echo "	td:color-child {  bgcolor:green;}	 "	>>	report.html
echo "	th.text-left {  text-align: left;}	 "	>>	report.html
echo "	th.text-center {  text-align: center;}	 "	>>	report.html
echo "	th.text-right {  text-align: right;}	 "	>>	report.html
echo "	td.text-left {  text-align: left;}	 "	>>	report.html
echo "	td.text-center {  text-align: center;}	 "	>>	report.html
echo "	td.text-right {  text-align: right;}	 "	>>	report.html
echo "	</style>	 "	>>	report.html
echo "	</head>	 "	>>	report.html
echo "	<body>	 "	>>	report.html
echo "	<div class="table-title">	 "	>>	report.html
echo "	<h3>Discovery of Software Packages in the Server by OTG  </h3>	 "	>>	report.html
echo "	</div>	 "	>>	report.html
echo "	<table class="table-fill1">	 "	>>	report.html
echo "	<thead>	 "	>>	report.html
echo "	<tr>	 "	>>	report.html
echo "	<th class="text-left">Basic Information</th>	 "	>>	report.html
echo "	<th class="text-left"></th>	 "	>>	report.html
echo "	</tr>	 "	>>	report.html
echo "	</thead>	 "	>>	report.html
echo "	<tbody class="table-hover">	 "	>>	report.html
echo "	<tr>	 "	>>	report.html
echo "	</tr>	 "	>>	report.html
####################################################################################
echo  "	<tr>	 						"	>>  report.html
echo  "	<td class="text-left">Hostname</td>			"	>>  report.html
echo  "	<td class=""text-left"">$vhostname</td> 		"	>>  report.html
echo  "	</tr>	  						"	>>  report.html
echo  "	<tr>							"	>>  report.html
echo  "	<td class=""text-left"">IP Address</td>			"	>>  report.html
echo  "	<td class=""text-left"">$vipaddress</td>		"	>>  report.html
echo  "	</tr>							"	>>  report.html
echo  "	<tr>							"	>>  report.html
echo  "	<td class=""text-left"">Mac Address</td>		"	>>  report.html
echo  "	<td class=""text-left"">$vmacaddress</td> 		"	>>  report.html
echo  "	</tr>							"	>>  report.html
echo  " <tr>                                                    "       >>  report.html
echo  " <td class=""text-left"">Platform </td>                  "       >>  report.html
echo  " <td class=""text-left"">`uname`</td>                    "       >>  report.html
echo  " </tr>                                                   "       >>  report.html
echo  "	<tr>							"	>>  report.html
echo  "	<td class=""text-left"">OS Detail</td>			"	>>  report.html
echo  "	<td class=""text-left"">`cat /etc/redhat-release`</td>	"	>>  report.html
echo  "	</tr>							"	>>  report.html
echo  "	<tr>							"	>>  report.html
echo  "	<td class=""text-left"">Kernel</td>			"	>>  report.html
echo  "	<td class=""text-left"">`uname -r`</td>			"	>>  report.html
echo  "	</tr>							"	>>  report.html

echo  "	<tr>							"	>>  report.html
echo  "	<td class=""text-left"">Uptime</td>			"	>>  report.html
echo  "	<td class=""text-left"">`uptime`</td>			"	>>  report.html
echo  "	</tr>

						"	>>  report.html
echo  "	<tr>							"	>>  report.html
echo  "	<td class=""text-left"">Date</td>			"	>>  report.html
echo  "	<td class=""text-left"">`date`</td>			"	>>  report.html
echo  "	</tr>							"	>>  report.html
echo  "	</tbody>						"	>>  report.html
echo  "	</table>						"	>>  report.html
echo  " </br>   			 			"	>>  report.html
echo  "	</br>							"	>>  report.html

#############################################################################################
#                          Table 2 packages information	                                    #
############################################################################################# 
echo  "	<table class="table-fill2">				"	>>  report.html
echo  "	<thead>							"	>>  report.html
echo  "	<tr>							"	>>  report.html
echo  "	<th class=""text-left"">Package Name</th>		"	>>  report.html
echo  "	<th class=""text-left"">Information of the Packages</th>"	>>  report.html
echo  "	<th class=""text-left"">Latest package version  </th>   "	>>  report.html
echo  "	</tr>							"	>>  report.html
echo  "	</thead>						"	>>  report.html
echo  "	<tbody class=""table-hover"">				"	>>  report.html

##############################################################################################





########################################################################
#                   CHECK mlocate PACKAGE                              #
########################################################################

#rpm -qa | grep mlocate
#check="$(echo $? )"
#if [ $check -eq 0 ]
#then
#   echo "mlocate is  installed "
#   echo "wait few minutes......."
#   updatedb
#   echo "updatedb finished" 
#else
#   echo "mlocate is not installed"
#   yum localinstall -y  mlocate-0.26-6.el7.x86_64.rpm 
#   echo "wait few minutes......."
#   updatedb
#   echo "updatedb finished"
#fi
#echo ""
#echo ""

##########################################################################
# 			mlocate path	   	                         #
##########################################################################

mlocate_path=/opt/spotsw_automatic-0.1/packages/mlocate-rhel$flag_version
echo "wait few minutes ..............updatedb process"
$mlocate_path/updatedb --require-visibility 0 -o mlocate.db





########################################################################
#               HTTPD Service  version,path and modules                #
########################################################################
echo "apache"
> /opt/spotsw_automatic-0.1/tempfiles/store.txt
$mlocate_path/locate -r /httpd$ -d /opt/spotsw_automatic-0.1/mlocate.db | xargs file  2>&1 | grep dynamically  | awk -F":" '{print $1}' > /opt/spotsw_automatic-0.1/tempfiles/store.txt
FILENAME="/opt/spotsw_automatic-0.1/tempfiles/store.txt"
if [ -s ${FILENAME} ]
then
    echo "File has data"
    echo  " <tr>                                            "       >>  report.html
    echo  " <td class=""text-left"">Apache </td>             "       >>  report.html
    echo  " <td class=""text-left""><br>		    "  	    >>  report.html
    echo "\"apache"\" : "[" >> report.json
    total="$(cat /opt/spotsw_automatic-0.1/tempfiles/store.txt  | wc -l )"
	i=1
	while IFS= read -r var
	do
	  array[ $i ]=$var
	  (( i++ ))
	done < "/opt/spotsw_automatic-0.1/tempfiles/store.txt"

	for (( c=1; c<=$total; c++ ))
	do
	   version="`${array[c]} -version 2>&1  | grep version | awk '{print $3}'`"
	   path=${array[c]}
	   modules="`${array[c]} -M 2>&1 |  grep -v "Loaded Modules:"`"
           ${array[c]} -M 2>&1 |  grep -v "Loaded Modules:" | awk '{$1=$1;print}' >/opt/spotsw_automatic-0.1/tempfiles/apachemod.txt 
	   #apachemod_total="$(cat /opt/spotsw_automatic-0.1/tempfiles/apachemod.txt  | wc -l )"	
	   #echo $apachemod_total
           cat /opt/spotsw_automatic-0.1/tempfiles/apachemod.txt | sed  's/\(.*\)/"\1",/g' | awk '{a[NR]=$0} END {for (i=1;i<NR;i++) print a[i];sub(/.$/,"",a[NR]);print a[NR]}'   > /opt/spotsw_automatic-0.1/tempfiles/apachemod_result.txt 





	   echo "Version : " $version
	   echo "path:" $path
	   echo "modules:" $modules
	   echo ""
	   echo ""
	   echo "<font color="blue">Version:</font>&nbsp;&nbsp;$version<hr><font color="blue">Path:</font>&nbsp;&nbsp;$path<hr><font color="blue">Modules: </font> $modules " >>report.html


           if [ $c -lt $total ]
	   then
         	echo " <hr size="4" color="#fd00cb" /> " >> report.html
	        echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\"",""\"modules"\":[`cat 			/opt/spotsw_automatic-0.1/tempfiles/apachemod_result.txt`]"}" ",">>  report.json
           else 
                echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\"",""\"modules"\":[`cat 			/opt/spotsw_automatic-0.1/tempfiles/apachemod_result.txt`]"}" "],">>  report.json 
	  fi 
	done
   	echo  "</td>                                            "        >>  report.html
        echo  " <td align=center>  Apache:2.4.27   </td>  </tr> "        >> report.html
else
  echo "Apache httpd not found!!"
  echo "\"apache"\":["not detected"], >> report.json 
fi

########################################################################
#               PHP  version,path and modules                          #
########################################################################

echo "PHP"
> /opt/spotsw_automatic-0.1/tempfiles/store.txt
$mlocate_path/locate -r /bin/php$ -d /opt/spotsw_automatic-0.1/mlocate.db | xargs file  2>&1 | grep dynamically  | awk -F":" '{print $1}' > /opt/spotsw_automatic-0.1/tempfiles/store.txt
FILENAME="/opt/spotsw_automatic-0.1/tempfiles/store.txt"

if [ -s ${FILENAME} ]
then
    echo "File has data"
    echo  " <tr>                                            "       >>  report.html
    echo  " <td class=""text-left"">PHP   </td>             "       >>  report.html
    echo  " <td class=""text-left""><br>		    "  	    >>  report.html
    echo "\"php"\" : "[" >> report.json

    total="$(cat /opt/spotsw_automatic-0.1/tempfiles/store.txt  | wc -l )"
	i=1
	while IFS= read -r var
	do
	  array[ $i ]=$var
	  (( i++ ))
	done < "/opt/spotsw_automatic-0.1/tempfiles/store.txt"

	for (( c=1; c<=$total; c++ ))
	do
	   version="`${array[c]} -v  2>&1 | grep cli | awk '{print $1 $2}'`"
	   path=${array[c]}
	   modules="`${array[c]} -m 2>&1`"
	   ${array[c]} -m 2>&1 | awk '{$1=$1;print}' >/opt/spotsw_automatic-0.1/tempfiles/phpmod.txt
           cat /opt/spotsw_automatic-0.1/tempfiles/phpmod.txt | sed  's/\(.*\)/"\1",/g' | awk '{a[NR]=$0} END {for (i=1;i<NR;i++) 
	   print a  [i];sub(/.$/,"",a[NR]);print a[NR]}'   > /opt/spotsw_automatic-0.1/tempfiles/phpmod_result.txt





	   echo "Version : " $version
	   echo "path:" $path
	   echo "modules:" $modules
	   echo ""
	   echo ""

	   
	   echo "<font color="blue">Version:</font>&nbsp;&nbsp;$version<hr><font color="blue">Path:</font>&nbsp;&nbsp;$path<hr><font color="blue">Modules:</font>$modules " >>report.html




           if [ $c -lt $total ]
	   then
         	echo " <hr size="4" color="#fd00cb" /> " >> report.html
		echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\"",""\"modules"\":[`cat 			/opt/spotsw_automatic-0.1/tempfiles/phpmod_result.txt`]"}" ",">>  report.json
           else 
                echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\"",""\"modules"\":[`cat 			/opt/spotsw_automatic-0.1/tempfiles/phpmod_result.txt`]"}" "],">>  report.json
	  fi 
	done

   	echo  "</td>                                          "        >>  report.html
	echo  " <td align=center>  PHP:7.1.7            </td>  </tr> "        >> report.html
else
  echo "PHP not found!"
  echo "\"php"\":["not detected"], >> report.json 
fi


########################################################################
#               TOMCAT  version,path                                   #
########################################################################
echo "Tomcat"
> /opt/spotsw_automatic-0.1/tempfiles/store.txt
$mlocate_path/locate -r /catalina.jar$ -d /opt/spotsw_automatic-0.1/mlocate.db | xargs file 2>&1 | grep Zip  | awk -F":" '{print $1}' > /opt/spotsw_automatic-0.1/tempfiles/store.txt
FILENAME="/opt/spotsw_automatic-0.1/tempfiles/store.txt"


###########################>>>>>>>>>>>>>>>>>>>>>>

if [ -s ${FILENAME} ]
then
    echo "File has data"
    echo  " <tr>                                            "       >>  report.html
    echo  " <td class=""text-left"">Tomcat </td>            "       >>  report.html
    echo  " <td class=""text-left""><br>		    "  	    >>  report.html
    echo "\"tomcat"\" : "[" >> report.json
    total="$(cat /opt/spotsw_automatic-0.1/tempfiles/store.txt  | wc -l )"
	i=1
	while IFS= read -r var
	do
	  array[ $i ]=$var
	  (( i++ ))
	done < "/opt/spotsw_automatic-0.1/tempfiles/store.txt"

	for (( c=1; c<=$total; c++ ))
	do
	   version="`java -cp ${array[c]} org.apache.catalina.util.ServerInfo  2>&1 | grep number  | awk '{print $3}'`" 	
	   path=${array[c]}
	 # modules="`${array[c]} -m 2>&1`"

	   echo "Version : " $version
	   echo "path:" $path
	 #  echo "modules:" $modules
	   echo ""
	   echo ""

	   
	   echo "<font color="blue">Version:</font>&nbsp;&nbsp;$version<hr><font color="blue">Path:</font>&nbsp;&nbsp;$path " >>report.html
           if [ $c -lt $total ]
	   then
         	echo " <hr size="4" color="#fd00cb" /> " >> report.html
		echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\" "}," >>  report.json
           else 
                echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\""}]," >>  report.json
	  fi 
	done

   	echo  "</td>                                          "        >>  report.html
	echo  " <td align=center>  Tomcat:8.5.16         </td>  </tr> "        >> report.html
else
  echo "Tomcat not found!"
  echo "\"tomcat"\":["not detected"], >> report.json 
fi

########################################################################
#                     JAVA version                                     #
########################################################################

echo "JAVA"
> /opt/spotsw_automatic-0.1/tempfiles/store.txt
$mlocate_path/locate -r /bin/java$ -d /opt/spotsw_automatic-0.1/mlocate.db| xargs file  2>&1 | grep dynamically  | awk -F":" '{print $1}' > /opt/spotsw_automatic-0.1/tempfiles/store.txt

FILENAME="/opt/spotsw_automatic-0.1/tempfiles/store.txt"

###########################>>>>>>>>>>>>>>>>>>>>>>

if [ -s ${FILENAME} ]
then
    echo  " <tr>                                            "       >>  report.html
    echo  " <td class=""text-left"">JAVA </td>              "       >>  report.html
    echo  " <td class=""text-left""><br>		    "  	    >>  report.html
    echo "\"java"\" : "[" >> report.json

    total="$(cat /opt/spotsw_automatic-0.1/tempfiles/store.txt  | wc -l )"
	i=1
	while IFS= read -r var
	do
	  array[ $i ]=$var
	  (( i++ ))
	done < "/opt/spotsw_automatic-0.1/tempfiles/store.txt"

	for (( c=1; c<=$total; c++ ))
	do
	   version="`${array[c]} -version   2>&1 | grep version | awk '{print $3}' | sed 's/"//g'`"
	   path=${array[c]}
	   echo "Version : " $version
	   echo "path:" $path
	   echo ""
	   echo ""
  	   echo "<font color="blue">Version:</font>&nbsp;&nbsp;$version<hr><font color="blue">Path:</font>&nbsp;&nbsp;$path " >>report.html
           if [ $c -lt $total ]
	   then
         	echo " <hr size="4" color="#fd00cb" /> " >> report.html
		echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\" "}," >>  report.json
           else 
                echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\""}]," >>  report.json
	  fi 
	done
   	echo  "</td>                                          "        >>  report.html
	echo  " <td align=center>  Open JDK Java: 1.8.0        </td>  </tr> "        >> report.html
else
  echo "Java not found !"
  echo "\"java"\":["not detected"], >> report.json 
fi

########################################################################
#                     PostgresSQl   Server  			       #
########################################################################
echo "POSTGRESQL SERVER"
>/opt/spotsw_automatic-0.1/tempfiles/store.txt
$mlocate_path/locate -r bin/pg_config$ -d /opt/spotsw_automatic-0.1/mlocate.db| xargs file 2>&1 | grep dynamically | awk -F":" '{print $1}' > /opt/spotsw_automatic-0.1/tempfiles/store.txt
FILENAME="/opt/spotsw_automatic-0.1/tempfiles/store.txt"
##############################################################################################
if [ -s ${FILENAME} ]
then
    echo  " <tr>                                            "       >>  report.html
    echo  " <td class=""text-left"">PostgreSQL Server </td> "       >>  report.html
    echo  " <td class=""text-left""><br>		    "  	    >>  report.html
    echo "\"postgresql_server"\" : "[" >> report.json
    total="$(cat /opt/spotsw_automatic-0.1/tempfiles/store.txt  | wc -l )"
	i=1
	while IFS= read -r var
	do
	  array[ $i ]=$var
	  (( i++ ))
	done < "/opt/spotsw_automatic-0.1/tempfiles/store.txt"

	for (( c=1; c<=$total; c++ ))
	do
	   version="`${array[c]} --version 2>&1 | awk '{print $2}'`"
	   path=${array[c]}

	   echo "Version : " $version
	   echo "path:" $path
	   echo ""
	   echo ""

	   
	   echo "<font color="blue">Version:</font>&nbsp;&nbsp;$version<hr><font color="blue">Path:</font>&nbsp;&nbsp;$path " >>report.html
           if [ $c -lt $total ]
	   then
         	echo " <hr size="4" color="#fd00cb" /> " >> report.html
		echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\" "}," >>  report.json
           else 
                echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\""}]," >>  report.json
	  fi 
	done

   	echo  "</td>                                          "        >>  report.html
	echo  " <td align=center>  PostgreSQL Server:9.6.3         </td>  </tr> "        >> report.html
	
else
  echo "PostgreSQl_Server not found!"
  echo "\"postgresql_server"\":["not detected"], >> report.json 
fi


########################################################################
#                     PostgresSQl  Client         		       #
########################################################################
echo "POSTGRESQL Client"
>/opt/spotsw_automatic-0.1/tempfiles/store.txt
$mlocate_path/locate -r bin/psql$ -d /opt/spotsw_automatic-0.1/mlocate.db | xargs file 2>&1 | grep dynamically | awk -F":" '{print $1}' > /opt/spotsw_automatic-0.1/tempfiles/store.txt
FILENAME="/opt/spotsw_automatic-0.1/tempfiles/store.txt"
##############################################################################################
if [ -s ${FILENAME} ]
then
    echo  " <tr>                                            "       >>  report.html
    echo  " <td class=""text-left"">PostgreSQL Client </td> "       >>  report.html
    echo  " <td class=""text-left""><br>		    "  	    >>  report.html
    echo "\"postgresql_client"\" : "[" >> report.json

    total="$(cat /opt/spotsw_automatic-0.1/tempfiles/store.txt  | wc -l )"
	i=1
	while IFS= read -r var
	do
	  array[ $i ]=$var
	  (( i++ ))
	done < "/opt/spotsw_automatic-0.1/tempfiles/store.txt"

	for (( c=1; c<=$total; c++ ))
	do
	   version="`${array[c]} -V  2>&1 | grep psql | awk '{print $3}'`"
	   path=${array[c]}

	   echo "Version : " $version
	   echo "path:" $path
	   echo ""
	   echo ""

	   
	   echo "<font color="blue">Version:</font>&nbsp;&nbsp;$version<hr><font color="blue">Path:</font>&nbsp;&nbsp;$path " >>report.html
           if [ $c -lt $total ]
	   then
         	echo " <hr size="4" color="#fd00cb" /> " >> report.html
		echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\" "}," >>  report.json
           else 
                echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\""}]," >>  report.json	
	  fi 
	done

   	echo  "</td>                                          "        >>  report.html
	echo  " <td align=center>  Postgres Client:9.6.3         </td>  </tr> "        >> report.html
	
else
  echo "PostgreSQl_Client not found !"
  echo "\"postgresql_client"\":["not detected"], >> report.json 
fi

########################################################################
#                     MYSQL or MariaDB Server                          #
########################################################################
echo "MYSQL or MariaDB Server"
>/opt/spotsw_automatic-0.1/tempfiles/store.txt
$mlocate_path/locate -r bin/mysqld$ -d /opt/spotsw_automatic-0.1/mlocate.db | xargs file 2>&1 | grep dynamically | awk -F":" '{print $1}' > /opt/spotsw_automatic-0.1/tempfiles/store.txt
FILENAME="/opt/spotsw_automatic-0.1/tempfiles/store.txt"
##############################################################################################
if [ -s ${FILENAME} ]
then
    echo  " <tr>                                            "       >>  report.html
    echo  " <td class=""text-left"">MySQL or MariaDB Server </td> "       >>  report.html
    echo  " <td class=""text-left""><br>		    "  	    >>  report.html
    echo "\"mysql_mariadb_server"\" : "[" >> report.json

    total="$(cat /opt/spotsw_automatic-0.1/tempfiles/store.txt  | wc -l )"
	i=1
	while IFS= read -r var
	do
	  array[ $i ]=$var
	  (( i++ ))
	done < "/opt/spotsw_automatic-0.1/tempfiles/store.txt"

	for (( c=1; c<=$total; c++ ))
	do
	   version="`${array[c]} --version  2>&1|grep mysqld|awk '{print $3}'`"
	   path=${array[c]}

	   echo "Version : " $version
	   echo "path:" $path
	   echo ""
	   echo ""

	   
	   echo "<font color="blue">Version:</font>&nbsp;&nbsp;$version<hr><font color="blue">Path:</font>&nbsp;&nbsp;$path " >>report.html
           if [ $c -lt $total ]
	   then
         	echo " <hr size="4" color="#fd00cb" /> " >> report.html
		echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\" "}," >>  report.json
           else 
                echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\""}]," >>  report.json
	  fi 
	done

   	echo  "</td>                                          "        >>  report.html
	echo  " <td align=center>  MySQL Server : 5.7.19 0r MariaDB server: 10.2.7  </td>  </tr> "        >> report.html
	
else
  echo "MySQL_MariaDB_Server not found !"
  echo "\"mysql_mariadb_server"\":["not detected"], >> report.json 
fi


########################################################################
#                     MYSQL or MariaDB Client                          #
########################################################################
echo "MYSQL or MariaDB Client"
>/opt/spotsw_automatic-0.1/tempfiles/store.txt
$mlocate_path/locate -r bin/mysql$ -d /opt/spotsw_automatic-0.1/mlocate.db | xargs file 2>&1 | grep dynamically | awk -F":" '{print $1}' > /opt/spotsw_automatic-0.1/tempfiles/store.txt
FILENAME="/opt/spotsw_automatic-0.1/tempfiles/store.txt"
##############################################################################################
if [ -s ${FILENAME} ]
then
    echo  " <tr>                                            "       >>  report.html
    echo  " <td class=""text-left"">MySQL or MariaDB Client</td> "       >>  report.html
    echo  " <td class=""text-left""><br>		    "  	    >>  report.html
    echo "\"mysql_mariadb_client"\" : "[" >> report.json

    total="$(cat /opt/spotsw_automatic-0.1/tempfiles/store.txt  | wc -l )"
	i=1
	while IFS= read -r var
	do
	  array[ $i ]=$var
	  (( i++ ))
	done < "/opt/spotsw_automatic-0.1/tempfiles/store.txt"

	for (( c=1; c<=$total; c++ ))
	do
	   version="`${array[c]} --version  2>&1|grep mysql|awk '{print $5}'| sed 's/,//g'`"
	   path=${array[c]}

	   echo "Version : " $version
	   echo "path:" $path
	   echo ""
	   echo ""

	   
	   echo "<font color="blue">Version:</font>&nbsp;&nbsp;$version<hr><font color="blue">Path:</font>&nbsp;&nbsp;$path " >>report.html
           if [ $c -lt $total ]
	   then
         	echo " <hr size="4" color="#fd00cb" /> " >> report.html
		echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\" "}," >>  report.json
           else 
                echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\""}]," >>  report.json
	  fi 
	done

   	echo  "</td>                                          "        >>  report.html
	echo  " <td align=center>  MySQL client:5.7.19  or Mariadb client:10.2.7       </td>  </tr> "        >> report.html	
else
  echo "MySQL_MariaDB_Client not found !"
  echo "\"mysql_mariadb_client"\":["not detected"], >> report.json 
fi


########################################################################
#                     PERL version                                     #
########################################################################
echo "PERL"
> /opt/spotsw_automatic-0.1/tempfiles/store.txt
$mlocate_path/locate -r /bin/perl$ -d /opt/spotsw_automatic-0.1/mlocate.db | xargs file  2>&1 | grep dynamically  | awk -F":" '{print $1}' > /opt/spotsw_automatic-0.1/tempfiles/store.txt

FILENAME="/opt/spotsw_automatic-0.1/tempfiles/store.txt"

#########################################################################

if [ -s ${FILENAME} ]
then
    echo  " <tr>                                            "       >>  report.html
    echo  " <td class=""text-left"">Perl </td>              "       >>  report.html
    echo  " <td class=""text-left""><br>		    "  	    >>  report.html
    echo "\"perl"\" : "[" >> report.json
    total="$(cat /opt/spotsw_automatic-0.1/tempfiles/store.txt  | wc -l )"
	i=1
	while IFS= read -r var
	do
	  array[ $i ]=$var
	  (( i++ ))
	done < "/opt/spotsw_automatic-0.1/tempfiles/store.txt"

	for (( c=1; c<=$total; c++ ))
	do
	   version="`${array[c]} --version 2>&1 | grep -Eo    'v[0-9].[0-9]*.[0-9]'`"
	   path=${array[c]}
	   echo "Version : " $version
	   echo "path:" $path
	   echo ""
	   echo ""
  	   echo "<font color="blue">Version:</font>&nbsp;&nbsp;$version<hr><font color="blue">Path:</font>&nbsp;&nbsp;$path " >>report.html
           if [ $c -lt $total ]
	   then
         	echo " <hr size="4" color="#fd00cb" /> " >> report.html
		echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\" "}," >>  report.json
           else 
                echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\""}]," >>  report.json
	  fi 
	done
   	echo  "</td>                                          "        >>  report.html
	echo  " <td align=center>  Perl:5.26.0        </td>  </tr> "        >> report.html
else
  echo "Perl not found ! "
  echo "\"perl"\":["not detected"], >> report.json 
fi


########################################################################
#                     PYTHON  version                                  #
########################################################################
echo "PYTHON" 
>/opt/spotsw_automatic-0.1/tempfiles/store.txt
$mlocate_path/locate  /bin/python  -d /opt/spotsw_automatic-0.1/mlocate.db  | xargs file 2>&1 | grep dynamically | awk -F":" '{print $1}' > /opt/spotsw_automatic-0.1/tempfiles/store.txt

FILENAME="/opt/spotsw_automatic-0.1/tempfiles/store.txt"

#########################################################################

if [ -s ${FILENAME} ]
then
    echo  " <tr>                                            "       >>  report.html
    echo  " <td class=""text-left"">Python </td>              "       >>  report.html
    echo  " <td class=""text-left""><br>		    "  	    >>  report.html
    echo "\"python"\" : "[" >> report.json
    total="$(cat /opt/spotsw_automatic-0.1/tempfiles/store.txt  | wc -l )"
	i=1
	while IFS= read -r var
	do
	  array[ $i ]=$var
	  (( i++ ))
	done < "/opt/spotsw_automatic-0.1/tempfiles/store.txt"

	for (( c=1; c<=$total; c++ ))
	do
	   version="`${array[c]}  -V  2>&1 | awk '{print $2}' `"
	   path=${array[c]}
	   echo "Version : " $version
	   echo "path:" $path
	   echo ""
	   echo ""
  	   echo "<font color="blue">Version:</font>&nbsp;&nbsp;$version<hr><font color="blue">Path:</font>&nbsp;&nbsp;$path " >>report.html
           if [ $c -lt $total ]
	   then
         	echo " <hr size="4" color="#fd00cb" /> " >> report.html
		echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\" "}," >>  report.json
           else 
                echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\""}]," >>  report.json
	  fi 
	done
   	echo  "</td>                                          "        >>  report.html
	echo  " <td align=center>  Python:3.6.2        </td>  </tr> "        >> report.html
else
  echo "Python not found!"
  echo "\"python"\":["not detected"], >> report.json 
fi





########################################################################
#                      List of running service 			       #
########################################################################

>/opt/spotsw_automatic-0.1/tempfiles/store.txt	                   

if [ "$flag" = "rhel7"  ] 
then
	systemctl 2>&1 | grep service |  grep running  | awk '{print $1}' >/opt/spotsw_automatic-0.1/tempfiles/store.txt

elif [ "$flag" = "rhel6" ] || [ "$flag" = "rhel5" ]
then 
	service --status-all 2>&1 | grep "is running" | awk -F"(" '{print $1}' >/opt/spotsw_automatic-0.1/tempfiles/store.txt
fi	


cat /opt/spotsw_automatic-0.1/tempfiles/store.txt | sed  's/\(.*\)/"\1",/g' | awk '{a[NR]=$0} END {for (i=1;i<NR;i++) print a[i];sub(/.$/,"",a[NR]);print a[NR]}'   > /opt/spotsw_automatic-0.1/tempfiles/running_services_result.txt



FILENAME="/opt/spotsw_automatic-0.1/tempfiles/store.txt"

#########################################################################

if [ -s ${FILENAME} ]
then
    echo  " <tr>                                            "       >>  report.html
    echo  " <td class=""text-left"">Running Services </td>              "       >>  report.html
    echo  " <td class=""text-left""><br>		    "  	    >>  report.html
    echo "\"running_services"\" : "[" >> report.json
    total="$(cat /opt/spotsw_automatic-0.1/tempfiles/store.txt  | wc -l )"
	i=1
	while IFS= read -r var
	do
	  array[ $i ]=$var
	  (( i++ ))
	done < "/opt/spotsw_automatic-0.1/tempfiles/store.txt"

	for (( c=1; c<=$total; c++ ))
	do
	   path=${array[c]}
	   
  	   echo "&nbsp;&nbsp;$path </br>" >>report.html
           	
	done
   	echo  "</td>  </tr>                                        "        >>  report.html
        echo   "`cat  /opt/spotsw_automatic-0.1/tempfiles/running_services_result.txt` ],"  		            >>  report.json 
else
  echo "File empty!!"
  echo "\"running_services"\":{}, >> report.json 
fi



echo "running services block"




########################################################################
#                      List of Enabled  service            	       #
########################################################################

>/opt/spotsw_automatic-0.1/tempfiles/store.txt	                   

if [ "$flag" = "rhel7"  ] 
then
	systemctl list-unit-files | grep enabled  | grep service | awk '{print $1}' >/opt/spotsw_automatic-0.1/tempfiles/store.txt

elif [ "$flag" = "rhel6" ] ||  [ "$flag" = "rhel5" ]
then 
	chkconfig --list | grep $(runlevel | awk '{ print $2}'):on | awk '{print $1}' >/opt/spotsw_automatic-0.1/tempfiles/store.txt
fi	

cat /opt/spotsw_automatic-0.1/tempfiles/store.txt | sed  's/\(.*\)/"\1",/g' | awk '{a[NR]=$0} END {for (i=1;i<NR;i++) print a[i];sub(/.$/,"",a[NR]);print a[NR]}'   > /opt/spotsw_automatic-0.1/tempfiles/enabled_services_result.txt

FILENAME="/opt/spotsw_automatic-0.1/tempfiles/store.txt"

#########################################################################

if [ -s ${FILENAME} ]
then
    echo  " <tr>                                            "       >>  report.html
    echo  " <td class=""text-left"">Enabled Services </td>              "       >>  report.html
    echo  " <td class=""text-left""><br>		    "  	    >>  report.html
    echo "\"enabled_services"\" : "[" >> report.json
    total="$(cat /opt/spotsw_automatic-0.1/tempfiles/store.txt  | wc -l )"
	i=1
	while IFS= read -r var
	do
	  array[ $i ]=$var
	  (( i++ ))
	done < "/opt/spotsw_automatic-0.1/tempfiles/store.txt"

	for (( c=1; c<=$total; c++ ))
	do
	   path=${array[c]}
	   
  	   echo "&nbsp;&nbsp;$path </br>" >>report.html
          #if [ $c -lt $total ]
	 # then
         #	echo " <hr size="0.1" color="#fd00cb" /> " >> report.html
	#  fi 
	done
   	echo  "</td>  </tr>                                        "        >>  report.html
        echo   "`cat  /opt/spotsw_automatic-0.1/tempfiles/enabled_services_result.txt` ],"  	            >>  report.json 
else
  echo "File empty!!"
  echo "\"enabled_services"\":{}, >> report.json 
fi
echo "Enabled services block"



########################################################################
#               Wordpress  version,path and plugins	               #
########################################################################

echo "wordpress"
> /opt/spotsw_automatic-0.1/tempfiles/store.txt
$mlocate_path/locate wp-login.php -d /opt/spotsw_automatic-0.1/mlocate.db | awk -F"wp-login" '{print $1}' > /opt/spotsw_automatic-0.1/tempfiles/store.txt
FILENAME="/opt/spotsw_automatic-0.1/tempfiles/store.txt"
mainpath="/opt/spotsw_automatic-0.1/"
echo mainpath: $mainpath 
if [ -s ${FILENAME} ]
then
    echo "File has data"
    echo  " <tr>                                            "       >>  report.html
    echo  " <td class=""text-left"">Wordpress </td>             "       >>  report.html
    echo  " <td class=""text-left""><br>		    "  	    >>  report.html
    echo "\"wordpress"\" : "[" >> report.json
    total="$(cat /opt/spotsw_automatic-0.1/tempfiles/store.txt  | wc -l )"
	i=1
	while IFS= read -r var
	do
	  array[ $i ]=$var
	  (( i++ ))
	done < "/opt/spotsw_automatic-0.1/tempfiles/store.txt"

	for (( c=1; c<=$total; c++ ))
	do
	   cd ${array[c]}
           version="`/opt/spotsw_automatic-0.1/packages/wp-cli core version --allow-root`"
	   path=${array[c]}
	   #plugins="`/opt/spotsw_automatic-0.1/packages/wp-cli plugin list --format=csv  --allow-root`"
	   plugins="`/opt/spotsw_automatic-0.1/packages/wp-cli plugin list  --format=yaml  --allow-root`"
	   plugins_json="`/opt/spotsw_automatic-0.1/packages/wp-cli plugin list --format=json  --allow-root`"

	   echo "Version : " $version
	   echo "path:" $path
	   echo "plugins:" 
	   /opt/spotsw_automatic-0.1/packages/wp-cli plugin list   --allow-root
	   cd $mainpath


	   echo "<font color="blue">Version:</font>&nbsp;&nbsp;$version<hr><font color="blue">Path:</font>&nbsp;&nbsp;$path<hr><font color="blue">Plugins: </font> $plugins " >>report.html


           if [ $c -lt $total ]
	   then
         	echo " <hr size="4" color="#fd00cb" /> " >> report.html
	       echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\"",""\"plugins"\": $plugins_json"}" ",">>  report.json
           else 
               echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\"",""\"plugins"\":$plugins_json"}" "],">>  report.json 
		echo ""
	  fi 
	done
   	echo  "</td>                                            "        >>  report.html
        echo  " <td align=center>  Wordpress:4.8.1   </td>  </tr> "        >> report.html
else
  echo "wordpress not found!!"
  echo "\"wordpress"\":[ "not detected "], >> report.json 
fi
cd $mainpath


########################################################################
#               Drupal  version,path and modules	               #
########################################################################

echo "Drupal"
> /opt/spotsw_automatic-0.1/tempfiles/store.txt
$mlocate_path/locate -r robots.txt$ -d /opt/spotsw_automatic-0.1/mlocate.db | awk -F"robots.txt" '{print $1}' > /opt/spotsw_automatic-0.1/tempfiles/store.txt
FILENAME="/opt/spotsw_automatic-0.1/tempfiles/store.txt"
mainpath="/opt/spotsw_automatic-0.1/"
#echo mainpath: $mainpath 
if [ -s ${FILENAME} ]
then
    echo "File has data"
    echo  " <tr>                                            "       >>  report.html
    echo  " <td class=""text-left"">drupal</td>             "       >>  report.html
    echo  " <td class=""text-left""><br>		    "  	    >>  report.html
    echo "\"drupal"\" : "[" >> report.json
    total="$(cat /opt/spotsw_automatic-0.1/tempfiles/store.txt  | wc -l )"
	i=1
	while IFS= read -r var
	do
	  array[ $i ]=$var
	  (( i++ ))
	done < "/opt/spotsw_automatic-0.1/tempfiles/store.txt"

	for (( c=1; c<=$total; c++ ))
	do
	   cd ${array[c]}
           version="`/opt/spotsw_automatic-0.1/packages/drush8-cli status 2>&1 | grep "Drupal version" | awk -F":" '{print $2}' | xargs`"
	   path=${array[c]}
	  modules="`/opt/spotsw_automatic-0.1/packages/drush8-cli  pm-list --fields=name,status --format=csv`"

           modules_json="`/opt/spotsw_automatic-0.1/packages/drush8-cli  pm-list --format=json 2>&1`"

	   echo "Version : " $version
	   echo "path:" $path
	   #echo "modules:" 
           #/opt/spotsw_automatic-0.1/packages/drush8-cli  pm-list --format=docs-output-formats

	   cd $mainpath


	   echo "<font color="blue">Version:</font>&nbsp;&nbsp;$version<hr><font color="blue">Path:</font>&nbsp;&nbsp;$path<hr><font color="blue">Modules: </font>$modules  " >>report.html


           if [ $c -lt $total ]
	   then
         	echo " <hr size="4" color="#fd00cb" /> " >> report.html
	       echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\"",""\"modules"\":$modules_json "}" ",">>  report.json
           else 
               echo "{" "\"version"\": "\"$version"\" ",""\"path"\":"\"$path"\"",""\"modules"\":$modules_json"}" "],">>  report.json 
		echo ""
	  fi 
	done
   	echo  "</td>                                            "        >>  report.html
        echo  " <td align=center>  Drupal:8.3.6    </td>  </tr> "        >> report.html
else
  echo "Drupal not found!!"
  echo "\"drupal"\":[ "not detected"], >> report.json 
fi
cd $mainpath



########################################################################
#                     SeLinux  status                                  #
########################################################################
echo  " <tr>                                                            "       >>  report.html
echo  " <td class=""text-left"">SeLinux</td>   "       >>  report.html
echo  " <td class=""text-left""><br>		                        "  	>>  report.html
echo "SeLinux status:&nbsp;&nbsp ` getenforce`"       >>report.html
echo  "</td> </tr>              "       >>  report.html
echo "\"selinux_status"\": "\"` getenforce`"\",   >> report.json 


echo "SeLinux status:" ` getenforce`

########################################################################
#                    Firewall  status                                  #
########################################################################




echo  " <tr>                                                            "       >>  report.html
echo  " <td class=""text-left"">Firewall</td>  				"       >>  report.html
echo  " <td class=""text-left""><br>		                        "  	>>  report.html

if [ "$flag" = "rhel7"  ] 
then
	systemctl status firewalld >/opt/spotsw_automatic-0.1/tempfiles/store.txt
	check="$(echo $? )"
	if [ $check -eq 0 ]
	then
	status=Active
	firewall_flag=ok
	else 
	status=InActive
	firewall_flag=notok
	fi 

elif [ "$flag" = "rhel6" ] || [ "$flag" = "rhel5" ]
then 
	service iptables status >/opt/spotsw_automatic-0.1/tempfiles/store.txt
	check="$(echo $? )"
	if [ $check -eq 0 ]
	then
	status=Active
	firewall_flag=ok
	else 
	status=InActive
	firewall_flag=notok
	fi 
fi	

echo "Firewall status:&nbsp;&nbsp $status "        >>report.html
echo  "</td> </tr>  "                              >>report.html
echo ""\"firewall_status"\": "\"$status"\","       >>report.json                

                











########################################################################
#                        Open Port                                     #
########################################################################

if [ $firewall_flag = "ok" ]
then
	echo "ok"
	echo "Open Ports" 
	>/opt/spotsw_automatic-0.1/tempfiles/store.txt
        if [ flag_os = rhel7 ]	
	then
	iptables -L -n | grep ctstate | grep ACCEPT | grep dpt | awk '{print $7}' | tr -d dpt: >/opt/spotsw_automatic-0.1/tempfiles/store.txt
	else 
	iptables -L -n  | awk -F "dpt:" '{print $2}'  | grep -o -E '[0-9]+' >/opt/spotsw_automatic-0.1/tempfiles/store.txt
	fi 
	cat /opt/spotsw_automatic-0.1/tempfiles/store.txt 

	FILENAME="/opt/spotsw_automatic-0.1/tempfiles/store.txt"

	#########################################################################

	if [ -s ${FILENAME} ]
	then
	    echo  " <tr>                                            "       >>  report.html
	    echo  " <td class=""text-left"">Opened Ports </td>      "       >>  report.html
	    echo  " <td class=""text-left""><br>		    "  	    >>  report.html
	    echo "\"open_ports"\":"[" >> report.json
	    total="$(cat /opt/spotsw_automatic-0.1/tempfiles/store.txt  | wc -l )"
		i=1
		while IFS= read -r var
		do
		  array[ $i ]=$var
		  (( i++ ))
		done < "/opt/spotsw_automatic-0.1/tempfiles/store.txt"

		for (( c=1; c<=$total; c++ ))
		do
	  	   echo "Port:&nbsp;&nbsp${array[c]}" >>report.html
	           if [ $c -lt $total ]
		   then
	         	echo " <hr size="4" color="#fd00cb" /> " >> report.html
	                echo "\"${array[c]}"\",	         >>  report.json
        	   else 
	                echo "\"${array[c]} "\"	  		 >>  report.json
		   fi 
		done
		echo "] }"	   					>>  report.json
	   	echo  "</td> </tr>                                           "        >>  report.html
	else
	  echo "Open Ports not found !"
          echo "\"open_ports"\":["\" Open Ports not found ! "\" "] }" >> report.json 
	fi

else 
	echo "Open Ports not found !"
        echo "\"open_ports"\":[ "\" Open Ports not found ! "\" "] }" >> report.json
fi 



####################################################################################
#                             End of the table html part                           #
####################################################################################
            
echo  "	</tbody>						"	>>  report.html
echo  "	</table>						"	>>  report.html
echo  " </br>   			 			"	>>  report.html
echo  "	</br>							"	>>  report.html
echo  " </body>                                                 "       >>  report.html
echo  " </html>                                                 "       >>  report.html

#######################################################
#           Report trigger                            # 
#######################################################




which firefox   >/opt/spotsw_automatic-0.1/tempfiles/out 2>&1 >/opt/spotsw_automatic-0.1/tempfiles/error.txt
value="$(echo $? )"
if [ $value -eq 0 ]
then
     firefox report.html
else
  echo "firefox is not found."
  echo "Check the report file manually by any browser"
fi
echo "location:"  `pwd`


#################################
# file name conversion          #
#################################




ip=`echo $vipaddress | awk '{print $1}'`
#echo $ip 

file_name=report_$ip 
echo $file_name.html 
echo $file_name.json  
mv report.html   $file_name.html
mv report.json   $file_name.json 

#################################################
#    Send json data to web service              #
#################################################


#curl -u admin:admin -H "Content-Type: application/json" -X POST -d @$file_name.json http://10.163.14.72:8282/test_service/services/rest/SearchingManage/fetchDataBy/

#curl -u admin:admin -H "Content-Type: application/json" -X POST -d @report.html http://10.163.14.72:8282/test_service/services/rest/SearchingManage/fetchDataBy/


######################################
#  show the time for script excution # 
######################################
echo ""
echo ""
end=$(date +%s)
tottime=$(expr $end - $begin)
echo " Time (minutes or seconds ) :" $tottime 











