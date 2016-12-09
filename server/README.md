# How to build / run

   * cd src
   * mirage configure -t unix --kv_ro crunch --net socket
   * make
   * ./mir-www

# How to extend

Add a matcher to the dispatch function in dispatcher.ml
Create a new controller module that handles functions defined in the Controller module type.
