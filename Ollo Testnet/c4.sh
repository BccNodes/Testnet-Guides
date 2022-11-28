#!/bin/bash
echo "=================================================="
echo "   _  ______  ___  __________________";
echo "  / |/ / __ \/ _ \/ __/  _/ __/_  __/";
echo " /    / /_/ / // / _/_/ /_\ \  / /   ";
echo "/_/|_/\____/____/___/___/___/ /_/    ";
echo -e "\e[0m"
echo "=================================================="


sleep 2

# DEGISKENLER by Nodeist
C4E_WALLET=wallet
C4E=c4ed
C4E_ID=perun-1
C4E_PORT=31
C4E_FOLDER=.c4e-chain
C4E_FOLDER2=c4e-chain
C4E_VER=v1.0.0
C4E_REPO=https://github.com/chain4energy/c4e-chain.git
C4E_GENESIS=https://raw.githubusercontent.com/chain4energy/c4e-chains/main/perun-1/genesis.json
C4E_ADDRBOOK=https://snapshots.nodestake.top/c4e/addrbook.json
C4E_MIN_GAS=0
C4E_DENOM=uc4e
C4E_SEEDS=
C4E_PEERS=96b621f209eb2244e6b0976a8918e1f6536d9a3d@34.208.153.193:26656,c1bfac5b59966c2fc97d48540b9614f34785fbf3@57.128.144.137:26656,f5d50df79f2aa5a9d18576147f59b8807347b6f9@66.70.178.78:26656,85acd1e5580c950f5ede07c3da4bd814d42cf323@95.179.190.59:26656,fe9a629d1bb3e1e958b2013b6747e3dbbd7ba8d3@149.102.130.176:26656,37f3f290c59dcce9109ac828e9839dc9c22be718@188.34.134.24:26656,bb9cbee9c391f5b0744d5da0ea1abc17ed0ca1b2@159.69.56.25:26656,2f6141859c28c088514b46f7783509aeeb87553f@141.94.193.12:11656

sleep 1

echo "export C4E_WALLET=${C4E_WALLET}" >> $HOME/.bash_profile
echo "export C4E=${C4E}" >> $HOME/.bash_profile
echo "export C4E_ID=${C4E_ID}" >> $HOME/.bash_profile
echo "export C4E_PORT=${C4E_PORT}" >> $HOME/.bash_profile
echo "export C4E_FOLDER=${C4E_FOLDER}" >> $HOME/.bash_profile
echo "export C4E_FOLDER2=${C4E_FOLDER2}" >> $HOME/.bash_profile
echo "export C4E_VER=${C4E_VER}" >> $HOME/.bash_profile
echo "export C4E_REPO=${C4E_REPO}" >> $HOME/.bash_profile
echo "export C4E_GENESIS=${C4E_GENESIS}" >> $HOME/.bash_profile
echo "export C4E_PEERS=${C4E_PEERS}" >> $HOME/.bash_profile
echo "export C4E_SEED=${C4E_SEED}" >> $HOME/.bash_profile
echo "export C4E_MIN_GAS=${C4E_MIN_GAS}" >> $HOME/.bash_profile
echo "export C4E_DENOM=${C4E_DENOM}" >> $HOME/.bash_profile
source $HOME/.bash_profile

sleep 1

if [ ! $C4E_NODENAME ]; then
	read -p "NODE ISMI YAZINIZ: " C4E_NODENAME
	echo 'export C4E_NODENAME='$C4E_NODENAME >> $HOME/.bash_profile
fi

echo -e "NODE ISMINIZ: \e[1m\e[32m$C4E_NODENAME\e[0m"
echo -e "CUZDAN ISMINIZ: \e[1m\e[32m$C4E_WALLET\e[0m"
echo -e "CHAIN ISMI: \e[1m\e[32m$C4E_ID\e[0m"
echo -e "PORT NUMARANIZ: \e[1m\e[32m$C4E_PORT\e[0m"
echo '================================================='

sleep 2


# GUNCELLEMELER by Nodeist
echo -e "\e[1m\e[32m1. GUNCELLEMELER YUKLENIYOR... \e[0m" && sleep 1
sudo apt update && sudo apt upgrade -y


# GEREKLI PAKETLER by Nodeist
echo -e "\e[1m\e[32m2. GEREKLILIKLER YUKLENIYOR... \e[0m" && sleep 1
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y

# GO KURULUMU by Nodeist
echo -e "\e[1m\e[32m1. GO KURULUYOR... \e[0m" && sleep 1
if ! [ -x "$(command -v go)" ]; then
  ver="1.19.1"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
  source $HOME/.bash_profile
fi

sleep 1

# KUTUPHANE KURULUMU by Nodeist
echo -e "\e[1m\e[32m1. REPO YUKLENIYOR... \e[0m" && sleep 1
cd $HOME
git clone $C4E_REPO
cd $C4E_FOLDER2
git checkout $C4E_VER
make install

sleep 1

# KONFIGURASYON by Nodeist
echo -e "\e[1m\e[32m1. KONFIGURASYONLAR AYARLANIYOR... \e[0m" && sleep 1
$C4E config chain-id $C4E_ID
$C4E config keyring-backend file
$C4E init $C4E_NODENAME --chain-id $C4E_ID

# ADDRBOOK ve GENESIS by Nodeist
wget $C4E_GENESIS -O $HOME/$C4E_FOLDER/config/genesis.json
wget $C4E_ADDRBOOK -O $HOME/$C4E_FOLDER/config/addrbook.json

# EŞLER VE TOHUMLAR by Nodeist
SEEDS="$C4E_SEEDS"
PEERS="$C4E_PEERS"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/$C4E_FOLDER/config/config.toml

sleep 1


# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$C4E_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$C4E_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$C4E_FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$C4E_FOLDER/config/app.toml


# ÖZELLEŞTİRİLMİŞ PORTLAR by Nodeist
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:2${C4E_PORT}8\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:2${C4E_PORT}7\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${C4E_PORT}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:2${C4E_PORT}6\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":2${C4E_PORT}0\"%" $HOME/$C4E_FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${C4E_PORT}7\"%; s%^address = \":8080\"%address = \":${C4E_PORT}80\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${C4E_PORT}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${C4E_PORT}91\"%" $HOME/$C4E_FOLDER/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:2${C4E_PORT}7\"%" $HOME/$C4E_FOLDER/config/client.toml

# PROMETHEUS AKTIVASYON by Nodeist
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/$C4E_FOLDER/config/config.toml

# MINIMUM GAS AYARI by Nodeist
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.00125$C4E_DENOM\"/" $HOME/$C4E_FOLDER/config/app.toml

# INDEXER AYARI by Nodeist
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/$C4E_FOLDER/config/config.toml

# RESET by Nodeist
$C4E tendermint unsafe-reset-all --home $HOME/$C4E_FOLDER

echo -e "\e[1m\e[32m4. SERVIS BASLATILIYOR... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/$C4E.service > /dev/null <<EOF
[Unit]
Description=$C4E
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which $C4E) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF


# SERVISLERI BASLAT by Nodeist
sudo systemctl daemon-reload
sudo systemctl enable $C4E
sudo systemctl restart $C4E

echo '=============== KURULUM TAMAM! by Nodeist ==================='
echo -e 'LOGLARI KONTROL ET: \e[1m\e[32mjournalctl -fu c4ed -o cat\e[0m'
echo -e "SENKRONIZASYONU KONTROL ET: \e[1m\e[32mcurl -s localhost:${C4E_PORT}657/status | jq .result.sync_info\e[0m"

source $HOME/.bash_profile
