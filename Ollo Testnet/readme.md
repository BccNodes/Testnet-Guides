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

# Ollo Testnet Manuel node kurulumu

<p align="center">
  <img height="220" height="auto" src="ollo.png">
</p>

Orijinal Döküman:
>- [Doğrulayıcı kurulum talimatları](https://docs.ollo.zone/join/running_a_node)

Explorer:
>- https://explorer.bccnodes.com/ollo

## Sistem Gereksinimleri

| Node Tipi | CPU |  RAM  | Depolama  |     OS       | GO Version|
|-----------|-----|-------|-----------|--------------|-----------|
| Testnet   |  4  | 8GB   |   200GB   | Ubuntu 20.04 | Go v1.19.1|

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
git clone https://github.com/OllO-Station/ollo.git
cd ollo
git checkout v0.0.1
make install
```

## Versiyonu kontrol edelim; v0.0.1 olmalı
```
ollod version
```

## Nodeu çalıştırmaya hazırlanalım
```
ollod config keyring-backend test
ollod config chain-id ollo-testnet-1
ollod init $NODENAME --chain-id ollo-testnet-1
ollod config node tcp://localhost:26657
```
Cüzdan oluşturalım veya var olan cüzdanı geri getirelim

```ollod keys add wallet                ``` #Yeni oluşturmak için

``` ollod keys add CÜZDANİSMİ --recover ``` #Cüzdan kelimlerinizi kullanarak geri getirmek için



## Genesis ve addrbook yükleyelim
```
wget -O ~/.ollo/config/genesis.json https://raw.githubusercontent.com/OllO-Station/networks/master/ollo-testnet-1/genesis.json
wget -O ~/.ollo/config/addrbook.json https://raw.githubusercontent.com/OLLO-Station/networks/master/ollo-testnet-1/addrbook.json
```

## Peers ayarlayalım
```
SEEDS=""
PEERS="a99fc4e81770ca32d574cac2e8680dccc9b55f74@18.144.61.148:26656,70ba32724461c7ed4ec8d6ddc8b5e0b1cfb9e237@54.219.57.63:26656,7864a2e4b42e5af76a83a8b644b9172fa1e40fa5@52.8.174.235:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.ollo/config/config.toml
```

## Pruning Yapılandıralım ( İsteğe bağlı)
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.ollo/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.ollo/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.ollo/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.ollo/config/app.toml
```
## Indexer'ı devre dışı bırakalım ( İsteğe bağlı)
```
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.ollo/config/config.toml
```

## Zincir verilerini sıfırlayalım
```
ollod tendermint unsafe-reset-all --home $HOME/.ollo
```


## Servis Oluşturalım
```
sudo tee /etc/systemd/system/ollod.service > /dev/null <<EOF
[Unit]
Description=ollo
After=network-online.target

[Service]
User=$USER
ExecStart=$(which ollod) start --home $HOME/.ollo
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

## Nodeu Başlatalım
```
sudo systemctl daemon-reload && systemctl enable ollod
sudo systemctl restart ollod && journalctl -o cat -fu ollod
```
## Senkronizasyon durumunu kotnrol edelim ve çıktı false olduğunda discrod kanalından token alıp validator oluşturalım
```
ollod status 2>&1 | jq .SyncInfo
```

## Validator Oluşturalım
>> Cüzdan bakiyesini kontrol etmek için; `ollod query bank balances CÜZDANADRESİNİZ`
```
ollod tx staking create-validator \
  --amount 1000000utollo \
  --from wallet \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(ollod tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id ollo-testnet-1
```

### İşe yarar komutlar
Logları kontrol et
```
journalctl -fu ollod -o cat
```

Servisi başlat
```
sudo systemctl start ollod
```

Servisi durdur
```
sudo systemctl stop ollod
```

Servisi yeniden başlat
```
sudo systemctl restart ollod
```
Delegate stake
```
ollod tx staking delegate $(ollod keys show wallet --bech val -a) 10000000utollo --from=wallet --chain-id=ollo-testnet-1 --gas=auto
```

