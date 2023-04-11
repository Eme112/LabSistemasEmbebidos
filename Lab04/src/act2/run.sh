echo "as -o $1.o $1.s"
as -o $1.o $1.s
echo "gcc -g -o $1 $1.o"
gcc -g -o $1 $1.o
echo "./$1"
./$1