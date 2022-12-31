print("Enter/Paste assembled Hmmm. Ctrl-D or Ctrl-Z ( windows ) to save it.")
contents = []
while True:
    try:
        line = input()
    except EOFError:
        break
    contents.append(line)

print()
print("Copy this into hmmm_tb.v:")
print()

for i, line in enumerate(contents):
    print(f"data <= 16'd{i};")
    print("""pgrm_addr <= 1'b1;
#10;
pgrm_addr <= 1'b0;""")

    fixed_line = line.replace(" ", "_").replace("\t", "")
    print(f"data <= 16'b{fixed_line};")
    print("""pgrm_data <= 1'b1;
#10;
pgrm_data <= 1'b0;""")

print(f"""data <= 16'd{len(contents)};
pgrm_addr <= 1'b1;
#10;
pgrm_addr <= 1'b0;
data <= 16'b0000_0000_0000_0000;
pgrm_data <= 1'b1;
#10;
pgrm_data <= 1'b0;""")