Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E8E27818C
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 09:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgIYH3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 03:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgIYH3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 03:29:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD76C0613D3
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 00:29:18 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kLiAO-0002Zn-A1; Fri, 25 Sep 2020 09:29:16 +0200
Received: from [IPv6:2a03:f580:87bc:d400:bb52:8761:ee49:c953] (unknown [IPv6:2a03:f580:87bc:d400:bb52:8761:ee49:c953])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id DEC2456A1D8;
        Fri, 25 Sep 2020 07:29:14 +0000 (UTC)
To:     Joakim Zhang <qiangqing.zhang@nxp.com>, linux-can@vger.kernel.org
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
References: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
 <20200925151028.11004-2-qiangqing.zhang@nxp.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH linux-can-next/flexcan 1/4] can: flexcan: initialize all
 flexcan memory for ECC function
Message-ID: <f98dcb18-19f9-9721-a191-481983158daa@pengutronix.de>
Date:   Fri, 25 Sep 2020 09:29:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200925151028.11004-2-qiangqing.zhang@nxp.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="4lTHm8lR0naIg2Xl4vXjC3lSvhtan610d"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4lTHm8lR0naIg2Xl4vXjC3lSvhtan610d
Content-Type: multipart/mixed; boundary="NBznI2sNmVbkp4CE0a2QoHDjmjm7OJj33";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Joakim Zhang <qiangqing.zhang@nxp.com>, linux-can@vger.kernel.org
Cc: linux-imx@nxp.com, netdev@vger.kernel.org
Message-ID: <f98dcb18-19f9-9721-a191-481983158daa@pengutronix.de>
Subject: Re: [PATCH linux-can-next/flexcan 1/4] can: flexcan: initialize all
 flexcan memory for ECC function
References: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
 <20200925151028.11004-2-qiangqing.zhang@nxp.com>
In-Reply-To: <20200925151028.11004-2-qiangqing.zhang@nxp.com>

--NBznI2sNmVbkp4CE0a2QoHDjmjm7OJj33
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 9/25/20 5:10 PM, Joakim Zhang wrote:
> There is a NOTE at the section "Detection and correction of memory erro=
rs":

Can you add a reference to one datasheet including name, revision and sec=
tion?

> All FlexCAN memory must be initialized before starting its operation in=

> order to have the parity bits in memory properly updated. CTRL2[WRMFRZ]=

> grants write access to all memory positions that require initialization=
,
> ranging from 0x080 to 0xADF and from 0xF28 to 0xFFF when the CAN FD fea=
ture
> is enabled. The RXMGMASK, RX14MASK, RX15MASK, and RXFGMASK registers ne=
ed to
> be initialized as well. MCR[RFEN] must not be set during memory initial=
ization.
>=20
> Memory range from 0x080 to 0xADF, there are reserved memory (unimplemen=
ted
> by hardware), these memory can be initialized or not.
>=20
> Initialize all FlexCAN memory before accessing them, otherwise, memory
> errors may be detected. The internal region cannot be initialized when
> the hardware does not support ECC.
>=20
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  drivers/net/can/flexcan.c | 92 ++++++++++++++++++++++++++++++++++++++-=

>  1 file changed, 90 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
> index 286c67196592..f02f1de2bbca 100644
> --- a/drivers/net/can/flexcan.c
> +++ b/drivers/net/can/flexcan.c
> @@ -292,7 +292,16 @@ struct flexcan_regs {
>  	u32 rximr[64];		/* 0x880 - Not affected by Soft Reset */
>  	u32 _reserved5[24];	/* 0x980 */
>  	u32 gfwr_mx6;		/* 0x9e0 - MX6 */
> -	u32 _reserved6[63];	/* 0x9e4 */
> +	u32 _reserved6[39];	/* 0x9e4 */
> +	u32 _rxfir[6];		/* 0xa80 */
> +	u32 _reserved8[2];	/* 0xa98 */
> +	u32 _rxmgmask;		/* 0xaa0 */
> +	u32 _rxfgmask;		/* 0xaa4 */
> +	u32 _rx14mask;		/* 0xaa8 */
> +	u32 _rx15mask;		/* 0xaac */
> +	u32 tx_smb[4];		/* 0xab0 */
> +	u32 rx_smb0[4];		/* 0xac0 */
> +	u32 rx_smb1[4];		/* 0xad0 */
>  	u32 mecr;		/* 0xae0 */
>  	u32 erriar;		/* 0xae4 */
>  	u32 erridpr;		/* 0xae8 */
> @@ -305,9 +314,13 @@ struct flexcan_regs {
>  	u32 fdctrl;		/* 0xc00 - Not affected by Soft Reset */
>  	u32 fdcbt;		/* 0xc04 - Not affected by Soft Reset */
>  	u32 fdcrc;		/* 0xc08 */
> +	u32 _reserved9[199];	/* 0xc0c */
> +	u32 tx_smb_fd[18];	/* 0xf28 */
> +	u32 rx_smb0_fd[18];	/* 0xf70 */
> +	u32 rx_smb1_fd[18];	/* 0xfb8 */
>  };
> =20
> -static_assert(sizeof(struct flexcan_regs) =3D=3D 0x4 + 0xc08);
> +static_assert(sizeof(struct flexcan_regs) =3D=3D 0x4 * 18 + 0xfb8);
> =20
>  struct flexcan_devtype_data {
>  	u32 quirks;		/* quirks needed for different IP cores */
> @@ -1292,6 +1305,78 @@ static void flexcan_set_bittiming(struct net_dev=
ice *dev)
>  		return flexcan_set_bittiming_ctrl(dev);
>  }
> =20
> +static void flexcan_init_ram(struct net_device *dev)
> +{
> +	struct flexcan_priv *priv =3D netdev_priv(dev);
> +	struct flexcan_regs __iomem *regs =3D priv->regs;
> +	u32 reg_ctrl2;
> +	int i, size;
> +
> +	/* CTRL2[WRMFRZ] grants write access to all memory positions that
> +	 * require initialization. MCR[RFEN] must not be set during FlexCAN
> +	 * memory initialization.

Please add here the reference to the datasheet aswell.

> +	 */
> +	reg_ctrl2 =3D priv->read(&regs->ctrl2);
> +	reg_ctrl2 |=3D FLEXCAN_CTRL2_WRMFRZ;
> +	priv->write(reg_ctrl2, &regs->ctrl2);
> +
> +	/* initialize MBs RAM */
> +	size =3D sizeof(regs->mb) / sizeof(u32);
> +	for (i =3D 0; i < size; i++)
> +		priv->write(0, &regs->mb[0][0] + sizeof(u32) * i);

Can you create a "static const struct" holding the reg (or offset) + len =
and
loop over it. Something linke this?

const struct struct flexcan_ram_init ram_init[] {
	void __iomem *reg;
	u16 len;
} =3D {
	{
		.reg =3D regs->mb,	/* MB RAM */
		.len =3D sizeof(regs->mb), / sizeof(u32),
	}, {
		.reg =3D regs->rximr,	/* RXIMR RAM */
		.len =3D sizeof(regs->rximr),
	}, {
		...
	},
};


> +
> +	/* initialize RXIMRs RAM */
> +	size =3D sizeof(regs->rximr) / sizeof(u32);
> +	for (i =3D 0; i < size; i++)
> +		priv->write(0, &regs->rximr[i]);
> +
> +	/* initialize RXFIRs RAM */
> +	size =3D sizeof(regs->_rxfir) / sizeof(u32);
> +	for (i =3D 0; i < size; i++)
> +		priv->write(0, &regs->_rxfir[i]);
> +
> +	/* initialize RXMGMASK, RXFGMASK, RX14MASK, RX15MASK RAM */
> +	priv->write(0, &regs->_rxmgmask);
> +	priv->write(0, &regs->_rxfgmask);
> +	priv->write(0, &regs->_rx14mask);
> +	priv->write(0, &regs->_rx15mask);
> +
> +	/* initialize TX_SMB RAM */
> +	size =3D sizeof(regs->tx_smb) / sizeof(u32);
> +	for (i =3D 0; i < size; i++)
> +		priv->write(0, &regs->tx_smb[i]);
> +
> +	/* initialize RX_SMB0 RAM */
> +	size =3D sizeof(regs->rx_smb0) / sizeof(u32);
> +	for (i =3D 0; i < size; i++)
> +		priv->write(0, &regs->rx_smb0[i]);
> +
> +	/* initialize RX_SMB1 RAM */
> +	size =3D sizeof(regs->rx_smb1) / sizeof(u32);
> +	for (i =3D 0; i < size; i++)
> +		priv->write(0, &regs->rx_smb1[i]);
> +
> +	if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
> +		/* initialize TX_SMB_FD RAM */

and the same for the fd-mode

> +		size =3D sizeof(regs->tx_smb_fd) / sizeof(u32);
> +		for (i =3D 0; i < size; i++)
> +			priv->write(0, &regs->tx_smb_fd[i]);
> +
> +		/* initialize RX_SMB0_FD RAM */
> +		size =3D sizeof(regs->rx_smb0_fd) / sizeof(u32);
> +		for (i =3D 0; i < size; i++)
> +			priv->write(0, &regs->rx_smb0_fd[i]);
> +
> +		/* initialize RX_SMB1_FD RAM */
> +		size =3D sizeof(regs->rx_smb1_fd) / sizeof(u32);
> +		for (i =3D 0; i < size; i++)
> +			priv->write(0, &regs->rx_smb0_fd[i]);
> +	}
> +
> +	reg_ctrl2 &=3D ~FLEXCAN_CTRL2_WRMFRZ;
> +	priv->write(reg_ctrl2, &regs->ctrl2);
> +}
> +
>  /* flexcan_chip_start
>   *
>   * this functions is entered with clocks enabled
> @@ -1316,6 +1401,9 @@ static int flexcan_chip_start(struct net_device *=
dev)
>  	if (err)
>  		goto out_chip_disable;
> =20
> +	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_DISABLE_MECR)
> +		flexcan_init_ram(dev);
> +
>  	flexcan_set_bittiming(dev);
> =20
>  	/* MCR
>=20

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--NBznI2sNmVbkp4CE0a2QoHDjmjm7OJj33--

--4lTHm8lR0naIg2Xl4vXjC3lSvhtan610d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAl9tnEYACgkQqclaivrt
76leMAf+KHvZ5OQwD2qzaGWiUm9SE7S4ERG6uwhM6hEFBrrBaxYwrDi/NNAhrCZK
34mZxUzSg6s+eltsVUMhoQt6UqSzmfcB0LjAzlqTIByr/4A1iTJodCmCpTk5q/GX
Jh9IusOMNTxIjEkPiaeVlpX8EI2JqgYBlUgVM8SgCtCnxOtYQT2iINYe8ZzG/zmC
fsO4+V7cl72RYypwvq8pU66BGgXAOn8L5CDnbXv4MsReYCn16PUN1HQZLgCMGo5Z
ymvrJLraWMvC9CKzPbN6or/kim0/E/DX1ApvA/rPuUim10LszQdUFag/AGDPUoeK
vbkQUOfoRtjIII+ImSvleCrT4yvC7Q==
=QkbI
-----END PGP SIGNATURE-----

--4lTHm8lR0naIg2Xl4vXjC3lSvhtan610d--
