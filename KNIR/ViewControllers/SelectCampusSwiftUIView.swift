// SearchSwiftUIView.swift

import SwiftUI

struct SearchSwiftUIView: View {
    @State var searchSelectedCampus: String
    let validCampuses: [String]
    @State private var searchText = ""
    var onSelectCampus: ((String) -> Void)?

    var body: some View {
        VStack {
            TextField("Нажми для поиска", text: $searchText)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            List(validCampuses.filter({ searchText.isEmpty ? true : $0.contains(searchText) }), id: \.self) { campus in
                Button(action: {
                    searchSelectedCampus = campus
                    onSelectCampus?(campus)
                }) {
                    Text(campus)
                }
            }
        }
        .padding()
    }
}
