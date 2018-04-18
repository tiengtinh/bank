# bank

The Bank Business Network

```bash
export FABRIC_VERSION=hlfv11
./downloadFabric.sh
./startFabric.sh
# create and import business network card
# Card file: /tmp/PeerAdmin@hlfv1.card
# Card name: PeerAdmin@hlfv1
./createPeerAdminCard.sh

composer card list
# get details a specific card
composer card list --card <Card Name>
```

yo hyperledger-composer
composer-playground

## Create

```bash
# Output file: bank@0.0.1.bna
composer archive create --sourceType dir --sourceName bank
composer network install --card PeerAdmin@hlfv1 --archiveFile bank\@0.0.1.bna 
# create business network card:
# Filename: admin@bank.card
composer network start --networkName bank --networkVersion 0.0.1 --networkAdmin admin --networkAdminEnrollSecret adminpw --card PeerAdmin@hlfv1
composer card import -f admin\@bank.card
composer network ping -c admin\@bank
```

## Update
```bash
composer archive create --sourceType dir --sourceName . --archiveFile bank@0.0.2.bna
composer network install --card PeerAdmin@hlfv1 --archiveFile bank/bank\@0.0.2.bna
composer network upgrade --networkName bank --networkVersion 0.0.2 --card PeerAdmin@hlfv1
```

```bash
composer-rest-server
```