# AWS-KMS-Test

## Purpose 

To help me understand how to get secrets into AWS KMS from GO pipelines utilising CloudKat to push values to AWS

---

## How it works

1. Have the secrets you want to access named in the metadata.json file
2. Have those secrets set as keys in GO against the values you wish to store
3. To store the keys use: `/bin/bash . aws-assume-role && bash save-secrets.sh` in your pipeline
4. To validate that the secrets were stored correctly use: `/bin/bash . aws-assume-role && bash launch-secrets.ps1` in your pipeline
5. This should output some simple test showing you the value of your secret you stored. 

|| N.B. Do not output values for secret variables! This is purely to verify this works...
