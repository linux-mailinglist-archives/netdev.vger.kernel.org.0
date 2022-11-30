Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7930163D3E1
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 11:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbiK3K7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 05:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbiK3K7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 05:59:48 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D957240A9
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 02:59:48 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p0KoK-0005hp-EB; Wed, 30 Nov 2022 11:59:28 +0100
Received: from pengutronix.de (unknown [IPv6:2a0a:edc0:0:701:38ad:958d:3def:4382])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 7F7A612DD71;
        Wed, 30 Nov 2022 10:59:25 +0000 (UTC)
Date:   Wed, 30 Nov 2022 11:59:24 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Prabhakar <prabhakar.csengg@gmail.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: Re: [PATCH] dt-bindings: can: renesas,rcar-canfd: Document RZ/Five
 SoC
Message-ID: <20221130105924.auw7agizdiguxuod@pengutronix.de>
References: <20221115123811.1182922-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="i7azc2naz74qg5oe"
Content-Disposition: inline
In-Reply-To: <20221115123811.1182922-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
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


--i7azc2naz74qg5oe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.11.2022 12:38:11, Prabhakar wrote:
> From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>=20
> The CANFD block on the RZ/Five SoC is identical to one found on the
> RZ/G2UL SoC. "renesas,r9a07g043-canfd" compatible string will be used
> on the RZ/Five SoC so to make this clear, update the comment to include
> RZ/Five SoC.
>=20
> No driver changes are required as generic compatible string
> "renesas,rzg2l-canfd" will be used as a fallback on RZ/Five SoC.
>=20
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Added to linux-can-next.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--i7azc2naz74qg5oe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOHN4kACgkQrX5LkNig
012NxAf+Ntvb2Ef9ysCZGZ5eY3r5vbnbeAcAS0jenynLu81pQYhU+jWXN+k3BE4H
v0Y9+zhfJdu2jfwqcSaHwZ84WNlkz+aRpxgE3bg4L5KqPbyTB34tON3eYQbHzEfN
ie/O/GkkGFsFx7X2GJ/xpfHqPATIjlifdbnkcp9FVz7dITH2mD3bFc2WM3XrKLnc
J10glxlNli5aeEK2onSg7fFEGXTX3dt4etLRss+mbuX4HoXHQecvCRcVAQxTwpn+
Ir6ULc7xvipPY4yLKJlmlGPGito8UksB4L3muQ2sW0arwJdcRW9sdhRCeJz1T8YE
GTV8tQtODFAkVPXkG/rQAJutnKtolg==
=Pm24
-----END PGP SIGNATURE-----

--i7azc2naz74qg5oe--
