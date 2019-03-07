# Text MARVEL Combat Arena

This Rails app works like this for the user:

1. The user (or two users battling against each other) will provide 2 character names to do battle in the arena
2. The user will provide a SEED number between 1-9
3. The API call to the Marvel universe will retrieve the bio for each character and parse the “description” field
4. The WORD in each description corresponding to the provided SEED is identified
5. The winner of the battle is the character whose WORD has the most characters EXCEPT if either character has a MAGIC WORD “Gamma” or “Radioactive” they automatically Win
6. Present the winning character to the user


Things I need to remember about the Marvel API rules:
1. Add this in a partial layout for each view with the data from the API: "Data provided by Marvel. © 2014 Marvel"
2. If I use significant data I need to link the entity back to its URL

Other:
1. Handle any errors or edge cases and display the message in a user friendly manner
2. Provide clear instructions on how to retrieve and run your code

## Notes on what happened when I was making this
It was hard to get the logic to work at first for the winner with the special magic word exceptions. I ran into some syntax issues but got through them and made sure that it was accounted for when there was a 'draw'.

The errors for edge cases were the last difficulty here. There are characters without descriptions, so I made it so they could win instead based on length of the first comic's title in that case. If there wasn't a comic title, I created error messages for the user to re-try. Turns out there were a lot of different scenarios, like characters with returned empty data, etc. I enjoyed sifting through all the edge cases and I am not entirely sure I have yet caught them all.

I wanted to use Postman to look at the hashes I was calling in the Marvel API so I didn't have to go into pry every time to check the returned hashes. It helped a lot, but it was really hard to get the MDN digest to work in Postman on the hash parameter. I went to a meetup during this project development and someone ended up helping me get Postman to work on the Marvel API.

I thought of a lot of great ways this could be refactored and improved upon to be a fun app. I want to make it so there are sessions that can help the players' choices persist through the controller with different views for the winner so there's a bit of suspense before the winner is shown.

After the app was working, I felt the code was unattractive and hard to read, so I started refactoring it with helper methods first. You can find some of these new methods in the characters helper method file. With more time I'd want to refactor it even more.

3.7.19 update:
I am starting to make a way for players to log in and accumulate points. Maybe the computer can randomly generate a character to play against, or maybe two players can log in or maybe one session just always has the same two players.

## Why I loved working on this so much
I learned a ton about calling APIs through working on this. I already had worked with APIs from Foursquare and Github, but it was so fun working with Marvel because the documentation was so well written, and the content was right up my alley!

I just loved how I assumed every really hard part I was stuck on, such as displaying the error messages, would take me an entire day to figure out, but when I found the answer through reading Ruby documentation is was such a quick move ahead to the next thing! Always re-assuring that the answer is indeed out there and it just takes persistence to find it.

## To do (in order):
- [x] - Set up the API call using Faraday
- [x] - Set up a form where the users put in the names of two characters and a seed number
- [x] - create a list of characters either to browse or create a dropdown to choose from
- [x] - make the logic in the controller where the system decides who won based on number of characters
- [x] - display the winner
- [x] - The winner of the battle is the character whose WORD has the most characters EXCEPT if either character has a MAGIC WORD “Gamma” or “Radioactive” they automatically Win
- [x] - Create a case where both players have the magic word
- [x] - Handle any errors or edge cases and display the message in a user friendly manner, such as the names weren't entered or the name couldn't be found in the database
- [x] - refactor the code into helper methods to make more readable
- [x] - create a login and sessions so the player can go between views and controllers (in progress)
- [ ] - add cool front end features like displaying the image of each character (extra)
- [ ] - Make players able to accumulate points and see them on their dashboard

## How to start and run this

clone this repo
run bundler
start the rails server
you will need to insert your own Marvel API key in the controller code before starting, which you can get at https://developer.marvel.com/account, just replace ENV[public_key] and ENV[private_key] with yours in the characters controller.
Go to the root route, localhost:3000, which takes you directly to the 'play' view.
Have fun!

## Ruby version

Ruby 2.5.3
