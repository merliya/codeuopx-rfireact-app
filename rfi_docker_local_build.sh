AWS_ACCOUNT=331956410237
AWS_REGION=us-east-1

echo "================================================================="
echo "                  CodeArtifact Login                             "
echo "================================================================="
export CODEARTIFACT_AUTH_TOKEN=`aws codeartifact get-authorization-token --domain uop-domain --domain-owner $AWS_ACCOUNT --query authorizationToken --output text --profile codeartifact`

echo "AWS_ACCOUNT           :: $AWS_ACCOUNT"
echo "AWS_REGION            :: $AWS_REGION"
echo "CODEARTIFACT_AUTH_TOKEN    :: $CODEARTIFACT_AUTH_TOKEN"

echo "================================================================="
echo "                  Building Docker image                          "
echo "================================================================="

docker build -t uopx/rfi-react-app --build-arg CODEARTIFACT_AUTH_TOKEN=$CODEARTIFACT_AUTH_TOKEN --build-arg AWS_ACCOUNT=$AWS_ACCOUNT --build-arg AWS_REGION=$AWS_REGION .

echo "React Docker image build complete"