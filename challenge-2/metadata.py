import urllib.request as request
from urllib.error import HTTPError

def metadata_json(key="instance-id"):
    try:
        value = request.urlopen('http://169.254.169.254/latest/meta-data/' + key).read().decode()
    except HTTPError as err:
        if err.code == 404:
            print('You have entered wrong or non existing key')
        else:
            print('Error with the response: ' + str(err.code))
    return {key: value}

if __name__ == "__main__":
    print(metadata_json(input("Enter the key for ec2-metadata: ")))