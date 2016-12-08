How to build / run

cd src
mirage configure -t unix --kv_ro crunch --net socket
make
./mir-www
