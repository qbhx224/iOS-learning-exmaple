//
//  ViewController.swift
//  NewsToday
//
//  Created by student on 2024/6/24.
//

import UIKit
import SQLite   //引入第三方库

//跳转的第二个界面
class secVc: UIViewController {
    var model: NewsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        view.backgroundColor = .white       //背景色
        let label = UILabel(frame: CGRect(x: 20, y: 100, width: UIScreen.main.bounds.width - 40, height: 80))       //label大小
        label.numberOfLines = 0         //多行显示
        label.text = model?.newsTitle       //从model中获取标题
        view.addSubview(label)      //在view上添加model
    }
}

class ViewController: UIViewController {
    var db: Connection?
    
    @IBOutlet weak var newsTableView: UITableView!
    
    var dataSource = [NewsModel]()      //数据源，存放newsmodel的数组
    
    let dbTools = DBTools()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //自动布局
        newsTableView.estimatedRowHeight = 130.0    //估计值
        newsTableView.rowHeight = UITableView.automaticDimension

        //下拉刷新
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        newsTableView.refreshControl = refreshControl
        
//                dbTools.createTab()       //  第一次创建表，取消注释
//
//                for model in NewsModel.getModels() {
//                    dbTools.insertData(model: model)      //通过dbtools获取表内容
//                }
        
        //数据量大时，该操作耗时长，会造成”假死“，建议放在线程里操作
        dataSource = dbTools.queryAll()
        newsTableView.reloadData()
    }
    
    //刷新方法
    @objc func refresh(sender:UIRefreshControl) {
        
        sender.endRefreshing()      //结束刷新状态
        
        let newData = NewsModel(newsTitle: "国防部就美新一轮对台军售答记者问，强调中国人民解放军将全面加强练兵备战，坚决粉碎一切“台独”分裂图谋。", newsAuthor: "人民日报", newsTime: "2024年6月24日")         //本地的新数据，实操中从服务器拉取数据
        
        //        //1.界面刷新
        //        dataSource.insert(newData, at: 0)
        //
        //        newsTableView.reloadData()
        //
        //        //2.增加一条数据到数据库
        //        dbTools.insertData(model: newData)
        
        dbTools.insertData(model: newData)      //刷新插入新数据
        dataSource = dbTools.queryAll()     //插入数据后再次刷新，使数据源中数据都有id
        newsTableView.reloadData()      //重新加载
        
    }
    
    
}

//数据源方法
extension ViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "news") as? NewsTableViewCell
        
        cell?.newspic.image = UIImage(named: "newspic")
        cell?.newstitle.text = dataSource[indexPath.row].newsTitle
        cell?.newsauthor.text = dataSource[indexPath.row].newsAuthor
        cell?.newstime.text = dataSource[indexPath.row].newsTime
        
        return cell!
    }
    
}

//编辑cell，滑动删除
//代理方法
extension ViewController:UITableViewDelegate {
    //允许编辑
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //界面显示
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //1.将数据库中数据同步删除
        //        dbTools.delete(id: dataSource[indexPath.row].newsId)      //废弃
        
        dbTools.update(id: dataSource[indexPath.row].newsId)
        //2.更新界面
        dataSource = dbTools.queryAll()     //插入数据后再次刷新，使数据源中数据都有id
        newsTableView.reloadData()
    }
    //侧滑显示文本
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "不感兴趣"
    }
    
    
    //点击标题跳转页面
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedModel = dataSource[indexPath.row]   //获取选中的cell
        
        let vc = secVc()
        vc.model = selectedModel
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
