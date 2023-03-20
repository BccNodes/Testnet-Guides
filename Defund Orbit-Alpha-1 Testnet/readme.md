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

# Defund Oribt-Alpha-1 Testnet Manuel node kurulumu

<p align="center">
  <img height="220" height="auto" src="defund.png">
</p>

Orijinal Döküman:
>- [Doğrulayıcı kurulum talimatları](https://github.com/defund-labs/testnet/tree/main/defund-private-2)

Explorer:
>- https://explorer.bccnodes.com/defund

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
rm -rf defund
git clone https://github.com/defund-labs/defund.git
cd defund
git checkout v0.2.6
make install
```

## Versiyonu kontrol edelim; v0.2.6 olmalı
```
defundd version
```

## Nodeu çalıştırmaya hazırlanalım
```
defundd config chain-id orbit-alpha-1
defundd config keyring-backend test
defundd init $NODENAME --chain-id orbit-alpha-1
defundd config node tcp://localhost:26657
```
Cüzdan oluşturalım veya var olan cüzdanı geri getirelim

```defundd keys add CÜZDANİSMİ```             #Yeni oluşturmak için

``` defundd keys add CÜZDANİSMİ --recover ``` #Cüzdan kelimlerinizi kullanarak geri getirmek için



## Genesis ve addrbook yükleyelim
```
wget -O $HOME/.defund/config/addrbook.json "https://raw.githubusercontent.com/BccNodes/Snapshot-Statesync/main/Defund%20orbit-alpha-1%20Testnet/addrbook.json"
wget -O $HOME/.defund/config/genesis.json "https://raw.githubusercontent.com/BccNodes/Snapshot-Statesync/main/Defund%20orbit-alpha-1%20Testnet/genesis.json"

```

## Seeds ayarlayalım
```
sed -i -e "s|^seeds *=.*|seeds = \"3f472746f46493309650e5a033076689996c8881@defund-testnet.rpc.kjnodes.com:40659\"|" $HOME/.defund/config/config.toml
```

## Minimum gas değerini ayarlayalım
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025ufetf\"/" ~/.defund/config/app.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 150/g' ~/.defund/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 150/g' ~/.defund/config/config.toml
```

## Pruning Yapılandıralım ( İsteğe bağlı)
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.defund/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.defund/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.defund/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.defund/config/app.toml
```
## Indexer'ı devre dışı bırakalım ( İsteğe bağlı)
```
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.defund/config/config.toml
```

## Zincir verilerini sıfırlayalım
```
defundd tendermint unsafe-reset-all --home $HOME/.defund
```


## Servis Oluşturalım
```
sudo tee  /etc/systemd/system/defundd.service /dev/null <<EOF
[Unit]
Description=Defund Service
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME
ExecStart=$HOME/go/bin/defundd start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

## Nodeu Başlatalım
```
sudo systemctl daemon-reload && systemctl enable defundd
sudo systemctl restart defundd && journalctl -o cat -fu defundd
```
## Senkronizasyon durumunu kotnrol edelim ve çıktı false olduğunda discrod kanalından token alıp validator oluşturalım
```
defundd status 2>&1 | jq .SyncInfo
```

## Validator Oluşturalım
>> Cüzdan bakiyesini kontrol etmek için; `defundd query bank balances CÜZDANADRESİNİZ`
```
defundd tx staking create-validator \
  --amount 5000000ufetf \
  --from wallet \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.05" \
  --min-self-delegation "1" \
  --pubkey  $(defundd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id defund-private-2 \
  --fees=2000ufetf
```

### İşe yarar komutlar
Logları kontrol et
```
journalctl -fu defundd -o cat
```

Servisi başlat
```
sudo systemctl start defundd
```

Servisi durdur
```
sudo systemctl stop defundd
```

Servisi yeniden başlat
```
sudo systemctl restart defundd
```
Delegate stake
```
defundd tx staking delegate $(defundd keys show wallet --bech val -a) 10000000ufetf --from=wallet --chain-id=defund-private-2 --gas=auto
```

# BccNodes API && RPC && STATE-SYNC && ADDRBOOK 

### Endpoints:
>- [BccNodes API endpoint](https://defund.api.bccnodes.com/)

>- [BccNodes RPC endpoint](https://defund.rpc.bccnodes.com/)


```


