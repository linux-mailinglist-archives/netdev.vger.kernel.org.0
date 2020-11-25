Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8B62C49DC
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 22:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732100AbgKYV2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 16:28:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:55526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732060AbgKYV2B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 16:28:01 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 020EB206E0;
        Wed, 25 Nov 2020 21:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606339680;
        bh=yEcWykMhdTmveduVtuMvF2XnF4rc1S8SYqqjK1rp9k4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dJkrg8GItUQKlYAcWSAVHfZsBt88Yp3U2B8V8VwhEKfHkDEXjGhHpx8C3BjoYKwP/
         Tzz5CFy5twTGW5i8YM5NYtOA+Utuky+TPGTsWxMF1y0R9u5C47mRJ+dle9A4dOg2b1
         ojrb27UXPWnVMNCt57S+nC66GRdufnxjX9+xfRAw=
Date:   Wed, 25 Nov 2020 13:27:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?xYF1a2Fzeg==?= Stelmach <l.stelmach@samsung.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?UTF-8?B?QmFydMWCb21pZWogxbtvbG5pZXJr?= =?UTF-8?B?aWV3aWN6?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v7 3/3] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Message-ID: <20201125132758.4554afe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124120330.32445-4-l.stelmach@samsung.com>
References: <20201124120330.32445-1-l.stelmach@samsung.com>
        <CGME20201124120337eucas1p268c7e3147ea36e62d40d252278c5dcb7@eucas1p2.samsung.com>
        <20201124120330.32445-4-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 13:03:30 +0100 =C5=81ukasz Stelmach wrote:
> ASIX AX88796[1] is a versatile ethernet adapter chip, that can be
> connected to a CPU with a 8/16-bit bus or with an SPI. This driver
> supports SPI connection.
>=20
> The driver has been ported from the vendor kernel for ARTIK5[2]
> boards. Several changes were made to adapt it to the current kernel
> which include:
>=20
> + updated DT configuration,
> + clock configuration moved to DT,
> + new timer, ethtool and gpio APIs,
> + dev_* instead of pr_* and custom printk() wrappers,
> + removed awkward vendor power managemtn.
> + introduced ethtool tunable to control SPI compression
>=20
> [1] https://www.asix.com.tw/products.php?op=3DpItemdetail&PItemID=3D104;6=
5;86&PLine=3D65
> [2] https://git.tizen.org/cgit/profile/common/platform/kernel/linux-3.10-=
artik/
>=20
> The other ax88796 driver is for NE2000 compatible AX88796L chip. These
> chips are not compatible. Hence, two separate drivers are required.
>=20
> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>

drivers/net/ethernet/asix/ax88796c_main.c: In function =E2=80=98ax88796c_pr=
obe=E2=80=99:
drivers/net/ethernet/asix/ax88796c_main.c:966:32: warning: conversion from =
=E2=80=98long unsigned int=E2=80=99 to =E2=80=98u32=E2=80=99 {aka =E2=80=98=
unsigned int=E2=80=99} changes value from =E2=80=9818446744073709486079=E2=
=80=99 to =E2=80=984294901759=E2=80=99 [-Woverflow]
  966 |  ax_local->mdiobus->phy_mask =3D ~BIT(AX88796C_PHY_ID);
      |                                ^
