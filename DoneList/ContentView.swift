//
//  ContentView.swift
//  DoneList
//
//  Created by  on 2023/07/06.
//

import SwiftUI

struct ContentView: View {
    /// 開始時刻
    @State var selectedStartDate:Date = Date()
    /// 終了時刻
    @State var selectedEndDate:Date = Date()
    /// 内容（やったこと）
    @State var contents:String = ""
    /// やったことリスト
    @State var doneLists: [DoneList] = DBService.shared.getDoneList() {
        didSet {
            // やったことリスト(doneLists)を日付（yyyyMMdd）ごとにリスト(dateList, doneListByDate)へセット
            convertDoneListByDate()
        }
    }
    /// 日付（yyyyMMdd）リスト
    @State var dateList:[String] = []
    /// 日付ごとのやったことリスト
    @State var doneListByDate: [String: [DoneList]] = [:]
    
    var body: some View {
        NavigationView {
            // --------------------
            // メイン
            // --------------------
            VStack{
                Spacer()
                // --------------------
                // 入力項目
                // --------------------
                // 開始／終了日時
                HStack {
                    HStack {
                        DatePicker("",
                                   selection: $selectedStartDate,
                                   displayedComponents: [.hourAndMinute]
                        ).environment(\.locale, Locale(identifier: "ja_JP"))
                        Button(action: {
                            selectedStartDate = Date()
                        }) {
                            Image(systemName: "xmark")
                        }
                    }.padding(.horizontal)
                    
                    HStack {
                        Label("〜", systemImage: "")
                    }.padding()
                    
                    HStack {
                        DatePicker("",
                                   selection: $selectedEndDate,
                                   displayedComponents: [.hourAndMinute]
                        ).environment(\.locale, Locale(identifier: "ja_JP"))
                        Button(action: {
                            selectedEndDate = Date()
                        }) {
                            Image(systemName: "xmark")
                        }
                    }.padding(.horizontal)
                }
                .padding(.horizontal)
                // やったこと入力
                TextField("やったことを入力", text: $contents)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                // --------------------
                // やったことリスト
                // --------------------
                List {
                    ForEach (0 ..< dateList.count, id: \.self) { dateIdx in
                        Section {
                            ForEach (0 ..< doneListByDate[dateList[dateIdx]]!.count, id: \.self) { listIdx in
                                let doneList = doneListByDate[dateList[dateIdx]]![listIdx]
                                let startDate: Date? = convertStringToDate(dateValue: doneList.StartDate)
                                let endDate: Date? = convertStringToDate(dateValue: doneList.EndDate)
                                let startHHmm = toDateString(dateValue:startDate, dateFormat: "HH:mm")
                                let endHHmm = toDateString(dateValue:endDate, dateFormat: "HH:mm")
                                let timeFromTo = "\(startHHmm)~\(endHHmm)"
                                let timeDiff = calculateTimeDifference(startDate: startDate, endDate: endDate)
                                
                                // リスト表示
                                HStack {
                                    VStack(alignment: .leading) {
                                        // 時間
                                        HStack(alignment: .bottom) {
                                            Text("\(timeFromTo)").font(.headline)
                                            Text("\(timeDiff)").font(.caption)
                                        }.padding(.bottom, 1)
                                        // 内容
                                        Text(doneList.Contents).font(.body)
                                    }
                                }
                                // スワイプアクション
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        // 削除処理
                                        deleteDoneList(doneListId: doneList.DoneListID)
                                    } label: {
                                        Image(systemName: "trash.fill")
                                    }
                                }
                            }
                        } header: {
                            let week = getWeekdayFromDate(date: convertStringToDate(dateValue: dateList[dateIdx], dateFormat: "yyyy/MM/dd"))
                            
                            // 日付
                            Text("\(dateList[dateIdx])(\(week))")
                        }
                    }
                }
                .listStyle(.plain)
            }
            // --------------------
            // ナビゲーションバー
            // --------------------
            .navigationTitle("やったことリスト")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // ナビゲーションバー左
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        // 共有処理
                        shareSheet()
                    }) {
                        Label("送信", systemImage: "square.and.arrow.up")
                    }
                }
                // ナビゲーションバー右
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        // 登録処理
                        addDoneList()
                    }) {
                        Text("追加")
                    }
                }
            }
            .padding()
        }
        // --------------------
        // 画面表示時
        // --------------------
        .onAppear {
            // やったことリストを日付（yyyyMMdd）ごとにリストへセット
            convertDoneListByDate()
        }
    }
    
    // --------------------
    // 各種処理
    // --------------------
    // 登録処理
    private func addDoneList() {
        let doneListID = toDateString(dateValue: Date(), dateFormat: "yyyyMMddHHmmssSSS")
        let startDate = toDateString(dateValue: selectedStartDate, dateFormat: "yyyyMMddHHmmss")
        let endDate = toDateString(dateValue: selectedEndDate, dateFormat: "yyyyMMddHHmmss")
        let contents = contents
        let doneList = DoneList(doneListID: doneListID, contents: contents, startDate: startDate, endDate: endDate)
        
        if DBService.shared.insertDoneList(doneList: doneList) {
            doneLists.append(doneList)
            doneLists.sort { $0.StartDate != $1.StartDate ? $0.StartDate > $1.StartDate : $0.DoneListID > $1.DoneListID }
            
            self.contents = ""
        } else {
            print("Insert Failed")
        }
    }
    
    // 削除処理
    private func deleteDoneList(doneListId: String) {
        if DBService.shared.deleteDoneList(doneListId: doneListId) {
            doneLists.removeAll(where: { $0.DoneListID == doneListId })
        } else {
            print("Delete Failed")
        }
    }
    
    // やったことリストを日付（yyyyMMdd）ごとにリストへセット
    private func convertDoneListByDate() {
        
        var tmpDateList:Set<String> = []

        for doneList in doneLists {
            let dateString = toDateString(dateValue:doneList.StartDate, dateFormat: "yyyy/MM/dd")
            tmpDateList.insert(dateString)
        }
        
        var tmpDoneListByDate: [String: [DoneList]] = [:]
        
        for date in tmpDateList {
            tmpDoneListByDate[date] = doneLists.filter({ toDateString(dateValue:$0.StartDate, dateFormat: "yyyy/MM/dd") == date })
        }
        
        dateList = Array(tmpDateList)
        dateList.sort { $0 > $1 }
        doneListByDate = tmpDoneListByDate
    }
    
    // 共有処理
    private func shareSheet() {
        var csv = ""
        // CSVデータを作成
        do {
            // 見出し行
            csv = "開始時刻,終了時刻,内容\r\n"

            for data in doneLists {
                var line = ""
                
                line += data.StartDate + ","
                line += data.EndDate + ","
                let tmp = "\"" + (data.Contents.replacingOccurrences(of: "\"", with: "\"\"") as String) + "\""
                line += tmp + "\r\n"
                
                csv = csv + line
            }
        }

        let tmpFile: URL = URL(fileURLWithPath: "data.csv", relativeTo: FileManager.default.temporaryDirectory)
        if let strm = OutputStream(url: tmpFile, append: false) {
            strm.open()
            let BOM = "\u{feff}"
            strm.write(BOM, maxLength: 3)
            let data = csv.data(using: .utf8)
            _ = data?.withUnsafeBytes {
                strm.write($0.baseAddress!, maxLength: Int(data?.count ?? 0))
            }
            strm.close()
        }
        shareApp(shareText: csv, shareLink: tmpFile.absoluteURL)
    }
        
    private func shareApp(shareText: String, shareLink: URL ) {
        let items = [shareLink] as [Any]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        // デバイスがiPadだったら
        if UIDevice.current.userInterfaceIdiom == .pad {
            let deviceSize = UIScreen.main.bounds// 画面サイズ取得
            if let popPC = activityVC.popoverPresentationController {
                // ポップオーバーの設定
                // iPadの場合、sourceView、sourceRectを指定しないとクラッシュする。
                popPC.sourceView = activityVC.view // sourceRectの基準になるView
                popPC.barButtonItem = .none// ボタンの位置起点ではない
                popPC.sourceRect = CGRect(x:deviceSize.size.width/2, y: deviceSize.size.height, width: 0, height: 0)// Popover表示起点
            }
        }
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootVC = windowScene?.windows.first?.rootViewController
        rootVC?.present(activityVC, animated: true,completion: {})
    }
}

// --------------------
// プレビュー
// --------------------
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let lst = [
            DoneList(doneListID: "001", contents: "test3", startDate: "20230707140000", endDate: "20230707150000"),
            DoneList(doneListID: "002", contents: "test2", startDate: "20230707130000", endDate: "20230707140000"),
            DoneList(doneListID: "003", contents: "test", startDate: "20230707120000", endDate: "20230707130000"),
            DoneList(doneListID: "004", contents: "test5", startDate: "20230708183000", endDate: "20230708190000"),
            DoneList(doneListID: "005", contents: "test4", startDate: "20230708180000", endDate: "20230708183000"),
        ]
        
        // ビューをプレビュー表示
        ContentView(doneLists: lst)
    }
}
