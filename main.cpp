#include <iostream>
#include <iterator>
#include <string>
#include <vector>

#include "rust_part.h"

int main() 
{
  std::cout << "prettify_json application" << std::endl;

  // Read json from stdin.
  std::istreambuf_iterator<char> begin{std::cin}, end;
  std::vector<unsigned char> input{begin, end};
  rust::Slice<const uint8_t> slice{input.data(), input.size()};

  // Prettify using serde_json and serde_transcode.
  std::string output;
  rust_part::prettify_json(slice, output);

  // Write to stdout.
  std::cout << output << std::endl;
}
