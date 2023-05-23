Return-Path: <netdev+bounces-4570-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 961A870D40E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:36:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9654C281233
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA227483;
	Tue, 23 May 2023 06:36:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF925393
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:36:12 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0D6109
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 23:36:10 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1q1LcH-0005kd-PO; Tue, 23 May 2023 08:35:29 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id 896BB1CA24E;
	Tue, 23 May 2023 06:35:26 +0000 (UTC)
Date: Tue, 23 May 2023 08:35:25 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Judith Mendez <jm@ti.com>
Cc: Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
	linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Schuyler Patton <spatton@ti.com>, Tero Kristo <kristo@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v7 2/2] can: m_can: Add hrtimer to generate software
 interrupt
Message-ID: <20230523-crawlers-cupbearer-7a7cbfed010b-mkl@pengutronix.de>
References: <20230523023749.4526-1-jm@ti.com>
 <20230523023749.4526-3-jm@ti.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="67ou6ygfxbkqgaot"
Content-Disposition: inline
In-Reply-To: <20230523023749.4526-3-jm@ti.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--67ou6ygfxbkqgaot
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22.05.2023 21:37:49, Judith Mendez wrote:
> Add an hrtimer to MCAN class device. Each MCAN will have its own
> hrtimer instantiated if there is no hardware interrupt found in
> device tree M_CAN node.

Please add a sentence why you introduce polling mode, i.e. there are
SoCs where the M_CAN interrupt is not available on the CPUs (which are
running Linux).

> The hrtimer will generate a software interrupt every 1 ms. In
> hrtimer callback, we check if there is a transaction pending by
> reading a register, then process by calling the isr if there is.
>=20
> Signed-off-by: Judith Mendez <jm@ti.com>
> ---
> Changelog:
> v7:
> - Clean up m_can_platform.c if/else section after removing poll-interval
> - Remove poll-interval from patch description
> v6:
> - Move hrtimer stop/start function calls to m_can_open and m_can_close to
> support power suspend/resume
> v5:
> - Change dev_dbg to dev_info if hardware interrupt exists and polling
> is enabled
> v4:
> - No changes
> v3:
> - Create a define for 1 ms polling interval
> - Change plarform_get_irq to optional to not print error msg
> v2:
> - Add functionality to check for 'poll-interval' property in MCAN node=20
> - Add 'polling' flag in driver to check if device is using polling method
> - Check for timer polling and hardware interrupt cases, default to
> hardware interrupt method
> - Change ns_to_ktime() to ms_to_ktime()
> ---
>  drivers/net/can/m_can/m_can.c          | 33 ++++++++++++++++++++++++--
>  drivers/net/can/m_can/m_can.h          |  4 ++++
>  drivers/net/can/m_can/m_can_platform.c | 25 ++++++++++++++++---
>  3 files changed, 57 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index a5003435802b..f273d989bdff 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -11,6 +11,7 @@
>  #include <linux/bitfield.h>
>  #include <linux/can/dev.h>
>  #include <linux/ethtool.h>
> +#include <linux/hrtimer.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/iopoll.h>
> @@ -308,6 +309,9 @@ enum m_can_reg {
>  #define TX_EVENT_MM_MASK	GENMASK(31, 24)
>  #define TX_EVENT_TXTS_MASK	GENMASK(15, 0)
> =20
> +/* Hrtimer polling interval */
> +#define HRTIMER_POLL_INTERVAL		1
> +
>  /* The ID and DLC registers are adjacent in M_CAN FIFO memory,
>   * and we can save a (potentially slow) bus round trip by combining
>   * reads and writes to them.
> @@ -895,7 +899,7 @@ static int m_can_handle_bus_errors(struct net_device =
*dev, u32 irqstatus,
>  			netdev_dbg(dev, "Arbitration phase error detected\n");
>  			work_done +=3D m_can_handle_lec_err(dev, lec);
>  		}
> -	=09
> +

Unrelated change. I've send a separate patch to fix the problem.

>  		if (is_lec_err(dlec)) {
>  			netdev_dbg(dev, "Data phase error detected\n");
>  			work_done +=3D m_can_handle_lec_err(dev, dlec);
> @@ -1414,6 +1418,12 @@ static int m_can_start(struct net_device *dev)
> =20
>  	m_can_enable_all_interrupts(cdev);
> =20
> +	if (cdev->polling) {
> +		dev_dbg(cdev->dev, "Start hrtimer\n");
> +		hrtimer_start(&cdev->hrtimer, ms_to_ktime(HRTIMER_POLL_INTERVAL),
> +			      HRTIMER_MODE_REL_PINNED);
> +	}
> +
>  	return 0;
>  }
> =20
> @@ -1571,6 +1581,11 @@ static void m_can_stop(struct net_device *dev)
>  	/* disable all interrupts */
>  	m_can_disable_all_interrupts(cdev);
> =20
> +	if (cdev->polling) {
> +		dev_dbg(cdev->dev, "Disabling the hrtimer\n");
> +		hrtimer_cancel(&cdev->hrtimer);
> +	}
> +

This might be a racy. Please move the disabling of the hrtimer before
disabling all interrupts. This makes it also symmetric with respect to
m_can_start().

>  	/* Set init mode to disengage from the network */
>  	m_can_config_endisable(cdev, true);
> =20
> @@ -1793,6 +1808,18 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff=
 *skb,
>  	return NETDEV_TX_OK;
>  }
> =20
> +static enum hrtimer_restart hrtimer_callback(struct hrtimer *timer)
> +{
> +	struct m_can_classdev *cdev =3D container_of(timer, struct
> +						   m_can_classdev, hrtimer);
> +
> +	m_can_isr(0, cdev->net);
> +
> +	hrtimer_forward_now(timer, ms_to_ktime(HRTIMER_POLL_INTERVAL));
> +
> +	return HRTIMER_RESTART;
> +}
> +
>  static int m_can_open(struct net_device *dev)
>  {
>  	struct m_can_classdev *cdev =3D netdev_priv(dev);
> @@ -1831,9 +1858,11 @@ static int m_can_open(struct net_device *dev)
>  		err =3D request_threaded_irq(dev->irq, NULL, m_can_isr,
>  					   IRQF_ONESHOT,
>  					   dev->name, dev);
> -	} else {
> +	} else if (!cdev->polling) {
>  		err =3D request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
>  				  dev);
> +	} else {
> +		cdev->hrtimer.function =3D &hrtimer_callback;

I think you can move this assignment to m_can_class_register(). We only
need to set the function once.

>  	}
> =20
>  	if (err < 0) {
> diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
> index a839dc71dc9b..e9db5cce4e68 100644
> --- a/drivers/net/can/m_can/m_can.h
> +++ b/drivers/net/can/m_can/m_can.h
> @@ -15,6 +15,7 @@
>  #include <linux/device.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/freezer.h>
> +#include <linux/hrtimer.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/iopoll.h>
> @@ -93,6 +94,9 @@ struct m_can_classdev {
>  	int is_peripheral;
> =20
>  	struct mram_cfg mcfg[MRAM_CFG_NUM];
> +
> +	struct hrtimer hrtimer;
> +	bool polling;
>  };
> =20
>  struct m_can_classdev *m_can_class_allocate_dev(struct device *dev, int =
sizeof_priv);
> diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_c=
an/m_can_platform.c
> index 94dc82644113..b639c9e645d3 100644
> --- a/drivers/net/can/m_can/m_can_platform.c
> +++ b/drivers/net/can/m_can/m_can_platform.c
> @@ -5,6 +5,7 @@
>  //
>  // Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.=
com/
> =20
> +#include <linux/hrtimer.h>
>  #include <linux/phy/phy.h>
>  #include <linux/platform_device.h>
> =20
> @@ -96,12 +97,30 @@ static int m_can_plat_probe(struct platform_device *p=
dev)
>  		goto probe_fail;
> =20
>  	addr =3D devm_platform_ioremap_resource_byname(pdev, "m_can");
> -	irq =3D platform_get_irq_byname(pdev, "int0");

I think irq will be uninitialized after this change. Although the
compiler doesn't complain :(

BTW: I think we don't need the "polling" variable in the priv. We can
make use of "irq". "irq" being 0 means use polling.

> -	if (IS_ERR(addr) || irq < 0) {
> -		ret =3D -EINVAL;
> +	if (IS_ERR(addr)) {
> +		ret =3D PTR_ERR(addr);
>  		goto probe_fail;
>  	}
> =20
> +	if (device_property_present(mcan_class->dev, "interrupts") ||
> +	    device_property_present(mcan_class->dev, "interrupt-names")) {
> +		irq =3D platform_get_irq_byname(pdev, "int0");
> +		mcan_class->polling =3D false;
> +		if (irq =3D=3D -EPROBE_DEFER) {
> +			ret =3D -EPROBE_DEFER;
> +			goto probe_fail;
> +		}
> +		if (irq < 0) {
> +			ret =3D -ENXIO;

Please return the original error code.

> +			goto probe_fail;
> +		}
> +	} else {
> +		mcan_class->polling =3D true;
> +		dev_dbg(mcan_class->dev, "Polling enabled, initialize hrtimer");
> +		hrtimer_init(&mcan_class->hrtimer, CLOCK_MONOTONIC,
> +			     HRTIMER_MODE_REL_PINNED);
> +	}
> +
>  	/* message ram could be shared */
>  	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "message_ram=
");
>  	if (!res) {

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--67ou6ygfxbkqgaot
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRsXqkACgkQvlAcSiqK
BOhbBgf/d+uyuHexONLa0MOQRZLHVLECCsn8NZn1GBj8h0GwtWS/1NsX3dynWAT3
9vGBtK6yPjKxACpKYy1LYCe8CO/rPl2o3AytAbrGFCNtfHIpulgRzidyPVF17vdR
Gv2Nxj6/PsTiDyi6t61G9lV8bfRqEq8c9d84TMxbaHv7Eb/ILq+Xkpikp/sU3aaY
BcDqwJPWrfoZzcMY9CKqptE74j8qq7mwIYLpEUOwhSHZXttQBuEzOM9s203AnClC
pxdJCfof171hg/UDP4SrlbDUWES08ucXXBz5Uni+LEzOc4e4bTydV1mQ3to4YQuo
9tPnnS6OfXBxv/WS+85+j4umwK4WGw==
=COZk
-----END PGP SIGNATURE-----

--67ou6ygfxbkqgaot--

