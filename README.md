# kpmg-test

### Challenge-1
You can find all the resources related to challenge 1 in the challenge-1 folder
The basic 3 tier architecture diagram can be seen in the draw.io file where we would potentially have an ALB that
fronts a fleet of EC2 instances that host the front end UI app managed by an ASG for scalability which in turn connects with another fleet of
backend EC2 instances managed by another ASG. Optionally, we could have an internal load balancer manage this when connecting from the UI app.
This backend then securely connects with an RDS instance deployed to the private subnet which only allows the connection from the backend nodes

In order to maintain reproducibility, I have gone with using terraform for the solution


### Challenge-2
You can find the code for getting the desired metadata from the ec2 instance in the challenge-2 folder.
Pre-requisites for running this would be as below:
You copy the python script in the ec2 along with the Makefile in the root dir
Run the command: "make setup-python-packages-and-run-challenge-2"

This should install the virtual env and setup packages if they aren't already installed and execute the script

When it executes, it would ask for a user-input:
e.g. Enter the key for ec2-metadata: instance-id
Output: {'instance-id': 'i-0c4ac3495897e8d66'}

###Challenge-3
The code and the unit test cases can be found in the challenge-3 folder
You can execute the tests from the root dir using the make command:
make run-challenge-3-test

That should execute the unit tests