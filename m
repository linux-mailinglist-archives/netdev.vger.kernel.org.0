Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93CC586078
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 20:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237661AbiGaSzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 14:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiGaSzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 14:55:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5045BC8F
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 11:55:00 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oIE5O-0004Up-97; Sun, 31 Jul 2022 20:54:46 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 35CBCBEBCA;
        Sun, 31 Jul 2022 18:54:45 +0000 (UTC)
Date:   Sun, 31 Jul 2022 20:54:44 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Max Staudt <max@enpas.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] can: can327: Fix a broken link to Documentation
Message-ID: <20220731185444.vzfvbd6hkrrmqfio@pengutronix.de>
References: <6a54aff884ea4f84b661527d75aabd6632140715.1659249135.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qxo3ypmddngiucvw"
Content-Disposition: inline
In-Reply-To: <6a54aff884ea4f84b661527d75aabd6632140715.1659249135.git.christophe.jaillet@wanadoo.fr>
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


--qxo3ypmddngiucvw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 31.07.2022 08:32:52, Christophe JAILLET wrote:
> Since commit 482a4360c56a ("docs: networking: convert netdevices.txt to
> ReST"), Documentation/networking/netdevices.txt has been replaced by
> Documentation/networking/netdevices.rst.
>=20
> Update the comment accordingly to avoid a 'make htmldocs' warning
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied to linux-can-next/master.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--qxo3ypmddngiucvw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLmz/EACgkQrX5LkNig
011I1ggAqDDECmOnJPHI92zr3DChAcs4FvS0hToEExWus5JBiQoaQahSwv9M2Mp7
ZssuPsRFz2Ew24nwlzxmaPOE+jgU9+QGId8c7SBu0LsSfLjh3c5qqTIMHPTrhoWi
6esRvMnuZ/CgWo/5sSJxKQWrfPiY8eAHB8Z5ClWk5SogPu0fCf9F08paPTO8bV1Y
5oG0RGXm03xD10LSLOCfh+cRbGKVjF/a+YfpGSaSC8cl1TNDKjhj3wz3D7p5lN0Y
BzajR07lHYLII6cpKECQK0RTCq5yQAwoFwtL6M6gW9TFlUbUNZyez16+qE6N7fUv
pkjQ2Xf4fKLijL8bnr5HstzDkC0sQQ==
=OuOE
-----END PGP SIGNATURE-----

--qxo3ypmddngiucvw--
