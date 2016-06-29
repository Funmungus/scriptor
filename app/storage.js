/*
  Copyright (c) 2016, Jonathan Pelletier
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

  2. Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE.
*/

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
