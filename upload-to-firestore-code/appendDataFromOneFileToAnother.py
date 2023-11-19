import csv
import json

csv_file_path = 'small_data_with_embeds.csv'
json_file_path = 'food_labels.json'

with open(json_file_path, 'r') as file:
    json_data = json.load(file)


# # new_column_data = ['value1', 'value2', 'value3', 'value4']
updated_rows = []
with open(csv_file_path, 'r', newline='', encoding='utf-8') as file:
    csv_reader = csv.reader(file)
    header = next(csv_reader)
    header.append('imageURL')
    for row in csv_reader:
        row.append(json_data[row[2].lower()])
        updated_rows.append(row)

with open(csv_file_path, 'w', newline='', encoding='utf-8') as file:
    csv_writer = csv.writer(file)
    csv_writer.writerow(header)
    csv_writer.writerows(updated_rows)