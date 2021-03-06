# account-payment-settings
Account, payment and settings services all togther as mock online service

# System run/start

## Ubuntu:

### 1. Pre-requisites
- Jenkins
- Nginx
- Maven
- Java JDK

#### Installing Jenkins

1. Open a shell terminal and add a new _repository key_ to apt
```
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add - 
```

2. Now add the _jenkins repository_ to the apt sources
```
echo deb http://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
```

3. _Update_ the local database
```
sudo apt-get update
```

4. And finally _install_ Jenkins
```
sudo apt-get install jenkins
```

#### Setting up Jenkins

1. _Open a browser_ of your choice and navigate to
```
http://localhost:8081
```

2. It will ask for a _password_. You can find it this way
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

>_After submitting the password you will be prompted to create a new user. We entered _admin as user name and password_, but this is arbitrary and for testing purposes only!_

#### Installing Nginx

1. _Update_ the local repositories
```
sudo apt-get update
```

2. _Install_ Nginx
```
sudo apt-get install nginx
```

#### Configuring Nginx

1. Enable Nginx in _firewall_
```
sudo ufw allow 'Nginx HTTP'
```

2. _Restart_ Nginx
```
sudo service nginx restart
```

3. Check that it works by navigating to `http://localhost`

#### Installing Maven

1. _Update_ the local repositories
```
sudo apt-get update
```

2. _Install_ Maven
```
sudo apt-get install maven
```

#### Installing Java JDK

1. _Update_ the local repositories
```
sudo apt-get update
```

2. _Install_ Java JDK
```
sudo apt-get install default-jdk
```

>_Now let's get started with the nitty gritty!_

### 2. Creating a new task in Jenkins

- _Open a browser_ of your choice and navigate to
```
http://localhost:8080
```

- Login with your _user name_ and _password_

- Click on `New Task` (left panel)

- Enter `account-payment-settings` as task name (_or anything else you see fit_)

- Select `free style` as project type

- Click `OK`

- In the `Source code origin` select `git` and use the following URL as `Repository URL`
```
https://github.com/xApiOrg/account-payment-settings.git
```

- Scroll down and enable `SCM`, then enter the following command
```
H/02 * * * *
```

- Finally, in the `Run pipeline` add the following steps

	- Maven tasks
	```
	clean verify test install
	```
	
	- Shell script
	```
	echo "bash $(pwd)/target/dockerfile/run_linux.sh -k" | at now
	```
	
	- Shell script
	```
	echo "bash $(pwd)/target/dockerfile/run_linux.sh -r" | at now
	```
	
- Click `Save`

>_The service should start automatically with every build!_

### 3. Expose the service with Nginx

>_The service will listen for requests on the `port 10001` by default_

>_We will redirect all the requests comming towards `http://<host>/ipay` to `http://localhost:10001/ipay`_ 

- Open a shell terminal and go to the available nginx _virtual servers_ folder:
```
cd /etc/nginx/sites-available
```

- Edit the _default configuration_ with your preferred text editor:
```
nano ./default
```

>_You should see a **location object** already present in the file.
It serves all requests comming to the root path `/`_

- Now _add_ a new location object below it:
```
location /ipay {
	include /etc/nginx/proxy_params;
	proxy_pass http://localhost:10001/ipay;
}
```

- _Restart_ the Nginx server:
```
sudo service nginx restart
```

- And _check_ with a browser or curl that it is actually working!
```
http://<public-server-ip>/ipay/account/100
```
It shoud return:
```
Metod getAllUserPaymentAccounts( Integer userId) NOT IMPLEMENTED YET Get ALL User's PAYMENT accounts by user Id Parameters, user Id = 113 []
```

### 4. Manually starting and stopping the service

Open a _shell terminal_ and move to the task's directory
```
cd /var/lib/jenkins/workspace/account-payment-settings
```

- Starting the service

	- Generate the _target_ folder
	```
	mvn generate-resources
	```

	- Start the service via the provided _shell script_
	```
	sudo bash ./target/dockerfile/run_linux -r
	```

- Stopping the service

	- Generate the _target_ folder
	```
	mvn generate-resources
	```

	- Stop the service via the provided _shell script_
	```
	sudo bash ./target/dockerfile/run_linux -k
	```
>_The `run_linux.sh` is a script writen to help run and kill the service._

>_To run the service use the parameter `-r`_

>_To kill the service use the parameter `-k`_

>_**Please stop the service by yourself** if you started it manually as Jenkins will have **no permission** to do so!_


## Windows:

### 1. Pre-requisites
- Jenkins
- Tomcat
- Maven
- Java JDK
- Open Firewall ports

#### Installing Java JDK

1. Download and install Java JDK 
```
http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
```

2. Set environment variables
```
Create JAVA_HOME environment variable in System variables
Variable name: JAVA_HOME
Variable value: {jdkDirectory} (e.g.: C:\Program Files\Java\jdk1.8.0_144)

Edit Path environment variable in System variables and add %JAVA_HOME% to it
```

#### Installing Jenkins

1. Download and install Jenkins for Windows
```
https://jenkins.io/download/
```

#### Setting up Jenkins

1. Open a browser of your choice and navigate to
```
http://localhost:8080
```

2. It will ask for a password. You can find it here
```
{jenkinsDirectory}/secrets/initialAdminPassword
```

3. Change Jenkins port to 8081
```
Open {jenkinsDirectory}\jenkins.xml and change --httpPort=8080 to --httpPort=8081
```

4. Restart Jenkins service
```
Open Windows services (win + r > services.msc), find Jenkins and restart it. After the restart the new Jenkins URL will be http://localhost:8081 
```

#### Installing Tomcat

1. Download Tomcat
```
https://tomcat.apache.org/download-80.cgi
```

#### Configuring Tomcat

1. Add and admin user
```
Open {tomcatDirectory}\tomcat-users.xml and edit it
<tomcat-users>
	<role rolename="manager-gui"/>
	<role rolename="manager-script"/>
	<user username="admin" password="admin" roles="manager-gui, manager-script"/>
<tomcat-users>
```

#### Installing Maven

1. Download Maven
```
https://maven.apache.org/download.cgi
```

2. Set environment variable
```
Edit Path environment variable in System variables and add your maven bin directory to it (e.g.: C:\Program Files\apache-maven-3.5.0\bin)
```

#### Firewall ports

To allow remote access to the applications, tomcat, jenkins... we need to open the port where the application is listening.


### 2. Creating a new task in Jenkins

- _Open a browser_ of your choice and navigate to
```
http://localhost:8081
```

- Login with your _user name_ and _password_

- Click on `New Item` (left panel)

- Enter `account-payment-settings` as task name (_or anything else you see fit_)

- Select `Freestyle project` as project type

- Click `OK`

- In the `Source Code Management` select `Git` and use the following URL as `Repository URL`
```
https://github.com/xApiOrg/account-payment-settings.git
```

- Scroll down and enable `Poll SCM`, then enter the following command
```
H/02 * * * *
```

- Finally, in the `Build pipeline` add the following steps

	- Invoke top-level Maven targets
	```
	generate-resources
	```
	
	- Execute Windows batch command
	```
	.\target\dockerfile\run_windows.bat /QT
	```
	
- Click `Save`

- After every Jenkins build the application will be restarted. To try the application navigate to 
```
http://<public-server-ip>:10001/ipay/account/100
```
>The default port is 10001.

