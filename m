Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E0E6B8DD0
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 09:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjCNIvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 04:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjCNIva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 04:51:30 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B358C5AE;
        Tue, 14 Mar 2023 01:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1678783873; i=frank-w@public-files.de;
        bh=ywnXrWotkDX6rOArAiV5Rs0tXkLDphK5oZ1U0KrPPhM=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=fyMA13a0qvR70KZdAieAI2oWHFrOzkyQFnqy/TNI7ZC799HqirorjEbGYJq98b9ZF
         D/7jtdeWcp0o2Rz9Pk52vzlCizxem6BOBPJw6PbERq5i1Lf1+e506orNSWClzUO/A3
         Mgiqp/s/cjGMgq34OE9PJ29+b5Flm3EyyIk6lzS8xDXX+6p+iWKqhBHfdmeH5pUDf6
         qGJHoC/SrFBcHMeRVXgljp7MFO5XbJdkJ0211vHHMlK5+5T1NAl3G9k/YxhPUO8jSL
         AmfppkKfNlRjMn+ZQWzjfEDpyhqt4TK45rMsmK9VCPlFF9N0xyUT6mrY14raTDJVkK
         XRlNeE0OiEtcQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [80.245.77.27] ([80.245.77.27]) by web-mail.gmx.net
 (3c-app-gmx-bap66.server.lan [172.19.172.66]) (via HTTP); Tue, 14 Mar 2023
 09:51:12 +0100
MIME-Version: 1.0
Message-ID: <trinity-e2c457f1-c897-45f1-907a-8ea3664b7512-1678783872771@3c-app-gmx-bap66>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Aw: Re: Re: Re: Re: [PATCH net-next v12 08/18] net: ethernet:
 mtk_eth_soc: fix 1000Base-X and 2500Base-X modes
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 14 Mar 2023 09:51:12 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <ZA+qTyQ3n6YiURkQ@shell.armlinux.org.uk>
References: <ZAik+I1Ei+grJdUQ@makrotopia.org>
 <ZAioqp21521NsttV@shell.armlinux.org.uk>
 <trinity-79e9f0b8-a267-4bf9-a3d4-1ec691eb5238-1678536337569@3c-app-gmx-bs24>
 <ZAzd1A0SAKZK0hF5@shell.armlinux.org.uk>
 <4B891976-C29E-4D98-B604-3AC4507D3661@public-files.de>
 <ZAzk71mTxgV/pRxC@shell.armlinux.org.uk>
 <trinity-8577978d-1c11-4f6d-ae11-aef37e8b78b0-1678624836722@3c-app-gmx-bap51>
 <ZA4wlQ8P48aDhDly@shell.armlinux.org.uk>
 <ZA8B/kI0fLx4gkQm@shell.armlinux.org.uk>
 <trinity-93681801-f99c-40e2-9fbd-45888b3069aa-1678732740564@3c-app-gmx-bs66>
 <ZA+qTyQ3n6YiURkQ@shell.armlinux.org.uk>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:8bLP4Au/rRlWhP9QKy/JMEtVkisxyfYA71CihxadCjCLmYMplug5nys92q2QMysjwyVt+
 G11fT15r+OXbrnLj2rVGndgpfnDTp4t9z3HJ6pCoEr+RDLsG++rn84QxnbbQ7y40eYDkbYkRuoWo
 axgBjoEKa6sfaQM6CsGQ+N16Ic/3hqJjNJIT11qJ+NvW43gBrtDVSfvrO9pF0pFv8WqM2YRtjkQJ
 ouQQBUPplB164SKJQgqCMFEIM3Hh6rBcml2bpoIdRCA3tzN2atiB09GsppAAaQY1xasrPQGnLjyl
 A0=
UI-OutboundReport: notjunk:1;M01:P0:PR8OvI4PMTk=;LyEkDW4MDgTn7MWp1hvsUBR+SS0
 VOQq2AVYZ1L4jF0HfJfvaTupVCkIHU+lnsBKX8MWV62D4WksUU/N156cMMjpnr50QRWla8WEM
 QZllJ+HxL5pTFIlPIbDeb/vUPhqK6vhK8EnPNe22N9gekGvg/B3KfPsrT5UkZbGR9YPny3Qov
 YcUr9ONVE7sj2C8WsFrsFPfZND5hUyDEhmrp83YTxlY1NnxVtQt9TU5RNM6DaPNxZotMx+8Mi
 c6iWWpYNrI8YGfbkJZD9t/SuiJ7MZLh2ExQcyzUOPh5+0aO44uJdJMJ95JDEksJn+l5XPrVE2
 joVtfYEn38cQeunSTT3PSR7rjGvQvvtqFATlCYWQUXVyZ7zq0Yv/OqaozxgZj4+yVhXGt8vuD
 zJBHFa/gYdv1KlTOS6oNIzr3/NBtp06RT0xLC4bv7SbAJyMA0/0KChGLLaxU3xyfUn1Cpc+91
 MnyAK+cON/SgKvB3QOEBqM3LirnaaGWIwGtoHe1tWxGWFespcGSk6gGJCqlZVD0a3xFjnYLyj
 43pWTuyeqVWQnhEbFguKCduSWxShYp+b7D3/NuIB+GMdpHQLifvsTaQTRNTZobQ1V1+WwGIWI
 3MlARCZg8cnbeej0pqDVdf4QNMVpjSKwCKRNSmT/b8+ABSYJa16ByBJtVnHTfjp6K0mWUFyUj
 K2SXZ8fW8aePhyzHJ0/baWUOiiisRebyDpGJnnXNGuZYDYupYVVos1991tiLZ4/3fVm8vcrt9
 kSQCp5ZEyvGlsAXYQlyAWVTJzO3561LF8Yqelv1dVOE+nS3WN4wq8PU0Dm2OZp+LLkghukV0b
 i3bZKV7FPmn+CCZpivEdi+P4QGixhhh7uUI42c+mADfQI=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

first i removed maintainers/reviewers and mtk people from this thread to (=
hopefully) no more disturb the review-process of daniels patch-series=2E

> Gesendet: Montag, 13=2E M=C3=A4rz 2023 um 23:57 Uhr
> Von: "Russell King (Oracle)" <linux@armlinux=2Eorg=2Euk>
>
> On Mon, Mar 13, 2023 at 07:39:00PM +0100, Frank Wunderlich wrote:
> > > Gesendet: Montag, 13=2E M=C3=A4rz 2023 um 11:59 Uhr
> > > Von: "Russell King (Oracle)" <linux@armlinux=2Eorg=2Euk>
> >=20
> > > Since describing what I wanted you to test didn't work, here's a pat=
ch
> > > instead, based upon the quirk that you provided (which is what I'd h=
ave
> > > written anyway)=2E Add a "#define DEBUG" to the top of
> > > drivers/net/phy/phylink=2Ec in addition to applying this patch, and =
please
> > > test the resulting kernel, sending me the resulting kernel messages,=
 and
> > > also reporting whether this works or not=2E
> >=20
> > Hi
> >=20
> > thx for the patch=2E=2E=2Esorry for misunderstanding=2E i thought the =
sfp quirk only sets a flag and i need to change
> > something in phylink=2Ec to do the same as done on userspace, so i tri=
ed to simulate the userspace call there only for testing=2E
> >=20
> > here relevant parts of debug
> >=20
> > [    1=2E990637] sfp sfp-1: module OEM              SFP-2=2E5G-T      =
 rev 1=2E0  sn SK2301110008     dc 230110 =20
> > [    2=2E000147] mtk_soc_eth 15100000=2Eethernet eth1: optical SFP: in=
terfaces=3D[mac=3D2-4,21-22, sfp=3D]
>=20
> First thing=2E=2E=2E why are the SFP interfaces here empty? They should =
be
> listing at least 22 for this SFP=2E Looking at the full log, you have
> omitted:
>=20
> [    2=2E008678] mtk_soc_eth 15100000=2Eethernet eth1: unsupported SFP m=
odule: no common interface modes

not sure why i have not added this as it should match the second grep for =
eth1 (sfp had not matched because of missing -i flag)
it was not intended to omit any relevant data, just wanted to pre-filter f=
rom full log=2E

> which seems to suggest that we need more than what I provided - and
> is a big pointer to why it isn't working=2E=2E=2E and I guess has been t=
here
> all along=2E
>=20
> This means that the interface configuration never gets updated, so
> its pointless trying to add quirks etc=2E Error messages are rather
> a key point=2E

thats clear, but somehow missed this one, sorry

> So everything after this is just not relevant=2E Let's fix that=2E Here'=
s
> an updated patch which sets an interface mode for this SFP and sets a
> link mode for it (although we use 2500baseX rather than baseT here
> just to test this)=2E I'm guessing it also does rate adaption, which we
> will have to work out later=2E

many thanks for guiding through this ;)

at least the error-message is gone, and interface gets up when i call etht=
oo to switch off autoneg=2E

root@bpi-r3:~# dmesg | grep -i 'sfp\|eth1'
[    0=2E000000] Linux version 6=2E3=2E0-rc1-bpi-r3-sfp13 (frank@frank-G5)=
 (aarch64-linux-gnu-gcc (Ubuntu 11=2E3=2E0-1ubuntu1~22=2E04) 11=2E3=2E0, GN=
U ld (GNU Binutils for Ubuntu) 2=2E38) #1 SMP Tue Mar 143
[    1=2E653862] sfp sfp-1: Host maximum power 1=2E0W
[    1=2E658862] sfp sfp-2: Host maximum power 1=2E0W
[    1=2E812551] mtk_soc_eth 15100000=2Eethernet eth1: mediatek frame engi=
ne at 0xffffffc00b080000, irq 123
[    1=2E991838] sfp sfp-1: module OEM              SFP-2=2E5G-T       rev=
 1=2E0  sn SK2301110008     dc 230110 =20
[    2=2E001352] mtk_soc_eth 15100000=2Eethernet eth1: optical SFP: interf=
aces=3D[mac=3D2-4,21-22, sfp=3D22]
[    2=2E010059] mtk_soc_eth 15100000=2Eethernet eth1: optical SFP: chosen=
 2500base-x interface
[    2=2E018145] mtk_soc_eth 15100000=2Eethernet eth1: requesting link mod=
e inband/2500base-x with support 00,00000000,00000000,0000e400
[   34=2E385814] mtk_soc_eth 15100000=2Eethernet eth1: configuring for inb=
and/2500base-x link mode
[   34=2E394259] mtk_soc_eth 15100000=2Eethernet eth1: major config 2500ba=
se-x
[   34=2E400860] mtk_soc_eth 15100000=2Eethernet eth1: phylink_mac_config:=
 mode=3Dinband/2500base-x/Unknown/Unknown/none adv=3D00,00000000,00000000,0=
000e400 pause=3D04 link=3D0 an=3D1
root@bpi-r3:~#=20
root@bpi-r3:~# ethtool -s eth1 autoneg off
root@bpi-r3:~# [  131=2E031902] mtk_soc_eth 15100000=2Eethernet eth1: Link=
 is Up - 2=2E5Gbps/Full - flow control off
[  131=2E040366] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready

full log here:
https://pastebin=2Ecom/yDC7PuM2

i see that an is still 1=2E=2Emaybe because of the fixed value here?

https://elixir=2Ebootlin=2Ecom/linux/v6=2E3-rc1/source/drivers/net/phy/phy=
link=2Ec#L3038

ethtool output after autoneg workaround:

Settings for eth1:                                                        =
                                                                           =
                                      =20
        Supported ports: [ FIBRE ]                                        =
                                                                           =
                                      =20
        Supported link modes:   2500baseX/Full                            =
                                                                           =
                                      =20
        Supported pause frame use: Symmetric Receive-only                 =
                                                                           =
                                      =20
        Supports auto-negotiation: No                                     =
                                                                           =
                                      =20
        Supported FEC modes: Not reported                                 =
                                                                           =
                                      =20
        Advertised link modes:  2500baseX/Full                            =
                                                                           =
                                      =20
        Advertised pause frame use: Symmetric Receive-only                =
                                                                           =
                                      =20
        Advertised auto-negotiation: No                                   =
                                                                           =
                                      =20
        Advertised FEC modes: Not reported                                =
                                                                           =
                                      =20
        Speed: 2500Mb/s                                                   =
                                                                           =
                                      =20
        Duplex: Full                                                      =
                                                                           =
                                      =20
        Auto-negotiation: off                                             =
                                                                           =
                                      =20
        Port: FIBRE                                                       =
                                                                           =
                                      =20
        PHYAD: 0                                                          =
                                                                           =
                                      =20
        Transceiver: internal                                             =
                                                                           =
                                      =20
        Current message level: 0x000000ff (255)                           =
                                                                           =
                                      =20
                               drv probe link timer ifdown ifup rx_err tx_=
err                                                                        =
                                      =20
        Link detected: yes

and yes, module seems to do rate adaption (it is labeled with 100M/1G/2=2E=
5G), i tried it on a 1G-Port and link came up (with workaround patch from d=
aniel),
traffic "works" but in tx-direction with massive retransmitts (i guess bec=
ause pause-frames are ignored - pause was 00)=2E

regards Frank
