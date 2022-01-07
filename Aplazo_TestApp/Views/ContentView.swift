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
                    ToolbarItemGroup(placement: .navigationBarLeading) {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
