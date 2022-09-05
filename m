Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0384B5AD02B
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 12:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237767AbiIEK3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 06:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237753AbiIEK27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 06:28:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B378223BE1
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 03:28:57 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oV9LT-0004o2-GF; Mon, 05 Sep 2022 12:28:47 +0200
Received: from [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400] (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 7D014DA64C;
        Mon,  5 Sep 2022 07:39:34 +0000 (UTC)
To:     =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        kernel@pengutronix.de,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20220901140402.64804-1-csokas.bence@prolan.hu>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH v2] net: fec: Use a spinlock to guard `fep->ptp_clk_on`
Message-ID: <9f03470a-99a3-0f98-8057-bc07b0c869a5@pengutronix.de>
Date:   Mon, 5 Sep 2022 09:38:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20220901140402.64804-1-csokas.bence@prolan.hu>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="6KnTPPvzt597p1S1LPm90jfm2EmIPq5Mu"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6KnTPPvzt597p1S1LPm90jfm2EmIPq5Mu
Content-Type: multipart/mixed; boundary="UOZVNE2muc2UjfbwIHT9OW7Eqikc2ssTy";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>,
 netdev@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>, Richard Cochran <richardcochran@gmail.com>,
 kernel@pengutronix.de, Francesco Dolcini <francesco.dolcini@toradex.com>,
 Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>
Message-ID: <9f03470a-99a3-0f98-8057-bc07b0c869a5@pengutronix.de>
Subject: Re: [PATCH v2] net: fec: Use a spinlock to guard `fep->ptp_clk_on`
References: <20220901140402.64804-1-csokas.bence@prolan.hu>
In-Reply-To: <20220901140402.64804-1-csokas.bence@prolan.hu>

--UOZVNE2muc2UjfbwIHT9OW7Eqikc2ssTy
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 9/1/22 4:04 PM, Cs=C3=B3k=C3=A1s Bence wrote:
> Mutexes cannot be taken in a non-preemptible context,
> causing a panic in `fec_ptp_save_state()`. Replacing
> `ptp_clk_mutex` by `tmreg_lock` fixes this.

I was on holidays, but this doesn't look good.

> Fixes: 6a4d7234ae9a ("net: fec: ptp: avoid register access when ipg clo=
ck is disabled")
> Fixes: f79959220fa5 ("fec: Restart PPS after link state change")
> Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Link: https://lore.kernel.org/all/20220827160922.642zlcd5foopozru@pengu=
tronix.de/
> Signed-off-by: Cs=C3=B3k=C3=A1s Bence <csokas.bence@prolan.hu>
> ---
>  drivers/net/ethernet/freescale/fec.h      |  1 -
>  drivers/net/ethernet/freescale/fec_main.c | 17 +++++++-------
>  drivers/net/ethernet/freescale/fec_ptp.c  | 28 ++++++++---------------=

>  3 files changed, 19 insertions(+), 27 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/etherne=
t/freescale/fec.h
> index 0cebe4b63adb..38f095260e1f 100644
> --- a/drivers/net/ethernet/freescale/fec.h
> +++ b/drivers/net/ethernet/freescale/fec.h
> @@ -557,7 +557,6 @@ struct fec_enet_private {
>  	struct clk *clk_2x_txclk;
> =20
>  	bool ptp_clk_on;
> -	struct mutex ptp_clk_mutex;
>  	unsigned int num_tx_queues;
>  	unsigned int num_rx_queues;
> =20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/et=
hernet/freescale/fec_main.c
> index b0d60f898249..ab1ee9508f76 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -2028,6 +2028,7 @@ static void fec_enet_phy_reset_after_clk_enable(s=
truct net_device *ndev)
>  static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
>  {
>  	struct fec_enet_private *fep =3D netdev_priv(ndev);
> +	unsigned long flags;
>  	int ret;
> =20
>  	if (enable) {
> @@ -2036,15 +2037,15 @@ static int fec_enet_clk_enable(struct net_devic=
e *ndev, bool enable)
>  			return ret;
> =20
>  		if (fep->clk_ptp) {
> -			mutex_lock(&fep->ptp_clk_mutex);
> +			spin_lock_irqsave(&fep->tmreg_lock, flags);
>  			ret =3D clk_prepare_enable(fep->clk_ptp);

clock_prepare() (and thus clk_prepare_enable()) must not be called from a=
tomic
context.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--UOZVNE2muc2UjfbwIHT9OW7Eqikc2ssTy--

--6KnTPPvzt597p1S1LPm90jfm2EmIPq5Mu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMVp1wACgkQrX5LkNig
012Z0Af/ZVGF343EZeK7rqdIOFgubbE5ffAz6y3ibo1NtLL2yJSbmwYy44+YQDwp
eXQnex8Cmo8s3iMD2MckcJmLjGwctmE4u3w3g4KUSwSWEHj7JI230uGT8eDjH7+R
y32XUAEYDeFNROBvMriJt81KyEKwsvKiw0KZCnGnb6uzn8T04WZhQJWMeHgGHMNv
VAkXFzbG2B2FYRiqYB8LKW+tVD6WFToUS3IHFsC8/GhKawBJB4TcG8EQOl2Qmf1H
QR+Ci7es9KLD9xHJFMK3hh2HSH8ck8HW3avUZMV+c/n4703hhJPdQ/VP1EaSjfxm
rP7UwJwe150kBVyPw2sMFwPye6C8tw==
=23li
-----END PGP SIGNATURE-----

--6KnTPPvzt597p1S1LPm90jfm2EmIPq5Mu--
