import os
from brownie import (
    USDC,
    RouterV2,
    MarketContract,
    AccountRegistrar,
    accounts,
    Faucet,
    network,
)
from .utility import deploy_contract, transact


def main():
    router_contract_address = None
    market_contract_address = None
    token_contract_address = None
    account_registrar_address = None
    faucet_address = None
    mainnet = ""

    if network.show_active() in [
        "arb-goerli-fork",
        "arb-goerli",
        "arbitrum-test-nitro",
        "arbitrum-sepolia"
    ]:
        admin = accounts.add(os.environ["BFR_PK"])


    ########### Get TokenX ###########
    if not token_contract_address:
        token_contract = deploy_contract(
            admin,
            network,
            USDC,
            [],
        )
        token_contract_address = token_contract.address
    elif network.show_active() != mainnet:
        token_contract = USDC.at(token_contract_address)

    # ####### Deploy Registrar #######
    # if not account_registrar_address:
    #     account_registrar = deploy_contract(
    #         admin,
    #         network,
    #         AccountRegistrar,
    #         [],
    #     )
    #     account_registrar_address = account_registrar.address
    # else:
    #     account_registrar = AccountRegistrar.at(account_registrar_address)

    # ########### Deploy Faucet ###########

    # if not faucet_address and network.show_active() != mainnet:
    #     faucet = deploy_contract(
    #         admin,
    #         network,
    #         Faucet,
    #         [token_contract_address, admin.address, 1683475200],
    #     )
    #     transact(
    #         token_contract.address,
    #         token_contract.abi,
    #         "approveAddress",
    #         faucet.address,
    #         sender=admin,
    #     )
    #     faucet_address = faucet.address
    # elif network.show_active() != mainnet:
    #     faucet = Faucet.at(faucet_address)

    # ########### Router ###########

    # if not router_contract_address:
    #     router_contract = deploy_contract(
    #         admin,
    #         network,
    #         RouterV2,
    #         [publisher, account_registrar.address],
    #     )
    #     router_contract_address = router_contract.address

    #     transact(
    #         router_contract.address,
    #         router_contract.abi,
    #         "setKeeper",
    #         open_keeper,
    #         True,
    #         sender=admin,
    #     )
    #     transact(
    #         router_contract.address,
    #         router_contract.abi,
    #         "setKeeper",
    #         close_keeper,
    #         True,
    #         sender=admin,
    #     )
    # else:
    #     router_contract = RouterV2.at(router_contract_address)

    # ########### Deploy Market Contract ###########

    # if not market_contract_address:
    #     market_contract = deploy_contract(
    #         admin,
    #         network,
    #         MarketContract,
    #         [token_contract_address, fee_address],
    #     )
    #     market_contract_address = market_contract.address
    # else:
    #     market_contract = MarketContract.at(market_contract_address)

    # ########### Grant Roles ###########

    # ROUTER_ROLE = market_contract.ROUTER_ROLE()
    # ADMIN_ROLE = account_registrar.ADMIN_ROLE()

    # transact(
    #     account_registrar.address,
    #     account_registrar.abi,
    #     "grantRole",
    #     ADMIN_ROLE,
    #     router_contract_address,
    #     sender=admin,
    # )
    # transact(
    #     account_registrar.address,
    #     account_registrar.abi,
    #     "grantRole",
    #     ADMIN_ROLE,
    #     open_keeper,
    #     sender=admin,
    # )
    # transact(
    #     market_contract.address,
    #     market_contract.abi,
    #     "grantRole",
    #     ROUTER_ROLE,
    #     router_contract_address,
    #     sender=admin,
    # )
    # transact(
    #     router_contract.address,
    #     router_contract.abi,
    #     "setContractRegistry",
    #     market_contract_address,
    #     True,
    #     sender=admin,
    # )

    # all_contractss = {
    #     "faucet": faucet.address if network.show_active() != mainnet else "",
    #     "router": router_contract.address,
    #     "token": token_contract_address,
    #     "market_contract": market_contract.address,
    #     "account_registrar": account_registrar.address,
    # }

    # print(all_contractss)
