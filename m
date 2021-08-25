Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552BC3F6F39
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 08:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238739AbhHYGOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 02:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238785AbhHYGN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 02:13:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA045C061757
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 23:13:13 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mIm9l-0005zz-AR; Wed, 25 Aug 2021 08:13:01 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-b509-65fb-e781-8611.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:b509:65fb:e781:8611])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 827D366E7B5;
        Wed, 25 Aug 2021 06:12:56 +0000 (UTC)
Date:   Wed, 25 Aug 2021 08:12:55 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     davem@davemloft.net, wg@grandegger.com, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: mscan: mpc5xxx_can: Remove useless BUG_ON()
Message-ID: <20210825061255.nhkg3yobirnn75c7@pengutronix.de>
References: <20210823141033.17876-1-tangbin@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kwyhwexn7jes4aja"
Content-Disposition: inline
In-Reply-To: <20210823141033.17876-1-tangbin@cmss.chinamobile.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kwyhwexn7jes4aja
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23.08.2021 22:10:33, Tang Bin wrote:
> In the function mpc5xxx_can_probe(), the variale 'data'
                                               ^b

Fixed typo while applying.

> has already been determined in the above code, so the
> BUG_ON() in this place is useless, remove it.
>=20
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> ---
>  drivers/net/can/mscan/mpc5xxx_can.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/mscan/=
mpc5xxx_can.c
> index 3b7465acd..35892c1ef 100644
> --- a/drivers/net/can/mscan/mpc5xxx_can.c
> +++ b/drivers/net/can/mscan/mpc5xxx_can.c
> @@ -317,7 +317,6 @@ static int mpc5xxx_can_probe(struct platform_device *=
ofdev)
> =20
>  	clock_name =3D of_get_property(np, "fsl,mscan-clock-source", NULL);
> =20
> -	BUG_ON(!data);
>  	priv->type =3D data->type;
>  	priv->can.clock.freq =3D data->get_clock(ofdev, clock_name,
>  					       &mscan_clksrc);

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--kwyhwexn7jes4aja
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEl32QACgkQqclaivrt
76mchAf+NffU83nHOfdrqDPqYDX7v53Hf3NOoRhQNfP+vK8QKW5ZQymf7bYzdYBp
LpwVyT1Udgu48ldFLIe0MJtD4JV5RWVtmnnrX1dh8+58xxjrul2l1zEhRWWieQ6p
8QA0782HJdUk9UXDNiUnRNOUcWKkKjlwSERyaQE/1YVKaZv4ZnFo5DXhdkKtZYW6
7wqDpkq5V2puoWIvHHqf3MGSowz/y9AruLLEPfhGTLI+t4DNAjPC9pcmpMNg7f1d
CeNmzEzUg5qmcXEQGziytWt1ECBzS/A9ihhAJVwp2tjIiQXT/HSeoypcx+uCozzM
4eH69CYs6kuPC1OUkp+DMehqeLV1sA==
=ft+K
-----END PGP SIGNATURE-----

--kwyhwexn7jes4aja--
