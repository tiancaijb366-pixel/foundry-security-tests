# Foundry Security Tests — Fuzz, Invariant & Security Testing Cookbook

A collection of **runnable Foundry test patterns** for smart contract security testing. Each file demonstrates a real technique you can adapt for your own audits, invariants, and fuzz campaigns.

## Quick Start

```bash
forge install
forge test
```

## Test Files

| File | What it tests | Why it matters |
|------|--------------|----------------|
| `test/FuzzBasic.t.sol` | Fuzzing with bounded inputs and multi-parameter calls | Catch edge cases in state-changing functions |
| `test/FuzzWithAssumptions.t.sol` | Using `vm.assume()` and `bound()` to constrain fuzz inputs | Keep fuzz campaigns productive, not wasteful |
| `test/InvariantBasic.t.sol` | State invariants that must hold across any sequence of calls | Detect logic bugs that unit tests miss |
| `test/InvariantERC20.t.sol` | ERC20 invariant: `totalSupply = sum(balances)` | The canonical invariant for any token |
| `test/Reentrancy.t.sol` | Fuzzing a withdraw function to detect reentrancy | Find the #1 DeFi vulnerability class via automation |
| `test/AccessControl.t.sol` | Fuzzing unauthorized callers against protected functions | Ensure only the right roles can call privileged functions |
| `test/OracleManipulation.t.sol` | Fuzzing price changes to break downstream logic | Detect price-manipulation attack surface |
| `test/GasAssertions.t.sol` | Gas benchmarking with fuzzed inputs | Quantify DoS risk and optimize hot paths |

## Structure

```
├── test/          ← Foundry tests (fuzz + invariant + security patterns)
├── src/           ← Minimal contracts for tests to import
├── foundry.toml   ← Foundry configuration
└── .gitignore
```

## Useful? Check out these companion resources

- [Foundry Cheatsheet](https://foundry-cheatsheet.vercel.app)
- [Contract Audit Checklist](https://contract-audit-checklist.vercel.app)
- [Solidity Snippets](https://solidity-snippets.vercel.app)
