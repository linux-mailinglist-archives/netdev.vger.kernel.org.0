Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9625536FD2F
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 17:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbhD3PBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 11:01:43 -0400
Received: from mout.gmx.net ([212.227.17.22]:59615 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhD3PBT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 11:01:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1619794787;
        bh=qjlBXZHE04sQy7D1Xhx0X5DzOE6ZA7NOBM8me5C/R/Q=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=YuibwIj8NQPoSbvYknLciWwyHkkOVtMPD/vRJBolyeRU1akGioJNzyOYWWBxiKQGZ
         rNuw5G8UzMcp/wh7KNWKzuBcA4QJ5FH7/u1I7EUHsUK9U8sDJG5G8qEbB0TCy1Bf1A
         9FzYABsuAAAAC0RnjHXZRMic4Y2Nv2fAm31O3zFM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [157.180.225.50] ([157.180.225.50]) by web-mail.gmx.net
 (3c-app-gmx-bap03.server.lan [172.19.172.73]) (via HTTP); Fri, 30 Apr 2021
 16:59:47 +0200
MIME-Version: 1.0
Message-ID: <trinity-c45bbeec-5b7c-43a2-8e86-7cb22ad61558-1619794787680@3c-app-gmx-bap03>
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
Subject: Aw: Re: Re: Re: [PATCH net-next 0/4] MT7530 interrupt support
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 30 Apr 2021 16:59:47 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <YIwCliT5NZT713WD@lunn.ch>
References: <20210429062130.29403-1-dqfext@gmail.com>
 <20210429.170815.956010543291313915.davem@davemloft.net>
 <20210430023839.246447-1-dqfext@gmail.com> <YIv28APpOP9tnuO+@lunn.ch>
 <trinity-843c99ce-952a-434e-95e4-4ece3ba6b9bd-1619786236765@3c-app-gmx-bap03>
 <YIv7w8Wy81fmU5A+@lunn.ch>
 <trinity-611ff023-c337-4148-a215-98fd5604eac2-1619787382934@3c-app-gmx-bap03>
 <YIwCliT5NZT713WD@lunn.ch>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:3W+2QeaDTZFi/muqkfARvOhkLYrfVFz6/YVDrpYyaSJgd2OdhBIyrcphMnEtviWnmP/1u
 s5AYUR9c0SH+PgDXagUi7Kao7l2UahPWHQbZpqfmebwjqN7gBDm7smwdJMvVmwtsQDwVqzhpvxTn
 pgiYQ5gpZ6rJEZ6/CBeBMEgcbvITDsVKT5Hz8hEFm9VGnEHhavg18a/ZMOJawUMyp+6BXvIbHqV2
 aAnC+GPjuUd+7or8EEqNWjVoSXvrcoCxKX5xFYeSSry1Pksv7GmiuuLSy63A75FrJRe62XHOUhIr
 Ys=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:EvyB3StFiq8=:LPmpx5r97csHQm8hjDY+5O
 xlx8rs4bLm4jaxPAppd2FQ2Dmv5INaOH2Lwi75dJJWMJbrS+Rr6HKRJkM1MtNhjLSnyt1Foc6
 AyMN3t+sTZumrhxx3iXvmUHMB9yJwT3l9gqPePgXd6Sl348MmbcqOorf0LNYFAryc+kdVP7Sj
 GnN3XwC6sA0wTWZ9SvaExv/YplOSzc+YZiQvVaGZ8fVlA7ImHLMJQRw9IahRH+tUGEYFVtD06
 iEDU4oKEQ64dFZU4+ZXH165pHBEvGGtJWeqm9cZO6p0xL+CtGwWC7/XCbJ9xZBt9BihRGAsel
 yNU/INVnTExmhKdiYwO00HpBlahz+CvzpSGr9AaUcpmMQ11Ts9a7vpc1TCi72KIwxGw6GFGMJ
 0X8+T/pZhiEY90ay/mG2E/cl2iLjgqiFqr/EUU3nS7AVKSYv+wJSqq0cnzkWTKaIMY6ywTL+q
 xerays+V32MfIXUQDUDjWinbEB6MVFrRKLKPbKNhvpgFqaXQ0dNeUwbWWy4toFQxOm0C8BZtS
 pFU5kA7oWHXDuXmjSADoPnzG7EZ+mZ+tV4gqTw9YlWBQVYp9fBdYcwzGzznGzEL2yP//uqeAz
 LjZx/GTrKZZZiuc87jmeENrlca2Fx9/vZMed7cwDmFT729gNzJnLJUUM3hFUvGSQmDRigVdq6
 5mmWcJ26KwHmlsU/Sz9st5wO4PCFO1EblJ/lWZfL0ouPbotApgKE71fiDXz571/eaJeVdJElY
 oUaOqlBZSV3myH/urs5LrbdIfUjZiiYh2hbRQQ3DjXODMKOx6/ymjT4LN6lkp2NjQQPaYOBOT
 nlEMbbekVVESdqR5hYb1gt6reVN2JlWuWK1rRyBfqzU+Nb5J3Dww+NQpPwK03qmveEVo7Dqcj
 0WrCd0JYpmH3oShRDqlgBa1FtQq5Rf+AyX0W1SJxJsKi7EFo01n0/WEEwWGzxvuo0ay3EvS7D
 mbX+f5dKa8w==
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Freitag, 30. April 2021 um 15:13 Uhr
> Von: "Andrew Lunn" <andrew@lunn.ch>
> > which ethernet-phy drivers do you mean?
>
> drivers/net/phy.

ok, sorry :)

> These are all examples of generic PHY drivers, not PHY drivers.

> There is a lot of confusion between PHY drivers and generic PHY
> drivers :-(

right, there is (at least by me) a confusion about generic phy and phy (he=
re net-only phy) drivers.

mhm, maybe the naming should differ if generic phy and net-phy are that di=
fferent. i guess there is no way to merge the net phys to the generic phys=
 (due to linking to the net device drivers) to have only 1 phy section, ri=
ght?

but if phy- prefix is used by generic phys, maybe eth- or net- can be used=
 here (maybe with "phy" added)

something like

eth-phy-mt753x.ko

else i have no idea now...my patch renaming the musb-module seems not to b=
e accepted due to possible breakage

regards Frank
