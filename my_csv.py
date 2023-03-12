import csv

with open('input.txt.txt','r') as f:
    reader = csv.reader(f, delimiter=' ')
    data = []
    for row in reader:
        # print(row)
        x = []
        for c in range(3,15):
            x = row[c]
        print(x)
        break


# import csv

# # Open the txt file for reading
# with open('input.txt.txt', 'r') as f:
#     reader = csv.reader(f, delimiter=' ')

#     # Create an empty list to store the data
#     data = []

#     # Loop through each line of the txt file and store it in the data list
#     for row in reader:
#         data.append(row)

# print(data[0])
# filename = "final.csv"
# for r in range(1,472):
#     x = data[r][3:14]

# with open('final.csv', 'w', encoding='UTF8', newline='') as f:
#     writer = csv.writer(f)

#     # write the header
    

#     # write multiple rows
#     writer.writerows(data[1:472][3:14])


# Open a CSV file for writing
# with open('output.csv', 'w', newline='') as f:
#     writer = csv.writer(f)

#     # Write each row of the data list to the CSV file
#     for row in data:
#         writer.writerow(row)

