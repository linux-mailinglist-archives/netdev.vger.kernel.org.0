Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0DB328FDEB
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 08:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390705AbgJPGAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 02:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390609AbgJPGAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 02:00:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C86C0613CF
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 23:00:08 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kTImR-0004Pz-VE; Fri, 16 Oct 2020 07:59:56 +0200
Received: from [IPv6:2a03:f580:87bc:d400:c4e8:c8ff:a41:29c1] (unknown [IPv6:2a03:f580:87bc:d400:c4e8:c8ff:a41:29c1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 39AC257A55E;
        Fri, 16 Oct 2020 05:59:54 +0000 (UTC)
To:     Joakim Zhang <qiangqing.zhang@nxp.com>, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        peng.fan@nxp.com, linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201016134320.20321-1-qiangqing.zhang@nxp.com>
 <20201016134320.20321-6-qiangqing.zhang@nxp.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH 5/6] can: flexcan: add CAN wakeup function for i.MX8QM
Message-ID: <f201e24c-18b9-513a-c4be-6bc4057f4530@pengutronix.de>
Date:   Fri, 16 Oct 2020 07:59:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201016134320.20321-6-qiangqing.zhang@nxp.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="PZK8cbRawmzK1LUDyAIUwZWbLaSvVSR9H"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PZK8cbRawmzK1LUDyAIUwZWbLaSvVSR9H
Content-Type: multipart/mixed; boundary="jLO36DgfLZpGg0nWH6VsxfAtZq7zVZx7u";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Joakim Zhang <qiangqing.zhang@nxp.com>, robh+dt@kernel.org,
 shawnguo@kernel.org, s.hauer@pengutronix.de
Cc: kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
 peng.fan@nxp.com, linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
 netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <f201e24c-18b9-513a-c4be-6bc4057f4530@pengutronix.de>
Subject: Re: [PATCH 5/6] can: flexcan: add CAN wakeup function for i.MX8QM
References: <20201016134320.20321-1-qiangqing.zhang@nxp.com>
 <20201016134320.20321-6-qiangqing.zhang@nxp.com>
In-Reply-To: <20201016134320.20321-6-qiangqing.zhang@nxp.com>

--jLO36DgfLZpGg0nWH6VsxfAtZq7zVZx7u
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 10/16/20 3:43 PM, Joakim Zhang wrote:
> The System Controller Firmware (SCFW) is a low-level system function
> which runs on a dedicated Cortex-M core to provide power, clock, and
> resource management. It exists on some i.MX8 processors. e.g. i.MX8QM
> (QM, QP), and i.MX8QX (QXP, DX). SCU driver manages the IPC interface
> between host CPU and the SCU firmware running on M4.
>=20
> For i.MX8QM, stop mode request is controlled by System Controller Unit(=
SCU)
> firmware, this patch introduces FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW quir=
k
> for this function.
>=20
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  drivers/net/can/flexcan.c | 125 ++++++++++++++++++++++++++++++++------=

>  1 file changed, 107 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
> index e708e7bf28db..a55ea8f27f7c 100644
> --- a/drivers/net/can/flexcan.c
> +++ b/drivers/net/can/flexcan.c
> @@ -9,6 +9,7 @@
>  //
>  // Based on code originally by Andrey Volkov <avolkov@varma-el.com>
> =20
> +#include <dt-bindings/firmware/imx/rsrc.h>
>  #include <linux/bitfield.h>
>  #include <linux/can.h>
>  #include <linux/can/dev.h>
> @@ -17,6 +18,7 @@
>  #include <linux/can/rx-offload.h>
>  #include <linux/clk.h>
>  #include <linux/delay.h>
> +#include <linux/firmware/imx/sci.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/mfd/syscon.h>
> @@ -242,6 +244,8 @@
>  #define FLEXCAN_QUIRK_SUPPORT_FD BIT(9)
>  /* support memory detection and correction */
>  #define FLEXCAN_QUIRK_SUPPORT_ECC BIT(10)
> +/* Setup stop mode with SCU firmware to support wakeup */
> +#define FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW BIT(11)
> =20
>  /* Structure of the message buffer */
>  struct flexcan_mb {
> @@ -347,6 +351,7 @@ struct flexcan_priv {
>  	u8 mb_count;
>  	u8 mb_size;
>  	u8 clk_src;	/* clock source of CAN Protocol Engine */
> +	u8 can_idx;
> =20
>  	u64 rx_mask;
>  	u64 tx_mask;
> @@ -358,6 +363,9 @@ struct flexcan_priv {
>  	struct regulator *reg_xceiver;
>  	struct flexcan_stop_mode stm;
> =20
> +	/* IPC handle when setup stop mode by System Controller firmware(scfw=
) */
> +	struct imx_sc_ipc *sc_ipc_handle;
> +
>  	/* Read and Write APIs */
>  	u32 (*read)(void __iomem *addr);
>  	void (*write)(u32 val, void __iomem *addr);
> @@ -387,7 +395,7 @@ static const struct flexcan_devtype_data fsl_imx6q_=
devtype_data =3D {
>  static const struct flexcan_devtype_data fsl_imx8qm_devtype_data =3D {=

>  	.quirks =3D FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_R=
RS |
>  		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
> -		FLEXCAN_QUIRK_SUPPORT_FD,
> +		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW,
>  };
> =20
>  static struct flexcan_devtype_data fsl_imx8mp_devtype_data =3D {
> @@ -546,18 +554,46 @@ static void flexcan_enable_wakeup_irq(struct flex=
can_priv *priv, bool enable)
>  	priv->write(reg_mcr, &regs->mcr);
>  }
> =20
> +static int flexcan_stop_mode_enable_scfw(struct flexcan_priv *priv, bo=
ol enabled)
> +{
> +	u8 idx =3D priv->can_idx;
> +	u32 rsrc_id, val;
> +
> +	if (idx =3D=3D 0)
> +		rsrc_id =3D IMX_SC_R_CAN_0;
> +	else if (idx =3D=3D 1)
> +		rsrc_id =3D IMX_SC_R_CAN_1;
> +	else
> +		rsrc_id =3D IMX_SC_R_CAN_2;
> +
> +	if (enabled)
> +		val =3D 1;
> +	else
> +		val =3D 0;
> +
> +	/* stop mode request via scu firmware */
> +	return imx_sc_misc_set_control(priv->sc_ipc_handle, rsrc_id, IMX_SC_C=
_IPG_STOP, val);
> +}
> +
>  static inline int flexcan_enter_stop_mode(struct flexcan_priv *priv)
>  {
>  	struct flexcan_regs __iomem *regs =3D priv->regs;
>  	u32 reg_mcr;
> +	int ret;
> =20
>  	reg_mcr =3D priv->read(&regs->mcr);
>  	reg_mcr |=3D FLEXCAN_MCR_SLF_WAK;
>  	priv->write(reg_mcr, &regs->mcr);
> =20
>  	/* enable stop request */
> -	regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
> -			   1 << priv->stm.req_bit, 1 << priv->stm.req_bit);
> +	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW) =
{
> +		ret =3D flexcan_stop_mode_enable_scfw(priv, true);
> +		if (ret < 0)
> +			return ret;
> +	} else {
> +		regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
> +				   1 << priv->stm.req_bit, 1 << priv->stm.req_bit);
> +	}
> =20
>  	return flexcan_low_power_enter_ack(priv);
>  }
> @@ -566,10 +602,17 @@ static inline int flexcan_exit_stop_mode(struct f=
lexcan_priv *priv)
>  {
>  	struct flexcan_regs __iomem *regs =3D priv->regs;
>  	u32 reg_mcr;
> +	int ret;
> =20
>  	/* remove stop request */
> -	regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
> -			   1 << priv->stm.req_bit, 0);
> +	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW) =
{
> +		ret =3D flexcan_stop_mode_enable_scfw(priv, false);
> +		if (ret < 0)
> +			return ret;
> +	} else {
> +		regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
> +				   1 << priv->stm.req_bit, 0);
> +	}
> =20
>  	reg_mcr =3D priv->read(&regs->mcr);
>  	reg_mcr &=3D ~FLEXCAN_MCR_SLF_WAK;
> @@ -1838,7 +1881,7 @@ static void unregister_flexcandev(struct net_devi=
ce *dev)
>  	unregister_candev(dev);
>  }
> =20
> -static int flexcan_setup_stop_mode(struct platform_device *pdev)
> +static int flexcan_setup_stop_mode_gpr(struct platform_device *pdev)
>  {
>  	struct net_device *dev =3D platform_get_drvdata(pdev);
>  	struct device_node *np =3D pdev->dev.of_node;
> @@ -1883,11 +1926,6 @@ static int flexcan_setup_stop_mode(struct platfo=
rm_device *pdev)
>  		"gpr %s req_gpr=3D0x02%x req_bit=3D%u\n",
>  		gpr_np->full_name, priv->stm.req_gpr, priv->stm.req_bit);
> =20
> -	device_set_wakeup_capable(&pdev->dev, true);
> -
> -	if (of_property_read_bool(np, "wakeup-source"))
> -		device_set_wakeup_enable(&pdev->dev, true);
> -
>  	return 0;
> =20
>  out_put_node:
> @@ -1895,6 +1933,56 @@ static int flexcan_setup_stop_mode(struct platfo=
rm_device *pdev)
>  	return ret;
>  }
> =20
> +static int flexcan_setup_stop_mode_scfw(struct platform_device *pdev)
> +{
> +	struct net_device *dev =3D platform_get_drvdata(pdev);
> +	struct flexcan_priv *priv;
> +	int ret;
> +
> +	priv =3D netdev_priv(dev);
> +
> +	/* this function could be defer probe, return -EPROBE_DEFER */
> +	ret =3D imx_scu_get_handle(&priv->sc_ipc_handle);
> +	if (ret < 0)
> +		dev_dbg(&pdev->dev, "get ipc handle used by SCU failed\n");
> +
> +	return ret;
> +}
> +
> +/* flexcan_setup_stop_mode - Setup stop mode
> + *
> + * Return: 0 setup stop mode successfully or doesn't support this feat=
ure
> + *         -EPROBE_DEFER defer probe
> + *         < 0 fail to setup stop mode
> + */
> +static int flexcan_setup_stop_mode(struct platform_device *pdev)
> +{
> +	struct net_device *dev =3D platform_get_drvdata(pdev);
> +	struct flexcan_priv *priv;
> +	int ret;
> +
> +	priv =3D netdev_priv(dev);
> +
> +	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW)
> +		ret =3D flexcan_setup_stop_mode_scfw(pdev);
> +	else if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_G=
PR)
> +		ret =3D flexcan_setup_stop_mode_gpr(pdev);
> +	else
> +		/* return 0 directly if stop mode is unsupport */
> +		return 0;
> +
> +	if (ret) {
> +		dev_warn(&pdev->dev, "failed to setup stop mode\n");
> +	} else {
> +		device_set_wakeup_capable(&pdev->dev, true);
> +
> +		if (of_property_read_bool(pdev->dev.of_node, "wakeup-source"))
> +			device_set_wakeup_enable(&pdev->dev, true);
> +	}
> +
> +	return ret;
> +}
> +
>  static const struct of_device_id flexcan_of_match[] =3D {
>  	{ .compatible =3D "fsl,imx8qm-flexcan", .data =3D &fsl_imx8qm_devtype=
_data, },
>  	{ .compatible =3D "fsl,imx8mp-flexcan", .data =3D &fsl_imx8mp_devtype=
_data, },
> @@ -1927,7 +2015,7 @@ static int flexcan_probe(struct platform_device *=
pdev)
>  	struct clk *clk_ipg =3D NULL, *clk_per =3D NULL;
>  	struct flexcan_regs __iomem *regs;
>  	int err, irq;
> -	u8 clk_src =3D 1;
> +	u8 clk_src =3D 1, can_idx =3D 0;
>  	u32 clock_freq =3D 0;
> =20
>  	reg_xceiver =3D devm_regulator_get_optional(&pdev->dev, "xceiver");
> @@ -1943,6 +2031,8 @@ static int flexcan_probe(struct platform_device *=
pdev)
>  				     "clock-frequency", &clock_freq);
>  		of_property_read_u8(pdev->dev.of_node,
>  				    "fsl,clk-source", &clk_src);
> +		of_property_read_u8(pdev->dev.of_node,
> +				    "fsl,can-index", &can_idx);
>  	}
> =20
>  	if (!clock_freq) {
> @@ -2019,6 +2109,7 @@ static int flexcan_probe(struct platform_device *=
pdev)
>  	priv->clk_src =3D clk_src;
>  	priv->devtype_data =3D devtype_data;
>  	priv->reg_xceiver =3D reg_xceiver;
> +	priv->can_idx =3D can_idx;
> =20
>  	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_FD) {
>  		priv->can.ctrlmode_supported |=3D CAN_CTRLMODE_FD |
> @@ -2030,6 +2121,10 @@ static int flexcan_probe(struct platform_device =
*pdev)
>  		priv->can.bittiming_const =3D &flexcan_bittiming_const;
>  	}
> =20
> +	err =3D flexcan_setup_stop_mode(pdev);
> +	if (err =3D=3D -EPROBE_DEFER)
> +		return -EPROBE_DEFER;

You need to free "dev". What about moving this directly before allocating=
 dev.

Do you have to undo device_set_wakeup_capable() and device_set_wakeup_ena=
ble()
in case of a failure and/or on flexcan_remove()?

> +
>  	pm_runtime_get_noresume(&pdev->dev);
>  	pm_runtime_set_active(&pdev->dev);
>  	pm_runtime_enable(&pdev->dev);
> @@ -2043,12 +2138,6 @@ static int flexcan_probe(struct platform_device =
*pdev)
>  	of_can_transceiver(dev);
>  	devm_can_led_init(dev);
> =20
> -	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR) {=

> -		err =3D flexcan_setup_stop_mode(pdev);
> -		if (err)
> -			dev_dbg(&pdev->dev, "failed to setup stop-mode\n");
> -	}
> -
>  	return 0;
> =20
>   failed_register:
>=20

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--jLO36DgfLZpGg0nWH6VsxfAtZq7zVZx7u--

--PZK8cbRawmzK1LUDyAIUwZWbLaSvVSR9H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAl+JNtYACgkQqclaivrt
76n0Zgf/eWrOl8YBZobwagGaHyRjhZ054AuUwDrMrq4ni7+n3PPF/oVFQs92wHAU
7Qx501Az1AyUrx8nH6zaOiz4lgoTnoDvbV7gMVDZ5VKMR9MbIEl+7VztjV3NZB0k
jIs1vdb53S+W8NndJbhgTy7xs/5dEG2/jP8U9BXcnNjnLJg1XIn13cna1l8eDDo8
imAFO7G4A15rySWM1cVzIt7CqmXubw2vndv8kjxppDRO9M5RKmbulu7i3JNmmdjz
7Dv2WAFB8wbFNzs6jkv3fqi5paxnVjI7/6aBSJkoJrJFIz0NqpQENQ3Vb3Rgr80k
UqpS5YV7QBlbbZroOHisxuoQXx2u9g==
=ixO9
-----END PGP SIGNATURE-----

--PZK8cbRawmzK1LUDyAIUwZWbLaSvVSR9H--
