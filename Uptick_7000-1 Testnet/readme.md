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

# Uptick_7000-1 Testnet Manuel node kurulumu

<p align="center">
  <img height="220" height="auto" src="uptick.png">
</p>

Uptick Discord:
>- [Discord](https://github.com/defund-labs/testnet/tree/main/defund-private-2)

Explorer:
>- https://explorer.bccnodes.com/uptick

## Sistem Gereksinimleri

| Node Tipi | CPU |  RAM  | Depolama  |     OS       | GO Version|
|-----------|-----|-------|-----------|--------------|-----------|
| Testnet   |  4  | 16GB  |   200GB   | Ubuntu 20.04 | Go v1.19.1|

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
curl -L -k https://github.com/UptickNetwork/uptick/releases/download/v0.2.4/uptick-linux-amd64-v0.2.4.tar.gz > uptick.tar.gz
tar -xvzf uptick.tar.gz
sudo mv -f uptick-linux-amd64-v0.2.4/uptickd /usr/local/bin/uptickd
rm -rf uptick.tar.gz
rm -rf uptick-v0.2.4
```

## Versiyonu kontrol edelim; v0.2.4 olmalı
```
uptickd version
```

## Nodeu çalıştırmaya hazırlanalım
```
uptickd config keyring-backend test
uptickd config chain-id defund-private-3
uptickd init $NODENAME --chain-id uptick_7000-1
uptickd config node tcp://localhost:26657
```
Cüzdan oluşturalım veya var olan cüzdanı geri getirelim

```uptickd keys add CÜZDANİSMİ```             #Yeni oluşturmak için

``` uptickd keys add CÜZDANİSMİ --recover ``` #Cüzdan kelimlerinizi kullanarak geri getirmek için



## Genesis ve addrbook yükleyelim
```
curl -o $HOME/.uptickd/config/config.toml https://raw.githubusercontent.com/UptickNetwork/uptick-testnet/main/uptick_7000-1/config.toml
curl -o $HOME/.uptickd/config/genesis.json https://raw.githubusercontent.com/UptickNetwork/uptick-testnet/main/uptick_7000-1/genesis.json
curl -o $HOME/.uptickd/config/app.toml https://raw.githubusercontent.com/UptickNetwork/uptick-testnet/main/uptick_7000-1/app.toml
```

## Peers ayarlayalım
```
seeds="61f9e5839cd2c56610af3edd8c3e769502a3a439@seed0.testnet.uptick.network:26656"
peers="eecdfb17919e59f36e5ae6cec2c98eeeac05c0f2@peer0.testnet.uptick.network:26656,178727600b61c055d9b594995e845ee9af08aa72@peer1.testnet.uptick.network:26656,61f9e5839cd2c56610af3edd8c3e769502a3a439@seed0.testnet.uptick.network:26656"
sed -i -e 's|^seeds *=.*|seeds = "'$seeds'"|; s|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.uptickd/config/config.toml
```

## Minimum gas değerini ayarlayalım
```
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001auptick"|g' $HOME/.uptickd/config/app.toml
```

## Pruning Yapılandıralım ( İsteğe bağlı)
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.defund/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.uptickd/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.uptickd/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.uptickd/config/app.toml
```
## Indexer'ı devre dışı bırakalım ( İsteğe bağlı)
```
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.uptickd/config/config.toml
```

## Zincir verilerini sıfırlayalım
```
uptickd tendermint unsafe-reset-all --home $HOME/.defund
```


## Servis Oluşturalım
```
sudo tee  /etc/systemd/system/uptickd.service /dev/null <<EOF
[Unit]
Description=Defund Service
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME
ExecStart=$HOME/go/bin/uptickd start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

## Nodeu Başlatalım
```
sudo systemctl daemon-reload && systemctl enable uptickd
sudo systemctl restart uptickd && journalctl -o cat -fu uptickd
```
## Senkronizasyon durumunu kotnrol edelim ve çıktı false olduğunda discrod kanalından token alıp validator oluşturalım
```
uptickd status 2>&1 | jq .SyncInfo
```

## Validator Oluşturalım
>> Cüzdan bakiyesini kontrol etmek için; `uptickd query bank balances CÜZDANADRESİNİZ`
```
uptickd tx staking create-validator \
  --amount 4900000000000000000auptick \
  --from wallet \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(uptickd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id uptick_7000-1 \
  --fees 20auptick
```

### İşe yarar komutlar
Logları kontrol et
```
journalctl -fu uptickd -o cat
```

Servisi başlat
```
sudo systemctl start uptickd
```

Servisi durdur
```
sudo systemctl stop uptickd
```

Servisi yeniden başlat
```
sudo systemctl restart uptickd
```
Delegate stake
```
uptickd tx staking delegate $(uptickd keys show wallet --bech val -a) 10000000auptick --from=wallet --chain-id=uptick_7000-1 --gas=auto
```

# BccNodes API && RPC && STATE-SYNC && ADDRBOOK 

### Endpoints:
>- [BccNodes API endpoint](https://uptick.api.bccnodes.com/)

>- [BccNodes RPC endpoint](https://uptick.rpc.bccnodes.com/)

>- [BccNodes gRPC endpoint](https://uptick.grpc.bccnodes.com:20090)

### State Sync 

```
ŞİMDİLİK ÇALIŞMIYOR
```

### Addrbook
```
wget -O $HOME/.uptickd/config/addrbook.json "https://raw.githubusercontent.com/BccNodes/Testnet-Guides/main/Uptick_7000-1%20Testnet/addrbook.json"

```
