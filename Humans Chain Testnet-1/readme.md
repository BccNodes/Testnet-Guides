<table width="900px" align="center">
    <tbody>
        <tr valign="top">
            <td width="300px" align="center">
            <span><strong>Twitter</strong></span><br><br />
            <a href="https://twitter.com/bccnodes" target="_blank" rel="noopener noreferrer">
            <img height="70px" src="https://github.com/berkcaNode/berkcaNode/blob/main/twitter.png">
            </td>
            <td width="300px" align="center">
            <span><strong>Website</strong></span><br><br />
            <a href="https://bccnodes.com/" target="_blank" rel="noopener noreferrer">
            <img height="70px" src="https://github.com/berkcaNode/berkcaNode/blob/main/web.png">
            </td>
            <td width="300px" align="center">
            <span><strong>BccNodes Explorer</strong></span><br><br />
            <a href="https://explorer.bccnodes.com/" target="_blank" rel="noopener noreferrer">
            <img height="70px" src="https://github.com/berkcaNode/berkcaNode/blob/main/exp%20(1).png">
            </td>
        </tr>
    </tbody>
</table>

# Humans Chain Testnet Manuel node kurulumu

<p align="center">
  <img height="220" height="auto" src="humans.jpg">
</p>

Humans Discord:
>- [Discord](https://discord.gg/humansdotai)

Explorer:
>- https://explorer.bccnodes.com/humans

## Sistem Gereksinimleri

| Node Tipi | CPU |  RAM  | Depolama  |     OS       | GO Version|
|-----------|-----|-------|-----------|--------------|-----------|
| Testnet   |  4  | 8GB   |   250GB   | Ubuntu 20.04 | Go v1.19.1|

## Gerekli güncellemeleri ve araçları kurunuz
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt-get install make build-essential gcc git jq chrony screen -y
```
## Go yükleyin (tek komut)
```
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
```
>> `go version` çıktısı `go version go1.19.1 linux/amd64` olmalıdır

## Moniker ismimizi atayalım
```
NODENAME=<MONIKER_ISMINIZI_GİRİN>
```

## Github reposunun bir kopyasını oluşturun ve kurun
```
cd $HOME
rm -rf humans
git clone https://github.com/humansdotai/humans
cd humans
git checkout v1.0.0
go build -o humansd cmd/humansd/main.go
sudo mv $HEART /usr/bin/
```

## Versiyonu kontrol edelim; v1.0.0 olmalı
```
humansd version
```

## Nodeu çalıştırmaya hazırlanalım
```
humansd config keyring-backend test
humansd config chain-id testnet-1
humansd init $NODENAME --chain-id testnet-1
humansd config node tcp://localhost:26657
```
Cüzdan oluşturalım veya var olan cüzdanı geri getirelim

```humansd keys add wallet```             #Yeni oluşturmak için

``` humansd keys add wallet --recover ``` #Cüzdan kelimlerinizi kullanarak geri getirmek için



## Genesis ve addrbook yükleyelim
```
curl -s https://rpc-testnet.humans.zone/genesis | jq -r .result.genesis > genesis.json
cp genesis.json $HOME/.humans/config/genesis.json
```

## Peers ayarlayalım
```
seeds=""
peers="1df6735ac39c8f07ae5db31923a0d38ec6d1372b@45.136.40.6:26656,9726b7ba17ee87006055a9b7a45293bfd7b7f0fc@45.136.40.16:26656,6e84cde074d4af8a9df59d125db3bf8d6722a787@45.136.40.18:26656,eda3e2255f3c88f97673d61d6f37b243de34e9d9@45.136.40.13:26656"
sed -i -e 's|^seeds *=.*|seeds = "'$seeds'"|; s|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.humans/config/config.toml
```

## Minimum gas değerini ayarlayalım
```
sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.025uheart"/g' $HOME/.humans/config/app.toml
```

## Blok süresi parametrelerini ayarlayalım
```
 sed -i 's/timeout_propose =.*/timeout_propose = "100ms"/g' $HOME/.humans/config/config.toml
 sed -i 's/timeout_propose_delta =.*/timeout_propose_delta = "500ms"/g' $HOME/.humans/config/config.toml
 sed -i 's/timeout_prevote =.*/timeout_prevote = "100ms"/g' $HOME/.humans/config/config.toml
 sed -i 's/timeout_prevote_delta =.*/timeout_prevote_delta = "500ms"/g' $HOME/.humans/config/config.toml
 sed -i 's/timeout_precommit =.*/timeout_precommit = "100ms"/g' $HOME/.humans/config/config.toml
 sed -i 's/timeout_precommit_delta =.*/timeout_precommit_delta = "500ms"/g' $HOME/.humans/config/config.toml
 sed -i 's/timeout_commit =.*/timeout_commit = "1s"/g' $HOME/.humans/config/config.toml
 sed -i 's/skip_timeout_commit =.*/skip_timeout_commit = false/g' $HOME/.humans/config/config.toml
```

## Pruning Yapılandıralım ( İsteğe bağlı)
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.humans/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.humans/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.humans/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.humans/config/app.toml
```
## Indexer'ı devre dışı bırakalım ( İsteğe bağlı)
```
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.humans/config/config.toml
```

## Zincir verilerini sıfırlayalım
```
humansd tendermint unsafe-reset-all --home $HOME/.humans
```


## Servis Oluşturalım
```
sudo tee  /etc/systemd/system/humansd.service /dev/null <<EOF
[Unit]
Description=Humans Service
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME
ExecStart=$HOME/go/bin/humansd start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

## Nodeu Başlatalım
```
sudo systemctl daemon-reload && systemctl enable humansd
sudo systemctl restart humansd && journalctl -o cat -fu humansd
```
## Senkronizasyon durumunu kotnrol edelim ve çıktı false olduğunda discrod kanalından token alıp validator oluşturalım
```
humansd status 2>&1 | jq .SyncInfo
```

## Validator Oluşturalım
>> Cüzdan bakiyesini kontrol etmek için; `humansd query bank balances CÜZDANADRESİNİZ`
```
humansd tx staking create-validator \
--amount 10000000uheart \
--commission-max-change-rate "0.1" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "put your validator description there" \
--pubkey=$(humansd tendermint show-validator) \
--moniker <your_moniker> \
--chain-id testnet-1 \
--gas-prices 0.025uheart \
--from wallet
```

### İşe yarar komutlar
Logları kontrol et
```
journalctl -fu humansd -o cat
```

Servisi başlat
```
sudo systemctl start humansd
```

Servisi durdur
```
sudo systemctl stop humansd
```

Servisi yeniden başlat
```
sudo systemctl restart humansd
```
Delegate stake
```
humansd tx staking delegate $(humansd keys show wallet --bech val -a) 10000000uheart --from=wallet --chain-id=testnet-1 --gas=auto
```

# BccNodes API && RPC && STATE-SYNC && SNAPSHOT && ADDRBOOK 

### Endpoints:
>- [BccNodes API endpoint](https://humans.api.bccnodes.com/)

>- [BccNodes RPC endpoint](https://humans.rpc.bccnodes.com/)

>- [BccNodes gRPC endpoint](https://humans.grpc.bccnodes.com:12090)

### Snapshot 

```
https://github.com/BccNodes/Snapshot-Statesync/blob/main/Humans%20Testnet-1/readme.md
```

### Addrbook
```
wget -O $HOME/.humans/config/addrbook.json "https://raw.githubusercontent.com/BccNodes/Snapshot-Statesync/main/Humans%20Testnet-1/addrbook.json"

```
