Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C0629F35C
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 18:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgJ2RgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 13:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgJ2Rf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 13:35:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF255C0613D4
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 10:28:01 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kYBi9-0004BG-6C; Thu, 29 Oct 2020 18:27:41 +0100
Received: from [IPv6:2a03:f580:87bc:d400:ff11:c9c6:9242:6723] (unknown [IPv6:2a03:f580:87bc:d400:ff11:c9c6:9242:6723])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits)
         client-signature RSA-PSS (4096 bits))
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id DCB3F585014;
        Thu, 29 Oct 2020 17:27:37 +0000 (UTC)
To:     =?UTF-8?Q?=c5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
        Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?Q?Bart=c5=82omiej_=c5=bbolnierkiewicz?= 
        <b.zolnierkie@samsung.com>
References: <20201028214012.9712-1-l.stelmach@samsung.com>
 <CGME20201028214016eucas1p19d2049a4edb4461b2424358e206dc59c@eucas1p1.samsung.com>
 <20201028214012.9712-4-l.stelmach@samsung.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH v4 3/5] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Message-ID: <69bc0b01-4f97-8c7c-7504-bbcf9c504efa@pengutronix.de>
Date:   Thu, 29 Oct 2020 18:27:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201028214012.9712-4-l.stelmach@samsung.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="XASIWa1aViY7sQMmqRxN20OZTaEZUJ3Aa"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XASIWa1aViY7sQMmqRxN20OZTaEZUJ3Aa
Content-Type: multipart/mixed; boundary="w4kjhPGLFbuTqLc2IfUg8uGvd9hmQcO73";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: =?UTF-8?Q?=c5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
 Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
 Heiner Kallweit <hkallweit1@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Rob Herring <robh+dt@kernel.org>, Kukjin Kim <kgene@kernel.org>,
 Krzysztof Kozlowski <krzk@kernel.org>, Russell King <linux@armlinux.org.uk>,
 netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
 =?UTF-8?Q?Bart=c5=82omiej_=c5=bbolnierkiewicz?= <b.zolnierkie@samsung.com>
Message-ID: <69bc0b01-4f97-8c7c-7504-bbcf9c504efa@pengutronix.de>
Subject: Re: [PATCH v4 3/5] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
References: <20201028214012.9712-1-l.stelmach@samsung.com>
 <CGME20201028214016eucas1p19d2049a4edb4461b2424358e206dc59c@eucas1p1.samsung.com>
 <20201028214012.9712-4-l.stelmach@samsung.com>
In-Reply-To: <20201028214012.9712-4-l.stelmach@samsung.com>

--w4kjhPGLFbuTqLc2IfUg8uGvd9hmQcO73
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 10/28/20 10:40 PM, =C5=81ukasz Stelmach wrote:
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
>=20
> [1] https://www.asix.com.tw/products.php?op=3DpItemdetail&PItemID=3D104=
;65;86&PLine=3D65
> [2] https://git.tizen.org/cgit/profile/common/platform/kernel/linux-3.1=
0-artik/
>=20
> The other ax88796 driver is for NE2000 compatible AX88796L chip. These
> chips are not compatible. Hence, two separate drivers are required.
>=20
> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
> ---
>  MAINTAINERS                                |    6 +
>  drivers/net/ethernet/Kconfig               |    1 +
>  drivers/net/ethernet/Makefile              |    1 +
>  drivers/net/ethernet/asix/Kconfig          |   22 +
>  drivers/net/ethernet/asix/Makefile         |    6 +
>  drivers/net/ethernet/asix/ax88796c_ioctl.c |  197 ++++
>  drivers/net/ethernet/asix/ax88796c_ioctl.h |   26 +
>  drivers/net/ethernet/asix/ax88796c_main.c  | 1144 ++++++++++++++++++++=

>  drivers/net/ethernet/asix/ax88796c_main.h  |  578 ++++++++++
>  drivers/net/ethernet/asix/ax88796c_spi.c   |  111 ++
>  drivers/net/ethernet/asix/ax88796c_spi.h   |   69 ++
>  11 files changed, 2161 insertions(+)
>  create mode 100644 drivers/net/ethernet/asix/Kconfig
>  create mode 100644 drivers/net/ethernet/asix/Makefile
>  create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.c
>  create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.h
>  create mode 100644 drivers/net/ethernet/asix/ax88796c_main.c
>  create mode 100644 drivers/net/ethernet/asix/ax88796c_main.h
>  create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.c
>  create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.h

[...]

> +enum watchdog_state {
> +	chk_link =3D 0,
> +	chk_cable,
> +	ax_nop,
> +};
> +
> +struct ax88796c_device {
> +	struct resource		*addr_res;   /* resources found */
> +	struct resource		*addr_req;   /* resources requested */
> +	struct resource		*irq_res;
> +
> +	struct spi_device	*spi;
> +	struct net_device	*ndev;
> +	struct net_device_stats	stats;
> +
> +	struct timer_list	watchdog;
> +	enum watchdog_state	w_state;
> +	size_t			w_ticks;

are these used?

> +
> +	struct work_struct	ax_work;
> +
> +	struct mutex		spi_lock; /* device access */
> +
> +	struct sk_buff_head	tx_wait_q;
> +
> +	struct axspi_data	ax_spi;
> +
> +	struct mii_bus		*mdiobus;
> +	struct phy_device	*phydev;
> +
> +	int			msg_enable;
> +
> +	u16			seq_num;
> +
> +	u8			multi_filter[AX_MCAST_FILTER_SIZE];
> +
> +	int			link;
> +	int			speed;
> +	int			duplex;
> +	int			pause;
> +	int			asym_pause;
> +	int			flowctrl;
> +		#define AX_FC_NONE		0
> +		#define AX_FC_RX		BIT(0)
> +		#define AX_FC_TX		BIT(1)
> +		#define AX_FC_ANEG		BIT(2)
> +
> +	unsigned long		capabilities;
> +		#define AX_CAP_DMA		BIT(0)
> +		#define AX_CAP_COMP		BIT(1)
> +		#define AX_CAP_BIDIR		BIT(2)
> +
> +	u8			plat_endian;
> +		#define PLAT_LITTLE_ENDIAN	0
> +		#define PLAT_BIG_ENDIAN		1
> +
> +	unsigned long		flags;
> +		#define EVENT_INTR		BIT(0)
> +		#define EVENT_TX		BIT(1)
> +		#define EVENT_SET_MULTI		BIT(2)
> +
> +};
> +
> +#define to_ax88796c_device(ndev) ((struct ax88796c_device *)netdev_pri=
v(ndev))
> +
> +enum skb_state {
> +	illegal =3D 0,
> +	tx_done,
> +	rx_done,
> +	rx_err,
> +};
> +
> +struct skb_data {
> +	enum skb_state state;
> +	struct net_device *ndev;
> +	struct sk_buff *skb;
> +	size_t len;
> +	dma_addr_t phy_addr;

unused?

[...]

> diff --git a/drivers/net/ethernet/asix/ax88796c_spi.c b/drivers/net/eth=
ernet/asix/ax88796c_spi.c
> new file mode 100644
> index 000000000000..1a20bbeb4dc1
> --- /dev/null
> +++ b/drivers/net/ethernet/asix/ax88796c_spi.c
> @@ -0,0 +1,111 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2010 ASIX Electronics Corporation
> + * Copyright (c) 2020 Samsung Electronics Co., Ltd.
> + *
> + * ASIX AX88796C SPI Fast Ethernet Linux driver
> + */
> +
> +#define pr_fmt(fmt)	"ax88796c: " fmt
> +
> +#include <linux/string.h>
> +#include <linux/spi/spi.h>
> +
> +#include "ax88796c_spi.h"
> +
> +/* driver bus management functions */
> +int axspi_wakeup(const struct axspi_data *ax_spi)
> +{
> +	u8 tx_buf;
> +	int ret;
> +
> +	tx_buf =3D AX_SPICMD_EXIT_PWD;	/* OP */
> +	ret =3D spi_write(ax_spi->spi, &tx_buf, 1);

spi_write() needs a DMA safe buffer.

> +	if (ret)
> +		dev_err(&ax_spi->spi->dev, "%s() failed: ret =3D %d\n", __func__, re=
t);
> +	return ret;
> +}
> +
> +int axspi_read_status(const struct axspi_data *ax_spi, struct spi_stat=
us *status)
> +{
> +	u8 tx_buf;
> +	int ret;
> +
> +	/* OP */
> +	tx_buf =3D AX_SPICMD_READ_STATUS;
> +	ret =3D spi_write_then_read(ax_spi->spi, &tx_buf, 1, (u8 *)&status, 3=
);
> +	if (ret)
> +		dev_err(&ax_spi->spi->dev, "%s() failed: ret =3D %d\n", __func__, re=
t);
> +	else
> +		le16_to_cpus(&status->isr);
> +
> +	return ret;
> +}
> +
> +int axspi_read_rxq(struct axspi_data *ax_spi, void *data, int len)
> +{
> +	struct spi_transfer *xfer =3D ax_spi->spi_rx_xfer;
> +	int ret;
> +
> +	memcpy(ax_spi->cmd_buf, rx_cmd_buf, 5);
> +
> +	xfer->tx_buf =3D ax_spi->cmd_buf;
> +	xfer->rx_buf =3D NULL;
> +	xfer->len =3D ax_spi->comp ? 2 : 5;
> +	xfer->bits_per_word =3D 8;
> +	spi_message_add_tail(xfer, &ax_spi->rx_msg);
> +
> +	xfer++;
> +	xfer->rx_buf =3D data;
> +	xfer->tx_buf =3D NULL;
> +	xfer->len =3D len;
> +	xfer->bits_per_word =3D 8;
> +	spi_message_add_tail(xfer, &ax_spi->rx_msg);
> +	ret =3D spi_sync(ax_spi->spi, &ax_spi->rx_msg);
> +	if (ret)
> +		dev_err(&ax_spi->spi->dev, "%s() failed: ret =3D %d\n", __func__, re=
t);
> +
> +	return ret;
> +}
> +
> +int axspi_write_txq(const struct axspi_data *ax_spi, void *data, int l=
en)
> +{
> +	return spi_write(ax_spi->spi, data, len);
> +}
> +
> +u16 axspi_read_reg(const struct axspi_data *ax_spi, u8 reg)
> +{
> +	u8 tx_buf[4];
> +	u16 rx_buf =3D 0;
> +	int ret;
> +	int len =3D ax_spi->comp ? 3 : 4;
> +
> +	tx_buf[0] =3D 0x03;	/* OP code read register */
> +	tx_buf[1] =3D reg;	/* register address */
> +	tx_buf[2] =3D 0xFF;	/* dumy cycle */
> +	tx_buf[3] =3D 0xFF;	/* dumy cycle */
> +	ret =3D spi_write_then_read(ax_spi->spi, tx_buf, len, (u8 *)&rx_buf, =
2);
> +	if (ret)
> +		dev_err(&ax_spi->spi->dev, "%s() failed: ret =3D %d\n", __func__, re=
t);
> +	else
> +		le16_to_cpus(&rx_buf);
> +
> +	return rx_buf;
> +}
> +
> +int axspi_write_reg(const struct axspi_data *ax_spi, u8 reg, u16 value=
)
> +{
> +	u8 tx_buf[4];
> +	int ret;
> +
> +	tx_buf[0] =3D AX_SPICMD_WRITE_REG;	/* OP code read register */
> +	tx_buf[1] =3D reg;			/* register address */
> +	tx_buf[2] =3D value;
> +	tx_buf[3] =3D value >> 8;
> +
> +	ret =3D spi_write(ax_spi->spi, tx_buf, 4);

I think you need DMA safe mem for spi_write().

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--w4kjhPGLFbuTqLc2IfUg8uGvd9hmQcO73--

--XASIWa1aViY7sQMmqRxN20OZTaEZUJ3Aa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAl+a+4UACgkQqclaivrt
76m4WQgAmJO2Mucfu9zwvcLygFvIVigWvSUacWDVehcacR9ntjylqHdXlIKZ4vtx
2dx0BBvr64CxSClQ1bESzQ2dX9Weu/TiYp3nqkz0x8r8OfuWLvj8UifjB+3FB2oX
9BrD1cf8jnYzFM4Lfz0gCy6x3f7GB9ygkFf3jVgkL88bxO67gJn3EgUOWm7dRa/V
CODYNsfooVlWkY1wMygTtz41dPoR4a5+FYdMIGSDoHeSwLnFfc/OqRq2oz2Ym9N3
tLCG9QpW+/vsRtkd4JGkDxE1XU0FAPIAWMKx6X/VtFfL9Ud7Glp7nzwBaYSWxWnq
mV7EA04MQgJTEQ/8HzWPglYOGUDCmA==
=p6VL
-----END PGP SIGNATURE-----

--XASIWa1aViY7sQMmqRxN20OZTaEZUJ3Aa--
