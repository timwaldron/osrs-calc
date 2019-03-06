<p align="center">
  <img width="1050" height="250" src=./docs/osrs.jpg></p>
  
<h1 align="center"> 
Oldschool RuneScape Buddy
</h1>
<br>

## Project Outline

The Old School RuneScape Buddy was built as a terminal application in order to meet the requirements of the first assignment given at CoderAcademy.

The Buddy will be an interactive application that allows players of RuneScape to bring down their player data, make calculations and take notes.

[What is Old School RuneScape?](https://oldschool.runescape.wiki/w/Old_School_RuneScape)<br>
[GitHub Repository](https://github.com/timwaldron/osrs-calc)<br>

### Instructions for use

1. Login with RuneScape username
2. Choose option
3. View skills / Calculate skill / Take notes
4. Return to menu screen
5. Choose a different option / Exit application
6. Enjoy playing RuneScape
7. Go outside

### Who Its For

Old School RuneScape Buddy is for any individual that plays the game RuneScape. Simply enter your name and use the Buddy as a companion as you "Scape"

### How It Works
The Old School RuneScape Buddy works by utilising the Net/HTTP gem which can collect data from the from RuneScape's API, then run calculations based on the data it received (Data received is parsed in either CSV or JSON form, so the project has utilised those gems as well). A user can enter their in-game-name and it will extract data from the hiscores and sort it into usable data for calculations and bragging-rights. The calculations require two things; a copy of a users hiscore data (which will validate before you can continue to the calculators) and a folder in your current working directory labeled 'calc_data' that contains a list of skill data in a CSV format. If you don't have the 'calc_data' directory or each skill in the array **@available_calcs** listed in **skill_calcs.rb** CSV file it will pull it from the master branch of this repository. You are able to customise the CSV files to include training methods that my be unpopular (E.g Anchovy Pizzas, Lava Eels, Bread, etc), due to these files only including popular training methods to cut down on terminal spam. OSRS Buddy also utilises the I/O functionality of Ruby by offering a 'notebook', where you can record/save/delete notes or goals directly to your local machine!

### Please note

The current version of Old School Runescape Buddy is capable of downloading a user's hiscore data which is freely accessible to anyone via the hiscore web page (https://secure.runescape.com/m=hiscore_oldschool/overall.ws). OSRS Buddy doesn't send or store the data it retrieves for you and will be disposed of after exiting the terminal application. It does however have the ability to add/delete notes, which are stored locally on your machine. There's an option to delete this only instance of the file within the application or manually by deleting **notebook.txt** out of the current working directory of where you ran this script.<br>

A moral implication may arise when using the Buddy due to users wanting to reach their entered goals. Their health may be negatively impacted due to lack of physical activity.
For example if a user of the Buddy calculated they needed to fish 13004 to get to their desired Skill Level of 80 and proceeded not to leave their computer for 12 hours.

### Why we did what we did
As both collaborators of this project have been heavy Old School RuneScape players at one point or another during their lives this idea for a terminal app seemed more appropriate by the second while brainstorming ideas. 

### Note to Future Developers

With the vision to continue this project on we both come to the conclusion that we should plan/write our code with futureproofing in mind. Specifically in the **skill_calcs.rb** file where we've gone ahead and added redundancy for by not hard-coding additional skill calculators.

### How Everything Went

As this project was planned out thoroughly and both having quite extensive knowledge about Old School RuneScape we didn't come across any roadblocks that made us defer our original goals. We ran into the usual teething issues regarding data-type, parse that data between modules and the most efficient way to handle redundancy. We did however decide on changing the projects name from Old School RuneScape Skill Calculator to Old School RuneScape Buddy, as our vision of this project changed from a skill calculator to a one-stop-shop for all your OSRS needs.

### Workflow

Separate files were used, not only to organise the code but also to enable seamless collaboration. While working in different files we found there was less conflicts to resolve and enable a more productive work.

During this project we ensured to make use of the webapp Trello, it was both of our first times using it. We found it smooth and seamless; improving both productivity and enjoyment.

Github was another technology utilised to manage workflow. Initially the process seemed clunky and unintuitive. After making our first 20 commits within the first hour we saw the value of the system and have used it extensively during this project.

# Screenshots 

<h2 align="center"> 
Initial Planning
</h2>
<p align="center">
  <img width="250" height="250" src=docs/planning.jpg>
  <img width="250" height="250" src=docs/planning1.jpg>
  <img width="250" height="250" src=docs/planning2.jpg>
</p>

<p align="center">
  <img width="250" height="250" src=docs/planning3.jpg>
  <img width="250" height="250" src=docs/planning4.jpg>
</p>


<h2 align="center"> 
Slack Communications
</h2>
<p align="center">
  <img width="250" height="250" src=docs/slack1.png>
  <img width="250" height="250" src=docs/slack2.png>
</p>


<h2 align="center"> 
Trello Use
</h2>
<p align="center">
  <img width="250" height="250" src=docs/trello1.png>
  <img width="250" height="250" src=docs/trello2.png>
</p>

<p align="center">
  <img width="250" height="250" src=docs/trello3.png>
  <img width="250" height="250" src=docs/trello4.png>
</p>
