 Python application running on a Linux server that needs to be containerized using Docker. The goal is to create a Dockerfile that includes the necessary steps to install Python and the required dependencies, copy the application into the container, configure it to run on startup, and expose the required ports for external access.
In this project, we will containerize a simple python application using docker. We will go through the steps below.

Deploy the application on a Linux machine

Write the Dockerfile using an Ubuntu base image 

write the Dockerfile using a python base image.

 

A- Deploy the application on a Linux machine ( it can be running anywhere, aws lightsail, aws ec2, Linode server or on-prem servers).
This section will explain how we can run the application without using docker, then in the latter part of the tutorial we will be using docker to run the application.

 

Step1- Installing Environment dependencies
Here, we will install the dependencies that our application requires to run.

Installing python  and pip3


Run the command below to install Python.



sudo apt update 
Now install python3 



sudo apt install python3 -y
once it's installed, we will go ahead and install python3-pip

Run the command below to install python3-pip



sudo apt -y install python3-pip 
we are done with the Environment dependencies, let's go ahead and clone the application from GitHub.

Step2- Clone the Application from GitHub
To clone the application from GitHub, which is equivalent to copying the application code to our server, run the command below.



git clone https://github.com/utrains/bookshopflaskapp.git
Once the code is cloned, move into the application directory.



cd bookshopflaskapp
Step3- Install application base dependencies
here, we will install the dependencies needed for the application to run. The list of the dependencies should be provided by the developer.



pip3 install -r requirements.txt
If you get the following warning message, use this command to fix it:

Open image-20240306-221609.png
image-20240306-221609.png


export PATH=$PATH:$HOME/.local/bin
After installing the dependencies, we need to expose the port needed by the application to run. In this case, our application runs on port 5000 

note that all of these details are given to you in a meeting with the developer.

Step4- Exposing port
We will be Exposing Port 5000  as it is the port needed by our application.

exposing ports varies from one provided to another. For example, if you are on EC2 you will use security groups, if you are on Google VMs, you will use Google firewalls etc.

if you are running on a centos7 / redhat7 on-prem, you can below command to do it.



firewall-cmd --permanent --add-port=5000/tcp
firewall-cmd --reload 
and if you are on Ubuntu or Debian, then run this instead



sudo ufw allow 5000/tcp
sudo service ufw restart
Step5- Start the application.
To start the application, make sure you are in the application directory



cd ~/bookshopflaskapp
Now, run the command below: 



flask run --host=0.0.0.0
once the application is running, copy the public  IP Address of your instance and paste it into the browser on port 5000

public-ip-address:5000.

Now that we are done installing on a physical server, let's go ahead and create a docker image that we will use to launch the same application.

The idea behind this is for you to see how you can convert and application running on a Linux server to run on a container by simple following the steps we used to deploy the application on a virtual machine but this time around on a docker file.

B- Deploying the application using Docker.
Before starting this section, make sure your docker lab is running, and you are in your docker server. Here is the link to the lab setup 

 

In this section, we are going to write two docker files, one with a Python base image, and another with an Ubuntu base image.

B-1 Ubuntu base image.
In this section, we will show the equivalence of the various steps above (deploying in a Linux server), with the steps used in the Dockerfile.

Before that, below is the docker file.



FROM ubuntu:20.04
RUN apt update
RUN apt install python3 -y
RUN apt -y install python3-pip
WORKDIR /app
COPY . /app
RUN pip3 install -r requirements.txt
EXPOSE 5000
CMD ["flask" , "run" ,"--host=0.0.0.0"]
Now let's explain the various steps.

Step1- base image 


FROM ubuntu:20.04
In this step, we are specifying the base image we want our application to run on. This step is the same as creating a light sail instance, or a virtual machine running Ubuntu 20.04. 

Step2 - install environment dependencies. 
This step spans line 2 to line  4 on the docker file. This step is equivalent to   step 1 in section A

in this step, we install the various environmental dependencies in our container.

Step3 - Copy application files
this step spans from line 5 to line 6 on our Dockerfile above

In this step, we copy all the application files into our working directory inside the container. This step is equivalent to step 2  in section A.

Step4 - Install application requirements


RUN pip3 install -r requirements.txt
This section installs the application base requirements, which is equivalent to step 3 In section A.

Step5 - Exposing the port


EXPOSE 5000
In this step, we will expose the port needed by the application to run using the EXPOSE command in docker. Which is port 5000. 

This step is equivalent to step 4 in section A.

Step5 - Start the application 


CMD ["flask" , "run" ,"--host=0.0.0.0"]
This step specifies the command to run when starting our container. This step is equivalent to step 5 in section A.

We can now relate how we converted the steps we use in running the application on a virtual machine to a docker file to run in a container.

Let's now go ahead and build our image, then run it.

Building and running the docker image 
 

make sure you are in your docker lab server.

Clone the project from GitHub 



git clone https://github.com/utrains/bookshopflaskapp.git
After cloning the project, move into the project Directory and create the  Dockerfile.



cd bookshopflaskapp
Create the Dockerfile and paste the docker file code above in it.



vi Dockerfile
Save and quit.

Now run the below to build the image.



docker build -t pythonapp .
Open image-20230529-172500.png

 

Once the build is done,

Run the application.



docker run -d  -p 8060:5000 pythonapp 
 Paste the IP address of your instance on port 8060 on the browser.

You will get the output below.

Open image-20230529-172933.png

Congratulations, you just deployed  your application using docker.

We have created and run a docker image based on the Ubuntu base image, let's create another image using Python as base image.

B-2 Python base image.
The Advantage of using Python as a base image is that it comes with python3 and python3-pip installed. So this saves us the stress of executing step 2 in section B-1 above and saves us more time. 

Below is the docker file



FROM python:3.9-slim-buster
WORKDIR /app
ADD . /app
RUN pip3 install -r requirements.txt
RUN export FLASK_APP=app.py
RUN export FLASk_ENV=development
EXPOSE 5000
CMD ["flask" , "run" ,"--host=0.0.0.0"]
Go ahead and run the Dockerfile.

That said, you should have in mind that before writing a docker file to deploy an application, you should know how the application is deployed. Remember to always work with the developer to get a better understanding of the functioning of the application.  
