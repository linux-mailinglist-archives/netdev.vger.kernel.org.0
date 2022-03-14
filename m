Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 950AD4D82DE
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 13:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240743AbiCNMLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 08:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241776AbiCNMJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 08:09:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1417A50444
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 05:06:00 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nTjSG-0006MY-0k; Mon, 14 Mar 2022 13:05:40 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-cd06-1d72-9fa6-b58a.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:cd06:1d72:9fa6:b58a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AA0FD4AE7C;
        Mon, 14 Mar 2022 12:05:02 +0000 (UTC)
Date:   Mon, 14 Mar 2022 13:05:02 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 27/30] can: ucan: fix typos in comments
Message-ID: <20220314120502.kpc27kzk2dnou2td@pengutronix.de>
References: <20220314115354.144023-1-Julia.Lawall@inria.fr>
 <20220314115354.144023-28-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="utbqex7kud7q6aoc"
Content-Disposition: inline
In-Reply-To: <20220314115354.144023-28-Julia.Lawall@inria.fr>
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


--utbqex7kud7q6aoc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.03.2022 12:53:51, Julia Lawall wrote:
> Various spelling mistakes in comments.
> Detected with the help of Coccinelle.
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

Should I take this, or are you going to upstream this?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--utbqex7kud7q6aoc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIvL2sACgkQrX5LkNig
013ghgf+OFs60+q+Dd4p/sUmD7ZvtB2QitZ69mbLVzun53kAWpiwm8dMpruvkzVv
3fJoo1LQf3RatjI3X1VdBhhPiXydxXqsPyPKM+wqGIFx4eBvUVVX2tqkJWa8fCiT
thYXj2u52KL/ewRCqY2n2P/SV9TZkBh1XCi0VfNJXctig/trq6EI8ggC5WDHPyqS
F+RLj00w4KXI1qm0cB81jzv9UV0I2yBhkdPhXcNZB6Wc7vgEeTufJwMwyPScrEVB
NopO4WdprdujxEEXl01ajOknMu6cuI2XCyVLWljYENYCbCfQ1AV19uYrYbTazGP/
iyaki+mj1/3mHLwV1NfiqnMPC0u8ug==
=Z0sl
-----END PGP SIGNATURE-----

--utbqex7kud7q6aoc--
