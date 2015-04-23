# mina-circle

>Look ma' No more building assets on my web server!

A plugin for [Mina](https://github.com/sparkbox/mina-circle) to deploy pre-built
artifacts from CircleCI.

## Why?

Modern web applications depend on a lot of tools to prepare their static
assets. For varying reasons, having those tools installed on a production server
(or, really, any publicly available server) is undesirable. It adds to the
maintenance cost of the server, it increases the time it takes to complete a
deployment, and some tools might even be a security risk. These issues can be
mitigated to some extent by bundling up your application in private and pushing
that artifact into the public. This gem is a first step in making that path
happier.

## Setup

Add `mina` and `mina-circle` to your Gemfile:

    source 'http://rubygems.org'

    gem 'mina'
    gem 'mina-circle'

Once you have that, go to your [CircleCI Account
Page](https://circleci.com/account/api) and create an API token (if you don't have
one already). Create a new file named `.mina-circle.yml` in your home directory
and add an entry for `token`:

    token: your_circle_ci_token

If the plugin cannot find an API token the deploy will fail.

### Mina Configuration
Once the gem is installed, require it into Mina's `config/deploy.rb` and set
each configuration option. They are all required.

    require 'mina-circle'

    # Basic Mina requirements probably live here...

    set :circle_user, 'username' # Your Username with CircleCI
    set :circle_project, 'project_name' # Name by which CircleCI knows your project
    set :circle_artifact, 'artifact.tar.gz' # Name that you configured CircleCI to call your build archives
    set :circle_explode_command, 'tar -mzxf', # Command with options for decompressing the artifact archive

    # Other configuration probably lives here...

    task :deploy => :environment do
      deploy do
        invoke 'circleci:deploy'
        launch do
          # mina-circle itself doesn't require any launch steps. Your particular
          # app might though.
        end
      end
    end

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

