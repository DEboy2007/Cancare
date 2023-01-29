import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

df = pd.read_csv("Possible dataset - Static.csv")
dfreg = pd.read_csv("Static LogReg.csv")

def count_symptoms(med):
    fatigue = 0
    nausea = 0
    swelling = 0
    confusion = 0
    fatigue_not = 0
    nausea_not = 0
    swelling_not = 0
    confusion_not = 0
    for i in range(len(df)):
        if df.loc[i, f"Med {med}"] == 1:
            if df.loc[i, "Fatigue"] == 1:
                fatigue += 1
            if df.loc[i, "Nausea"] == 1:
                nausea += 1
            if df.loc[i, "Swelling"] == 1:
                swelling += 1
            if df.loc[i, "Confusion"] == 1:
                confusion += 1
        else:
            if df.loc[i, "Fatigue"] == 1:
                fatigue_not += 1
            if df.loc[i, "Nausea"] == 1:
                nausea_not += 1
            if df.loc[i, "Swelling"] == 1:
                swelling_not += 1
            if df.loc[i, "Confusion"] == 1:
                confusion_not += 1

    # Create a dataframe with the data
    data = pd.DataFrame({'Fatigue': [fatigue, fatigue_not], 'Nausea': [nausea, nausea_not], 'Swelling': [swelling, swelling_not], 'Confusion': [confusion, confusion_not]}, index=[f'Medicine {med}', f'No Medicine {med}'])

    # Melt data
    data = pd.melt(data.reset_index(), id_vars='index', value_vars=['Fatigue', 'Nausea', 'Swelling', 'Confusion'])

    return data


function = input(
    "Welcome to Cancare analysis! What would you like to see?\nCorrelation Heatmap (0)\nMedicine Adherence (1)\nAffect of taking Medicine on Symptoms (2)\n")
if (function == "0"):
    sns.heatmap(df.corr(), annot=True)
    plt.show()
if (function == "1"):
    char1 = df.describe().at["mean", "Med 1"]
    char2 = df.describe().at["mean", "Med 2"]
    char3 = df.describe().at["mean", "Med 3"]

    char_data = pd.DataFrame(
        {'Med 1': char1, 'Med 2': char2, 'Med 3': char3}, index=[1, 2, 3])

    sns.catplot(data=char_data, kind="bar").set(title="Medicine Adherence")
    plt.show()
if (function == "2"):
    medicine = input(
        "Which medicine would you like to see?\nMedicine 1 (0)\nMedicine 2 (1)\nMedicine 3 (2)\n")
    sns.catplot(x="variable", y="value", hue="index", data=count_symptoms(int(medicine) + 1), kind="bar").set(title=f"Medicine {int(medicine) + 1} affect on symptoms")
    plt.show()
    
    