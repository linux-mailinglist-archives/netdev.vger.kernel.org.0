Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74ECA4D860C
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 14:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241888AbiCNNht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 09:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240818AbiCNNho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 09:37:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F1F26AD2
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 06:36:33 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nTks5-0008Up-Gm; Mon, 14 Mar 2022 14:36:25 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-cd06-1d72-9fa6-b58a.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:cd06:1d72:9fa6:b58a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id F37984AF3E;
        Mon, 14 Mar 2022 13:36:23 +0000 (UTC)
Date:   Mon, 14 Mar 2022 14:36:23 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 27/30] can: ucan: fix typos in comments
Message-ID: <20220314133623.76gzah6hidfvvtto@pengutronix.de>
References: <20220314115354.144023-1-Julia.Lawall@inria.fr>
 <20220314115354.144023-28-Julia.Lawall@inria.fr>
 <20220314120502.kpc27kzk2dnou2td@pengutronix.de>
 <alpine.DEB.2.22.394.2203141402480.2561@hadrien>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dcy3gzpbwvxexksz"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.22.394.2203141402480.2561@hadrien>
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


--dcy3gzpbwvxexksz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.03.2022 14:03:01, Julia Lawall wrote:
>=20
>=20
> On Mon, 14 Mar 2022, Marc Kleine-Budde wrote:
>=20
> > On 14.03.2022 12:53:51, Julia Lawall wrote:
> > > Various spelling mistakes in comments.
> > > Detected with the help of Coccinelle.
> > >
> > > Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> >
> > Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
> >
> > Should I take this, or are you going to upstream this?
>=20
> You can take it.

Added to linux-can-next/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--dcy3gzpbwvxexksz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIvRNQACgkQrX5LkNig
013LcAf+MtDL13gETAZZ09eOdGZRta5+/qsmzl9CxkS37+Ix/AwgGdNZ29U+C4fj
LNxzGGgOm0fPIBld2oNeMLJsnwRQcB44HCn52ZdRWCqv7ttciTr7IZoCfRfFXzeO
YIgqwmIx9ioPnqXhU8dsfvuX2ZyAMQIWHKBF/dFGZkD/24hlosQMRJ//0mYwpKIq
ho4tBNiPSKijnXURZuzhyDFswqdZf4H1I7xzRFAcTA/2irWwtGHCI64KBkYIwyjP
SP4fuWkao4B70/3tEf2Rkku4jckASHTzB4e/DQE+POXsfv/V8HaLS5Q9rJLRmqEG
zDqrpJpGIGQs9HAO1yDQmW7KgQ8EuA==
=EBS7
-----END PGP SIGNATURE-----

--dcy3gzpbwvxexksz--
