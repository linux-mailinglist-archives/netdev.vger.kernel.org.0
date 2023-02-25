Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 295ED6A294D
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 12:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjBYLOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 06:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjBYLOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 06:14:53 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8339D269F
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 03:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1677323664; i=frank-w@public-files.de;
        bh=KJhXgc27XwaEZOrYo1mOVBq/F6nh+8qBMIPOJvcFJ00=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=U42UfHrcr1nSj5pnJ9g6TYni3SM9SECw/dQ5qfYqoyuhW6g9Yo4f/9pngM9/C/ydd
         ZCuaPdgNhfq5JJ82t2+CCY41fmtpU4Fb8teZN2W0oz1j0Qjh0hjFVtpVEpAs7EtFHW
         4sxDDvfnV10NOKkGMM2z+OTbLAaUXHsOMEHNfjFDHF6B25vd6VkkPZKcjdapDV6pjm
         uhDDqegn97Pbg2QVLjrhR782Thb2WgGoI5kDkxiQvqsMdY9sryNB+N2iX+ugwHpTYO
         3hoExZtUELQur1BPyZICpHTSQnU4KTdgbLMPb4Lswv4g5CkYhOFmMyQ1n9x+/Fdlgw
         IbKz2t/fuH7Mw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.154.5] ([217.61.154.5]) by web-mail.gmx.net
 (3c-app-gmx-bap06.server.lan [172.19.172.76]) (via HTTP); Sat, 25 Feb 2023
 12:14:24 +0100
MIME-Version: 1.0
Message-ID: <trinity-3a190e81-4797-4428-881b-7fb6dd2b19f5-1677323664480@3c-app-gmx-bap06>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     =?UTF-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Aw: Re: Choose a default DSA CPU port
Content-Type: text/plain; charset=UTF-8
Date:   Sat, 25 Feb 2023 12:14:24 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <20230224210852.np3kduoqhrbzuqg3@skbuf>
References: <trinity-4ef08653-c2e7-4da8-8572-4081dca0e2f7-1677271483935@3c-app-gmx-bap70>
 <20230224210852.np3kduoqhrbzuqg3@skbuf>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:8YNJZ4d3jFDYM5Nu3oXmeaY6m+rK6oF+ORsZgIFLbfCmFsWFJ1JgchG/Zr5ThfxaIxiT1
 0SZgzzXAvH93eyDyxH4VVWUXC8Wn4qvIfkuCa0SKHq+Nv5oX3OmhJGWu3bfzUy2qZza9Lrs0PnWM
 aICCdfwPYe1fR5VmswkiyFVyx16IsqiJHJGHTI3n3AxIf3JC+TK4O3qJcvyfeUB1zwSQDIRAJgnd
 wGy1Qp2uQhhmT2zjmsH6H1rxcag4X0flfTs9HCt9blfPyhgfd9Jrc0SFvvBBgTdp61yjam7quPe+
 JA=
UI-OutboundReport: notjunk:1;M01:P0:itETFq8zeKg=;viAK7Zyc70dcWb6ReI59K9267kW
 DCCOdMjEFsM5Qg/v4f+YjIGzMUZM827c9DwPg2uzDPEpFxjpmcS+KEW8gPQkGEmQ9Ch7XJ9N4
 IyEGHNwgFaea9TMmDAM42aphcukIoZa/KP5nnviwowCu4rvObvZMLjTl54X0vxV2ONb8ze3Q2
 PoyFHsAPW+FrPQjoQ+nT7CAb3ybwOcHV8/Xr9A9fTbe2dBdYq/FMYcLK8h9KNr5OfQiHJAzuP
 YfNau0yBBiMEOveBaJ5JNBgkFBCt/eU79ZnHfwI8BmLzw3vp76swMRcw8sm7ujRC0TqPrQDI8
 Cf3tQuwBlF43yn0CQm1xEqoo4SjNx5MMitaH0igw6kni0B0Vp1TXcVJHvZa+v8iz9vw1UoKqu
 pIhX/F+1CfXBmWJIohZYGUKBcUJUON7DspU9G5WvaSZWbJxRAPlSn+5w1koDeTz7r6EJuZNf8
 1x7LMizwXJwfSEAK2VX+Rg43SMllodWG6rmTUvRDyo+JqMzQve9feKf+ViABhMs4bWRda8VT5
 4l3utul+AbUtBpbF4d5w1Zdr1j/ZXinXjmycX+eWNO0slhxCprQjHTlwTxekK8+74Sp9kNfMr
 xVOk/6H/JveFvtdB37N/sE4ifakFpTrW8Le7nP5fU+/vo4X9/dG8EGMaWzhRJJNQNqwmC3b9E
 q1U2Cy8hs2YMi+XbjF9o49gR8TvmL2U8G9NRK2M2aF4Uu9ZimuwRBVaipv18tC4qRHCpmVa4z
 XJnliMXWZ91833FgadlJKczujhYbrzQJX1cEgIDOkR8ZOtuunIrUJCkqgoO14APQgH95sDGeA
 0rlT+lDDTP6B274Acl1WbDOw==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Freitag, 24=2E Februar 2023 um 22:08 Uhr
> Von: "Vladimir Oltean" <olteanv@gmail=2Ecom>
> An: "Frank Wunderlich" <frank-w@public-files=2Ede>
> Cc: "Ar=C4=B1n=C3=A7 =C3=9CNAL" <arinc=2Eunal@arinc9=2Ecom>, "netdev" <n=
etdev@vger=2Ekernel=2Eorg>, erkin=2Ebozoglu@xeront=2Ecom, "Andrew Lunn" <an=
drew@lunn=2Ech>, "Florian Fainelli" <f=2Efainelli@gmail=2Ecom>, "Felix Fiet=
kau" <nbd@nbd=2Ename>, "John Crispin" <john@phrozen=2Eorg>, "Mark Lee" <Mar=
k-MC=2ELee@mediatek=2Ecom>, "Lorenzo Bianconi" <lorenzo@kernel=2Eorg>, "Mat=
thias Brugger" <matthias=2Ebgg@gmail=2Ecom>, "Landen Chao" <Landen=2EChao@m=
ediatek=2Ecom>, "Sean Wang" <sean=2Ewang@mediatek=2Ecom>, "DENG Qingfang" <=
dqfext@gmail=2Ecom>
> Betreff: Re: Choose a default DSA CPU port
>
> On Fri, Feb 24, 2023 at 09:44:43PM +0100, Frank Wunderlich wrote:
> > 6=2E1=2E12 is clean and i get 940 Mbit/s over gmac0/port6
>=20
> Sounds like something which could be bisected?

tried this, and got network completely broken on third step

git bisect start
# good: [830b3c68c1fb1e9176028d02ef86f3cf76aa2476] Linux 6=2E1
git bisect good 830b3c68c1fb1e9176028d02ef86f3cf76aa2476
# bad: [c9c3395d5e3dcc6daee66c6908354d47bf98cb0c] Linux 6=2E2
git bisect bad c9c3395d5e3dcc6daee66c6908354d47bf98cb0c
# good: [1ca06f1c1acecbe02124f14a37cce347b8c1a90c] Merge tag 'xtensa-20221=
213' of https://github=2Ecom/jcmvbkbc/linux-xtensa
git bisect good 1ca06f1c1acecbe02124f14a37cce347b8c1a90c

$ git logone -1
b83a7080d300 2022-12-16 Merge tag 'staging-6=2E2-rc1' of git://git=2Ekerne=
l=2Eorg/pub/scm/linux/kernel/git/gregkh/staging  (HEAD)

wan and eth0 are up, but no traffic :(

root@bpi-r2:~# ip link set eth0 up
[  259=2E865441] mtk_soc_eth 1b100000=2Eethernet eth0: configuring for fix=
ed/trgmii=20
link mode
[  259=2E873639] mtk_soc_eth 1b100000=2Eethernet eth0: Link is Up - 1Gbps/=
Full - flo
w control rx/tx
[  259=2E882175] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
root@bpi-r2:~#=20
root@bpi-r2:~# ip link set wan up
[  269=2E651154] mt7530 mdio-bus:00 wan: configuring for phy/gmii link mod=
e
root@bpi-r2:~# [  272=2E742227] mt7530 mdio-bus:00 wan: Link is Up - 1Gbps=
/Full -=20
flow control rx/tx
[  272=2E749678] IPv6: ADDRCONF(NETDEV_CHANGE): wan: link becomes ready

root@bpi-r2:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group =
defaul
t qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127=2E0=2E0=2E1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host=20
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1504 qdisc mq state UP grou=
p defa
ult qlen 1000
    link/ether 3a:69:cb:48:04:40 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::3869:cbff:fe48:440/64 scope link=20
       valid_lft forever preferred_lft forever
3: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 10=
00
    link/sit 0=2E0=2E0=2E0 brd 0=2E0=2E0=2E0
4: wan@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue stat=
e UP g
roup default qlen 1000
    link/ether 08:22:33:44:55:77 brd ff:ff:ff:ff:ff:ff
    inet 192=2E168=2E0=2E11/24 scope global wan
       valid_lft forever preferred_lft forever
    inet6 fe80::a22:33ff:fe44:5577/64 scope link=20
       valid_lft forever preferred_lft forever
5: lan0@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group d=
efault
 qlen 1000
    link/ether 3a:5d:98:f7:50:8b brd ff:ff:ff:ff:ff:ff
6: lan1@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group d=
efault
 qlen 1000
    link/ether 3e:de:03:53:13:70 brd ff:ff:ff:ff:ff:ff
7: lan2@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group d=
efault
 qlen 1000
    link/ether 66:8a:45:e7:49:14 brd ff:ff:ff:ff:ff:ff
8: lan3@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group d=
efault
 qlen 1000
    link/ether 0a:81:22:f8:21:57 brd ff:ff:ff:ff:ff:ff
root@bpi-r2:~#=20
root@bpi-r2:~#=20
root@bpi-r2:~#=20
root@bpi-r2:~# ping 192=2E168=2E0=2E21
PING 192=2E168=2E0=2E21 (192=2E168=2E0=2E21) 56(84) bytes of data=2E
From 192=2E168=2E0=2E11 icmp_seq=3D1 Destination Host Unreachable
From 192=2E168=2E0=2E11 icmp_seq=3D2 Destination Host Unreachable
From 192=2E168=2E0=2E11 icmp_seq=3D3 Destination Host Unreachable
^C
--- 192=2E168=2E0=2E21 ping statistics ---
4 packets transmitted, 0 received, +3 errors, 100% packet loss, time 3111m=
s
pipe 4
root@bpi-r2:~# ethtool eth0
Settings for eth0:
        Supported ports: [ MII ]
        Supported link modes:   1000baseT/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  1000baseT/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  1000baseT/Full
        Link partner advertised pause frame use: Symmetric
        Link partner advertised auto-negotiation: No
        Link partner advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Auto-negotiation: on
        Port: MII
        PHYAD: 0
        Transceiver: internal
        Current message level: 0x000000ff (255)
                               drv probe link timer ifdown ifup rx_err tx_=
err
        Link detected: yes
root@bpi-r2:~# ethtool -S eth0
NIC statistics:
     tx_bytes: 7342
     tx_packets: 90
     tx_skip: 0
     tx_collisions: 0
     rx_bytes: 9980
     rx_packets: 105
     rx_overflow: 0
     rx_fcs_errors: 0
     rx_short_errors: 0
     rx_long_errors: 0
     rx_checksum_errors: 0
     rx_flow_control_packets: 0
     rx_xdp_redirect: 0
     rx_xdp_pass: 0
     rx_xdp_drop: 0
     rx_xdp_tx: 0
     rx_xdp_tx_errors: 0
     tx_xdp_xmit: 0
     tx_xdp_xmit_errors: 0
     p06_TxDrop: 0
     p06_TxCrcErr: 0
     p06_TxUnicast: 21
     p06_TxMulticast: 80
     p06_TxBroadcast: 4
     p06_TxCollision: 0
     p06_TxSingleCollision: 0
     p06_TxMultipleCollision: 0
     p06_TxDeferred: 0
     p06_TxLateCollision: 0
     p06_TxExcessiveCollistion: 0
     p06_TxPause: 0
     p06_TxPktSz64: 0
     p06_TxPktSz65To127: 93
     p06_TxPktSz128To255: 4
     p06_TxPktSz256To511: 8
     p06_TxPktSz512To1023: 0
     p06_Tx1024ToMax: 0
     p06_TxBytes: 10400
     p06_RxDrop: 0
     p06_RxFiltering: 30
     p06_RxUnicast: 0
     p06_RxMulticast: 69
     p06_RxBroadcast: 21
     p06_RxAlignErr: 0
     p06_RxCrcErr: 0
     p06_RxUnderSizeErr: 0
     p06_RxFragErr: 0
     p06_RxOverSzErr: 0
     p06_RxJabberErr: 0
     p06_RxPause: 0
     p06_RxPktSz64: 25
     p06_RxPktSz65To127: 65
     p06_RxPktSz128To255: 0
     p06_RxPktSz256To511: 0
     p06_RxPktSz512To1023: 0
     p06_RxPktSz1024ToMax: 0
     p06_RxBytes: 7342
     p06_RxCtrlDrop: 0
     p06_RxIngressDrop: 0
     p06_RxArlDrop: 0
root@bpi-r2:~# ethtool -S wan
NIC statistics:
     tx_packets: 60
     tx_bytes: 3932
     rx_packets: 10
     rx_bytes: 1848
     TxDrop: 0
     TxCrcErr: 0
     TxUnicast: 0
     TxMulticast: 39
     TxBroadcast: 21
     TxCollision: 0
     TxSingleCollision: 0
     TxMultipleCollision: 0
     TxDeferred: 0
     TxLateCollision: 0
     TxExcessiveCollistion: 0
     TxPause: 0
     TxPktSz64: 25
     TxPktSz65To127: 35
     TxPktSz128To255: 0
     TxPktSz256To511: 0
     TxPktSz512To1023: 0
     Tx1024ToMax: 0
     TxBytes: 4574
     RxDrop: 0
     RxFiltering: 0
     RxUnicast: 21
     RxMulticast: 86
     RxBroadcast: 4
     RxAlignErr: 0
     RxCrcErr: 0
     RxUnderSizeErr: 0
     RxFragErr: 0
     RxOverSzErr: 0
     RxJabberErr: 0
     RxPause: 0
     RxPktSz64: 91
     RxPktSz65To127: 12
     RxPktSz128To255: 0
     RxPktSz256To511: 8
     RxPktSz512To1023: 0
     RxPktSz1024ToMax: 0
     RxBytes: 10364
     RxCtrlDrop: 0
     RxIngressDrop: 0
     RxArlDrop: 0
root@bpi-r2:~#=20

checked commits at this point for mt7530 dsa driver and mtk-eth driver, fi=
rst has no changes, but mediatek-driver has a bunch of commits which may br=
eak=2E=2E=2Emost of them are wed-specific which is not available/enabled on=
 mt7623=2E

$ git logone -20 -- drivers/net/ethernet/mediatek/
587585e1bbeb 2022-12-07 net: ethernet: mtk_wed: fix possible deadlock if m=
tk_wed_wo_init fails=20
c79e0af5ae5e 2022-12-07 net: ethernet: mtk_wed: fix some possible NULL poi=
nter dereferences=20
e22dcbc9aa32 2022-12-05 net: ethernet: mtk_wed: Fix missing of_node_put() =
in mtk_wed_wo_hardware_init()=20
ed883bec679b 2022-12-05 net: ethernet: mtk_wed: add reset to rx_ring_setup=
 callback=20
c9f8d73645b6 2022-12-03 net: mtk_eth_soc: enable flow offload support for =
MT7986 SoC=20
65e6af6cebef 2022-12-01 net: ethernet: mtk_wed: fix sleep while atomic in =
mtk_wed_wo_queue_refill=20
f2bb566f5c97 2022-11-29 Merge git://git=2Ekernel=2Eorg/pub/scm/linux/kerne=
l/git/netdev/net=20
23dca7a90017 2022-11-24 net: ethernet: mtk_wed: add reset to tx_ring_setup=
 callback=20
b08134c6e109 2022-11-24 net: ethernet: mtk_wed: add mtk_wed_rx_reset routi=
ne=20
f78cd9c783e0 2022-11-24 net: ethernet: mtk_wed: update mtk_wed_stop=20
92b1169660eb 2022-11-24 net: ethernet: mtk_wed: move MTK_WDMA_RESET_IDX_TX=
 configuration in mtk_wdma_tx_reset=20
b0488c4598a5 2022-11-24 net: ethernet: mtk_wed: return status value in mtk=
_wdma_rx_reset=20
a66d79ee0bd5 2022-11-24 net: ethernet: mtk_wed: add wcid overwritten suppo=
rt for wed v1=20

603ea5e7ffa7 2022-11-20 net: ethernet: mtk_eth_soc: fix memory leak in err=
or path <<<<<<< in 6=2E1 from here
8110437e5961 2022-11-20 net: ethernet: mtk_eth_soc: fix resource leak in e=
rror path=20
3213f808ae21 2022-11-20 net: ethernet: mtk_eth_soc: fix potential memory l=
eak in mtk_rx_alloc()=20
ef8c373bd91d 2022-11-17 net: ethernet: mtk_eth_soc: fix RSTCTRL_PPE{0,1} d=
efinitions=20
8bd8dcc5e47f 2022-11-16 net: ethernet: mediatek: ppe: assign per-port queu=
es for offloaded traffic=20
f63959c7eec3 2022-11-16 net: ethernet: mtk_eth_soc: implement multi-queue =
support for per-port queues=20
71ba8e4891c7 2022-11-16 net: ethernet: mtk_eth_soc: avoid port_mg assignme=
nt on MT7622 and newer=20
frank@frank-G5:/media/data_nvme/git/kernel/BPI-R2-4=2E14 (HEAD) [1M46U]
$ git logone -10 v6=2E1 -- drivers/net/ethernet/mediatek/
603ea5e7ffa7 2022-11-20 net: ethernet: mtk_eth_soc: fix memory leak in err=
or path=20
8110437e5961 2022-11-20 net: ethernet: mtk_eth_soc: fix resource leak in e=
rror path=20
3213f808ae21 2022-11-20 net: ethernet: mtk_eth_soc: fix potential memory l=
eak in mtk_rx_alloc()=20
f70074140524 2022-11-17 net: ethernet: mtk_eth_soc: fix error handling in =
mtk_open()=20
b0c09c7f08c2 2022-11-07 net: ethernet: mtk-star-emac: disable napi when co=
nnect and start PHY failed in mtk_star_enable()=20
402fe7a57287 2022-10-17 net: ethernet: mediatek: ppe: Remove the unused fu=
nction mtk_foe_entry_usable()=20
e0bb4659e235 2022-10-17 net: ethernet: mtk_eth_wed: add missing of_node_pu=
t()=20
9d4f20a476ca 2022-10-17 net: ethernet: mtk_eth_wed: add missing put_device=
() in mtk_wed_add_hw()=20
b3d0d98179d6 2022-10-17 net: ethernet: mtk_eth_soc: fix possible memory le=
ak in mtk_probe()=20
4af609b216e8 2022-10-06 net: ethernet: mediatek: Remove -Warray-bounds exc=
eption


$ git logone -10 drivers/net/dsa/mt7530=2Ec
accc3b4a572b 2022-09-29 Merge git://git=2Ekernel=2Eorg/pub/scm/linux/kerne=
l/git/netdev/net=20
728c2af6ad8c 2022-09-17 net: mt7531: ensure all MACs are powered down befo=
re reset=20
42bc4fafe359 2022-09-17 net: mt7531: only do PLL once after the reset=20
e19de30d2080 2022-09-21 net: dsa: mt7530: add support for in-band link sta=
tus=20
ebe48922c0c4 2022-09-21 net: dsa: mt7530: remove unnecessary dev_set_drvda=
ta()=20
1f9a6abecf53 2022-06-10 net: dsa: mt7530: get cpu-port via dp->cpu_dp inst=
ead of constant=20
6e19bc26cccd 2022-06-10 net: dsa: mt7530: rework mt753[01]_setup=20
a9c317417c27 2022-06-10 net: dsa: mt7530: rework mt7530_hw_vlan_{add,del}=
=20
c8227d568ddf 2022-05-05 Merge git://git=2Ekernel=2Eorg/pub/scm/linux/kerne=
l/git/netdev/net=20
a9e9b091a1c1 2022-04-28 net: dsa: mt7530: add missing of_node_put() in mt7=
530_setup()
