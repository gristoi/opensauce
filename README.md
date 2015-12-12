# Opensauce ( NOW CALLED FUDI :) )

## This is my final app for the Udacity swift nanodegree.

When i started building this app i originally called it opensauce but it eveolved over time into Fud. It is a recipe scrapbook app that allows you to search for recipes and store the ones you like for future use.
The app is broken into 3 main sections :

## Note: I have used cocoapods to handle my package / dependancy management
Please ensure you run the following command in the project root via a terminal window:

`pod install`

This will install the swifty json, reachability and alamo fire dependancies. Then open the Fudi.xcworkspace file NOT the normal project file!

###registering
If this is your first time using the app then you will need to register a new account on the app. to do this you need to click on the register now button on the login page. this will direct you to the register page. Complete your details and submit. You will then be asked to login

![searching](https://github.com/gristoi/opensauce/blob/master/walkthrough/register.png "Registering")

###explore
From here you can either search for recipes directly using the search bar, or click on one of the collection sites to go to the main recipe sites.

![searching](https://github.com/gristoi/opensauce/blob/master/walkthrough/search.png "Searching for a recipe")

###saving a recipe
When you find a recipe that you like you can tap on the save button on the bottom of the search results window. This will attempt to save the recipe for you, and if it cannot the you will be asked if you want to save it as a bookmark

![searching](https://github.com/gristoi/opensauce/blob/master/walkthrough/save.png "Saving a recipe")

###saving a bookmark
When you select to bookmark your recipe you will be asked to add a title and select an image that relates to your recipe

![searching](https://github.com/gristoi/opensauce/blob/master/walkthrough/bookmark.png "Bookmark a recipe")
![searching](https://github.com/gristoi/opensauce/blob/master/walkthrough/openbookmark.png "Bookmark a recipe")


###recipes
The recipes list from the main menu will show you all recipes that could be saved from the recipe search. All other recipes that could only be bookmarked will show in the bookmark controller

###bookmarks
If the app cannot save the recipe directly it will let you bookmark the page you are on. All of your bookmarks will be saved here for viewing
