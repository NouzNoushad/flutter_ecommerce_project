import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MyDb {
  Database? db;
  Future open() async {
    // --> mysql database with emulator

    // var databasePath = await getDatabasesPath();
    // String path = join(databasePath, 'demoPro.db');
    // print(path);

    // db = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
    //   await db.execute(
    //     '''
    //       CREATE TABLE products (
    //         id integer primary key autoIncrement,
    //         image varchar(255) not null,
    //         productName varchar(255) not null,
    //         productWeight varchar(255) not null,
    //         price int not null
    //       );
    //     '''
    //   );
    //   print('products table created');
    //   await db.execute(
    //       '''
    //       CREATE TABLE favorites (
    //         id integer primary key autoIncrement,
    //         image varchar(255) not null,
    //         productName varchar(255) not null,
    //         productWeight varchar(255) not null,
    //         price int not null
    //       );
    //     '''
    //   );
    //   print('favorites table created');
    //   await db.execute(
    //       '''
    //       CREATE TABLE users (
    //         id integer primary key autoIncrement,
    //         username varchar(255) not null,
    //         email varchar(255) not null,
    //         password varchar(255) not null
    //       );
    //     '''
    //   );
    //   print('users table created');
    // });

    //  --> desktop version for connecting mysql

    sqfliteFfiInit();
    var databasePath = await databaseFactoryFfi.getDatabasesPath();
    String path = join(databasePath, 'productDemo.db');
    DatabaseFactory databaseFactory = databaseFactoryFfi;
    print(path);
    db = await databaseFactory.openDatabase(path,
        options: OpenDatabaseOptions(
            version: 1,
            onCreate: (Database db, int version) async {
              await db.execute('''
          CREATE TABLE products (
            id integer primary key autoIncrement,
            image varchar(255) not null,
            productName varchar(255) not null,
            productWeight varchar(255) not null,
            price int not null
          );
        ''');
              print('products table created');
              await db.execute('''
          CREATE TABLE favorites (
            id integer primary key autoIncrement,
            image varchar(255) not null,
            productName varchar(255) not null,
            productWeight varchar(255) not null,
            price int not null
          );
        ''');
              print('favorites table created');
              await db.execute('''
          CREATE TABLE users (
            id integer primary key autoIncrement,
            username varchar(255) not null,
            email varchar(255) not null,
            password varchar(255) not null
          );
        ''');
              print('users table created');
            }));
  }
}
