//
//  NewsModel.swift
//  NewsToday
//
//  Created by student on 2024/6/24.
//

import Foundation

//将标题等内容封装到结构体中
struct NewsModel {
    var newsId:Int64 = 0
    var newsTitle:String = ""
    var newsAuthor:String = ""
    var newsTime:String = ""
    
    static func getModels() -> [NewsModel] {
        
        var data = [NewsModel]()
        
        var titles = ["我国在酒泉卫星发射中心完成重复使用运载火箭首次10公里级垂直起降飞行试验","国家主席习近平向2024年“鼓岭缘”中美青年交流周致贺信。","黄河小浪底水利枢纽向下游应急抗旱调水。预计此次调度历时8天左右，累计下泄水量超18亿立方米。","巴黎奥运会资格系列赛全部结束，中国队在攀岩、滑板、霹雳舞和自由式小轮车项目中共收获12个奥运资格。","最高法发布新的反垄断民事诉讼司法解释，自7月1日起施行。","长江中下游地区将有持续性强降水，国家防总24日将针对浙江、安徽、江西、湖南4省的防汛应急响应提升至三级。"]
        var authors = ["人民日报","光明日报","新华报社","澎湃体育","法治在线","人民日报"]
        var times = ["2024年6月23日","2024年6月24日","2024年6月23日","2024年6月23日","2024年6月24日","2024年6月24日"]
        
        for index in 0..<times.count {
            let newsModel = NewsModel(newsTitle: titles[index], newsAuthor: authors[index], newsTime: times[index])
            
            data.append(newsModel)
        }
        return data
    }
}
