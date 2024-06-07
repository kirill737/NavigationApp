////
////  pathSwiftUIView.swift
////  KNIR
////
////  Created by elena on 19.05.2024.
////
//
//import SwiftUI
//
//
//struct PathSwiftUIView: View {
//    @State var selectedStartPoint: String = "1"
//    @State var selectedEndPoint: String = "2"
//    let validPoints: [String] = []
//    @State private var searchText = ""
//    @Binding var isShown = true
//    var onSelectPoint: ((String) -> Void)? // Замыкание для передачи выбранного здания
//
//    var body: some View {
//        HStack {
//            TextField("Откуда", text: $searchText)
//                .padding()
//                .background(Color.gray.opacity(0.1))
//                .cornerRadius(8);
//            TextField("Куда", text: $searchText)
//                .padding()
//                .background(Color.gray.opacity(0.1))
//                .cornerRadius(8)
//        }
//        .sheet(isPresented: true, onDismiss: <#T##(() -> Void)?#>, content: <#T##() -> Content#>)
////        VStack {
////            TextField("Нажми для поиска", text: $searchText)
////                .padding()
////                .background(Color.gray.opacity(0.1))
////                .cornerRadius(8)
////            
////            List(validCampuses.filter({ searchText.isEmpty ? true : $0.contains(searchText) }), id: \.self) { campus in
////                Button(action: {
////                    searchSelectedCampus = campus
////                    onSelectCampus?(campus) // Вызываем замыкание при выборе здания
////                }) {
////                    Text(campus)
////                }
////            }
////        }
////        .padding()
//    }
//}
//
//#Preview {
//    PathSwiftUIView()
//}
