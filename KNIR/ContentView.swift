import SwiftUI

struct ViewControllerRepresentable: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var selectedCampus: String?
    let validCampuses: [String]

    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController()
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        if isPresented {
            let searchSwiftUIView = SearchSwiftUIView(isPresented: $isPresented, selectedCampus: $selectedCampus, validCampuses: validCampuses)
            let hostingController = UIHostingController(rootView: searchSwiftUIView)
            hostingController.modalPresentationStyle = .automatic
            uiViewController.present(hostingController, animated: true)
        } else {
            uiViewController.dismiss(animated: true)
        }
    }
}

struct ContentView: View {
    @State private var showSearch = false
    @State private var selectedCampus: String? = nil
    let validCampuses = ["Campus 1", "Campus 2", "Campus 3"]

    var body: some View {
        VStack {
            Button(action: {
                showSearch.toggle()
            }) {
                Text(selectedCampus ?? "Select Campus")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showSearch) {
                ViewControllerRepresentable(isPresented: $showSearch, selectedCampus: $selectedCampus, validCampuses: validCampuses)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
