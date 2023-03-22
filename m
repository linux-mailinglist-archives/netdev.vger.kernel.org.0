Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4CD6C4512
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 09:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjCVIey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 04:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjCVIet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 04:34:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D9432CC8
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 01:34:49 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1petvT-0001pr-0z; Wed, 22 Mar 2023 09:34:31 +0100
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E5A0E19952C;
        Wed, 22 Mar 2023 08:34:28 +0000 (UTC)
Date:   Wed, 22 Mar 2023 09:34:27 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v4 0/2] can: rcar_canfd: Add transceiver support
Message-ID: <20230322083427.gpctjxsbli4jwymg@pengutronix.de>
References: <cover.1679414936.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="d7myp4lk3xjjti3m"
Content-Disposition: inline
In-Reply-To: <cover.1679414936.git.geert+renesas@glider.be>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--d7myp4lk3xjjti3m
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21.03.2023 17:14:59, Geert Uytterhoeven wrote:
> 	Hi all,
>=20
> This patch series adds transceiver support to the Renesas R-Car CAN-FD
> driver, and improves the printing of error messages, as requested by
> Vincent.
>=20
> Originally, both patches were submitted separately, but as the latter
> depends on the former, I absorbed it within this series for the resend.

Applied to linux-can-next. I've squashed the improved error message for
the phy_power_on() into patch 1.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129  |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--d7myp4lk3xjjti3m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQavZAACgkQvlAcSiqK
BOiOhgf9HPvv0c966rIStZyowDe97ypON9Wk1ZnAiDd89nMPZelPkSe/+pT8YwKn
ZbG+dmUfArhJryAEfQXY02aFBiEO0wiB9PiG1Sf85pyHvWCd8x+81UiVxXYqo6c/
m9TKwjO2h4As6nJZLRySkSMsEaD94CbFEJqBa/NMah2pse9dVqTxDUrlLv8xni1A
G37oWxkxYmMD29fm1iF6DBR/G6Zlwo/ZctvmDRKm81bE2gXh+TYmLJVU7O3Khwmy
qnkIrlgtwE54rtteyeu7g/IHmkLQFNtPxUlWVZnn6CvvgFbglfkZ0v1r9rG6BtYx
ufoy809tMXJncwrRoEh8TDSSBbKCtA==
=O164
-----END PGP SIGNATURE-----

--d7myp4lk3xjjti3m--
