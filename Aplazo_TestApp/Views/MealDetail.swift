//
//  MealDetail.swift
//  Aplazo_TestApp
//
//  Created by Daniel Meneses León on 06/01/22.
//

import SwiftUI

struct MealDetail: View {
    let mealId: String
    @ObservedObject var model: Model = .init()
    var body: some View {
        ScrollView {
            if let meal = model.meal {
                AsyncImage(url: URL(string: meal.strMealThumb)!,
                           content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 250)
                    
                }, placeholder: {
                    ProgressView()
                })
                
                Text(meal.strInstructions ?? "")
            }
        }
        .padding(.horizontal)
        .navigationTitle(model.meal?.strMeal ?? "")
        .onAppear {
            Task {
                await model.fetch(for: mealId)
            }
        }
    }
}

