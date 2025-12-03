docker run -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/src alpine/helm:3.19.0 package /src/$1 --app-version $2 --version $VERSION -d /src
