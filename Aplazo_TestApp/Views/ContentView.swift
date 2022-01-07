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
        NavigationView {
            List(model.categories) { category in
                NavigationLink(destination: CategoryDetail(category: category)) {
                    Text(category.strCategory)
                        .padding()
                }
            }
            .navigationBarTitle("Meal Catalogue")
            .toolbar {
                Button(action: {
                    Task {
                        await model.getRandomMeal()
                    }
                }) {
                    Image(systemName: "shuffle")
                    Text("Random Meal")
                }
            }
        }
        .onAppear {
            Task(priority: .userInitiated) {
                try? await model.fetch()
            }
        }
        .sheet(isPresented: $model.showRandom) {
            if let randomMeal = model.randomMeal {
                VStack {
                    Text(randomMeal.strMeal)
                        .font(.title)
                    
                    AsyncImage(url: URL(string: randomMeal.strMealThumb)!,
                               content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 250)
                        
                    }, placeholder: {
                        ProgressView()
                    })
                    
                    if let youTubeLink = randomMeal.strYoutube {
                        Link("YouTube", destination: URL(string: youTubeLink)!)
                    }
                    
                    Text(randomMeal.strCategory ?? "")
                        .font(.title2)
                    
                    Text("Instructions")
                        .font(.title3)
                    Text(randomMeal.strInstructions ?? "")
                }
                .padding(.horizontal)
            }
        }
    }
}

extension ContentView {
    class Model: ObservableObject {
        @Published var categories = [Category]()
        @Published var randomMeal: Meal?
        @Published var showRandom: Bool = false
        
        @MainActor
        func fetch() async {
            let url = URL(string: "http://www.themealdb.com/api/json/v1/1/categories.php")!
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                categories = try JSONDecoder().decode(CategoriesResponse.self, from: data).categories
                
            } catch {
                debugPrint("error while retreving", error.localizedDescription)
            }
        }
        
        @MainActor
        func getRandomMeal() async {
            let url = URL(string: "http://www.themealdb.com/api/json/v1/1/random.php")!
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                self.randomMeal = try JSONDecoder().decode(MealResponse.self, from: data).meals.first!
                self.showRandom = true
                
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
