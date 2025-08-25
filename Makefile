# Makefile for Flex-Perks Contracts

# Load environment variables from .env file if it exists
-include .env

# Default shell
SHELL := /bin/bash

# Target Networks
BAOBAB_RPC_URL := $(shell toml get config.toml kaia_testnet.rpc_url)
BAOBAB_PRIVATE_KEY := $(shell toml get config.toml kaia_testnet.private_key)
BAOBAB_ETHERSCAN_API_KEY := $(shell toml get config.toml kaia_testnet.etherscan_api_key)

CYPRESS_RPC_URL := $(shell toml get config.toml kaia.rpc_url)
CYPRESS_PRIVATE_KEY := $(shell toml get config.toml kaia.private_key)
CYPRESS_ETHERSCAN_API_KEY := $(shell toml get config.toml kaia.etherscan_api_key)

# Contract paths
SCRIPT_PATH = script/Deploy.s.sol:Deploy

.PHONY: all clean install build test deploy-testnet deploy-mainnet

all: clean install build test

clean:
	@echo "Cleaning up..."
	forge clean

install:
	@echo "Installing dependencies..."
	forge install

build:
	@echo "Building contracts..."
	forge build

test:
	@echo "Running tests..."
	forge test

deploy-testnet:
	@echo "Deploying contracts to Kaia Testnet (Baobab)..."
	@forge script $(SCRIPT_PATH) --rpc-url $(BAOBAB_RPC_URL) --private-key $(BAOBAB_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(BAOBAB_ETHERSCAN_API_KEY) -vvvv

deploy-mainnet:
	@echo "Deploying contracts to Kaia Mainnet (Cypress)..."
	@read -p "Are you sure you want to deploy to mainnet? (y/N) " a; \
	if [ "$${a}" = "y" ]; then \
		forge script $(SCRIPT_PATH) --rpc-url $(CYPRESS_RPC_URL) --private-key $(CYPRESS_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(CYPRESS_ETHERSCAN_API_KEY) -vvvv; \
	fi
