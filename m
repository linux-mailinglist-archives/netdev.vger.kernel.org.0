Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41916B9710
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 15:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbjCNOAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 10:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjCNOAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 10:00:17 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0F9A403A;
        Tue, 14 Mar 2023 06:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1678802351; i=frank-w@public-files.de;
        bh=H5jSBsXfpV8vfbpCM7sa9WUmHavxWAwDYJRxSvRoQa8=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=CsNlR9dbIdycw2Btnq6aJpvHy0H/7syh9WpfeS5PaxMuRNnb5bj2n02dUV32Sb9bT
         uAGkFJ5ne0RnK4vKo+LRky1RHeF7nu1vbfAP2isVhCLFdiNZ7hjRx6grLeK9XdPSez
         W9O2UMNH4Dg9Z5r+EWwyI5l1NmL9mkRRDQXqKt1bI3xOngPPoancE6MJ5r+oVXLeXX
         7tJsBbZhyXsP3ZptBLKlw/ezA7kbDn/vPjcQjcD3i0lP4svCBmqzaaceuK1W5/3IcF
         S2AQAXghA814NiW5aVuxO9+helWRHpNQsOGr4g0UaiRVhTlKhclmU3inrmGk0dTHTB
         fBfH23Kb6fWKg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [91.64.11.45] ([91.64.11.45]) by web-mail.gmx.net
 (3c-app-gmx-bap50.server.lan [172.19.172.120]) (via HTTP); Tue, 14 Mar 2023
 14:59:11 +0100
MIME-Version: 1.0
Message-ID: <trinity-99c1353c-98c3-4608-8079-9a818909e6c4-1678802351739@3c-app-gmx-bap50>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Aw: Re: [PATCH net-next v12 08/18] net: ethernet: mtk_eth_soc: fix
 1000Base-X and 2500Base-X modes
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 14 Mar 2023 14:59:11 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <ZBBIDqZaqdSfwu9g@shell.armlinux.org.uk>
References: <4B891976-C29E-4D98-B604-3AC4507D3661@public-files.de>
 <ZAzk71mTxgV/pRxC@shell.armlinux.org.uk>
 <trinity-8577978d-1c11-4f6d-ae11-aef37e8b78b0-1678624836722@3c-app-gmx-bap51>
 <ZA4wlQ8P48aDhDly@shell.armlinux.org.uk>
 <ZA8B/kI0fLx4gkQm@shell.armlinux.org.uk>
 <trinity-93681801-f99c-40e2-9fbd-45888b3069aa-1678732740564@3c-app-gmx-bs66>
 <ZA+qTyQ3n6YiURkQ@shell.armlinux.org.uk>
 <trinity-e2c457f1-c897-45f1-907a-8ea3664b7512-1678783872771@3c-app-gmx-bap66>
 <ZBA6gszARdJY26Mz@shell.armlinux.org.uk>
 <trinity-bc4bbf4e-812a-4682-ac8c-5178320467f5-1678788102813@3c-app-gmx-bap66>
 <ZBBIDqZaqdSfwu9g@shell.armlinux.org.uk>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:NhK14wNUkflro3RqDPkDuJrdLBQ+eZgN416pIUJfkynHCgThTB1VAWOMSDrDZuikOQfUw
 1iciGy0pZl87hzyoa2smS3HyUnDQPs9bBwcrO/cON/Uivue46pBI03HuTw0D0u6TysbvXbo/Zbex
 +DTPgFHdcdlrlek9l+4Yf582x6BbnBefHFD/9UcMqT+Gt1aRSD/MaM+IiVlsu7buvcpWs0ZI+VBX
 KD1iuO0RP2o0Ldq0BoePuCnaKO8HGoPFw04vkbxnmHqS+e1RBqsJRVRvEQDkEzCYSdcATRGqWWjL
 2o=
UI-OutboundReport: notjunk:1;M01:P0:oxG0TvV7TbI=;gg5M9XZ+TKu0eW25vHrBYq/dDo/
 iuDYdMGNWW7vQtvEGJy54P4lvzMdLZ5aKHwGt/LWMI8eFZ0JnRY1/edDv/q/J9xj6/UvHfr5M
 Tl7nj/oQLlX5+x7NIp4I84gHM92BfZ9z7GaR/njg9gRpZ4f/QWJpuGjVGJhPW3FjnxpSgyY3q
 vhOSGx0P2hYy8LKjDGHSQ6CWUEe8ECdYSiy40Vy0mBCFf2d11LZ1n8TwI24NxF677rWimpAut
 JoZN+qa1JVoSwAjcBLsg1sx6bErG5JtEoYAzBSGs+8Fx6IIEmHPDf517+y8uQLcv6lioi1MhN
 1zLnATVr+L7ZzNKAYBHjsND6BueUnPsKYD/Q63fhGaCdYI2NjGD+2Sg6EHz2ZIG7fT7O1u61s
 310gBcnwVg8LoEfQIPXXFvHyVdXb1jIg24qgdf/XqzqOIX2XafnWuYNdqE3B9AEGPOWkv3M+q
 HRvW+4BDf39ZjEx7TvWhphLzbs8NCSkXeYRRkS5W/jPbkcLQUNgptRGc9TjyOyNhcflB7vA6N
 IXoUR9WEHKHi1Ac+W9Eqyv0pYmex3iOh7w0qBaOOjC0xHl46iD44q1e2aAeAvI7dRgDViMvU8
 t+l7qsVPkMl4MZJsp+DQP/QhOLT0YM7qYuo0HpDCsuS/yMzFfUbVI+zDzWEOPv0URmT4hvJTg
 4M4ju+gWI+2wZR0ftO9Z54QEVNTWv/fINjOLiVb7x/NcRFJKRIbK08xpN+qGuYxHXu6u7NucH
 61uYBoPDdjSQCYSMrBljiqSQXwwq/yjw1T1a3gM9doYqidO/zFogB93mzE1b7b0fScd5VsK42
 AjGOczVxs33e/3yhvn1k/HAg==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

very good=2E=2E=2Edo not need the manual autoneg with the last Patch :)

> Gesendet: Dienstag, 14=2E M=C3=A4rz 2023 um 11:10 Uhr
> Von: "Russell King (Oracle)" <linux@armlinux=2Eorg=2Euk>

> For 802=2E3z modes, MLO_AN_INBAND with Autoneg clear in the advertising =
mode
> disables in-band negotiation=2E This is exactly how "ethtool -s ethX
> autoneg off" works=2E

ok, this seems now correctly set=2E

> > > The patch below should result in ethtool reporting 2500baseT rather =
than
> > > 2500baseX, and that an=3D1 should now be an=3D0=2E Please try it, an=
d dump the
> > > ethtool eth1 before asking for autoneg to be manually disabled, and =
also
> > > report the kernel messages=2E

root@bpi-r3:~# ip link set eth1 up                                        =
                                                                           =
                                      =20
[   91=2E624075] mtk_soc_eth 15100000=2Eethernet eth1: configuring for inb=
and/2500base-x link mode                                                   =
                                          =20
[   91=2E632485] mtk_soc_eth 15100000=2Eethernet eth1: major config 2500ba=
se-x                                                                       =
                                          =20
[   91=2E639094] mtk_soc_eth 15100000=2Eethernet eth1: phylink_mac_config:=
 mode=3Dinband/2500base-x/Unknown/Unknown/none adv=3D00,00000000,00008000,0=
0006400 pause=3D00 link=3D0 an=3D0                  =20
root@bpi-r3:~# [   95=2E808983] mtk_soc_eth 15100000=2Eethernet eth1: Link=
 is Up - Unknown/Unknown - flow control off                                =
                                          =20
[   95=2E817706] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready  =
                                                                           =
                                        =20
                                                                          =
                                                                           =
                                      =20
root@bpi-r3:~# ethtool eth1                                               =
                                                                           =
                                      =20
Settings for eth1:                                                        =
                                                                           =
                                      =20
        Supported ports: [ FIBRE ]                                        =
                                                                           =
                                      =20
        Supported link modes:   2500baseT/Full                            =
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
        Advertised link modes:  2500baseT/Full                            =
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
        Speed: Unknown!                                                   =
                                                                           =
                                      =20
        Duplex: Unknown! (255)                                            =
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
        Link detected: yes=20

root@bpi-r3:~# dmesg | grep -i 'sfp\|eth1'                                =
                                                                           =
                                      =20
[    0=2E000000] Linux version 6=2E3=2E0-rc1-bpi-r3-sfp13 (frank@frank-G5)=
 (aarch64-linux-gnu-gcc (Ubuntu 11=2E3=2E0-1ubuntu1~22=2E04) 11=2E3=2E0, GN=
U ld (GNU Binutils for Ubuntu) 2=2E38) #2 SMP Tue Mar 143
[    1=2E658048] sfp sfp-1: Host maximum power 1=2E0W                     =
                                                                           =
                                          =20
[    1=2E663128] sfp sfp-2: Host maximum power 1=2E0W                     =
                                                                           =
                                          =20
[    1=2E812401] mtk_soc_eth 15100000=2Eethernet eth1: mediatek frame engi=
ne at 0xffffffc00af80000, irq 123                                          =
                                          =20
[    2=2E001796] sfp sfp-1: module OEM              SFP-2=2E5G-T       rev=
 1=2E0  sn SK2301110008     dc 230110                                      =
                                            =20
[    2=2E011307] mtk_soc_eth 15100000=2Eethernet eth1: optical SFP: interf=
aces=3D[mac=3D2-4,21-22, sfp=3D22]                                         =
                                                =20
[    2=2E020000] mtk_soc_eth 15100000=2Eethernet eth1: optical SFP: chosen=
 2500base-x interface                                                      =
                                          =20
[    2=2E028080] mtk_soc_eth 15100000=2Eethernet eth1: requesting link mod=
e inband/2500base-x with support 00,00000000,00008000,00006400             =
                                          =20
[   91=2E624075] mtk_soc_eth 15100000=2Eethernet eth1: configuring for inb=
and/2500base-x link mode                                                   =
                                          =20
[   91=2E632485] mtk_soc_eth 15100000=2Eethernet eth1: major config 2500ba=
se-x                                                                       =
                                          =20
[   91=2E639094] mtk_soc_eth 15100000=2Eethernet eth1: phylink_mac_config:=
 mode=3Dinband/2500base-x/Unknown/Unknown/none adv=3D00,00000000,00008000,0=
0006400 pause=3D00 link=3D0 an=3D0                  =20
[   95=2E808983] mtk_soc_eth 15100000=2Eethernet eth1: Link is Up - Unknow=
n/Unknown - flow control off                                               =
                                          =20
[   95=2E817706] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready

so you can see the link-up comes directly after the interface up

does the ethtool-output look like expected? i see speed/duplex is set as s=
upported/advertised but not active

        Supported link modes:   2500baseT/Full
        Advertised link modes:  2500baseT/Full
vs=2E
        Speed: Unknown!                                                   =
                                                                           =
                                      =20
        Duplex: Unknown! (255)=20

maybe because of the

@@ -3003,7 +3007,8 @@ static int phylink_sfp_config_optical(struct phylink=
 *pl)
        config=2Espeed =3D SPEED_UNKNOWN;
        config=2Eduplex =3D DUPLEX_UNKNOWN;
        config=2Epause =3D MLO_PAUSE_AN;

imho ETHTOOL_LINK_MODE_2500baseT_Full_BIT sets only the supported which in=
tersected with the advertised from the other side maximum should be taken a=
s actual mode=2E=2E=2Eso this part seems not correctly working at the momen=
t=2E

the "Supported ports: [ FIBRE ]" is also misleading for copper sfp, but im=
ho all SFP are shown like this=2E

full log if needed:
https://pastebin=2Ecom/6yWe4Kyi

next step:
is it possible to have pause for rate adaption (handling rx pause frames c=
orrectly)?

regards Frank
