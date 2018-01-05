sudo apt update -y
sudo apt install git -y
git clone https://github.com/fireworm71/veriumMiner
sudo apt install automake autoconf pkg-config libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev zlib1g-dev -y
cd veriumMiner
./build.sh
echo ./cpuminer -n 1048576 -o stratum+tcp://eu.vrm.mining-pool.ovh:3032 -u WfqGj6Cp2lW8tabDCT_2.WorkerName -p WorkerPassword > run.sh
chmod +x run.sh
