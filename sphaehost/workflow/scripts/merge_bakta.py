import argparse
import pandas as pd

def parse_files(file_list):
    """Parse information from the given list of files and return a structured list."""
    data_list = []

    # Loop through each provided file
    for file_path in file_list:
        with open(file_path, "r") as f:
            lines = f.readlines()

        # Extract sample name from filename (excluding path)
        sample_name = file_path.split("/")[-1]

        # Initialize dictionary for the current sample
        sample_data = {"Sample": sample_name}

        # Extract key-value pairs
        for line in lines:
            line = line.strip()
            if line and ":" in line:
                key, value = line.split(":", 1)
                key = key.strip().replace(" ", "_").lower()  # Format column names
                value = value.strip()
                sample_data[key] = value

        # Append parsed data
        data_list.append(sample_data)

    return data_list

def save_to_tsv(data_list, output_file):
    """Save parsed data to a TSV file."""
    df = pd.DataFrame(data_list)
    df.to_csv(output_file, sep="\t", index=False)
    print(f"TSV file saved as {output_file}")

def main():
    parser = argparse.ArgumentParser(description="Parse genome annotation files and save to TSV.")
    parser.add_argument("-i", "--input_files", nargs='+', required=True, help="List of input files to process.")
    parser.add_argument("-o", "--output_file", required=True, help="Path to save the output TSV file.")

    args = parser.parse_args()

    # Process files
    data_list = parse_files(args.input_files)

    # Save results
    save_to_tsv(data_list, args.output_file)

if __name__ == "__main__":
    main()
