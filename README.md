###Goal of project

Interact with a tivo, to calculate how much can be stored in hours / space.  To make sure that what I want to record from the olympics will fit.
The tivo does not offer the to do list, so this has to be entered manually.
The tivo does allow curling for the shows that are on the tivo, how much space they take up, and channel, along with time that it took.

Pieces of the software have been developed in a tdd method using ruby, and Test Unit Test cases.  The goal would be to eventually switch to rspec testing.
A spike version of a web service has been developed to be used as a tivo mock, for integration testing to supply test data, that realistically mocks what tivo would return.
A mock for the Time.now function will be needed to fully integration test the software.

Eventually this will be ported to Android, possibly IOS.

This is still a very rough work in progress, with a deadline of the 2016 olympics for the ruby version of the app.

###Testing project

For each spec file in the spec folder, run ruby <spec filename.rb>

###Running project

Still building the project.  Most likely will call a script at specific intervals, and use tmux to show various files, and use watch to call the main program at defined intervals

### Input files

test.csv -- recordings that are scheduled to record.  It uses this to tell how much will be recorded for which channel and how long.  It uses the averages that it calculates from the tivo to forecast how much it wil take up.

### Generated files

averages.json -- right now contains json strings of channel, and gb's/hr.  Might change this to just the running total for last show recorded.

output.txt -- will be a file that can be cat'd  -- will show current percent used, and space and time.  Will show planned percent (total if all recordings from guide were recorded now)

