module minima.core.biarray;

struct Biarray(ElementType)
{
    public
    {
        this(int rows, int columns, ElementType fill)
        {
            _rows = rows;
            _columns = columns;
            _data.length = _rows * _columns;
            foreach (ref element; _data)
                element = fill;
        }

        this(immutable Biarray!ElementType otherArray) immutable
        {
            _data = otherArray._data.idup;
            _rows = otherArray._rows;
            _columns = otherArray._columns;
        }

        bool isValidIndex(int i, int j) const
        {
            return 0 <= i && i < _rows && 0 <= j && j < _columns;
        }

        ref ElementType opIndex(int i, int j)
        in
        {
            assert(isValidIndex(i, j));
        }
        do
        {
            return _data[j + i * _columns];
        }

        ElementType opIndex(int i, int j) const
        {
            return _data[j + i * _columns];
        }

        int opApply(scope int delegate(int i, int j, ref ElementType element) dg)
        {
            for (int i = 0; i < _rows; i++)
                for (int j = 0; j < _columns; j++)
                    if (int result = dg(i, j, this[i, j]))
                        return result;
            return 0;
        }

        int opApply(scope int delegate(ref ElementType element) dg)
        {
            foreach (ref element; _data)
                if (int result = dg(element))
                    return result;
            return 0;
        }

        ulong rows() const
        {
            return _rows;
        }

        ulong columns() const
        {
            return _columns;
        }
    }

    private
    {
        ElementType[] _data;
        ulong _rows, _columns;
    }

    invariant
    {
        assert(_data.length == _rows * _columns);
    }
}
