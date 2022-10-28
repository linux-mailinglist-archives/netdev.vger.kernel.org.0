Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7486110E9
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 14:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiJ1ML7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 08:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiJ1MLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 08:11:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02161D3C53
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 05:11:38 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ooOCw-0000cg-M1; Fri, 28 Oct 2022 14:11:30 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3911210CBA9;
        Fri, 28 Oct 2022 12:11:29 +0000 (UTC)
Date:   Fri, 28 Oct 2022 14:11:26 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] can: rcar_canfd: Add missing ECC error checks for
 channels 2-7
Message-ID: <20221028121126.aigrnf4uph6hsppl@pengutronix.de>
References: <4edb2ea46cc64d0532a08a924179827481e14b4f.1666951503.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ubstobhq47tay4vw"
Content-Disposition: inline
In-Reply-To: <4edb2ea46cc64d0532a08a924179827481e14b4f.1666951503.git.geert+renesas@glider.be>
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


--ubstobhq47tay4vw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.10.2022 12:06:45, Geert Uytterhoeven wrote:
> When introducing support for R-Car V3U, which has 8 instead of 2
> channels, the ECC error bitmask was extended to take into account the
> extra channels, but rcar_canfd_global_error() was not updated to act
> upon the extra bits.
>=20
> Replace the RCANFD_GERFL_EEF[01] macros by a new macro that takes the
> channel number, fixing R-Car V3U while simplifying the code.
>=20
> Fixes: 45721c406dcf50d4 ("can: rcar_canfd: Add support for r8a779a0 SoC")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Added stable on Cc and added to linux-can.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ubstobhq47tay4vw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNbxuwACgkQrX5LkNig
013Qfgf/fkqiHPRNYQM2wioOyj/AM8EgMCMraqKrtalSn3zGZ5ZLKiX1KcnmSxdM
5dSpsWCM90ZckJN3VB6q10Mmu5N0ftC6xB8eK08JCwJqHz3g0ui40mlJtYoJ6g7H
69K/NjwkeMCM3ANPqHvlSQs/VmdZ9URcnb4MlWMI5dW3QC7QbyFSfR6M42Q0MTzN
P0CwQugvmMur1D5ZW9h5SndgcHiR1WS3YsdjZwN2S1p7HlZXcp0KLULBqHtmlyAQ
WJq+fx12rXPihiuGbVKX+dTW5chyV3kaR4sfSVYFU4gxVmTGTvM4bZsUkWuTstGW
7d9oV1fHbaHzW1+MgcuFl4+aI2Xl9A==
=SNJZ
-----END PGP SIGNATURE-----

--ubstobhq47tay4vw--
