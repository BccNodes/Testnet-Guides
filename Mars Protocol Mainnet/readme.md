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
            <a href="https://bccnodes.net/" target="_blank" rel="noopener noreferrer">
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

# Mars Protocol Mainnet Manuel node kurulumu

<p align="center">
  <img height="220" height="auto" src="mars.png">
</p>

C4E Discord:
>- [Discord](https://discord.gg/chain4energy)

Explorer:
>- https://explorer.bccnodes.com/chain4energy

## Sistem Gereksinimleri

| Node Tipi | CPU |  RAM  | Depolama  |     OS       | GO Version|
|-----------|-----|-------|-----------|--------------|-----------|
| Mainnet   |  4  | 16GB  |   300GB   | Ubuntu 20.04 | Go v1.19.1|

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
git clone https://github.com/mars-protocol/hub.git
cd hub
git checkout v1.0.0
make install

```

## Versiyonu kontrol edelim; v1.0.1 olmalı
```
marsd version
```

## Nodeu çalıştırmaya hazırlanalım
```
marsd config keyring-backend test
marsd config chain-id perun-1
marsd init $NODENAME --chain-id mars-1
marsd config node tcp://localhost:26657
```
Cüzdan oluşturalım veya var olan cüzdanı geri getirelim

```marsd keys add CÜZDANİSMİ```             #Yeni oluşturmak için

``` marsd keys add CÜZDANİSMİ --recover ``` #Cüzdan kelimlerinizi kullanarak geri getirmek için



## Genesis ve addrbook yükleyelim
```
wget https://raw.githubusercontent.com/mars-protocol/networks/main/mars-1/genesis.json -O $HOME/.mars/config/genesis.json

wget -O $HOME/.c4e-chain/config/addrbook.json "https://raw.githubusercontent.com/BccNodes/Testnet-Guides/main/Chain4Energy%20Mainnet/addrbook.json"

```

## Peers ayarlayalım
```
seeds="52de8a7e2ad3da459961f633e50f64bf597c7585@seed.marsprotocol.io:443,d2d2629c8c8a8815f85c58c90f80b94690468c4f@tenderseed.ccvalidators.com:26012"
peers=""
sed -i -e 's|^seeds *=.*|seeds = "'$seeds'"|; s|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.mars/config/config.toml
```

## Minimum gas değerini ayarlayalım
```
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.000umars"|g' $HOME/.mars/config/app.toml
```


i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.c4e-chain/config/config.toml
```

## Zincir verilerini sıfırlayalım
```
marsd tendermint unsafe-reset-all --home $HOME/.mars
```


## Servis Oluşturalım
```
sudo tee  /etc/systemd/system/marsd.service /dev/null <<EOF
[Unit]
Description=mars
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME
ExecStart=$(which marsd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

## Nodeu Başlatalım
```
sudo systemctl daemon-reload && systemctl enable marsd
sudo systemctl restart marsd && journalctl -o cat -fu marsd
```
## Senkronizasyon durumunu kotnrol edelim ve çıktı false olduğunda discrod kanalından token alıp validator oluşturalım
```
marsd status 2>&1 | jq .SyncInfo
```

## Validator Oluşturalım
>> Cüzdan bakiyesini kontrol etmek için; `marsd query bank balances CÜZDANADRESİNİZ`
```
marsd tx staking create-validator \
--amount 9000000umars \
--commission-max-change-rate "0.1" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "Professionally managed institutional grade blockchain infrastructure provider." \
--website="https://bccnodes.com/" \
--identity=C5337EB8B55DFA0C \
--pubkey=$(marsd tendermint show-validator) \
--moniker $NODENAME \
--chain-id mars-1 \
--gas-prices 0.025umars \
--from wallet
```

### İşe yarar komutlar
Logları kontrol et
```
journalctl -fu marsd -o cat
```

Servisi başlat
```
sudo systemctl start marsd
```

Servisi durdur
```
sudo systemctl stop marsd
```

Servisi yeniden başlat
```
sudo systemctl restart marsd
```
Delegate stake
```
marsd tx staking delegate $(marsd keys show wallet --bech val -a) 10000000umars --from=wallet --chain-id=mars-1 --gas=auto
```

# BccNodes API && RPC && STATE-SYNC && ADDRBOOK 

### Endpoints:
>- [BccNodes API endpoint](https://mars.api.bccnodes.com/)

>- [BccNodes RPC endpoint](https://mars.rpc.bccnodes.com/)

>- [BccNodes gRPC endpoint](https://mars.grpc.bccnodes.com:20090)

### State Sync 

```
NA
```

### Addrbook
```
NA

```

