# kumuassessment
Persistence - UserDefaults
This is used because the model structure is not too complicated. It is also easier to implement on a simple feature like storing the favorite movies of the user. 

For the implementation of UserDefaults, the saving of data occurs whenever the user presses the favorite button (Both in the movie list table and the movie details view) which would update the list of favorite movies. Meanwhile, the loading of data occurs whenever the movie list table is loaded in the home view


Architecture - MVC
The structure used was Model-View-Controller as it can be easy to implement because it separates the responsibility of the model, view, and controller. Using this pattern, it is also easy to identify where to look and update the code when there is anything we have to add or fix.
