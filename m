Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFAD35C395
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 12:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237816AbhDLKTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 06:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237743AbhDLKTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 06:19:01 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE34C06138C
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 03:18:43 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lVte5-0006Xr-Bo; Mon, 12 Apr 2021 12:18:17 +0200
Received: from [IPv6:2a03:f580:87bc:d400:3d5d:9164:44d1:db57] (unknown [IPv6:2a03:f580:87bc:d400:3d5d:9164:44d1:db57])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 6704D60CD20;
        Mon, 12 Apr 2021 10:18:13 +0000 (UTC)
To:     Aswath Govindraju <a-govindraju@ti.com>
Cc:     Vignesh Raghavendra <vigneshr@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Sriram Dash <sriram.dash@samsung.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org
References: <20210409134056.18740-1-a-govindraju@ti.com>
 <20210409134056.18740-3-a-govindraju@ti.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH 2/4] phy: phy-can-transceiver: Add support for generic CAN
 transceiver driver
Message-ID: <fe0a8a9b-35c6-8f23-5968-0b14abb6078d@pengutronix.de>
Date:   Mon, 12 Apr 2021 12:18:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210409134056.18740-3-a-govindraju@ti.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="ViNxBVKByHnvG5KCpPWTrvMkcB8VtWmDP"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ViNxBVKByHnvG5KCpPWTrvMkcB8VtWmDP
Content-Type: multipart/mixed; boundary="497uuTA2eeqwb5jo9Nue446FpEUvvKG5K";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Aswath Govindraju <a-govindraju@ti.com>
Cc: Vignesh Raghavendra <vigneshr@ti.com>,
 Kishon Vijay Abraham I <kishon@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>,
 Grygorii Strashko <grygorii.strashko@ti.com>,
 Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
 Wolfgang Grandegger <wg@grandegger.com>,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Rob Herring <robh+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
 Sriram Dash <sriram.dash@samsung.com>, linux-can@vger.kernel.org,
 netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org
Message-ID: <fe0a8a9b-35c6-8f23-5968-0b14abb6078d@pengutronix.de>
Subject: Re: [PATCH 2/4] phy: phy-can-transceiver: Add support for generic CAN
 transceiver driver
References: <20210409134056.18740-1-a-govindraju@ti.com>
 <20210409134056.18740-3-a-govindraju@ti.com>
In-Reply-To: <20210409134056.18740-3-a-govindraju@ti.com>

--497uuTA2eeqwb5jo9Nue446FpEUvvKG5K
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 4/9/21 3:40 PM, Aswath Govindraju wrote:
> The driver adds support for generic CAN transceivers. Currently
> the modes supported by this driver are standby and normal modes for TI
> TCAN1042 and TCAN1043 CAN transceivers.
>=20
> The transceiver is modelled as a phy with pins controlled by gpios, to =
put
> the transceiver in various device functional modes. It also gets the ph=
y
> attribute max_link_rate for the usage of m_can drivers.

This driver should be independent of CAN driver, so you should not mentio=
n a
specific driver here.

> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
> ---
>  drivers/phy/Kconfig               |   9 ++
>  drivers/phy/Makefile              |   1 +
>  drivers/phy/phy-can-transceiver.c | 140 ++++++++++++++++++++++++++++++=

>  3 files changed, 150 insertions(+)
>  create mode 100644 drivers/phy/phy-can-transceiver.c
>=20
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 54c1f2f0985f..51902b629fc6 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -61,6 +61,15 @@ config USB_LGM_PHY
>  	  interface to interact with USB GEN-II and USB 3.x PHY that is part
>  	  of the Intel network SOC.
> =20
> +config PHY_CAN_TRANSCEIVER
> +	tristate "CAN transceiver PHY"
> +	select GENERIC_PHY
> +	help
> +	  This option enables support for CAN transceivers as a PHY. This
> +	  driver provides function for putting the transceivers in various
> +	  functional modes using gpios and sets the attribute max link
> +	  rate, for mcan drivers.
> +
>  source "drivers/phy/allwinner/Kconfig"
>  source "drivers/phy/amlogic/Kconfig"
>  source "drivers/phy/broadcom/Kconfig"
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index adac1b1a39d1..9c66101c9605 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -9,6 +9,7 @@ obj-$(CONFIG_PHY_LPC18XX_USB_OTG)	+=3D phy-lpc18xx-usb-=
otg.o
>  obj-$(CONFIG_PHY_XGENE)			+=3D phy-xgene.o
>  obj-$(CONFIG_PHY_PISTACHIO_USB)		+=3D phy-pistachio-usb.o
>  obj-$(CONFIG_USB_LGM_PHY)		+=3D phy-lgm-usb.o
> +obj-$(CONFIG_PHY_CAN_TRANSCEIVER)	+=3D phy-can-transceiver.o
>  obj-y					+=3D allwinner/	\
>  					   amlogic/	\
>  					   broadcom/	\
> diff --git a/drivers/phy/phy-can-transceiver.c b/drivers/phy/phy-can-tr=
ansceiver.c
> new file mode 100644
> index 000000000000..14496f6e1666
> --- /dev/null
> +++ b/drivers/phy/phy-can-transceiver.c
> @@ -0,0 +1,140 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * phy-can-transceiver.c - phy driver for CAN transceivers
> + *
> + * Copyright (C) 2021 Texas Instruments Incorporated - http://www.ti.c=
om
> + *
> + */
> +#include<linux/phy/phy.h>
> +#include<linux/platform_device.h>
> +#include<linux/module.h>
> +#include<linux/gpio.h>
> +#include<linux/gpio/consumer.h>
> +
> +struct can_transceiver_data {
> +	u32 flags;
> +#define STB_PRESENT	BIT(0)
> +#define EN_PRESENT	BIT(1)

please add a common prefix to the defines

> +};
> +
> +struct can_transceiver_phy {
> +	struct phy *generic_phy;
> +	struct gpio_desc *standby_gpio;
> +	struct gpio_desc *enable_gpio;
> +};
> +
> +/* Power on function */
> +static int can_transceiver_phy_power_on(struct phy *phy)
> +{
> +	struct can_transceiver_phy *can_transceiver_phy =3D phy_get_drvdata(p=
hy);
> +
> +	if (can_transceiver_phy->standby_gpio)
> +		gpiod_set_value_cansleep(can_transceiver_phy->standby_gpio, 0);
> +	if (can_transceiver_phy->enable_gpio)
> +		gpiod_set_value_cansleep(can_transceiver_phy->enable_gpio, 1);

Please add a newline before the return.

> +	return 0;
> +}
> +
> +/* Power off function */
> +static int can_transceiver_phy_power_off(struct phy *phy)
> +{
> +	struct can_transceiver_phy *can_transceiver_phy =3D phy_get_drvdata(p=
hy);
> +
> +	if (can_transceiver_phy->standby_gpio)
> +		gpiod_set_value_cansleep(can_transceiver_phy->standby_gpio, 1);
> +	if (can_transceiver_phy->enable_gpio)
> +		gpiod_set_value_cansleep(can_transceiver_phy->enable_gpio, 0);

same here

> +	return 0;
> +}
> +
> +static const struct phy_ops can_transceiver_phy_ops =3D {
> +	.power_on	=3D can_transceiver_phy_power_on,
> +	.power_off	=3D can_transceiver_phy_power_off,
> +	.owner		=3D THIS_MODULE,
> +};
> +
> +static const struct can_transceiver_data tcan1042_drvdata =3D {
> +	.flags =3D STB_PRESENT,
> +};
> +
> +static const struct can_transceiver_data tcan1043_drvdata =3D {
> +	.flags =3D STB_PRESENT | EN_PRESENT,
> +};
> +
> +static const struct of_device_id can_transceiver_phy_ids[] =3D {
> +	{
> +		.compatible =3D "ti,tcan1042",
> +		.data =3D &tcan1042_drvdata
> +	},
> +	{
> +		.compatible =3D "ti,tcan1043",
> +		.data =3D &tcan1043_drvdata
> +	},
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, can_transceiver_phy_ids);
> +
> +int can_transceiver_phy_probe(struct platform_device *pdev)
> +{
> +	struct phy_provider *phy_provider;
> +	struct device *dev =3D &pdev->dev;
> +	struct can_transceiver_phy *can_transceiver_phy;
> +	const struct can_transceiver_data *drvdata;
> +	const struct of_device_id *match;
> +	struct phy *phy;
> +	struct gpio_desc *standby_gpio;
> +	struct gpio_desc *enable_gpio;
> +	u32 max_bitrate =3D 0;
> +
> +	can_transceiver_phy =3D devm_kzalloc(dev, sizeof(struct can_transceiv=
er_phy), GFP_KERNEL);

error handling?

> +
> +	match =3D of_match_node(can_transceiver_phy_ids, pdev->dev.of_node);
> +	drvdata =3D match->data;
> +
> +	phy =3D devm_phy_create(dev, dev->of_node,
> +			      &can_transceiver_phy_ops);
> +	if (IS_ERR(phy)) {
> +		dev_err(dev, "failed to create can transceiver phy\n");
> +		return PTR_ERR(phy);
> +	}
> +
> +	device_property_read_u32(dev, "max-bitrate", &max_bitrate);
> +	phy->attrs.max_link_rate =3D max_bitrate / 1000000;

The problem is, there are CAN transceivers with a max of 83.3 kbit/s or 1=
25 kbit/s.

> +	can_transceiver_phy->generic_phy =3D phy;
> +
> +	if (drvdata->flags & STB_PRESENT) {
> +		standby_gpio =3D devm_gpiod_get(dev, "standby",   GPIOD_OUT_LOW);

please use only one space after the ",".
Why do you request the gpio standby low?

> +		if (IS_ERR(standby_gpio))
> +			return PTR_ERR(standby_gpio);
> +		can_transceiver_phy->standby_gpio =3D standby_gpio;
> +	}
> +
> +	if (drvdata->flags & EN_PRESENT) {
> +		enable_gpio =3D devm_gpiod_get(dev, "enable",   GPIOD_OUT_LOW);
> +		if (IS_ERR(enable_gpio))
> +			return PTR_ERR(enable_gpio);
> +		can_transceiver_phy->enable_gpio =3D enable_gpio;
> +	}
> +
> +	phy_set_drvdata(can_transceiver_phy->generic_phy, can_transceiver_phy=
);
> +
> +	phy_provider =3D devm_of_phy_provider_register(dev, of_phy_simple_xla=
te);
> +
> +	return PTR_ERR_OR_ZERO(phy_provider);
> +}
> +
> +static struct platform_driver can_transceiver_phy_driver =3D {
> +	.probe =3D can_transceiver_phy_probe,
> +	.driver =3D {
> +		.name =3D "can-transceiver-phy",
> +		.of_match_table =3D can_transceiver_phy_ids,
> +	},
> +};
> +
> +module_platform_driver(can_transceiver_phy_driver);
> +
> +MODULE_AUTHOR("Faiz Abbas <faiz_abbas@ti.com>");
> +MODULE_AUTHOR("Aswath Govindraju <a-govindraju@ti.com>");
> +MODULE_DESCRIPTION("CAN TRANSCEIVER PHY driver");
> +MODULE_LICENSE("GPL v2");
>=20

marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--497uuTA2eeqwb5jo9Nue446FpEUvvKG5K--

--ViNxBVKByHnvG5KCpPWTrvMkcB8VtWmDP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmB0HmAACgkQqclaivrt
76kRvQf/UeAg/lS+KSt7XRJT/1ygqFlxVjg6mQQMvXPR9pp/fc7x0QrHzQrC6BpY
FSkmJAVUBybGbghVHZXTyEJv3v0IIc1ChpJ/AyeGGKkeYYcF1ILlbxrpeHHwUGDk
0Xu1+YKEhqmGr1+5rTTNaMfLSykv+uwaDmUnYSRQs+FCsqomB1wc9vFl22IqotZ0
QhPyqtwbdoUDO8dQkkPt0q/E9TTYsR57GM/cHX8OYo11nBmcMRoCet/PA6Y5DrZU
f+u8V6sHBFfferTQBhhL886bazjfzBdAJb4XvJUFp2vigHXROntQYLjoInBk05TH
/cGhVa5tbhsHzNSeh67jedVtQfy8PQ==
=CpjJ
-----END PGP SIGNATURE-----

--ViNxBVKByHnvG5KCpPWTrvMkcB8VtWmDP--
