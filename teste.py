import csv
import random

def generate_athlete_data_csv(filename="athlete_injury_data.csv", num_athletes=1000):
    # Define ranges for height and weight based on sport and gender
    athlete_profiles = {
    "Soccer": {"Male": {"height": (165, 190), "weight": (60, 85)},
               "Female": {"height": (155, 180), "weight": (50, 70)}},
    "Basketball": {"Male": {"height": (180, 215), "weight": (65, 110)},
                   "Female": {"height": (170, 200), "weight": (55, 90)}},
    "Running": {"Male": {"height": (160, 190), "weight": (50, 85)},
                "Female": {"height": (150, 180), "weight": (45, 70)}},
    "Swimming": {"Male": {"height": (175, 205), "weight": (65, 100)},
                 "Female": {"height": (165, 195), "weight": (55, 85)}},
    "Tennis": {"Male": {"height": (170, 200), "weight": (60, 90)},
               "Female": {"height": (160, 190), "weight": (50, 75)}},
    "Cycling": {"Male": {"height": (165, 190), "weight": (55, 85)},
                "Female": {"height": (155, 180), "weight": (45, 65)}},
    "Gymnastics": {"Male": {"height": (160, 180), "weight": (55, 75)},
                   "Female": {"height": (150, 170), "weight": (40, 55)}},
    "Weightlifting": {"Male": {"height": (160, 185), "weight": (75, 120)},
                      "Female": {"height": (150, 175), "weight": (60, 95)}},
}

    
    # Define ranges and categories for other characteristics
    age_range = (18, 40)  # Age in years
    training_hours_range = (0, 20)  # Weekly training hours
    training_intensity_levels = ["Low", "Moderate", "High"]
    previous_injuries_range = (0, 5)  # Number of previous injuries
    nutrition_score_range = (1, 10)  # 1 (poor) to 10 (excellent)
    physical_conditioning_range = (1, 10)  # 1 (poor) to 10 (excellent)
    
    # Define the target classes
    risk_classes = ["low", "high"]
    num_per_class = num_athletes // len(risk_classes)  # Equal split
    
    data = []
    
    for risk in risk_classes:
        for _ in range(num_per_class):
            # Generate basic characteristics
            age = random.randint(*age_range)
            gender = random.choice(["Male", "Female"])
            sport = random.choice(list(athlete_profiles.keys()))
            
            # Get realistic height and weight based on sport and gender
            height_range = athlete_profiles[sport][gender]["height"]
            weight_range = athlete_profiles[sport][gender]["weight"]
            height = random.randint(*height_range)  # Height in cm
            weight = round(random.uniform(*weight_range), 1)  # Weight in kg
            
            training_hours = random.uniform(*training_hours_range)
            training_intensity = random.choice(training_intensity_levels)
            previous_injuries = random.randint(*previous_injuries_range)
            nutrition_score = random.uniform(*nutrition_score_range)
            physical_conditioning = random.uniform(*physical_conditioning_range)
            
            # Adjust characteristics based on the risk class
            if risk == "low":
                training_hours = random.uniform(10, 20)
                training_intensity = "High"
                previous_injuries = random.randint(0, 1)
                nutrition_score = random.uniform(8, 10)
                physical_conditioning = random.uniform(8, 10)
                
            elif risk == "high":
                training_hours = random.uniform(0, 10)
                training_intensity = "Low"
                previous_injuries = random.randint(3, 5)
                nutrition_score = random.uniform(1, 4)
                physical_conditioning = random.uniform(1, 4)
            
            # Append data row
            data.append({
                "Gender": gender,
                "Age": age,
                "Height": height,
                "Weight": weight,
                "Sport": sport,
                "Weekly_Training_Hours": round(training_hours, 1),
                "Training_Intensity": training_intensity,
                "Physical_Conditioning": round(physical_conditioning, 1),
                "Nutrition_Score": round(nutrition_score, 1),
                "Previous_Injuries": previous_injuries,
                "Injury_Risk": risk
            })
    
    # Shuffle the data
    random.shuffle(data)
    
    # Write data to CSV
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
    
    print(f"CSV file '{filename}' with {num_athletes} shuffled athletes created successfully.")

# Usage
generate_athlete_data_csv()
