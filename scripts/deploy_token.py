import os
from brownie import (
    USDC,
    accounts,
    network,
)
from .utility import deploy_contract


def main():

    admin = accounts.add(os.environ["BFR_PK"])
    token_contract = deploy_contract(
        admin,
        network,
        USDC,
        [],
    )

    print("Token Contract", token_contract.address)