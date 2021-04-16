Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3187F361A2F
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 09:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239213AbhDPG6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 02:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234691AbhDPG6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 02:58:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EE3C06175F
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 23:58:24 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lXIQR-0002Eu-BI; Fri, 16 Apr 2021 08:57:59 +0200
Received: from [IPv6:2a03:f580:87bc:d400:b21a:a98c:8cd:ce9c] (unknown [IPv6:2a03:f580:87bc:d400:b21a:a98c:8cd:ce9c])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id BCC8A60FF93;
        Fri, 16 Apr 2021 06:57:55 +0000 (UTC)
Subject: Re: [PATCH v2 2/2] can: m_can: Add support for transceiver as phy
To:     Aswath Govindraju <a-govindraju@ti.com>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Faiz Abbas <faiz_abbas@ti.com>
References: <20210415154635.30094-1-a-govindraju@ti.com>
 <20210415154635.30094-3-a-govindraju@ti.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <48eb6865-857c-78b4-8fd1-878fcc3da43d@pengutronix.de>
Date:   Fri, 16 Apr 2021 08:57:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210415154635.30094-3-a-govindraju@ti.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="IR4DSMc4fUohNh8mGIVX9vQJxJtDUXfHn"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IR4DSMc4fUohNh8mGIVX9vQJxJtDUXfHn
Content-Type: multipart/mixed; boundary="esjrgWRct3qJVhF8TeT9Ra4cor9vBvAB7";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Aswath Govindraju <a-govindraju@ti.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
 linux-can@vger.kernel.org, netdev@vger.kernel.org,
 Wolfgang Grandegger <wg@grandegger.com>, Rob Herring <robh+dt@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
 Kishon Vijay Abraham I <kishon@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>,
 Vignesh Raghavendra <vigneshr@ti.com>,
 Grygorii Strashko <grygorii.strashko@ti.com>, Faiz Abbas <faiz_abbas@ti.com>
Message-ID: <48eb6865-857c-78b4-8fd1-878fcc3da43d@pengutronix.de>
Subject: Re: [PATCH v2 2/2] can: m_can: Add support for transceiver as phy
References: <20210415154635.30094-1-a-govindraju@ti.com>
 <20210415154635.30094-3-a-govindraju@ti.com>
In-Reply-To: <20210415154635.30094-3-a-govindraju@ti.com>

--esjrgWRct3qJVhF8TeT9Ra4cor9vBvAB7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 4/15/21 5:46 PM, Aswath Govindraju wrote:
> From: Faiz Abbas <faiz_abbas@ti.com>
>=20
> Add support for implementing transceiver node as phy. The max_bitrate i=
s
> obtained by getting a phy attribute.
>=20
> Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
> ---
>  drivers/net/can/m_can/m_can.c          | 10 ++++++++++
>  drivers/net/can/m_can/m_can.h          |  2 ++
>  drivers/net/can/m_can/m_can_platform.c | 13 +++++++++++++
>  3 files changed, 25 insertions(+)
>=20
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_ca=
n.c
> index 34073cd077e4..7d31250446c2 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -21,6 +21,7 @@
>  #include <linux/iopoll.h>
>  #include <linux/can/dev.h>
>  #include <linux/pinctrl/consumer.h>
> +#include <linux/phy/phy.h>
> =20
>  #include "m_can.h"
> =20
> @@ -1514,6 +1515,7 @@ static void m_can_stop(struct net_device *dev)
>  static int m_can_close(struct net_device *dev)
>  {
>  	struct m_can_classdev *cdev =3D netdev_priv(dev);
> +	int err;
> =20
>  	netif_stop_queue(dev);
> =20
> @@ -1536,6 +1538,10 @@ static int m_can_close(struct net_device *dev)
>  	close_candev(dev);
>  	can_led_event(dev, CAN_LED_EVENT_STOP);
> =20
> +	err =3D phy_power_off(cdev->transceiver);
> +	if (err)
> +		return err;
> +
>  	return 0;
>  }
> =20
> @@ -1720,6 +1726,10 @@ static int m_can_open(struct net_device *dev)
>  	struct m_can_classdev *cdev =3D netdev_priv(dev);
>  	int err;
> =20
> +	err =3D phy_power_on(cdev->transceiver);
> +	if (err)
> +		return err;
> +
>  	err =3D m_can_clk_start(cdev);
>  	if (err)
>  		return err;
> diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_ca=
n.h
> index ace071c3e58c..38cad068abad 100644
> --- a/drivers/net/can/m_can/m_can.h
> +++ b/drivers/net/can/m_can/m_can.h
> @@ -28,6 +28,7 @@
>  #include <linux/iopoll.h>
>  #include <linux/can/dev.h>
>  #include <linux/pinctrl/consumer.h>
> +#include <linux/phy/phy.h>
> =20
>  /* m_can lec values */
>  enum m_can_lec_type {
> @@ -82,6 +83,7 @@ struct m_can_classdev {
>  	struct workqueue_struct *tx_wq;
>  	struct work_struct tx_work;
>  	struct sk_buff *tx_skb;
> +	struct phy *transceiver;
> =20
>  	struct can_bittiming_const *bit_timing;
>  	struct can_bittiming_const *data_timing;
> diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m=
_can/m_can_platform.c
> index 599de0e08cd7..82d4f1a15dd7 100644
> --- a/drivers/net/can/m_can/m_can_platform.c
> +++ b/drivers/net/can/m_can/m_can_platform.c
> @@ -6,6 +6,7 @@
>  // Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.t=
i.com/
> =20
>  #include <linux/platform_device.h>
> +#include <linux/phy/phy.h>
> =20
>  #include "m_can.h"
> =20
> @@ -67,6 +68,7 @@ static int m_can_plat_probe(struct platform_device *p=
dev)
>  	struct resource *res;
>  	void __iomem *addr;
>  	void __iomem *mram_addr;
> +	struct phy *transceiver;
>  	int irq, ret =3D 0;
> =20
>  	mcan_class =3D m_can_class_allocate_dev(&pdev->dev,
> @@ -101,6 +103,16 @@ static int m_can_plat_probe(struct platform_device=
 *pdev)
>  		goto probe_fail;
>  	}
> =20
> +	transceiver =3D devm_phy_optional_get(&pdev->dev, NULL);
> +	if (IS_ERR(transceiver)) {
> +		ret =3D PTR_ERR(transceiver);
> +		dev_err(&pdev->dev, "error while getting phy, err=3D%d\n", ret);

please use dev_err_probe(), as the probing might be deferred and this is =
not an
error.

> +		return ret;
> +	}
> +
> +	if (transceiver)
> +		priv->cdev.can.bitrate_max =3D transceiver->attrs.max_link_rate;
> +
>  	priv->base =3D addr;
>  	priv->mram_base =3D mram_addr;
> =20
> @@ -108,6 +120,7 @@ static int m_can_plat_probe(struct platform_device =
*pdev)
>  	mcan_class->pm_clock_support =3D 1;
>  	mcan_class->can.clock.freq =3D clk_get_rate(mcan_class->cclk);
>  	mcan_class->dev =3D &pdev->dev;
> +	mcan_class->transceiver =3D transceiver;
> =20
>  	mcan_class->ops =3D &m_can_plat_ops;
> =20
>=20

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--esjrgWRct3qJVhF8TeT9Ra4cor9vBvAB7--

--IR4DSMc4fUohNh8mGIVX9vQJxJtDUXfHn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmB5NXAACgkQqclaivrt
76nj9Af/TXX+wO0iBN6ayh6oYbeW5wgvdVc32H75shC4IH6n9/6Bx7EoB/QtHn6j
0g1KQJw1QC/USvo4QBbKGImABeawzEwtzpiSpP+H6IzDvvzFjZatI7/sl8BlVAPr
aPYUZ/nZ5FgGi7BgEf12gqamgH4ePhbCKJty9v5Hr0FtUAyqanBBoAL7vS7cV47j
RafsqGT0fByKKUahNlmVAKSjwHTAsogcquYZehP6NWB8uhqYhVhekk4myo2YTzwP
OlVC9I4rWhOOfQP29Fh3TS1ECNdI079PWpmRaMZHOSswdwrTjXUkstZ0DawGE6rp
+HZEhhJY/YiazpCeNicgSMhzkyJA6g==
=FQ/6
-----END PGP SIGNATURE-----

--IR4DSMc4fUohNh8mGIVX9vQJxJtDUXfHn--
