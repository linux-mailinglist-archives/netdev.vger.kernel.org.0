Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8865360F0F9
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 09:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbiJ0HN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 03:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233773AbiJ0HNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 03:13:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E263713A583
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 00:13:24 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onx4c-0006a3-I0; Thu, 27 Oct 2022 09:13:06 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2C2F810AEDF;
        Thu, 27 Oct 2022 07:13:02 +0000 (UTC)
Date:   Thu, 27 Oct 2022 09:12:59 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 2/6] can: rcar_canfd: Add max_channels to struct
 rcar_canfd_hw_info
Message-ID: <20221027071259.ixueuw5xkptv22x5@pengutronix.de>
References: <20221026131732.1843105-1-biju.das.jz@bp.renesas.com>
 <20221026131732.1843105-3-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kze524f3mqvex6jc"
Content-Disposition: inline
In-Reply-To: <20221026131732.1843105-3-biju.das.jz@bp.renesas.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kze524f3mqvex6jc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26.10.2022 14:17:28, Biju Das wrote:
> R-Car V3U supports a maximum of 8 channels whereas rest of the SoCs
> support 2 channels.
>=20
> Add max_channels variable to struct rcar_canfd_hw_info to handle this
> difference.
>=20
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> v1->v2:
>  * Replaced data type of max_channels from u32->unsigned int.
>  * Added Rb tag from Geert.
> ---
>  drivers/net/can/rcar/rcar_canfd.c | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rca=
r_canfd.c
> index 5660bf0cd755..00e06cd26487 100644
> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -525,6 +525,7 @@ struct rcar_canfd_global;
> =20
>  struct rcar_canfd_hw_info {
>  	enum rcanfd_chip_id chip_id;
> +	unsigned int max_channels;

You can save some bytes of you make this an u8 and the postdiv in the
next patch, too.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--kze524f3mqvex6jc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNaL3cACgkQrX5LkNig
012xYgf+LeHXchpNeBHlu/ytLHIwV0FgBOuGi/6WHpZt1MdsfdLzncvirwl/T9W5
lnbtqiDACm+qfHemFX8Xu3sz8sbZ4D/pe/VScuCGT0b00FcDK7W49+b8Qh2Q/JRs
G1g6o4dpHJXcp6zCEevLAdkWK0Zit4iqSicpFbqYZ3fJkCWYZL239Bg3HqoZ+iIV
VDVdRarsOtLPKrmFQQE3NuHtrMFRuaioV2esh05bvtWaz1Pmb60k/5qOwPgNHySE
W+tcWIyqpWxvNaPJCWagrG/Aiiz0mHEcYEYIJlw6Br7tx+3XS+NUuhb7wUCgdOiA
Irs2UOmZl9Vc+elCTIz4pRI6QhT3oQ==
=uX4Q
-----END PGP SIGNATURE-----

--kze524f3mqvex6jc--
