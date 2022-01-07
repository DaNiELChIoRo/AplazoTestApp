//
//  ContentView.swift
//  Aplazo_TestApp
//
//  Created by Daniel Meneses León on 06/01/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model: Model = .init()
    var body: some View {        
        VStack {
            NavigationView {
                List(model.categories) { category in
                    NavigationLink(destination: CategoryDetail(category: category)) {
                        Text(category.strCategory)
                            .padding()
                    }
                }
            }
        }
        .navigationTitle("Food Categories")
        .onAppear {
            Task(priority: .userInitiated) {
                try? await model.fetch()
            }
        }
    }
}

extension ContentView {
    class Model: ObservableObject {
        @Published var categories = [Category]()
        
        @MainActor
        func fetch() async throws {
            let url = URL(string: "http://www.themealdb.com/api/json/v1/1/categories.php")!
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                categories = try JSONDecoder().decode(CategoriesResponse.self, from: data).categories
                
            } catch {
                debugPrint("error while retreving", error.localizedDescription)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
