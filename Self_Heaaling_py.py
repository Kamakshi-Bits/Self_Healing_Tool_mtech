from sklearn.metrics.pairwise import cosine_similarity
from sentence_transformers import SentenceTransformer, util
import numpy as np
import os
import re
from bs4 import BeautifulSoup
from subprocess import run, PIPE

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


# if __name__ == "__main__":
#     input_text = '<p id="placement_id">Our students are placed in top companies like Google, Microsoft, Amazon, Tesla, and many more.</p>'
#     file_path =  r"C:\Users\Microsoft\Desktop\Bits\SEM4\Current_logs\Home - BITS Pilani.txt"  # Replace with your actual file path

#     best_line_sbert, best_score_sbert = find_most_similar_line_sbert(input_text, file_path)
#     print(f"\nBest Match (SBERT):\nScore: {best_score_sbert:.2f}% | Line: {best_line_sbert}")

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
    # Pattern to extract attributes like @name="value" or @id='value'
    attr_pattern = re.search(r'@([a-zA-Z0-9_-]+)\s*=\s*["\']([a-zA-Z0-9_-]+)["\']', xpath)
    
    # Pattern to extract text-based conditions like text()='value' or text()="value"
    text_pattern = re.search(r'text\(\)\s*=\s*["\']([a-zA-Z0-9_-]+)["\']', xpath)
    
    if attr_pattern:
        return f"{attr_pattern.group(1)}=\"{attr_pattern.group(2)}\""
    elif text_pattern:
        return text_pattern.group(1)
    
    return "No matching pattern found"

# Test cases
# xpaths = [
#     '//input[@name="name"]',
#     '//input[text()="name"]',
#     '//input[contains(text(),"name")]'
# ]

# for xpath in xpaths:
# print(extract_xpath_info("Element with locator '//input[@name='name']' not found."))

# # Example usage
# filename = r"C:\Users\Microsoft\Desktop\Bits\SEM4\Passed_Logs\Forms.txt"  # Change this to your file path
# search_term = "name=\"name\""
# find_lines(filename, search_term)

def get_above_line(file_path, target_line):
    with open(file_path, "r", encoding="utf-8") as file:
        lines = file.readlines()

    target_line = target_line.strip()
    for i, line in enumerate(lines):
        if line.strip() == target_line:
            return lines[i - 1].strip() if i > 0 else "No above line found"

    return "Target line not found"

# Example usage
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

    # Prioritized attributes for uniqueness
    attr_priority = ["id", "name", "class"]

    # Collect non-numeric attributes for XPath
    attr_conditions = []
    for attr in attr_priority:
        if attr in attributes:
            attr_value = attributes[attr]
            
            # Convert to string if attribute value is a list (e.g., class="btn primary")
            if isinstance(attr_value, list):
                attr_value = " ".join(attr_value)  # Convert list to space-separated string
            
            # Ensure the attribute value is not numeric
            if not re.search(r'^\d+$', attr_value):  
                attr_conditions.append(f"@{attr}='{attr_value}'")

    # If we have multiple conditions, join them using 'and'
    if attr_conditions:
        return f"//{tag_name}[{' and '.join(attr_conditions)}]"

    # Handle text-based XPath
    if element.string and element.string.strip():
        text_content = element.string.strip()
        if len(text_content) > 10:  # Use contains() for longer text
            return f"//{tag_name}[contains(text(),'{text_content}')]"
        return f"//{tag_name}[text()='{text_content}']"

    # Default generic XPath if no suitable attributes found
    return f"//{tag_name}"

# # Test cases
# html_lines = [
#     '<input type="text" name="name"><br><br>',
#     '<input id="username" type="text" value="John">',
#     '<button class="submit-btn">Submit</button>',
#     '<span>Welcome</span>',
#     '<div class="container">Hello World</div>',
#     '<input type="checkbox" data-id="1234" name="subscribe">',
#     '<input name="email" type="text" class="form-control">'
# ]

# for line in html_lines:
#     print(generate_xpath(line))



def find_and_replace_text(root_dir, search_pattern, replace_text):
    # Define file extensions to search
    file_extensions = ('.robot', '.txt')
    
    # Compile regex pattern to match the required format
    pattern = re.compile(r'(\${\w+}\s+)' + re.escape(search_pattern))
    print(pattern)
    
    # Traverse through files in the directory
    for subdir, _, files in os.walk(root_dir):
        for file in files:
            if file.endswith(file_extensions):
                file_path = os.path.join(subdir, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                # Replace matching patterns while maintaining the prefix
                updated_content = pattern.sub(lambda m: m.group(1) + replace_text, content)
                
                # Write back to the file if changes were made
                if content != updated_content:
                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.write(updated_content)
                    print(f'Updated file: {file_path}')

# if __name__ == "__main__":
#     root_directory = r'C:\Users\Microsoft\Desktop\Bits\SEM4'
#     search_string = "Element with locator '//input[@name='name']' not found."
#     replacement_string = "//button[@name='fggggggd']"
#     find_and_replace_text(root_directory, search_string, replacement_string)
#     print("Search and replace operation completed.")

def is_start_of_file(file_path, target_line):
    with open(file_path, "r", encoding="utf-8") as file:
        first_line = file.readline().strip()  # Read the actual first line from the file
    return first_line == target_line.strip()  # Compare with the given target line

# Example usage
# file_path = "sample.html"  # Replace with your actual file
# target_line = "<html><head>"  # The expected first line

# if is_start_of_file(file_path, target_line):
#     print("The target line is the start of the file.")
# else:
#     print("The target line is NOT the start of the file.")


def get_next_line(file_path: str, given_line: str, count: int) -> str:
    # Read the file content
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            lines = [line.strip() for line in file.readlines()]
    except FileNotFoundError:
        return "File not found"
    
    # Normalize given_line by stripping extra spaces
    given_line = given_line.strip()
    
    # Find the index of the given line (ignoring extra spaces)
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

# Example usage
# file_path = r"C:\Users\Microsoft\Desktop\Bits\SEM4\Current_logs\Forms.txt"
# given_line = "<label for=\"name\">Name:</label>"
# count = 1
# print(get_next_line(file_path, given_line, count))
