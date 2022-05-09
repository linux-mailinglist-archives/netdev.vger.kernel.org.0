Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B26E5201FE
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 18:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238944AbiEIQMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 12:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238909AbiEIQMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 12:12:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CAD275A15
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 09:08:52 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1no5w5-0006Dc-V1; Mon, 09 May 2022 18:08:38 +0200
Received: from pengutronix.de (unknown [46.183.103.8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3888C792B0;
        Mon,  9 May 2022 16:08:34 +0000 (UTC)
Date:   Mon, 9 May 2022 18:08:29 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: ctucanfd: Let users select instead of depend on
 CAN_CTUCANFD
Message-ID: <20220509160829.33on24zv2dzuduki@pengutronix.de>
References: <887b7440446b6244a20a503cc6e8dc9258846706.1652104941.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2kgpg7mgensexdts"
Content-Disposition: inline
In-Reply-To: <887b7440446b6244a20a503cc6e8dc9258846706.1652104941.git.geert+renesas@glider.be>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2kgpg7mgensexdts
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.05.2022 16:02:59, Geert Uytterhoeven wrote:
> The CTU CAN-FD IP core is only useful when used with one of the
> corresponding PCI/PCIe or platform (FPGA, SoC) drivers, which depend on
> PCI resp. OF.
>=20
> Hence make the users select the core driver code, instead of letting
> then depend on it.  Keep the core code config option visible when
> compile-testing, to maintain compile-coverage.
>=20
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Makes sense! Applied to linux-can-next/testing.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--2kgpg7mgensexdts
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJ5PHsACgkQrX5LkNig
010rxwf/a5jCQVKz2Pqk4Z+Yg5tynosGv++gD8deJN81C0mVRBpYgyzh1AOO/hNN
uiTaginVvB3jBg8yWSMjX3vT8ntZZ6T5FBmWg2sh0QyzWU4wdahW77levMpyVDgh
480So9M7jzW1ILBZL0DedERx8vOGk5L6ygsNUSzu9XZmwRUG9NXqT+1851dR1NAl
tg7nwb6TyYp+2uaeTem4e1mkhi8Zi4kcOCLC6JrICCaGTNOTbeGGwhoRh97tZyyh
CFbA16mk0r8sBp+xpblzlGV8KxSed8YTTOeAJjgen+KqTQTpaZAH6lYkWu1/cB65
JY6MmxXuU9Z8uhBFojHeOgmg7IUafw==
=FcCT
-----END PGP SIGNATURE-----

--2kgpg7mgensexdts--
