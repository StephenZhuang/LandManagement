//
//  LoginView.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/11/4.
//

import SwiftUI
import ToastUI

struct LoginView: View {
    @State var isPushed = false
    @State private var phone = "18112339163"
    @State private var password = ""
//    private var time = 60
//    @State private var sending = false
//    @State private var title = "发送"
    
    @State private var presentingWaitingView: Bool = false
    @State private var presentingSuccessView: Bool = false
    @State private var presentingErrorView: Bool = false
    var body: some View {
        VStack {
            TextField("手机号", text: $phone)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
//            HStack {
//                TextField("验证码", text: $verifyCode)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                Spacer().frame(width: 15, height: 15)
//                Button(title) {
//                    if sending {
//
//                    } else {
//                        if isPhone(phone: phone) {
//                            sending = true
//                            self.countDown()
//                            self.sendCode()
//                        }
//                    }
//                }
//            }.padding()
            SecureField("密码", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button("登录") {
                    presentingWaitingView = true
                }
                .toast(isPresented: $presentingWaitingView, dismissAfter: 2.0) {
                    presentingSuccessView = true
                } content: {
                    ToastView("登录中...")
                        .toastViewStyle(IndefiniteProgressToastViewStyle())
                }
                .toast(isPresented: $presentingSuccessView, dismissAfter: 2.0) {
                    ToastView("登录成功")
                        .toastViewStyle(SuccessToastViewStyle())
                }
                Spacer()
                
                Button {
                    isPushed = true
                } label: {
                    NavigationLink(destination: RegisterView(isPushed: $isPushed), isActive: $isPushed) {
                        Text("注册")
                    }
                }

            }.padding()
        }
        .navigationBarTitle("登录")
    }
    
//    func sendCode() {
//        _ = User.requestLoginVerificationCode(mobilePhoneNumber: phone) { result in
//            switch result {
//            case .success:
//                break
//            case .failure(error: let error):
//                print(error)
//            }
//        }
//    }
    
//    func countDown() -> Void {
//        var time = 60
//        let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
//        codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))  //此处方法与Swift 3.0 不同
//        codeTimer.setEventHandler {
//            time = time - 1
//            if time < 0 {
//                codeTimer.cancel()
//                sending = false
//                title = "发送"
//            } else {
//                title = "\(time)"+"s"
//            }
//        }
//
//        codeTimer.activate()
//    }
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
