Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D14D517F94
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 10:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbiECITe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 04:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbiECITd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 04:19:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5084026AEB
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 01:16:02 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nlnhC-0002lE-Tg; Tue, 03 May 2022 10:15:46 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 51A54749F4;
        Tue,  3 May 2022 08:15:44 +0000 (UTC)
Date:   Tue, 3 May 2022 10:15:42 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: can: renesas,rcar-canfd: Make
 interrupt-names required
Message-ID: <878rrjf2vv.fsf@hardanger.blackshift.org>
References: <cover.1651512451.git.geert+renesas@glider.be>
 <a68e65955e0df4db60233d468f348203c2e7b940.1651512451.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sfgxuhwvddqugxs5"
Content-Disposition: inline
In-Reply-To: <a68e65955e0df4db60233d468f348203c2e7b940.1651512451.git.geert+renesas@glider.be>
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


--sfgxuhwvddqugxs5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.05.2022 19:33:53, Geert Uytterhoeven wrote:
> The Renesas R-Car CAN FD Controller always uses two or more interrupts.
> Make the interrupt-names properties a required property, to make it
> easier to identify the individual interrupts.
>=20
> Update the example accordingly.
>=20
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Applied to linux-can-next/testing.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--sfgxuhwvddqugxs5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJw5KwACgkQrX5LkNig
010SDAgAmjLWcB7Oaw7BaFNiAZCrFvSztk4Cdz5YLEkvckGfldZ3/pMuCe42t9sf
oVJF8+89iexDgYCV/8VLOvtfeHnOBV/A1TLO3FUEXEMeVsjnpEXM8SKveWbQ1/sW
Eav3u40j/oaoiKNoT5CYRzu2n+6qFmPBsfmj4QkONfKhDvxTB+ILZPhcth7urR6J
muEHawO6nWkX7l8G52BEWMgi7CDvfudTzSywaJ/qQ1berzwpJYIMs64RBhdWonOk
wA5Qr2iTjW7WGfg4NR00w416PhfFLrwc+f8pG7t20WZ74mkdODYzoFlWlgxrM55m
F5mLvO7aP6tf/N7Zzw7Z+CDXsK7Lkw==
=FNo9
-----END PGP SIGNATURE-----

--sfgxuhwvddqugxs5--
