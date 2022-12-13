Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479CF64B0E9
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 09:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbiLMIPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 03:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234717AbiLMIPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 03:15:30 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8303EB876
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 00:15:29 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p50Rb-0003q5-7Z; Tue, 13 Dec 2022 09:15:19 +0100
Received: from pengutronix.de (hardanger.fritz.box [IPv6:2a03:f580:87bc:d400:7718:f6d6:39bc:6089])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 422F813D841;
        Tue, 13 Dec 2022 08:15:16 +0000 (UTC)
Date:   Tue, 13 Dec 2022 09:15:16 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: [PATCH] Documentation: devlink: add missing toc entry for
 etas_es58x devlink doc
Message-ID: <20221213081516.fsvsl4b7jhlxm5qr@pengutronix.de>
References: <20221213153708.4f38a7cf@canb.auug.org.au>
 <20221213051136.721887-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lyvz3jzvztfk523c"
Content-Disposition: inline
In-Reply-To: <20221213051136.721887-1-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lyvz3jzvztfk523c
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13.12.2022 14:11:36, Vincent Mailhol wrote:
> toc entry is missing for etas_es58x devlink doc and triggers this warning:
>=20
>   Documentation/networking/devlink/etas_es58x.rst: WARNING: document isn'=
t included in any toctree
>=20
> Add the missing toc entry.
>=20
> Fixes: 9f63f96aac92 ("Documentation: devlink: add devlink documentation f=
or the etas_es58x driver")
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Added to linux-can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--lyvz3jzvztfk523c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOYNJEACgkQrX5LkNig
010jzgf/UgJ0hC22ANU2PePS2i5ZhsAspJEpHSkICqzIPNePOfKA7gn5gC3ADk6G
sCrRm2TStbIRcz+cSynGf1GbXgwwePft4Qm46igsWBBdtlJwrB/AtkffFodOSZ3Y
TrDncFfrTccEXfL86/q35pQQm1nDL5zVzLaTkCI8P8W+q4VtiI2MP1FTWw0Ji5fh
gYcbnksck/chX6bCyYwv8UhKJfsDP63d7IbYrHpY/xYNEWi6i+4i8HPQZKz3RNnB
Dkl4sRUtJWh+yW1key9J+Rj+q3Ao7Kv+Y+ZzvCAui6o5x3iFMcS5DnD/UZoqQP7w
l9f9HKMPNwaqoxxqFQ4N59QZZDYdYQ==
=2Gff
-----END PGP SIGNATURE-----

--lyvz3jzvztfk523c--
