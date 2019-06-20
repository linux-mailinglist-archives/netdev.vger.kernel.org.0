Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 749024CE23
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 15:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731801AbfFTNCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 09:02:43 -0400
Received: from mout.gmx.net ([212.227.15.15]:51751 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726569AbfFTNCn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 09:02:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1561035730;
        bh=+afkOThX5iGh2rB1ktgwAzNdjRHJupZfIJ7drdFwZgo=;
        h=X-UI-Sender-Class:Date:In-Reply-To:References:Subject:Reply-to:To:
         CC:From;
        b=TC6fSpvQ6YnvG0rajSAOfWrG2Mb3JxwuuxBAF0IkUB1Y1BYY0nugbPs/eJFg7b+yw
         iaajMPYRVNVAbl0qqnxHvTAFv20Ja1sZgUDeDyI7i6gZnE2G1hNcRWdtG0p5JYeouy
         VPm4A9AbzbPWQR77dXmhxz8OoqhRIqjTr+dCp95A=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.218.201.144] ([88.128.80.145]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MbOoG-1hwiXe0qhA-00Illb; Thu, 20
 Jun 2019 15:02:10 +0200
Date:   Thu, 20 Jun 2019 15:02:04 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <20190620122155.32078-1-opensource@vdorst.com>
References: <20190620122155.32078-1-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 net-next 0/2] net: mediatek: Add MT7621 TRGMII mode support
Reply-to: frank-w@public-files.de
To:     =?ISO-8859-1?Q?Ren=E9_van_Dorst?= <opensource@vdorst.com>,
        sean.wang@mediatek.com, f.fainelli@gmail.com, davem@davemloft.net,
        matthias.bgg@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com
CC:     netdev@vger.kernel.org, john@phrozen.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
From:   Frank Wunderlich <frank-w@public-files.de>
Message-ID: <74C80E79-877C-4DEC-BC82-1195C3D0981F@public-files.de>
X-Provags-ID: V03:K1:xIO+yH9i6OHFj2f10Rv4UCkFlBt3qm7Dlkf80DSU+4Hpi3dZzfR
 X2JpvTbtZM7DauCbrwia3F9oqlqikYHqEb1eHHiCmXGxbY+Wk6sXXVfcy7Qkk98dOvvBKTJ
 hfIBxOf2QVeHwX3zEHsgf4F/dS/QKHaFp0uT5lOFoJAK94yHJOnnCi39AnzjtWiMGHfMU1/
 NDOIhG+ZNQHIyBIPIyzUA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:gLuq2wC3/5I=:8NE4223G084VtT9X+ICDmP
 +EYJ6KJjR+o1VJHowytLI7SHiRVkjpLGZcnhHD8Opk9tPxtmsAXMjnRxHqVcslTw+WvhREoob
 s6IYBbOHnZwRTON6fDr0YKCfBDxuVd/zxOv9hqlzB45cA/3kGSvd6I2WdsjRr1gNO7zPpGOL9
 OrZWraERWMDznpDAlWoRCTGLSpt+1P6XaWsWCdzcAInXmXZUPG2Dn7v80YkT1ibteOJOtJfc9
 G4UD8CHN3vvDk0+OFWGaBEVXliS5dLqZGyAu+6Le+mmaQM2262OR7lhShMPDeD+dCWpifhHIx
 cuL8rn8WIY3rdR2Os0EOBwxiDSZYV8Hzrnk2D8zai5VlxknekjU1i2XXIh/kDDcOylgDftADg
 YCQbm/YLB5MBVbypGSHdW8SZM6IfDf2ys/8ve964Ah2IR3IkgGY1YxZ5nu7jLauMiYT8WIDZl
 /Zhz1LZpQa9yeaTkoeH/eU3TSVxbVWVyHcK2+emENJMc1YHw9tB1A8J46K9tX3kb9sR45oXDb
 2R0K6wupIdi3246GKxU8xApf/wxL/MSNVxE8OgmH9DbZt7tzSAQRY8vGmPVTYRM37ZcafeBjn
 flT+hLmqupzTz+zS9eZrIL8J5U4VVNF89G6IXTRvjklnv7cPGFwN2ZiJb3/6C69L1il+wa4pl
 LdGAxK62hyKIboRTO6wnw8rtvPLNjUvHU/oH9q94QUTEDfc3/UeU1VvDTRDnhjnqqidKADE86
 zpQF+122RTNZATc+3LSzA4I0RkeTxrNKh9NgRUYgqrI3C5oz2BxovjlaGyquucBB5MHKPp8w9
 kuyQgsc0PyHEbDGuFx6FK0LiV6r0gO2Zba0OkVRocxKH05w98Gcj/3ejoOVSn1M4ATYd/WCoH
 8IKqvnaK2pFQNq9SaAB5NCXQEww9lFlgDDPZyY7c8ToaXC35/NQZ56Kb+cl2DccCdWS4KaDg3
 2GWXN4ZJv6pkn5vKWmn7tT30R8rCHteg0J00M6jxYB67azbua8cKA
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tested on Bananapi R2 (mt7623)

Tested-by: "Frank Wunderlich" <frank-w@public-files=2Ede>

Am 20=2E Juni 2019 14:21:53 MESZ schrieb "Ren=C3=A9 van Dorst" <opensource=
@vdorst=2Ecom>:
>Like many other mediatek SOCs, the MT7621 SOC and the internal MT7530
>switch both supports TRGMII mode=2E MT7621 TRGMII speed is fix 1200MBit=
=2E
>
>v1->v2:=20
> - Fix breakage on non MT7621 SOC
> - Support 25MHz and 40MHz XTAL as MT7530 clocksource
>
>Ren=C3=A9 van Dorst (2):
>  net: ethernet: mediatek: Add MT7621 TRGMII mode support
>  net: dsa: mt7530: Add MT7621 TRGMII mode support
>
> drivers/net/dsa/mt7530=2Ec                    | 46 ++++++++++++++++-----
> drivers/net/dsa/mt7530=2Eh                    |  4 ++
> drivers/net/ethernet/mediatek/mtk_eth_soc=2Ec | 38 +++++++++++++++--
> drivers/net/ethernet/mediatek/mtk_eth_soc=2Eh | 11 +++++
> 4 files changed, 85 insertions(+), 14 deletions(-)
