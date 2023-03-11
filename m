Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5996B6079
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 21:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjCKUWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 15:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCKUWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 15:22:38 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0530065044;
        Sat, 11 Mar 2023 12:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1678566112; i=frank-w@public-files.de;
        bh=pQEr/z53bOdtnEgvEbVCLCSP3zmBPGXC/5MGDKXPBY4=;
        h=X-UI-Sender-Class:Date:From:To:CC:Subject:Reply-to:In-Reply-To:
         References;
        b=FL+Dm1v3CmA9dF2EKSU/QxgsYoqUNOo+5zTngwD8wnOmP+r4Q7XeNNU5si1qamVQx
         zrJMb3ybeNrj+jTZwTcPtGKkXIXY9j7/zOtpcMjXYdDOzWg1n6nLR3zeIu7xK0ZP7H
         XcMk77ExiIXk75U1RSbGVRpTrk1qIEpzjwbokzKY9dgif9Q6UWawine6lFxHwzxwhr
         YrBQbQGmguNcHrHtLi/V/zinWg6RwlqDN4sJp67Z+f7DybLm246agWCd5bgk7hvwb/
         HuqKt8OLe/KGcl6Tmb8sWXRaVfkfBJNIm9lN9S5nC4JAy3FgX2PgCIuSRbXRmMced6
         lAZ1fpLVkCFBA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [127.0.0.1] ([157.180.225.226]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N6bfq-1qc7ji1rwc-01843B; Sat, 11
 Mar 2023 21:21:52 +0100
Date:   Sat, 11 Mar 2023 21:21:47 +0100
From:   Frank Wunderlich <frank-w@public-files.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Daniel Golle <daniel@makrotopia.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: =?US-ASCII?Q?Re=3A_Re=3A_=5BPATCH_net-next_?= =?US-ASCII?Q?v12_08/18=5D_net=3A_ethernet=3A?= =?US-ASCII?Q?_mtk=5Feth=5Fsoc=3A_fix_1000Base-X_and_2500Base-X_modes?=
User-Agent: K-9 Mail for Android
Reply-to: frank-w@public-files.de
In-Reply-To: <ZAzd1A0SAKZK0hF5@shell.armlinux.org.uk>
References: <ZAiCh8wkdTBT+6Id@shell.armlinux.org.uk> <ZAiFOTRQI36nGo+w@makrotopia.org> <ZAiJqvzcUob2Aafq@shell.armlinux.org.uk> <20230308134642.cdxqw4lxtlgfsl4g@skbuf> <ZAiXvNT8EzHTmFPh@shell.armlinux.org.uk> <ZAiciK5fElvLXYQ9@makrotopia.org> <ZAijM91F18lWC80+@shell.armlinux.org.uk> <ZAik+I1Ei+grJdUQ@makrotopia.org> <ZAioqp21521NsttV@shell.armlinux.org.uk> <trinity-79e9f0b8-a267-4bf9-a3d4-1ec691eb5238-1678536337569@3c-app-gmx-bs24> <ZAzd1A0SAKZK0hF5@shell.armlinux.org.uk>
Message-ID: <4B891976-C29E-4D98-B604-3AC4507D3661@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vdyMgGY1iVprjllKbjxvxHOpUdPyu+gTDNbOdJAAsh20zcnPvFu
 Gu4uDRjcTHBsNFrLZwtMXC3MznDe3+HsxIdlWrE7L5DaTLJQWzLytwBRPrfu7rQ7nQrWFc3
 AHvfE92lon3U39Ku8wZ5OpQQqTfIcD8XYQLDI+mXH0x2cTTA7bMOhOTY0pdkpcRm0gR5XFK
 pzQ1msQ+lejVU+4PKT3hA==
UI-OutboundReport: notjunk:1;M01:P0:agqwbhrfqQA=;cALfKvctJcc8G0uB+jboKdQ/Mvn
 GayVyX07jAae41Kp4ggw1IolCpsqjuAtxNEweYmVMfV5kGpnNj0CxCXgtjrb58tTqKi/AX2tr
 zeWIPRP2RHjdNnfjxfy/67FTI4m65Hirx9OXlkoc1p5fTQWbS578yMGmYuHE6JwDtjMZs/bWM
 /Y+aMJFspDZfy78MvsP1YWQmCcoS1/rY+37E+VZ/eORM069VVNFddMjOhm/Z0qd2OtEHogisI
 k3nDtVEOgp+ULMdAvyYeLM7mWF0oXXvFd5PY5lAsJC3lhihOsmjOcopuOBPHLPtIIy1VyOpkl
 kugHlQztX4E8l5CD33qgRmiBPXmMlo+ux5uG78k4dwJVm40xhLcC5SIR/gZ6wxzTYGzd1wO0b
 C3yvM4fYh3QhphQTZt+EatIJHHVpjQIOoKlM2iksANBLFGHdN4GeP/X+RNILTJWP+k8RQbLAO
 GBTzQtMPZqbNp59QLlx+6tuaRnRUlZ4/dD8Y3Q56vXfu3lxmadT7BCGhcI8SzURVZuNgI98fG
 pB7nXu/eWqUkc8lkL5oJpp/PZJB4v0zWesrLrfZqBXRG0q4hJchiu2LLhbbdYPum87W7vj7D7
 mGM2KJXRnhHR/eksaDfyanBKJxpQQbdvjhwnYy6ZILq0iqpjrW7hcYlCN366Q53WS17QMRduY
 gjpSb0vlnmzGyewEj4isLPYcLWur3tuV6l5B+AM6mQgXNeswl2FJ8dMF7ftmXzzdWcWNQrxMU
 SM7m1X3chUehHZhW+FqORIm8ekra+00JibMK7xVfnzCevI2eQk+p33YCUb1QtI272X/LzYEij
 4NwB9YXaNf3fX5UzMA0ofFtL9W82WmRRh8kbQ6Qprgsx+Imgvj3CVaHQymh8BDkClSBZFtsMF
 qz1p8Et6tJjzkqkCaVFSKSVTYdDhFYeTTarfYxiD7mXMBqt612my4CnpqZlyYydN0SMQH7zGq
 suQbUw==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 11=2E M=C3=A4rz 2023 21:00:20 MEZ schrieb "Russell King (Oracle)" <linux=
@armlinux=2Eorg=2Euk>:
>On Sat, Mar 11, 2023 at 01:05:37PM +0100, Frank Wunderlich wrote:

>> i got the 2=2E5G copper sfps, and tried them=2E=2E=2Ethey work well wit=
h the v12 (including this patch), but not in v13=2E=2E=2E=20

>> how can we add a quirk to support this?
>
>Why does it need a quirk?

To disable the inband-mode for this 2=2E5g copper
sfp=2E But have not found a way to set a flag which i
can grab in phylink=2E

The interface imho can only hold 1 value=20
(speedmode which is correctly set to 2500baseX)=20
and the mode holds ethtool options which seem=20
not accessable from phylink=2Ec

>>=20
>> some more information:
>>=20
>> root@bpi-r3:~# ethtool eth1
>> Settings for eth1:
>>         Supported ports: [ FIBRE ]
>>         Supported link modes:   2500baseX/Full
>>         Supported pause frame use: Symmetric Receive-only
>>         Supports auto-negotiation: Yes
>>         Supported FEC modes: Not reported
>>         Advertised link modes:  2500baseX/Full
>>         Advertised pause frame use: Symmetric Receive-only
>>         Advertised auto-negotiation: Yes
>>         Advertised FEC modes: Not reported
>>         Speed: 2500Mb/s
>>         Duplex: Full
>>         Auto-negotiation: on
>>         Port: FIBRE
>>         PHYAD: 0
>>         Transceiver: internal
>>         Current message level: 0x000000ff (255)
>>                                drv probe link timer ifdown ifup rx_err =
tx_err
>>         Link detected: yes
>> root@bpi-r3:~# ethtool -m eth1
>>         Identifier                                : 0x03 (SFP)
>>         Extended identifier                       : 0x04 (GBIC/SFP defi=
ned by 2-wire interface ID)
>>         Connector                                 : 0x07 (LC)
>>         Transceiver codes                         : 0x00 0x01 0x00 0x00=
 0x00 0x00 0x02 0x00 0x00
>>         Transceiver type                          : SONET: OC-48, short=
 reach
>>         Encoding                                  : 0x05 (SONET Scrambl=
ed)
>>         BR, Nominal                               : 2500MBd

>>         Vendor name                               : OEM
>>         Vendor OUI                                : 00:00:00
>>         Vendor PN                                 : SFP-2=2E5G-T
>>         Vendor rev                                : 1=2E0
>>         Option values                             : 0x00 0x1a
=2E=2E=2E

>>=20
>> i guess this sfp have a phy as it can operate in 100/1000/2500 mode lik=
e described on the module=2E
>
>It would help to know the kernel messages=2E

I had only the sfp message with vendor/partno and the interface up from ma=
c (2500baseX/Full)
But no link up=2E

Which message(s) do you want to see?


regards Frank
