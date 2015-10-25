## Tessa(Hyeri)
* ~~Turn importers into scrapers~~
* ~~Put scrapers into scraper module~~
* ~~Add categories attribute into Articles~~
* ~~Find a gem for tagging, searching, emails, etc.~~
* ~~Complete tag module with 5 different tagging classes~~
* ~~Do compiling and emailing functionality~~
* ~~Create admin controller dealing with the two admin urls~~*


## Nihal
* ~~Add The Age importer~~
* ~~Change DateTime from string to DateTime~~
* ~~Fix Date import bug?~~
* ~~Double check regex~~
* ~~Add administrator URL pages~~
* ~~Change async coroutines back to standard (db can't handle it)~~
* Move db commits to end of transaction loops
* Paginate articles (5 per page)
* ~~Find a gem for tagging, searching, emails, etc.~~

## Lina
* Change the registration page, remove 'interests'
* Add 'interests' into profile editing view, instead of new profile view
* Add a checkbox for toggling email preferences in a user profile.
* Make usernames unique
* Work on UI stuff, frontend
* Find a gem for tagging, searching, emails, etc.

## Others
* Add emailing functionality
	* Make new models for User, Email, Address and Articles
	* Store every single email sent, and every single article sent
	* 'Mandrill' gem is recommended

* Add searching functionality
	* Add keywords weightings for search relevance

* Run code through rubocop (AFTER EVERYTHING ELSE IS IMPLEMENTED)
