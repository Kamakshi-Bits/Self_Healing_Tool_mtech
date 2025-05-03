from sentence_transformers import SentenceTransformer, util
import numpy as np
import os
import re
from bs4 import BeautifulSoup
from subprocess import run, PIPE
import json
import ast

def read_file_lines(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        return file.readlines()

def find_most_similar_line_sbert(input_text, file_path):
    l=[]
    model = SentenceTransformer('all-MiniLM-L6-v2')
    file_lines = read_file_lines(file_path)
    embeddings = model.encode([input_text] + file_lines, convert_to_tensor=True)
    similarities = util.pytorch_cos_sim(embeddings[0], embeddings[1:]).flatten()
    max_index = np.argmax(similarities.cpu().numpy())
    l.append(file_lines[max_index].strip())
    l.append(similarities[max_index].item() * 100)
    return l 

def find_lines(filename, search_term):
    try:
        with open(filename, 'r', encoding='utf-8') as file:
            lines = file.readlines()
            
            matching_lines = [line.strip() for line in lines if search_term in line]
            
            if matching_lines:
                for line in matching_lines:
                  return(line)
            else:
              AssertionError("No matching lines found.")
    except FileNotFoundError:
       AssertionError("Error: File not found.")
    except Exception as e:
      AssertionError(f"An error occurred: {e}")




def extract_xpath_info(xpath: str) -> str:
    attr_pattern = re.search(r'@([a-zA-Z0-9_-]+)\s*=\s*["\']([a-zA-Z0-9_-]+)["\']', xpath)
    
    text_pattern = re.search(r'text\(\)\s*=\s*["\']([a-zA-Z0-9_-]+)["\']', xpath)
    
    if attr_pattern:
        return f"{attr_pattern.group(1)}=\"{attr_pattern.group(2)}\""
    elif text_pattern:
        return text_pattern.group(1)
    
    return "No matching pattern found"


def get_above_line(file_path, target_line):
    with open(file_path, "r", encoding="utf-8") as file:
        lines = file.readlines()

    target_line = target_line.strip()
    for i, line in enumerate(lines):
        if line.strip() == target_line:
            return lines[i - 1].strip() if i > 0 else "No above line found"

    return "Target line not found"

# file_path =  r"C:\Users\Microsoft\Desktop\Bits\SEM4\Passed_Logs\Forms.txt"
# target_line = '<input type="text" name="name"><br><br>'

# print(get_above_line(file_path, target_line))

def generate_xpath(html_line):
    soup = BeautifulSoup(html_line, "html.parser")
    element = soup.find()  # Extract the first (and only) element from the given line

    if not element:
        return "Invalid HTML element"

    tag_name = element.name
    attributes = element.attrs

    attr_priority = ["id", "name", "class"]

    attr_conditions = []
    for attr in attr_priority:
        if attr in attributes:
            attr_value = attributes[attr]
            
            if isinstance(attr_value, list):
                attr_value = " ".join(attr_value) 
            
            if not re.search(r'^\d+$', attr_value):  
                attr_conditions.append(f"@{attr}='{attr_value}'")

    if attr_conditions:
        return f"//{tag_name}[{' and '.join(attr_conditions)}]"

    if element.string and element.string.strip():
        text_content = element.string.strip()
        if len(text_content) > 10: 
            return f"//{tag_name}[contains(text(),'{text_content}')]"
        return f"//{tag_name}[text()='{text_content}']"

    return f"//{tag_name}"




def find_and_replace_text(root_dir, search_pattern, replace_text):
    file_extensions = ('.robot', '.txt')
    
    pattern = re.compile(r'(\${\w+}\s+)' + re.escape(search_pattern))
    print(pattern)
    
    for subdir, _, files in os.walk(root_dir):
        for file in files:
            if file.endswith(file_extensions):
                file_path = os.path.join(subdir, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                updated_content = pattern.sub(lambda m: m.group(1) + replace_text, content)
                
                if content != updated_content:
                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.write(updated_content)
                    print(f'Updated file: {file_path}')



def is_start_of_file(file_path, target_line):
    with open(file_path, "r", encoding="utf-8") as file:
        first_line = file.readline().strip()  
    return first_line == target_line.strip()  



def get_next_line(file_path: str, given_line: str, count: int) -> str:
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            lines = [line.strip() for line in file.readlines()]
    except FileNotFoundError:
        return "File not found"
    
    given_line = given_line.strip()
    
    try:
        index = next(i for i, line in enumerate(lines) if line == given_line)
    except StopIteration:
        return "Given line not found in file"
    
    # Get the next line based on count
    next_index = index + count
    if 0 <= next_index < len(lines):
        return lines[next_index]
    else:
        return "No sufficient lines available"

# file_path = r"C:\Users\Microsoft\Desktop\Bits\SEM4\Current_logs\Forms.txt"
# given_line = "<label for=\"name\">Name:</label>"
# count = 1
# print(get_next_line(file_path, given_line, count))


def get_variable_name(value):
    for k, v in globals().items():
        if v is value:
            return k
    return None


def find_variable_and_value(folder_path, search_value):
    for root, dirs, files in os.walk(folder_path):
        for file in files:
            if file.endswith('.robot') or file.endswith('.txt'):
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    for line in f:
                        if search_value in line:
                            parts = line.strip().split()
                            if len(parts) >= 2:
                                variable_name = parts[0]
                                value = ' '.join(parts[1:])
                                return variable_name,value



# folder_path=r"C:\Users\Microsoft\Desktop\Bits\SEM4"
# search_value="//div[@id='DBM_info_id1' and @class='update-box']"
# print(find_variable_and_value(folder_path, search_value))


def parse_string_to_dict(input_string):
    input_string = input_string.strip()
    
    if input_string == '{}' or input_string == '':
        return {}

    parts = input_string.split('},')
    merged_dict = {}
    for part in parts:
        part = part.strip()
        if not part.endswith('}'):
            part += '}'
        try:
            # Convert to Python dictionary safely
            py_dict = ast.literal_eval(part)
            if not isinstance(py_dict, dict):
                raise ValueError("One part is not a dictionary.")
            merged_dict.update(py_dict)
        except (ValueError, SyntaxError) as e:
            raise ValueError(f"Invalid dictionary part: {part} -- {e}")
    return merged_dict

def  combine_list(l1,l2):
    return l1+l2
