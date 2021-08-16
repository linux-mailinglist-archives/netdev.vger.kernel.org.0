Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8763ED2EF
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 13:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235881AbhHPLNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 07:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235976AbhHPLNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 07:13:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940E3C0613C1
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 04:13:12 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mFaYH-00016o-94; Mon, 16 Aug 2021 13:13:09 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:3272:cc96:80a9:1a01])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 106E3668211;
        Mon, 16 Aug 2021 11:13:07 +0000 (UTC)
Date:   Mon, 16 Aug 2021 13:13:06 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add Vincent MAILHOL as maintainer for the
 ETAS ES58X CAN/USB driver
Message-ID: <20210816111306.xdyfb7shpwij4z27@pengutronix.de>
References: <20210814093353.74391-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dc5q36jk3j4vbglt"
Content-Disposition: inline
In-Reply-To: <20210814093353.74391-1-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dc5q36jk3j4vbglt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.08.2021 18:33:53, Vincent Mailhol wrote:
> Adding myself (Vincent Mailhol) as a maintainer for the ETAS ES58X
> CAN/USB driver.
>=20
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
> When sending the patches for the ETAS ES58X driver, I looked at what
> other drivers were doing and realized that most of these did not
> update the MAINTAINERS file. At that time, I candidly thought that the
> MODULE_AUTHOR macro was sufficient for that. Following this e-mail:
> https://lore.kernel.org/linux-can/20210809175158.5xdkqeemjo3hqwcw@pengutr=
onix.de/
> it appeared that I should have done so.
>=20
> This patch fixes it. :)
> ---
> MAINTAINERS | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 41fcfdb24a81..9a164f4eeee6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11347,6 +11347,12 @@ L:	netdev@vger.kernel.org
>  S:	Supported
>  F:	drivers/net/phy/mxl-gpy.c
> =20
> +ETAS ES58X CAN/USB DRIVER
> +M:	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> +L:	linux-can@vger.kernel.org
> +S:	Maintained
> +F:	drivers/net/can/usb/etas_es58x/
> +

The file should be sorted alphabetically, fixed while applying.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--dc5q36jk3j4vbglt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEaSD4ACgkQqclaivrt
76mPxgf/U/pNltqTiXwccENNXOBZW5oG8WHAIRlpSPrXvzBBb8NzOBPpj9BNKGM3
wk5XSPxQSnSriwQo97xOCkDiNnfeewCJ7FHj6LLKrWfUdDawQTum1hTjb+ZMLOO9
mSQhbBYPOM3qXK8AhgweEWikppsrOjPxEPUpa8LWwgaKOiya5cRmBhOMmj487wfF
A/i5OCkfOiyJypmz5VfEeiNfY0m0GTujBV1C5iOBND6ti0ESnwM9XgMy/7nxePPR
17YTzIYOKtBkv8SrwnBP2WxqHLEAtGRuH7HkqSd+fjBy9tNil4YWsoekmMTFVowO
mBdjdFtPswmMwoGiN/ftp26GalJEFg==
=9DQ6
-----END PGP SIGNATURE-----

--dc5q36jk3j4vbglt--
