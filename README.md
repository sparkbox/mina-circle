# mina-circle

>Look ma' No more building assets on my web server!

A plugin for [Mina](https://github.com/sparkbox/mina-circle) to deploy pre-built
artifacts from CircleCI.

## Setup

Add `mina` and `mina-circle` to your Gemfile:

    source http://rubygems.org

    gem 'mina'
    gem 'mina-circle'

Once you have that, go to your [CircleCI Account
Page](https://circleci.com/account/api) and create an API token (if you don't have
one already). Create a new file named `.mina-circle.yml` in your home directory
and add an entry for `token`:

    token: <replace this with your CircleCI API token>

### Mina Configuration
Once the gem is installed, require it into Mina's `config/deploy.rb`.

    require 'mina-circle'

#### circle_token
API access token. By default this is taken from ~/.mina-circle.yml if it exists.

#### circle_user
Your Username with CircleCI.

#### circle_project
Name by which CircleCI knows your project.

#### circle_artifact
Name that you configured CircleCI to call your build archives.

#### circle_explode_command
Command with options for decompressing the artifact archive

### CircleCI Configuration
Change name of the asset and build path.  (gruntfile, gulp, etc)

    general:
      artifacts:
        - "~/artifact_example.tar.gz"

    test:
      override:
        - cd static && npm install
        - ./static/node_modules/.bin/grunt ci --gruntfile static/Gruntfile.coffee
        - tar --exclude=".git" -czvf ~/artifact_example.tar.gz .

