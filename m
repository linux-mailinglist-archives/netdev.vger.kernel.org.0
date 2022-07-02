Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A352564168
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 18:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbiGBQSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 12:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiGBQSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 12:18:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36984BE2A
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 09:18:52 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o7fpP-0003ks-TR; Sat, 02 Jul 2022 18:18:39 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 7737FA5980;
        Sat,  2 Jul 2022 16:18:37 +0000 (UTC)
Date:   Sat, 2 Jul 2022 18:18:36 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 4/6] can: sja1000: Use of_device_get_match_data to get
 device data
Message-ID: <20220702161836.zuixkwjbbo5li7o5@pengutronix.de>
References: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
 <20220702140130.218409-5-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ueon7v6qzmswjax2"
Content-Disposition: inline
In-Reply-To: <20220702140130.218409-5-biju.das.jz@bp.renesas.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ueon7v6qzmswjax2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.07.2022 15:01:28, Biju Das wrote:
> This patch replaces of_match_device->of_device_get_match_data
> to get pointer to device data.
>=20
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  drivers/net/can/sja1000/sja1000_platform.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/can/sja1000/sja1000_platform.c b/drivers/net/can=
/sja1000/sja1000_platform.c
> index f9ec7bd8dfac..24ea0f76e130 100644
> --- a/drivers/net/can/sja1000/sja1000_platform.c
> +++ b/drivers/net/can/sja1000/sja1000_platform.c
> @@ -210,7 +210,6 @@ static int sp_probe(struct platform_device *pdev)
>  	struct resource *res_mem, *res_irq =3D NULL;
>  	struct sja1000_platform_data *pdata;
>  	struct device_node *of =3D pdev->dev.of_node;
> -	const struct of_device_id *of_id;
>  	const struct sja1000_of_data *of_data =3D NULL;
>  	size_t priv_sz =3D 0;
> =20
> @@ -243,11 +242,9 @@ static int sp_probe(struct platform_device *pdev)
>  			return -ENODEV;
>  	}
> =20
> -	of_id =3D of_match_device(sp_of_table, &pdev->dev);
> -	if (of_id && of_id->data) {
> -		of_data =3D of_id->data;
> +	of_data =3D of_device_get_match_data(&pdev->dev);

Can you use device_get_match_data() instead?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ueon7v6qzmswjax2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLAb9oACgkQrX5LkNig
011luwgAjgt+C0wHXmdRLewFe4TikraRgeLAI1jGp0sV+xNZWz5ha8ODBuUmRUXo
pfZPrVlIbTlh1bYaZ1KSwpsm4nis+mLIet0XuMz+lqG4WUxR3Qw29CqM/4mw2uEO
ujzDEpaDliizY3FIl6EhQUuvR3JUHDbSbE9Uojwpdl0VVTc9Wqw9NY6hqdgRbnvm
ysel/7PgZF8YrJpZU6BNiAhFkbfrZBgwmwgOk2uO97P9Bs+lbJkV5osSC3xcSFvq
/D3szkJYefA1acTuWHcuByKAvXbwO46MxGQ4Amh0JcYqpG1hq7QefJEb6en9z59A
zEfYmFVTdsNoTRIWuWU620NVwNTdag==
=gRG8
-----END PGP SIGNATURE-----

--ueon7v6qzmswjax2--
