Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C38F9B5F1
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 19:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404118AbfHWR5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 13:57:15 -0400
Received: from mout.gmx.net ([212.227.15.15]:56701 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389214AbfHWR5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 13:57:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1566583013;
        bh=a3hZV3/n3ap+4WSZEq2RCiSPGLdIgJo4H4GyKnhd4jQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Ts+0NBdd02jIOaF9g1O+JvxABsznTx6snIgz4VeDRBddaITcjR6Nqv3e0N6vElRv9
         jRvzmc4DkatBYwteaGDAGJqGUC/qDK/SBtcBUBRggGsH0rFcVPRHpZRajiD3FpW2hq
         812QeuqLdTWOt4wZp6hTWFFLox9/EA5C91RjywIQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [217.61.154.8] ([217.61.154.8]) by web-mail.gmx.net
 (3c-app-gmx-bs75.server.lan [172.19.170.219]) (via HTTP); Fri, 23 Aug 2019
 19:56:53 +0200
MIME-Version: 1.0
Message-ID: <trinity-df75d11a-c27f-4941-a880-b017ebabd3dc-1566583013438@3c-app-gmx-bs75>
From:   "Frank Wunderlich" <frank-w@public-files.de>
To:     =?UTF-8?Q?=22Ren=C3=A9_van_Dorst=22?= <opensource@vdorst.com>
Cc:     "John Crispin" <john@phrozen.org>,
        "Sean Wang" <sean.wang@mediatek.com>,
        "Nelson Chang" <nelson.chang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        "Russell King" <linux@armlinux.org.uk>,
        "Stefan Roese" <sr@denx.de>,
        =?UTF-8?Q?=22Ren=C3=A9_van_Dorst=22?= <opensource@vdorst.com>
Subject: Aw: [PATCH net-next v3 0/3] net: ethernet: mediatek: convert to
 PHYLINK
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 23 Aug 2019 19:56:53 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20190823134516.27559-1-opensource@vdorst.com>
References: <20190823134516.27559-1-opensource@vdorst.com>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:S0kLgvQPkllpT2VhF6NadCxmnsC4j1OSSgjS8MvBJRToXf5272KzfOlHJTEuMwhdhRBkV
 alz6rIZAKym54sGmYq+kBS+OqXCV1CPFSm9ypNkwOGS14DBQAGcoVfPkdH5Nr7yncJza6H0T9DMr
 GZZCcFwyv72zk+Svv2dxTijzg3isID01ns4l5Tw3kfKQ41yAUKX5MS8Gm5+YCMtQydyWUEgWilq3
 HjT1GubFAxqdU7t3UOnwSylRmsBgFAQtFa37MIEPi0Iw0gTAhZUkmJCyNQM+D4nXU9D/xYGJC6W7
 Hc=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:JjDFsC2WnnU=:dLB5XzDJgCgcJHVkZzvig5
 sTjeopAWAVioeRr8fmySRP1TgkFxKvRFvH3V4mUfeb3fHx8O0wsGCKSHrMOR9ELfHshqz3Bss
 MyLUU7uOWk+qzN2c5je2sFCKWuOnlgvfW5TBU3GXrj4g7k8wsqCcb3G7s+/c/CpNPMBmGDApl
 tA+kC+/VNwnmQy+Htr97ROyH7qzxTYPnlYARpzFm5Q1atphm6wW6AGx+UiVttsNQiK6X3LfoM
 /wzkvPtWesv8LfSmoa3a4NlT+PxQYDhCrBCWDgiT+QEapuBUT7KcVjl0fX+iuHIjsycbBHRKR
 a0hIyb6KORjVOjSz7R+0EzfIzV07qo7nuqwZqayALOnLdmzVHgWda3T9nfuy5BARIgEcJ8Ol6
 72tHrpLx3s7zrX3NUdgOaxgaFDkyfDZZ9yB7+yN/9reEukzot6BSvGtlnWe+LETCno+Mvx85o
 xW59anHfl78cmTchS7iFUcSnlZqikA8R5gYnrrfenNILbTq/DOYKlcUaNDbTMTYh0SyShz7sb
 LQwdrByFdm1qPiSo5CPNb5z+/+iT7agAiLSdyfq2nnKJSU6z5aZqOJ2KF8OqUeaBNe6/Jn1Oa
 JpFKrukp3wtwVa+GA8HZndkCd14kMpR3jlOXKi4jhjzz8s4nNll4XDfh03MRrUi57hEeZJ+OD
 eOpHjC0BxSYsKoUsR9axMSqPLp/noA04+c7IaR4XXlFg12w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tested on bpi-r2 (mt7623/mt7530) and bpi-r64 (mt7622/rtl8367)

as reported to rene directly rx-path needs some rework because current rx-=
speed
on bpi-r2 is 865 Mbits/sec instead of ~940 Mbits/sec

Tested-by: Frank Wunderlich <frank-w@public-files=2Ede>

regards Frank


> Gesendet: Freitag, 23=2E August 2019 um 15:45 Uhr
> Von: "Ren=C3=A9 van Dorst" <opensource@vdorst=2Ecom>
> An: "John Crispin" <john@phrozen=2Eorg>, "Sean Wang" <sean=2Ewang@mediat=
ek=2Ecom>, "Nelson Chang" <nelson=2Echang@mediatek=2Ecom>, "David S =2E Mil=
ler" <davem@davemloft=2Enet>, "Matthias Brugger" <matthias=2Ebgg@gmail=2Eco=
m>
> Cc: netdev@vger=2Ekernel=2Eorg, linux-arm-kernel@lists=2Einfradead=2Eorg=
, linux-mediatek@lists=2Einfradead=2Eorg, linux-mips@vger=2Ekernel=2Eorg, "=
Russell King" <linux@armlinux=2Eorg=2Euk>, "Frank Wunderlich" <frank-w@publ=
ic-files=2Ede>, "Stefan Roese" <sr@denx=2Ede>, "Ren=C3=A9 van Dorst" <opens=
ource@vdorst=2Ecom>
> Betreff: [PATCH net-next v3 0/3] net: ethernet: mediatek: convert to PHY=
LINK
>
> These patches converts mediatek driver to PHYLINK API=2E
>=20
> v2->v3:
> * Phylink improvements and clean-ups after review
> v1->v2:
> * Rebase for mt76x8 changes
> * Phylink improvements and clean-ups after review
> * SGMII port doesn't support 2=2E5Gbit in SGMII mode only in BASE-X mode=
=2E
>   Refactor the code=2E
>=20
> Ren=C3=A9 van Dorst (3):
>   net: ethernet: mediatek: Add basic PHYLINK support
>   net: ethernet: mediatek: Re-add support SGMII
>   dt-bindings: net: ethernet: Update mt7622 docs and dts to reflect the
>     new phylink API
>=20
>  =2E=2E=2E/arm/mediatek/mediatek,sgmiisys=2Etxt        |   2 -
>  =2E=2E=2E/dts/mediatek/mt7622-bananapi-bpi-r64=2Edts  |  28 +-
>  arch/arm64/boot/dts/mediatek/mt7622=2Edtsi      |   1 -
>  drivers/net/ethernet/mediatek/Kconfig         |   2 +-
>  drivers/net/ethernet/mediatek/mtk_eth_path=2Ec  |  75 +--
>  drivers/net/ethernet/mediatek/mtk_eth_soc=2Ec   | 529 ++++++++++++-----=
-
>  drivers/net/ethernet/mediatek/mtk_eth_soc=2Eh   |  68 ++-
>  drivers/net/ethernet/mediatek/mtk_sgmii=2Ec     |  65 ++-
>  8 files changed, 477 insertions(+), 293 deletions(-)
>=20
> --=20
> 2=2E20=2E1
>=20
>
