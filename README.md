# AssetsFlow

Calculate taxes for transactions in your bank investor account!

## Software Requirements

- [Docker](https://docs.docker.com/get-docker/)
- A terminal emulator

## Development Reasoning

Creating a CLI tool with Elixir is a good choice for this problem for a couple of reasons:

- Maintainability: Elixir is a language that is easy to read and understand, which makes it easier to maintain the codebase.
- Performance: Elixir is a language that is known for its performance, which is important for a CLI tool.
- Separation of Concerns: with Elixir idioms, like modules, pattern-matching, pipes, one can separate concerns and make the code more modular.

## Libraries

This project is currently using the following libraries:

- Jason: for easy JSON parsing and serialization, as Elixir doesn't provide a native way to do this
- Decimal: for handling decimal numbers with precision, as Elixir's native float type can lead to precision errors
  In this project, Decimal is only used within `DecimalHelper` module, which acts as an adapter between Decimal and the rest of the codebase.

## Building with Docker

Run

```bash
docker build -t assets_flow .
```

Then wait for the build to finish.

## Executing

This program reads data from stdin and writes to stdout. To run it, you can run both ways:

```bash
docker run -i assets_flow
[{"operation":"buy", "unit-cost":10.00, "quantity": 10000}, {"operation":"sell", "unit-cost":20.00, "quantity": 5000}]
[{"operation":"buy", "unit-cost":20.00, "quantity": 10000}, {"operation":"sell", "unit-cost":10.00, "quantity": 5000}]

[{"tax": 0}, {"tax": 10000}]
[{"tax": 0}, {"tax": 0}]
```

Or, assuming you have the line entries in a file named `input.txt`, you can run:

```bash
docker run -i assets_flow < input.txt
[{"tax": 0}, {"tax": 10000}]
[{"tax": 0}, {"tax": 0}]
```

## Testing
Run tests by running

```bash
mix test
```
