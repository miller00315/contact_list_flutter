import 'package:contacts/db/entities/contact.dart';
import 'package:contacts/helpers/contact_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ContactRepository {
  static final ContactRepository _instance = ContactRepository.internal();

  factory ContactRepository() => _instance;

  ContactRepository.internal();

  Database _db;

  Future<Database> get db async {
    if (_db == null) _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    final dataBasesPath = await getDatabasesPath();

    final path = join(dataBasesPath, 'contacts.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newerVersion) async {
        await db.execute(
            "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imageColumn TEXT)");
      },
    );
  }

  Future<Contact> save(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());

    return contact;
  }

  Future<Contact> read(String id) async {
    Database dbContact = await db;

    List<Map> maps = await dbContact.query(
      contactTable,
      columns: [idColumn, nameColumn, phoneColumn, emailColumn, imageColumn],
      where: '$idColumn = ?',
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    }

    return null;
  }

  Future<int> delete(int id) async {
    Database dbContact = await db;
    return await dbContact.delete(
      contactTable,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Contact contact) async {
    Database dbContact = await db;

    return await dbContact.update(
      contactTable,
      contact.toMap(),
      where: '$idColumn = ?',
      whereArgs: [contact.id],
    );
  }

  Future<List<Contact>> list() async {
    Database dbContact = await db;

    List listMap = await dbContact.rawQuery('SELECT * FROM $contactTable');

    List<Contact> listContact = List();

    for (Map m in listMap) {
      listContact.add(Contact.fromMap(m));
    }

    return listContact;
  }

  Future<int> getNumber() async {
    Database dbContact = await db;

    return Sqflite.firstIntValue(
      await dbContact.rawQuery('SELECT COUNT(*) FROM $contactTable'),
    );
  }

  Future close() async {
    Database dbContact = await db;
    dbContact.close();
  }
}
