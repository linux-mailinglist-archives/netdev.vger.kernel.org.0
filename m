Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA80628D526
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 22:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgJMUDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 16:03:12 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54026 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729854AbgJMUDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 16:03:12 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201013200256euoutp02d4624325a935b7cfa205432ce9715ea1~9pdUTg-LP0275902759euoutp02E;
        Tue, 13 Oct 2020 20:02:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201013200256euoutp02d4624325a935b7cfa205432ce9715ea1~9pdUTg-LP0275902759euoutp02E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1602619377;
        bh=DO76uklogiHD5b8KRv+PGvAc8NrFNSwv5iBoP7VhlV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WzQGkaCM/D5mIbq5qD7PgUXVhnf2yIpNhl9dFgSs5Y6lquPL84ezx0AzCtvDDB75L
         naCV/fvgcVeBHKNWwTNi731+LtZf+q4/tA95+6KZr3g7AaGoxfQMbXR8sYvx4Utwc2
         46451rWjV29jweIsaCo11JE4Ws8WIv5f7MfqPkTE=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201013200251eucas1p1b0a374c5958849cebf61906a238da436~9pdPQ2HdS0737407374eucas1p1a;
        Tue, 13 Oct 2020 20:02:51 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 55.5B.06318.BE7068F5; Tue, 13
        Oct 2020 21:02:51 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201013200250eucas1p2445005531b86f246d7a14b7fc8016e80~9pdOr3HNE2829628296eucas1p2Q;
        Tue, 13 Oct 2020 20:02:50 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201013200250eusmtrp11a88c102cacef5b17b4e87822b7c81b7~9pdOrB2he2558025580eusmtrp1b;
        Tue, 13 Oct 2020 20:02:50 +0000 (GMT)
X-AuditID: cbfec7f5-38bff700000018ae-b4-5f8607ebcf89
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id B6.F9.06314.AE7068F5; Tue, 13
        Oct 2020 21:02:50 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201013200250eusmtip2ae00b2d5cf65f8c7066cd19b5188ac32~9pdOYR-nw1796217962eusmtip2m;
        Tue, 13 Oct 2020 20:02:50 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        =?utf-8?Q?Bart?= =?utf-8?Q?=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2 2/4] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Date:   Tue, 13 Oct 2020 22:02:27 +0200
In-Reply-To: <2e7d2325-66ce-3f18-ddcb-628c999b34ed@gmail.com> (Heiner
        Kallweit's message of "Sat, 3 Oct 2020 14:59:05 +0200")
Message-ID: <dleftjeem199nw.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02SX0hTcRTH+e3eu3snTa4r6zAtctpDRloY+TM1TK2uT9lLRFS26mLR/sim
        lj2kSJqZqSXmnJImZqZNba6h0oqGGaU5w7Ish6VR5lyLTCiJbPMa9PY553zPOd/z48cQsgVK
        zpzUZPI6jVKlEPuR1r5fgxtddGHapqmJIOxw2gl819BO4VrHeRLX9Q5SuMFjoPCIe4zCZZMu
        AjscHTQespZS2Dw5QuHhnloxNjgeiLC90oawqddJ4776lbjA1ksnsNzwyAuCs9weFXHdRifN
        mVsuirnOxlyuu2tWxJVaWhA3a16TyhzwizvOq05m87rI7Uf8TlwrNKEMRxNxZtRQJ8pDntei
        YiRhgN0CdQsO2scythnBwofUYuTn5R8Ixu6U0UIwi+B64Tv6X8dgUyUlFG4huNv2mBSCzwic
        BdNEMWIYMRsBJtN+X8MKNhzKXXfEPg3BPiPB6jEtTlrO7oMXF94QPibZddDXfGnRk4TNhblR
        m9jHUjYazFMNi/pANgYsU+O0kA+Ap9UfSR8TrBqqHTPItwDYmwz0truQYDUZfl2zLfFymH5i
        WTohGPorSkifUfAuq7i6VegtQWCt/UkKmlgYG5wXC7wDvlcNiQS9P7xxBwh7/eGqtYoQ0lIo
        KpQJ6jBoK7u/NEUOl6eblxxwUGo0IOGtyhHUvWxF5Wit8b9zjP+dY/SOJdj10N4TKaQ3QNMN
        FyFwPLS1ech6RLWgVXyWXp3O66M0/OkIvVKtz9KkRxzTqs3I+xX7/zyZ60IPfh+1I5ZBimXS
        oo6CNBmlzNbnqO0ozDtpoqN1CMlJjVbDK1ZIE5/3H5ZJjytzzvI6bZouS8Xr7SiIIRWrpFEN
        Xw7J2HRlJn+K5zN43b+qiJHI89C5l0l0e/d7lTLq+WZnxe6iENeut0Tl79aYhNiB/Jpxd4xM
        Gvxt28DOEFVOpMQ/MTuo6mHjuC2xVBeOu3/EMXL3mbPR61IkBdK9fyZrPse/yt3jXq3t3Nq6
        Mj/2a01gxox2+FFwfVJSU81M6NfoK58gMOVgSN6AONeSPBrqme+8pyD1J5SbwwmdXvkXY+Ll
        rJIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t/xe7qv2NviDTq7jSzO3z3EbLFxxnpW
        iznnW1gs5h85x2qx6P0MVotrb++wWvQ/fs1scf78BnaLC9v6WC02Pb7GanF51xw2ixnn9zFZ
        HJq6l9Fi7ZG77BbHFohZtO49wu4g4HH52kVmjy0rbzJ57Jx1l91j06pONo/NS+o9du74zOTR
        t2UVo8fnTXIBHFF6NkX5pSWpChn5xSW2StGGFkZ6hpYWekYmlnqGxuaxVkamSvp2NimpOZll
        qUX6dgl6GdPa1jIWnF/GXHFzxnymBsb315m6GDk5JARMJM4tm8raxcjFISSwlFHixryFQAkO
        oISUxMq56RA1whJ/rnWxQdQ8ZZQ4v3AZC0gNm4CexNq1ESA1IgJaEhNerwGrYRY4xyLx/sFz
        VpCEsECIxMK+U2DLhARsJHr23mMHsVkEVCWOregGi3MK1Et8vbmXDcTmFTCX2PRiEViNqICl
        xJYX99kh4oISJ2c+YQGxmQWyJb6ufs48gVFgFpLULCSpWUDnMQtoSqzfpQ8R1pZYtvA1M4Rt
        K7Fu3XuWBYysqxhFUkuLc9Nziw31ihNzi0vz0vWS83M3MQIjetuxn5t3MF7aGHyIUYCDUYmH
        t2NDa7wQa2JZcWXuIUYVoDGPNqy+wCjFkpefl6okwut09nScEG9KYmVValF+fFFpTmrxIUZT
        oD8nMkuJJucDk1BeSbyhqaG5haWhubG5sZmFkjhvh8DBGCGB9MSS1OzU1ILUIpg+Jg5OqQZG
        276p0x6uX+jEY18+tWsqhwdH7d7SEssD1//6V830m7JV8x1jZmWecodTtCiT3uznykv/i2qe
        OXful+tfHeft+SFJs8s0PnueP9z7LS7uKP9X86isdzbbuUSyBRiad/3YeGJNVnoVL/e5m122
        qncXZd1STb9q9p1h4vT8ef1HZtkm6s1P9v+ixFKckWioxVxUnAgAJjzHKQoDAAA=
X-CMS-MailID: 20201013200250eucas1p2445005531b86f246d7a14b7fc8016e80
X-Msg-Generator: CA
X-RootMTR: 20201013200250eucas1p2445005531b86f246d7a14b7fc8016e80
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201013200250eucas1p2445005531b86f246d7a14b7fc8016e80
References: <2e7d2325-66ce-3f18-ddcb-628c999b34ed@gmail.com>
        <CGME20201013200250eucas1p2445005531b86f246d7a14b7fc8016e80@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-10-03 sob 14:59>, when Heiner Kallweit wrote:
> On 02.10.2020 21:22, =C5=81ukasz Stelmach wrote:
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
>> + new timer, ethtool and gpio APIs,
>> + dev_* instead of pr_* and custom printk() wrappers,
>> + removed awkward vendor power managemtn.
>>=20
>> [1]
>> https://protect2.fireeye.com/v1/url?k=3Df34a6c6f-ae99377b-f34be720-0cc47=
a31ce4e-31468d469d6422a1&q=3D1&e=3D9cb90086-9be8-4db6-8a58-c5447926b709&u=
=3Dhttps%3A%2F%2Fwww.asix.com.tw%2Fproducts.php%3Fop%3DpItemdetail%26PItemI=
D%3D104%3B65%3B86%26PLine%3D65
>> [2]
>> https://protect2.fireeye.com/v1/url?k=3D67412e7e-3a92756a-6740a531-0cc47=
a31ce4e-4192baccfff43dec&q=3D1&e=3D9cb90086-9be8-4db6-8a58-c5447926b709&u=
=3Dhttps%3A%2F%2Fgit.tizen.org%2Fcgit%2Fprofile%2Fcommon%2Fplatform%2Fkerne=
l%2Flinux-3.10-artik%2F
>>=20
>> The other ax88796 driver is for NE2000 compatible AX88796L chip. These
>> chips are not compatible. Hence, two separate drivers are required.
>>=20
>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>> ---
>>  MAINTAINERS                                |    6 +
>>  drivers/net/ethernet/Kconfig               |    1 +
>>  drivers/net/ethernet/Makefile              |    1 +
>>  drivers/net/ethernet/asix/Kconfig          |   21 +
>>  drivers/net/ethernet/asix/Makefile         |    6 +
>>  drivers/net/ethernet/asix/ax88796c_ioctl.c |  241 +++++
>>  drivers/net/ethernet/asix/ax88796c_ioctl.h |   27 +
>>  drivers/net/ethernet/asix/ax88796c_main.c  | 1041 ++++++++++++++++++++
>>  drivers/net/ethernet/asix/ax88796c_main.h  |  568 +++++++++++
>>  drivers/net/ethernet/asix/ax88796c_spi.c   |  111 +++
>>  drivers/net/ethernet/asix/ax88796c_spi.h   |   69 ++
>>  11 files changed, 2092 insertions(+)
>>  create mode 100644 drivers/net/ethernet/asix/Kconfig
>>  create mode 100644 drivers/net/ethernet/asix/Makefile
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.c
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.h
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_main.c
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_main.h
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.c
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.h
>>=20
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index deaafb617361..654eb0127479 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -2822,6 +2822,12 @@ S:	Maintained
>>  F:	Documentation/hwmon/asc7621.rst
>>  F:	drivers/hwmon/asc7621.c
>>=20=20
>> +ASIX AX88796C SPI ETHERNET ADAPTER
>> +M:	=C5=81ukasz Stelmach <l.stelmach@samsung.com>
>> +S:	Maintained
>> +F:	Documentation/devicetree/bindings/net/asix,ax99706c-spi.yaml
>> +F:	drivers/net/ethernet/asix/ax88796c_*
>> +
>>  ASPEED PINCTRL DRIVERS
>>  M:	Andrew Jeffery <andrew@aj.id.au>
>>  L:	linux-aspeed@lists.ozlabs.org (moderated for non-subscribers)
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
>> index 000000000000..7caa45607450
>> --- /dev/null
>> +++ b/drivers/net/ethernet/asix/Kconfig
>> @@ -0,0 +1,21 @@
>> +#
>> +# Asix network device configuration
>> +#
>> +
>> +config NET_VENDOR_ASIX
>> +	bool "Asix devices"
>> +	default y
>> +	help
>> +	  If you have a network (Ethernet, non-USB, not NE2000 compatible)
>> +	  interface based on a chip from ASIX, say Y.
>> +
>> +if NET_VENDOR_ASIX
>> +
>> +config SPI_AX88796C
>> +	tristate "Asix AX88796C-SPI support"
>> +	depends on SPI
>> +	depends on GPIOLIB
>> +	help
>> +	  Say Y here if you intend to use ASIX AX88796C attached in SPI mode.
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
>> index 000000000000..b3e3ac96790d
>> --- /dev/null
>> +++ b/drivers/net/ethernet/asix/ax88796c_ioctl.c
>> @@ -0,0 +1,241 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (c) 2010 ASIX Electronics Corporation
>> + * Copyright (c) 2020 Samsung Electronics Co., Ltd.
>> + *
>> + * ASIX AX88796C SPI Fast Ethernet Linux driver
>> + */
>> +
>> +#define pr_fmt(fmt)	"ax88796c: " fmt
>> +
>> +#include <linux/bitmap.h>
>> +#include <linux/iopoll.h>
>> +#include <linux/phy.h>
>> +#include <linux/netdevice.h>
>> +
>> +#include "ax88796c_main.h"
>> +#include "ax88796c_ioctl.h"
>> +
>> +static void ax88796c_get_drvinfo(struct net_device *ndev,
>> +				 struct ethtool_drvinfo *info)
>> +{
>> +	/* Inherit standard device info */
>> +	strncpy(info->driver, DRV_NAME, sizeof(info->driver));
>> +}
>> +
>> +static u32 ax88796c_get_link(struct net_device *ndev)
>
> Why not using ethtool_op_get_link ?
>

For no particualr reason other than lack of knowledge. It seems OK to
use it and it works fine.

>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +
>> +	mutex_lock(&ax_local->spi_lock);
>> +
>> +	phy_read_status(ndev->phydev);
>> +
>> +	mutex_unlock(&ax_local->spi_lock);
>> +
>> +	return ndev->phydev->link;
>> +}
>> +
>> +static u32 ax88796c_get_msglevel(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +
>> +	return ax_local->msg_enable;
>> +}
>> +
>> +static void ax88796c_set_msglevel(struct net_device *ndev, u32 level)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +
>> +	ax_local->msg_enable =3D level;
>> +}
>> +
>> +static int
>> +ax88796c_get_link_ksettings(struct net_device *ndev,
>> +			    struct ethtool_link_ksettings *cmd)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	int ret;
>> +
>> +	mutex_lock(&ax_local->spi_lock);
>> +
>> +	ret =3D phy_ethtool_get_link_ksettings(ndev, cmd);
>> +
>> +	mutex_unlock(&ax_local->spi_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static int
>> +ax88796c_set_link_ksettings(struct net_device *ndev,
>> +			    const struct ethtool_link_ksettings *cmd)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	int ret;
>> +
>> +	mutex_lock(&ax_local->spi_lock);
>> +
>> +	ret =3D phy_ethtool_set_link_ksettings(ndev, cmd);
>> +
>> +	mutex_unlock(&ax_local->spi_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static int ax88796c_nway_reset(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	int ret;
>> +
>> +	mutex_lock(&ax_local->spi_lock);
>> +
>> +	ret =3D phy_ethtool_nway_reset(ndev);
>> +
>> +	mutex_unlock(&ax_local->spi_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static u32 ax88796c_ethtool_getmsglevel(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +
>> +	return ax_local->msg_enable;
>> +}
>> +
>> +static void ax88796c_ethtool_setmsglevel(struct net_device *ndev, u32 l=
evel)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +
>> +	ax_local->msg_enable =3D level;
>> +}
>> +
>> +static int ax88796c_get_regs_len(struct net_device *ndev)
>> +{
>> +	return AX88796C_REGDUMP_LEN + AX88796C_PHY_REGDUMP_LEN;
>> +}
>> +
>> +static void
>> +ax88796c_get_regs(struct net_device *ndev, struct ethtool_regs *regs, v=
oid *_p)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	u16 *p =3D _p;
>> +	int offset, i;
>> +
>> +	memset(p, 0, AX88796C_REGDUMP_LEN);
>> +
>> +	for (offset =3D 0; offset < AX88796C_REGDUMP_LEN; offset +=3D 2) {
>> +		if (!test_bit(offset / 2, ax88796c_no_regs_mask))
>> +			*p =3D AX_READ(&ax_local->ax_spi, offset);
>> +		p++;
>> +	}
>> +
>> +	for (i =3D 0; i < AX88796C_PHY_REGDUMP_LEN / 2; i++) {
>> +		*p =3D phy_read(ax_local->phydev, i);
>> +		p++;
>> +	}
>> +}
>> +
>> +int ax88796c_mdio_read(struct mii_bus *mdiobus, int phy_id, int loc)
>> +{
>> +	struct ax88796c_device *ax_local =3D mdiobus->priv;
>> +	int ret;
>> +
>> +	AX_WRITE(&ax_local->ax_spi, MDIOCR_RADDR(loc)
>> +			| MDIOCR_FADDR(phy_id) | MDIOCR_READ, P2_MDIOCR);
>> +
>> +	ret =3D read_poll_timeout(AX_READ, ret,
>> +				(ret !=3D 0),
>> +				0, jiffies_to_usecs(HZ / 100), false,
>> +				&ax_local->ax_spi, P2_MDIOCR);
>> +	if (ret)
>> +		return -EBUSY;
>> +
>> +	return AX_READ(&ax_local->ax_spi, P2_MDIODR);
>> +}
>> +
>> +int
>> +ax88796c_mdio_write(struct mii_bus *mdiobus, int phy_id, int loc, u16 v=
al)
>> +{
>> +	struct ax88796c_device *ax_local =3D mdiobus->priv;
>> +	int ret;
>> +
>> +	AX_WRITE(&ax_local->ax_spi, val, P2_MDIODR);
>> +
>> +	AX_WRITE(&ax_local->ax_spi,
>> +		 MDIOCR_RADDR(loc) | MDIOCR_FADDR(phy_id)
>> +		 | MDIOCR_WRITE, P2_MDIOCR);
>> +
>> +	ret =3D read_poll_timeout(AX_READ, ret,
>> +				((ret & MDIOCR_VALID) !=3D 0), 0,
>> +				jiffies_to_usecs(HZ / 100), false,
>> +				&ax_local->ax_spi, P2_MDIOCR);
>> +	if (ret)
>> +		return -EIO;
>> +
>> +	if (loc =3D=3D MII_ADVERTISE) {
>> +		AX_WRITE(&ax_local->ax_spi, (BMCR_FULLDPLX | BMCR_ANRESTART |
>> +			  BMCR_ANENABLE | BMCR_SPEED100), P2_MDIODR);
>
> This looks very hacky. Why do you do this?

As I wrote Andy Lunn:

I will honestly say, I am not sure. Apparently it is not required and I
am willing to remove it. It could be of some use when the driver didn't
use phylib.

> What if the user wants to switch to fixed mode?

For the record, it doesn't look like it prevents a fixed mode. This code
runs when user changes the list of advertised modes which means they
want it to be used for autonegotiation so why not turn it on. However,
since it doesn't appear other drivers behave like this I will remove
this code.

>> +		AX_WRITE(&ax_local->ax_spi, (MDIOCR_RADDR(MII_BMCR) |
>> +			  MDIOCR_FADDR(phy_id) | MDIOCR_WRITE),
>> +			  P2_MDIOCR);
>> +
>> +		ret =3D read_poll_timeout(AX_READ, ret,
>> +					((ret & MDIOCR_VALID) !=3D 0), 0,
>> +					jiffies_to_usecs(HZ / 100), false,
>> +					&ax_local->ax_spi, P2_MDIOCR);
>> +		if (ret)
>> +			return -EIO;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +void ax88796c_set_csums(struct ax88796c_device *ax_local)
>> +{
>> +	struct net_device *ndev =3D ax_local->ndev;
>> +
>> +	if (ndev->features & NETIF_F_RXCSUM) {
>> +		AX_WRITE(&ax_local->ax_spi, COERCR0_DEFAULT, P4_COERCR0);
>> +		AX_WRITE(&ax_local->ax_spi, COERCR1_DEFAULT, P4_COERCR1);
>> +	} else {
>> +		AX_WRITE(&ax_local->ax_spi, 0, P4_COERCR0);
>> +		AX_WRITE(&ax_local->ax_spi, 0, P4_COERCR1);
>> +	}
>> +
>> +	if (ndev->features & NETIF_F_HW_CSUM) {
>> +		AX_WRITE(&ax_local->ax_spi, COETCR0_DEFAULT, P4_COETCR0);
>> +		AX_WRITE(&ax_local->ax_spi, COETCR1_TXPPPE, P4_COETCR1);
>> +	} else {
>> +		AX_WRITE(&ax_local->ax_spi, 0, P4_COETCR0);
>> +		AX_WRITE(&ax_local->ax_spi, 0, P4_COETCR1);
>> +	}
>> +}
>> +
>> +const struct ethtool_ops ax88796c_ethtool_ops =3D {
>> +	.get_drvinfo		=3D ax88796c_get_drvinfo,
>> +	.get_link		=3D ax88796c_get_link,
>> +	.get_msglevel		=3D ax88796c_get_msglevel,
>> +	.set_msglevel		=3D ax88796c_set_msglevel,
>> +	.get_link_ksettings	=3D ax88796c_get_link_ksettings,
>> +	.set_link_ksettings	=3D ax88796c_set_link_ksettings,
>> +	.nway_reset		=3D ax88796c_nway_reset,
>> +	.get_msglevel		=3D ax88796c_ethtool_getmsglevel,
>> +	.set_msglevel		=3D ax88796c_ethtool_setmsglevel,
>> +	.get_regs_len		=3D ax88796c_get_regs_len,
>> +	.get_regs		=3D ax88796c_get_regs,
>> +};
>> +
>> +int ax88796c_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	int ret;
>> +
>> +	mutex_lock(&ax_local->spi_lock);
>> +
>> +	ret =3D phy_mii_ioctl(ndev->phydev, ifr, cmd);
>> +
>> +	mutex_unlock(&ax_local->spi_lock);
>> +
>> +	return ret;
>> +}
>> diff --git a/drivers/net/ethernet/asix/ax88796c_ioctl.h b/drivers/net/et=
hernet/asix/ax88796c_ioctl.h
>> new file mode 100644
>> index 000000000000..d478981bf995
>> --- /dev/null
>> +++ b/drivers/net/ethernet/asix/ax88796c_ioctl.h
>> @@ -0,0 +1,27 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Copyright (c) 2010 ASIX Electronics Corporation
>> + * Copyright (c) 2020 Samsung Electronics Co., Ltd.
>> + *
>> + * ASIX AX88796C SPI Fast Ethernet Linux driver
>> + */
>> +
>> +#ifndef _AX88796C_IOCTL_H
>> +#define _AX88796C_IOCTL_H
>> +
>> +#include <linux/ethtool.h>
>> +#include <linux/netdevice.h>
>> +
>> +#include "ax88796c_main.h"
>> +
>> +extern const struct ethtool_ops ax88796c_ethtool_ops;
>> +
>> +bool ax88796c_check_power(const struct ax88796c_device *ax_local);
>> +bool ax88796c_check_power_and_wake(struct ax88796c_device *ax_local);
>> +void ax88796c_set_power_saving(struct ax88796c_device *ax_local, u8 ps_=
level);
>> +int ax88796c_mdio_read(struct mii_bus *mdiobus, int phy_id, int loc);
>> +int ax88796c_mdio_write(struct mii_bus *mdiobus, int phy_id, int loc, u=
16 val);
>> +void ax88796c_set_csums(struct ax88796c_device *ax_local);
>> +int ax88796c_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
>> +
>> +#endif
>> diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/eth=
ernet/asix/ax88796c_main.c
>> new file mode 100644
>> index 000000000000..2148ea01362a
>> --- /dev/null
>> +++ b/drivers/net/ethernet/asix/ax88796c_main.c
>> @@ -0,0 +1,1041 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (c) 2010 ASIX Electronics Corporation
>> + * Copyright (c) 2020 Samsung Electronics Co., Ltd.
>> + *
>> + * ASIX AX88796C SPI Fast Ethernet Linux driver
>> + */
>> +
>> +#define pr_fmt(fmt)	"ax88796c: " fmt
>> +
>> +#include "ax88796c_main.h"
>> +#include "ax88796c_ioctl.h"
>> +
>> +#include <linux/bitmap.h>
>> +#include <linux/etherdevice.h>
>> +#include <linux/iopoll.h>
>> +#include <linux/mdio.h>
>> +#include <linux/module.h>
>> +#include <linux/netdevice.h>
>> +#include <linux/of.h>
>> +#include <linux/phy.h>
>> +#include <linux/spi/spi.h>
>> +
>> +static int comp;
>> +static int msg_enable =3D NETIF_MSG_PROBE |
>> +			NETIF_MSG_LINK |
>> +			/* NETIF_MSG_TIMER | */
>> +			/* NETIF_MSG_IFDOWN | */
>> +			/* NETIF_MSG_IFUP | */
>> +			NETIF_MSG_RX_ERR |
>> +			NETIF_MSG_TX_ERR |
>> +			/* NETIF_MSG_TX_QUEUED | */
>> +			/* NETIF_MSG_INTR | */
>> +			/* NETIF_MSG_TX_DONE | */
>> +			/* NETIF_MSG_RX_STATUS | */
>> +			/* NETIF_MSG_PKTDATA | */
>> +			/* NETIF_MSG_HW | */
>> +			/* NETIF_MSG_WOL | */
>> +			0;
>> +
>> +static char *no_regs_list =3D "80018001,e1918001,8001a001,fc0d0000";
>> +unsigned long ax88796c_no_regs_mask[AX88796C_REGDUMP_LEN / (sizeof(unsi=
gned long) * 8)];
>> +
>> +module_param(comp, int, 0444);
>> +MODULE_PARM_DESC(comp, "0=3DNon-Compression Mode, 1=3DCompression Mode"=
);
>> +
>> +module_param(msg_enable, int, 0444);
>> +MODULE_PARM_DESC(msg_enable, "Message mask (see linux/netdevice.h for b=
itmap)");
>> +
>> +static int ax88796c_soft_reset(struct ax88796c_device *ax_local)
>> +{
>> +	u16 temp;
>> +	int ret;
>> +
>> +	AX_WRITE(&ax_local->ax_spi, PSR_RESET, P0_PSR);
>> +	AX_WRITE(&ax_local->ax_spi, PSR_RESET_CLR, P0_PSR);
>> +
>> +	ret =3D read_poll_timeout(AX_READ, ret,
>> +				(ret & PSR_DEV_READY),
>> +				0, jiffies_to_usecs(160 * HZ / 1000), false,
>> +				&ax_local->ax_spi, P0_PSR);
>> +	if (ret)
>> +		return -1;
>> +
>> +	temp =3D AX_READ(&ax_local->ax_spi, P4_SPICR);
>> +	if (ax_local->capabilities & AX_CAP_COMP) {
>> +		AX_WRITE(&ax_local->ax_spi,
>> +			 (temp | SPICR_RCEN | SPICR_QCEN), P4_SPICR);
>> +		ax_local->ax_spi.comp =3D 1;
>> +	} else {
>> +		AX_WRITE(&ax_local->ax_spi,
>> +			 (temp & ~(SPICR_RCEN | SPICR_QCEN)), P4_SPICR);
>> +		ax_local->ax_spi.comp =3D 0;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int ax88796c_reload_eeprom(struct ax88796c_device *ax_local)
>> +{
>> +	int ret;
>> +
>> +	AX_WRITE(&ax_local->ax_spi, EECR_RELOAD, P3_EECR);
>> +
>> +	ret =3D read_poll_timeout(AX_READ, ret,
>> +				(ret & PSR_DEV_READY),
>> +				0, jiffies_to_usecs(2 * HZ / 1000), false,
>> +				&ax_local->ax_spi, P0_PSR);
>> +	if (ret) {
>> +		dev_err(&ax_local->spi->dev,
>> +			"timeout waiting for reload eeprom\n");
>> +		return -1;
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
>> +	} else if (ndev->flags & IFF_ALLMULTI || mc_count > AX_MAX_MCAST) {
>> +		rx_ctl |=3D RXCR_AMALL;
>> +
>> +	} else if (mc_count =3D=3D 0) {
>> +		/* just broadcast and directed */
>> +	} else {
>> +		u32 crc_bits;
>> +		int i;
>> +		struct netdev_hw_addr *ha;
>> +
>> +		netdev_for_each_mc_addr(ha, ndev) {
>> +			crc_bits =3D ether_crc(ETH_ALEN, ha->addr);
>> +			ax_local->multi_filter[crc_bits >> 29] |=3D
>> +						(1 << ((crc_bits >> 26) & 7));
>> +		}
>> +
>> +		for (i =3D 0; i < 4; i++) {
>> +			AX_WRITE(&ax_local->ax_spi,
>> +				 ((ax_local->multi_filter[i * 2 + 1] << 8) |
>> +				  ax_local->multi_filter[i * 2]), P3_MFAR(i));
>> +		}
>> +	}
>> +
>> +	AX_WRITE(&ax_local->ax_spi, rx_ctl, P2_RXCR);
>> +}
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
>> +	mutex_lock(&ax_local->spi_lock);
>> +
>> +	ax88796c_set_mac_addr(ndev);
>> +
>> +	mutex_unlock(&ax_local->spi_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +static void ax88796c_load_mac_addr(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	u16 temp;
>> +
>> +	/* Try the device tree first */
>> +	if (!eth_platform_get_mac_address(&ax_local->spi->dev, ndev->dev_addr)=
 &&
>> +	    is_valid_ether_addr(ndev->dev_addr)) {
>> +		if (netif_msg_probe(ax_local))
>> +			dev_info(&ax_local->spi->dev,
>> +				 "MAC address read from device tree\n");
>> +		return;
>> +	}
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
>> +	if (is_valid_ether_addr(ndev->dev_addr)) {
>> +		if (netif_msg_probe(ax_local))
>> +			dev_info(&ax_local->spi->dev,
>> +				 "MAC address read from ASIX chip\n");
>> +		return;
>> +	}
>> +
>> +	/* Use random address if none found */
>> +	if (netif_msg_probe(ax_local))
>> +		dev_info(&ax_local->spi->dev, "Use random MAC address\n");
>> +	eth_hw_addr_random(ndev);
>> +}
>> +
>> +static void ax88796c_proc_tx_hdr(struct tx_pkt_info *info, u8 ip_summed)
>> +{
>> +	u16 pkt_len_bar =3D (~info->pkt_len & TX_HDR_SOP_PKTLENBAR);
>> +
>> +	/* Prepare SOP header */
>> +	info->sop.flags_len =3D info->pkt_len |
>> +		((ip_summed =3D=3D CHECKSUM_NONE) ||
>> +		 (ip_summed =3D=3D CHECKSUM_UNNECESSARY) ? TX_HDR_SOP_DICF : 0);
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
>> +	info =3D (struct tx_pkt_info *)skb->cb;
>> +	info->pkt_len =3D pkt_len;
>> +
>> +	if ((!skb_cloned(skb)) &&
>> +	    (headroom >=3D (TX_OVERHEAD + spi_len)) &&
>> +	    (tailroom >=3D (padlen + TX_EOP_SIZE))) {
>> +		info->seq_num =3D seq_num;
>> +		ax88796c_proc_tx_hdr(info, skb->ip_summed);
>> +
>> +		/* SOP and SEG header */
>> +		memcpy(skb_push(skb, TX_OVERHEAD), &info->sop, TX_OVERHEAD);
>> +
>> +		/* Write SPI TXQ header */
>> +		memcpy(skb_push(skb, spi_len), tx_cmd_buf, spi_len);
>> +
>> +		/* Make 32-bit alignment */
>> +		skb_put(skb, padlen);
>> +
>> +		/* EOP header */
>> +		memcpy(skb_put(skb, TX_EOP_SIZE), &info->eop, TX_EOP_SIZE);
>> +
>> +		tx_skb =3D skb;
>> +		skb_unlink(skb, q);
>> +	} else {
>> +		tx_skb =3D alloc_skb(tol_len, GFP_KERNEL);
>
> Are you sure GFP_KERNEL is appropriate here and you don't have
> to use GFP_ATOMIC?
>

Well=E2=80=A6 It's not called from the ISR but rather from a work queue.

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
>> +		       &info->sop, TX_OVERHEAD);
>> +
>> +		/* Packet */
>> +		memcpy(skb_put(tx_skb, ((pkt_len + 3) & 0xFFFC)),
>> +		       skb->data, pkt_len);
>> +
>> +		/* EOP header */
>> +		memcpy(skb_put(tx_skb, TX_EOP_SIZE),
>> +		       &info->eop, TX_EOP_SIZE);
>> +
>> +		skb_unlink(skb, q);
>> +		dev_kfree_skb(skb);
>> +	}
>> +
>> +	entry =3D (struct skb_data *)tx_skb->cb;
>> +	memset(entry, 0, sizeof(*entry));
>> +	entry->len =3D pkt_len;
>> +
>> +	if (netif_msg_pktdata(ax_local)) {
>> +		char pfx[IFNAMSIZ + 7];
>> +
>> +		snprintf(pfx, sizeof(pfx), "%s:     ", ndev->name);
>> +
>> +		netdev_info(ndev, "TX packet len %d, total len %d, seq %d\n",
>> +			    pkt_len, tx_skb->len, seq_num);
>> +
>> +		netdev_info(ndev, "  SPI Header:\n");
>> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
>> +			       tx_skb->data, 4, 0);
>> +
>> +		netdev_info(ndev, "  TX SOP:\n");
>> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
>> +			       tx_skb->data + 4, TX_OVERHEAD, 0);
>> +
>> +		netdev_info(ndev, "  TX packet:\n");
>> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
>> +			       tx_skb->data + 4 + TX_OVERHEAD,
>> +			       tx_skb->len - TX_EOP_SIZE - 4 - TX_OVERHEAD, 0);
>> +
>> +		netdev_info(ndev, "  TX EOP:\n");
>> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
>> +			       tx_skb->data + tx_skb->len - 4, 4, 0);
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
>> +		 (TSNR_TXB_START | TSNR_PKT_CNT(1)), P0_TSNR);
>> +
>> +	axspi_write_txq(&ax_local->ax_spi, tx_skb->data, tx_skb->len);
>> +
>> +	if (((AX_READ(&ax_local->ax_spi, P0_TSNR) & TXNR_TXB_IDLE) =3D=3D 0) ||
>> +	    ((ISR_TXERR & AX_READ(&ax_local->ax_spi, P0_ISR)) !=3D 0)) {
>> +		/* Ack tx error int */
>> +		AX_WRITE(&ax_local->ax_spi, ISR_TXERR, P0_ISR);
>> +
>> +		ax_local->stats.tx_dropped++;
>> +
>> +		netif_err(ax_local, tx_err, ax_local->ndev,
>> +			  "TX FIFO error, re-initialize the TX bridge\n");
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
>> +		netif_err(ax_local, tx_queued, ndev,
>> +			  "Too much TX packets in queue %d\n",
>> +			  skb_queue_len(&ax_local->tx_wait_q));
>> +
>> +		netif_stop_queue(ndev);
>> +	}
>> +
>> +	set_bit(EVENT_TX, &ax_local->flags);
>> +	queue_work(ax_local->ax_work_queue, &ax_local->ax_work);
>> +
>> +	return NETDEV_TX_OK;
>> +}
>> +
>> +static void
>> +ax88796c_skb_return(struct ax88796c_device *ax_local, struct sk_buff *s=
kb,
>> +		    struct rx_header *rxhdr)
>> +{
>> +	struct net_device *ndev =3D ax_local->ndev;
>> +	int status;
>> +
>> +	do {
>> +		if (!(ndev->features & NETIF_F_RXCSUM))
>> +			break;
>> +
>> +		/* checksum error bit is set */
>> +		if ((rxhdr->flags & RX_HDR3_L3_ERR) ||
>> +		    (rxhdr->flags & RX_HDR3_L4_ERR))
>> +			break;
>> +
>> +		/* Other types may be indicated by more than one bit. */
>> +		if ((rxhdr->flags & RX_HDR3_L4_TYPE_TCP) ||
>> +		    (rxhdr->flags & RX_HDR3_L4_TYPE_UDP))
>> +			skb->ip_summed =3D CHECKSUM_UNNECESSARY;
>> +	} while (0);
>
> Why this do {} while(0) construct? If you want to separate this code,
> then put it into its own function.
>
>> +
>> +	ax_local->stats.rx_packets++;
>> +	ax_local->stats.rx_bytes +=3D skb->len;
>> +	skb->dev =3D ndev;
>> +
>> +	skb->truesize =3D skb->len + sizeof(struct sk_buff);
>> +	skb->protocol =3D eth_type_trans(skb, ax_local->ndev);
>> +
>> +	netif_info(ax_local, rx_status, ndev, "< rx, len %zu, type 0x%x\n",
>> +		   skb->len + sizeof(struct ethhdr), skb->protocol);
>> +
>> +	status =3D netif_rx(skb);
>> +	if (status !=3D NET_RX_SUCCESS)
>> +		netif_info(ax_local, rx_err, ndev,
>> +			   "netif_rx status %d\n", status);
>> +}
>> +
>> +static void
>> +ax88796c_rx_fixup(struct ax88796c_device *ax_local, struct sk_buff *rx_=
skb)
>> +{
>> +	struct rx_header *rxhdr =3D (struct rx_header *)rx_skb->data;
>> +	struct net_device *ndev =3D ax_local->ndev;
>> +	u16 len;
>> +
>> +	be16_to_cpus(&rxhdr->flags_len);
>> +	be16_to_cpus(&rxhdr->seq_lenbar);
>> +	be16_to_cpus(&rxhdr->flags);
>> +
>> +	if ((((short)rxhdr->flags_len) & RX_HDR1_PKT_LEN) !=3D
>> +			 (~((short)rxhdr->seq_lenbar) & 0x7FF)) {
>> +		netif_err(ax_local, rx_err, ndev, "Header error\n");
>> +
>> +		ax_local->stats.rx_frame_errors++;
>> +		kfree_skb(rx_skb);
>> +		return;
>> +	}
>> +
>> +	if ((rxhdr->flags_len & RX_HDR1_MII_ERR) ||
>> +	    (rxhdr->flags_len & RX_HDR1_CRC_ERR)) {
>> +		netif_err(ax_local, rx_err, ndev, "CRC or MII error\n");
>> +
>> +		ax_local->stats.rx_crc_errors++;
>> +		kfree_skb(rx_skb);
>> +		return;
>> +	}
>> +
>> +	len =3D rxhdr->flags_len & RX_HDR1_PKT_LEN;
>> +	if (netif_msg_pktdata(ax_local)) {
>> +		char pfx[IFNAMSIZ + 7];
>> +
>> +		snprintf(pfx, sizeof(pfx), "%s:     ", ndev->name);
>> +		netdev_info(ndev, "RX data, total len %d, packet len %d\n",
>> +			    rx_skb->len, len);
>> +
>> +		netdev_info(ndev, "  Dump RX packet header:");
>> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
>> +			       rx_skb->data, sizeof(*rxhdr), 0);
>> +
>> +		netdev_info(ndev, "  Dump RX packet:");
>> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
>> +			       rx_skb->data + sizeof(*rxhdr), len, 0);
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
>
> Also here, sure you don't have to use GFP_ATOMIC?
>

This one, indeed, is inside ISR. Done.

>> +	if (!skb) {
>> +		AX_WRITE(&ax_local->ax_spi, RXBCR1_RXB_DISCARD, P0_RXBCR1);
>> +		return 0;
>> +	}
>> +	entry =3D (struct skb_data *)skb->cb;
>> +
>> +	AX_WRITE(&ax_local->ax_spi, RXBCR1_RXB_START | w_count, P0_RXBCR1);
>> +
>> +	axspi_read_rxq(&ax_local->ax_spi,
>> +		       skb_put(skb, w_count * 2), skb->len);
>> +
>> +	/* Check if rx bridge is idle */
>> +	if ((AX_READ(&ax_local->ax_spi, P0_RXBCR2) & RXBCR2_RXB_IDLE) =3D=3D 0=
) {
>> +		netif_err(ax_local, rx_err, ndev,
>> +			  "Rx Bridge is not idle\n");
>> +		AX_WRITE(&ax_local->ax_spi, RXBCR2_RXB_REINIT, P0_RXBCR2);
>> +
>> +		entry->state =3D rx_err;
>> +	} else {
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
>> +static int ax88796c_process_isr(struct ax88796c_device *ax_local)
>> +{
>> +	u16 isr;
>> +	u8 done =3D 0;
>> +	struct net_device *ndev =3D ax_local->ndev;
>> +
>> +	isr =3D AX_READ(&ax_local->ax_spi, P0_ISR);
>> +	AX_WRITE(&ax_local->ax_spi, isr, P0_ISR);
>> +
>> +	netif_dbg(ax_local, intr, ndev, "  ISR 0x%04x\n", isr);
>> +
>> +	if (isr & ISR_TXERR) {
>> +		netif_dbg(ax_local, intr, ndev, "  TXERR interrupt\n");
>> +		AX_WRITE(&ax_local->ax_spi, TXNR_TXB_REINIT, P0_TSNR);
>> +		ax_local->seq_num =3D 0x1f;
>> +	}
>> +
>> +	if (isr & ISR_TXPAGES) {
>> +		netif_dbg(ax_local, intr, ndev, "  TXPAGES interrupt\n");
>> +		set_bit(EVENT_TX, &ax_local->flags);
>> +	}
>> +
>> +	if (isr & ISR_LINK) {
>> +		netif_dbg(ax_local, intr, ndev, "  Link change interrupt\n");
>> +		phy_mac_interrupt(ax_local->ndev->phydev);
>> +	}
>> +
>> +	if (isr & ISR_RXPKT) {
>> +		netif_dbg(ax_local, intr, ndev, "  RX interrupt\n");
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
>> +	if (!ndev) {
>> +		pr_err("irq %d for unknown device.\n", irq);
>> +		return IRQ_RETVAL(0);
>> +	}
>> +
>> +	disable_irq_nosync(irq);
>> +
>> +	netif_dbg(ax_local, intr, ndev, "Interrupt occurred\n");
>> +
>> +	set_bit(EVENT_INTR, &ax_local->flags);
>> +	queue_work(ax_local->ax_work_queue, &ax_local->ax_work);
>> +
>
> Why not simpy using a threaded interrupt?
> And in general: Why don't you use NAPI in the driver?
>

As I mention in the commit description this is a driver from a vendor
kernel. I am porting it to the mainline. I am willing to make it meet
standards and expectation, but my primary goal was to make it work
reliably without too many changes. If I understand correctly, using
threaded interrupt and getting rid(?) of the work queue means I need to
rework the transmitting code too. I'll be more than happy, if I can
avoid it.

>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static void ax88796c_work(struct work_struct *work)
>> +{
>> +	struct ax88796c_device *ax_local =3D
>> +			container_of(work, struct ax88796c_device, ax_work);
>> +
>> +	mutex_lock(&ax_local->spi_lock);
>> +
>> +	if (test_bit(EVENT_SET_MULTI, &ax_local->flags)) {
>> +		ax88796c_set_hw_multicast(ax_local->ndev);
>> +		clear_bit(EVENT_SET_MULTI, &ax_local->flags);
>> +	}
>> +
>> +	if (test_bit(EVENT_INTR, &ax_local->flags)) {
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
>> +	mutex_unlock(&ax_local->spi_lock);
>> +}
>> +
>> +static struct net_device_stats *ax88796c_get_stats(struct net_device *n=
dev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +
>> +	return &ax_local->stats;
>> +}
>> +
>> +static void ax88796c_handle_link_change(struct net_device *ndev)
>> +{
>> +	if (net_ratelimit())
>> +		phy_print_status(ndev->phydev);
>> +}
>> +
>> +void ax88796c_phy_init(struct ax88796c_device *ax_local)
>> +{
>> +	/* Enable PHY auto-polling */
>> +	AX_WRITE(&ax_local->ax_spi,
>> +		 PCR_PHYID(0x10) | PCR_POLL_EN |
>> +		 PCR_POLL_FLOWCTRL | PCR_POLL_BMCR, P2_PCR);
>> +}
>> +
>> +static int
>> +ax88796c_open(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	int ret;
>> +	unsigned long irq_flag =3D IRQF_SHARED;
>> +
>> +	mutex_lock(&ax_local->spi_lock);
>> +
>> +	ret =3D ax88796c_soft_reset(ax_local);
>> +	if (ret < 0)
>> +		return -ENODEV;
>> +
>> +	ret =3D request_irq(ndev->irq, ax88796c_interrupt,
>> +			  irq_flag, ndev->name, ndev);
>> +	if (ret) {
>> +		netdev_err(ndev, "unable to get IRQ %d (errno=3D%d).\n",
>> +			   ndev->irq, ret);
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
>> +		 AX_READ(&ax_local->ax_spi, P1_RXBSPCR)
>> +		 & ~RXBSPCR_STUF_ENABLE, P1_RXBSPCR);
>> +
>> +	/* Enable RX packet process */
>> +	AX_WRITE(&ax_local->ax_spi, RPPER_RXEN, P1_RPPER);
>> +
>> +	AX_WRITE(&ax_local->ax_spi, AX_READ(&ax_local->ax_spi, P0_FER)
>> +		 | FER_RXEN | FER_TXEN | FER_BSWAP | FER_IRQ_PULL, P0_FER);
>> +
>> +	/* Setup LED mode */
>> +	AX_WRITE(&ax_local->ax_spi,
>> +		 (LCR_LED0_EN | LCR_LED0_DUPLEX | LCR_LED1_EN |
>> +		 LCR_LED1_100MODE), P2_LCR0);
>> +	AX_WRITE(&ax_local->ax_spi,
>> +		 (AX_READ(&ax_local->ax_spi, P2_LCR1) & LCR_LED2_MASK) |
>> +		 LCR_LED2_EN | LCR_LED2_LINK, P2_LCR1);
>> +
>> +	ax88796c_phy_init(ax_local);
>> +
>> +	phy_start(ax_local->ndev->phydev);
>> +
>> +	netif_start_queue(ndev);
>> +
>> +	AX_WRITE(&ax_local->ax_spi, IMR_DEFAULT, P0_IMR);
>> +
>> +	spi_message_init(&ax_local->ax_spi.rx_msg);
>> +
>> +	mutex_unlock(&ax_local->spi_lock);
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
>> +
>> +	netif_stop_queue(ndev);
>> +
>> +	free_irq(ndev->irq, ndev);
>
> This looks racy. I think e.g. you can still get e.g. rx interrupts.
>

Done.

>> +
>> +	phy_stop(ndev->phydev);
>> +
>> +	mutex_lock(&ax_local->spi_lock);
>> +
>> +	AX_WRITE(&ax_local->ax_spi, IMR_MASKALL, P0_IMR);
>> +	ax88796c_free_skb_queue(&ax_local->tx_wait_q);
>> +
>> +	ax88796c_soft_reset(ax_local);
>> +
>> +	mutex_unlock(&ax_local->spi_lock);
>> +	netif_carrier_off(ndev);
>> +
>> +	return 0;
>> +}
>> +
>> +static int
>> +ax88796c_set_features(struct net_device *ndev, netdev_features_t featur=
es)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	netdev_features_t changed =3D features ^ ndev->features;
>> +
>> +	if (!(changed & (NETIF_F_RXCSUM | NETIF_F_HW_CSUM)))
>> +		return 0;
>> +
>> +	ndev->features =3D features;
>> +
>> +	if (changed & (NETIF_F_RXCSUM | NETIF_F_HW_CSUM))
>> +		ax88796c_set_csums(ax_local);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct net_device_ops ax88796c_netdev_ops =3D {
>> +	.ndo_open		=3D ax88796c_open,
>> +	.ndo_stop		=3D ax88796c_close,
>> +	.ndo_start_xmit		=3D ax88796c_start_xmit,
>> +	.ndo_get_stats		=3D ax88796c_get_stats,
>> +	.ndo_do_ioctl		=3D ax88796c_ioctl,
>> +	.ndo_set_mac_address	=3D ax88796c_set_mac_address,
>> +	.ndo_set_features	=3D ax88796c_set_features,
>> +};
>> +
>> +static int ax88796c_hard_reset(struct ax88796c_device *ax_local)
>> +{
>> +	struct device *dev =3D (struct device *)&ax_local->spi->dev;
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
>> +	msleep(20);
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
>> +	SET_NETDEV_DEV(ndev, &spi->dev);
>> +
>> +	ax_local =3D to_ax88796c_device(ndev);
>> +	memset(ax_local, 0, sizeof(*ax_local));
>> +
>> +	dev_set_drvdata(&spi->dev, ax_local);
>> +	ax_local->spi =3D spi;
>> +	ax_local->ax_spi.spi =3D spi;
>> +
>> +	ax_local->ndev =3D ndev;
>> +	ax_local->capabilities |=3D comp ? AX_CAP_COMP : 0;
>> +	ax_local->msg_enable =3D msg_enable;
>> +
>> +	ax_local->mdiobus =3D devm_mdiobus_alloc(&spi->dev);
>> +	if (!ax_local->mdiobus) {
>> +		dev_err(&spi->dev, "Could not allocate MDIO bus\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	ax_local->mdiobus->priv =3D ax_local;
>> +	ax_local->mdiobus->read =3D ax88796c_mdio_read;
>> +	ax_local->mdiobus->write =3D ax88796c_mdio_write;
>> +	ax_local->mdiobus->name =3D "ax88976c-mdiobus";
>> +	ax_local->mdiobus->phy_mask =3D ~(1 << 0x10);
>> +	ax_local->mdiobus->parent =3D &spi->dev;
>> +
>> +	snprintf(ax_local->mdiobus->id, ARRAY_SIZE(ax_local->mdiobus->id),
>> +		 "ax88796c-spi-%s.%u", dev_name(&spi->dev), spi->chip_select);
>> +
>> +	ret =3D devm_mdiobus_register(&spi->dev, ax_local->mdiobus);
>> +	if (ret < 0) {
>> +		dev_err(&spi->dev, "Could not register MDIO bus\n");
>> +		return ret;
>> +	}
>> +
>> +	if (netif_msg_probe(ax_local)) {
>> +		dev_info(&spi->dev, "AX88796C-SPI Configuration:\n");
>> +		dev_info(&spi->dev, "    Compression : %s\n",
>> +			 ax_local->capabilities & AX_CAP_COMP ? "ON" : "OFF");
>> +	}
>> +
>> +	ndev->irq =3D spi->irq;
>> +	ndev->netdev_ops =3D &ax88796c_netdev_ops;
>> +	ndev->ethtool_ops =3D &ax88796c_ethtool_ops;
>> +	ndev->hw_features |=3D NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
>> +	ndev->features |=3D NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
>> +	ndev->hard_header_len +=3D (TX_OVERHEAD + 4);
>> +
>> +	/* ax88796c gpio reset */
>> +	ax88796c_hard_reset(ax_local);
>> +
>> +	/* Reset AX88796C */
>> +	ret =3D ax88796c_soft_reset(ax_local);
>> +	if (ret < 0) {
>> +		ret =3D -ENODEV;
>> +		goto err;
>> +	}
>> +	/* Check board revision */
>> +	temp =3D AX_READ(&ax_local->ax_spi, P2_CRIR);
>> +	if ((temp & 0xF) !=3D 0x0) {
>> +		dev_err(&spi->dev, "spi read failed: %d\n", temp);
>> +		ret =3D -ENODEV;
>> +		goto err;
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
>> +	/*Reload EEPROM*/
>> +	ax88796c_reload_eeprom(ax_local);
>> +
>> +	ax88796c_load_mac_addr(ndev);
>> +
>> +	if (netif_msg_probe(ax_local))
>> +		dev_info(&spi->dev,
>> +			 "irq %d, MAC addr %02X:%02X:%02X:%02X:%02X:%02X\n",
>> +			 ndev->irq,
>> +			 ndev->dev_addr[0], ndev->dev_addr[1],
>> +			 ndev->dev_addr[2], ndev->dev_addr[3],
>> +			 ndev->dev_addr[4], ndev->dev_addr[5]);
>> +
>> +	/* Disable power saving */
>> +	AX_WRITE(&ax_local->ax_spi, (AX_READ(&ax_local->ax_spi, P0_PSCR)
>> +				     & PSCR_PS_MASK) | PSCR_PS_D0, P0_PSCR);
>> +
>> +	INIT_WORK(&ax_local->ax_work, ax88796c_work);
>> +
>> +	ax_local->ax_work_queue =3D
>> +			create_singlethread_workqueue("ax88796c_work");
>> +
>> +	mutex_init(&ax_local->spi_lock);
>> +
>> +	skb_queue_head_init(&ax_local->tx_wait_q);
>> +
>> +	ret =3D devm_register_netdev(&spi->dev, ndev);
>> +	if (ret) {
>> +		dev_err(&spi->dev, "failed to register a network device\n");
>> +		destroy_workqueue(ax_local->ax_work_queue);
>> +		goto err;
>> +	}
>> +
>> +	ax_local->phydev =3D phy_find_first(ax_local->mdiobus);
>> +	if (!ax_local->phydev) {
>> +		dev_err(&spi->dev, "no PHY found\n");
>> +		ret =3D -ENODEV;
>> +		goto err;
>> +	}
>> +
>> +	ax_local->phydev->irq =3D PHY_IGNORE_INTERRUPT;
>> +	phy_connect_direct(ax_local->ndev, ax_local->phydev,
>> +			   ax88796c_handle_link_change,
>> +			   PHY_INTERFACE_MODE_MII);
>> +
>> +	netif_info(ax_local, probe, ndev, "%s %s registered\n",
>> +		   dev_driver_string(&spi->dev),
>> +		   dev_name(&spi->dev));
>> +	phy_attached_info(ax_local->phydev);
>
> Does the integrated PHY provide a proper PHY ID?

Yes.

>=20
> Is there a PHY driver for it or do you rely on the genphy driver?
>

genphy


>> +
>> +	ret =3D 0;
>> +err:
>> +	return ret;
>> +}
>> +
>> +static int ax88796c_remove(struct spi_device *spi)
>> +{
>> +	struct ax88796c_device *ax_local =3D dev_get_drvdata(&spi->dev);
>> +	struct net_device *ndev =3D ax_local->ndev;
>> +
>> +	netif_info(ax_local, probe, ndev, "removing network device %s %s\n",
>> +		   dev_driver_string(&spi->dev),
>> +		   dev_name(&spi->dev));
>> +
>> +	destroy_workqueue(ax_local->ax_work_queue);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct of_device_id ax88796c_dt_ids[] =3D {
>> +	{ .compatible =3D "asix,ax88796c" },
>> +	{},
>> +};
>> +MODULE_DEVICE_TABLE(of, ax88796c_dt_ids);
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
>> +#ifdef CONFIG_USE_OF
>> +		.of_match_table =3D of_match_ptr(ax88796c_dt_ids),
>> +#endif
>> +	},
>> +	.probe =3D ax88796c_probe,
>> +	.remove =3D ax88796c_remove,
>> +	.id_table =3D asix_id,
>> +};
>> +
>> +static __init int ax88796c_spi_init(void)
>> +{
>> +	int ret;
>> +
>> +	bitmap_zero(ax88796c_no_regs_mask, AX88796C_REGDUMP_LEN);
>> +	ret =3D bitmap_parse(no_regs_list, 35,
>> +			   ax88796c_no_regs_mask, AX88796C_REGDUMP_LEN);
>> +	if (ret) {
>> +		bitmap_fill(ax88796c_no_regs_mask, AX88796C_REGDUMP_LEN);
>> +		pr_err("Invalid bitmap description, masking all registers\n");
>> +	}
>> +
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
>> +
>> +MODULE_AUTHOR("ASIX");
>> +MODULE_DESCRIPTION("ASIX AX88796C SPI Ethernet driver");
>> +MODULE_LICENSE("GPL");
>> +
>> +/* ax88796c_phy */
>> diff --git a/drivers/net/ethernet/asix/ax88796c_main.h b/drivers/net/eth=
ernet/asix/ax88796c_main.h
>> new file mode 100644
>> index 000000000000..428833978fbf
>> --- /dev/null
>> +++ b/drivers/net/ethernet/asix/ax88796c_main.h
>> @@ -0,0 +1,568 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
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
>> +#include <linux/netdevice.h>
>> +#include <linux/mii.h>
>> +
>> +#include "ax88796c_spi.h"
>> +
>> +/* These identify the driver base version and may not be removed. */
>> +#define DRV_NAME	"ax88796c"
>> +#define ADP_NAME	"ASIX AX88796C SPI Ethernet Adapter"
>> +#define DRV_VERSION	"1.2.0"
>> +
> An benefit in using a separate driver version? Typically the
> kernel version is sufficient.
>

Removed.

>> +#define TX_QUEUE_HIGH_WATER		45	/* Tx queue high water mark */
>> +#define TX_QUEUE_LOW_WATER		20	/* Tx queue low water mark */
>> +
>> +#define AX88796C_REGDUMP_LEN		256
>> +#define AX88796C_PHY_REGDUMP_LEN	12
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
>> +#define RX_HDR3_L3_TYPE_IPV4V6		0x6000
>> +#define RX_HDR3_L3_TYPE_IP		0x4000
>> +#define RX_HDR3_L3_TYPE_IPV6		0x2000
>> +#define RX_HDR3_L4_TYPE_ICMPV6		0x1400
>> +#define RX_HDR3_L4_TYPE_TCP		0x1000
>> +#define RX_HDR3_L4_TYPE_IGMP		0x0c00
>> +#define RX_HDR3_L4_TYPE_ICMP		0x0800
>> +#define RX_HDR3_L4_TYPE_UDP		0x0400
>> +#define RX_HDR3_L3_ERR			0x0200
>> +#define RX_HDR3_L4_ERR			0x0100
>> +#define RX_HDR3_PRIORITY(x)		((x) << 4)
>> +#define RX_HDR3_STRIP			0x0008
>> +#define RX_HDR3_VLAN_ID			0x0007
>> +
>> +enum watchdog_state {
>> +	chk_link =3D 0,
>> +	chk_cable,
>> +	ax_nop,
>> +};
>> +
>> +struct ax88796c_device {
>> +	struct resource		*addr_res;   /* resources found */
>> +	struct resource		*addr_req;   /* resources requested */
>> +	struct resource		*irq_res;
>> +
>> +	struct spi_device	*spi;
>> +	struct net_device	*ndev;
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
>> +	struct mutex		spi_lock; /* device access */
>> +
>> +	struct sk_buff_head	tx_wait_q;
>> +
>> +	struct axspi_data	ax_spi;
>> +
>> +	struct mii_bus		*mdiobus;
>> +	struct phy_device	*phydev;
>> +
>> +	int			msg_enable;
>> +
>> +	u16			seq_num;
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
>> +		#define EVENT_TX		2
>> +		#define EVENT_SET_MULTI		4
>> +
>> +};
>> +
>> +#define to_ax88796c_device(ndev) ((struct ax88796c_device *)netdev_priv=
(ndev))
>> +
> Is this helper really needed? in The places I've seen you can assign
> the void* pointer returned netdev_priv().
>

As I said, it was not my code. I am porting it and this has worked. It
doesn't look that bad IMHO. Do you think I should change it?

Thanks for the feedback.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl+GB9MACgkQsK4enJil
gBCLJQf9ERCZzTi7KHy2Vx+3DzHWYNfA0RKDRL1OjhJ+MLOFl0InLqz/NFBgTywd
L8mfmvoQWEGTSg9+DRw44H5XTasZdT1epGDmwObVoDfxCGBS/seZGHDKB/jRksSM
krvyd3k3Ky9dCXFJj7PKW1L1+gkLxGhgFf0Q0mfDfNMWUBu6ePCunugC+SG+6KKR
stHBdcj13F9N5ahV+9lPvF5iE9zCANx6yipHLwiliDOhe0kNY1XJe0lW6SXQYI6s
8p0L2rTjIj1wjuCskAob1vSJFrn/FdWRz1kKBkd3F+jzZS3n2/MYkcoRod2ap4ts
JugbYh2WR+hJr7wgMe2+G30mxQoygg==
=2RWJ
-----END PGP SIGNATURE-----
--=-=-=--
