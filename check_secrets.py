#!/usr/bin/env python3
"""
Simple script to help identify potential secrets in code files.
Run this before pushing to GitHub to avoid security blocks.
"""

import os
import re
import sys

# Patterns that might indicate secrets
SECRET_PATTERNS = [
    r'api[_-]?key[=:]["\'](.*?)["\']',
    r'auth[_-]?token[=:]["\'](.*?)["\']',
    r'password[=:]["\'](.*?)["\']',
    r'secret[=:]["\'](.*?)["\']',
    r'firebase.*?[=:]["\'](.*?)["\']',
    r'AIza[0-9A-Za-z\\-_]{35}',  # Google API Key
    r'[0-9]+-[0-9A-Za-z_]{32}\\.apps\\.googleusercontent\\.com', # Google OAuth
    r'sk_live_[0-9a-zA-Z]{24}',  # Stripe API Key
    r'access_key[=:]["\'](.*?)["\']',
    r'private_key[=:]["\'](.*?)["\']',
]

# File extensions to check
EXTENSIONS_TO_CHECK = ['.dart', '.py', '.json', '.xml', '.txt', '.html', '.js', '.java', '.kt', '.swift']

def find_potential_secrets(directory):
    """Scan directory for files with potentially sensitive information."""
    potential_secrets = []
    
    for root, _, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            _, ext = os.path.splitext(file_path)
            
            # Skip files we don't want to check
            if ext not in EXTENSIONS_TO_CHECK:
                continue
                
            # Skip files from .git directory
            if '.git' in file_path:
                continue
                
            try:
                with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                    for pattern in SECRET_PATTERNS:
                        matches = re.finditer(pattern, content, re.IGNORECASE)
                        for match in matches:
                            potential_secrets.append({
                                'file': file_path,
                                'line': content.count('\n', 0, match.start()) + 1,
                                'match': match.group(0)
                            })
            except Exception as e:
                print(f"Error reading {file_path}: {e}")
    
    return potential_secrets

def main():
    directory = os.getcwd()
    print(f"Scanning {directory} for potential secrets...")
    
    secrets = find_potential_secrets(directory)
    
    if secrets:
        print("\nPotential secrets found:")
        for secret in secrets:
            print(f"File: {secret['file']}")
            print(f"Line: {secret['line']}")
            print(f"Match: {secret['match']}")
            print("---")
        
        print(f"\nFound {len(secrets)} potential secrets. Please review them before pushing.")
        return 1
    else:
        print("No potential secrets found.")
        return 0

if __name__ == "__main__":
    sys.exit(main())
