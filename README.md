** Deployment Instructions **
```
mkdir ~/Workspace
cd ~/Workspace
git clone git@bitbucket.org:nylonee/the-digest.git
cd ~/Workspace/the-digest
bundle install
rake db:create
rake db:seed
rake db:migrate
rails s
```
