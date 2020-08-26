Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210AB2532A8
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 17:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgHZO7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 10:59:44 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49886 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbgHZO7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 10:59:39 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200826145930euoutp0111696dba0d2b67df200130888757b407~u2WrTUPbT0117001170euoutp01S;
        Wed, 26 Aug 2020 14:59:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200826145930euoutp0111696dba0d2b67df200130888757b407~u2WrTUPbT0117001170euoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1598453970;
        bh=vTySaiNS2NYSJV/ycjtGFlY8eLr3GMq1+Gs/Hnxavcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJAoyGPL826d+VHXso8Auj306hbZr0jr2Tn0NnGLZ+oWdaG8wy8G/OI91DmZdJHq9
         vfqhYPtdjPlBMn9gluVwV04OEAS+Hcp3W3IfNyHrpp+EMAXsbMgZNppAEo+VRU640R
         Da8P5dyhRWi/1KXcJazX+94SVGIn13dKHGYRlSMA=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200826145930eucas1p294bdf625f096606bf680f3e52eb667fd~u2Wq63W4D3140831408eucas1p24;
        Wed, 26 Aug 2020 14:59:30 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id FC.42.06318.2D8764F5; Wed, 26
        Aug 2020 15:59:30 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200826145929eucas1p1367c260edb8fa003869de1da527039c0~u2WqcuUCm1616716167eucas1p1j;
        Wed, 26 Aug 2020 14:59:29 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200826145929eusmtrp2527af5a1da295236786b8dbc92cdb3ac~u2Wqb07cC2236922369eusmtrp2V;
        Wed, 26 Aug 2020 14:59:29 +0000 (GMT)
X-AuditID: cbfec7f5-38bff700000018ae-c6-5f4678d20b21
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 83.90.06314.1D8764F5; Wed, 26
        Aug 2020 15:59:29 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200826145929eusmtip15075acf880f5f14cc4c067c3d3029612~u2WqLvbCD1778717787eusmtip1I;
        Wed, 26 Aug 2020 14:59:29 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, m.szyprowski@samsung.com,
        b.zolnierkie@samsung.com
Subject: Re: [PATCH 1/3] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Date:   Wed, 26 Aug 2020 16:59:09 +0200
In-Reply-To: <20200825184413.GA2693@kozik-lap> (Krzysztof Kozlowski's
        message of "Tue, 25 Aug 2020 20:44:13 +0200")
Message-ID: <dleftja6yhv4g2.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA01SZ0xTYRTN1zf6qJY8SpUrqNFaI6iA2+eMEtNUg0kjMTEoo8oLorSY1qL4
        B0zAURGkiiJWGaIyZLQ0jRo1sSJDlApEcBEUByqusKoIYttXE/+dc757zz335qMw0QfCn0pQ
        72c1amWihBTg1vpf9uC2g7KYBUcz+Ywpr5pgjPZ0nCmoayGY7Ld9GGO31/CZJ9YsgjG/7SCY
        9ltGksmz3+Uxttw7iKms6+Iz9YWTmYw7dfx1Qnl7Rysmt5Q958nN5cdJeW1JqjzLUo7kA+bp
        CjJSsDqOTUxIZjWha2MFu7u/DZL7SnKIg8Z3nXgasmXjeuRFAb0EWntLkB4JKBFdiuC5yYFz
        ZBCBoeYowZEBBD1fx/n/WixtRpJ7uIag97Ue40gvgjNFFiehKJIOgcrKba4GMR0EnWMOtxNG
        52PQanG4h/vSEXD56SPMhXF6NuSUWdzYi9ZBZ1uFu0ZIL4fh6zfdeBK9Aiwfu/mc7gNN59+5
        dYxWwXn7F8SlG+NDWaYvhzeA0fSb5LAvfG6weDaYCuM3C3iunECnwmnDMlc2oDMRWI0/PYdZ
        Ba9aRjy966F25CHJ1XvDs68+3FhvMFjPYZwshGNHRFy1FKqyb3tc/OHk51JPMjk0WUs9pz6M
        oKZfj59CM/L/2yb/v23ynbaY83TVt0I5eR5cLerDOLwGqqq+44WIKEd+rE6rime1i9XsgRCt
        UqXVqeNDdiWpzMj545r/NAzdQHdHd9oQTSHJRGFgjCxGRCiTtSkqG5I6nXpqKp4gf1ydpGYl
        YmHY4+ZokTBOmXKI1STFaHSJrNaGAihc4idcXPwpSkTHK/eze1l2H6v598qjvPzT0IUpm+1b
        hlOp+k2OrfNlS4bau1729Xe+WlTYg4VujJg1Ou3qhCjpnpnPGndFnmgJb/xxKjbopcJ875Jj
        y5eVZ5NVxnAmdqzpSsZ2Q1PkqDTrwYsEmcK3OPf+jrBJt31w7wZVbffSdKsiMCACVQ2JdaUX
        A+ckVASniN+vMUXP088yv5Hg2t3KhXMxjVb5F/x2l4B5AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t/xu7oXK9ziDe4sU7XYOGM9q8Wc8y0s
        FvOPnGO16H/8mtni/PkN7BYXtvWxWmx6fI3V4vKuOWwWM87vY7I4NHUvo8XaI3fZLY4tELNo
        3XuE3YHX4/K1i8weW1beZPLYtKqTzWPzknqPvi2rGD0+b5ILYIvSsynKLy1JVcjILy6xVYo2
        tDDSM7S00DMysdQzNDaPtTIyVdK3s0lJzcksSy3St0vQy7j/7gtbwZKJrBVznlxnaWA81M/S
        xcjJISFgIrHl0hw2EFtIYCmjxIGG2C5GDqC4lMTKuekQJcISf651QZU8ZZTYscALpIRNQE9i
        7doIkLCIgKbE9b/fWbsYuTiYBfqYJe4u/MkIkhAWCJR4MO8UO0SvrsSjQz/B5rAIqEpMXLmF
        GcTmFCiVWHd+Ntg5vALmEt/W7ASzRQUsJba8uM8OEReUODnzCVicWSBb4uvq58wTGAVmIUnN
        QpKaBXQeM9BN63fpQ4S1JZYtfM0MYdtKrFv3nmUBI+sqRpHU0uLc9NxiQ73ixNzi0rx0veT8
        3E2MwNjcduzn5h2MlzYGH2IU4GBU4uHViHeLF2JNLCuuzD3EqAI05tGG1RcYpVjy8vNSlUR4
        nc6ejhPiTUmsrEotyo8vKs1JLT7EaAr050RmKdHkfGA6ySuJNzQ1NLewNDQ3Njc2s1AS5+0Q
        OBgjJJCeWJKanZpakFoE08fEwSnVwBjUcT5GunT6a7M4hXXSPy+7s/jx85zqUBfRuqpcXSW1
        3PNPfnDh2VsKVgbM0lpHlLu7/k+JnDIhdP+tZXz/rmjOWLU0zVj2xoEdDzelsu9zefVF4cbG
        jDf2ZV+FLO/d0S7nFWleJqtQEfn6q/6CSQbL9jsvarK/4X3m2/E7Z55W3Gbe5pURla7EUpyR
        aKjFXFScCACSzYLE7wIAAA==
X-CMS-MailID: 20200826145929eucas1p1367c260edb8fa003869de1da527039c0
X-Msg-Generator: CA
X-RootMTR: 20200826145929eucas1p1367c260edb8fa003869de1da527039c0
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200826145929eucas1p1367c260edb8fa003869de1da527039c0
References: <20200825184413.GA2693@kozik-lap>
        <CGME20200826145929eucas1p1367c260edb8fa003869de1da527039c0@eucas1p1.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-08-25 wto 20:44>, when Krzysztof Kozlowski wrote:
> On Tue, Aug 25, 2020 at 07:03:09PM +0200, =C5=81ukasz Stelmach wrote:
>> ASIX AX88796[1] is a versatile ethernet adapter chip, that can be
>> connected to a CPU with a 8/16-bit bus or with an SPI. This driver
>> supports SPI connection.
>>=20
>> The driver has been ported from the vendor kernel for ARTIK5[2]
>> boards. Several changes were made to adapt it to the current kernel
>> which include:
>>=20
>> + updated DT configuration,
>> + clock configuration moved to DT,
>> + new timer, ethtool and gpio APIs
>> + dev_* instead of pr_* and custom printk() wrappers.
>>=20
>> [1] https://protect2.fireeye.com/v1/url?k=3D074e9e9d-5a9dc212-074f15d2-0=
cc47a31ce52-0f896a3d08738907&q=3D1&e=3Dbcaebfa2-4f00-46b6-a35d-096f39710f47=
&u=3Dhttps%3A%2F%2Fwww.asix.com.tw%2Fproducts.php%3Fop%3DpItemdetail%26PIte=
mID%3D104%3B65%3B86%26PLine%3D65
>> [2] https://protect2.fireeye.com/v1/url?k=3D553869ec-08eb3563-5539e2a3-0=
cc47a31ce52-fc42424019c6fd8f&q=3D1&e=3Dbcaebfa2-4f00-46b6-a35d-096f39710f47=
&u=3Dhttps%3A%2F%2Fgit.tizen.org%2Fcgit%2Fprofile%2Fcommon%2Fplatform%2Fker=
nel%2Flinux-3.10-artik%2F
>>=20
>> The other ax88796 driver is for NE2000 compatible AX88796L chip. These
>> chips are not compatible. Hence, two separate drivers are required.
>
> Hi,
>
> Thanks for the driver, nice work. Few comments below.
>

Thank you. I fixed most problems and asked some question where I didn't
understand.

>>=20
>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>> ---
>>  drivers/net/ethernet/Kconfig               |    1 +
>>  drivers/net/ethernet/Makefile              |    1 +
>>  drivers/net/ethernet/asix/Kconfig          |   20 +
>>  drivers/net/ethernet/asix/Makefile         |    6 +
>>  drivers/net/ethernet/asix/ax88796c_ioctl.c |  293 +++++
>>  drivers/net/ethernet/asix/ax88796c_ioctl.h |   21 +
>>  drivers/net/ethernet/asix/ax88796c_main.c  | 1373 ++++++++++++++++++++
>>  drivers/net/ethernet/asix/ax88796c_main.h  |  596 +++++++++
>>  drivers/net/ethernet/asix/ax88796c_spi.c   |  103 ++
>>  drivers/net/ethernet/asix/ax88796c_spi.h   |   67 +
>>  10 files changed, 2481 insertions(+)
>>  create mode 100644 drivers/net/ethernet/asix/Kconfig
>>  create mode 100644 drivers/net/ethernet/asix/Makefile
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.c
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.h
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_main.c
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_main.h
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.c
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.h
>>=20
>> diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
>> index de50e8b9e656..f3b218e45ea5 100644
>> --- a/drivers/net/ethernet/Kconfig
>> +++ b/drivers/net/ethernet/Kconfig
>> @@ -32,6 +32,7 @@ source "drivers/net/ethernet/apm/Kconfig"
>>  source "drivers/net/ethernet/apple/Kconfig"
>>  source "drivers/net/ethernet/aquantia/Kconfig"
>>  source "drivers/net/ethernet/arc/Kconfig"
>> +source "drivers/net/ethernet/asix/Kconfig"
>>  source "drivers/net/ethernet/atheros/Kconfig"
>>  source "drivers/net/ethernet/aurora/Kconfig"
>>  source "drivers/net/ethernet/broadcom/Kconfig"
>> diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefi=
le
>> index f8f38dcb5f8a..9eb368d93607 100644
>> --- a/drivers/net/ethernet/Makefile
>> +++ b/drivers/net/ethernet/Makefile
>> @@ -18,6 +18,7 @@ obj-$(CONFIG_NET_XGENE) +=3D apm/
>>  obj-$(CONFIG_NET_VENDOR_APPLE) +=3D apple/
>>  obj-$(CONFIG_NET_VENDOR_AQUANTIA) +=3D aquantia/
>>  obj-$(CONFIG_NET_VENDOR_ARC) +=3D arc/
>> +obj-$(CONFIG_NET_VENDOR_ASIX) +=3D asix/
>>  obj-$(CONFIG_NET_VENDOR_ATHEROS) +=3D atheros/
>>  obj-$(CONFIG_NET_VENDOR_AURORA) +=3D aurora/
>>  obj-$(CONFIG_NET_VENDOR_CADENCE) +=3D cadence/
>> diff --git a/drivers/net/ethernet/asix/Kconfig b/drivers/net/ethernet/as=
ix/Kconfig
>> new file mode 100644
>> index 000000000000..4b127a4a659a
>> --- /dev/null
>> +++ b/drivers/net/ethernet/asix/Kconfig
>> @@ -0,0 +1,20 @@
>> +#
>> +# Asix network device configuration
>> +#
>> +
>> +config NET_VENDOR_ASIX
>> +	bool "Asix devices"
>> +	depends on SPI
>> +	help
>> +	  If you have a network (Ethernet) interface based on a chip from ASIX=
, say Y
>
> Looks like too long, did it pass checkpatch?

Yes? Let me try again. Yes, this one passed, but I missed a few other
problems. Thank you.

>> +
>> +if NET_VENDOR_ASIX
>> +
>> +config SPI_AX88796C
>> +	tristate "Asix AX88796C-SPI support"
>> +	depends on SPI
>> +	depends on GPIOLIB
>> +	help
>> +	  Say Y here if you intend to attach a Asix AX88796C as SPI mode
>> +
>> +endif # NET_VENDOR_ASIX
>> diff --git a/drivers/net/ethernet/asix/Makefile b/drivers/net/ethernet/a=
six/Makefile
>> new file mode 100644
>> index 000000000000..0bfbbb042634
>> --- /dev/null
>> +++ b/drivers/net/ethernet/asix/Makefile
>> @@ -0,0 +1,6 @@
>> +#
>> +# Makefile for the Asix network device drivers.
>> +#
>> +
>> +obj-$(CONFIG_SPI_AX88796C) +=3D ax88796c.o
>> +ax88796c-y :=3D ax88796c_main.o ax88796c_ioctl.o ax88796c_spi.o
>> diff --git a/drivers/net/ethernet/asix/ax88796c_ioctl.c b/drivers/net/et=
hernet/asix/ax88796c_ioctl.c
>> new file mode 100644
>> index 000000000000..eba361e2a8b7
>> --- /dev/null
>> +++ b/drivers/net/ethernet/asix/ax88796c_ioctl.c
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
> Looks here like pointer to const. Unless it is because of
> AX_READ_STATUS() which cannot take const?

It can. I changed other stuff in ax88796c_spi.[hc] to const too.

>> +{
>
> Please put file-scope definitions first, so this should go to the end.

I don't understand.

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
>
> This looks buggy... AX_READ_STATUS can fail, without reporting an error.
> There is no error handling. What will be the value of ax_status? Sure,
> some stack-protector-GCC-plugins might initialize it to 0, but that's
> not a good design.
>
> There is no error handling of all SPI functions so entire driver works
> because of luck... if there is any error in the middle of some work, it
> won't spot it.

You are right this requires more work. I will do it.

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
>> +
>> +		ax88796c_set_power_saving(ax_local, AX_PS_D0);
>> +
>> +		return 1;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +void ax88796c_set_power_saving(struct ax88796c_device *ax_local, u8 ps_=
level)
>> +{
>> +	u16 pmm;
>> +
>> +	if (ps_level =3D=3D AX_PS_D1)
>> +		pmm =3D PSCR_PS_D1;
>> +	else if (ps_level =3D=3D AX_PS_D2)
>> +		pmm =3D PSCR_PS_D2;
>> +	else
>> +		pmm =3D PSCR_PS_D0;
>> +
>> +	AX_WRITE(&ax_local->ax_spi, (AX_READ(&ax_local->ax_spi, P0_PSCR)
>> +				      & PSCR_PS_MASK) | pmm, P0_PSCR);
>> +}
>> +
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
>> +
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
>> +void ax88796c_set_csums(struct ax88796c_device *ax_local)
>> +{
>> +	if (ax_local->checksum & AX_RX_CHECKSUM) {
>> +		AX_WRITE(&ax_local->ax_spi, COERCR0_DEFAULT, P4_COERCR0);
>> +		AX_WRITE(&ax_local->ax_spi, COERCR1_DEFAULT, P4_COERCR1);
>> +	} else {
>> +		AX_WRITE(&ax_local->ax_spi, 0, P4_COERCR0);
>> +		AX_WRITE(&ax_local->ax_spi, 0, P4_COERCR1);
>> +	}
>> +
>> +	if (ax_local->checksum & AX_TX_CHECKSUM) {
>> +		AX_WRITE(&ax_local->ax_spi, COETCR0_DEFAULT, P4_COETCR0);
>> +		AX_WRITE(&ax_local->ax_spi, COETCR1_TXPPPE, P4_COETCR1);
>> +	} else {
>> +		AX_WRITE(&ax_local->ax_spi, 0, P4_COETCR0);
>> +		AX_WRITE(&ax_local->ax_spi, 0, P4_COETCR1);
>> +	}
>> +}
>> +
>> +static void ax88796c_get_drvinfo(struct net_device *ndev,
>> +				 struct ethtool_drvinfo *info)
>> +{
>> +	/* Inherit standard device info */
>> +	strncpy(info->driver, DRV_NAME, sizeof(info->driver));
>> +	strncpy(info->version, DRV_VERSION, sizeof(info->version));
>> +}
>> +
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
>
> Empty lines.

Fixed.

>> +}
>> +
>> +static u32 ax88796c_get_msglevel(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	return ax_local->msg_enable;
>> +}
>> +
>> +static void ax88796c_set_msglevel(struct net_device *ndev, u32 level)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	ax_local->msg_enable =3D level;
>> +}
>> +
>> +
>
> One line break.

Fixed.

>> +static int
>> +ax88796c_get_link_ksettings(struct net_device *ndev,
>> +			    struct ethtool_link_ksettings *cmd)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	u8 power;
>> +
>> +	down(&ax_local->spi_lock);
>> +	power =3D ax88796c_check_power_and_wake(ax_local);
>> +
>> +	mii_ethtool_get_link_ksettings(&ax_local->mii, cmd);
>> +
>> +	if (power)
>> +		ax88796c_set_power_saving(ax_local, ax_local->ps_level);
>> +	up(&ax_local->spi_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +static int
>> +ax88796c_set_link_ksettings(struct net_device *ndev,
>> +			    const struct ethtool_link_ksettings *cmd)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	u8 power;
>> +
>> +	down(&ax_local->spi_lock);
>> +	power =3D ax88796c_check_power_and_wake(ax_local);
>> +
>> +	mii_ethtool_set_link_ksettings(&ax_local->mii, cmd);
>> +
>> +	if (power)
>> +		ax88796c_set_power_saving(ax_local, ax_local->ps_level);
>> +	up(&ax_local->spi_lock);
>> +	return 0;
>> +
>
> Line before return, not after.
>

Fixed.

>> +}
>> +
>> +static int ax88796c_nway_reset(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	int ret;
>> +	u8 power;
>> +
>> +	down(&ax_local->spi_lock);
>> +	power =3D ax88796c_check_power_and_wake(ax_local);
>> +
>> +	ret =3D mii_nway_restart(&ax_local->mii);
>> +
>> +	if (power)
>> +		ax88796c_set_power_saving(ax_local, ax_local->ps_level);
>> +	up(&ax_local->spi_lock);
>> +	return ret;
>> +}
>> +
>> +static u32 ax88796c_ethtool_getmsglevel(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	return ax_local->msg_enable;
>> +}
>> +
>> +static void ax88796c_ethtool_setmsglevel(struct net_device *ndev, u32 l=
evel)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	ax_local->msg_enable =3D level;
>> +}
>> +
>> +struct ethtool_ops ax88796c_ethtool_ops =3D {
>> +	.get_drvinfo		=3D ax88796c_get_drvinfo,
>> +	.get_link		=3D ax88796c_get_link,
>> +	.get_msglevel		=3D ax88796c_get_msglevel,
>> +	.set_msglevel		=3D ax88796c_set_msglevel,
>> +	.get_link_ksettings	=3D ax88796c_get_link_ksettings,
>> +	.set_link_ksettings	=3D ax88796c_set_link_ksettings,
>> +	.nway_reset		=3D ax88796c_nway_reset,
>> +	.get_msglevel		=3D ax88796c_ethtool_getmsglevel,
>> +	.set_msglevel		=3D ax88796c_ethtool_setmsglevel,
>> +};
>> +
>> +int ax88796c_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	int ret;
>> +	u8 power;
>> +
>> +	down(&ax_local->spi_lock);
>> +	power =3D ax88796c_check_power_and_wake(ax_local);
>> +
>> +	ret =3D generic_mii_ioctl(&ax_local->mii, if_mii(ifr), cmd, NULL);
>> +
>> +	if (power)
>> +		ax88796c_set_power_saving(ax_local, ax_local->ps_level);
>> +	up(&ax_local->spi_lock);
>> +
>> +	return ret;
>> +}
>> +
>> diff --git a/drivers/net/ethernet/asix/ax88796c_ioctl.h b/drivers/net/et=
hernet/asix/ax88796c_ioctl.h
>> new file mode 100644
>> index 000000000000..bafd573bd813
>> --- /dev/null
>> +++ b/drivers/net/ethernet/asix/ax88796c_ioctl.h
>> @@ -0,0 +1,21 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (c) 2010 ASIX Electronics Corporation
>> + *
>> + * ASIX AX88796C SPI Fast Ethernet Linux driver
>> + */
>> +
>> +#ifndef _AX88796C_IOCTL_H
>> +#define _AX88796C_IOCTL_H
>> +
>> +extern struct ethtool_ops ax88796c_ethtool_ops;
>> +
>> +u8 ax88796c_check_power(struct ax88796c_device *ax_local);
>> +u8 ax88796c_check_power_and_wake(struct ax88796c_device *ax_local);
>> +void ax88796c_set_power_saving(struct ax88796c_device *ax_local, u8 ps_=
level);
>> +int ax88796c_mdio_read(struct net_device *dev, int phy_id, int loc);
>> +void ax88796c_mdio_write(struct net_device *dev, int phy_id, int loc, i=
nt val);
>> +void ax88796c_set_csums(struct ax88796c_device *ax_local);
>> +int ax88796c_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
>> +
>> +#endif
>> diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/eth=
ernet/asix/ax88796c_main.c
>> new file mode 100644
>> index 000000000000..c28cfb931319
>> --- /dev/null
>> +++ b/drivers/net/ethernet/asix/ax88796c_main.c
>> @@ -0,0 +1,1373 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (c) 2010 ASIX Electronics Corporation
>> + * Copyright (c) 2020 Samsung Electronics Co., Ltd.
>> + *
>> + * ASIX AX88796C SPI Fast Ethernet Linux driver
>> + */
>> +
>> +#include "ax88796c_main.h"
>> +#include "ax88796c_ioctl.h"
>> +
>> +static int comp;
>> +static int ps_level =3D AX_PS_D0;
>> +static int msg_enable =3D NETIF_MSG_PROBE |
>> +			NETIF_MSG_LINK |
>> +			/* NETIF_MSG_TIMER | */
>> +			NETIF_MSG_RX_ERR |
>> +			NETIF_MSG_TX_ERR |
>> +			/* NETIF_MSG_TX_QUEUED | */
>> +			/* NETIF_MSG_INTR | */
>> +			/* NETIF_MSG_TX_DONE | */
>> +			/* NETIF_MSG_RX_STATUS | */
>> +			/* NETIF_MSG_PKTDATA | */
>> +			/* NETIF_MSG_HW | */
>> +			NETIF_MSG_WOL;
>> +
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
> I think MAC address as param is not accepted in mainline...
>

$ git grep MODULE_PARM_DESC\(macaddr -- drivers/net | wc -l
6

>> +
>
>> +MODULE_AUTHOR("ASIX");
>> +MODULE_DESCRIPTION("ASIX AX88796C SPI Ethernet driver");
>> +MODULE_LICENSE("GPL");
>
> These three usually go to the end of file.
>

Fixed.

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
>> +
>> +static void ax88796c_watchdog_timer(struct timer_list *t)
>> +{
>> +	struct ax88796c_device *ax_local =3D from_timer(ax_local, t, watchdog);
>> +	//struct net_device *ndev =3D ax_local->ndev;
>
> Clean up.
>

Done.

>> +
>> +	set_bit(EVENT_WATCHDOG, &ax_local->flags);
>> +	queue_work(ax_local->ax_work_queue, &ax_local->ax_work);
>> +}
>> +
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
>> +
>> +	temp =3D AX_READ(&ax_local->ax_spi, P4_SPICR);
>> +	if (ax_local->capabilities & AX_CAP_COMP) {
>> +		AX_WRITE(&ax_local->ax_spi,
>> +			(temp | SPICR_RCEN | SPICR_QCEN), P4_SPICR);
>> +		ax_local->ax_spi.comp =3D 1;
>> +	} else {
>> +		AX_WRITE(&ax_local->ax_spi,
>> +			(temp & ~(SPICR_RCEN | SPICR_QCEN)), P4_SPICR);
>> +		ax_local->ax_spi.comp =3D 0;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int ax88796c_reload_eeprom(struct ax88796c_device *ax_local)
>> +{
>> +	unsigned long start;
>> +
>> +	AX_WRITE(&ax_local->ax_spi, EECR_RELOAD, P3_EECR);
>> +
>> +	start =3D jiffies;
>> +	while (!(AX_READ(&ax_local->ax_spi, P0_PSR) & PSR_DEV_READY)) {
>> +		if (time_after(jiffies, start + (2 * HZ / 100))) {
>> +			dev_err(&ax_local->spi->dev,
>> +				"timeout waiting for reload eeprom\n");
>> +			return -1;
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void ax88796c_set_hw_multicast(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	u16 rx_ctl =3D RXCR_AB;
>> +	int mc_count =3D netdev_mc_count(ndev);
>> +
>> +	memset(ax_local->multi_filter, 0, AX_MCAST_FILTER_SIZE);
>> +
>> +	if (ndev->flags & IFF_PROMISC) {
>> +		rx_ctl |=3D RXCR_PRO;
>> +
>> +	} else if (ndev->flags & IFF_ALLMULTI
>> +		   || mc_count > AX_MAX_MCAST) {
>> +		rx_ctl |=3D RXCR_AMALL;
>> +
>> +	} else if (mc_count =3D=3D 0) {
>> +		/* just broadcast and directed */
>> +	} else {
>> +		u32 crc_bits;
>> +		int i;
>> +		struct netdev_hw_addr *ha;
>> +		netdev_for_each_mc_addr(ha, ndev) {
>> +			crc_bits =3D ether_crc(ETH_ALEN, ha->addr);
>> +			ax_local->multi_filter[crc_bits >> 29] |=3D
>> +						(1 << ((crc_bits >> 26) & 7));
>> +		}
>> +
>> +		for (i =3D 0; i < 4; i++) {
>> +			AX_WRITE(&ax_local->ax_spi,
>> +				  ((ax_local->multi_filter[i*2+1] << 8) |
>> +				  ax_local->multi_filter[i*2]), P3_MFAR(i));
>> +
>> +		}
>> +	}
>> +
>> +	AX_WRITE(&ax_local->ax_spi, rx_ctl, P2_RXCR);
>> +
>
> No need for empty line.
>

Fixed.

>> +}
>> +
>> +#if 0
>
> Please comment why it is commented out.
>

Always has been (-; This is how it came from the vendor I missed it when
I focused on making things work. I will investigate it and either
uncomment or remove it.

>> +static void ax88796c_set_multicast(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +
>> +	set_bit(EVENT_SET_MULTI, &ax_local->flags);
>> +	queue_work(ax_local->ax_work_queue, &ax_local->ax_work);
>> +}
>> +#endif
>> +
>> +static void ax88796c_set_mac_addr(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +
>> +	AX_WRITE(&ax_local->ax_spi, ((u16)(ndev->dev_addr[4] << 8) |
>> +			(u16)ndev->dev_addr[5]), P3_MACASR0);
>> +	AX_WRITE(&ax_local->ax_spi, ((u16)(ndev->dev_addr[2] << 8) |
>> +			(u16)ndev->dev_addr[3]), P3_MACASR1);
>> +	AX_WRITE(&ax_local->ax_spi, ((u16)(ndev->dev_addr[0] << 8) |
>> +			(u16)ndev->dev_addr[1]), P3_MACASR2);
>> +}
>> +
>> +static int ax88796c_set_mac_address(struct net_device *ndev, void *p)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	struct sockaddr *addr =3D p;
>> +
>> +	if (!is_valid_ether_addr(addr->sa_data))
>> +		return -EADDRNOTAVAIL;
>> +
>> +	memcpy(ndev->dev_addr, addr->sa_data, ndev->addr_len);
>> +
>> +	down(&ax_local->spi_lock);
>> +
>> +	ax88796c_set_mac_addr(ndev);
>> +
>> +	up(&ax_local->spi_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +static int ax88796c_load_mac_addr(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	u16 temp;
>> +
>> +	/* Read the MAC address from AX88796C */
>> +	temp =3D AX_READ(&ax_local->ax_spi, P3_MACASR0);
>> +	ndev->dev_addr[5] =3D (u8)temp;
>> +	ndev->dev_addr[4] =3D (u8)(temp >> 8);
>> +
>> +	temp =3D AX_READ(&ax_local->ax_spi, P3_MACASR1);
>> +	ndev->dev_addr[3] =3D (u8)temp;
>> +	ndev->dev_addr[2] =3D (u8)(temp >> 8);
>> +
>> +	temp =3D AX_READ(&ax_local->ax_spi, P3_MACASR2);
>> +	ndev->dev_addr[1] =3D (u8)temp;
>> +	ndev->dev_addr[0] =3D (u8)(temp >> 8);
>> +
>> +	/* Supported for no EEPROM */
>> +	if (!is_valid_ether_addr(ndev->dev_addr)) {
>> +		if (macaddr && mac_pton(macaddr, ndev->dev_addr))
>> +			return 0;
>> +
>> +		if (netif_msg_probe(ax_local))
>> +			dev_info(&ax_local->spi->dev, "Use random MAC address\n");
>> +
>> +		random_ether_addr(ndev->dev_addr);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void ax88796c_proc_tx_hdr(struct tx_pkt_info *info, u8 ip_summed)
>> +{
>> +	u16 pkt_len_bar =3D (~info->pkt_len & TX_HDR_SOP_PKTLENBAR);
>> +
>> +	/* Prepare SOP header */
>> +	info->sop.flags_len =3D info->pkt_len |
>> +			(ip_summed =3D=3D CHECKSUM_NONE ? TX_HDR_SOP_DICF : 0);
>> +
>> +	info->sop.seq_lenbar =3D ((info->seq_num << 11) & TX_HDR_SOP_SEQNUM)
>> +				| pkt_len_bar;
>> +	cpu_to_be16s(&info->sop.flags_len);
>> +	cpu_to_be16s(&info->sop.seq_lenbar);
>> +
>> +	/* Prepare Segment header */
>> +	info->seg.flags_seqnum_seglen =3D TX_HDR_SEG_FS | TX_HDR_SEG_LS
>> +						| info->pkt_len;
>> +
>> +	info->seg.eo_so_seglenbar =3D pkt_len_bar;
>> +
>> +	cpu_to_be16s(&info->seg.flags_seqnum_seglen);
>> +	cpu_to_be16s(&info->seg.eo_so_seglenbar);
>> +
>> +	/* Prepare EOP header */
>> +	info->eop.seq_len =3D ((info->seq_num << 11) &
>> +			     TX_HDR_EOP_SEQNUM) | info->pkt_len;
>> +	info->eop.seqbar_lenbar =3D ((~info->seq_num << 11) &
>> +				   TX_HDR_EOP_SEQNUMBAR) | pkt_len_bar;
>> +
>> +	cpu_to_be16s(&info->eop.seq_len);
>> +	cpu_to_be16s(&info->eop.seqbar_lenbar);
>> +}
>> +
>> +static int
>> +ax88796c_check_free_pages(struct ax88796c_device *ax_local, u8 need_pag=
es)
>> +{
>> +	u8 free_pages;
>> +	u16 tmp;
>> +
>> +	free_pages =3D AX_READ(&ax_local->ax_spi, P0_TFBFCR) & TX_FREEBUF_MASK;
>> +	if (free_pages < need_pages) {
>> +		/* schedule free page interrupt */
>> +		tmp =3D AX_READ(&ax_local->ax_spi, P0_TFBFCR)
>> +				& TFBFCR_SCHE_FREE_PAGE;
>> +		AX_WRITE(&ax_local->ax_spi, tmp | TFBFCR_TX_PAGE_SET |
>> +				TFBFCR_SET_FREE_PAGE(need_pages),
>> +				P0_TFBFCR);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static struct sk_buff *
>> +ax88796c_tx_fixup(struct net_device *ndev, struct sk_buff_head *q)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	struct sk_buff *skb, *tx_skb;
>> +	struct tx_pkt_info *info;
>> +	struct skb_data *entry;
>> +	int headroom;
>> +	int tailroom;
>> +	u8 need_pages;
>> +	u16 tol_len, pkt_len;
>> +	u8 padlen, seq_num;
>> +	u8 spi_len =3D ax_local->ax_spi.comp ? 1 : 4;
>> +
>> +	if (skb_queue_empty(q))
>> +		return NULL;
>> +
>> +	skb =3D skb_peek(q);
>> +	pkt_len =3D skb->len;
>> +	need_pages =3D (pkt_len + TX_OVERHEAD + 127) >> 7;
>> +	if (ax88796c_check_free_pages(ax_local, need_pages) !=3D 0)
>> +		return NULL;
>> +
>> +	headroom =3D skb_headroom(skb);
>> +	tailroom =3D skb_tailroom(skb);
>> +	padlen =3D ((pkt_len + 3) & 0x7FC) - pkt_len;
>> +	tol_len =3D ((pkt_len + 3) & 0x7FC) +
>> +			TX_OVERHEAD + TX_EOP_SIZE + spi_len;
>> +	seq_num =3D ++ax_local->seq_num & 0x1F;
>> +
>> +	info =3D (struct tx_pkt_info *) skb->cb;
>> +	info->pkt_len =3D pkt_len;
>> +
>> +	if ((!skb_cloned(skb)) &&
>> +	    (headroom >=3D (TX_OVERHEAD + spi_len)) &&
>> +	    (tailroom >=3D (padlen + TX_EOP_SIZE))) {
>> +
>> +		info->seq_num =3D seq_num;
>> +		ax88796c_proc_tx_hdr(info, skb->ip_summed);
>> +
>> +		/* SOP and SEG header */
>> +		memcpy(skb_push(skb, TX_OVERHEAD), &info->sop, TX_OVERHEAD);
>> +
>> +		/* Write SPI TXQ header */
>> +		memcpy(skb_push(skb, spi_len), tx_cmd_buf, spi_len);
>> +
>> +		/* Make 32-bit aligment */
>> +		skb_put(skb, padlen);
>> +
>> +		/* EOP header */
>> +		memcpy(skb_put(skb, TX_EOP_SIZE), &info->eop, TX_EOP_SIZE);
>> +
>> +		tx_skb =3D skb;
>> +		skb_unlink(skb, q);
>> +
>> +	} else {
>> +
>> +		tx_skb =3D alloc_skb(tol_len, GFP_KERNEL);
>> +		if (!tx_skb)
>> +			return NULL;
>> +
>> +		/* Write SPI TXQ header */
>> +		memcpy(skb_put(tx_skb, spi_len), tx_cmd_buf, spi_len);
>> +
>> +		info->seq_num =3D seq_num;
>> +		ax88796c_proc_tx_hdr(info, skb->ip_summed);
>> +
>> +		/* SOP and SEG header */
>> +		memcpy(skb_put(tx_skb, TX_OVERHEAD),
>> +				&info->sop, TX_OVERHEAD);
>> +
>> +		/* Packet */
>> +		memcpy(skb_put(tx_skb, ((pkt_len + 3) & 0xFFFC)),
>> +				skb->data, pkt_len);
>> +
>> +		/* EOP header */
>> +		memcpy(skb_put(tx_skb, TX_EOP_SIZE),
>> +				&info->eop, TX_EOP_SIZE);
>> +
>> +		skb_unlink(skb, q);
>> +		dev_kfree_skb(skb);
>> +	}
>> +
>> +	entry =3D (struct skb_data *) tx_skb->cb;
>> +	memset(entry, 0, sizeof(*entry));
>> +	entry->len =3D pkt_len;
>> +
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
>> +
>> +		netdev_info(ndev, "  Dump TX SOP:\n    ");
>> +		for (loop =3D 0; loop < TX_OVERHEAD; loop++)
>> +			netdev_info(ndev, "%02x ", *(tx_skb->data + 4 + loop));
>> +
>> +		netdev_info(ndev, "\n");
>> +
>> +		netdev_info(ndev, "  Dump TX packet:");
>> +		for (loop =3D TX_OVERHEAD + 4;
>> +		     loop < (tx_skb->len - TX_EOP_SIZE); loop++) {
>> +			if (((loop + 8) % 16) =3D=3D 0)
>> +				netdev_info(ndev, "\n    ");
>> +			netdev_info(ndev, "%02x ", *(tx_skb->data + loop));
>> +		}
>> +		netdev_info(ndev, "\n");
>> +
>> +		netdev_info(ndev, "  Dump TX EOP:\n    %02x %02x %02x %02x\n",
>> +			*(tx_skb->data + tx_skb->len - 4),
>> +			*(tx_skb->data + tx_skb->len - 3),
>> +			*(tx_skb->data + tx_skb->len - 2),
>> +			*(tx_skb->data + tx_skb->len - 1));
>> +	}
>> +
>> +	return tx_skb;
>> +}
>> +
>> +static int ax88796c_hard_xmit(struct ax88796c_device *ax_local)
>> +{
>> +	struct sk_buff *tx_skb;
>> +	struct skb_data *entry;
>> +
>> +	tx_skb =3D ax88796c_tx_fixup(ax_local->ndev, &ax_local->tx_wait_q);
>> +
>> +	if (!tx_skb)
>> +		return 0;
>> +
>> +	entry =3D (struct skb_data *)tx_skb->cb;
>> +
>> +	AX_WRITE(&ax_local->ax_spi,
>> +			(TSNR_TXB_START | TSNR_PKT_CNT(1)), P0_TSNR);
>> +
>> +	axspi_write_txq(&ax_local->ax_spi, tx_skb->data, tx_skb->len);
>> +
>> +	if (((AX_READ(&ax_local->ax_spi, P0_TSNR) & TXNR_TXB_IDLE) =3D=3D 0) ||
>> +	    ((ISR_TXERR & AX_READ(&ax_local->ax_spi, P0_ISR)) !=3D 0)) {
>> +
>> +		/* Ack tx error int */
>> +		AX_WRITE(&ax_local->ax_spi, ISR_TXERR, P0_ISR);
>> +
>> +		ax_local->stats.tx_dropped++;
>> +
>> +		if (netif_msg_tx_err(ax_local))
>> +			netdev_err(ax_local->ndev,
>> +				"TX FIFO error, re-initialize the TX bridge\n");
>> +
>> +		/* Reinitial tx bridge */
>> +		AX_WRITE(&ax_local->ax_spi, TXNR_TXB_REINIT |
>> +			AX_READ(&ax_local->ax_spi, P0_TSNR), P0_TSNR);
>> +		ax_local->seq_num =3D 0;
>> +	} else {
>> +		ax_local->stats.tx_packets++;
>> +		ax_local->stats.tx_bytes +=3D entry->len;
>> +	}
>> +
>> +	entry->state =3D tx_done;
>> +	dev_kfree_skb(tx_skb);
>> +
>> +	return 1;
>> +}
>> +
>> +static int
>> +ax88796c_start_xmit(struct sk_buff *skb, struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +
>> +	skb_queue_tail(&ax_local->tx_wait_q, skb);
>> +	if (skb_queue_len(&ax_local->tx_wait_q) > TX_QUEUE_HIGH_WATER) {
>> +		if (netif_msg_tx_queued(ax_local))
>> +			netdev_err(ndev, "Too much TX packets in queue %d\n",
>> +					skb_queue_len(&ax_local->tx_wait_q));
>> +
>> +		netif_stop_queue(ndev);
>> +	}
>> +
>> +	set_bit(EVENT_TX, &ax_local->flags);
>> +	queue_work(ax_local->ax_work_queue, &ax_local->ax_work);
>> +
>> +	return NETDEV_TX_OK;
>> +
>> +}
>> +
>> +
>> +static inline void
>> +ax88796c_skb_return(struct ax88796c_device *ax_local, struct sk_buff *s=
kb,
>> +			struct rx_header *rxhdr)
>> +{
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
>> +}
>> +
>> +static void dump_packet(struct net_device *ndev, const char *msg, int l=
en, const char *data)
>> +{
>
> Too long lines.
>

Fixed.

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
>> +			dump_packet(ndev, __func__, rx_skb->len, rx_skb->data);
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
>> +
>> +static int ax88796c_receive(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	struct sk_buff *skb;
>> +	struct skb_data *entry;
>> +	u16 w_count, pkt_len;
>> +	u8 pkt_cnt;
>> +
>> +	/* check rx packet and total word count */
>> +	AX_WRITE(&ax_local->ax_spi, AX_READ(&ax_local->ax_spi, P0_RTWCR)
>> +		  | RTWCR_RX_LATCH, P0_RTWCR);
>> +
>> +	pkt_cnt =3D AX_READ(&ax_local->ax_spi, P0_RXBCR2) & RXBCR2_PKT_MASK;
>> +	if (!pkt_cnt)
>> +		return 0;
>> +
>> +	pkt_len =3D AX_READ(&ax_local->ax_spi, P0_RCPHR) & 0x7FF;
>> +
>> +	w_count =3D ((pkt_len + 6 + 3) & 0xFFFC) >> 1;
>> +
>> +	skb =3D alloc_skb((w_count * 2), GFP_KERNEL);
>> +	if (!skb) {
>> +		if (netif_msg_rx_err(ax_local))
>> +			netdev_err(ndev,
>> +				"Couldn't allocate a sk_buff of size %d\n",
>> +				w_count * 2);
>> +
>> +		AX_WRITE(&ax_local->ax_spi, RXBCR1_RXB_DISCARD, P0_RXBCR1);
>> +		return 0;
>> +	}
>> +	entry =3D (struct skb_data *) skb->cb;
>> +
>> +	AX_WRITE(&ax_local->ax_spi, RXBCR1_RXB_START | w_count, P0_RXBCR1);
>> +
>> +	axspi_read_rxq(&ax_local->ax_spi,
>> +			skb_put(skb, w_count * 2), skb->len);
>> +
>> +	/* Check if rx bridge is idle */
>> +	if ((AX_READ(&ax_local->ax_spi, P0_RXBCR2) & RXBCR2_RXB_IDLE) =3D=3D 0=
) {
>> +
>> +		if (netif_msg_rx_err(ax_local))
>> +			netdev_err(ndev, "Rx Bridge is not idle\n");
>> +		AX_WRITE(&ax_local->ax_spi, RXBCR2_RXB_REINIT, P0_RXBCR2);
>> +
>> +		entry->state =3D rx_err;
>> +
>> +	} else {
>> +
>> +		entry->state =3D rx_done;
>> +	}
>> +
>> +	AX_WRITE(&ax_local->ax_spi, ISR_RXPKT, P0_ISR);
>> +
>> +	ax88796c_rx_fixup(ax_local, skb);
>> +
>> +	return 1;
>> +}
>> +
>> +static void ax88796c_check_media(struct ax88796c_device *ax_local)
>> +{
>> +	struct net_device *ndev =3D ax_local->ndev;
>> +	u16 bmsr, bmcr;
>> +
>> +	if (netif_msg_hw(ax_local))
>> +		ax88796c_dump_phy_regs(ax_local);
>> +
>> +	bmsr =3D ax88796c_mdio_read(ndev,
>> +			ax_local->mii.phy_id, MII_BMSR);
>> +
>> +	if (!(bmsr & BMSR_LSTATUS) && netif_carrier_ok(ndev)) {
>> +
>> +		netif_carrier_off(ndev);
>> +		if (netif_msg_link(ax_local))
>> +			netdev_info(ndev, "link down\n");
>> +
>> +		ax_local->w_state =3D chk_cable;
>> +		mod_timer(&ax_local->watchdog,
>> +				jiffies + AX88796C_WATCHDOG_PERIOD);
>> +
>> +	} else if ((bmsr & BMSR_LSTATUS) &&
>> +		  !netif_carrier_ok(ndev)) {
>> +		bmcr =3D ax88796c_mdio_read(ndev,
>> +				ax_local->mii.phy_id, MII_BMCR);
>> +		if (netif_msg_link(ax_local))
>> +			netdev_info(ndev, "link up, %sMbps, %s-duplex\n",
>> +				(bmcr & BMCR_SPEED100) ? "100" : "10",
>> +				(bmcr & BMCR_FULLDPLX) ? "full" : "half");
>> +
>> +		netif_carrier_on(ndev);
>> +	}
>> +
>> +	return;
>> +}
>> +
>> +static int ax88796c_process_isr(struct ax88796c_device *ax_local)
>> +{
>> +	u16 isr;
>> +	u8 done =3D 0;
>> +	struct net_device *ndev =3D ax_local->ndev;
>> +
>> +	isr =3D AX_READ(&ax_local->ax_spi, P0_ISR);
>> +	AX_WRITE(&ax_local->ax_spi, isr, P0_ISR);
>> +
>> +	if (netif_msg_intr(ax_local))
>> +		netdev_info(ndev, "  ISR 0x%04x\n", isr);
>> +
>> +	if (isr & ISR_TXERR) {
>> +		if (netif_msg_intr(ax_local))
>> +			netdev_info(ndev, "  TXERR interrupt\n");
>> +		AX_WRITE(&ax_local->ax_spi, TXNR_TXB_REINIT, P0_TSNR);
>> +		ax_local->seq_num =3D 0x1f;
>> +	}
>> +
>> +	if (isr & ISR_TXPAGES) {
>> +
>> +		if (netif_msg_intr(ax_local))
>> +			netdev_info(ndev, "  TXPAGES interrupt\n");
>> +
>> +		set_bit(EVENT_TX, &ax_local->flags);
>> +	}
>> +
>> +	if (isr & ISR_LINK) {
>> +
>> +		if (netif_msg_intr(ax_local))
>> +			netdev_info(ndev, "  Link change interrupt\n");
>> +
>> +		ax88796c_check_media(ax_local);
>> +	}
>> +
>> +	if (isr & ISR_RXPKT) {
>> +
>> +		if (netif_msg_intr(ax_local))
>> +			netdev_info(ndev, "  RX interrupt\n");
>> +
>> +		done =3D ax88796c_receive(ax_local->ndev);
>> +	}
>> +
>> +	return done;
>> +}
>> +
>> +static irqreturn_t ax88796c_interrupt(int irq, void *dev_instance)
>> +{
>> +	struct net_device *ndev =3D dev_instance;
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +
>> +	if (ndev =3D=3D NULL) {
>> +		pr_err("irq %d for unknown device.\n", irq);
>> +		return IRQ_RETVAL(0);
>> +	}
>> +
>> +	disable_irq_nosync(irq);
>> +
>> +	if (netif_msg_intr(ax_local))
>> +		netdev_info(ndev, "Interrupt occurred\n");
>> +
>> +	set_bit(EVENT_INTR, &ax_local->flags);
>> +	queue_work(ax_local->ax_work_queue, &ax_local->ax_work);
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +
>
> Only one line
>

Fixed.

>> +static void ax88796c_work(struct work_struct *work)
>> +{
>> +	struct ax88796c_device *ax_local =3D
>> +			container_of(work, struct ax88796c_device, ax_work);
>> +	u8 power =3D 0;
>> +
>> +	down(&ax_local->spi_lock);
>> +
>> +	if (test_bit(EVENT_WATCHDOG, &ax_local->flags)) {
>> +
>> +		ax88796c_watchdog(ax_local);
>> +
>> +		clear_bit(EVENT_WATCHDOG, &ax_local->flags);
>> +	}
>> +
>> +	if (test_bit(EVENT_SET_MULTI, &ax_local->flags)) {
>> +
>> +		power =3D ax88796c_check_power_and_wake(ax_local);
>> +
>> +		ax88796c_set_hw_multicast(ax_local->ndev);
>> +		clear_bit(EVENT_SET_MULTI, &ax_local->flags);
>> +	}
>> +
>> +	if (test_bit(EVENT_INTR, &ax_local->flags)) {
>> +
>> +		power =3D ax88796c_check_power_and_wake(ax_local);
>> +
>> +		AX_WRITE(&ax_local->ax_spi, IMR_MASKALL, P0_IMR);
>> +
>> +		while (1) {
>> +			if (!ax88796c_process_isr(ax_local))
>> +				break;
>> +		}
>> +
>> +		clear_bit(EVENT_INTR, &ax_local->flags);
>> +
>> +		AX_WRITE(&ax_local->ax_spi, IMR_DEFAULT, P0_IMR);
>> +
>> +		enable_irq(ax_local->ndev->irq);
>> +	}
>> +
>> +	if (test_bit(EVENT_TX, &ax_local->flags)) {
>> +
>> +		power =3D ax88796c_check_power_and_wake(ax_local);
>> +
>> +		while (skb_queue_len(&ax_local->tx_wait_q)) {
>> +			if (!ax88796c_hard_xmit(ax_local))
>> +				break;
>> +		}
>> +
>> +		clear_bit(EVENT_TX, &ax_local->flags);
>> +
>> +		if (netif_queue_stopped(ax_local->ndev) &&
>> +		    (skb_queue_len(&ax_local->tx_wait_q) < TX_QUEUE_LOW_WATER))
>> +			netif_wake_queue(ax_local->ndev);
>> +	}
>> +
>> +	if (power)
>> +		ax88796c_set_power_saving(ax_local, ax_local->ps_level);
>> +
>> +	up(&ax_local->spi_lock);
>> +}
>> +
>> +static struct net_device_stats *ax88796c_get_stats(struct net_device *n=
dev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	return &ax_local->stats;
>> +}
>> +
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
>> +
>> +	ax88796c_mdio_write(ax_local->ndev,
>> +			ax_local->mii.phy_id, MII_ADVERTISE, advertise);
>> +
>> +	ax88796c_mdio_write(ax_local->ndev, ax_local->mii.phy_id, MII_BMCR,
>> +			BMCR_SPEED100 | BMCR_ANENABLE | BMCR_ANRESTART);
>> +}
>> +
>> +static int
>> +ax88796c_open(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	int ret;
>> +	u8 power;
>> +	unsigned long irq_flag =3D IRQF_SHARED;
>> +
>> +	netif_carrier_off(ax_local->ndev);
>> +
>> +	down(&ax_local->spi_lock);
>> +
>> +	power =3D ax88796c_check_power_and_wake(ax_local);
>> +
>> +	ret =3D ax88796c_soft_reset(ax_local);
>> +	if (ret < 0) {
>> +		return -ENODEV;
>> +	}
>> +
>> +	ret =3D request_irq(ndev->irq, ax88796c_interrupt,
>> +			irq_flag, ndev->name, ndev);
>> +	if (ret) {
>> +		netdev_err(ndev, "unable to get IRQ %d (errno=3D%d).\n",
>> +				ndev->irq, ret);
>> +		return -ENXIO;
>> +	}
>> +
>> +	ax_local->seq_num =3D 0x1f;
>> +
>> +	ax88796c_set_mac_addr(ndev);
>> +	ax88796c_set_csums(ax_local);
>> +
>> +	/* Disable stuffing packet */
>> +	AX_WRITE(&ax_local->ax_spi,
>> +		  AX_READ(&ax_local->ax_spi, P1_RXBSPCR)
>> +		  & ~RXBSPCR_STUF_ENABLE, P1_RXBSPCR);
>> +
>> +	/* Enable RX packet process */
>> +	AX_WRITE(&ax_local->ax_spi, RPPER_RXEN, P1_RPPER);
>> +
>> +	AX_WRITE(&ax_local->ax_spi, AX_READ(&ax_local->ax_spi, P0_FER)
>> +		  | FER_RXEN | FER_TXEN | FER_BSWAP | FER_IRQ_PULL, P0_FER);
>> +
>> +	ax88796c_phy_init(ax_local);
>> +
>> +	netif_start_queue(ndev);
>> +
>> +	AX_WRITE(&ax_local->ax_spi, IMR_DEFAULT, P0_IMR);
>> +
>> +	if (netif_msg_hw(ax_local)) {
>> +		netdev_info(ndev,
>> +			"Dump all MAC registers after initialization:\n");
>> +		ax88796c_dump_regs(ax_local);
>> +		ax88796c_dump_phy_regs(ax_local);
>> +	}
>> +
>> +	if (power)
>> +		ax88796c_set_power_saving(ax_local, ax_local->ps_level);
>> +
>> +	spi_message_init(&ax_local->ax_spi.rx_msg);
>> +
>> +	up(&ax_local->spi_lock);
>> +
>> +	timer_setup(&ax_local->watchdog, ax88796c_watchdog_timer, 0);
>> +	/* init_timer(&ax_local->watchdog); */
>> +	/* ax_local->watchdog.function =3D &ax88796c_watchdog_timer; */
>> +	/* ax_local->watchdog.data =3D (unsigned long) ndev; */
>
> I guess it's a development code.
>

Removed. This was an old timer/watchdog API.

>> +	ax_local->watchdog.expires =3D jiffies + AX88796C_WATCHDOG_PERIOD;
>> +	ax_local->w_state =3D chk_cable;
>> +	ax_local->w_ticks =3D 0;
>> +
>> +	add_timer(&ax_local->watchdog);
>> +
>> +	return 0;
>> +}
>> +
>> +static void ax88796c_free_skb_queue(struct sk_buff_head *q)
>> +{
>> +	struct sk_buff *skb;
>> +
>> +	while (q->qlen) {
>> +		skb =3D skb_dequeue(q);
>> +		kfree_skb(skb);
>> +	}
>> +}
>> +
>> +static int
>> +ax88796c_close(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	u8 power;
>> +
>> +	netif_stop_queue(ndev);
>> +
>> +	del_timer_sync(&ax_local->watchdog);
>> +
>> +	free_irq(ndev->irq, ndev);
>> +
>> +	down(&ax_local->spi_lock);
>> +
>> +	power =3D ax88796c_check_power_and_wake(ax_local);
>> +
>> +	AX_WRITE(&ax_local->ax_spi, IMR_MASKALL, P0_IMR);
>> +	ax88796c_free_skb_queue(&ax_local->tx_wait_q);
>> +
>> +	ax88796c_soft_reset(ax_local);
>> +
>> +	if (power)
>> +		ax88796c_set_power_saving(ax_local, ax_local->ps_level);
>> +
>> +	up(&ax_local->spi_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct net_device_ops ax88796c_netdev_ops =3D {
>> +	.ndo_open		=3D ax88796c_open,
>> +	.ndo_stop		=3D ax88796c_close,
>> +	.ndo_start_xmit		=3D ax88796c_start_xmit,
>> +	.ndo_get_stats		=3D ax88796c_get_stats,
>> +	/* .ndo_set_multicast_list =3D ax88796c_set_multicast, */
>
> Still need a comment.
>

Will do.

>> +	.ndo_do_ioctl		=3D ax88796c_ioctl,
>> +	.ndo_set_mac_address	=3D ax88796c_set_mac_address,
>> +};
>> +
>> +
>> +static int ax88796c_hard_reset(struct ax88796c_device *ax_local)
>> +{
>> +	struct device *dev =3D (struct device*)&ax_local->spi->dev;
>> +	struct gpio_desc *reset_gpio;
>> +
>> +	/* reset info */
>> +	reset_gpio =3D gpiod_get(dev, "reset", 0);
>> +	if (IS_ERR(reset_gpio)) {
>> +		dev_err(dev, "Could not get 'reset' GPIO: %ld", PTR_ERR(reset_gpio));
>> +		return PTR_ERR(reset_gpio);
>> +	}
>> +
>> +	/* set reset */
>> +	gpiod_direction_output(reset_gpio, 1);
>> +	msleep(100);
>> +	gpiod_direction_output(reset_gpio, 0);
>> +	gpiod_put(reset_gpio);
>> +	msleep(10);
>> +
>> +	return 0;
>> +}
>> +
>> +static int ax88796c_probe(struct spi_device *spi)
>> +{
>> +	struct net_device *ndev;
>> +	struct ax88796c_device *ax_local;
>> +	int ret;
>> +	u16 temp;
>> +
>> +	ndev =3D devm_alloc_etherdev(&spi->dev, sizeof(*ax_local));
>> +	if (!ndev) {
>> +		dev_err(&spi->dev, "AX88796C SPI: Could not allocate ethernet device\=
n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	ax_local =3D to_ax88796c_device(ndev);
>> +	memset(ax_local, 0, sizeof(*ax_local));
>> +
>> +	dev_set_drvdata(&spi->dev, ax_local);
>> +	ax_local->spi =3D spi;
>> +	ax_local->ax_spi.spi =3D spi;
>> +
>> +	ndev->irq =3D spi->irq;
>> +
>> +	ax_local->msg_enable =3D  msg_enable;
>
> One space after '=3D'.
>

Fixed.

>> +	if (ps_level > AX_PS_D2 || ps_level < 0)
>> +		ax_local->ps_level =3D 0;
>> +	else
>> +		ax_local->ps_level =3D ps_level;
>> +
>> +	ax_local->capabilities |=3D comp ? AX_CAP_COMP : 0;
>> +
>> +	if (netif_msg_probe(ax_local)) {
>> +		dev_info(&spi->dev, "AX88796C-SPI Configuration:\n");
>> +		dev_info(&spi->dev, "    Compression : %s\n",
>> +			 ax_local->capabilities & AX_CAP_COMP ? "ON" : "OFF");
>> +		dev_info(&spi->dev, "    Power Saving Level: %d\n",
>> +			 ax_local->ps_level);
>> +	}
>> +
>> +	ndev->netdev_ops	=3D &ax88796c_netdev_ops;
>> +	ndev->ethtool_ops	=3D &ax88796c_ethtool_ops;
>
> No spaces before '=3D'.
>

Fixed.

>> +
>> +	ax_local->ndev =3D ndev;
>
> Set all priv-storing-pointers in one place, so next to dev_set_drvdata()
> unless it is chosen by probe() flow on purpose.

Done.

>> +
>> +	/* Initialize MII structure */
>> +	ax_local->mii.dev =3D ndev;
>> +	ax_local->mii.mdio_read =3D ax88796c_mdio_read;
>> +	ax_local->mii.mdio_write =3D ax88796c_mdio_write;
>> +	ax_local->mii.phy_id_mask =3D 0x3f;
>> +	ax_local->mii.reg_num_mask =3D 0x1f;
>> +	ax_local->mii.phy_id =3D 0x10;
>> +
>> +	/* ax88796c gpio reset */
>> +	ax88796c_hard_reset(ax_local);
>> +
>> +	/* Reset AX88796C */
>> +	ret =3D ax88796c_soft_reset(ax_local);
>> +	if (ret < 0) {
>> +		return -ENODEV;
>> +	}
>
> No need for {}.
>

Fixed

>> +
>> +	/* Check board revision */
>> +	temp =3D AX_READ(&ax_local->ax_spi, P2_CRIR);
>> +	if ((temp & 0xF) !=3D 0x0) {
>> +		dev_err(&spi->dev, "spi read failed: %d\n", temp);
>> +		return -ENODEV;
>> +	}
>> +
>> +	temp =3D AX_READ(&ax_local->ax_spi, P0_BOR);
>> +	if (temp =3D=3D 0x1234) {
>> +		ax_local->plat_endian =3D PLAT_LITTLE_ENDIAN;
>> +	} else {
>> +		AX_WRITE(&ax_local->ax_spi, 0xFFFF, P0_BOR);
>> +		ax_local->plat_endian =3D PLAT_BIG_ENDIAN;
>> +	}
>> +
>> +	if (netif_msg_hw(ax_local)) {
>> +		dev_info(&spi->dev,
>> +			 "Dump all MAC registers before initialization:\n");
>> +		ax88796c_dump_regs(ax_local);
>> +		ax88796c_dump_phy_regs(ax_local);
>> +	}
>> +
>> +	/*Reload EEPROM*/
>> +	ax88796c_reload_eeprom(ax_local);
>> +
>> +	ax88796c_load_mac_addr(ndev);
>> +
>> +	if (netif_msg_probe(ax_local))
>> +		dev_info(&spi->dev,
>> +			 "irq %d, MAC addr "
>> +			 "%02X:%02X:%02X:%02X:%02X:%02X\n",
>> +			 ndev->irq,
>> +			 ndev->dev_addr[0], ndev->dev_addr[1],
>> +			 ndev->dev_addr[2], ndev->dev_addr[3],
>> +			 ndev->dev_addr[4], ndev->dev_addr[5]);
>> +
>> +	ax88796c_set_power_saving(ax_local, ax_local->ps_level);
>> +
>> +	INIT_WORK(&ax_local->ax_work, ax88796c_work);
>> +
>> +	ax_local->ax_work_queue =3D
>> +			create_singlethread_workqueue("ax88796c_work");
>> +
>> +	sema_init(&ax_local->spi_lock, 1);
>> +
>> +	skb_queue_head_init(&ax_local->tx_wait_q);
>> +
>> +	ndev->features |=3D NETIF_F_HW_CSUM;
>> +	ax_local->checksum =3D AX_RX_CHECKSUM | AX_TX_CHECKSUM;
>> +	ndev->hard_header_len +=3D (TX_OVERHEAD + 4);
>> +
>> +	ret =3D register_netdev(ndev);
>> +	if (!ret) {
>> +		if (netif_msg_probe(ax_local))
>> +			netdev_info(ndev, "%s %s registered\n",
>> +				    dev_driver_string(&spi->dev),
>> +				    dev_name(&spi->dev));
>> +		return ret;
>> +	}
>
> That's unusual flow - exit on success early. Follow the kernel pattern
> of "return 0" on success and jumps to common error handling like:
>
> 	ret =3D register_netdev(ndev)
> 	if (ret)
> 		// handle error: maybe dev_err and goto
>=20=09
> 	if (netif_msg_probe())
> 		netdev_info();
>
> 	return 0;
>

Done.

>> +
>> +	dev_err(&spi->dev, "failed to register a network device\n");
>> +	destroy_workqueue(ax_local->ax_work_queue);
>> +
>> +	return ret;
>> +}
>> +
>> +static int
>> +ax88796c_suspend(struct spi_device *spi, pm_message_t mesg)
>> +{
>> +	struct ax88796c_device *ax_local =3D dev_get_drvdata(&spi->dev);
>> +	struct net_device *ndev =3D ax_local->ndev;
>> +	u8 power;
>> +
>> +	if (!ndev || !netif_running(ndev))
>> +		return 0;
>
> !ndev cannot happen (device should not be suspended before end of
> probe). If it can, there is a bug which you should not silently ignore.
>

Removed.

>> +
>> +	netif_device_detach(ndev);
>> +
>> +	netif_stop_queue(ndev);
>> +
>> +	down(&ax_local->spi_lock);
>> +
>> +	power =3D ax88796c_check_power_and_wake(ax_local);
>> +
>> +	AX_WRITE(&ax_local->ax_spi, IMR_MASKALL, P0_IMR);
>> +	ax88796c_free_skb_queue(&ax_local->tx_wait_q);
>> +
>> +	if (ax_local->wol) {
>> +
>> +		AX_WRITE(&ax_local->ax_spi, 0, P5_WFTR);
>> +
>> +		if (ax_local->wol & WFCR_LINKCH) {	/* Link change */
>> +
>> +			/* Disable wol power saving in link change mode */
>> +			AX_WRITE(&ax_local->ax_spi,
>> +				  (AX_READ(&ax_local->ax_spi, P0_PSCR)
>> +				  & ~PSCR_WOLPS), P0_PSCR);
>> +
>> +			if (netif_msg_wol(ax_local))
>> +				netdev_info(ndev,
>> +					"Enable link change wakeup\n");
>> +
>> +			AX_WRITE(&ax_local->ax_spi, WFTR_8192MS, P5_WFTR);
>> +		}
>> +		if (ax_local->wol & WFCR_MAGICP) {	/* Magic packet */
>> +			if (netif_msg_wol(ax_local))
>> +				netdev_info(ndev,
>> +					"Enable magic packet wakeup\n");
>> +		}
>> +
>> +		AX_WRITE(&ax_local->ax_spi,
>> +			  ax_local->wol | WFCR_WAKEUP | WFCR_PMEEN, P0_WFCR);
>> +	}
>> +
>> +	if (power)
>> +		ax88796c_set_power_saving(ax_local, ax_local->ps_level);
>> +
>> +	up(&ax_local->spi_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +static int
>> +ax88796c_resume(struct spi_device *spi)
>> +{
>> +	struct ax88796c_device *ax_local =3D dev_get_drvdata(&spi->dev);
>> +	struct net_device *ndev =3D ax_local->ndev;
>> +	u16 pme;
>> +
>> +	down(&ax_local->spi_lock);
>> +
>> +	/* Wakeup AX88796C first */
>> +	ax88796c_check_power_and_wake(ax_local);
>> +	msleep(200);
>> +
>> +	pme =3D AX_READ(&ax_local->ax_spi, P0_WFCR);
>> +	if (ax_local->wol && ~(pme & WFCR_WAITEVENT)) {
>> +
>> +		if (pme & WFCR_LINKCHS) {
>> +			if (netif_msg_wol(ax_local))
>> +				netdev_info(ndev,
>> +					"Wakeuped from link change.\n");
>> +		} else if (pme & WFCR_MAGICPS) {
>> +			if (netif_msg_wol(ax_local))
>> +				netdev_info(ndev,
>> +					"Wakeuped from magic packet.\n");
>> +		}
>> +
>> +		AX_WRITE(&ax_local->ax_spi, WFCR_CLRWAKE, P0_WFCR);
>> +	}
>> +
>> +	netif_device_attach(ndev);
>> +
>> +	/* Initialize all the local variables*/
>> +	ax88796c_soft_reset(ax_local);
>> +
>> +	ax_local->seq_num =3D 0x1f;
>> +
>> +	ax88796c_set_mac_addr(ndev);
>> +	ax88796c_set_csums(ax_local);
>> +
>> +	/* Disable stuffing packet */
>> +	AX_WRITE(&ax_local->ax_spi,
>> +		  AX_READ(&ax_local->ax_spi, P1_RXBSPCR)
>> +		  & ~RXBSPCR_STUF_ENABLE, P1_RXBSPCR);
>> +
>> +	/* Enable RX packet process */
>> +	AX_WRITE(&ax_local->ax_spi, RPPER_RXEN, P1_RPPER);
>> +
>> +	AX_WRITE(&ax_local->ax_spi,
>> +		  AX_READ(&ax_local->ax_spi, P0_FER)
>> +		  | FER_RXEN | FER_TXEN | FER_BSWAP, P0_FER);
>> +
>> +	ax88796c_phy_init(ax_local);
>> +
>> +	AX_WRITE(&ax_local->ax_spi, IMR_DEFAULT, P0_IMR);
>> +
>> +	if (netif_msg_hw(ax_local)) {
>> +		netdev_info(ndev,
>> +			"Dump all MAC registers after initialization:\n");
>> +		ax88796c_dump_regs(ax_local);
>> +		ax88796c_dump_phy_regs(ax_local);
>> +	}
>> +
>> +	ax88796c_set_power_saving(ax_local, ax_local->ps_level);
>> +
>> +	netif_start_queue(ndev);
>> +
>> +	up(&ax_local->spi_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +static int ax88796c_remove(struct spi_device *spi)
>> +{
>> +	struct ax88796c_device *ax_local =3D dev_get_drvdata(&spi->dev);
>> +	struct net_device *ndev =3D ax_local->ndev;
>> +
>> +	if (netif_msg_probe(ax_local))
>> +		netdev_info(ndev, "removing network device %s %s\n",
>> +			    dev_driver_string(&spi->dev),
>> +			    dev_name(&spi->dev));
>> +
>> +	destroy_workqueue(ax_local->ax_work_queue);
>> +
>> +	unregister_netdev(ndev);
>> +
>> +	if (netif_msg_probe(ax_local))
>> +		dev_info(&spi->dev, "device removed\n");
>> +
>> +	return 0;
>> +}
>> +
>> +#ifdef CONFIG_USE_OF
>
> #ifdef should not be needed.
>

Removed.

>> +static const struct of_device_id ax88796c_dt_ids[] =3D {
>> +	{ .compatible =3D "asix,ax88796c" },
>> +	{},
>> +};
>> +MODULE_DEVICE_TABLE(of, ax88796c_dt_ids);
>> +#endif
>> +
>> +static const struct spi_device_id asix_id[] =3D {
>> +	{ "ax88796c", 0 },
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(spi, asix_id);
>> +
>> +static struct spi_driver ax88796c_spi_driver =3D {
>> +	.driver =3D {
>> +		.name =3D DRV_NAME,
>> +		.owner =3D THIS_MODULE,
>
> No need for owner.
>

Removed

>> +#ifdef CONFIG_USE_OF
>> +		.of_match_table =3D of_match_ptr(ax88796c_dt_ids),
>> +#endif
>
> No need for ifdef.
>

Removed

>> +	},
>> +	.probe =3D ax88796c_probe,
>> +	.remove =3D ax88796c_remove,
>> +//	.suspend =3D ax88796c_suspend,
>> +//	.resume =3D ax88796c_resume,
>
> ?

My bad. This is an old PM api that no longer exists. I commented it out
at first and forgot it. I've converted it to the new API.

>> +	.id_table =3D asix_id,
>> +};
>> +
>> +static __init int ax88796c_spi_init(void)
>> +{
>> +	pr_info("Register AX88796C SPI Ethernet Driver.\n");
>
> No, no printing of driver inits. It will bother everyone in the world.
>
> This all should be just module driver, no init/exit.
>

Removed.

>> +	return spi_register_driver(&ax88796c_spi_driver);
>> +}
>> +
>> +static __exit void ax88796c_spi_exit(void)
>> +{
>> +	spi_unregister_driver(&ax88796c_spi_driver);
>> +}
>> +
>> +module_init(ax88796c_spi_init);
>> +module_exit(ax88796c_spi_exit);
>> diff --git a/drivers/net/ethernet/asix/ax88796c_main.h b/drivers/net/eth=
ernet/asix/ax88796c_main.h
>> new file mode 100644
>> index 000000000000..6c61766b1788
>> --- /dev/null
>> +++ b/drivers/net/ethernet/asix/ax88796c_main.h
>> @@ -0,0 +1,596 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (c) 2010 ASIX Electronics Corporation
>> + * Copyright (c) 2020 Samsung Electronics
>> + *
>> + * ASIX AX88796C SPI Fast Ethernet Linux driver
>> + */
>> +
>> +#ifndef _AX88796C_MAIN_H
>> +#define _AX88796C_MAIN_H
>> +
>> +#define pr_fmt(fmt)	"ax88796c: " fmt
>> +
>> +/* INCLUDE FILE DECLARATIONS */
>> +#ifdef CONFIG_USE_OF
>
> No ifdef.
>

Removed

>> +#include <linux/of.h>
>> +#endif
>> +#include <linux/crc32.h>
>> +#include <linux/etherdevice.h>
>> +#include <linux/ethtool.h>
>> +#include <linux/gpio/consumer.h>
>> +#include <linux/init.h>
>> +#include <linux/io.h>
>> +#include <linux/kmod.h>
>> +#include <linux/mii.h>
>> +#include <linux/module.h>
>> +#include <linux/netdevice.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/sched.h>
>> +#include <linux/spi/spi.h>
>> +#include <linux/timer.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/usb.h>
>> +#include <linux/version.h>
>> +#include <linux/workqueue.h>
>
> All of these should be removed except the headers used directly in this
> header.
>

This is "private" header file included in all ax88796c_*.c files and
these are headers required in them. It seems more conveninet to have
them all listed in one place. What is the reason to do otherwise?

>> +
>> +#include <asm/dma.h>
>> +
>> +#include "ax88796c_spi.h"
>> +
>> +/* NAMING CONSTANT AND TYPE DECLARATIONS */
>> +/* These identify the driver base version and may not be removed. */
>> +#define DRV_NAME	"ax88796c"
>> +#define ADP_NAME	"ASIX AX88796C SPI Ethernet Adapter"
>> +#define DRV_VERSION	"1.2.0"
>> +
>> +#define TX_QUEUE_HIGH_WATER		45	/* Tx queue high water mark */
>> +#define TX_QUEUE_LOW_WATER		20	/* Tx queue low water mark */
>> +
>> +#define AX88796C_WATCHDOG_PERIOD	(1 * HZ)
>> +#define AX88796C_WATCHDOG_RESTART	7
>> +
>> +#define TX_OVERHEAD			8
>> +#define TX_EOP_SIZE			4
>> +
>> +#define AX_MCAST_FILTER_SIZE		8
>> +#define AX_MAX_MCAST			64
>> +#define AX_MAX_CLK                      80000000
>> +#define TX_HDR_SOP_DICF			0x8000
>> +#define TX_HDR_SOP_CPHI			0x4000
>> +#define TX_HDR_SOP_INT			0x2000
>> +#define TX_HDR_SOP_MDEQ			0x1000
>> +#define TX_HDR_SOP_PKTLEN		0x07FF
>> +#define TX_HDR_SOP_SEQNUM		0xF800
>> +#define TX_HDR_SOP_PKTLENBAR		0x07FF
>> +
>> +#define TX_HDR_SEG_FS			0x8000
>> +#define TX_HDR_SEG_LS			0x4000
>> +#define TX_HDR_SEG_SEGNUM		0x3800
>> +#define TX_HDR_SEG_SEGLEN		0x0700
>> +#define TX_HDR_SEG_EOFST		0xC000
>> +#define TX_HDR_SEG_SOFST		0x3800
>> +#define TX_HDR_SEG_SEGLENBAR		0x07FF
>> +
>> +#define TX_HDR_EOP_SEQNUM		0xF800
>> +#define TX_HDR_EOP_PKTLEN		0x07FF
>> +#define TX_HDR_EOP_SEQNUMBAR		0xF800
>> +#define TX_HDR_EOP_PKTLENBAR		0x07FF
>> +
>> +/* Rx header fields mask */
>> +#define RX_HDR1_MCBC			0x8000
>> +#define RX_HDR1_STUFF_PKT		0x4000
>> +#define RX_HDR1_MII_ERR			0x2000
>> +#define RX_HDR1_CRC_ERR			0x1000
>> +#define RX_HDR1_PKT_LEN			0x07FF
>> +
>> +#define RX_HDR2_SEQ_NUM			0xF800
>> +#define RX_HDR2_PKT_LEN_BAR		0x7FFF
>> +
>> +#define RX_HDR3_PE			0x8000
>> +#define RX_HDR3_L4_TYPE_TCP		0x1000
>> +#define RX_HDR3_L4_TYPE_UDP		0x0400
>> +#define RX_HDR3_L3_ERR			0x0200
>> +#define RX_HDR3_L4_ERR			0x0100
>> +#define RX_HDR3_PRIORITY(x)		((x) << 4)
>> +#define RX_HDR3_STRIP			0x0008
>> +#define RX_HDR3_VLAN_ID			0x0007
>> +
>> +#define AX_RX_CHECKSUM			1
>> +#define AX_TX_CHECKSUM			2
>> +
>> +enum watchdog_state {
>> +	chk_link =3D 0,
>> +	chk_cable,
>> +	ax_nop,
>> +};
>> +
>> +struct ax88796c_device {
>> +
>> +	struct resource		*addr_res;   /* resources found */
>> +	struct resource		*addr_req;   /* resources requested */
>> +	struct resource		*irq_res;
>> +
>> +	struct spi_device	*spi;
>> +	struct net_device	*ndev;
>> +	struct mii_if_info      mii;
>> +	struct net_device_stats	stats;
>> +
>> +	struct timer_list	watchdog;
>> +	enum watchdog_state	w_state;
>> +	size_t			w_ticks;
>> +
>> +	struct work_struct	ax_work;
>> +	struct workqueue_struct *ax_work_queue;
>> +	struct tasklet_struct	bh;
>> +
>> +	struct semaphore	spi_lock;
>> +
>> +	struct sk_buff_head	tx_wait_q;
>> +
>> +	struct axspi_data	ax_spi;
>> +
>> +	int			msg_enable;
>> +
>> +	u16			seq_num;
>> +
>> +	u16			wol;
>> +
>> +	u8			checksum;
>> +
>> +	u8			multi_filter[AX_MCAST_FILTER_SIZE];
>> +
>> +	unsigned long		capabilities;
>> +		#define AX_CAP_DMA		1
>> +		#define AX_CAP_COMP		2
>> +		#define AX_CAP_BIDIR		4
>> +
>> +	u8			plat_endian;
>> +		#define PLAT_LITTLE_ENDIAN	0
>> +		#define PLAT_BIG_ENDIAN		1
>> +
>> +	unsigned long		flags;
>> +		#define EVENT_INTR		1
>> +		#define EVENT_TX			2
>> +		#define EVENT_SET_MULTI		4
>> +		#define EVENT_WATCHDOG		8
>> +
>> +	u8	ps_level;
>> +		#define AX_PS_D0			0
>> +		#define AX_PS_D1			1
>> +		#define AX_PS_D2			2
>> +
>> +
>> +};
>> +
>> +#define to_ax88796c_device(ndev) ((struct ax88796c_device *)netdev_priv=
(ndev))
>> +
>> +enum skb_state {
>> +	illegal =3D 0,
>> +	tx_done,
>> +	rx_done,
>> +	rx_err,
>> +};
>> +
>> +struct skb_data;
>> +
>> +struct skb_data {
>> +	enum skb_state state;
>> +	struct net_device *ndev;
>> +	struct sk_buff *skb;
>> +	size_t len;
>> +	dma_addr_t phy_addr;
>> +};
>> +
>> +/* A88796C register definition */
>> +	/* Definition of PAGE0 */
>> +#define P0_PSR		(0x00)
>> +	#define PSR_DEV_READY		(1 << 7)
>> +	#define PSR_RESET		(0 << 15)
>> +	#define PSR_RESET_CLR		(1 << 15)
>> +#define P0_BOR		(0x02)
>> +#define P0_FER		(0x04)
>> +	#define FER_IPALM		(1 << 0)
>> +	#define FER_DCRC		(1 << 1)
>> +	#define FER_RH3M		(1 << 2)
>> +	#define FER_HEADERSWAP		(1 << 7)
>> +	#define FER_WSWAP		(1 << 8)
>> +	#define FER_BSWAP		(1 << 9)
>> +	#define FER_INTHI		(1 << 10)
>> +	#define FER_INTLO		(0 << 10)
>> +	#define FER_IRQ_PULL		(1 << 11)
>> +	#define FER_RXEN		(1 << 14)
>> +	#define FER_TXEN		(1 << 15)
>> +#define P0_ISR		(0x06)
>> +	#define ISR_RXPKT		(1 << 0)
>> +	#define ISR_MDQ			(1 << 4)
>> +	#define ISR_TXT			(1 << 5)
>> +	#define ISR_TXPAGES		(1 << 6)
>> +	#define ISR_TXERR		(1 << 8)
>> +	#define ISR_LINK		(1 << 9)
>> +#define P0_IMR		(0x08)
>> +	#define IMR_RXPKT		(1 << 0)
>> +	#define IMR_MDQ			(1 << 4)
>> +	#define IMR_TXT			(1 << 5)
>> +	#define IMR_TXPAGES		(1 << 6)
>> +	#define IMR_TXERR		(1 << 8)
>> +	#define IMR_LINK		(1 << 9)
>> +	#define IMR_MASKALL		(0xFFFF)
>> +	#define IMR_DEFAULT		(IMR_TXERR)
>> +#define P0_WFCR		(0x0A)
>> +	#define WFCR_PMEIND		(1 << 0) /* PME indication */
>> +	#define WFCR_PMETYPE		(1 << 1) /* PME I/O type */
>> +	#define WFCR_PMEPOL		(1 << 2) /* PME polarity */
>> +	#define WFCR_PMERST		(1 << 3) /* Reset PME */
>> +	#define WFCR_SLEEP		(1 << 4) /* Enable sleep mode */
>> +	#define WFCR_WAKEUP		(1 << 5) /* Enable wakeup mode */
>> +	#define WFCR_WAITEVENT		(1 << 6) /* Reserved */
>> +	#define WFCR_CLRWAKE		(1 << 7) /* Clear wakeup */
>> +	#define WFCR_LINKCH		(1 << 8) /* Enable link change */
>> +	#define WFCR_MAGICP		(1 << 9) /* Enable magic packet */
>> +	#define WFCR_WAKEF		(1 << 10) /* Enable wakeup frame */
>> +	#define WFCR_PMEEN		(1 << 11) /* Enable PME pin */
>> +	#define WFCR_LINKCHS		(1 << 12) /* Link change status */
>> +	#define WFCR_MAGICPS		(1 << 13) /* Magic packet status */
>> +	#define WFCR_WAKEFS		(1 << 14) /* Wakeup frame status */
>> +	#define WFCR_PMES		(1 << 15) /* PME pin status */
>> +#define P0_PSCR		(0x0C)
>> +	#define PSCR_PS_MASK		(0xFFF0)
>> +	#define PSCR_PS_D0		(0)
>> +	#define PSCR_PS_D1		(1 << 0)
>> +	#define PSCR_PS_D2		(1 << 1)
>> +	#define PSCR_FPS		(1 << 3) /* Enable fiber mode PS */
>> +	#define PSCR_SWPS		(1 << 4) /* Enable software */
>> +						 /* PS control */
>> +	#define PSCR_WOLPS		(1 << 5) /* Enable WOL PS */
>> +	#define PSCR_SWWOL		(1 << 6) /* Enable software select */
>> +						 /* WOL PS */
>> +	#define PSCR_PHYOSC		(1 << 7) /* Internal PHY OSC control */
>> +	#define PSCR_FOFEF		(1 << 8) /* Force PHY generate FEF */
>> +	#define PSCR_FOF		(1 << 9) /* Force PHY in fiber mode */
>> +	#define PSCR_PHYPD		(1 << 10) /* PHY power down. */
>> +						  /* Active high */
>> +	#define PSCR_PHYRST		(1 << 11) /* PHY reset signal. */
>> +						  /* Active low */
>> +	#define PSCR_PHYCSIL		(1 << 12) /* PHY cable energy detect */
>> +	#define PSCR_PHYCOFF		(1 << 13) /* PHY cable off */
>> +	#define PSCR_PHYLINK		(1 << 14) /* PHY link status */
>> +	#define PSCR_EEPOK		(1 << 15) /* EEPROM load complete */
>> +#define P0_MACCR	(0x0E)
>> +	#define MACCR_RXFC_ENABLE	(1 << 3)
>> +	#define MACCR_RXFC_MASK		0xFFF7
>> +	#define MACCR_TXFC_ENABLE	(1 << 4)
>> +	#define MACCR_TXFC_MASK		0xFFEF
>> +	#define MACCR_PF		(1 << 7)
>> +	#define MACCR_PMM_BITS		8
>> +	#define MACCR_PMM_MASK		(0x1F00)
>> +	#define MACCR_PMM_RESET		(1 << 8)
>> +	#define MACCR_PMM_WAIT		(2 << 8)
>> +	#define MACCR_PMM_READY		(3 << 8)
>> +	#define MACCR_PMM_D1		(4 << 8)
>> +	#define MACCR_PMM_D2		(5 << 8)
>> +	#define MACCR_PMM_WAKE		(7 << 8)
>> +	#define MACCR_PMM_D1_WAKE	(8 << 8)
>> +	#define MACCR_PMM_D2_WAKE	(9 << 8)
>> +	#define MACCR_PMM_SLEEP		(10 << 8)
>> +	#define MACCR_PMM_PHY_RESET	(11 << 8)
>> +	#define MACCR_PMM_SOFT_D1	(16 << 8)
>> +	#define MACCR_PMM_SOFT_D2	(17 << 8)
>> +#define P0_TFBFCR	(0x10)
>> +	#define TFBFCR_SCHE_FREE_PAGE	0xE07F
>> +	#define TFBFCR_FREE_PAGE_BITS	0x07
>> +	#define TFBFCR_FREE_PAGE_LATCH	(1 << 6)
>> +	#define TFBFCR_SET_FREE_PAGE(x)	((x & 0x3F) << TFBFCR_FREE_PAGE_BITS)
>> +	#define TFBFCR_TX_PAGE_SET	(1 << 13)
>> +	#define TFBFCR_MANU_ENTX	(1 << 15)
>> +	#define TX_FREEBUF_MASK		0x003F
>> +	#define TX_DPTSTART		0x4000
>> +
>> +#define P0_TSNR		(0x12)
>> +	#define TXNR_TXB_ERR		(1 << 5)
>> +	#define TXNR_TXB_IDLE		(1 << 6)
>> +	#define TSNR_PKT_CNT(x)		(((x) & 0x3F) << 8)
>> +	#define TXNR_TXB_REINIT		(1 << 14)
>> +	#define TSNR_TXB_START		(1 << 15)
>> +#define P0_RTDPR	(0x14)
>> +#define P0_RXBCR1	(0x16)
>> +	#define RXBCR1_RXB_DISCARD	(1 << 14)
>> +	#define RXBCR1_RXB_START	(1 << 15)
>> +#define P0_RXBCR2	(0x18)
>> +	#define RXBCR2_PKT_MASK		(0xFF)
>> +	#define RXBCR2_RXPC_MASK	(0x7F)
>> +	#define RXBCR2_RXB_READY	(1 << 13)
>> +	#define RXBCR2_RXB_IDLE		(1 << 14)
>> +	#define RXBCR2_RXB_REINIT	(1 << 15)
>> +#define P0_RTWCR	(0x1A)
>> +	#define RTWCR_RXWC_MASK		(0x3FFF)
>> +	#define RTWCR_RX_LATCH		(1 << 15)
>> +#define P0_RCPHR	(0x1C)
>> +
>> +	/* Definition of PAGE1 */
>> +#define P1_RPPER	(0x22)
>> +	#define RPPER_RXEN		(1 << 0)
>> +#define P1_MRCR		(0x28)
>> +#define P1_MDR		(0x2A)
>> +#define P1_RMPR		(0x2C)
>> +#define P1_TMPR		(0x2E)
>> +#define P1_RXBSPCR	(0x30)
>> +	#define RXBSPCR_STUF_WORD_CNT(x)	(((x) & 0x7000) >> 12)
>> +	#define RXBSPCR_STUF_ENABLE		(1 << 15)
>> +#define P1_MCR		(0x32)
>> +	#define MCR_SBP			(1 << 8)
>> +	#define MCR_SM			(1 << 9)
>> +	#define MCR_CRCENLAN		(1 << 11)
>> +	#define MCR_STP			(1 << 12)
>> +	/* Definition of PAGE2 */
>> +#define P2_CIR		(0x42)
>> +#define P2_POOLCR	(0x44)
>> +	#define POOLCR_POLL_EN		(1 << 0)
>> +	#define POOLCR_POLL_FLOWCTRL	(1 << 1)
>> +	#define POOLCR_POLL_BMCR	(1 << 2)
>> +	#define POOLCR_PHYID(x)		((x) << 8)
>> +#define P2_PHYSR	(0x46)
>> +#define P2_MDIODR	(0x48)
>> +#define P2_MDIOCR	(0x4A)
>> +	#define MDIOCR_RADDR(x)		((x) & 0x1F)
>> +	#define MDIOCR_FADDR(x)		(((x) & 0x1F) << 8)
>> +	#define MDIOCR_VALID		(1 << 13)
>> +	#define MDIOCR_READ		(1 << 14)
>> +	#define MDIOCR_WRITE		(1 << 15)
>> +#define P2_LCR0		(0x4C)
>> +	#define LCR_LED0_EN		(1 << 0)
>> +	#define LCR_LED0_100MODE	(1 << 1)
>> +	#define LCR_LED0_DUPLEX		(1 << 2)
>> +	#define LCR_LED0_LINK		(1 << 3)
>> +	#define LCR_LED0_ACT		(1 << 4)
>> +	#define LCR_LED0_COL		(1 << 5)
>> +	#define LCR_LED0_10MODE		(1 << 6)
>> +	#define LCR_LED0_DUPCOL		(1 << 7)
>> +	#define LCR_LED1_EN		(1 << 8)
>> +	#define LCR_LED1_100MODE	(1 << 9)
>> +	#define LCR_LED1_DUPLEX		(1 << 10)
>> +	#define LCR_LED1_LINK		(1 << 11)
>> +	#define LCR_LED1_ACT		(1 << 12)
>> +	#define LCR_LED1_COL		(1 << 13)
>> +	#define LCR_LED1_10MODE		(1 << 14)
>> +	#define LCR_LED1_DUPCOL		(1 << 15)
>> +#define P2_LCR1		(0x4E)
>> +	#define LCR_LED2_MASK		(0xFF00)
>> +	#define LCR_LED2_EN		(1 << 0)
>> +	#define LCR_LED2_100MODE	(1 << 1)
>> +	#define LCR_LED2_DUPLEX		(1 << 2)
>> +	#define LCR_LED2_LINK		(1 << 3)
>> +	#define LCR_LED2_ACT		(1 << 4)
>> +	#define LCR_LED2_COL		(1 << 5)
>> +	#define LCR_LED2_10MODE		(1 << 6)
>> +	#define LCR_LED2_DUPCOL		(1 << 7)
>> +#define P2_IPGCR	(0x50)
>> +#define P2_CRIR		(0x52)
>> +#define P2_FLHWCR	(0x54)
>> +#define P2_RXCR		(0x56)
>> +	#define RXCR_PRO		(1 << 0)
>> +	#define RXCR_AMALL		(1 << 1)
>> +	#define RXCR_SEP		(1 << 2)
>> +	#define RXCR_AB			(1 << 3)
>> +	#define RXCR_AM			(1 << 4)
>> +	#define RXCR_AP			(1 << 5)
>> +	#define RXCR_ARP		(1 << 6)
>> +#define P2_JLCR		(0x58)
>> +#define P2_MPLR		(0x5C)
>> +
>> +	/* Definition of PAGE3 */
>> +#define P3_MACASR0	(0x62)
>> +	#define P3_MACASR(x)		(P3_MACASR0 + 2*x)
>> +	#define MACASR_LOWBYTE_MASK	0x00FF
>> +	#define MACASR_HIGH_BITS	0x08
>> +#define P3_MACASR1	(0x64)
>> +#define P3_MACASR2	(0x66)
>> +#define P3_MFAR01	(0x68)
>> +#define P3_MFAR_BASE	(0x68)
>> +	#define P3_MFAR(x)		(P3_MFAR_BASE + 2*x)
>> +
>> +#define P3_MFAR23	(0x6A)
>> +#define P3_MFAR45	(0x6C)
>> +#define P3_MFAR67	(0x6E)
>> +#define P3_VID0FR	(0x70)
>> +#define P3_VID1FR	(0x72)
>> +#define P3_EECSR	(0x74)
>> +#define P3_EEDR		(0x76)
>> +#define P3_EECR		(0x78)
>> +	#define EECR_ADDR_MASK		(0x00FF)
>> +	#define EECR_READ_ACT		(1 << 8)
>> +	#define EECR_WRITE_ACT		(1 << 9)
>> +	#define EECR_WRITE_DISABLE	(1 << 10)
>> +	#define EECR_WRITE_ENABLE	(1 << 11)
>> +	#define EECR_EE_READY		(1 << 13)
>> +	#define EECR_RELOAD		(1 << 14)
>> +	#define EECR_RESET		(1 << 15)
>> +#define P3_TPCR		(0x7A)
>> +	#define TPCR_PATT_MASK		(0xFF)
>> +	#define TPCR_RAND_PKT_EN	(1 << 14)
>> +	#define TPCR_FIXED_PKT_EN	(1 << 15)
>> +#define P3_TPLR		(0x7C)
>> +	/* Definition of PAGE4 */
>> +#define P4_SPICR	(0x8A)
>> +	#define SPICR_RCEN		(1 << 0)
>> +	#define SPICR_QCEN		(1 << 1)
>> +	#define SPICR_RBRE		(1 << 3)
>> +	#define SPICR_PMM		(1 << 4)
>> +	#define SPICR_LOOPBACK		(1 << 8)
>> +	#define SPICR_CORE_RES_CLR	(1 << 10)
>> +	#define SPICR_SPI_RES_CLR	(1 << 11)
>> +#define P4_SPIISMR	(0x8C)
>> +
>> +#define P4_COERCR0	(0x92)
>> +	#define COERCR0_RXIPCE		(1 << 0)
>> +	#define COERCR0_RXIPVE		(1 << 1)
>> +	#define COERCR0_RXV6PE		(1 << 2)
>> +	#define COERCR0_RXTCPE		(1 << 3)
>> +	#define COERCR0_RXUDPE		(1 << 4)
>> +	#define COERCR0_RXICMP		(1 << 5)
>> +	#define COERCR0_RXIGMP		(1 << 6)
>> +	#define COERCR0_RXICV6		(1 << 7)
>> +
>> +	#define COERCR0_RXTCPV6		(1 << 8)
>> +	#define COERCR0_RXUDPV6		(1 << 9)
>> +	#define COERCR0_RXICMV6		(1 << 10)
>> +	#define COERCR0_RXIGMV6		(1 << 11)
>> +	#define COERCR0_RXICV6V6	(1 << 12)
>> +
>> +	#define COERCR0_DEFAULT		(COERCR0_RXIPCE | COERCR0_RXV6PE | \
>> +					 COERCR0_RXTCPE | COERCR0_RXUDPE | \
>> +					 COERCR0_RXTCPV6 | COERCR0_RXUDPV6)
>> +#define P4_COERCR1	(0x94)
>> +	#define COERCR1_IPCEDP		(1 << 0)
>> +	#define COERCR1_IPVEDP		(1 << 1)
>> +	#define COERCR1_V6VEDP		(1 << 2)
>> +	#define COERCR1_TCPEDP		(1 << 3)
>> +	#define COERCR1_UDPEDP		(1 << 4)
>> +	#define COERCR1_ICMPDP		(1 << 5)
>> +	#define COERCR1_IGMPDP		(1 << 6)
>> +	#define COERCR1_ICV6DP		(1 << 7)
>> +	#define COERCR1_RX64TE		(1 << 8)
>> +	#define COERCR1_RXPPPE		(1 << 9)
>> +	#define COERCR1_TCP6DP		(1 << 10)
>> +	#define COERCR1_UDP6DP		(1 << 11)
>> +	#define COERCR1_IC6DP		(1 << 12)
>> +	#define COERCR1_IG6DP		(1 << 13)
>> +	#define COERCR1_ICV66DP		(1 << 14)
>> +	#define COERCR1_RPCE		(1 << 15)
>> +
>> +	#define COERCR1_DEFAULT		(COERCR1_RXPPPE)
>> +#define P4_COETCR0	(0x96)
>> +	#define COETCR0_TXIP		(1 << 0)
>> +	#define COETCR0_TXTCP		(1 << 1)
>> +	#define COETCR0_TXUDP		(1 << 2)
>> +	#define COETCR0_TXICMP		(1 << 3)
>> +	#define COETCR0_TXIGMP		(1 << 4)
>> +	#define COETCR0_TXICV6		(1 << 5)
>> +	#define COETCR0_TXTCPV6		(1 << 8)
>> +	#define COETCR0_TXUDPV6		(1 << 9)
>> +	#define COETCR0_TXICMV6		(1 << 10)
>> +	#define COETCR0_TXIGMV6		(1 << 11)
>> +	#define COETCR0_TXICV6V6	(1 << 12)
>> +
>> +	#define COETCR0_DEFAULT		(COETCR0_TXIP | COETCR0_TXTCP | \
>> +					 COETCR0_TXUDP | COETCR0_TXTCPV6 | \
>> +					 COETCR0_TXUDPV6)
>> +#define P4_COETCR1	(0x98)
>> +	#define COETCR1_TX64TE		(1 << 0)
>> +	#define COETCR1_TXPPPE		(1 << 1)
>> +
>> +#define P4_COECEDR	(0x9A)
>> +#define P4_L2CECR	(0x9C)
>> +
>> +	/* Definition of PAGE5 */
>> +#define P5_WFTR		(0xA2)
>> +	#define WFTR_2MS		(0x01)
>> +	#define WFTR_4MS		(0x02)
>> +	#define WFTR_8MS		(0x03)
>> +	#define WFTR_16MS		(0x04)
>> +	#define WFTR_32MS		(0x05)
>> +	#define WFTR_64MS		(0x06)
>> +	#define WFTR_128MS		(0x07)
>> +	#define WFTR_256MS		(0x08)
>> +	#define WFTR_512MS		(0x09)
>> +	#define WFTR_1024MS		(0x0A)
>> +	#define WFTR_2048MS		(0x0B)
>> +	#define WFTR_4096MS		(0x0C)
>> +	#define WFTR_8192MS		(0x0D)
>> +	#define WFTR_16384MS		(0x0E)
>> +	#define WFTR_32768MS		(0x0F)
>> +#define P5_WFCCR	(0xA4)
>> +#define P5_WFCR03	(0xA6)
>> +	#define WFCR03_F0_EN		(1 << 0)
>> +	#define WFCR03_F1_EN		(1 << 4)
>> +	#define WFCR03_F2_EN		(1 << 8)
>> +	#define WFCR03_F3_EN		(1 << 12)
>> +#define P5_WFCR47	(0xA8)
>> +	#define WFCR47_F4_EN		(1 << 0)
>> +	#define WFCR47_F5_EN		(1 << 4)
>> +	#define WFCR47_F6_EN		(1 << 8)
>> +	#define WFCR47_F7_EN		(1 << 12)
>> +#define P5_WF0BMR0	(0xAA)
>> +#define P5_WF0BMR1	(0xAC)
>> +#define P5_WF0CR	(0xAE)
>> +#define P5_WF0OBR	(0xB0)
>> +#define P5_WF1BMR0	(0xB2)
>> +#define P5_WF1BMR1	(0xB4)
>> +#define P5_WF1CR	(0xB6)
>> +#define P5_WF1OBR	(0xB8)
>> +#define P5_WF2BMR0	(0xBA)
>> +#define P5_WF2BMR1	(0xBC)
>> +
>> +	/* Definition of PAGE6 */
>> +#define P6_WF2CR	(0xC2)
>> +#define P6_WF2OBR	(0xC4)
>> +#define P6_WF3BMR0	(0xC6)
>> +#define P6_WF3BMR1	(0xC8)
>> +#define P6_WF3CR	(0xCA)
>> +#define P6_WF3OBR	(0xCC)
>> +#define P6_WF4BMR0	(0xCE)
>> +#define P6_WF4BMR1	(0xD0)
>> +#define P6_WF4CR	(0xD2)
>> +#define P6_WF4OBR	(0xD4)
>> +#define P6_WF5BMR0	(0xD6)
>> +#define P6_WF5BMR1	(0xD8)
>> +#define P6_WF5CR	(0xDA)
>> +#define P6_WF5OBR	(0xDC)
>> +
>> +/* Definition of PAGE7 */
>> +#define P7_WF6BMR0	(0xE2)
>> +#define P7_WF6BMR1	(0xE4)
>> +#define P7_WF6CR	(0xE6)
>> +#define P7_WF6OBR	(0xE8)
>> +#define P7_WF7BMR0	(0xEA)
>> +#define P7_WF7BMR1	(0xEC)
>> +#define P7_WF7CR	(0xEE)
>> +#define P7_WF7OBR	(0xF0)
>> +#define P7_WFR01	(0xF2)
>> +#define P7_WFR23	(0xF4)
>> +#define P7_WFR45	(0xF6)
>> +#define P7_WFR67	(0xF8)
>> +#define P7_WFPC0	(0xFA)
>> +#define P7_WFPC1	(0xFC)
>> +
>> +
>> +/* Tx headers structure */
>> +struct tx_sop_header {
>> +	/* bit 15-11: flags, bit 10-0: packet length */
>> +	u16 flags_len;
>> +	/* bit 15-11: sequence number, bit 11-0: packet length bar */
>> +	u16 seq_lenbar;
>> +} __packed;
>> +
>> +struct tx_segment_header {
>> +	/* bit 15-14: flags, bit 13-11: segment number */
>> +	/* bit 10-0: segment length */
>> +	u16 flags_seqnum_seglen;
>> +	/* bit 15-14: end offset, bit 13-11: start offset */
>> +	/* bit 10-0: segment length bar */
>> +	u16 eo_so_seglenbar;
>> +} __packed;
>> +
>> +struct tx_eop_header {
>> +	/* bit 15-11: sequence number, bit 10-0: packet length */
>> +	u16 seq_len;
>> +	/* bit 15-11: sequence number bar, bit 10-0: packet length bar */
>> +	u16 seqbar_lenbar;
>> +} __packed;
>> +
>> +struct tx_pkt_info {
>> +	struct tx_sop_header sop;
>> +	struct tx_segment_header seg;
>> +	struct tx_eop_header eop;
>> +	u16 pkt_len;
>> +	u16 seq_num;
>> +} __packed;
>> +
>> +/* Rx headers structure */
>> +struct rx_header {
>> +	u16 flags_len;
>> +	u16 seq_lenbar;
>> +	u16 flags;
>> +} __packed;
>> +
>> +#endif /* #ifndef _AX88796C_MAIN_H */
>> diff --git a/drivers/net/ethernet/asix/ax88796c_spi.c b/drivers/net/ethe=
rnet/asix/ax88796c_spi.c
>> new file mode 100644
>> index 000000000000..5304eb33aad2
>> --- /dev/null
>> +++ b/drivers/net/ethernet/asix/ax88796c_spi.c
>> @@ -0,0 +1,103 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (c) 2010 ASIX Electronics Corporation
>> + *
>> + * ASIX AX88796C SPI Fast Ethernet Linux driver
>> + */
>> +
>> +#include "ax88796c_main.h"
>> +#include "ax88796c_spi.h"
>> +
>> +/* driver bus management functions */
>> +void axspi_wakeup(struct axspi_data *ax_spi)
>> +{
>> +	u8 tx_buf;
>> +	int ret;
>> +
>> +	tx_buf =3D AX_SPICMD_EXIT_PWD;	/* OP */
>> +	ret =3D spi_write(ax_spi->spi, &tx_buf, 1);
>> +	if (ret)
>> +		dev_err(&ax_spi->spi->dev, "%s() failed: ret =3D %d\n", __func__, ret=
);
>> +}
>> +
>> +void axspi_read_status(struct axspi_data *ax_spi, struct spi_status *st=
atus)
>> +{
>> +	u8 tx_buf;
>> +	int ret;
>> +
>> +	/* OP */
>> +	tx_buf =3D AX_SPICMD_READ_STATUS;
>> +	ret =3D spi_write_then_read(ax_spi->spi, &tx_buf, 1, (u8 *)&status, 3);
>> +	if (ret)
>> +		dev_err(&ax_spi->spi->dev, "%s() failed: ret =3D %d\n", __func__, ret=
);
>> +	else
>> +		le16_to_cpus(&status->isr);
>> +}
>> +
>> +int axspi_read_rxq(struct axspi_data *ax_spi, void *data, int len)
>> +{
>> +	struct spi_transfer *xfer =3D ax_spi->spi_rx_xfer;
>> +	int ret;
>> +
>> +	memcpy(ax_spi->cmd_buf, rx_cmd_buf, 5);
>> +
>> +	xfer->tx_buf =3D ax_spi->cmd_buf;
>> +	xfer->rx_buf =3D NULL;
>> +	xfer->len =3D ax_spi->comp ? 2 : 5;
>> +	xfer->bits_per_word =3D 8;
>> +	spi_message_add_tail(xfer, &ax_spi->rx_msg);
>> +
>> +	xfer++;
>> +	xfer->rx_buf =3D data;
>> +	xfer->tx_buf =3D NULL;
>> +	xfer->len =3D len;
>> +	xfer->bits_per_word =3D 8;
>> +	spi_message_add_tail(xfer, &ax_spi->rx_msg);
>> +	ret =3D spi_sync(ax_spi->spi, &ax_spi->rx_msg);
>> +	if (ret)
>> +		dev_err(&ax_spi->spi->dev, "%s() failed: ret =3D %d\n", __func__, ret=
);
>> +
>> +	return ret;
>> +}
>> +
>> +int axspi_write_txq(struct axspi_data *ax_spi, void *data, int len)
>> +{
>> +	return spi_write(ax_spi->spi, data, len);
>> +}
>> +
>> +u16 axspi_read_reg(struct axspi_data *ax_spi, u8 reg)
>> +{
>> +	u8 tx_buf[4];
>> +	u16 rx_buf =3D 0;
>> +	int ret;
>> +	int len =3D ax_spi->comp ? 3 : 4;
>> +
>> +	tx_buf[0] =3D 0x03;	/* OP code read register */
>> +	tx_buf[1] =3D reg;	/* register address */
>> +	tx_buf[2] =3D 0xFF;	/* dumy cycle */
>> +	tx_buf[3] =3D 0xFF;	/* dumy cycle */
>> +	ret =3D spi_write_then_read(ax_spi->spi, tx_buf, len, (u8 *)&rx_buf, 2=
);
>> +	if (ret)
>> +		dev_err(&ax_spi->spi->dev, "%s() failed: ret =3D %d\n", __func__, ret=
);
>> +	else
>> +		le16_to_cpus(&rx_buf);
>> +
>> +	return rx_buf;
>> +}
>> +
>> +void axspi_write_reg(struct axspi_data *ax_spi, u8 reg, u16 value)
>> +{
>> +	u8 tx_buf[4];
>> +	int ret;
>> +
>> +	tx_buf[0] =3D AX_SPICMD_WRITE_REG;	/* OP code read register */
>> +	tx_buf[1] =3D reg;			/* register address */
>> +	tx_buf[2] =3D value;
>> +	tx_buf[3] =3D value >> 8;
>> +
>> +	ret =3D spi_write(ax_spi->spi, tx_buf, 4);
>> +	if (ret)
>> +		dev_err(&ax_spi->spi->dev, "%s() failed: ret =3D %d\n", __func__, ret=
);
>> +
>
> Run the checkpatch string and fix almost all issues (except ones you
> disagree).


=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl9GeL0ACgkQsK4enJil
gBCpPwf2ILHcUkSg2UA16Z8P7l3AnWX2y8M4qOB8YAsW56CPZMb0rOlNtUDLwGlu
V/B4nsJqM4kpYmkg3+0vtyrqbbX1l5veiKdlBktesFwEY6z6J8aMUDkQKpJY8Gm3
IMFyM5HqHrW24g2w9Bykt6iC4JeTl2J40KIgPl13xe7on/610VM/JzB1fieNWN56
HambXx8Y22IspElQ5ZEIPR4GK45UpPucyAQO6bD1P0R+E9JsOJyqLfeYrCwt+ZRo
KKJL6KWenZ0FQFqzIU8UddCXMK87OC3Klfi1NxaJNZD5R53/w8ZhDEgW334XyurI
wVtD8uDWF2Ua1uw/17y5UUQpJ1Ml
=jULJ
-----END PGP SIGNATURE-----
--=-=-=--
