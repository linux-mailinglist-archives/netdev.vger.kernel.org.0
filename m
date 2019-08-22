Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10E1599860
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 17:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731416AbfHVPoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 11:44:55 -0400
Received: from mout.gmx.net ([212.227.17.21]:44183 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbfHVPoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 11:44:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1566488653;
        bh=Vy2sL6yIc2Cm33yYziTqAMn0mT4b4EWOI52QiBXdRmc=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=QrOHC6/2NAmFobf5S2YYzs5TWISc4dkEgsm5srJ57fksDPmZB21ItRv9XjzV9cu45
         9nYnDIY/F6xa164T9B2M2OOw5hOcwSpgxZJAnlhW002+Z4B1iLgtsZfGSgDtAqqWR8
         c0/aCfFCDn9ugbR4ouH7YUnV+aie8Hwekw14+hfg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [217.61.154.89] ([217.61.154.89]) by web-mail.gmx.net
 (3c-app-gmx-bap07.server.lan [172.19.172.77]) (via HTTP); Thu, 22 Aug 2019
 17:44:13 +0200
MIME-Version: 1.0
Message-ID: <trinity-b1f48e51-af73-466d-9ecf-d560a7d7c1ee-1566488653737@3c-app-gmx-bap07>
From:   "Frank Wunderlich" <frank-w@public-files.de>
To:     =?UTF-8?Q?=22Ren=C3=A9_van_Dorst=22?= <opensource@vdorst.com>
Cc:     "Sean Wang" <sean.wang@mediatek.com>,
        "Andrew Lunn" <andrew@lunn.ch>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        =?UTF-8?Q?=22Ren=C3=A9_van_Dorst=22?= <opensource@vdorst.com>,
        linux-mediatek@lists.infradead.org,
        "John Crispin" <john@phrozen.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Aw: [PATCH net-next v2 0/3] net: dsa: mt7530: Convert to PHYLINK
 and add support for port 5
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 22 Aug 2019 17:44:13 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20190821144547.15113-1-opensource@vdorst.com>
References: <20190821144547.15113-1-opensource@vdorst.com>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:OnOmnNjRELKVDhw1WQ00dkVJuIqcBT9mIxsIJFG3y8nB9jk9SoGT1zYS+j7Hrug05uaRc
 wyfpj5sv6EnDKgPWJT1nDz20RXXwzuhx/jflRFQlLJECmmRxBLZT0IDWBzDceWlqwm05vt1Q30ZB
 qxHcSPFXQfWgRe6xK7ko3+YGTQsteRpHY6fIjn1gREIrNVmzXUH898hwnFvyxpkJw7gBmpF5JbYX
 OotJuHOPdSolA/xZdJ4ol64gN4UuJddW0ahxqEcnYXSi4BvaojZNNekB7/0c1Z/6rTCdONIWuqqA
 FU=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:A9vU9Oh1LEE=:DFgHGOwKN1RHx6kZQ498pi
 zX+xC8Drxjpw+G+vUDjrzkxjmEdsaQWF99BUxfFFCB1Lbuxweib2bcOxiDc45mjrxOKULzmBh
 Tc2QG63jIq3UVmi7GJusiZoTjWppmjHJnLO7rDs3sgR8JItcfzD7Jrpm8MCL0ZgeQek/IL3S5
 MIlrU9tpcspXV28cUK4mCDjbykLugedrl7F6hjyTULWoG6kiPjLERQ+tK8mD9CKwmRIDNHM5U
 pj3Iy3MikCcaCxfSaOzM/mFoqXkbr5HjHN1odpnXWmt6OFas74gyG/3zS0YtfbfWmEaUZETvG
 mtVkJqwC5SmAZO7A/U6QPdQbtz7by7K2q4BuMpLEOG00hcZd728gvTyFy4ijTfLJqvNbf9pLb
 QvpKS3YZjTkgd6EEk3AnQvLG5DdDJDqP5B8+dKZ5uvrgbDt309vqoAKI1acHb9grNIqcyzsc4
 9FsqenYJm99b8XMLxZNWdelX12TmV2HUBZqqzOFxZ8W3vIf9dGoD+qMk8kPnQzLd9Tz7BSLuS
 d8292YpgCPIH1Plr1UZUan+Csz6krXBBiDhfgA70meddJds6kDD0b5bh7MuDwMC2Dh90kb38D
 z/9p4y6SR4kUOz/OHWXwi81phfKlOK/oZHIGZVPpSXN3d+rXsqoINiaFv7EBjC7s40cZQQ+yM
 0UfGTxouFcI+56UwaoItJWKiDXNeSPvXruKyh7SCBStUFbg==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

tested on BPI-R2 (mt7623) with 2 Problems (already reported to Rene, just =
to inform everyone)...maybe anybody has an idea

- linux-next (i know it's not part of the series, but a pitfall on testing=
 other devices) seems to break power-regulator somewhere here:

priv->core_pwr =3D devm_regulator_get(&mdiodev->dev, "core"); returns 517

#define EPROBE_DEFER517/* Driver requests probe retry */

https://elixir.bootlin.com/linux/latest/source/drivers/regulator/core.c#L1=
726

without linux-next switch came up including dsa-ports

- RX-traffic (run iperf3 -c x.x.x.x -R) is only 780 Mbits/sec (TX=3D940 Mb=
its/sec), same measure with 5.3-rc4 gives 940 MBit/s with same devices,
maybe caused by changes for mt76x8?

regards Frank
