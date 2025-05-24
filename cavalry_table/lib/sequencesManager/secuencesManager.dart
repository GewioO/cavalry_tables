abstract class SecuencesBase {
    late List<String> _mTablesQueue;
    late String _mCurrentTable;
    late 

    void setTablesQueue(List<String> tablesPathes);
    void callNextTable();
    
    List<String> get items => _items;

    set items(List<String> newItems) {
        _items = newItems;
    }
}