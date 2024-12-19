//
//  ContentView.swift
//  The Wheel of Taste
//
//  Created by Kevin Chuang on 2024/12/13.
//

import Lottie
import SwiftUI

struct ContentView: View {
    @State private var emojiOffsets: [CGFloat] = Array(repeating: -100, count: 10)
    @State private var emojiStartTimes: [Double] = Array(repeating: 0, count: 10)
    @State private var emojiXPositions: [CGFloat] = Array(repeating: 0, count: 10)
    @State private var selectedCuisine: String? = nil
    @State private var showCuisineSelection = false
    
    let emojis = ["🍕", "🍔", "🍣", "🌮", "🥗", "🍝", "🍩", "🍜", "🍟", "🥙", "🍙", "🥘", "🌯", "🍖", "🍛", "🍤", "🍲"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                if let cuisine = selectedCuisine {
                    BudgetSelectionView(
                        cuisine: cuisine,
                        showCuisineSelection: $showCuisineSelection,
                        selectedCuisine: $selectedCuisine
                    )
                    .transition(.opacity)
                } else if showCuisineSelection {
                    CuisineSelectionView(
                        onCuisineSelected: { cuisine in
                            withAnimation(.easeInOut(duration: 1)) {
                                selectedCuisine = cuisine
                            }
                        },
                        onBack: {
                            withAnimation(.easeInOut(duration: 1)) {
                                showCuisineSelection = false
                            }
                        }
                    )
                    .transition(.opacity)
                } else {
                    HomeScreen(
                        emojis: emojis,
                        emojiOffsets: $emojiOffsets,
                        emojiStartTimes: $emojiStartTimes,
                        emojiXPositions: $emojiXPositions,
                        showCuisineSelection: $showCuisineSelection
                    )
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 1), value: selectedCuisine)
            .animation(.easeInOut(duration: 1), value: showCuisineSelection)
        }
    }
    
    struct HomeScreen: View {
        let emojis: [String]
        @Binding var emojiOffsets: [CGFloat]
        @Binding var emojiStartTimes: [Double]
        @Binding var emojiXPositions: [CGFloat]
        @Binding var showCuisineSelection: Bool
        
        var body: some View {
            ZStack {
                // Background Lottie Animation
                LottieView(name: "Animation - 1734346571997", loopMode: .loop, play: true)
                    .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.5)
                    .scaleEffect(0.28)
                    .ignoresSafeArea()
                
                // Gradient Background
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.9), Color.cyan.opacity(0.8), Color.gray.opacity(0.9)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Falling Emojis
                ForEach(0..<emojiOffsets.count, id: \.self) { index in
                    Text(emojis[index % emojis.count])
                        .font(.system(size: 50))
                        .position(x: emojiXPositions[index], y: emojiOffsets[index])
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + emojiStartTimes[index]) {
                                startFalling(index: index)
                            }
                        }
                }
                
                VStack(spacing: 20) {
                    Text("The Wheel of Taste")
                        .font(.custom("MarkerFelt-Wide", size: 35))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(1), radius: 3, x: 2, y: 2)
                        .padding(.top, 65)
                    
                    Spacer()
                    
                    Text("What Should I Eat?")
                        .font(.custom("MarkerFelt-Wide", size: 23))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.6), radius: 5, x: 5, y: 5)
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 1)) {
                            showCuisineSelection = true
                        }
                    }) {
                        Text("Start")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: 270, height: 70)
                            .background(
                                Capsule()
                                    .fill(Color.yellow)
                                    .shadow(color: .black.opacity(0.8), radius: 10, x: 0, y: 5)
                            )
                            .foregroundColor(.black)
                    }
                }
                .padding(.bottom, 30)
            }
            .onAppear {
                for index in 0..<emojiStartTimes.count {
                    emojiStartTimes[index] = Double(index) * 1.8
                    emojiXPositions[index] = CGFloat.random(in: 50...UIScreen.main.bounds.width - 50)
                }
                
                // Reset emojiOffsets to restart animations when navigating back
                emojiOffsets = Array(repeating: -100, count: emojiOffsets.count)
            }
            .onDisappear {
                emojiOffsets = Array(repeating: -100, count: emojiOffsets.count) // Stop emojis on navigation
            }
        }
        
        private func startFalling(index: Int) {
            emojiXPositions[index] = CGFloat.random(in: 50...UIScreen.main.bounds.width - 50)
            emojiOffsets[index] = -50
            
            withAnimation(
                Animation.linear(duration: Double.random(in: 6...10))
                    .repeatForever(autoreverses: false)
            ) {
                emojiOffsets[index] = UIScreen.main.bounds.height + 50
            }
        }
    }
    
    struct CuisineSelectionView: View {
        var onCuisineSelected: (String) -> Void
        var onBack: () -> Void
        
        
        let cuisines = [
            "American", "Chinese", "Indian", "Italian", "Japanese", "Mexican", "Thai", "Korean",
            "Vietnamese", "French", "Taiwanese", "Spanish", "Greek", "Turkish", "German",
            "Caribbean", "Brazilian", "Argentinian", "Russian", "Moroccan"
        ]
        
        
        
        var body: some View {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.green, Color.orange, Color.pink]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                .ignoresSafeArea()
                
                
                VStack(spacing: 30) {
                    HStack {
                        BackButton(action: onBack)
                        Spacer()
                    }
                    .padding(.top, -28)
                    .padding(.leading, 16)
                    
                    
                    
                    Text("Choose Your Cuisine")
                        .font(.custom("MarkerFelt-Wide", size: 38))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.4), radius: 3, x: 2, y: 2)
                        .padding(.top, 20)
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 25) {
                            ForEach(cuisines, id: \.self) { cuisine in
                                Button(action: {
                                    onCuisineSelected(cuisine) // Select cuisine and navigate
                                }) {
                                    Text(cuisine)
                                        .font(.custom("MarkerFelt-Wide", size: 22))
                                        .frame(maxWidth: .infinity, minHeight: 80)
                                        .background(Color.white.opacity(0.9))
                                        .foregroundColor(.black)
                                        .cornerRadius(20)
                                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            
        }
    }
    
    
    struct BackButton: View {
        var action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.title2)
                    Text("Back")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 0))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    struct BudgetSelectionView: View {
        let cuisine: String
        @Binding var showCuisineSelection: Bool
        @Binding var selectedCuisine: String?
        @State private var selectedBudget: String? = nil
        @State private var showWheel = false
        
        var body: some View {
            ZStack {
                // Background Animation
                LottieView(name: "Animation - 1734348675383", loopMode: .loop, play: true)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.9)
                    .scaleEffect(0.5)
                    .ignoresSafeArea()
                
                // Gradient Overlay
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.6), Color.indigo.opacity(0.6), Color.gray.opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Back Button
                    HStack {
                        BackButton {
                            withAnimation(.easeInOut(duration: 1)) {
                                showCuisineSelection = true
                                selectedCuisine = nil
                            }
                        }
                        Spacer()
                            .padding(.top, 20)// Align back button to the left
                    }
                    
                    Spacer()
                    
                    // Main content
                    Text("Selected Cuisine: \(cuisine)")
                        .font(.custom("MarkerFelt-Wide", size: 25))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 4, x: 2, y: 2)
                        .padding(.top, 50)
                    
                    Text(flagForCuisine(cuisine))
                        .font(.system(size: 80))
                        .padding(.bottom, 20)
                    
                    Text("What's Your Budget?")
                        .font(.custom("MarkerFelt-Wide", size: 35))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 4, x: 2, y: 2)
                    
                    VStack(spacing: 20) {
                        BudgetOptionView(price: "< 15 USD") {
                            triggerTransition(with: "< 15 USD")
                        }
                        BudgetOptionView(price: "15-30 USD") {
                            triggerTransition(with: "15-30 USD")
                        }
                        BudgetOptionView(price: "> 30 USD") {
                            triggerTransition(with: "> 30 USD")
                        }
                    }
                    
                    Spacer()
                    Text("Your appetite awaits!")
                        .font(.custom("HelveticaNeue-Italic", size: 18))
                        .foregroundColor(.white.opacity(0.9))
                        .padding()
                }
                .padding()
                
                // Conditional Transition to SpinningWheelView
                if showWheel, let budget = selectedBudget {
                    SpinningWheelView(showWheel: $showWheel, cuisine: cuisine, budget: budget)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 2), value: showWheel)
                }
            }
        }
        
        private func triggerTransition(with budget: String) {
            withAnimation(.easeInOut(duration: 2)) {
                selectedBudget = budget
                showWheel = true
            }
        }
        
        private func flagForCuisine(_ cuisine: String) -> String {
            switch cuisine {
            case "American": return "🇺🇸"
            case "Chinese": return "🇨🇳"
            case "Indian": return "🇮🇳"
            case "Italian": return "🇮🇹"
            case "Japanese": return "🇯🇵"
            case "Mexican": return "🇲🇽"
            case "Thai": return "🇹🇭"
            case "Korean": return "🇰🇷"
            case "Vietnamese": return "🇻🇳"
            case "French": return "🇫🇷"
            case "Taiwanese": return "🇹🇼"
            case "Spanish": return "🇪🇸"
            case "Greek": return "🇬🇷"
            case "Turkish": return "🇹🇷"
            case "German": return "🇩🇪"
            case "Caribbean": return "🇨🇺"
            case "Brazilian": return "🇧🇷"
            case "Argentinian": return "🇦🇷"
            case "Russian": return "🇷🇺"
            case "Moroccan": return "🇲🇦"
            default: return "🏳️"
            }
        }
    }
    
    
    struct SpinningWheelView: View {
        @Binding var showWheel: Bool
        @State private var angle: Double = 0
        @State private var isSpinning = false
        @State private var selectedResult: String? = nil
        @State private var showResult = false
        @State private var playAnimation = false

        let cuisine: String
        let budget: String
        
        // Meal options for each cuisine and budget
        let meals: [String: [String: [String]]] = [
            "American": [
                "< 15 USD": ["Burger", "Hotdog", "Grilled Cheese Sandwich", "Mac and Cheese", "Sloppy Joes"],
                "15-30 USD": ["Spaghetti", "BBQ Ribs", "Cheeseburger", "Clam Chowder", "BBQ Pulled Pork Sandwich"],
                "> 30 USD": ["Lobster Roll", "Prime Rib", "Steak", "Seafood Platter", "Beef Wellington"]
            ],
            "Indian": [
                "< 15 USD": ["Aloo Paratha ", "Chole Bhature", "Pav Bhaji", "Masala Dosa", "Vada Pav"],
                "15-30 USD": ["Chicken Biryani", "Chicken Tikka Masala", "Mutto Rogan Josh", "Dal Makhani", "Fish Curry"],
                "> 30 USD": ["Prawn Malai Curry", "Malai Kofta", "Butter Chicken with Naan ", "Hyderabadi Dum Biryani (Goat)", "Tandoori Platter"]
            ],
            "Chinese":[
                "< 15 USD": ["Chicken Friend Rice", "Spring Rolls", "Egg Drop Soup", "Vegetable Stir-Fry", "Scallion Pancakes"],
                "15-30 USD": ["Kung Pao Chicken", "Sweet and Sour Pork", "Beef Chow Mein", "Mapo Tofu", "General Tso’s Chicken"],
                "> 30 USD": ["Peking Duck", "Dim Sum Feast", "Hot Pot", "Braised Abalone with Vegetables", "Lobster in Black Bean Sauce"]
            ],
            "Italian":[
                "< 15 USD": ["Caprese Salad", "Bruschetta", "Spaghetti Aglio e Olio", "Margherita Pizza", "Minestrone Soup"],
                "15-30 USD": ["Lasagna Bolognese", "Fettuccine Alfredo", "Risotto alla Milanese", "Chicken Parmesan", "Spaghetti Carbonara"],
                "> 30 USD": ["Osso Buco", "Seafood Risotto", "Lobster Ravioli", "Bistecca alla Fiorentina", "Tartufo Nero Pasta"]
            ],
            "Japanese":[
                "< 15 USD": ["Onigiri", "Takoyaki", "Miso Soup", "Zaru Soba", "Tamagoyaki"],
                "15-30 USD": ["Tonkotsu Ramen", "Chicken Karaage", "Tempura", "Katsu Curry", "Chirashi Sushi"],
                "> 30 USD": ["Sushi Platter", "Unagi Don", "Wagyu Steak", "Kaiseki Meal", "Shabu-Shabu"]
            ],"Mexican":[
                "< 15 USD": ["Tacos", "Quesadillas", "Guacamole with Tortilla Chips", "Elote", "Chilaquiles"],
                "15-30 USD": ["Enchiladas", "Pozole", "Tostadas", "Carnitas Plate ", "Carne Asadai"],
                "> 30 USD": ["Mole Poblano", "Seafood Ceviche", "Birria", "Tampiqueña Plate", "Cochinita Pibil"]
            ],"Thai":[
                "< 15 USD": ["Pad Thai", "Som Tum", "Thai Spring Rolls", "Tom Yum Soup", "Kai Jeow (Thai Omelet"],
                "15-30 USD": ["Massaman Curry", "Green Curry (Gaeng Keow Wan)", "Pad Kra Pao (Basil Stir-Fry)", "Panang Curry", "Thai Fried Rice"],
                "> 30 USD": ["Pla Rad Prik (Crispy Fish with Chili Sauce)", "Pad See Ew with Prawns", "Tom Kha Gai (Coconut Chicken Soup)", "Khao Soi", "Lobster Phad Thai "]
            ],"Korean":[
                "< 15 USD": ["Bibimbap", "Kimchi Jjigae", "Tteokbokki", "Kimbap", "Buchimgae (Korean Pancakes)"],
                "15-30 USD": ["Samgyeopsal (Grilled Pork Belly)", "Japchae", "Sundubu Jjigae", "Bulgogi", "Dak Galbi"],
                "> 30 USD": ["Galbi (Korean BBQ Short Ribs)", "Haemul Tang (Seafood Hot Pot)", "Samgyetang (Ginseng Chicken Soup)", "Hanu Steak", "Bossam"]
            ],"Vietnamese":[
                "< 15 USD": ["Pho", "Banh Mi", "Goi Cuon", "Cha Gio", "Com Tam"],
                "15-30 USD": ["Bun Bo Hue", "Bun Cha", "Ca Kho To", "Mi Quang", "Bo Luc Lac (Shaking Beef)"],
                "> 30 USD": ["Lau (Vietnamese Hot Pot)", "Cha Ca La Vong", "Vietnamese Seafood Platter", "Duck Pho", "Banh Xeo Feast"]
            ],"French":[
                "< 15 USD": ["Croque Monsieur", "French Onion Soup", "Quiche Lorraine", "Ratatouille", "Crêpes (Savory or Sweet)"],
                "15-30 USD": ["Coq au Vin", "Bouillabaisse", "Steak Frites", "Duck Confit", "Moules Marinières"],
                "> 30 USD": ["Beef Bourguignon", "Lobster Thermidor", "Chateaubriand", "Sole Meunière", "Foie Gras"]
            ],"Taiwanese":[
                "< 15 USD": ["Gua Bao (Pork Belly Buns)", "Lu Rou Fan", "Scallion Pancakes (Cong You Bing)", "Popcorn Chicken (Yan Su Ji)", "Daikon Radish Cake"],
                "15-30 USD": ["Beef Noodle Soup", "Oyster Omelet", "Three Cup Chicken (San Bei Ji)", "Stinky Tofu (Chou Doufu)", "Pork Chop Rice"],
                "> 30 USD": ["Taiwanese Hot Pot", "Buddha Jumps Over the Wall", "Whole Steamed Fish", "Braised Pork Knuckle", "Grilled Giant Squid"]
            ],"Spanish":[
                "< 15 USD": ["Tortilla Española", "Pan con Tomate", "Patatas Bravas", "Croquetas de Jamón", "Gazpacho"],
                "15-30 USD": ["Paella Valenciana", "Calamares a la Romana", "Albóndigas", "Pisto", "Pollo al Ajillo"],
                "> 30 USD": ["Fabada Asturiana", "Mariscada", "Pulpo a la Gallega", "Cochinillo Asado", "Bacalao al Pil Pil"]
            ],"Greek":[
                "< 15 USD": ["Souvlaki", "Spanakopita", "Horiatiki (Greek Salad)", "Dolmades", "Tzatziki with Pita Bread"],
                "15-30 USD": ["Moussaka", "Gyro Plate", "Pastitsio", "Stifado", "Kleftiko"],
                "> 30 USD": ["Lamb Souvla", "Octopus Stifado", "Arni me Patates (Lamb with Potatoes)", "Bakaliaros Skordalia", "Youvetsi"]
            ]
            ,"Turkish":[
                "< 15 USD": ["Simit", "Gözleme", "Lahmacun", "Menemen", "Pide"],
                "15-30 USD": ["Köfte", "Doner Kebab Plate", "İskender Kebab", "Beyti Kebab", "Manti"],
                "> 30 USD": ["Testi Kebab", "Lamb Shish Kebab", "Kuzu Tandir", "Baklava Feast", "Hünkar Beğendi"]
            ]
            ,"German":[
                "< 15 USD": ["Bratwurst", "Kartoffelsalat", "Schnitzel Sandwich", "Spätzle", "Currywurst"],
                "15-30 USD": ["Wiener Schnitzel", "Sauerbraten", "Flammkuchen", "Rinderroulade", "Käsespätzle"],
                "> 30 USD": ["Eisbein", "Schweinshaxe", "Venison Ragout", "Grilled Trout (Forelle Müllerin", "Bavarian Sausage Platter"]
            ],
            "Caribbean":[
                "< 15 USD": ["Jerk Chicken", "Roti", "Fried Plantains", "Callaloo Soup", "Bake and Shark"],
                "15-30 USD": ["Oxtail Stew", "Ackee and Saltfish", "Pelau", "Conch Fritters", "Escovitch Fish"],
                "> 30 USD": ["Whole Roasted Snapper", "Crab and Callaloo", "Lobster Thermidor Caribbean Style", "Jerk Lobster", "Pepper Pot Stew"]
            ],
            "Brazilian":[
                "< 15 USD": ["Pão de Queijo", "Coxinha", "Pastel", "Acarajé", "Feijão Tropeiro"],
                "15-30 USD": ["Feijoada", "Moqueca", "Picanha", "Frango com Quiabo", "Escondidinho de Carne Seca"],
                "> 30 USD": ["Churrasco", "Bacalhau à Brás", "Whole Roasted Suckling Pig (Leitão à Pururuca)", "Caruru", "Peixe Assado"]
            ],
            "Argentinian":[
                "< 15 USD": ["Empanadas", "Choripán", "Milanesa Sandwich", "Provoleta", "Humita"],
                "15-30 USD": ["Asado (Grilled Beef Short Ribs)", "Milanesa Napolitana", "Locro", "Puchero", "Pastel de Papa"],
                "> 30 USD": ["Parrillada (Argentinian Grill Platter)", "Bife de Chorizo", "Cordero Patagónico", "Trout with Herbs", "Chivito al Asador"]
            ],
            "Russian":[
                "< 15 USD": ["Borscht", "Pelmeni", "Blini", "Syrniki", "Pirozhki"],
                "15-30 USD": ["Beef Stroganoff", "Shashlik", "Golubtsy", "Solyanka", "Kotleti"],
                "> 30 USD": ["Kulebyaka", "Pirog with Caviar", "Duck with Apple", "Zakuski Platter", "Baked Kamchatka Crab"]
            ],
            "Moroccan":[
                "< 15 USD": ["Harira", "Khobz", "Bissara", "Zaalouk", "Maakouda"],
                "15-30 USD": ["Chicken Tagine with Preserved Lemon and Olives", "Lamb Tagine with Prunes", "Couscous Royale", "Rfissa", "Kefta Tagine"],
                "> 30 USD": ["Mechoui", "Stuffed Camel or Lamb", "Grilled Lobster with Chermoula", "Royal Couscous with Lamb and Vegetables", "Camel Kebab Platter"]
            ]
        ]
        
        var body: some View {
                ZStack {
                    // Background Gradient
                    LinearGradient(
                        gradient: Gradient(colors: [Color.mint, Color.gray, Color.orange]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()

                    VStack {
                        // Back Button
                        HStack {
                            Button(action: {
                                withAnimation() {
                                    showWheel = false
                                }
                            }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                    Text("Back")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                }
                            }
                            .padding(.top, -26)
                            .padding(.leading, 33)

                            Spacer()
                        }
                        .padding(.top, 50)

                        Spacer()

                        // Title
                        Text("Spin the Wheel!")
                            .font(.custom("MarkerFelt-Wide", size: 30))
                            .foregroundColor(.white)
                            .padding(.bottom, 100)

                        // Wheel
                        ZStack {
                            LottieView(name: "Animation - 1734352709204", loopMode: .playOnce, play: playAnimation)
                                .frame(width: 300, height: 300)
                                .scaleEffect(0.8)

                            ZStack {
                                ForEach(getMealOptions().indices, id: \.self) { index in
                                    let segmentAngle = 360.0 / Double(getMealOptions().count)
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(width: 5, height: 5)
                                        .offset(y: -90)
                                        .rotationEffect(.degrees(segmentAngle * Double(index)))
                                }
                            }
                            .rotationEffect(.degrees(angle))
                        }
                        .animation(.easeOut(duration: 3), value: isSpinning)
                        .padding(.bottom, 30)

                        // Spin Button
                        Button(action: spinWheel) {
                            Text("Spin")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding()
                                .frame(width: 200)
                                .background(Color.yellow)
                                .cornerRadius(30)
                                .shadow(radius: 5)
                                .foregroundColor(.black)
                        }
                        .padding(.top, 60)
                        .padding(.bottom, 50)

                        Spacer()
                    }

                    // Result Display
                    if showResult, let result = selectedResult {
                        ZStack {
                            Color.black.opacity(0.8)
                                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.48)
                                .ignoresSafeArea(edges: .horizontal)

                            LottieView(name: "Animation - 1734511623225", loopMode: .playOnce, play: true)
                                .frame(width: 300, height: 300)
                                .offset(y: -50)

                            VStack(spacing: 30) {
                                Text("Your meal is")
                                    .font(.custom("MarkerFelt-Wide", size: 30))
                                    .foregroundColor(.white)

                                Text(result)
                                    .font(.custom("MarkerFelt-Wide", size: 25))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.cyan.opacity(0.9))
                                    )
                                    .shadow(radius: 3)
                                    .shadow(color: .black.opacity(0.8), radius: 10, x: 0, y: 5)
                            }
                            .padding()
                            .scaleEffect(showResult ? 1 : 0.5)
                            .animation(.spring(), value: showResult)
                        }
                    }
                }
            }

            private func spinWheel() {
                isSpinning = true
                playAnimation = false
                selectedResult = nil
                showResult = false

                DispatchQueue.main.async {
                    playAnimation = true
                }

                let rotation = Double.random(in: 720...1080)
                withAnimation {
                    angle += rotation
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isSpinning = false
                    determineResult()
                    withAnimation {
                        showResult = true
                    }
                }
            }

            private func determineResult() {
                let normalizedAngle = angle.truncatingRemainder(dividingBy: 360)
                let options = getMealOptions()
                let segmentAngle = 360.0 / Double(options.count)
                let index = Int((360 - normalizedAngle) / segmentAngle) % options.count
                selectedResult = options[index]
            }

            private func getMealOptions() -> [String] {
                return meals[cuisine]?[budget] ?? ["No options available"]
            }
        }
    
    // LottieView to Control Animation
    struct LottieView: UIViewRepresentable {
        let name: String
        let loopMode: LottieLoopMode
        var play: Bool
        
        func makeUIView(context: Context) -> LottieAnimationView {
            let animationView = LottieAnimationView(name: name)
            animationView.loopMode = loopMode
            animationView.contentMode = .scaleAspectFit
            return animationView
        }
        
        func updateUIView(_ uiView: LottieAnimationView, context: Context) {
            if play {
                uiView.play()
            } else {
                uiView.stop()
            }
        }
    }
    
    struct BudgetOptionView: View {
        let price: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.9), Color.gray.opacity(0.3)]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .frame(height: 80)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                    
                    HStack {
                        Spacer()
                        Text(price)
                            .font(.custom("MarkerFelt-Wide", size: 30))
                            .foregroundColor(.black)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
#Preview {
    ContentView()
}
