Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C952D29F8D0
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 00:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgJ2XDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 19:03:12 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49438 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgJ2XDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 19:03:08 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201029230209euoutp02495a948065ef4777ba48855853a327af~CmOWeJaas2504625046euoutp02x;
        Thu, 29 Oct 2020 23:02:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201029230209euoutp02495a948065ef4777ba48855853a327af~CmOWeJaas2504625046euoutp02x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1604012529;
        bh=cmHJ39G3brso5mTbjmWtYo2yyYMmHlg0nAEXN4TjLro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YjKlzOaQxXPiIZJnErKRbZNz1fT5R7yQ67nkUnZkji5+mu7lpTCnkFA3Vkhonkf7g
         wkG42bhcABFuNu8a+Y+mMrJe7WJUF8MNWSYkKXZHfaKjSfCMirEw+NDqmd3FXC2cWt
         YR3roOJ374tB697ewzdVWS1wqdmFStJFvsR7P4mc=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201029230203eucas1p1e419ebe87dba48e123b6180c6582444d~CmORh8QjW2253522535eucas1p1Z;
        Thu, 29 Oct 2020 23:02:03 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 50.8C.06456.BE94B9F5; Thu, 29
        Oct 2020 23:02:03 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201029230203eucas1p1d496586b195f2c01f1e5f69739c5ddfe~CmOQt7PDH2253622536eucas1p1N;
        Thu, 29 Oct 2020 23:02:03 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201029230203eusmtrp1cf15cb5a32ac861a8c575a9f67991824~CmOQtESa31656616566eusmtrp1T;
        Thu, 29 Oct 2020 23:02:03 +0000 (GMT)
X-AuditID: cbfec7f2-7efff70000001938-d4-5f9b49ebb3e2
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id EA.97.06017.AE94B9F5; Thu, 29
        Oct 2020 23:02:02 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201029230202eusmtip1ec4d22d6f841e9d4488ae5202ea87584~CmOQgc4TN0419304193eusmtip1t;
        Thu, 29 Oct 2020 23:02:02 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?utf-8?Q?Bart=C5=82omiej?= =?utf-8?Q?_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v4 3/5] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Date:   Fri, 30 Oct 2020 00:01:43 +0100
In-Reply-To: <69bc0b01-4f97-8c7c-7504-bbcf9c504efa@pengutronix.de> (Marc
        Kleine-Budde's message of "Thu, 29 Oct 2020 18:27:33 +0100")
Message-ID: <dleftjd010vdpk.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se1BMURzH5+y9d/eWLqcV/aaMx04GGRvjdYy38bj9YbyGwQy1dKeMdmt2
        K2WSPCKJ2FraytBqpExt1raqkWGtjMJFpvEojFcpSYrBCN0uM/77/M7v+/ue7+/MYSn1PmUA
        u80QJxgNumiN0pt21X0XJ3WE5odNfrhnOhFb3BS5mGtnSIG4nyanPfcYYuvKZUhTZzNDsl53
        UEQUK1TkvusoQxyvmxjSWFOgJLniVQVxW2oRKfO0qIjdlkOTujPDSVqtR7XAl29sekDxzpIn
        Cr46r0XFO0oPKflLRbv56qoeBZ/VN5k/6ixFfI9j5Eqvjd5zIoTobQmCMWReuHeU/dHK2I9L
        EmsddVQqcpMM5MUCngZtORV0BvJm1fg8guZKUSkXvQgKU6uRXPQgeNVpVvwb6bJaBliNixHc
        uRkni1oR2G487W+wrBJroaxsvaTxw8HwrPuyUmIK99KQVhIu8VC8DjzdlSqJaTwWin9cpyQf
        L3wQgXjpMJJ8ODwTThbGSppheBY4214M6DnsC7etb2jZUw9W8cNAUMBOFszP0pEcdDE8L//K
        yDwU2m85VTKPgIbsTFryB7wbss0z5NlMBK6Cb7SsmQ3N934oZc1CqKlfI+NgeNzpK187GMyu
        k5R8zEH6AbU8GATlWVf+mgTAkfbzf8PwcH2PFEZ6KQuCvZ37qGNodN5/2+T9t01evy2FJ4C9
        JkQ+ngjnCjsomedCeXkXfQYxpchfiDfpIwXTFIOwQ2vS6U3xhkjt1hi9A/V/x4Zftz5XoS8P
        t7gRZpHGh1swKj9MzegSTEl6Nwrqd3pVceE+CqANMQZB48ctutuwWc1F6JJ2CsaYMGN8tGBy
        o0CW1vhzU23vN6lxpC5O2C4IsYLxX1fBegWkotV79cn2x+lj9Ls2VQZiH8sJV/snV6a1pKdv
        ibXg7ISN/hmeVVbbjENPX+q5URHUNa5o2dp3Kw6v+T0oKbA+e1xryDF3Xdb4+oT5+aeoQZYU
        X+2Q4ynD08aH/lya/isjdbsz8c5y8sRvjMoZGLxBoY3rSyYHp603n/IxvF18ojUkKlFDm6J0
        U4Ipo0n3B2iAmh+WAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t/xu7qvPGfHGyy7YGNx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2qx6fE1VovLu+awWcw4v4/J
        4tDUvYwWa4/cZbdYv2gKi8WxBWIWrXuPsDsIely+dpHZY8vKm0weO2fdZffYtKqTzWPzknqP
        nTs+M3n0/zXw6NuyitHj8ya5AM4oPZui/NKSVIWM/OISW6VoQwsjPUNLCz0jE0s9Q2PzWCsj
        UyV9O5uU1JzMstQifbsEvYz1VwIK3rlW7N10jLmB8ZBFFyMnh4SAicT7mVOZuhi5OIQEljJK
        ND3dz9rFyAGUkJJYOTcdokZY4s+1LjaImqeMEucPtDCB1LAJ6EmsXRsBUiMioCVx++N2sBpm
        ge8sEhdOXmIBSQgLhEgsOniDEcQWEnCUaNp9nx3EZhFQlVj+6yAzSAOnQDvQ0M3djCBDeQXM
        JaYvLACpERWwlNjyAqKeV0BQ4uTMJ2AzmQWyJb6ufs48gVFgFpLULCSpWUCTmAU0Jdbv0ocI
        a0ssW/iaGcK2lVi37j3LAkbWVYwiqaXFuem5xUZ6xYm5xaV56XrJ+bmbGIHRve3Yzy07GLve
        BR9iFOBgVOLhdZCfHS/EmlhWXJl7iFEFaMyjDasvMEqx5OXnpSqJ8DqdPR0nxJuSWFmVWpQf
        X1Sak1p8iNEU6M+JzFKiyfnAhJRXEm9oamhuYWlobmxubGahJM7bIXAwRkggPbEkNTs1tSC1
        CKaPiYNTqoExcrP+ui7m1+3fVLNYMjuv5leyRf4Vf6Jr2tl1PXjBLPZpTBP0XNWfR7rEHdn4
        yKDima1L+VsOo1PaH46mfb43RePUinybbl7rpRs/OqfH9Uh/NjKtmbLX+FBK0t6IzqjtYX2N
        /sssi95Mi9h/4uZpgXf7fmWe7SucZ8vu8Cz9AsuhtfbTrfqUWIozEg21mIuKEwFiNfraEAMA
        AA==
X-CMS-MailID: 20201029230203eucas1p1d496586b195f2c01f1e5f69739c5ddfe
X-Msg-Generator: CA
X-RootMTR: 20201029230203eucas1p1d496586b195f2c01f1e5f69739c5ddfe
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201029230203eucas1p1d496586b195f2c01f1e5f69739c5ddfe
References: <69bc0b01-4f97-8c7c-7504-bbcf9c504efa@pengutronix.de>
        <CGME20201029230203eucas1p1d496586b195f2c01f1e5f69739c5ddfe@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-10-29 czw 18:27>, when Marc Kleine-Budde wrote:
> On 10/28/20 10:40 PM, =C5=81ukasz Stelmach wrote:
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
>> https://protect2.fireeye.com/v1/url?k=3D9aaa9891-c7611faf-9aab13de-0cc47=
a31309a-7f8f6d6347765df4&q=3D1&e=3D78d1d40c-ff31-47e7-91fd-0c29963c1913&u=
=3Dhttps%3A%2F%2Fwww.asix.com.tw%2Fproducts.php%3Fop%3DpItemdetail%26PItemI=
D%3D104%3B65%3B86%26PLine%3D65
>> [2]
>> https://protect2.fireeye.com/v1/url?k=3D407e4fb6-1db5c888-407fc4f9-0cc47=
a31309a-aaf46a5c37be27ea&q=3D1&e=3D78d1d40c-ff31-47e7-91fd-0c29963c1913&u=
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
>>  drivers/net/ethernet/asix/Kconfig          |   22 +
>>  drivers/net/ethernet/asix/Makefile         |    6 +
>>  drivers/net/ethernet/asix/ax88796c_ioctl.c |  197 ++++
>>  drivers/net/ethernet/asix/ax88796c_ioctl.h |   26 +
>>  drivers/net/ethernet/asix/ax88796c_main.c  | 1144 ++++++++++++++++++++
>>  drivers/net/ethernet/asix/ax88796c_main.h  |  578 ++++++++++
>>  drivers/net/ethernet/asix/ax88796c_spi.c   |  111 ++
>>  drivers/net/ethernet/asix/ax88796c_spi.h   |   69 ++
>>  11 files changed, 2161 insertions(+)
>>  create mode 100644 drivers/net/ethernet/asix/Kconfig
>>  create mode 100644 drivers/net/ethernet/asix/Makefile
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.c
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.h
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_main.c
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_main.h
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.c
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.h
>
> [...]
>
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
>
> are these used?
>

Nope. Removed. Thanks.

>> +
>> +	struct work_struct	ax_work;
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
>> +	int			link;
>> +	int			speed;
>> +	int			duplex;
>> +	int			pause;
>> +	int			asym_pause;
>> +	int			flowctrl;
>> +		#define AX_FC_NONE		0
>> +		#define AX_FC_RX		BIT(0)
>> +		#define AX_FC_TX		BIT(1)
>> +		#define AX_FC_ANEG		BIT(2)
>> +
>> +	unsigned long		capabilities;
>> +		#define AX_CAP_DMA		BIT(0)
>> +		#define AX_CAP_COMP		BIT(1)
>> +		#define AX_CAP_BIDIR		BIT(2)
>> +
>> +	u8			plat_endian;
>> +		#define PLAT_LITTLE_ENDIAN	0
>> +		#define PLAT_BIG_ENDIAN		1
>> +
>> +	unsigned long		flags;
>> +		#define EVENT_INTR		BIT(0)
>> +		#define EVENT_TX		BIT(1)
>> +		#define EVENT_SET_MULTI		BIT(2)
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
>> +struct skb_data {
>> +	enum skb_state state;
>> +	struct net_device *ndev;
>> +	struct sk_buff *skb;
>> +	size_t len;
>> +	dma_addr_t phy_addr;
>
> unused?
>
> [...]
>

Ditto.

>> diff --git a/drivers/net/ethernet/asix/ax88796c_spi.c b/drivers/net/ethe=
rnet/asix/ax88796c_spi.c
>> new file mode 100644
>> index 000000000000..1a20bbeb4dc1
>> --- /dev/null
>> +++ b/drivers/net/ethernet/asix/ax88796c_spi.c
>> @@ -0,0 +1,111 @@
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
>> +#include <linux/string.h>
>> +#include <linux/spi/spi.h>
>> +
>> +#include "ax88796c_spi.h"
>> +
>> +/* driver bus management functions */
>> +int axspi_wakeup(const struct axspi_data *ax_spi)
>> +{
>> +	u8 tx_buf;
>> +	int ret;
>> +
>> +	tx_buf =3D AX_SPICMD_EXIT_PWD;	/* OP */
>> +	ret =3D spi_write(ax_spi->spi, &tx_buf, 1);
>
> spi_write() needs a DMA safe buffer.
>

Done.

>> +	if (ret)
>> +		dev_err(&ax_spi->spi->dev, "%s() failed: ret =3D %d\n", __func__, ret=
);
>> +	return ret;
>> +}
>> +
>> +int axspi_read_status(const struct axspi_data *ax_spi, struct spi_statu=
s *status)
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
>> +
>> +	return ret;
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
>> +int axspi_write_txq(const struct axspi_data *ax_spi, void *data, int le=
n)
>> +{
>> +	return spi_write(ax_spi->spi, data, len);
>> +}
>> +
>> +u16 axspi_read_reg(const struct axspi_data *ax_spi, u8 reg)
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
>> +int axspi_write_reg(const struct axspi_data *ax_spi, u8 reg, u16 value)
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
>
> I think you need DMA safe mem for spi_write().

"Moved" the bufferers to axspi_data struct.

Thank you.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl+bSdcACgkQsK4enJil
gBBljwf+M08hEkUrZDXXIf061PUhb7V8h/nITQ8cw2vX7Mc8QIYfsVkhv0AvhOCD
bjokryjUCds1u8nDax3tvmQRpbURe1Lhnvr4k/CKRvEdNIUB8sU55pr7FSL3GAu8
i0E0KO7L0/TX3e9cJGx8g4C9auLvLCemrtbxiYg+Fpcay+lQrd3dlvZhQ5yL1GPJ
dWxOYH3h0kf7qbWQ0YbpI3POlLJVM6S3D6ylPh6CVjr9NTO97nqtdL4ndNOHLb8u
TszGZBVkeeUDm6GUtpf4Q8OodmekWhR/OabRdl//oXnQ8fCIdguzC5parOdvFzLv
QjnDHuIBffTLKsJWOvyeAfZIsJoq0w==
=aIxF
-----END PGP SIGNATURE-----
--=-=-=--
