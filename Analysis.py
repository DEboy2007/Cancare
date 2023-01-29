import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
import pickle

df = pd.read_csv("Possible dataset - Static.csv")
dfreg = pd.read_csv("Static LogReg.csv")

function = input(
    "Welcome to Cancare analysis! What would you like to see?\nCorrelation Heatmap (0)\nShow Medicine Adherence (1)\nBivariate Analysis(2)\n")
if (function == "0"):
    sns.heatmap(df.corr(), annot=True)
    plt.show()
if (function == "1"):
    char1 = df.describe().at["mean", "Med 1"]
    char2 = df.describe().at["mean", "Med 2"]
    char3 = df.describe().at["mean", "Med 3"]

    char_data = pd.DataFrame(
        {'Med 1': char1, 'Med 2': char2, 'Med 3': char3}, index=[1, 2, 3])

    # Use seaborn to create a bar plot
    sns.catplot(data=char_data, kind="bar")

    # Show the plot
    plt.show()
if (function == "2"):
    # FIX
    medicine = input(
        "Which medicine would you like to see?\nMedicine 1 (0)\nMedicine 2 (1)\nMedicine 3 (2)\n")
    grouped = df.groupby(f'Med {str(int(medicine) + 1)}')

    # Count the frequency of the side effects (Fatigue, Nausea, Swelling, and Confusion)
    fatigue_count = grouped['Fatigue'].sum()
    nausea_count = grouped['Nausea'].sum()
    swelling_count = grouped['Swelling'].sum()
    confusion_count = grouped['Confusion'].sum()
    print(f"Grouped {fatigue_count}")

    # Create a new DataFrame with the frequency counts
    count_df = pd.DataFrame({'Fatigue': fatigue_count,
                            'Nausea': nausea_count,
                             'Swelling': swelling_count,
                             'Confusion': confusion_count})

    # Plot the frequency counts as a 100% stacked bar graph
    sns.set_style('whitegrid')
    sns.barplot(data=count_df, errorbar=None, estimator=sum, color='#34495e')
    sns.set(font_scale=1.5)
    sns.set_palette('husl')
    plt.show()
