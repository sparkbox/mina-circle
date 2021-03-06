# mina-circle

>Look ma' No more building assets on my web server!

A plugin for [Mina](https://github.com/mina-deploy/mina) to deploy pre-built
artifacts from CircleCI.


[![Gem](https://img.shields.io/gem/v/mina-circle.svg)](https://github.com/sparkbox/mina-circle)

Now supports CircleCI version 2.0 Workflows! If your CircleCI 2.0 build has only one job it likely
does not use workflows. If you find that your builds do not use workflows stick with version 1.4.2
of this gem.

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

    # config/deploy.rb
    require 'mina-circle'

    # Basic Mina requirements probably live here...

    set :branch, ENV['branch'] || 'master' # Your specifc git branch to deploy
    set :circleci_user, 'username' # Your Username with CircleCI
    set :circleci_project, 'project_name' # Name by which CircleCI knows your project
    set :circleci_artifact, 'artifact_example.tar.gz' # Name that you configured CircleCI to call your build archives
    set :circleci_explode_command, 'tar -mzxf' # Command with options for decompressing the artifact archive
    set :circleci_job_name, 'build' # Name of workflow job

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

### CircleCI Configuration - circle.yml
Change name of the asset and build path.  (gruntfile, gulp, etc)

    # circle.yml
    general:
      artifacts:
        - "~/artifact_example.tar.gz"

    test:
      override:
        - cd static && npm install
        - ./static/node_modules/.bin/grunt ci --gruntfile static/Gruntfile.coffee
        - tar --exclude=".git" --exclude="node_modules" -czvf ~/artifact_example.tar.gz .

## Running

To deploy you'll run `mina deploy`

To deploy a specific branch, run `mina deploy branch=your_feature_branch`

### Continuous Deployment

For successful builds, CircleCI has an optional deployment step which it can run after it builds your artifacts. This example will result in CircleCI executing a deploy each time it successfully builds the `master` branch.

    # circle.yml
    deployment:
      test:
        branch: master
        commands:
          - mina deploy

#### API Permissions

Once this runs, mina-circle will be calling back into CircleCI's API and will require a token. Since it's running on their servers, not your own computer, you'll need to supply one to the project configuration on CircleCI. In your CircleCI project's settings:
- Click `API permissions` under `Permissions`
- Enter a value for `Token label` and click `Create token`
- Copy the token string
- Click the `Environment variables` section under `Tweaks`
- Enter `MINA_CIRCLE_TOKEN` for the variable name, and the value is the token you copied in the previous step

#### SSH Access

Now running remotely, CircleCI will need a private key which works to access your server. [Permissions and access during deployment](https://circleci.com/docs/permissions-and-access-during-deployment) describes setting this up on both CircleCI and your server.

#### Not Enough?

Depending on how you have Mina configured, you may want to investigate [mina-multistage](https://github.com/endoze/mina-multistage) to target specific environments for this task. Also, CircleCI's deployment phase offers many more features than what this simple example covers. Read [this section](https://circleci.com/docs/configuration#deployment) of their configuration guide to learn more about how to use it.
