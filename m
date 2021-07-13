Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715BF3C6AB0
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 08:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbhGMGoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 02:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbhGMGoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 02:44:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71449C0613DD
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 23:41:13 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m3C6N-0006Zg-E5; Tue, 13 Jul 2021 08:41:07 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m3C6K-0006P1-Py; Tue, 13 Jul 2021 08:41:04 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m3C6K-0000np-P0; Tue, 13 Jul 2021 08:41:04 +0200
Date:   Tue, 13 Jul 2021 08:41:01 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Salah Triki <salah.triki@gmail.com>
Cc:     kevin.curtis@farsite.co.uk, davem@davemloft.net, kuba@kernel.org,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] delete useless for loop
Message-ID: <20210713064101.kmqwms6aon2myakp@pengutronix.de>
References: <20210712205848.GA1492971@pc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3id3qk4l6sglt4ek"
Content-Disposition: inline
In-Reply-To: <20210712205848.GA1492971@pc>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3id3qk4l6sglt4ek
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Salah,

On Mon, Jul 12, 2021 at 09:58:48PM +0100, Salah Triki wrote:
> Delete useless initialization of fst_card_array since the default
> initialization is NULL.
>=20
> Signed-off-by: Salah Triki <salah.triki@gmail.com>
> ---
>  drivers/net/wan/farsync.c | 4 ----
>  1 file changed, 4 deletions(-)
>=20
> diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
> index b3466e084e84..0b3f561d5d5e 100644
> --- a/drivers/net/wan/farsync.c
> +++ b/drivers/net/wan/farsync.c
> @@ -2565,10 +2565,6 @@ static struct pci_driver fst_driver =3D {
>  static int __init
>  fst_init(void)
>  {
> -	int i;
> -
> -	for (i =3D 0; i < FST_MAX_CARDS; i++)
> -		fst_card_array[i] =3D NULL;
>  	return pci_register_driver(&fst_driver);
>  }

Looks right. I wonder if it makes sense to go even further and let
farsync.c use module_pci_driver.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--3id3qk4l6sglt4ek
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmDtNXoACgkQwfwUeK3K
7AnG8wgAjnz0nqKmlTJ7V2zmhTKUNSQl0R4h4E+uNuztLIMHVz5Y2/3T73jaAVf/
WKL+TrCB4vOJTjlqA6ZmL//p4Ua3ZqgGuanEN+bx/8QG9PZxN0ShIC33XXq+n7SY
4cVyotvebIH5SFC/5nkqHKoGTlQ6OzEeIZVUyjKgrtmCwPrCdWpDUWncet2DN7A9
kOzs7sS7qphBM6YdCSeM5PpB/pNf0AGOM/zc6NFwsbz4tqTvc7Jgf43msF0YsHt5
nfJrEose6dOAYxSwvwDWrM9yTxFNMy/6XP1MAdytVLvr2LXSBim0MYs1OmBWneOD
FxP9iJ0BhknzhNlkAOij8sP+N7w+5Q==
=HU7c
-----END PGP SIGNATURE-----

--3id3qk4l6sglt4ek--
