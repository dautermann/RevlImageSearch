Create a simple app in Swift that displays images from Microsoft Image Search API in a grid. Your end result should look something like this: 

![](http://i.imgur.com/0kuMzUm.jpg)

#### Requirements:

- When the user reaches the end of the grid, call the API again to load more items, and add the new items to the end of the grid (infinite scrolling).
- When the user taps a cell, show a fullscreen version of the image.
- If the user taps and holds on a cell, copy the image to the user's clipboard

#### Bonus 

- When in fullscreen mode, allow user to swipe forward and backward to get to next image.
- Add option to display animated gifs (hint: add `image-type=animategif` to the image search request)
- Anything else interesting you can think of. Surprise us!

#### API Details

API Introduction: 
https://www.microsoft.com/cognitive-services/en-us/bing-image-search-api 

API Documentation:
https://dev.cognitive.microsoft.com/docs/services/56b43f0ccf5ff8098cef3808/operations/56b4433fcf5ff8098cef380c

API Test Console:
https://dev.cognitive.microsoft.com/docs/services/56b43f0ccf5ff8098cef3808/operations/56b4433fcf5ff8098cef380c/console

API Key: 
`a6738e4c135542229c8e5c5d8a697c69`

Sample curl: 
`curl -i -H "Ocp-Apim-Subscription-Key: a6738e4c135542229c8e5c5d8a697c69" https://api.cognitive.microsoft.com/bing/v5.0/images/search?q=snowboarding&count=50&offset=0&mkt=en-us&safeSearch=Moderate`

Use any keywords you like to grab images, ie "Kite Surfing", "Snowboarding", "Golden Doodle". Use the API key above as the value for the `Ocp-Apim-Subscription-Key` header. The keys `thumbnailUrl` and `contentUrl` may prove useful for displaying images.

#### Code Structure

Use any libraries/tools you need as you see fit. You will not be penalized for including or failing to include a library, but be prepared to justify a library’s inclusion.

Please organize the project like you would a real app and use best practices for organization. Code structure and style counts.

#### Time Limit

Time limit is __2-4 hours__ (you may not finish). If you have any problems with dev environment/etc (API being down, wifi problems, etc), please tell me ASAP and we'll pause the clock until resolved. 

#### How to submit

Push to a public github, bitbucket or gitlab repository and email us with that url. Feel free to provide any detail about your implementation.

Good luck!
