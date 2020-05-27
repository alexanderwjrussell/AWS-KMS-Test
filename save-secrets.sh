error() {
  echo "An error occured"
  echo $key "was not found"
  exit 1
}
trap error ERR

# Parse secret_env_vars out of metadata.json and store as an array variable
secrets=$(cat metadata.json | jq -r .secret_env_vars[])

# Loop through each key in the secrets array, obtain the value and use cloudkat to save to aws
for key in ${secrets[*]}; do
  value=$(printenv $key)
  echo "Saving $key secret"
  ./cloudkat secret save -m metadata.json -e $ENVIRONMENT -n $key -s $value
done