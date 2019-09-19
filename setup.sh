echo "Setting up the network.."

echo "Creating channel genesis block.."

# Create the channel
docker exec -e "CORE_PEER_LOCALMSPID=bank1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/bank1.kyc.com/users/Admin@bank1.kyc.com/msp" -e "CORE_PEER_ADDRESS=peer0.bank1.kyc.com:7051" cli peer channel create -o orderer.kyc.com:7050 -c tfbcchannel -f /etc/hyperledger/configtx/tfbcchannel.tx


sleep 5

echo "Channel genesis block created."

echo "peer0.bank1.kyc.com joining the channel..."
# Join peer0.bank1.kyc.com to the channel.
docker exec -e "CORE_PEER_LOCALMSPID=bank1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/bank1.kyc.com/users/Admin@bank1.kyc.com/msp" -e "CORE_PEER_ADDRESS=peer0.bank1.kyc.com:7051" cli peer channel join -b tfbcchannel.block

echo "peer0.bank1.kyc.com joined the channel"

echo "peer0.bank2.kyc.com joining the channel..."

# Join peer0.bank2.kyc.com to the channel.
docker exec -e "CORE_PEER_LOCALMSPID=bank2MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/bank2.kyc.com/users/Admin@bank2.kyc.com/msp" -e "CORE_PEER_ADDRESS=peer0.bank2.kyc.com:7051" cli peer channel join -b tfbcchannel.block

echo "peer0.bank2.kyc.com joined the channel"

echo "peer0.bank3.kyc.com joining the channel..."
# Join peer0.bank3.kyc.com to the channel.
docker exec -e "CORE_PEER_LOCALMSPID=bank3MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/bank3.kyc.com/users/Admin@bank3.kyc.com/msp" -e "CORE_PEER_ADDRESS=peer0.bank3.kyc.com:7051" cli peer channel join -b tfbcchannel.block
sleep 5

echo "peer0.bank3.kyc.com joined the channel"

echo "Installing kyc chaincode to peer0.bank1.kyc.com..."

# install chaincode
# Install code on bank1 peer
docker exec -e "CORE_PEER_LOCALMSPID=bank1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/bank1.kyc.com/users/Admin@bank1.kyc.com/msp" -e "CORE_PEER_ADDRESS=peer0.bank1.kyc.com:7051" cli peer chaincode install -n kyc -v 1.0 -p github.com/kyc/go -l golang

echo "Installed kyc chaincode to peer0.bank1.kyc.com"

echo "Installing kyc chaincode to peer0.bank2.kyc.com...."

# Install code on bank2 peer
docker exec -e "CORE_PEER_LOCALMSPID=bank2MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/bank2.kyc.com/users/Admin@bank2.kyc.com/msp" -e "CORE_PEER_ADDRESS=peer0.bank2.kyc.com:7051" cli peer chaincode install -n kyc -v 1.0 -p github.com/kyc/go -l golang

echo "Installed kyc chaincode to peer0.bank2.kyc.com"

echo "Installing kyc chaincode to peer0.bank3.kyc.com..."
# Install code on bank3 peer
docker exec -e "CORE_PEER_LOCALMSPID=bank3MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/bank3.kyc.com/users/Admin@bank3.tfbc.com/msp" -e "CORE_PEER_ADDRESS=peer0.bank3.kyc.com:7051" cli peer chaincode install -n kyc -v 1.0 -p github.com/kyc/go -l golang

sleep 5

echo "Installed kyc chaincode to peer0.bank3.kyc.com"

echo "Instantiating kyc chaincode.."

docker exec -e "CORE_PEER_LOCALMSPID=Bank1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/bank1.kyc.com/users/Admin@bank1.kyc.com/msp" -e "CORE_PEER_ADDRESS=peer0.bank1.kyc.com:7051" cli peer chaincode instantiate -o orderer.tfbc.com:7050 -C tfbcchannel -n kyc -l golang -v 1.0 -c '{"Args":[""]}' -P "OR ('bank1MSP.member','bank2MSP.member','bank3MSP.member')"

echo "Instantiated kya chaincode."

echo "Following is the docker network....."

docker ps