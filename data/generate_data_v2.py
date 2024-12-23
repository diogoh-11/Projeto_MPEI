import csv
import random

def generate_athlete_data_csv(filename="athlete_injury_data.csv", num_athletes=1000):
    # Define sport-specific characteristics
    athlete_profiles = {
        "Soccer": {"Male": {"height": (165, 195), "weight": (60, 90)},
                   "Female": {"height": (155, 185), "weight": (50, 75)}},
        "Basketball": {"Male": {"height": (180, 215), "weight": (70, 110)},
                       "Female": {"height": (170, 200), "weight": (55, 85)}},
        "Running": {"Male": {"height": (160, 190), "weight": (50, 75)},
                    "Female": {"height": (150, 180), "weight": (45, 65)}},
        "Swimming": {"Male": {"height": (175, 205), "weight": (65, 100)},
                     "Female": {"height": (165, 195), "weight": (55, 80)}},
        "Gymnastics": {"Male": {"height": (160, 180), "weight": (55, 75)},
                       "Female": {"height": (150, 170), "weight": (40, 55)}},
    }
    
    # Define general ranges for features
    age_range = (18, 40)
    training_hours_range = (0, 20)
    nutrition_score_range = (1, 10)
    physical_conditioning_range = (1, 10)
    previous_injuries_range = (0, 5)
    
    # Define risk categories and corresponding probabilities
    risk_classes = ["low", "high"]
    num_per_class = num_athletes // len(risk_classes)
    
    data = []
    
    for risk in risk_classes:
        for _ in range(num_per_class):
            # Generate basic characteristics
            gender = random.choice(["Male", "Female"])
            sport = random.choice(list(athlete_profiles.keys()))
            
            # Get height and weight based on sport and gender
            height_range = athlete_profiles[sport][gender]["height"]
            weight_range = athlete_profiles[sport][gender]["weight"]
            height = random.randint(*height_range)
            weight = round(random.uniform(*weight_range), 1)
            
            age = random.randint(*age_range)
            training_hours = random.uniform(*training_hours_range)
            nutrition_score = random.uniform(*nutrition_score_range)
            physical_conditioning = random.uniform(*physical_conditioning_range)
            previous_injuries = random.randint(*previous_injuries_range)
            
            # Adjust characteristics based on the injury risk class
            if risk == "low":
                training_hours = random.uniform(10, 20)
                physical_conditioning = random.uniform(8, 10)
                nutrition_score = random.uniform(8, 10)
                previous_injuries = random.randint(0, 1)
           
            elif risk == "high":
                training_hours = random.uniform(0, 10)
                physical_conditioning = random.uniform(1, 4)
                nutrition_score = random.uniform(1, 4)
                previous_injuries = random.randint(3, 5)
            
            # Append the generated athlete
            data.append({
                "Gender": gender,
                "Age": age,
                "Height": height,
                "Weight": weight,
                "Sport": sport,
                "Weekly_Training_Hours": round(training_hours, 1),
                "Training_Intensity": "High" if training_hours > 15 else "Low" if training_hours < 5 else "Moderate",
                "Physical_Conditioning": round(physical_conditioning, 1),
                "Nutrition_Score": round(nutrition_score, 1),
                "Previous_Injuries": previous_injuries,
                "Injury_Risk": risk
            })
    
    # Shuffle the data
    random.shuffle(data)
    
    # Write to CSV
    fieldnames = [
        "Gender", "Age", "Height", "Weight", "Sport",
        "Weekly_Training_Hours", "Training_Intensity",
        "Physical_Conditioning", "Nutrition_Score",
        "Previous_Injuries", "Injury_Risk"
    ]
    with open(filename, "w", newline="") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(data)
    
    print(f"CSV file '{filename}' with {num_athletes} athletes created.")

# Usage
generate_athlete_data_csv()
