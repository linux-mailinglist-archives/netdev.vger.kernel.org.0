Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220726095BA
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 21:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiJWTEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 15:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiJWTEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 15:04:34 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5435FFC;
        Sun, 23 Oct 2022 12:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1666551838;
        bh=pbLEU+zXgC8zFwHz0H3Pt6/+hEGvSEnx/0ldbn4xpFI=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=l0RoOupi2ehu9SqaR4Dgn901it9JL5bc0ZWIXPfWS9E+EDvjPBVhXuezEbw38pPkg
         vYpz3krKp01VcLFhuVK2EJoMu7S4C/uTJTQsCCtYa50k17tXH7u2ICZ9C56VYrHm0D
         OODsOUHAdTaFyAK7mf6PlNMdjjKqulpAcZpCcbeA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.79.234] ([80.245.79.234]) by web-mail.gmx.net
 (3c-app-gmx-bs01.server.lan [172.19.170.50]) (via HTTP); Sun, 23 Oct 2022
 21:03:58 +0200
MIME-Version: 1.0
Message-ID: <trinity-ac9a840b-cb06-4710-827a-4c4423686074-1666551838763@3c-app-gmx-bs01>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Aw: Re: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 23 Oct 2022 21:03:58 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <Y1V/asUompZKj0ct@shell.armlinux.org.uk>
References: <Y1Ozp2ASm2Y+if3Q@shell.armlinux.org.uk>
 <trinity-4470b00b-771b-466e-9f3a-a3df72758208-1666435920485@3c-app-gmx-bs49>
 <Y1Qi55IwJZulL1X/@shell.armlinux.org.uk>
 <trinity-164dc5a6-98ce-464c-a43d-b00b91ca69e5-1666461195968@3c-app-gmx-bs49>
 <Y1RCA+l2OHkrFfhB@shell.armlinux.org.uk>
 <trinity-ff9bb15b-b10c-46d6-8af2-09a03563c3c8-1666509999435@3c-app-gmx-bap20>
 <Y1UMrvk2A9aAcjo5@shell.armlinux.org.uk>
 <trinity-5350c2bc-473d-408f-a25a-16b34bbfcba7-1666537529990@3c-app-gmx-bs01>
 <Y1Vh5U96W2u/GCnx@shell.armlinux.org.uk>
 <trinity-1d4cc306-d1a4-4ccf-b853-d315553515ce-1666543305596@3c-app-gmx-bs01>
 <Y1V/asUompZKj0ct@shell.armlinux.org.uk>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:RrvjJMnF0bQZ5soakBSlh0up+m7kvTe3/BLFL7d3x1UuF5rF05aEofpiinEMikzwPmVE6
 zZuwfblYoukCw1lWFA4krdse90iMOjtnZEg22OIfJHZq/a+59DcxQnvZsfNkgmdIDyV3uV7o4Z9o
 T7ugmrH6+tf0co22i7gjibRucqVD9MsiRI5WF8ZMR2BmQSj3A1w88boLhqN63KE94JSpDzVEywDp
 iCY/Noy+mGKBG0d6mjrJjOwCZPsZXyJwp06XCE220Z768rpc0qH6k35QTrNhV270ZS2k3AJz2Lx8
 6g=
X-UI-Out-Filterresults: notjunk:1;V03:K0:2yNzWUJnl14=:+CVqymrbpa+TnDmpg9GQ0t
 jVWYFR+lRE7M2rU/Wb0EZ5s67nfTs/XtkWPU7VKzaiw2UeKaEoL5T+MHc7rDZ7Pr14YN8DOYn
 AKjQzMiy3b3jfZbPHCAlgZZu9n3EEgBx/hXi1EGliKVgKr8k3aJsw+IfzKW50lk7R3dO33sIy
 GtzaK9NUoJLJfE5MWc/GzMy+jICDd/swZhMVdQX8yJAIQQV5c24U3xIuSBBOlwu8PGvAP7vNc
 /vUOKAW8nzrOrTUhZzwraZc7IkPc5mZwPiAFUASSSwT3uAhbZwgFEC63GRE1Yzo5DWcJtbAJj
 yWocrvT5uxfqNQ0HIYp6sJUwzRny781KPW1CEszeqHws+YqAOKKLorNcFbLQdANffKKOSWCTM
 SJL7eLql6eZw8d4WGNpbnu9SbTzVLX7iIo6a55FfbIiBR2tlboeZflWwAyhB9d/VwMIq8ILpF
 KxEzR6KJGgDaeHrfMdhg3XfyKCihys1DWoa7Jiu0xwwtlhLdLzt3KoGdI4i8WCBHmJ8nW/J5b
 rUZtyxV7BAK088e9PKKgFpnigAT8QhWN3Vyo2iqR87IyUOyLDE3k3/wglIuyCs8uD7dyOo2Wy
 uMrW0wJEy77Cg7Oy7KZSJKmCAL+a5seVxIpNsLH5STgalYI4nhRh0WqXOdLQUflJjeNVbEoUT
 54qWd3Qf/eK1C+D1ug390Rt01QTDR9UAMASozRfJS+hUn3h1kXCS5gglIqRyG6NP0t7JKabOW
 KilNNQ8iM4J2EvFstBvlK04NI2B2g3iPVTbbUzH3CCL/xhtrekJYtMXfRVwK54bdcPWK6eeeb
 RlFWhAHRzBKtgrQeaiCehVbQwnGsH0dDyzaRRQ80lG2hIcBt/A8D9PmQSU7un1ZJjR48kcGCK
 3w9hd+9TjcXD8sdnlQq9h2XCc2+xRJJQY+bu4oR2OApK7zKwinZ1oj5X4eCL5THe53jz3lyIR
 cpQZ4hsxmQDrI/xL5Kg4EVIg/ONaUeAWJkh7ApbRvSjP/M2/tfji2R1PZeB160ujYcxBfs8v4
 AuaCx2JvD9JPqJv1PsuNtea1i+jdCILH6bDFeewKLyE+16QoGJNwp0UerzAcq/oyT5SPEE4PS
 tPffbxfHH+p5CP+3Pi3eM/xyjg5V7lpAfdRIVWwP1n65i2KZX6Zb6nQhP6sewvXqqpDAitqeK
 GAu3o+juFgRzpPi5VwTWl4m2/uHymHntNsvNekHLZ+P3d1HIOiNmEOXV7pL9llJNaiGm/3HhS
 /wujAX6zaOgcLyEC0H3Cgrg1XyUKKlxgALVmB45Bm2j2YePkrC9pTn8t+iIc7ihyphNDhM14/
 uTHB/O6FBcUC8ieNlFXAuCtne6IHxw==
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Sonntag, 23. Oktober 2022 um 19:52 Uhr
> Von: "Russell King (Oracle)" <linux@armlinux.org.uk>

> Hi Frank,
>
> Based on this, could you give the following patch a try - it replaces
> my previous patch.

looks better now:

root@bpi-r3:~# ip link set eth1 up
[   59.437700] mtk_soc_eth 15100000.ethernet eth1: configuring for inband/=
1000base-x link mode
root@bpi-r3:~# [   59.446191] interface-mode: 21 advertise: 0x1a0 link tim=
er:0x98968
[   59.503145] offset:0 0x2c1140
[   59.509329] offset:4 0x4d544950
[   59.512284] offset:8 0x40e041a0
[   59.515446] offset:32 0x3112011a
[   59.518598] mtk_soc_eth 15100000.ethernet eth1: Link is Up - 1Gbps/Full=
 - flow control off
[   59.530096] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready

root@bpi-r3:~# ip a a 192.168.0.19/24 dev eth1
root@bpi-r3:~# ping 192.168.0.10
PING 192.168.0.10 (192.168.0.10) 56(84) bytes of data.
64 bytes from 192.168.0.10: icmp_seq=3D1 ttl=3D64 time=3D0.863 ms
64 bytes from 192.168.0.10: icmp_seq=3D2 ttl=3D64 time=3D0.491 ms
^C
=2D-- 192.168.0.10 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1071ms
rtt min/avg/max/mdev =3D 0.491/0.677/0.863/0.186 ms
root@bpi-r3:~# ethtool eth1
[  128.027246] offset:0 0x2c1140
[  128.027264] offset:4 0x4d544950
[  128.030230] offset:8 0x40e041a0
Settings for eth[  128.033411] offset:32 0x3112011a
1:
        Supported p[  128.036798] offset:0 0x2c1140
[  128.041287] offset:4 0x4d544950

        Supported link[  128.045636] offset:8 0x40e041a0
 modes:   1000baseX/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  1000baseX/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Auto-negotiation: on
        Port: FIBRE
        PHYAD: 0
        Transceiver: internal
        Current message level: 0x000000ff (255)
                               drv probe link timer ifdown ifup rx_err tx_=
err
        Link detected: yes
root@bpi-r3:~#
root@bpi-r3:~# iperf3 -c 192.168.0.21
Connecting to host 192.168.0.21, port 5201
[  5] local 192.168.0.19 port 50992 connected to 192.168.0.21 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   114 MBytes   960 Mbits/sec    0    450 KBytes
[  5]   1.00-2.00   sec   112 MBytes   940 Mbits/sec    0    450 KBytes
[  5]   2.00-3.00   sec   113 MBytes   948 Mbits/sec    0    450 KBytes
[  5]   3.00-4.00   sec   112 MBytes   940 Mbits/sec    0    450 KBytes
[  5]   4.00-5.00   sec   112 MBytes   941 Mbits/sec    0    450 KBytes
[  5]   5.00-6.00   sec   112 MBytes   941 Mbits/sec    0    450 KBytes
[  5]   6.00-7.00   sec   113 MBytes   948 Mbits/sec    0    450 KBytes
[  5]   7.00-8.00   sec   112 MBytes   939 Mbits/sec    0    450 KBytes
[  5]   8.00-9.00   sec   112 MBytes   940 Mbits/sec    0    450 KBytes
[  5]   9.00-10.00  sec   113 MBytes   947 Mbits/sec    0    450 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.10 GBytes   944 Mbits/sec    0             send=
er
[  5]   0.00-10.06  sec  1.10 GBytes   938 Mbits/sec                  rece=
iver

iperf Done.
root@bpi-r3:~# iperf3 -c 192.168.0.21 -R
Connecting to host 192.168.0.21, port 5201
Reverse mode, remote host 192.168.0.21 is sending
[  5] local 192.168.0.19 port 38736 connected to 192.168.0.21 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec   112 MBytes   937 Mbits/sec
[  5]   1.00-2.00   sec   112 MBytes   940 Mbits/sec
[  5]   2.00-3.00   sec   112 MBytes   939 Mbits/sec
[  5]   3.00-4.00   sec   112 MBytes   940 Mbits/sec
[  5]   4.00-5.00   sec   112 MBytes   940 Mbits/sec
[  5]   5.00-6.00   sec   112 MBytes   940 Mbits/sec
[  5]   6.00-7.00   sec   112 MBytes   940 Mbits/sec
[  5]   7.00-8.00   sec   112 MBytes   941 Mbits/sec
[  5]   8.00-9.00   sec   112 MBytes   940 Mbits/sec
[  5]   9.00-10.00  sec   112 MBytes   940 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.06  sec  1.10 GBytes   936 Mbits/sec    0             send=
er
[  5]   0.00-10.00  sec  1.09 GBytes   940 Mbits/sec                  rece=
iver

iperf Done.
root@bpi-r3:~#

so now checking the first gmac (mt7531 switch-chip, fixed link with 2500ba=
seX - sgmii, but i can only test 1G on a switchport not the full 2g5):

root@bpi-r3:~# ip link set eth1 down
[  128.050136] offset:32 0x3112011a
[  266.426857] mtk_soc_eth 15100000.ethernet eth1: Link is Down
root@bpi-r3:~# ip link set eth0 up
[  277.257578] mtk_soc_eth 15100000.ethernet eth0: configuring for fixed/2=
500base-x link mode
[  277.266007] mtk_soc_eth 15100000.ethernet eth0: Link is Up - 2.5Gbps/Fu=
ll - flow control rx/tx
root@bpi-r3:~#
root@bpi-r3:~# ip a a 192.168.0.19/24 dev wan
root@bpi-r3:~# ip link set wan up
[  373.687223] mt7530 mdio-bus:1f wan: configuring for phy/gmii link mode
root@bpi-r3:~# [  373.698593] mt7530 mdio-bus:1f wan: Link is Up - 1Gbps/F=
ull - flow control rx/tx
[  373.706061] IPv6: ADDRCONF(NETDEV_CHANGE): wan: link becomes ready
root@bpi-r3:~# ip a a 192.168.0.19/24 dev wan
root@bpi-r3:~# ip link set wan up
[  373.687223] mt7530 mdio-bus:1f wan: configuring for phy/gmii link mode
root@bpi-r3:~# [  373.698593] mt7530 mdio-bus:1f wan: Link is Up - 1Gbps/F=
ull - flow control rx/tx
[  373.706061] IPv6: ADDRCONF(NETDEV_CHANGE): wan: link becomes ready

root@bpi-r3:~# ping 192.168.0.10
PING 192.168.0.10 (192.168.0.10) 56(84) bytes of data.
64 bytes from 192.168.0.10: icmp_seq=3D1 ttl=3D64 time=3D0.964 ms
64 bytes from 192.168.0.10: icmp_seq=3D2 ttl=3D64 time=3D0.523 ms
^C
=2D-- 192.168.0.10 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev =3D 0.523/0.743/0.964/0.220 ms
root@bpi-r3:~# iperf3 -c 192.168.0.21
Connecting to host 192.168.0.21, port 5201
[  5] local 192.168.0.19 port 48332 connected to 192.168.0.21 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   115 MBytes   962 Mbits/sec    0    641 KBytes
[  5]   1.00-2.00   sec   112 MBytes   944 Mbits/sec    0    641 KBytes
[  5]   2.00-3.00   sec   112 MBytes   944 Mbits/sec    0    641 KBytes
[  5]   3.00-4.00   sec   112 MBytes   944 Mbits/sec    0    641 KBytes
[  5]   4.00-5.00   sec   112 MBytes   944 Mbits/sec    0    641 KBytes
[  5]   5.00-6.00   sec   112 MBytes   944 Mbits/sec    0    641 KBytes
[  5]   6.00-7.00   sec   112 MBytes   944 Mbits/sec    0    641 KBytes
[  5]   7.00-8.00   sec   112 MBytes   944 Mbits/sec    0    641 KBytes
[  5]   8.00-9.00   sec   112 MBytes   944 Mbits/sec    0    641 KBytes
[  5]   9.00-10.00  sec   111 MBytes   933 Mbits/sec    0    641 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.10 GBytes   944 Mbits/sec    0             send=
er
[  5]   0.00-10.06  sec  1.10 GBytes   937 Mbits/sec                  rece=
iver

iperf Done.
root@bpi-r3:~# iperf3 -c 192.168.0.21 -R
Connecting to host 192.168.0.21, port 5201
Reverse mode, remote host 192.168.0.21 is sending
[  5] local 192.168.0.19 port 51822 connected to 192.168.0.21 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec   112 MBytes   937 Mbits/sec
[  5]   1.00-2.00   sec   112 MBytes   941 Mbits/sec
[  5]   2.00-3.00   sec   112 MBytes   939 Mbits/sec
[  5]   3.00-4.00   sec   112 MBytes   940 Mbits/sec
[  5]   4.00-5.00   sec   112 MBytes   938 Mbits/sec
[  5]   5.00-6.00   sec   112 MBytes   940 Mbits/sec
[  5]   6.00-7.00   sec   112 MBytes   938 Mbits/sec
[  5]   7.00-8.00   sec   112 MBytes   941 Mbits/sec
[  5]   8.00-9.00   sec   112 MBytes   940 Mbits/sec
[  5]   9.00-10.00  sec   112 MBytes   940 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.06  sec  1.10 GBytes   936 Mbits/sec    0             send=
er
[  5]   0.00-10.00  sec  1.09 GBytes   939 Mbits/sec                  rece=
iver

iperf Done.
root@bpi-r3:~# ethtool eth0
Settings for eth0:
        Supported ports: [ MII ]
        Supported link modes:   2500baseT/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  2500baseT/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  2500baseT/Full
        Link partner advertised pause frame use: Symmetric
        Link partner advertised auto-negotiation: No
        Link partner advertised FEC modes: Not reported
        Speed: 2500Mb/s
        Duplex: Full
        Auto-negotiation: on
        Port: MII
        PHYAD: 0
        Transceiver: internal
        Current message level: 0x000000ff (255)
                               drv probe link timer ifdown ifup rx_err tx_=
err
        Link detected: yes
root@bpi-r3:~# ethtool wan
Settings for wan:
        Supported ports: [ TP    MII ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  10baseT/Half 10baseT/Full
                                             100baseT/Half 100baseT/Full
                                             1000baseT/Full
        Link partner advertised pause frame use: Symmetric
        Link partner advertised auto-negotiation: Yes
        Link partner advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Auto-negotiation: on
        master-slave cfg: preferred slave
        master-slave status: master
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: external
        MDI-X: Unknown
        Supports Wake-on: d
        Wake-on: d
        Link detected: yes
root@bpi-r3:~#

looks good too :)

if you fix this typo you can send the patch and add my tested-by:

        regmap_read(mpcs->regmap, SGMSYS_SGMII_MODE, &val);
-       if (interface =3D =3D=3D PHY_INTERFACE_MODE_SGMII)
+       if (interface =3D=3D PHY_INTERFACE_MODE_SGMII)
                val |=3D SGMII_IF_MODE_BIT0;
        else
                val &=3D ~SGMII_IF_MODE_BIT0;

should i send an update for my patch including this:

state->duplex =3D DUPLEX_FULL;

or do you want to read the duplex from the advertisement like stated befor=
e?

regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &bm);
regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1 + 8, &adv);

phylink_mii_c22_pcs_decode_state(state, bm >> 16, adv >> 16);

regards Frank
