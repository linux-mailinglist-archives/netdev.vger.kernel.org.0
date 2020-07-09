Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5EA121A927
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgGIUis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:38:48 -0400
Received: from mout.gmx.net ([212.227.17.22]:36545 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgGIUir (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 16:38:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1594327091;
        bh=2UXj/YT1X1xRE6iXdWnGBTz2+zD4QV71s7VPwzbW098=;
        h=X-UI-Sender-Class:Date:In-Reply-To:References:Subject:Reply-to:To:
         CC:From;
        b=dc7wmo6i6/U4z4UFZCv2hyADvI9GnbubqtA4+cjFVinJIzToiqRyfwtKd9jTjfDmz
         88x9gV0RNDyW+Ok0R1wZQUcPXRFGajuwMnycWn1V+HYT1i9gNunfQGrv42JxiHMM/s
         I7w/rmdPA7oAGHsTh3j+vmr3gpagukk1bRve70ME=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from frank-s9 ([80.208.213.58]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M42jQ-1jtdJ52PB2-0001Ay; Thu, 09
 Jul 2020 22:38:11 +0200
Date:   Thu, 09 Jul 2020 22:38:04 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <20200709203134.GI1551@shell.armlinux.org.uk>
References: <20200709055742.3425-1-frank-w@public-files.de> <20200709134115.GK928075@lunn.ch> <20200709203134.GI1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2] net: ethernet: mtk_eth_soc: fix mtu warning
Reply-to: frank-w@public-files.de
To:     linux-mediatek@lists.infradead.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
CC:     netdev@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        linux-kernel@vger.kernel.org, Mark Lee <Mark-MC.Lee@mediatek.com>,
        =?ISO-8859-1?Q?Ren=E9_van_Dorst?= <opensource@vdorst.com>,
        John Crispin <john@phrozen.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, Felix Fietkau <nbd@nbd.name>
From:   Frank Wunderlich <frank-w@public-files.de>
Message-ID: <08A4F0A0-ED34-4FB1-BD38-0977C52771F1@public-files.de>
X-Provags-ID: V03:K1:h7S43N8I4FY0MTa+lsB0ECm63VvXcEgDY4fIR7I5CDS/H67dvv0
 yJI5IcRam4U4lWsr3Ta1+Oa1xvd/KII+gEkl3S4agBboYXBVuA9nqH4PIoWb7beeOYJaWwm
 T9ofk4Pey7aTQ71WubbVE2Wu6YWUhxyoRepZys6TpnvJtjS9Oqzu3EQ+gWIoBY42hgRs45Y
 t/XRuVj+HVg1BZtnAMWNQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:HIxVHMenlqU=:0JFB4OxdjQJLsk7Nnw88QD
 qRVVOTZfIQj1kDpgOg+cG4la+w4tWEZaK4pz6SrHVxKlAx+Ga90Hx6vJaw4prUrcAjk18uGgw
 YPOKhs9igXHKuq1BgZLZV4m/kuTvBOiA1bpE8P03gep+/YnBX5C2i419phyrEPX4V7ZqVuElP
 FLNdarM4vpMMTtwD/BpqMaIKFWwQDjxN1MZKJ6XX20J0rT0ZGCJnTSvlS+cTon2WnRwUxDePD
 pe/Dhls1p9TCTm4CsfdFbvi5Ql3HQFa+c7lnAjUSNe0obJX14J2toBIBIbF5XplBnx616+oKb
 1ZkexoLUgPBRWI78LTYw5uymy4e+7xHE+XuI1OR58Uk6m3xAoxPiF7zs96CCLI3ar9eE1bnHr
 354DbjTJ8PGnGN16IT2kzV7n/j3V3rzlj5gAeBGlF6y1sfwJFoHIGSiD0RHh3TGyrZXXN/pdX
 CxUdsV6w82c5z+yQyLJ/LrwjnytJkA/X44XlzRnoGlfswIbiRegidgUIUpI1OsEVbAkXpV5vU
 dIjUuYwA7gH6vmfDX9H9S/PoQt52TGCpvRrMfSDrrFo7ppW+8TIvoWvY8yR1ptPjK+Y4kXwun
 vYsS7gJ15b2R72tFXd9WcsTHkb/kW/JNPEr8iSM5rR52K1x347YrZOmfSrIzS5xs0+ewSZ1qA
 6aKyuZOFQ7Cy7AIGJ8ixtmruQa0aStA+AtchbmnrieOhPczvlbxYVnOWo07XXybZPHPh2IJ4q
 bQiDF57qxojfb3p6GK/RC2h1WaxqOde+GOJnJUCoTHDfqxBIsW7XFhSn6W2kq/HRRtEEMZ2ws
 1T1wtivps4VBX0wsUVT/3MLDwPAkt9rLoe7mwgwd/Q689MgY8P5CEam/8ZgepLfepNOBkw/ND
 r45zNXnvMPrSxcf4qILCeef3ApN6ZFMMdL66sjBuwyTw2oExAVTuOUbn/nPRwm18VjFsPDa+n
 ZHQlsS19gmrzx076c/C8Cq2O3tyFRPtTv2skyfcU6X+sLM5JRTiZeGZ+cLSXQdSCxIcJZ94NG
 ooeNsqD1EdtB0vz+wZ/jku5gRLea62TJEOp4DnRxbfgvxepPfU1EuUNXTkvP6fgY81K7Pr0jM
 AXH9fylN/bpDxAx0ogpQhHMLCbU6opZm1IR6Fe109r63iX6Cen1CZCi2WlLWwjYtU1pzG6agE
 nwnIwehdzF8+Hk6u9vxxjcln5weTYMohEIqPfZz33X+WO29LhojsQtBprJbhVx9hvFYYB5siW
 0K9VoPIiQqxCsuhmUm6xVZZd6wBipP++vkaSPoA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 9=2E Juli 2020 22:31:34 MESZ schrieb Russell King - ARM Linux admin <li=
nux@armlinux=2Eorg=2Euk>:
>Are there any plans to solve these warnings for Marvell 88e6xxx DSA
>ports?

Maybe it's a better idea to restore previous condition?

if (ret && ret !=3D -EOPNOTSUPP)

Or use another loglevel (dev_dbg)
regards Frank
