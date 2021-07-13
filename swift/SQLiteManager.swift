//
//  SQLiteManager.swift
//  mremind
//
//  Created by miaoxiaodong on 2019/12/5.
//  Copyright © 2019 mark. All rights reserved.
//

import UIKit
import SQLite

let address_column = Expression<String>("address")//地址
let name_column = Expression<String>("name")//名称
let latitude_umn = Expression<Double>("latitude")//纬度
let longitude_column = Expression<Double>("longitude") //经度
let id_column = Expression<Int64>("id") //id

class SQLiteManager: NSObject {
    
    static let manager = SQLiteManager()
    private var db: Connection?
    private var table: Table?
    
    func getDB() -> Connection {
        if db == nil {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            db = try! Connection("\(path)/db.sqlite3")
            db?.busyTimeout = 5.0
        }
        return db!
    }
    
    func getTable() -> Table {
        if table == nil {
            table = Table("records")
            try! getDB().run(
                table!.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (TableBuilder) in
                    TableBuilder.column(id_column, primaryKey: .autoincrement)
                    TableBuilder.column(address_column)
                    TableBuilder.column(name_column)
                    TableBuilder.column(latitude_umn)
                    TableBuilder.column(longitude_column)
                })
            )
        }
        let sqlitePath : String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/"
        XDLog("sqlitepath = \(sqlitePath)")
        return table!
    }
    //增
    func insert(item: Dictionary<String, Any>) -> Int64 {
        let insert = getTable().insert(address_column <- item["address"] as! String,
                                       name_column <- item["name"] as! String,
                                       latitude_umn <- item["latitude"] as! Double,
                                       longitude_column <- item["longitude"] as! Double)
        if let rowId = try? getDB().run(insert) {
            XDLog("插入成功：\(rowId)")
            return rowId
        } else {
            XDLog("插入失败")
            return 0
        }
    }
    //删
    func delete(id: Int64) {
        let query = getTable().filter(id_column == id)
        if let count = try? getDB().run(query.delete()) {
            XDLog("删除成功 = \(count)")
        } else {
            XDLog("删除失败")
        }
    }
    //改
    func updata(item: Dictionary<String, Any>) {
        let updata = getTable().filter(id_column == item["id"] as! Int64)
        if let count = try? getDB().run(updata.update(address_column <- item["address"] as! String,
                                                      name_column <- item["name"] as! String,
                                                      latitude_umn <- item["latitude"] as! Double,
                                                      longitude_column <- item["longitude"] as! Double)) {
            XDLog("修改结果成功\(count)")
        } else {
            XDLog("修改结果失败")
        }
    }
    //根据id查
    func search(id: Int64) -> Dictionary<String, Any> {
        let query = getTable().filter(id_column == id)
        let result = try! getDB().prepare(query)
        var array = Array<Any>()
        for user in result {
            array.append(["id": user[id_column],
                          "address": user[address_column],
                          "name": user[name_column],
                          "latitude": user[latitude_umn],
                          "longitude": user[longitude_column]])
        }
        XDLog("根据id查询 = \(array)")
        return array.first as! Dictionary<String, Any>
    }
    //查
    func search() -> Array<Any> {
        let query = getTable().order([id_column.desc])//按照id倒序  state_column.asc,
        let result = try! getDB().prepare(query)
        var array = Array<Any>()
        for user in result {
            array.append(["id": user[id_column],
                          "address": user[address_column],
                          "name": user[name_column],
                          "latitude": user[latitude_umn],
                          "longitude": user[longitude_column]])
        }
        return array
    }
}
