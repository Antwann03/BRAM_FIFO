import pathlib

def main():
    # basically a path to my folder 
    script_direction = pathlib.Path(__file__).resolve().parent
    out_path = script_direction.parent / "sim" / "input_data.txt"
    with open(out_path, "w") as f:
        # 0xFFFF -> FFFF, a 4 uppercase hex
        f.write(f"{0xFFFF:04X}\n")
        f.write(f"{0x0000:04X}\n")
        f.write(f"{0xAAAA:04X}\n")
        f.write(f"{0x5555:04X}\n")
        #loops from 0 to 31 and it writes 0 as 0000
        for i in range(32):
            f.write(f"{i:04X}\n")

    print(f"Wrote values to {out_path}")

if __name__ == "__main__":
    main()