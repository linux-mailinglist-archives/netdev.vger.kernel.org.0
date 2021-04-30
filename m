Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE0036FB05
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 14:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbhD3M56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 08:57:58 -0400
Received: from mout.gmx.net ([212.227.17.20]:54437 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232058AbhD3M54 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 08:57:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1619787383;
        bh=jiHjwD9KEK68VrKpFF0o4RmJfriOaSNHb7xO6qkSFnw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=fNvA3jtJLAhb4p4k8QHUa5XTxtODZkgZLi+CDT8cehPUC2F8NhU3lQGFlQv4hKX4e
         FEgp2lEdJgucvZgPXrLeN4KSTeDbO9YSlgxf1Yo8MgBYkE81Ixw/PR92QHa0FXz2kb
         gkOFX23ZxM3uSWyqtLV8aBkgBTRy9g+GwVT52b64=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [157.180.225.50] ([157.180.225.50]) by web-mail.gmx.net
 (3c-app-gmx-bap03.server.lan [172.19.172.73]) (via HTTP); Fri, 30 Apr 2021
 14:56:22 +0200
MIME-Version: 1.0
Message-ID: <trinity-611ff023-c337-4148-a215-98fd5604eac2-1619787382934@3c-app-gmx-bap03>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        David Miller <davem@davemloft.net>, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, Landen.Chao@mediatek.com,
        matthias.bgg@gmail.com, linux@armlinux.org.uk,
        sean.wang@mediatek.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, robh+dt@kernel.org, linus.walleij@linaro.org,
        gregkh@linuxfoundation.org, sergio.paracuellos@gmail.com,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, weijie.gao@mediatek.com,
        gch981213@gmail.com, opensource@vdorst.com, tglx@linutronix.de,
        maz@kernel.org
Subject: Aw: Re: Re: [PATCH net-next 0/4] MT7530 interrupt support
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 30 Apr 2021 14:56:22 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <YIv7w8Wy81fmU5A+@lunn.ch>
References: <20210429062130.29403-1-dqfext@gmail.com>
 <20210429.170815.956010543291313915.davem@davemloft.net>
 <20210430023839.246447-1-dqfext@gmail.com> <YIv28APpOP9tnuO+@lunn.ch>
 <trinity-843c99ce-952a-434e-95e4-4ece3ba6b9bd-1619786236765@3c-app-gmx-bap03>
 <YIv7w8Wy81fmU5A+@lunn.ch>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:Sa3V4OjTrIKRONdn3NifAbsvIirQD+5771qAC7rFgWOh0xYUx6aMMmd1EPpXyU3LtLuE+
 h+UmC8NEa3TcUD/lHdaoZmwfN7f4GCbb3mr1miP22LyCn5m2ldenQOQWIQHsU3+/ULuE/bsEItTk
 zt/d8NQy//tQPxYO8A5LBKBhU2EcY8oS7JzYpdvHiTUyfdHTSbaWgcI8jfcWu6L7FUAw1q8fnzaD
 8Ndr6yQZ9yQ6GKsJF9/Aqli6MBf3zMg6QLtySxt4eypYDu1MuNVs2iVt69uMY3oRdXNFTuQlj5YR
 M4=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:dTgbeb7UncI=:6kflibcpYS25s72RSdJapR
 Wu/WqFhtfUSkIlEStl0DKFlLOFUx7wdKQ7sachIrjnkuodBpA/H719VqEOXsaRJdG+vY4+6MY
 4Lu76ppEkpq2/QsnzLuSSZy5UqJyyS0MQZv7QdOovU+FxmQa94gsEvGizp92j46v0mhnSMYsW
 CJxwlPI04e++8y+Fm1J8a9JsK51ZVP0sRb2qUMIN8Q/C+gb/CI9gS8uTtrExGiyKHxiLv8rna
 dXgJR1LHPMsKpqkav7LEuf4hZ0IjatTa3iTwkQTaXW0eCiwWhqR4DsJp/vYWp9p0CcFd8afGZ
 H4fwJWJ00QDVte7u8lDiT1lHLXPYZhcwjclYtzykFi8713N+DmwNFI7IrjssmDCNFJtR6DErJ
 WsEA8l8h7axQoDu49m62eP+4OnTVrNAbw6hYDzQEKwcfmDxftueC3ZDOo+BmrR7Ai3GmFjIN1
 /D1Kyfe1WPE19SCqUzjf17qbXBrN7EWBUrmfEHxgzmWhgL/dPRbrzrO5kYXOjVggTI3eIhkX4
 Jkha4aBIhzY9yyfU/F2KScfAqttwpFWCY6B8N8scWV9Rl+3+EjWciYE+NQ3+89H7ZhPCIZTXW
 m7VJUu9ZF3bQeTihlp/cVon9IL8xkuGQb9a2ADH/P/oVKe2kyEw4g4+HDLSVjUwWA4H+v1Ct6
 gWjQqFlIgmlCAxMTjSQAug5IgeZhycnfMP9c92vfbin69F62lA/oJ+MIGBi17xtxms+0PCCDf
 LVrHwculOwxAHzDnH8sKaqPR2Up1dtQPc0IOZPtimeE9VsAMJXl1fs1sXP5eVwzxQxXZxms+b
 17X3yKspSHTVlOQSEgUEC6RkBkak6Hx6Uq9W407R/mkLnzrCvNyj18wEyuew8wLtKUo300erB
 RYlBXREWtAfWEggWJvfIQQXMGIjoqlJKshkx49eaMLU7zkbTFHudFKg2ZUWs1XNV4zLZSQlie
 WJp3Eg6P+pKIIzopCjFYlSLT0KM4xpHYfkMhzpnYRVr2YuyitFZitxVNDQHOSzskbtiqOamQ1
 ZeYLvrexM0YYP2ip8e7R/9k=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

which ethernet-phy drivers do you mean?
i found only combined phy-drivers with ethernet-handling (marvell,xilinx,mscc,ti) having the "phy-" prefix too

as i see something like this in drivers/phy/intel/

phy-intel-keembay-emmc.c
phy-intel-keembay-usb.c

maybe this in drivers/phy/mediatek/

phy-mediatek-mt753x.c

? maybe with additional -eth, but this seems redundant, as mt753x is an ethernet-switch

or like the other mtk-phys

phy-mtk-eth-mt7531.c (like phy-mtk-mipi-dsi.c,phy-mtk-hdmi.c,phy-mtk-hdmi-mt8173.c)

regards Frank


> Gesendet: Freitag, 30. April 2021 um 14:44 Uhr
> Von: "Andrew Lunn" <andrew@lunn.ch>
> That name will cause confusion with generic PHY drivers. They all seem
> to use phy- as a file name prefix. At the moment, no Ethernet PHY
> driver has phy as filename prefix or suffix.

