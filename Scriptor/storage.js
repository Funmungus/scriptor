
function localStorage() {
	return LocalStorage.openDatabaseSync("Scryptor", "0.1", "List of Scripts");
}

function initDb() {
	var db = localStorage();
	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS scripts(id INT UNIQUE, name TEXT, command TEXT, icon TEXT);');
	});
}

function initDb(idCount) {
	var db = localStorage();
	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS scripts(id INT UNIQUE, name TEXT, command TEXT, icon TEXT);');
		tx.executeSql('DELETE FROM scripts WHERE id>=?;', [idCount]);
	});
}

function script(id) {
	var db = localStorage();
	var defaultValue = {id: 0, name: "", command: "", icon: ""};
	var res = defaultValue;
	try {
		db.readTransaction(function(tx) {
			var rowSet = tx.executeSql('SELECT * FROM scripts WHERE id=?;', [id]);
			if (rowSet.rows.length > 0) {
				res = rowSet.rows.item(0);
			}
		});
	} catch (err) {
		console.log("Database " + err);
	};
	return res;
}

function setScript(id, name, command, icon) {
	var db = localStorage();
	var res = "";
	db.transaction(function(tx) {
		var rowSet = tx.executeSql('INSERT OR REPLACE INTO scripts VALUES (?,?,?,?);', [id,name,command,icon]);
		if (rowSet.rowsAffected > 0) {
			res = "OK";
		} else {
			res = "Error";
		}
	});
	return res;
}

function scriptCount() {
	var db = localStorage();
	var res = "";
	db.transaction(function(tx) {
		var rowSet = tx.executeSql('SELECT COUNT(id) AS count FROM scripts');
		if (rowSet.rows.length > 0) {
			res = rowSet.rows.item(0).count;
		} else {
			res = "Error";
		}
	});
	return res;
}
