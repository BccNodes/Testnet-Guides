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

# QuickSilver Manuel node kurulumu

<p align="center">
  <img height="220" height="auto" src="quicksilver.png">
</p>

Quicksilver Discord:
>- [Discord](https://discord.gg/FPcUhJ3x)

Explorer:
>- https://explorer.bccnodes.com/quicksilver

## Sistem Gereksinimleri

| Node Tipi | CPU |  RAM  | Depolama  |     OS       | GO Version|
|-----------|-----|-------|-----------|--------------|-----------|
| Testnet   |  4  | 8GB   |   250GB   | Ubuntu 20.04 | Go v1.19.3|

## Gerekli güncellemeleri ve araçları kurunuz
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt-get install make build-essential gcc git jq chrony screen -y
```
## Go yükleyin
```
sudo rm -rvf /usr/local/go/
wget https://golang.org/dl/go1.19.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.19.3.linux-amd64.tar.gz
rm go1.19.3.linux-amd64.tar.gz
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
```
>> `go version` çıktısı `go version go1.19.3 linux/amd64` olmalıdır

## Moniker ismimizi atayalım
```
NODENAME=<MONIKER_ISMINIZI_GİRİN>
```

## Github reposunun bir kopyasını oluşturun ve kurun
```
cd $HOME
git clone https://github.com/ingenuity-build/quicksilver
cd quicksilver
git checkout v1.0.0
make install
```

## Versiyonu kontrol edelim; v1.0.0 olmalı
```
quicksilverd version
```

## Nodeu çalıştırmaya hazırlanalım
```
quicksilverd config keyring-backend test
quicksilverd config chain-id quicksilver-1
quicksilverd init $NODENAME --chain-id quicksilver-1
quicksilverd config node tcp://localhost:26657
```


Cüzdan oluşturalım veya var olan cüzdanı geri getirelim

```quicksilverd keys add wallet```             #Yeni oluşturmak için

``` quicksilverd keys add wallet --recover ``` #Cüzdan kelimlerinizi kullanarak geri getirmek için



## Genesis ve addrbook yükleyelim
```
 wget -O ~/.quicksilverd/config/genesis.json https://raw.githubusercontent.com/ingenuity-build/mainnet/main/genesis.json
```

## Peers ayarlayalım
```
SEEDS="20e1000e88125698264454a884812746c2eb4807@seeds.lavenderfive.com:11156,babc3f3f7804933265ec9c40ad94f4da8e9e0017@seed.rhinostake.com:11156,00f51227c4d5d977ad7174f1c0cea89082016ba2@seed-quick-mainnet.moonshot.army:26650"
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/" ~/.quicksilverd/config/config.toml
```

## Minimum gas değerini ayarlayalım
```
sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.025uqck"/g' $HOME/.quicksilverd/config/app.toml
```


## Zincir verilerini sıfırlayalım
```
quicksilverd tendermint unsafe-reset-all --home $HOME/.quicksilverd
```


## Servis Oluşturalım
```
sudo tee  /etc/systemd/system/quicksilverd.service /dev/null <<EOF

[Unit]
Description=Quicksilver Service
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME
ExecStart=$HOME/go/bin/quicksilverd start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

## Nodeu Başlatalım
```
sudo systemctl daemon-reload && systemctl enable quicksilverd
sudo systemctl restart quicksilverd && journalctl -o cat -fu quicksilverd
```
## Senkronizasyon durumunu kotnrol edelim ve çıktı false olduğunda discrod kanalından token alıp validator oluşturalım
```
quicksilverd status 2>&1 | jq .SyncInfo
```

## Validator Oluşturalım
>> Cüzdan bakiyesini kontrol etmek için; `quicksilverd query bank balances CÜZDANADRESİNİZ`
```
quicksilverd tx staking create-validator \
--amount 9000000uqck \
--commission-max-change-rate "0.1" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--website="" \
--identity= \
--pubkey=$(quicksilverd tendermint show-validator) \
--moniker $NODENAME \
--chain-id quicksilver-1 \
 --from wallet --node http://75.119.144.167:26657
```

### İşe yarar komutlar
Logları kontrol et
```
journalctl -fu quicksilverd -o cat
```

Servisi başlat
```
sudo systemctl start quicksilverd
```

Servisi durdur
```
sudo systemctl stop quicksilverd
```

Servisi yeniden başlat
```
sudo systemctl restart quicksilverd
```
Delegate stake
```
quicksilverd tx staking delegate $(quicksilverd keys show wallet --bech val -a) 10000000uqck --from=wallet --chain-id=testnet-1 --gas=auto
```

# BccNodes API && RPC && STATE-SYNC && SNAPSHOT && ADDRBOOK 

### Endpoints:
>- [BccNodes API endpoint](https://quicksilver.api.bccnodes.com/)

>- [BccNodes RPC endpoint](https://quicksilver.rpc.bccnodes.com/)

>- [BccNodes gRPC endpoint](https://quicksilver.grpc.bccnodes.com:19090)

### Snapshot 

```
https://github.com/BccNodes/Snapshot-Statesync/blob/main/QuickSilver%20Mainnet/readme.md
```

### Addrbook
```
wget -O $HOME/.quicksilverd/config/addrbook.json "https://raw.githubusercontent.com/BccNodes/Snapshot-Statesync/main/QuickSilver%20Mainnet/addrbook.json"

```
