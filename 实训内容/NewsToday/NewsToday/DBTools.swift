//
//  DB Tools.swift
//  NewsToday
//
//  Created by student on 2024/6/24.
//

import UIKit
import SQLite

class DBTools {
    
    
    
    let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!      //数据库路径
    
    var db:Connection?
    
    let news = Table("news")
    let newsId = Expression<Int64>("id")
    let newsTitle = Expression<String?>("newsTitle")
    let newsAuthor = Expression<String?>("newsAuthor")
    let newsTime = Expression<String?>("newsTime")
    let isDelete = Expression<String?>("isDelete")
    var data = [NewsModel]()
    
    //连接表
    func connectDB(){
        do {
            db = try Connection("\(dbPath)/db.sqlite3")
        } catch {
            print(error)
        }
    }
    
    //创建表
    func createTab() {
        
        connectDB()        //连接db，下方法同理
        
        do {
            try db?.run(news.create { t in
                t.column(newsId, primaryKey: true)
                t.column(newsTitle)
                t.column(newsAuthor)
                t.column(newsTime)
                t.column(isDelete)
            })
        } catch {
            print(error)
        }
    }
    
    //增加表中数据
    func insertData(model:NewsModel) {
        
        connectDB()
        
        let insert = news.insert(newsTitle <- model.newsTitle, newsAuthor <- model.newsAuthor, newsTime <- model.newsTime, isDelete <- "0" )
        do {
            _ = try db?.run(insert)
        } catch {
            print(error)
        }
    }
    
    //查询表中数据
    func queryAll() -> [NewsModel]{
        connectDB()
        
        data.removeAll()    //每次query清空数据
        
        do {
            let queryNews = try db?.prepare(news)
            if let queryNews = queryNews {      //可添加条件排序，按照id降序排列
                for item in queryNews where item[isDelete] == "0" {     //筛选未删除（isdelete == 0）的数据
                    let newsModel = NewsModel(newsId: item[newsId], newsTitle: item[newsTitle]!, newsAuthor: item[newsAuthor]!, newsTime: item[newsTime]!)
                    data.insert(newsModel,at: 0)    //新添加数据永远在第一个
                }
            }
        } catch {
            print(error)
        }
        return data
    }
    
    //更新表中数据,更新isdelete字段
    func update(id:Int64) {
        let updateNews = news.filter(newsId == id)
        
        do {
            try db?.run(updateNews.update(isDelete <- isDelete.replace("0", with: "1")))
        } catch {
            print(error)
        }
        
    }
    
    //删除表中数据(方法较危险)
    //    func delete(id:Int64) {
    //        let deleteNews = news.filter(newsId == id)
    //
    //        do {
    //            try db?.run(deleteNews.delete())
    //        } catch {
    //            print(error)
    //        }
    //
    //    }
}
