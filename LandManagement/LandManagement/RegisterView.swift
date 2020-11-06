//
//  RegisterView.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/11/5.
//

import SwiftUI
import ToastUI
import LeanCloud

struct RegisterView: View {
    @Environment(\.presentationMode) var presentation
    @State private var phone = "18112339163"
    @State private var nickName = "黄石公"
    @State private var password = ""
    @State private var passwordAgain = ""
    
    @State private var presentingWaitingView: Bool = false
    @State private var presentingSuccessView: Bool = false
    @State private var presentingErrorView: Bool = false
    @State private var toastMessage: String = ""
    @State private var registerSuccess: Bool = false
    var body: some View {
        VStack {
            TextField("手机号", text: $phone)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("昵称", text: $nickName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("密码", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("再次输入密码", text: $passwordAgain)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button("注册") {
                    self.verify()
                }
                .toast(isPresented: $presentingWaitingView) {
                    if registerSuccess {
                        presentingSuccessView = true
                    } else {
                        presentingErrorView = true
                    }
                } content: {
                    ToastView("注册中...")
                        .toastViewStyle(IndefiniteProgressToastViewStyle())
                }
                .toast(isPresented: $presentingSuccessView, dismissAfter: 1.0) {
                    self.presentation.wrappedValue.dismiss()
                } content: {
                    ToastView("注册成功")
                        .toastViewStyle(SuccessToastViewStyle())
                }
                .toast(isPresented: $presentingErrorView, dismissAfter: 2.0) {

                } content: {
                    ToastView(toastMessage)
                        .toastViewStyle(ErrorToastViewStyle())
                }
            }
        }
        .navigationBarTitle("注册")
    }
    
    func verify() {
        if phone.isPhone() {
            if password.count >= 4 && password.count <= 12{
                if password == passwordAgain {
                    if nickName.count > 0 && nickName.count <= 6 {
                        self.register()
                    } else {
                        toastMessage = "昵称长度必须在1-6位之间"
                        presentingErrorView = true
                    }
                } else {
                    toastMessage = "两次输入的密码不一致"
                    presentingErrorView = true
                }
            } else {
                toastMessage = "密码长度在4-12位之间"
                presentingErrorView = true
            }
        } else {
            toastMessage = "请输入11位手机号"
            presentingErrorView = true
        }
    }
    
    func register() {
        presentingWaitingView = true
        // 创建实例
        let user = User()

        // 等同于 user.set("username", value: "Tom")
        user.username = LCString("+86"+phone)
        user.password = LCString(password)

        // 可选
        user.mobilePhoneNumber = LCString("+86"+phone)

        // 设置其他属性的方法跟 LCObject 一样
        user.nickname = LCString(nickName)

        _ = user.signUp { (result) in
            switch result {
            case .success:
                self.registerSuccess = true
                presentingWaitingView = false
                break
            case .failure(error: let error):
                self.registerSuccess = false
                presentingWaitingView = false
                switch error.code {
                case 202:
                    toastMessage = "手机号已注册"
                case 203:
                    toastMessage = "email已注册"
                case 214:
                    toastMessage = "手机号已注册"
                default:
                    toastMessage = error.description
                }
                print(error)
            }
        }
    }
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
