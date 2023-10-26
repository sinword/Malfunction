//
//  ContentView.swift
//  Malfunction
//
//  Created by 新翌王 on 2023/10/26.
//
import SwiftUI
import UIKit
import ARKit
import WebKit
import Combine

var customPrompt = ""
var startRender = false
var hasPlayedOnce = false

struct ARUIView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController()
        return viewController
    }
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }

}

struct LoadingAnimationInitializing: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        // transparent background
        webView.isOpaque = false
        if let url = Bundle.main.url(forResource: "loadingAnimationInitializing", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url)
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}

struct LoadingAnimationLoading: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        // transparent background
        webView.isOpaque = false
        if let url = Bundle.main.url(forResource: "loadingAnimationLoading", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url)
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}

struct LoadingAnimationCompleted: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        // transparent background
        webView.isOpaque = false
        if let url = Bundle.main.url(forResource: "loadingAnimationCompleted", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url)
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}

struct ContentView: View {
    var style = "None"
    var condition = "None"
    var strength = "None"
    
    @EnvironmentObject var stageObject: StageObject
    @State var shouldRender = false
    var body: some View {
        // Overlay ARview and UI
        // ARview is defined in ViewController.swift
        // If option is not all selected, the background is black with a image "Exclude"
        // If options are all selected, the background is ARview with a image "Exclude"
        
        ZStack {
            ARUIView()
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name(rawValue: "ARImageDetected"))) { _ in
                    print("ARImageDetected")
                }
            Image("Exclude")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .edgesIgnoringSafeArea(.all)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                
            ZStack {
                Image("TopVector1")
                VStack {
                    HStack {
                        Image("VRHeadset")
                        .frame(width: 35.12657, height: 17.15551)
                        .padding()
                    Text("客製化你的城市")
                        .font(.custom("NotoSansCJKTC", size: 17.68))
                        .kerning(9.6356)
                        .foregroundColor(.white)
                    }
                    .position(CGPoint(x: 140, y: 32))

                    HStack (alignment: .center) {
                        Text("Customize your city")
                            .font(Font.custom("Syncopate", size: 15.5272))
                            .foregroundColor(.white)
                            .padding(20)

                        Spacer()
                        Text("    G.H.")
                            .font(Font.custom("Syncopate", size: 17.68).weight(.bold))
                            .foregroundColor(.black)
                            .padding()
                        
                        Spacer()

                        Text("頭盔畫面測試 Beta v2.5.3")
                            .font(Font.custom("Syncopate", size: 17.68).weight(.bold))
                            .foregroundColor(.black)
                            .padding()
                    }
                }
                .zIndex(2)
                Image("TopVector2")
                    .frame(width: 83.41927, height: 16.79277)
                    .offset(x: -230, y: 3)
            }
            .frame(width: UIScreen.main.bounds.width, height: 89)
            .position(x: UIScreen.main.bounds.width / 2, y: 20)

            ZStack {
                Image("ChatBoxContent")
                    .frame(width: 1136, height: 203)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 150)
                
                Image("ChatBoxFrame")
                    .frame(width: 1137.53748, height: 205.00616)
                    .shadow(color: .white.opacity(0.25), radius: 5.50315, x: 0, y: 3.38656)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 150)
                // Swtich the content of the chatbox with the stage

                if stageObject.stage == "generating" {
                    Text("目 標 鎖 定 中...")
                        .font(Font.custom("Syncopate", size: 25).weight(.medium))
                        .kerning(3.1)
                        .foregroundColor(Color(red: 0.11, green: 0.44, blue: 0.85))
                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 180)
                    Text("Targeting...")
                        .font(Font.custom("Syncopate", size: 20).weight(.bold))
                        .kerning(3.1)
                        .foregroundColor(Color(red: 0.11, green: 0.44, blue: 0.85))
                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 130)
                    LoadingAnimationLoading()
                        .position(x: 150, y: UIScreen.main.bounds.height + 135)
                }
                else if stageObject.stage == "completed" {
                    LoadingAnimationCompleted()
                        .position(x: 650, y: UIScreen.main.bounds.height + 150)
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text("系統錯誤，數據無法上傳至頭盔。")
                                .font(Font.custom("Noto Sans CJK TC", size: 20).weight(.medium)
                                )
                                .kerning(4)
                                .foregroundColor(Color("SystemBlue"))
                                .frame(width: 471, height: 45, alignment: .topLeading)
                            Text("SYSTEM ERROR.\n\nError Code 0xc0003501.")
                                .font(Font.custom("Syncopate", size: 16).weight(.bold))
                                .kerning(2)
                                .foregroundStyle(Color("SystemBlue"))
                                .frame(width: 700, height: 50, alignment: .topLeading)
                        }
                    
                        Button(action: {
                            stageObject.stage = "generating"
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RemoveARAnchor"), object: nil)
                        }) {
                            Image("RegenerateButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 310, height: 60)
                                .padding(.leading, -130)
                        }
                    }
                    .position(x: UIScreen.main.bounds.height - 140, y: 670)
                    
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name(rawValue: "ARImagedetected"))) { _ in
            print("ARImagedetected")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(stageObject)
    }
}
