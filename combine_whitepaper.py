#!/usr/bin/env python3
import os
from pathlib import Path

def combine_whitepaper():
    # Define the order of sections (adjust these to match your actual filenames)
    sections = [
        "01-introduction.md",
        "02-protocol-overview.md",
        "03-token-economic-model.md",
        "04-autonomous-agent-framework.md",
        "05-utility-and-use-cases.md",
        "06-governance-and-dao-layers.md",
        "07-technical-architecture.md",
        "08-roadmap-and-milestones.md",
        "09-risk-and-mitigation.md",
        "10-conclusion.md"
    ]
    
    # Create output directory if it doesn't exist
    os.makedirs("docs/whitepaper", exist_ok=True)
    
    output = []
    base_path = Path("docs/whitepaper/sections")
    
    # Combine all sections
    for section in sections:
        section_path = base_path / section
        if section_path.exists():
            with open(section_path, "r", encoding="utf-8") as f:
                content = f.read()
                output.append(content)
                output.append("\n\n---\n\n")  # Add separator between sections
        else:
            print(f"Warning: Section {section} not found at {section_path}")
    
    # Write combined output
    output_path = Path("docs/whitepaper/full-whitepaper.md")
    with open(output_path, "w", encoding="utf-8") as f:
        f.write("".join(output))
    
    print(f"Combined whitepaper created at: {output_path.absolute()}")

if __name__ == "__main__":
    combine_whitepaper()