deprecated module minima.math.arrayindex;

ref T biArrayAt(T)(T[] arr, uint rows, uint columns, int i, int j)
in
{
    assert(rows > 0 && columns > 0);
    assert(biArrayIsValid(rows, columns, i, j));
    assert(arr.length == rows * columns);
}
do
{
    return arr[biArrayIndexOf(rows, columns, i, j)];
}

int biArrayIndexOf(uint rows, uint columns, int i, int j)
in
{
    assert(rows > 0 && columns > 0);
    assert(biArrayIsValid(rows, columns, i, j));
}
out (result)
{
    assert(0 <= result && result < rows * columns);
}
do
{
    return j + i * columns;
}

bool biArrayIsValid(uint rows, uint columns, int i, int j)
in
{
    assert(rows > 0 && columns > 0);
}
do
{
    return 0 <= i && i < rows && 0 <= j && j < columns;
}
