//
//  DBService.swift
//  DoneList
//
//  Created by  on 2023/07/06.
//

import Foundation
import SQLite3

final class DBService {
    static let shared = DBService()
    
    private let dbFile = "DBDoneList.sqlite"
    private var db: OpaquePointer?
    
    private init() {
        db = openDatabase()
        if !createTable() {
            print("Failed to create table")
        }
    }
    
    private func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false).appendingPathComponent(dbFile)
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Failed to open database")
            return nil
        }
        else {
            print("Opened connection to database")
            return db
        }
    }
    
    private func createTable() -> Bool {
        let createSql = """
        CREATE TABLE IF NOT EXISTS done_list (
            done_list_id INTEGER NOT NULL PRIMARY KEY,
            contents TEXT NOT NULL,
            start_date TEXT NULL,
            end_date TEXT NULL
        );
        """
        
        var createStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (createSql as NSString).utf8String, -1, &createStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        if sqlite3_step(createStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(createStmt)
            return false
        }
        
        sqlite3_finalize(createStmt)
        return true
    }
    
    private func getDBErrorMessage(_ db: OpaquePointer?) -> String {
        if let err = sqlite3_errmsg(db) {
            return String(cString: err)
        } else {
            return ""
        }
    }
    
    func getDoneList() -> [DoneList] {
     
        var doneLists: [DoneList] = []
        
        let sql = """
            SELECT   done_list_id, contents, start_date, end_date
            FROM     done_list
            ORDER BY start_date DESC
            """
        
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &stmt, nil) != SQLITE_OK {
            return doneLists
        }
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let doneListID = String(describing: String(cString: sqlite3_column_text(stmt, 0)))
            let contents = String(describing: String(cString: sqlite3_column_text(stmt, 1)))
            let startDate = String(describing: String(cString: sqlite3_column_text(stmt, 2)))
            let endDate = String(describing: String(cString: sqlite3_column_text(stmt, 3)))
            
            doneLists.append(DoneList(doneListID: doneListID, contents: contents, startDate: startDate, endDate: endDate))
        }
        
        sqlite3_finalize(stmt)
        return doneLists
    }
    
    func insertDoneList(doneList: DoneList) -> Bool {
        let insertSql = """
                        INSERT INTO done_list
                            (done_list_id, contents, start_date, end_date)
                            VALUES
                            (?, ?, ?, ?)
                        ;
                        """;
        var insertStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (insertSql as NSString).utf8String, -1, &insertStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        sqlite3_bind_text(insertStmt, 1,(doneList.DoneListID as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertStmt, 2, (doneList.Contents as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertStmt, 3, (doneList.StartDate as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertStmt, 4, (doneList.EndDate as NSString).utf8String, -1, nil)
        
        if sqlite3_step(insertStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(insertStmt)
            return false
        }
        sqlite3_finalize(insertStmt)
        return true
    }
    
    func deleteDoneList(doneListId: String) -> Bool {
        let deleteSql = """
                        DELETE FROM
                            done_list
                        WHERE
                            done_list_id = ?
                        ;
                        """
        var deleteStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (deleteSql as NSString).utf8String, -1, &deleteStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        sqlite3_bind_text(deleteStmt, 1, (doneListId as NSString).utf8String, -1, nil)

        if sqlite3_step(deleteStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(deleteStmt)
            return false
        }

        sqlite3_finalize(deleteStmt)
        return true
    }
}

struct DoneList {
    var DoneListID: String
    var Contents: String
    var StartDate: String
    var EndDate: String
    
    init(doneListID: String, contents: String, startDate: String, endDate: String) {
        self.DoneListID = doneListID
        self.Contents = contents
        self.StartDate = startDate
        self.EndDate = endDate
    }
}

