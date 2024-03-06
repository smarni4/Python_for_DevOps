import pandas as pd

# input file
input_file = pd.read_csv("../input_files/marksheet.csv")

# Lists
subjects = list(input_file.columns[5:9])
total_values, highest_scorers = [], []

# Added Total column
for row in input_file.iterrows():
    total_values.append(sum(row[1][5:]))
input_file['Total'] = total_values

# highest score in each subject

for subject in subjects:
    highest_score = input_file[input_file[subject] == input_file[subject].max()]
    print(highest_score)
    print("\n\n")
