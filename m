Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520DF6D92E1
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 11:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbjDFJgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 05:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236498AbjDFJgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 05:36:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0589146B2
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:36:07 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pkM2G-0008Q3-QX; Thu, 06 Apr 2023 11:36:04 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 90AFD1A7FD8;
        Thu,  6 Apr 2023 07:44:24 +0000 (UTC)
Date:   Thu, 6 Apr 2023 09:44:23 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] can: CAN_BXCAN should depend on ARCH_STM32
Message-ID: <20230406-choice-tremble-e49e7967747b@pengutronix.de>
References: <40095112efd1b2214e4223109fd9f0c6d0158a2d.1680609318.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wbtaudnlognaudah"
Content-Disposition: inline
In-Reply-To: <40095112efd1b2214e4223109fd9f0c6d0158a2d.1680609318.git.geert+renesas@glider.be>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wbtaudnlognaudah
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.04.2023 13:59:00, Geert Uytterhoeven wrote:
> The STMicroelectronics STM32 basic extended CAN Controller (bxCAN) is
> only present on STM32 SoCs.  Hence drop the "|| OF" part from its
> dependency rule, to prevent asking the user about this driver when
> configuring a kernel without STM32 SoC support.
>=20
> Fixes: f00647d8127be4d3 ("can: bxcan: add support for ST bxCAN controller=
")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Applied to linux-can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--wbtaudnlognaudah
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQueFQACgkQvlAcSiqK
BOj7lwf+OyVXNEtWVL+T3SDIVOBN3QUjzyyETldw5+Ww9EymokAB47Xo4Dn3VEZy
Eo2qIsHunlRIK9Bn9LQQTWLVPtAxJAlMaFOaGo3KjQP5D9E54wpCzKfoPOLeROUN
tuQKlkiwRD6FxOWl3IXsDRKGeTSaYEfoFMux9755/aL7kML0M7FDLDut1CwvWEmb
rvOXamsvQSXabKGMqy80QN/HUle9e/XTmzbbZMDmoagEA8/TO/MfLvQjFjpMU7Gk
OGZx3Qfq+3eTTiHFtzPfBkBG65rR/V37Oqt3vMq/LeNNhtWe2ucm2WxhtHWpZ4ys
1qzxcu42oOg6v6lEUQE5KYR5AxI7jw==
=sgpy
-----END PGP SIGNATURE-----

--wbtaudnlognaudah--
