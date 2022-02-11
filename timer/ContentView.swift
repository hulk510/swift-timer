//
//  ContentView.swift
//  timer
//
//  Created by 後藤遥 on 2022/02/10.
//

import SwiftUI

struct ContentView: View {
    @State var timerHandler : Timer?
    @State var count = 0
    @AppStorage("timer_value") var timerValue = 10
    @State var showAlert = false
    var body: some View {
        NavigationView {
            ZStack {
                Image("backgroundTimer")
                    .resizable()
                    .ignoresSafeArea()
                    .aspectRatio(
                        contentMode: .fill)
                VStack(spacing: 30.0) {
                    Text("残り\(timerValue - count)秒")
                        .font(.largeTitle)
                    HStack {
                        Button(action: {
                            startTimer()
                        }) {
                            Text("スタート")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .frame(width: 140, height: 140)
                                .background(Color("startColor"))
                                .clipShape(Circle())
                        }
                        Button(action: {
                            if let unwrapedTimerHandler = timerHandler {
                                if unwrapedTimerHandler.isValid == true {
                                    unwrapedTimerHandler.invalidate()
                                }
                            }
                        }) {
                            Text("ストップ")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .frame(width: 140, height: 140)
                                .background(Color("stopColor"))
                                .clipShape(Circle())
                        }
                    }
                }
            }
            .onAppear {
                count = 0
            }
            .toolbar { // .toolbarでナビゲーションにボタン追加
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingView()){
                        Text("秒数設定")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingView()){
                        Text("２個目をおく")
                    }
                }
            }
            // あくまで実行を取れるイベントが.alertで表示するviewがAlertってことかな
            .alert(isPresented: $showAlert) {
                Alert(title: Text("おわり"),
                      message: Text("終わりだよー"),
                      dismissButton: .default(Text("とじる")))
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    // これはipad用の修正のために入れてるらしい
    }
    
    func countDownTimer() {
        count += 1
        if timerValue - count <= 0 {
            timerHandler?.invalidate()
            
            showAlert = true
        }
    }
    
    func startTimer() {
        if let unwrapedTimerHandler = timerHandler {
            if unwrapedTimerHandler.isValid == true {
                return
            }
        }
        
        if timerValue - count <= 0 {
            count = 0
        }
        
        timerHandler = Timer.scheduledTimer(withTimeInterval:1, repeats: true) {
            _ in
            countDownTimer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
