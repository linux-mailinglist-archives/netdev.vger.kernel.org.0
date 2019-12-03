Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9174A110429
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 19:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfLCSVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 13:21:45 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41909 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbfLCSVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 13:21:45 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1icCnt-0000tr-Pt; Tue, 03 Dec 2019 19:21:41 +0100
Received: from [IPv6:2a03:f580:87bc:d400:858e:130c:14c0:366e] (unknown [IPv6:2a03:f580:87bc:d400:858e:130c:14c0:366e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits)
         client-signature RSA-PSS (4096 bits))
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B8CE0488960;
        Tue,  3 Dec 2019 18:21:40 +0000 (UTC)
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <20191127055334.1476-4-qiangqing.zhang@nxp.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Openpgp: preference=signencrypt
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH V2 3/4] can: flexcan: change the way of stop mode
 acknowledgment
Message-ID: <8795fcdb-d102-758d-6257-ffcd05108715@pengutronix.de>
Date:   Tue, 3 Dec 2019 19:21:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191127055334.1476-4-qiangqing.zhang@nxp.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="2Ob8pop3426oy7nhLxm2NZsQ1tGt7oV71"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2Ob8pop3426oy7nhLxm2NZsQ1tGt7oV71
Content-Type: multipart/mixed; boundary="0dKgauQox5wbWHudvwt0wwiXJLKXq2Iv5";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Joakim Zhang <qiangqing.zhang@nxp.com>, "sean@geanix.com"
 <sean@geanix.com>, "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc: dl-linux-imx <linux-imx@nxp.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <8795fcdb-d102-758d-6257-ffcd05108715@pengutronix.de>
Subject: Re: [PATCH V2 3/4] can: flexcan: change the way of stop mode
 acknowledgment
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <20191127055334.1476-4-qiangqing.zhang@nxp.com>
In-Reply-To: <20191127055334.1476-4-qiangqing.zhang@nxp.com>

--0dKgauQox5wbWHudvwt0wwiXJLKXq2Iv5
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 11/27/19 6:56 AM, Joakim Zhang wrote:
> Stop mode is entered when Stop mode is requested at chip level and
> MCR[LPM_ACK] is asserted by the FlexCAN.
>=20
> Double check with IP owner, should poll MCR[LPM_ACK] for stop mode
> acknowledgment, not the acknowledgment from chip level which is used
> for glitch filter.
>=20
> Fixes: 5f186c257fa4(can: flexcan: fix stop mode acknowledgment)
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ------
> ChangeLog:
> 	V1->V2: no change.
> ---
>  drivers/net/can/flexcan.c | 64 ++++++++++++++++++++-------------------=

>  1 file changed, 33 insertions(+), 31 deletions(-)
>=20
> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
> index 5d5ed28d3005..d178146b3da5 100644
> --- a/drivers/net/can/flexcan.c
> +++ b/drivers/net/can/flexcan.c
> @@ -388,6 +388,34 @@ static struct flexcan_mb __iomem *flexcan_get_mb(c=
onst struct flexcan_priv *priv
>  		(&priv->regs->mb[bank][priv->mb_size * mb_index]);
>  }
> =20
> +static int flexcan_enter_low_power_ack(struct flexcan_priv *priv)

nitpick: please call this flexcan_low_power_enter_ack()
> +{
> +	struct flexcan_regs __iomem *regs =3D priv->regs;
> +	unsigned int timeout =3D FLEXCAN_TIMEOUT_US / 10;
> +
> +	while (timeout-- && !(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
> +		udelay(10);
> +
> +	if (!(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
> +		return -ETIMEDOUT;
> +
> +	return 0;
> +}
> +
> +static int flexcan_exit_low_power_ack(struct flexcan_priv *priv)

=2E..and this one flexcan_low_power_exit_ack()

> +{
> +	struct flexcan_regs __iomem *regs =3D priv->regs;
> +	unsigned int timeout =3D FLEXCAN_TIMEOUT_US / 10;
> +
> +	while (timeout-- && (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
> +		udelay(10);
> +
> +	if (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK)
> +		return -ETIMEDOUT;
> +
> +	return 0;
> +}

Can you move split the creation of
flexcan_low_power_enter_ack()/flexcan_low_power_exit_ack() and use in
flexcan_chip_enable/disable() into one patch and the conversion of
flexcan_enter_stop_mode()/flexcan_exit_stop_mode() into another.

Marc

> +
>  static void flexcan_enable_wakeup_irq(struct flexcan_priv *priv, bool =
enable)
>  {
>  	struct flexcan_regs __iomem *regs =3D priv->regs;
> @@ -406,7 +434,6 @@ static void flexcan_enable_wakeup_irq(struct flexca=
n_priv *priv, bool enable)
>  static inline int flexcan_enter_stop_mode(struct flexcan_priv *priv)
>  {
>  	struct flexcan_regs __iomem *regs =3D priv->regs;
> -	unsigned int ackval;
>  	u32 reg_mcr;
> =20
>  	reg_mcr =3D priv->read(&regs->mcr);
> @@ -418,35 +445,24 @@ static inline int flexcan_enter_stop_mode(struct =
flexcan_priv *priv)
>  			   1 << priv->stm.req_bit, 1 << priv->stm.req_bit);
> =20
>  	/* get stop acknowledgment */
> -	if (regmap_read_poll_timeout(priv->stm.gpr, priv->stm.ack_gpr,
> -				     ackval, ackval & (1 << priv->stm.ack_bit),
> -				     0, FLEXCAN_TIMEOUT_US))
> -		return -ETIMEDOUT;
> -
> -	return 0;
> +	return flexcan_enter_low_power_ack(priv);
>  }
> =20
>  static inline int flexcan_exit_stop_mode(struct flexcan_priv *priv)
>  {
>  	struct flexcan_regs __iomem *regs =3D priv->regs;
> -	unsigned int ackval;
>  	u32 reg_mcr;
> =20
>  	/* remove stop request */
>  	regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
>  			   1 << priv->stm.req_bit, 0);
> =20
> -	/* get stop acknowledgment */
> -	if (regmap_read_poll_timeout(priv->stm.gpr, priv->stm.ack_gpr,
> -				     ackval, !(ackval & (1 << priv->stm.ack_bit)),
> -				     0, FLEXCAN_TIMEOUT_US))
> -		return -ETIMEDOUT;
> -
>  	reg_mcr =3D priv->read(&regs->mcr);
>  	reg_mcr &=3D ~FLEXCAN_MCR_SLF_WAK;
>  	priv->write(reg_mcr, &regs->mcr);
> =20
> -	return 0;
> +	/* get stop acknowledgment */
> +	return flexcan_exit_low_power_ack(priv);
>  }
> =20
>  static void flexcan_try_exit_stop_mode(struct flexcan_priv *priv)
> @@ -512,39 +528,25 @@ static inline int flexcan_transceiver_disable(con=
st struct flexcan_priv *priv)
>  static int flexcan_chip_enable(struct flexcan_priv *priv)
>  {
>  	struct flexcan_regs __iomem *regs =3D priv->regs;
> -	unsigned int timeout =3D FLEXCAN_TIMEOUT_US / 10;
>  	u32 reg;
> =20
>  	reg =3D priv->read(&regs->mcr);
>  	reg &=3D ~FLEXCAN_MCR_MDIS;
>  	priv->write(reg, &regs->mcr);
> =20
> -	while (timeout-- && (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
> -		udelay(10);
> -
> -	if (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK)
> -		return -ETIMEDOUT;
> -
> -	return 0;
> +	return flexcan_exit_low_power_ack(priv);
>  }
> =20
>  static int flexcan_chip_disable(struct flexcan_priv *priv)
>  {
>  	struct flexcan_regs __iomem *regs =3D priv->regs;
> -	unsigned int timeout =3D FLEXCAN_TIMEOUT_US / 10;
>  	u32 reg;
> =20
>  	reg =3D priv->read(&regs->mcr);
>  	reg |=3D FLEXCAN_MCR_MDIS;
>  	priv->write(reg, &regs->mcr);
> =20
> -	while (timeout-- && !(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
> -		udelay(10);
> -
> -	if (!(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
> -		return -ETIMEDOUT;
> -
> -	return 0;
> +	return flexcan_enter_low_power_ack(priv);
>  }
> =20
>  static int flexcan_chip_freeze(struct flexcan_priv *priv)
>=20


--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--0dKgauQox5wbWHudvwt0wwiXJLKXq2Iv5--

--2Ob8pop3426oy7nhLxm2NZsQ1tGt7oV71
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEmvEkXzgOfc881GuFWsYho5HknSAFAl3mp7AACgkQWsYho5Hk
nSBRMQf/fIElqnTsXHrm17GDRyQ2uUqFDG0aosj4xTj2Twz1v9E0NJd3KJR5LKmA
wdi527vCf3hL//OI2GapaE3AeZb754VhjMiOhGVsPeTepRVqGX7TEZAqILxwjH6z
9J4+6b+/4OMq6eP5tBdjy46G1pNuAfVFugnW60DTcrgSpxpaUyCBcubOHG0tq9UU
vckjnHigFSkWKu8jg8s7uCGn/KZgdAeU6kPv9PP0OBsKeZ30Jk4XGjjIZNPrClTr
yVzsP6PPGI+jgBuBG0sY8F9GVUQuvv23zsLEyrnPijUjSZvRJfbODkDn3xWGxoEO
3TEiCN7JMxvpswKbr3U9M/KQOgTeNw==
=IGww
-----END PGP SIGNATURE-----

--2Ob8pop3426oy7nhLxm2NZsQ1tGt7oV71--
