# On The Map

"On The Map" is an iOS application developed as part of the Udacity iOS Development Nanodegree program. It uses MapKit, URLSession networking, JSON Serialization and Reachability in order to display the locations of Udacity students currently studying around the globe.

## Install

To check out my version of "On The Map":

1. Clone or download my repository:
` $ https://github.com/ginnypx1/On-The-Map.git `

2. Enter the "On the Map directory":
` $ cd /On-The-Map-master/ `

3. Open "On the Map" in XCode:
` $ open OnTheMap.xcodeproj `

## Instructions

The "On the Map" user will first be presented with a log-in screen that allows the user to either log-on to their account at Udacity, or click on a "Sign-Up" button that will allow them to create an account at Udacity.

Once a student is logged in, they will be shown a map of the world, with pins at the locations Udacity Students are currently studying. When the user clicks on a pin, they can see that student's name as well as a website the student would like to share. If the user then clicks on the pin's info tag, the student's website will open up in Safari.

The locations of current Udacity students can also be seen inside a table view, which displays each student's name and provided website in a list. When the user clicks on a table cell, the featured student's website will open in Safari.

A user can add their own location to the map by hitting the **+** button in the top right hand corner of both the table and the map views. The user can provide their location in the form of "City, State" and an interesting website in the "https://" or "http://" format. Once the user has entered this information, they will be shown a map to confirm their location, and once confirmed, their pin can be added to the world map.

A user can then modify their pin information (location and website) at any time.

## Technical Information

"On the Map" uses Udacity's login/logout authentication process as well as a student location API based on a Udacity-hosted Parse database.
