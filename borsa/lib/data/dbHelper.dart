import 'dart:async';
import 'package:borsa/models/product.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class dbHelper {
  Database _db;
  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    String dbPath = join(await getDatabasesPath(),"etrade.db");
    var eTradedb = await openDatabase(dbPath,version: 1,onCreate: createDb);
        return eTradedb;
      }
    
    void createDb(Database db,int version) async {
      await db.execute("Create Table products(id integer primary key,name text, description text,uniPrice integer)");
      }
      Future<List<Product>> getProducts() async{
        Database db = await this.db;
        var result = await db.query("products");
        return List.generate(result.length, (i){
          return Product.fromObject(result[i]);
        });
      }
      Future<int> insert(Product product) async {
        Database db = await this.db;
        var result = await db.insert("products", product.toMap());
      }
      Future<int> delete(int id) async {
        Database db = await this.db;
        var result = await db.rawDelete("delete from products where id = $id");
        return result;
      }
      Future<int> update(Product product) async {
        Database db = await this.db;
        var result = await db.update("products", product.toMap(), where: "id=?", whereArgs: [product.id]);
        return result;
      }
}
