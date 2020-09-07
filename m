Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036552602F3
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731246AbgIGRkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:40:04 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55494 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729539AbgIGRjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 13:39:51 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200907173945euoutp01aaf75411d6a1d7f7ab9b6a5e00e6f9b3~ykSBW8TNY2577725777euoutp01_;
        Mon,  7 Sep 2020 17:39:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200907173945euoutp01aaf75411d6a1d7f7ab9b6a5e00e6f9b3~ykSBW8TNY2577725777euoutp01_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1599500385;
        bh=VyNJ/u2VtqEjabn6KyuSmi5uaCziZpvJDEXoqzvDcKs=;
        h=From:To:Cc:Subject:In-Reply-To:Date:References:From;
        b=fhTHtwKxb0+UhkRwwEHiVbH30/VHDY8ieen0e70Gj4aCz6fRZFCZ+X1Nwuu6eLWnl
         JnBP1TnZHcGBqT4Hs/cYljIBkQ3EJRoGZvoQ7se7DxmBNwTL3m166T5z03TBZYJodl
         ME9z2v+YDV+8fcYQXwmgBVrPrg51/GJxY52TZYjQ=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200907173945eucas1p2ad33692211bad4eaa461ad383cb22b01~ykSBJtC-m2522025220eucas1p2s;
        Mon,  7 Sep 2020 17:39:45 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id DF.56.06456.160765F5; Mon,  7
        Sep 2020 18:39:45 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200907173945eucas1p240c0d7ebff3010a3bf752eaf8e619eb1~ykSAwULvR2522425224eucas1p2e;
        Mon,  7 Sep 2020 17:39:45 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200907173945eusmtrp29637e398b3a7cd5ab312239a81af96e7~ykSAvjof41653916539eusmtrp2o;
        Mon,  7 Sep 2020 17:39:45 +0000 (GMT)
X-AuditID: cbfec7f2-7efff70000001938-12-5f5670612203
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 50.F1.06314.060765F5; Mon,  7
        Sep 2020 18:39:44 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200907173944eusmtip1f2750bb9c1cc1710eb1b2867e0076d65~ykSAh4MHC0361103611eusmtip1N;
        Mon,  7 Sep 2020 17:39:44 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com
Subject: Re: [PATCH 1/3] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
In-Reply-To: <20200825180134.GN2403519@lunn.ch> (Andrew Lunn's message of
        "Tue, 25 Aug 2020 20:01:34 +0200")
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Mon, 07 Sep 2020 19:39:33 +0200
Message-ID: <dleftjwo15qyei.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02SW0wTURCGc7q77UIsWYvKWIkhDZqIkZuoa/AeEqtPGo2CRLHCWgi0kC6I
        8gIqGG2UCohAU0VEEdFyqaSCXJSCaEVaKV5BxChEBEQFTIAQkHVrwts3c/75zz8nh8QkI4SU
        jFEnMhq1Ik4mdMXNrZO2NYqEAxH+6Q6g7T0WjK7KryBogz0dpwtbbASt+zqE0XZ7pYh+Zc4k
        aNPXtwTd+cggpPPtjQLaktuAaGNLj4huvbGEzmhoEW1zk3e+7cDk1Xc/COSmsgtC+YNbqfLa
        mjGBPLO6DMnHTMv3iA65bopi4mJOMBq/LUddo216LUq4fxWdTJvMEqahhmQtciGBCgLHk6e4
        FrmSEqoUQb9hWsQX4wheV7Y7izEEfRlG/P+ITTdKcCyh7iAYMITyom8ISro6MC0iSSHlC0Zj
        KKdZRHnBFev0Pz1GWTDordvKsTu1D4rfvMQ4dqHU0KorQxwvpjZC9UCviGOcWgGF+i4hx2Jq
        AxSP5GA8LwRrQR/Oe6qgwD6MuAxAZZFwOqNTyAcNgUZjs4hndxh8Vu1kT5itLRRwOYFKhZzs
        9fzsRQRmw4RzyWD4aJty+myH/EYd4vVu8P7HQv5eN8g252F8Wwznz0l4tTeU6+qdLlK4NFiK
        eJbD2Y4ujH+qMwiqzLPEZeSln7eOft46+jlbjFoFFY/8+PZqKCkawnjeDOXlP/EbiChDHkwS
        q1IybICaSfZlFSo2Sa30jYxXmdDcz2ubeTZag/44jlkQRSLZAvGv3QciJITiBHtKZUHec05f
        Ku+9QlJcHa9mZIvEO9rbjkjEUYpTKYwmPkKTFMewFrSMxGUe4rU3vx+WUEpFIhPLMAmM5v+p
        gHSRpqGsPHaAnPUMnDru8nkq4fk17EWDNJDpsf8OMy0tQjPoy15rXciQtS56w66a7mBtbOZE
        eKxeFu/TJOoOq3yXvO66OBFqIwea6z81kXXEtwJHUcv+h/3uO1eGj1ck7rZIctPaQhwpuUEz
        2LBqqbL7T4X/wefFpdarXrczH5uVTbUynI1WBPhgGlbxF5h6xLWBAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t/xu7oJBWHxBrue2Ficv3uI2WLjjPWs
        FnPOt7BYzD9yjtWi//FrZovz5zewW1zY1sdqsenxNVaLy7vmsFnMOL+PyeLQ1L2MFmuP3GW3
        OLZAzKJ17xF2Bz6Py9cuMntsWXmTyWPTqk42j81L6j127vjM5NG3ZRWjx+dNcgHsUXo2Rfml
        JakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFWRqZK+nY2Kak5mWWpRfp2CXoZ52Z1MRasmcZY
        0fBzIlsD497yLkZODgkBE4lz/Z9Yuxi5OIQEljJKnN51maWLkQMoISWxcm46RI2wxJ9rXWwQ
        NU8ZJY4vnMoMUsMmoCexdm0ESI2IgILElJN/wOYwC2xjlvi6chITSEJYIFDiwbxT7CA2p0Ce
        xLH+VYwgthBQ74ers1hAbFEBS4ktL+6D1bAIqErMn3WLDcTmFTCXWPxuMjOELShxcuYTsHpm
        gWyJr6ufM09gFJiFJDULSWoW0HnMApoS63fpQ4S1JZYtfM0MYdtKrFv3nmUBI+sqRpHU0uLc
        9NxiQ73ixNzi0rx0veT83E2MwIjdduzn5h2MlzYGH2IU4GBU4uH94BUWL8SaWFZcmXuIUQVo
        zKMNqy8wSrHk5eelKonwOp09HSfEm5JYWZValB9fVJqTWnyI0RTon4nMUqLJ+cAkk1cSb2hq
        aG5haWhubG5sZqEkztshcDBGSCA9sSQ1OzW1ILUIpo+Jg1OqgXGWT9sKxeOr/p31nJ/1MjbK
        esPL8hXeUz/HPHm5qvfKs8vKLYt/H/KzenB+4sJfQWX+37j1l5p8m6e9tnrKtqXHGvjD+0q6
        nz747DbxfMtZo9Wz28xWXry35N32Fdmb71/Y3yctNeVUypKk5DMlp5bxv0ltPFF/4ZXqKg3R
        tjfWYubMswPVny+bosRSnJFoqMVcVJwIAG1E2Hj6AgAA
X-CMS-MailID: 20200907173945eucas1p240c0d7ebff3010a3bf752eaf8e619eb1
X-Msg-Generator: CA
X-RootMTR: 20200907173945eucas1p240c0d7ebff3010a3bf752eaf8e619eb1
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200907173945eucas1p240c0d7ebff3010a3bf752eaf8e619eb1
References: <20200825180134.GN2403519@lunn.ch>
        <CGME20200907173945eucas1p240c0d7ebff3010a3bf752eaf8e619eb1@eucas1p2.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-08-25 wto 20:01>, when Andrew Lunn wrote:

> Hi =C5=81ukasz
>
> It is pretty clear this is a "vendor crap driver".

I can't deny.

> It needs quite a bit more work on it.

I'll be more than happy to take your suggestions.

> On Tue, Aug 25, 2020 at 07:03:09PM +0200, =C5=81ukasz Stelmach wrote:
>> +++ b/drivers/net/ethernet/asix/ax88796c_ioctl.c
>
> This is an odd filename. The ioctl code is wrong anyway, but there is
> a lot more than ioctl in here. I suggest you give it a new name.
>

Sure, any suggestions?

>> @@ -0,0 +1,293 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (c) 2010 ASIX Electronics Corporation
>> + * Copyright (c) 2020 Samsung Electronics Co., Ltd.
>> + *
>> + * ASIX AX88796C SPI Fast Ethernet Linux driver
>> + */
>> +
>> +#include "ax88796c_main.h"
>> +#include "ax88796c_spi.h"
>> +#include "ax88796c_ioctl.h"
>> +
>> +u8 ax88796c_check_power(struct ax88796c_device *ax_local)
>
> bool ?

OK.

It appears, however, that 0 means OK and 1 !OK. Do you think changing to
TRUE and FALSE (or FALSE and TRUE) is required?

>> +{
>> +	struct spi_status ax_status;
>> +
>> +	/* Check media link status first */
>> +	if (netif_carrier_ok(ax_local->ndev) ||
>> +	    (ax_local->ps_level =3D=3D AX_PS_D0)  ||
>> +	    (ax_local->ps_level =3D=3D AX_PS_D1)) {
>> +		return 0;
>> +	}
>> +
>> +	AX_READ_STATUS(&ax_local->ax_spi, &ax_status);
>> +	if (!(ax_status.status & AX_STATUS_READY))
>> +		return 1;
>> +
>> +	return 0;
>> +}
>> +
>> +u8 ax88796c_check_power_and_wake(struct ax88796c_device *ax_local)
>> +{
>> +	struct spi_status ax_status;
>> +	unsigned long start_time;
>> +
>> +	/* Check media link status first */
>> +	if (netif_carrier_ok(ax_local->ndev) ||
>> +	    (ax_local->ps_level =3D=3D AX_PS_D0) ||
>> +	    (ax_local->ps_level =3D=3D AX_PS_D1)) {
>> +		return 0;
>> +	}
>> +
>> +	AX_READ_STATUS(&ax_local->ax_spi, &ax_status);
>> +	if (!(ax_status.status & AX_STATUS_READY)) {
>> +
>> +		/* AX88796C in power saving mode */
>> +		AX_WAKEUP(&ax_local->ax_spi);
>> +
>> +		/* Check status */
>> +		start_time =3D jiffies;
>> +		do {
>> +			if (time_after(jiffies, start_time + HZ/2)) {
>> +				netdev_err(ax_local->ndev,
>> +					"timeout waiting for wakeup"
>> +					" from power saving\n");
>> +				break;
>> +			}
>> +
>> +			AX_READ_STATUS(&ax_local->ax_spi, &ax_status);
>> +
>> +		} while (!(ax_status.status & AX_STATUS_READY));
>
> include/linux/iopoll.h
>

Done. The result seems only slightly more elegant since the generic
read_poll_timeout() needs to be employed.

>
> Can the device itself put itself to sleep? If not, maybe just track
> the power saving state in struct ax88796c_device?
>

Yes, it can. When the cable is unplugged, parts of of the chip enter
power saving mode and the values in registers change.

>> +int ax88796c_mdio_read(struct net_device *ndev, int phy_id, int loc)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	unsigned long start_time;
>> +
>> +	AX_WRITE(&ax_local->ax_spi, MDIOCR_RADDR(loc)
>> +			| MDIOCR_FADDR(phy_id) | MDIOCR_READ, P2_MDIOCR);
>> +
>> +	start_time =3D jiffies;
>> +	while ((AX_READ(&ax_local->ax_spi, P2_MDIOCR) & MDIOCR_VALID) =3D=3D 0=
) {
>> +		if (time_after(jiffies, start_time + HZ/100))
>> +			return -EBUSY;
>> +	}
>
> Another use case of iopoll.h
>

Done.

>> +	return AX_READ(&ax_local->ax_spi, P2_MDIODR);
>> +}
>> +
>> +void
>> +ax88796c_mdio_write(struct net_device *ndev, int phy_id, int loc, int v=
al)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	unsigned long start_time;
>> +
>> +	AX_WRITE(&ax_local->ax_spi, val, P2_MDIODR);
>> +
>> +	AX_WRITE(&ax_local->ax_spi,
>> +			MDIOCR_RADDR(loc) | MDIOCR_FADDR(phy_id)
>> +			| MDIOCR_WRITE, P2_MDIOCR);
>> +
>> +	start_time =3D jiffies;
>> +	while ((AX_READ(&ax_local->ax_spi, P2_MDIOCR) & MDIOCR_VALID) =3D=3D 0=
) {
>> +		if (time_after(jiffies, start_time + HZ/100))
>> +			return;
>> +	}
>> +
>> +	if (loc =3D=3D MII_ADVERTISE) {
>> +		AX_WRITE(&ax_local->ax_spi, (BMCR_FULLDPLX | BMCR_ANRESTART |
>> +			  BMCR_ANENABLE | BMCR_SPEED100), P2_MDIODR);
>> +		AX_WRITE(&ax_local->ax_spi, (MDIOCR_RADDR(MII_BMCR) |
>> +			  MDIOCR_FADDR(phy_id) | MDIOCR_WRITE),
>> +			  P2_MDIOCR);
>
> Odd. An mdio bus driver should not need to do anything like this.
>
> Humm, please make this is a plain MDIO bus driver, using
> mdiobus_register().
>

The manufacturer says

    The AX88796C integrates on-chip Fast Ethernet MAC and PHY, [=E2=80=A6]

There is a single integrated PHY in this chip and no possiblity to
connect external one. Do you think it makes sense in such case to
introduce the additional layer of abstraction?

>> +
>> +		start_time =3D jiffies;
>> +		while ((AX_READ(&ax_local->ax_spi, P2_MDIOCR)
>> +					& MDIOCR_VALID) =3D=3D 0) {
>> +			if (time_after(jiffies, start_time + HZ/100))
>> +				return;
>> +		}
>> +	}
>> +}
>> +
>
>> +static void ax88796c_get_drvinfo(struct net_device *ndev,
>> +				 struct ethtool_drvinfo *info)
>> +{
>> +	/* Inherit standard device info */
>> +	strncpy(info->driver, DRV_NAME, sizeof(info->driver));
>> +	strncpy(info->version, DRV_VERSION, sizeof(info->version));
>
> verion is pretty much not wanted any more.
>

Removed.

>> +static u32 ax88796c_get_link(struct net_device *ndev)
>> +{
>> +	u32 link;
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	u8 power;
>> +
>> +	down(&ax_local->spi_lock);
>> +	power =3D ax88796c_check_power_and_wake(ax_local);
>> +
>> +	link =3D mii_link_ok(&ax_local->mii);
>> +
>> +	if (power)
>> +		ax88796c_set_power_saving(ax_local, ax_local->ps_level);
>> +	up(&ax_local->spi_lock);
>> +
>> +	return link;
>> +
>> +
>> +}
>
> When you convert to phylib, this will go away.
>

See above (single integrated phy).

>> +static int
>> +ax88796c_get_link_ksettings(struct net_device *ndev,
>> +			    struct ethtool_link_ksettings *cmd)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	u8 power;
>> +
>> +	down(&ax_local->spi_lock);
>
> Please use a mutex, not semaphores.
>

Done.

>> +module_param(comp, int, 0);
>> +MODULE_PARM_DESC(comp, "0=3DNon-Compression Mode, 1=3DCompression Mode"=
);
>> +
>> +module_param(ps_level, int, 0);
>> +MODULE_PARM_DESC(ps_level,
>> +	"Power Saving Level (0:disable 1:level 1 2:level 2)");
>> +
>> +module_param(msg_enable, int, 0);
>> +MODULE_PARM_DESC(msg_enable, "Message mask (see linux/netdevice.h for b=
itmap)");
>> +
>> +static char *macaddr;
>> +module_param(macaddr, charp, 0);
>> +MODULE_PARM_DESC(macaddr, "MAC address");
>
> No Module parameters. You can get the MAC address from DT.

What about systems without DT? Not every bootloader is sophisicated
enough to edit DT before starting kernel. AX88786C is a chip that can be
used in a variety of systems and I'd like to avoid too strong
assumptions.

Of course reading MAC address from DT is a good idea and I will add it.

> msg_enable can be controlled by ethtool.

But it does not work during boot.

>> +MODULE_AUTHOR("ASIX");
>
> Do you expect ASIX to support this?=20

No.

> You probably want to put your name here.

I don't want to be considered as the only author and as far as I can
tell being mentioned as an author does not imply being a
maintainer. Do you think two MODULE_AUTHOR()s be OK?
=20
>> +MODULE_DESCRIPTION("ASIX AX88796C SPI Ethernet driver");
>> +MODULE_LICENSE("GPL");
>> +
>> +static void ax88796c_dump_regs(struct ax88796c_device *ax_local)
>> +{
>> +	struct net_device *ndev =3D ax_local->ndev;
>> +	u8 i, j;
>> +
>> +	netdev_info(ndev,
>> +		"       Page0   Page1   Page2   Page3   "
>> +				"Page4   Page5   Page6   Page7\n");
>> +	for (i =3D 0; i < 0x20; i +=3D 2) {
>> +		netdev_info(ndev, "0x%02x   ", i);
>> +		for (j =3D 0; j < 8; j++) {
>> +			netdev_info(ndev, "0x%04x  ",
>> +				AX_READ(&ax_local->ax_spi, j * 0x20 + i));
>> +		}
>> +		netdev_info(ndev, "\n");
>> +	}
>> +	netdev_info(ndev, "\n");
>
> Please implement ethtool -d, not this.
>

Done.

>> +}
>> +
>> +static void ax88796c_dump_phy_regs(struct ax88796c_device *ax_local)
>> +{
>> +	struct net_device *ndev =3D ax_local->ndev;
>> +	int i;
>> +
>> +	netdev_info(ndev, "Dump PHY registers:\n");
>> +	for (i =3D 0; i < 6; i++) {
>> +		netdev_info(ndev, "  MR%d =3D 0x%04x\n", i,
>> +			ax88796c_mdio_read(ax_local->ndev,
>> +			ax_local->mii.phy_id, i));
>> +	}
>> +}
>> +
>
> Please delete. Let the PHY driver worry about PHY registers.
>

See above (single integrated phy).

>> +static void ax88796c_watchdog(struct ax88796c_device *ax_local)
>> +{
>> +	struct net_device *ndev =3D ax_local->ndev;
>> +	u16 phy_status;
>> +	unsigned long time_to_chk =3D AX88796C_WATCHDOG_PERIOD;
>> +
>> +	if (ax88796c_check_power(ax_local)) {
>> +		mod_timer(&ax_local->watchdog, jiffies + time_to_chk);
>> +		return;
>> +	}
>> +
>> +	ax88796c_set_power_saving(ax_local, AX_PS_D0);
>
> You might want to look at runtime PM for all this power management.
>

This one and the one below, are to manage device's PM state during this
function.

>> +
>> +	phy_status =3D AX_READ(&ax_local->ax_spi, P0_PSCR);
>> +	if (phy_status & PSCR_PHYLINK) {
>> +
>> +		ax_local->w_state =3D ax_nop;
>> +		time_to_chk =3D 0;
>> +
>> +	} else if (!(phy_status & PSCR_PHYCOFF)) {
>> +		/* The ethernet cable has been plugged */
>> +		if (ax_local->w_state =3D=3D chk_cable) {
>> +			if (netif_msg_timer(ax_local))
>> +				netdev_info(ndev, "Cable connected\n");
>> +
>> +			ax_local->w_state =3D chk_link;
>> +			ax_local->w_ticks =3D 0;
>> +		} else {
>> +			if (netif_msg_timer(ax_local))
>> +				netdev_info(ndev, "Check media status\n");
>> +
>> +			if (++ax_local->w_ticks =3D=3D AX88796C_WATCHDOG_RESTART) {
>> +				if (netif_msg_timer(ax_local))
>> +					netdev_info(ndev, "Restart autoneg\n");
>> +				ax88796c_mdio_write(ndev,
>> +					ax_local->mii.phy_id, MII_BMCR,
>> +					(BMCR_SPEED100 | BMCR_ANENABLE |
>> +					BMCR_ANRESTART));
>> +
>> +				if (netif_msg_hw(ax_local))
>> +					ax88796c_dump_phy_regs(ax_local);
>> +				ax_local->w_ticks =3D 0;
>> +			}
>> +		}
>> +	} else {
>> +		if (netif_msg_timer(ax_local))
>> +			netdev_info(ndev, "Check cable status\n");
>> +
>> +		ax_local->w_state =3D chk_cable;
>> +	}
>> +
>> +	ax88796c_set_power_saving(ax_local, ax_local->ps_level);
>> +
>> +	if (time_to_chk)
>> +		mod_timer(&ax_local->watchdog, jiffies + time_to_chk);
>> +}
>
> This is not the normal use of a watchdog in network drivers. The
> normal case is the network stack as asked the driver to do something,
> normally a TX, and the driver has not reported the action has
> completed.  The state of the cable should not make any
> difference. This does not actually appear to do anything useful, like
> kick the hardware to bring it back to life.
>

Maybe it's the naming that is a problem. Yes, it is not a watchdog, but
rather a periodic housekeeping and it kicks hw if it can't negotiate
the connection. The question is: should the settings be reset in such case.

>> +static int ax88796c_soft_reset(struct ax88796c_device *ax_local)
>> +{
>> +	unsigned long start;
>> +	u16 temp;
>> +
>> +	AX_WRITE(&ax_local->ax_spi, PSR_RESET, P0_PSR);
>> +	AX_WRITE(&ax_local->ax_spi, PSR_RESET_CLR, P0_PSR);
>> +
>> +	start =3D jiffies;
>> +	while (!(AX_READ(&ax_local->ax_spi, P0_PSR) & PSR_DEV_READY)) {
>> +		if (time_after(jiffies, start + (160 * HZ / 1000))) {
>> +			dev_err(&ax_local->spi->dev,
>> +				"timeout waiting for reset completion\n");
>> +			return -1;
>> +		}
>> +	}
>
> iopoll.h.=20
>

Done

>> +#if 0
>> +static void ax88796c_set_multicast(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +
>> +	set_bit(EVENT_SET_MULTI, &ax_local->flags);
>> +	queue_work(ax_local->ax_work_queue, &ax_local->ax_work);
>> +}
>> +#endif
>
> We don't allow #if 0 code in mainline.
>

Removed.

>> +	if (netif_msg_pktdata(ax_local)) {
>> +		int loop;
>> +		netdev_info(ndev, "TX packet len %d, total len %d, seq %d\n",
>> +				pkt_len, tx_skb->len, seq_num);
>> +
>> +		netdev_info(ndev, "  Dump SPI Header:\n    ");
>> +		for (loop =3D 0; loop < 4; loop++)
>> +			netdev_info(ndev, "%02x ", *(tx_skb->data + loop));
>> +
>> +		netdev_info(ndev, "\n");
>
> This no longer works as far as i remember. Lines are terminate by
> default even if they don't have a \n.
>
> Please you should not be using netdev_info(). netdev_dbg() please.
>

I changed most netif_msg_*()+netdev_*() to netif_*(), including
netif_dbg() in several places. However, after reading other drivers I
decided to leave this at INFO level. I think this is the way to go,
because this is what user asks for and with dynamic debug enabled users
would have to ask for these in two different places.

>> +static inline void
>> +ax88796c_skb_return(struct ax88796c_device *ax_local, struct sk_buff *s=
kb,
>> +			struct rx_header *rxhdr)
>> +{
>
> No inline functions in C code please.
>

Done.

>> +	struct net_device *ndev =3D ax_local->ndev;
>> +	int status;
>> +
>> +	do {
>> +		if (!(ax_local->checksum & AX_RX_CHECKSUM))
>> +			break;
>> +
>> +		/* checksum error bit is set */
>> +		if ((rxhdr->flags & RX_HDR3_L3_ERR) ||
>> +		    (rxhdr->flags & RX_HDR3_L4_ERR))
>> +			break;
>> +
>> +		if ((rxhdr->flags & RX_HDR3_L4_TYPE_TCP) ||
>> +		    (rxhdr->flags & RX_HDR3_L4_TYPE_UDP)) {
>> +			skb->ip_summed =3D CHECKSUM_UNNECESSARY;
>> +		}
>> +	} while (0);
>
>
> ??
>

if() break; Should I use goto?

>> +
>> +	ax_local->stats.rx_packets++;
>> +	ax_local->stats.rx_bytes +=3D skb->len;
>> +	skb->dev =3D ndev;
>> +
>> +	skb->truesize =3D skb->len + sizeof(struct sk_buff);
>> +	skb->protocol =3D eth_type_trans(skb, ax_local->ndev);
>> +
>> +	if (netif_msg_rx_status(ax_local))
>> +		netdev_info(ndev, "< rx, len %zu, type 0x%x\n",
>> +			skb->len + sizeof(struct ethhdr), skb->protocol);
>> +
>> +	status =3D netif_rx(skb);
>> +	if (status !=3D NET_RX_SUCCESS && netif_msg_rx_err(ax_local))
>> +		netdev_info(ndev, "netif_rx status %d\n", status);
>
> Please go through the driver and use netdev_dbg() where appropriate.
>

Done, partially (see above.)

>> +}
>> +
>> +static void dump_packet(struct net_device *ndev, const char *msg, int l=
en, const char *data)
>> +{
>> +        netdev_printk(KERN_DEBUG, ndev,  DRV_NAME ": %s - packet len:%d=
\n", msg, len);
>> +        print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1,
>> +                        data, len, true);
>> +}
>> +
>> +static void
>> +ax88796c_rx_fixup(struct ax88796c_device *ax_local, struct sk_buff *rx_=
skb)
>> +{
>> +	struct rx_header *rxhdr =3D (struct rx_header *) rx_skb->data;
>> +	struct net_device *ndev =3D ax_local->ndev;
>> +	u16 len;
>> +
>> +	be16_to_cpus(&rxhdr->flags_len);
>> +	be16_to_cpus(&rxhdr->seq_lenbar);
>> +	be16_to_cpus(&rxhdr->flags);
>> +
>> +	if ((((short)rxhdr->flags_len) & RX_HDR1_PKT_LEN) !=3D
>> +			 (~((short)rxhdr->seq_lenbar) & 0x7FF)) {
>> +		if (netif_msg_rx_err(ax_local)) {
>> +			int i;
>> +			netdev_err(ndev, "Header error\n");
>> +			//netdev_err(ndev, "Dump received frame\n");
>> +			/* for (i =3D 0; i < rx_skb->len; i++) { */
>> +			/* 	netdev_err(ndev, "%02x ", */
>> +			/* 			*(rx_skb->data + i)); */
>> +			/* 	if (((i + 1) % 16) =3D=3D 0) */
>> +			/* 		netdev_err(ndev, "\n"); */
>> +			/* } */
>
> No commented out code.
>

Removed.

>> +			dump_packet(ndev, __func__, rx_skb->len, rx_skb->data);
>
> and this is questionable. I can understand it while writing a driver,
> but once it works, this is the sort of thing you remove.
>

Removed.

>> +		}
>> +		ax_local->stats.rx_frame_errors++;
>> +		kfree_skb(rx_skb);
>> +		return;
>> +	}
>> +
>> +	if ((rxhdr->flags_len & RX_HDR1_MII_ERR) ||
>> +			(rxhdr->flags_len & RX_HDR1_CRC_ERR)) {
>> +		if (netif_msg_rx_err(ax_local))
>> +			netdev_err(ndev, "CRC or MII error\n");
>> +
>> +		ax_local->stats.rx_crc_errors++;
>> +		kfree_skb(rx_skb);
>> +		return;
>> +	}
>> +
>> +	len =3D rxhdr->flags_len & RX_HDR1_PKT_LEN;
>> +	if (netif_msg_pktdata(ax_local)) {
>> +		int loop;
>> +		netdev_info(ndev, "RX data, total len %d, packet len %d\n",
>> +				rx_skb->len, len);
>> +
>> +		netdev_info(ndev, "  Dump RX packet header:\n    ");
>> +		for (loop =3D 0; loop < sizeof(*rxhdr); loop++)
>> +			netdev_info(ndev, "%02x ", *(rx_skb->data + loop));
>> +
>> +		netdev_info(ndev, "\n  Dump RX packet:");
>> +		for (loop =3D 0; loop < len; loop++) {
>> +			if ((loop % 16) =3D=3D 0)
>> +				netdev_info(ndev, "\n    ");
>> +			netdev_info(ndev, "%02x ",
>> +				*(rx_skb->data + loop + sizeof(*rxhdr)));
>> +		}
>> +		netdev_info(ndev, "\n");
>> +	}
>> +
>> +	skb_pull(rx_skb, sizeof(*rxhdr));
>> +	__pskb_trim(rx_skb, len);
>> +
>> +	return ax88796c_skb_return(ax_local, rx_skb, rxhdr);
>> +}
>
>> +void ax88796c_phy_init(struct ax88796c_device *ax_local)
>> +{
>> +	u16 advertise =3D ADVERTISE_ALL | ADVERTISE_CSMA | ADVERTISE_PAUSE_CAP;
>> +
>> +	/* Setup LED mode */
>> +	AX_WRITE(&ax_local->ax_spi,
>> +		  (LCR_LED0_EN | LCR_LED0_DUPLEX | LCR_LED1_EN |
>> +		   LCR_LED1_100MODE), P2_LCR0);
>> +	AX_WRITE(&ax_local->ax_spi,
>> +		  (AX_READ(&ax_local->ax_spi, P2_LCR1) & LCR_LED2_MASK) |
>> +		   LCR_LED2_EN | LCR_LED2_LINK, P2_LCR1);
>> +
>> +	/* Enable PHY auto-polling */
>> +	AX_WRITE(&ax_local->ax_spi,
>> +		  POOLCR_PHYID(ax_local->mii.phy_id) | POOLCR_POLL_EN |
>> +		  POOLCR_POLL_FLOWCTRL | POOLCR_POLL_BMCR, P2_POOLCR);
>
> What exactly does PHY polling do? Generally, you don't want the MAC
> touching the PHY, because it can upset the PHY driver.
>

See above (single integrated phy).

>> +
>> +	ax88796c_mdio_write(ax_local->ndev,
>> +			ax_local->mii.phy_id, MII_ADVERTISE, advertise);
>> +
>> +	ax88796c_mdio_write(ax_local->ndev, ax_local->mii.phy_id, MII_BMCR,
>> +			BMCR_SPEED100 | BMCR_ANENABLE | BMCR_ANRESTART);
>> +}
>> +
>
> I stopped reviewing here.

It took a while to work through it all. Thank you very much for your
effort.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl9WcFUACgkQsK4enJil
gBAMiwf/aH/tq9YLXFE27neHlLrNhd2Fvc+BYdy+/hRzLiy0I9BUh5i7lSvwXdsX
Z208nHkFfkHY0O8bYyCe8CyuurxU5tXVqC0cmfKWfUEagBzfHwmgrpTtlO6Xq1rX
PrvLWnJuU9WtT4tAvWPsNgxbfyA1IcQgr1iNuYNDAnQLwwiNnK+Rcxg/blSN5TTL
OFm+tiImS/3JVHDkN05kZDB6QbwSUOFLfrR2K4L1MSjQS2P7cfc2hEhOiySzhQ7Q
W2spfXneHp+fAL9OEv41fKcgpml60+d78dNbGmyfHCERIJTAUhKkj8xg39AUOZnM
lkSbbQrQrgTTw1SOIT33Y/WrrYAjjw==
=hI4p
-----END PGP SIGNATURE-----
--=-=-=--
