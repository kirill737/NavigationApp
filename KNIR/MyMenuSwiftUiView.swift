////
////  MyMenuSwiftUiView.swift
////  KNIR
////
////  Created by elena on 20.05.2024.
////
//
//import SwiftUI
//
//struct MenuSwiftUIView: View {
//    @State private var isPresented = false
//
//    var body: some View {
//        Button(action: {
//            isPresented.toggle()
//        }) {
//            Text("Show Menu")
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(8)
//        }
//        .fullScreenCover(isPresented: $isPresented, content: {
//            MyMenuWrapperView(isPresented: $isPresented)
//        })
//    }
//}
//
//struct MyMenuWrapperView: UIViewControllerRepresentable {
//    @Binding var isPresented: Bool
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let myMenuVC = ViewController()
//        let navigationController = UINavigationController(rootViewController: myMenuVC)
//        
//        navigationController.presentationController?.delegate = context.coordinator
//        
//        if let sheet = navigationController.sheetPresentationController {
//            sheet.detents = [.medium(), .large()]
//            sheet.prefersGrabberVisible = true
//            sheet.prefersEdgeAttachedInCompactHeight = true
//            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
//        }
//        
//        return navigationController
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
//        var parent: MyMenuWrapperView
//
//        init(_ parent: MyMenuWrapperView) {
//            self.parent = parent
//        }
//
//        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
//            parent.isPresented = false
//        }
//    }
//}
//
//struct MenuSwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuSwiftUIView()
//    }
//}
