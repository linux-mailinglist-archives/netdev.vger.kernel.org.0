Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D5568B67C
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 08:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjBFHgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 02:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBFHgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 02:36:49 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649D730EA;
        Sun,  5 Feb 2023 23:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1675668965;
        bh=zRvq5G48v/+SFSZZxD4wCUbAQest4/ymyHewA8vStrc=;
        h=X-UI-Sender-Class:Date:From:To:CC:Subject:Reply-to:In-Reply-To:
         References;
        b=ZhjsLq7v09GfXGHElRpGhgXAUue3d2yo+jQZInpMulqCtBKgITUSzBN/oW1OBxM4U
         9lBLPgppJsMZWwIGReS1ynWi3vJispRDQq8jNIPx71Fumkdi2vQq0dFih3M+f9xJ17
         uuHYJUYPmPJQ3tvIhFZ2FqncY5DJclGpd2/HxsRQwVJWWE+GkK1sC3bL4bDpihWrxL
         xiC4ZkGAKy5YJEAmgc/bBBUsYklkvqwYkQn8qK8vXneShx2bj9rP/BFK1LAMoYwoXE
         cuIr3K3tYzQnw1o/mN+1N5wpr/YJE/tI+uXkt1A2zwxmZK0qWINtsvz9E4o36MsybK
         5+DG1TetRHDTA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [127.0.0.1] ([217.61.157.231]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mi2O1-1ouI3o2krJ-00e8pc; Mon, 06
 Feb 2023 08:36:05 +0100
Date:   Mon, 06 Feb 2023 08:35:56 +0100
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
CC:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, erkin.bozoglu@xeront.com,
        richard@routerhints.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_net=5D_net=3A_dsa=3A_mt7530=3A_don=27t_chang?= =?US-ASCII?Q?e_PVC=5FEG=5FTAG_when_CPU_port_becomes_VLAN-aware?=
User-Agent: K-9 Mail for Android
Reply-to: frank-w@public-files.de
In-Reply-To: <20230205235053.g5cttegcdsvh7uk3@skbuf>
References: <20230205140713.1609281-1-vladimir.oltean@nxp.com> <3649b6f9-a028-8eaf-ac89-c4d0fce412da@arinc9.com> <20230205203906.i3jci4pxd6mw74in@skbuf> <b055e42f-ff0f-d05a-d462-961694b035c1@arinc9.com> <20230205235053.g5cttegcdsvh7uk3@skbuf>
Message-ID: <E5DEFD06-4B8F-4A37-918F-61AD4EB15761@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:JnPnhDz763PU1eSKgs3MFK6tgsZ8JjViwmwjOm0hMpfCpX10Jk4
 7oz4QorDJanlFQfZqdaYFzNr+BFt+wykcyGvNqu286AlQxoLFAZoo7eCe5WZaGj0Yhkyea7
 8MjeNq1EfdyEgjaemILmFNc2SxcGmB3KxroQlfJpTNQUVviqpX61x78KqUlIZFOkHj1kMPR
 4kRHsppk7HyZgKiBdpSYg==
UI-OutboundReport: notjunk:1;M01:P0:6Xm+fAtSmR8=;VjUR1eUGC/sJmZRhzglFcmkb0hu
 dkeFVhOsSxjrJggIMAxXiHfnA39B2yffiRKOO2zUBxC8WnUVuiz1Hu3aQ+orfw1b34AipaTjc
 GAW/h6BOPV1anf3Aro3TZsLQnh+vq++r+iL8VzonrCFdmIa6GMcYkwbk/w2cNTF/TnF2uNBrQ
 EXQeHf6y5wkTIRo7eLYtcquV/3g+/gOZ8pmL+NFfcER1A7/XMluHWX+Zqghd1j4mo6B+NA+JR
 tHmQOtUbzjgv0/YCsKj/klfXL8UJtjw/dh7CuFXXwsvVwonfuC6eoHKNr2bQcRiFz7dk7SVu/
 PyrJ0XKEEtzgMt5mRWYWR9ft25RLl+bHnoKDoLNhloo2S9ElKFaghc3CxX44sw8239fXUYW6T
 7+xs+BlvRKmVQjUMy9vcsw0qpIwg0cBO3mL3RxwwhNPUXcJg2BeHUKhIC4WXVhFl6NFvVqRdv
 TyspgZhHpJ/m6rLdnWLJGlD61MOQeG0cvce3ENv/1XhdB9k5zhGcNn3wU/aBWb45DDNpQZ1m5
 o8mczwBYWFOXvl21FnEYDuT9HtENCc3qa3a01dP5D5eAFSFwY6OX9uccFtyR9Dze5sJnygBex
 g3MminuUlJt0fl+m8oIQhAOKAKVuCqgsxmwOye8DBrdG8e9IS7uA4j3TtDlAtbegh0ye5jOUL
 Tj1KNbv7gNXVlwm32CFDa3KwpyeFSv1uBhgdzm7ZoO1M/r/WGXNVxe4mBz4wVVLAukh4elNke
 MuKcJJur/DEg9/vEyxpQM1VlvzJIdzdJap39/6cZ1HUb06bNIsw2MdKb2IIRDepnpGHLDHlrn
 jETF7mKoUY3XU/9oTQUKK43H7EAMEu3NOGgfHLOditjvRZ8kwQzmlhUbMiCNrX02A0cfopUm/
 zm4oy19FN8MCYVfSVymfODeTC5GhP4AOYfOqeur//MI96LfVHfXBPWBADaECMtXz+p6rMeyTo
 VxOzuW2JdGUhgbTEa5ntzLaba58=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 6=2E Februar 2023 00:50:53 MEZ schrieb Vladimir Oltean <vladimir=2Eoltea=
n@nxp=2Ecom>:
>On Mon, Feb 06, 2023 at 02:02:48AM +0300, Ar=C4=B1n=C3=A7 =C3=9CNAL wrote=
:
>> # ethtool -S eth1 | grep -v ': 0'
>> NIC statistics:
>>      tx_bytes: 6272
>>      tx_packets: 81
>>      rx_bytes: 9089
>>      rx_packets: 136
>>      p05_TxUnicast: 52
>>      p05_TxMulticast: 3
>>      p05_TxBroadcast: 81
>>      p05_TxPktSz65To127: 136
>>      p05_TxBytes: 9633
>>      p05_RxFiltering: 11
>>      p05_RxUnicast: 11
>>      p05_RxMulticast: 26
>>      p05_RxBroadcast: 44
>>      p05_RxPktSz64: 47
>>      p05_RxPktSz65To127: 34
>>      p05_RxBytes: 6272
>> # ethtool -S eth1 | grep -v ': 0'
>> NIC statistics:
>>      tx_bytes: 6784
>>      tx_packets: 89
>>      rx_bytes: 9601
>>      rx_packets: 144
>>      p05_TxUnicast: 60
>>      p05_TxMulticast: 3
>>      p05_TxBroadcast: 81
>>      p05_TxPktSz65To127: 144
>>      p05_TxBytes: 10177
>>      p05_RxFiltering: 11
>>      p05_RxUnicast: 11
>>      p05_RxMulticast: 26
>>      p05_RxBroadcast: 52
>>      p05_RxPktSz64: 55
>>      p05_RxPktSz65To127: 34
>>      p05_RxBytes: 6784
>> # ethtool -S eth1 | grep -v ': 0'
>> NIC statistics:
>>      tx_bytes: 7424
>>      tx_packets: 99
>>      rx_bytes: 10241
>>      rx_packets: 154
>>      p05_TxUnicast: 70
>>      p05_TxMulticast: 3
>>      p05_TxBroadcast: 81
>>      p05_TxPktSz65To127: 154
>>      p05_TxBytes: 10857
>>      p05_RxFiltering: 11
>>      p05_RxUnicast: 11
>>      p05_RxMulticast: 26
>>      p05_RxBroadcast: 62
>>      p05_RxPktSz64: 65
>>      p05_RxPktSz65To127: 34
>>      p05_RxBytes: 7424
>
>I see no signs of packet loss on the DSA master or the CPU port=2E
>However my analysis of the packets shows:
>
>> # tcpdump -i eth1 -e -n -Q in -XX
>> tcpdump: verbose output suppressed, use -v[v]=2E=2E=2E for full protoco=
l decode
>> listening on eth1, link-type NULL (BSD loopback), snapshot length 26214=
4 bytes
>> 03:50:38=2E645568 AF Unknown (2459068999), length 60:=20
>> 	0x0000:  9292 6a47 1ac0 e0d5 5ea4 edcc 0806 0001  =2E=2EjG=2E=2E=2E=2E=
^=2E=2E=2E=2E=2E=2E=2E
>                 ^              ^              ^
>                 |              |              |
>                 |              |              ETH_P_ARP
>                 |              MAC SA:
>                 |              e0:d5:5e:a4:ed:cc
>                 MAC DA:
>                 92:92:6a:47:1a:c0
>
>> 	0x0010:  0800 0604 0002 e0d5 5ea4 edcc c0a8 0202  =2E=2E=2E=2E=2E=2E=
=2E=2E^=2E=2E=2E=2E=2E=2E=2E
>> 	0x0020:  9292 6a47 1ac0 c0a8 0201 0000 0000 0000  =2E=2EjG=2E=2E=2E=2E=
=2E=2E=2E=2E=2E=2E=2E=2E
>> 	0x0030:  0000 0000 0000 0000 0000 0000            =2E=2E=2E=2E=2E=2E=
=2E=2E=2E=2E=2E=2E
>
>So you have no tag_mtk header in the EtherType position where it's
>supposed to be=2E This means you must be making use of the hardware DSA
>untagging feature that Felix Fietkau added=2E
>
>Let's do some debugging=2E I'd like to know 2 things, in this order=2E
>First, whether DSA sees the accelerated header (stripped by hardware, as
>opposed to being present in the packet):
>
>diff --git a/net/dsa/tag=2Ec b/net/dsa/tag=2Ec
>index b2fba1a003ce=2E=2Ee64628cf7fc1 100644
>--- a/net/dsa/tag=2Ec
>+++ b/net/dsa/tag=2Ec
>@@ -75,12 +75,17 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct=
 net_device *dev,
> 		if (!skb_has_extensions(skb))
> 			skb->slow_gro =3D 0;
>=20
>+		netdev_err(dev, "%s: skb %px metadata dst contains port id %d attached=
\n",
>+			   __func__, skb, port);
>+
> 		skb->dev =3D dsa_master_find_slave(dev, 0, port);
> 		if (likely(skb->dev)) {
> 			dsa_default_offload_fwd_mark(skb);
> 			nskb =3D skb;
> 		}
> 	} else {
>+		netdev_err(dev, "%s: there is no metadata dst attached to skb 0x%px\n"=
,
>+			   __func__, skb);
> 		nskb =3D cpu_dp->rcv(skb, dev);
> 	}
>=20
>
>And second, which is what does the DSA master actually see, and put in
>the skb metadata dst field:
>
>diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc=2Ec b/drivers/net/=
ethernet/mediatek/mtk_eth_soc=2Ec
>index f1cb1efc94cf=2E=2Ee7ff569959b4 100644
>--- a/drivers/net/ethernet/mediatek/mtk_eth_soc=2Ec
>+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc=2Ec
>@@ -2077,11 +2077,23 @@ static int mtk_poll_rx(struct napi_struct *napi, =
int budget,
> 		if (skb_vlan_tag_present(skb) && netdev_uses_dsa(netdev)) {
> 			unsigned int port =3D ntohs(skb->vlan_proto) & GENMASK(2, 0);
>=20
>+			netdev_err(netdev, "%s: skb->vlan_proto 0x%x port %d\n", __func__,
>+				   ntohs(skb->vlan_proto), port);
>+
> 			if (port < ARRAY_SIZE(eth->dsa_meta) &&
>-			    eth->dsa_meta[port])
>+			    eth->dsa_meta[port]) {
>+				netdev_err(netdev, "%s: attaching metadata dst with port %d to skb 0=
x%px\n",
>+					   __func__, port, skb);
> 				skb_dst_set_noref(skb, &eth->dsa_meta[port]->dst);
>+			} else {
>+				netdev_err(netdev, "%s: not attaching any metadata dst to skb 0x%px\=
n",
>+					   __func__, skb);
>+			}
>=20
> 			__vlan_hwaccel_clear_tag(skb);
>+		} else if (netdev_uses_dsa(netdev)) {
>+			netdev_err(netdev, "%s: received skb 0x%px without VLAN/DSA tag prese=
nt\n",
>+				   __func__, skb);
> 		}
>=20
> 		skb_record_rx_queue(skb, 0);
>
>Be warned that there may be a considerable amount of output to the consol=
e,
>so it would be best if you used a single switch port with small amounts
>of traffic=2E

Ar=C4=B1n=C3=A7 have you tested with or without this series?

https://patchwork=2Ekernel=2Eorg/project/linux-mediatek/list/?series=3D707=
666

Maybe try the opposite=2E

Have not see it in net-next yet=2E
regards Frank
