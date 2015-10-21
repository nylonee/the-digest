** Installation Instructions (via terminal) **
```
mkdir ~/Workspace
cd ~/Workspace
git clone https://<YOURUSERNAME>@bitbucket.org/nylonee/the-digest.git
cd ~/Workspace/the-digest
```
Note: Replace <YOURUSERNAME> with your bitbucket username!

** Deployment Instructions (via terminal) **
```
bundle install
rake db:drop db:create db:seed db:migrate
rails s
```