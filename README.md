# mina-circle
A deployment wrapper for mina based, artifact deployment. Using Circle CI to build assets and mina to deploy the artifact asset directly on the webhost. 

## Setup

### Circle

Rename `circle-example.yml` to `circle.yml` 

Change name of the asset and build path.  (gruntfile, gulp, etc)

Example: 
```
general:
  artifacts:
    - "~/artifact_example.tar.gz"

machine:
  php:
    version: 5.6.2

test:
  override:
    - cd static && npm install
    - ./static/node_modules/.bin/grunt ci --gruntfile static/Gruntfile.coffee
    - tar --exclude=".git" -czvf ~/artifact_example.tar.gz .
```

### Mina Circle

Set circle username, project and artifact. 

    project = "your_circle_project"
    username = "your_circle_username"
    artifact = "artifact_example.tar.gz"


### Mina Deploy

Setup as normal, change `deploy.rb` to website setup specifications.

`deploy-ee-example.rb` has basic setup for EE projects.

## Running

Your circleci token is required. 

`ruby bin/mina-circle.rb -t CIRCLE_TOKEN`

You can specify the environment (default is staging). 

`ruby bin/mina-circle.rb -t CIRCLE_TOKEN -e production`
