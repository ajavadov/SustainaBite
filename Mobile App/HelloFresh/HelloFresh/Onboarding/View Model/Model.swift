//
//  OnboardingViewModel.swift
//  HelloFresh
//
//  Created by Murad Talibov on 18.11.23.
//

import SwiftUI
import Combine

enum OnboardingPage: Int, CaseIterable {
    case welcome
    case tags
    case frequencies
    case meals
}

@MainActor
class Model: ObservableObject {
    @Published var user: User?
    @Published var currentPage = OnboardingPage.welcome
    @Published var isOnboardingFinished = false
    @Published var isWeeklyMenuPrepared = false
    @Published var tags: [Tag] = [
        .init("Environment friendly"),
        .init("Vegan"),
        .init("Vegetarian"),
        .init("Under 650 calories"),
        .init("Family-friendly"),
        .init("Gluten-free"),
        .init("Under 30 minutes")
    ]
    @Published var recipes: [Recipe] = []
    @Published var recipesToHide: [Recipe] = []
    @Published var recipesChosen: [Recipe] = []
    @Published var recipesLoading: Bool = false
    @Published var numberOfPersons: [Tag] = [
        .init(isSelected: true, value: "2"),
        .init("3"),
        .init("4")
    ]
    @Published var mealsPerWeek: [Tag] = [
        .init("3"),
        .init(isSelected: true, value: "4"),
        .init("5")
    ]
    
    var numberOfMealsToChoose: Int {
        if let mealsPerWeek = mealsPerWeek.first(where: { $0.isSelected }) {
            return Int(mealsPerWeek.value) ?? 3
        }
        
        return 3
    }
    
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.user = User(id: "43fegrt3fve", name: "Murad Talibov", username: "murad")
        
        Task {
//            await MainActor.run {
            do {
                if let recipes: [Recipe] = await fetchAllRecipes() {
                    self.recipes = recipes
                } else {
                    self.recipes = [
                        .init(id: "64fed0d332e9107c6db8b507", name: "Harissa chicken on quinoa with green olives", ingredients: ["chicken", "quinoa", "olives", "salt", "pepper", "basilic"], headline: "This dish produces 50% less CO2e from ingredients than an average HelloFresh recipe", prepTime: "25", image: nil, imageURL: "www.cookedandloved.com/wp-content/uploads/2020/05/harissa-chicken-quinoa-salad-1.jpg", tags: [.init("High Protein"), .init("Under 650 Calories")], nutrition: .init(energy: 2534, calories: 606, carbohydrate: 52.4, protein: 38.4), course: [], cuisine: [], rating: "5.0", co2Rating: "E")
                    ]
                    for _ in 1 ... 5 {
                        var recipesCopy = recipes.map {
                            var recipe = $0
                            recipe.id = UUID().uuidString
                            return recipe
                        }
                        
                        recipes.append(contentsOf: recipesCopy)
                    }
                }
            } catch {
                print("Error fetching recipes: \(error)")
            }
        }
        
        $recipes
            .sink(receiveValue: { recipes in
                if let ecoTag = self.tags.first,
                   ecoTag.isSelected, self.isOnboardingFinished {
                    self.recipes = recipes
                        .sorted(by: { $0.co2Rating < $1.co2Rating })
                }
                
                if let quickPrepTag = self.tags.first(where: { $0.value == "Under 30 minutes" }),
                    quickPrepTag.isSelected, self.isOnboardingFinished {
                    self.recipes = recipes.filter({
                        if let prepTime = $0.prepTime,
                           let prepTimeDouble = Double(prepTime) {
                            return prepTimeDouble <= 30.0
                        }
                        return true
                    })
                }
            })
            .store(in: &cancellables)
        
        $tags
            .sink(receiveValue: { tags in
                if let ecoTag = tags.first,
                   ecoTag.isSelected, self.isOnboardingFinished {
                    self.recipes = self.recipes
                        .sorted(by: { $0.co2Rating < $1.co2Rating })
                }
                
                if let quickPrepTag = tags.first(where: { $0.value == "Under 30 minutes" }),
                    quickPrepTag.isSelected, self.isOnboardingFinished {
                    self.recipes = self.recipes.filter({
                        if let prepTime = $0.prepTime,
                           let prepTimeDouble = Double(prepTime) {
                            return prepTimeDouble <= 30.0
                        }
                        return true
                    })
                }
            })
            .store(in: &cancellables)
        
        $isOnboardingFinished
            .sink(receiveValue: { isOnboardingFinished in
                if let ecoTag = self.tags.first,
                   ecoTag.isSelected, isOnboardingFinished {
                    self.recipes = self.recipes
                        .sorted(by: { $0.co2Rating < $1.co2Rating })
                }
                
                if let quickPrepTag = self.tags.first(where: { $0.value == "Under 30 minutes" }),
                    quickPrepTag.isSelected, isOnboardingFinished {
                    self.recipes = self.recipes.filter({
                        if let prepTime = $0.prepTime,
                           let prepTimeDouble = Double(prepTime) {
                            return prepTimeDouble <= 30.0
                        }
                        return true
                    })
                }
            })
            .store(in: &cancellables)
    }
    
    func nextPage() {
        if let nextPage = OnboardingPage(rawValue: currentPage.rawValue + 1) {
            currentPage = nextPage
        } else {
            isOnboardingFinished = true
        }
    }
    
    func previousPage() {
        if let previousPage = OnboardingPage(rawValue: currentPage.rawValue - 1) {
            currentPage = previousPage
        }
    }
    
    func isRecipeChosen(_ recipe: Recipe?) -> Bool {
        recipesChosen.contains(where: { $0.id == recipe?.id ?? "" })
    }
    
    func confirmMeals() {
        isWeeklyMenuPrepared = true
    }
    
    func getRecipeByID(_ id: String) -> Recipe? {
        return recipes.first(where: { $0.id == id })
    }
    
    func addRecipeAsLiked(_ recipe: Recipe) {
        guard let user = user else { return }
        
        Task {
            do {
                _ = try await NetworkManager.makeGetRequest(endpoint: "function-2?username=\(user.username)&foodid=\(recipe.id)")
                await fetchRecommendedRecipes()
            } catch {
                print("Network error: \(error)")
            }
        }
    }
    
    func fetchAllRecipes() async -> [Recipe]? {
        recipesLoading = true
        do {
            let recipes: [Recipe] = try await NetworkManager.makeGetRequest(endpoint: "function-4")
            recipesLoading = false
            return recipes
        } catch {
            print("Network error: \(error)")
            recipesLoading = false
            return nil
        }
    }
    
    func fetchRecommendedRecipes() async {
        recipesLoading = true
        guard let user = user else { return }
        
        do {
            self.recipes = try await NetworkManager.makeGetRequest(endpoint: "function-3?username=\(user.username)")
            
            for recipeToHide in recipesToHide {
                self.recipes.removeAll(where: { $0.id == recipeToHide.id })
            }
        } catch {
            print("Network error: \(error)")
        }
        recipesLoading = false
    }
}
