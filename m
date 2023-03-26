Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF066C9402
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 13:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjCZLgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 07:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjCZLgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 07:36:37 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAED83DA
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 04:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1679830571; i=frank-w@public-files.de;
        bh=XbthwJQWpL5raTC6GTcl63kkVNXkn9VwevjO7N53JEE=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=mk7Z6JySrqPosvAPtR+fE/Fmk/V+sWaLLpLRhsUCSoLQ6/H2dtmQ1hCQALiE9Pdaj
         8EnwXJk9CwUERIbti/ip3gfOsM1vYYk/UiC62MhZiAlF0PcXWf+vXjcRe21oGjxiq7
         C9HALh4A7qWP3FlOdASaRNgWQVbIru/pDOKEG1C/rObubO3Y1V8DgAM8TT04gXTtb/
         TKKbVCVZxbxch3NE0VPXsK1Xl7rdijzxNRPKDd0BqCkToOVBXarJdISZDBAUjXoTy7
         rGfka++/jrPRiGs+KOZdcqpvxXCD4YZGdDVqIHg1qpaMvckaGaUCUBDmRi/Fepe92s
         99a+mIUJIPcug==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [80.245.78.73] ([80.245.78.73]) by web-mail.gmx.net
 (3c-app-gmx-bap45.server.lan [172.19.172.115]) (via HTTP); Sun, 26 Mar 2023
 13:36:11 +0200
MIME-Version: 1.0
Message-ID: <trinity-d65e8e0e-6837-49d9-b5e2-1e1d68c289d3-1679830571282@3c-app-gmx-bap45>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Aw: Re: [PATCH net-next 2/2] net: sfp: add quirk for 2.5G copper
 SFP
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 26 Mar 2023 13:36:11 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <ZB9NKo3iXe7CZSId@shell.armlinux.org.uk>
References: <ZBniMlTDZJQ242DP@shell.armlinux.org.uk>
 <E1pefJz-00Dn4V-Oc@rmk-PC.armlinux.org.uk>
 <ZB5YgPiZYwbf/G2u@makrotopia.org> <ZB7/v8oUu3lkO4yC@shell.armlinux.org.uk>
 <ZB8Upcgv8EIovPCl@makrotopia.org> <ZB9NKo3iXe7CZSId@shell.armlinux.org.uk>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:3RxTUbgFf4x6WZv3FavinS95y4rcGbw/lPTPKHj0R9mNIGivOCm9h/CGyj3ZdN9jmgyxc
 Rvqbk+S3ldyWLhbEC4vX+oB6TCTkvwuZj6uhW/ey3nNI3pY/F07YhuyeYbNhGtgYVFvtH6osQZA8
 ktvfauhT67zqdyFG3p/F/teFDiffGfVnYETOAM0txCXiaShbaPmezYuWt1xtNe3ENXkX1QuVCq1X
 Zzx5FOrxwoujtbY7g0Txap4lHr7GXS36tRyBEYCOWu/G8mTr0+msyRc3lKDwb2CLPVN6+022Gt0k
 jQ=
UI-OutboundReport: notjunk:1;M01:P0:BeLWVakyC5U=;o0k3dOXz0e+WuHw8drk4xoU4unt
 QK6rvAll2JbTuhmbTsigIerrvW3pxghgsRpSvICmgvhY71D+m971xiQUyeujiNCEqGgWHU93F
 PsKfBOz4lW/dXOVoy27Lv2QEtrmM6cskiSzVTwDsEduc+QfE5Gc2I3KFJpJSZTUm7/ZQOBirt
 ZI0HZnKANm2sZf0ADp9+7tton2tA9EEmPgmcDB/PdIw1NhjlV7f7O6zDngpm+h4f0nlDHgaWT
 6cV/dGdYcvkZQQlMevJZQP8xxf6qKVghJ8Vf2G1wf8k9Jia71Hz9FTJuw1N2B5/jv0vIVjg9O
 M1H6bf4P1jwz/iOHo3BolkGxHgmBzQmPqpbu8SQ5FnGerdmjbWHRzb4+w1J8YfYY8rHmtpnEx
 kgun1GsqUa+EMkDbjEao/HXA6WjwuJHM2EJm4h7qZLh60wNMlUJsP3JDTaipLQiPJquNWcu83
 fmRUmiC299NhHv64StjPLMY/XnHeTC2S8/iSCyTG7gp9admysxbvZVTK/z9tsq9jFDEwaSxis
 TWUewxAUTRe5afYkLuiPbaKSLm+i249ogHUepBh8bxMvAzwojyF5RirTjOMbquFegoUgzJAam
 necdin2nYV1nAW663I7EHhh4j9ZlMlTuSi5HcJk7NkvmjvHnjBFruBuzTAyVCWojJBDapCwR5
 rsZpKkXyLVM4EbDbQlgylVHEX1saXiP07veOstnqDxSo1KsVQfhTNPszMVvUNxB5cHZLA12vA
 GdErxH+5to6sYQXYyEQXkt2g4p+GBPjfo7EdCrGoLOCWT4yp+Aj6pDMzQ1ubY+c0VTxqAp4jw
 1huX1WdphIuFWzqHwt/0LZhQByb/PgOue/YXXPhgafIS0=
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Samstag, 25=2E M=C3=A4rz 2023 um 21:36 Uhr
> Von: "Russell King (Oracle)" <linux@armlinux=2Eorg=2Euk>
> An: "Daniel Golle" <daniel@makrotopia=2Eorg>
> Cc: "Andrew Lunn" <andrew@lunn=2Ech>, "Heiner Kallweit" <hkallweit1@gmai=
l=2Ecom>, "David S=2E Miller" <davem@davemloft=2Enet>, "Eric Dumazet" <edum=
azet@google=2Ecom>, "Frank Wunderlich" <frank-w@public-files=2Ede>, "Jakub =
Kicinski" <kuba@kernel=2Eorg>, netdev@vger=2Ekernel=2Eorg, "Paolo Abeni" <p=
abeni@redhat=2Ecom>
> Betreff: Re: [PATCH net-next 2/2] net: sfp: add quirk for 2=2E5G copper =
SFP
>
> On Sat, Mar 25, 2023 at 03:35:01PM +0000, Daniel Golle wrote:
> > On Sat, Mar 25, 2023 at 02:05:51PM +0000, Russell King (Oracle) wrote:
> > > On Sat, Mar 25, 2023 at 02:12:16AM +0000, Daniel Golle wrote:
> > > > Hi Russell,
> > > >=20
> > > > On Tue, Mar 21, 2023 at 04:58:51PM +0000, Russell King (Oracle) wr=
ote:
> > > > > Add a quirk for a copper SFP that identifies itself as "OEM"
> > > > > "SFP-2=2E5G-T"=2E This module's PHY is inaccessible, and can onl=
y run
> > > > > at 2500base-X with the host without negotiation=2E Add a quirk t=
o
> > > > > enable the 2500base-X interface mode with 2500base-T support, an=
d
> > > > > disable autonegotiation=2E
> > > > >=20
> > > > > Reported-by: Frank Wunderlich <frank-w@public-files=2Ede>
> > > > > Tested-by: Frank Wunderlich <frank-w@public-files=2Ede>
> > > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux=2Eorg=
=2Euk>
> > > >=20
> > > > I've tried the same fix also with my 2500Base-T SFP module:
> > > > diff --git a/drivers/net/phy/sfp=2Ec b/drivers/net/phy/sfp=2Ec
> > > > index 4223c9fa6902=2E=2Ec7a18a72d2c5 100644
> > > > --- a/drivers/net/phy/sfp=2Ec
> > > > +++ b/drivers/net/phy/sfp=2Ec
> > > > @@ -424,6 +424,7 @@ static const struct sfp_quirk sfp_quirks[] =3D=
 {
> > > >         SFP_QUIRK_F("Turris", "RTSFP-10", sfp_fixup_rollball),
> > > >         SFP_QUIRK_F("Turris", "RTSFP-10G", sfp_fixup_rollball),
> > > >         SFP_QUIRK_F("OEM", "SFP-GE-T", sfp_fixup_ignore_tx_fault),
> > > > +       SFP_QUIRK_M("TP-LINK", "TL-SM410U", sfp_quirk_oem_2_5g),
> > > >  };
> > > >=20
> > > >  static size_t sfp_strlen(const char *str, size_t maxlen)
> > >=20
> > > Thanks for testing=2E
> > >=20
> > > > However, the results are a bit of a mixed bag=2E The link now does=
 come up
> > > > without having to manually disable autonegotiation=2E However, I s=
ee this
> > > > new warning in the bootlog:
> > > > [   17=2E344155] sfp sfp2: module TP-LINK          TL-SM410U      =
  rev 1=2E0  sn 12154J6000864    dc 210606 =20
> > > > =2E=2E=2E
> > > > [   21=2E653812] mt7530 mdio-bus:1f sfp2: selection of interface f=
ailed, advertisement 00,00000000,00000000,00006440
> > >=20
> > > This will be the result of issuing an ethtool command, and phylink
> > > doesn't know what to do with the advertising mask - which is saying:
> > >=20
> > >    Autoneg, Fibre, Pause, AsymPause
> > >=20
> > > In other words, there are no capabilities to be advertised, which is
> > > invalid, and suggests user error=2E What ethtool command was being
> > > issued?
> >=20
> > This was simply adding the interface to a bridge and bringing it up=2E
> > No ethtool involved afaik=2E
>=20
> If its not ethtool, then there is only one other possibility which I
> thought had already been ruled out - and that is the PHY is actually
> accessible, but either we don't have a driver for it, or when reading
> the PHY's "features" we don't know what it is=2E
>=20
> Therefore, as the PHY is accessible, we need to identify what it is
> and have a driver for it=2E
>=20
> Please apply the following patch to print some useful information
> about the PHY:


i tried this patch too to get more information about the phy of my sfp (i =
use gmac1 instead of the mt7531 port5), but see nothing new

root@bpi-r3:~# dmesg | grep 'sfp\|phy'
[    0=2E000000] Booting Linux on physical CPU 0x0000000000 [0x410fd034]
[    0=2E000000] arch_timer: cp15 timer(s) running at 13=2E00MHz (phys)=2E
[    1=2E654975] sfp sfp-1: Host maximum power 1=2E0W
[    1=2E659976] sfp sfp-2: Host maximum power 1=2E0W
[    2=2E001284] sfp sfp-1: module OEM              SFP-2=2E5G-T       rev=
 1=2E0  sn SK2301110008     dc 230110 =20
[    2=2E010789] mtk_soc_eth 15100000=2Eethernet eth1: optical SFP: interf=
aces=3D[mac=3D2-4,21-22, sfp=3D22]
[    3=2E261039] mt7530 mdio-bus:1f: phylink_mac_config: mode=3Dfixed/2500=
base-x/2=2E5Gbps/Full/none adv=3D00,00000000,00008000,00006200 pause=3D03 l=
ink=3D0 an=3D1
[    3=2E293176] mt7530 mdio-bus:1f wan (uninitialized): phy: gmii setting=
 supported 00,00000000,00000000,000062ef advertising 00,00000000,00000000,0=
00062ef
[    3=2E326808] mt7530 mdio-bus:1f lan0 (uninitialized): phy: gmii settin=
g supported 00,00000000,00000000,000062ef advertising 00,00000000,00000000,=
000062ef
[    3=2E360144] mt7530 mdio-bus:1f lan1 (uninitialized): phy: gmii settin=
g supported 00,00000000,00000000,000062ef advertising 00,00000000,00000000,=
000062ef
[    3=2E393490] mt7530 mdio-bus:1f lan2 (uninitialized): phy: gmii settin=
g supported 00,00000000,00000000,000062ef advertising 00,00000000,00000000,=
000062ef
[    3=2E426819] mt7530 mdio-bus:1f lan3 (uninitialized): phy: gmii settin=
g supported 00,00000000,00000000,000062ef advertising 00,00000000,00000000,=
000062ef
[   15=2E156727] mtk_soc_eth 15100000=2Eethernet eth0: phylink_mac_config:=
 mode=3Dfixed/2500base-x/2=2E5Gbps/Full/none adv=3D00,00000000,00008000,000=
06240 pause=3D03 link=3D0 an=3D1
[   15=2E178021] mt7530 mdio-bus:1f lan3: configuring for phy/gmii link mo=
de
[   15=2E192190] mt7530 mdio-bus:1f lan3: phylink_mac_config: mode=3Dphy/g=
mii/Unknown/Unknown/none adv=3D00,00000000,00000000,00000000 pause=3D00 lin=
k=3D0 an=3D0
[   15=2E208137] mt7530 mdio-bus:1f lan3: phy link down gmii/Unknown/Unkno=
wn/none/off
[   15=2E216371] mt7530 mdio-bus:1f lan2: configuring for phy/gmii link mo=
de
[   15=2E228163] mt7530 mdio-bus:1f lan2: phylink_mac_config: mode=3Dphy/g=
mii/Unknown/Unknown/none adv=3D00,00000000,00000000,00000000 pause=3D00 lin=
k=3D0 an=3D0
[   15=2E242579] mt7530 mdio-bus:1f lan1: configuring for phy/gmii link mo=
de
[   15=2E245731] mt7530 mdio-bus:1f lan2: phy link down gmii/Unknown/Unkno=
wn/none/off
[   15=2E261771] mt7530 mdio-bus:1f lan1: phylink_mac_config: mode=3Dphy/g=
mii/Unknown/Unknown/none adv=3D00,00000000,00000000,00000000 pause=3D00 lin=
k=3D0 an=3D0
[   15=2E277381] mt7530 mdio-bus:1f lan0: configuring for phy/gmii link mo=
de
[   15=2E278665] mt7530 mdio-bus:1f lan1: phy link down gmii/Unknown/Unkno=
wn/none/off
[   15=2E296641] mt7530 mdio-bus:1f lan0: phylink_mac_config: mode=3Dphy/g=
mii/Unknown/Unknown/none adv=3D00,00000000,00000000,00000000 pause=3D00 lin=
k=3D0 an=3D0
[   15=2E312570] mt7530 mdio-bus:1f lan0: phy link down gmii/Unknown/Unkno=
wn/none/off
[   15=2E392799] mt7530 mdio-bus:1f wan: configuring for phy/gmii link mod=
e
[   15=2E404425] mt7530 mdio-bus:1f wan: phylink_mac_config: mode=3Dphy/gm=
ii/Unknown/Unknown/none adv=3D00,00000000,00000000,00000000 pause=3D00 link=
=3D0 an=3D0
[   15=2E420491] mt7530 mdio-bus:1f wan: phy link up gmii/1Gbps/Full/none/=
rx/tx
[  262=2E106630] mtk_soc_eth 15100000=2Eethernet eth1: phylink_mac_config:=
 mode=3Dinband/2500base-x/Unknown/Unknown/none adv=3D00,00000000,00008000,0=
0006400 pause=3D00 link=3D0 an=3D0

full log: https://pastebin=2Ecom/9DbCayjv

root@bpi-r3:~# ethtool eth1
Settings for eth1:
        Supported ports: [ FIBRE ]
        Supported link modes:   2500baseT/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: No
        Supported FEC modes: Not reported
        Advertised link modes:  2500baseT/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: No
        Advertised FEC modes: Not reported
        Speed: Unknown!
        Duplex: Unknown! (255)
        Auto-negotiation: off
        Port: FIBRE
        PHYAD: 0
        Transceiver: internal
        Current message level: 0x000000ff (255)
                               drv probe link timer ifdown ifup rx_err tx_=
err
        Link detected: yes
root@bpi-r3:~# ethtool -m eth1
        Identifier                                : 0x03 (SFP)
        Extended identifier                       : 0x04 (GBIC/SFP defined=
 by 2-wire interface ID)
        Connector                                 : 0x07 (LC)
        Transceiver codes                         : 0x00 0x01 0x00 0x00 0x=
00 0x00 0x02 0x00 0x00
        Transceiver type                          : SONET: OC-48, short re=
ach
        Encoding                                  : 0x05 (SONET Scrambled)
        BR, Nominal                               : 2500MBd
=2E=2E=2E

i guess because sfp interface is not PHY_INTERFACE_MODE_NA but 2500BaseX=
=2E=2E=2Eshould we move this out of the condition?

regards Frank
