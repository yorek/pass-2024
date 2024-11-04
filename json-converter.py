import json

# Read the JSON file
with open('sessions.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Write the content to another file with UTF-8 escaping
with open('sessions-escaped.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=True, indent=4)