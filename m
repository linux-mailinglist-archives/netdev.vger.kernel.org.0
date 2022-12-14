Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57A164C4E5
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 09:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237585AbiLNISX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 03:18:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237595AbiLNIRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 03:17:35 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE0215838
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 00:17:07 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p5Mwd-0001pw-CB; Wed, 14 Dec 2022 09:16:51 +0100
Received: from pengutronix.de (hardanger.fritz.box [IPv6:2a03:f580:87bc:d400:631f:86da:f36:1a4c])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id DA88213E660;
        Wed, 14 Dec 2022 08:16:46 +0000 (UTC)
Date:   Wed, 14 Dec 2022 09:16:46 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: [PATCH] Documentation: devlink: add missing toc entry for
 etas_es58x devlink doc
Message-ID: <20221214081646.4ioxaktqqgqpz3ek@pengutronix.de>
References: <20221213153708.4f38a7cf@canb.auug.org.au>
 <20221213051136.721887-1-mailhol.vincent@wanadoo.fr>
 <20221213133954.f2msxale6a37bvvo@pengutronix.de>
 <20221213172351.4d251315@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="x6mwduzw5bnatglb"
Content-Disposition: inline
In-Reply-To: <20221213172351.4d251315@kernel.org>
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


--x6mwduzw5bnatglb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13.12.2022 17:23:51, Jakub Kicinski wrote:
> On Tue, 13 Dec 2022 14:39:54 +0100 Marc Kleine-Budde wrote:
> > On 13.12.2022 14:11:36, Vincent Mailhol wrote:
> > > toc entry is missing for etas_es58x devlink doc and triggers this war=
ning:
> > >=20
> > >   Documentation/networking/devlink/etas_es58x.rst: WARNING: document =
isn't included in any toctree
> > >=20
> > > Add the missing toc entry.
> > >=20
> > > Fixes: 9f63f96aac92 ("Documentation: devlink: add devlink documentati=
on for the etas_es58x driver")
> > > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr> =20
> >=20
> > Added to linux-can-next + added Reported-bys.
>=20
> To -next or not to -next, that is the question..

I missed the fact that net-next is closed and already merged to Linus's
tree. So this should go into net/master.

> FWIW the code is now in Linus's tree, but IDK how you forward your
> trees. We could also take this directly given the file being changed,
> but up to you.

Thanks for the heads up,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--x6mwduzw5bnatglb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOZhmsACgkQrX5LkNig
010vEQf8CrOT2oJH7Wim+sKk7y+Zzr7kjjiGltOmMd7ZNM/zSKSZgRqisbXV+PgY
Lx2gIseRvNJhAYGYquars9FnZpWweKfrh1XfKtdmsODBpViXuXp6ZIUItIl8ivl8
qfv8R8QXcnViMFSd6eK9a2MBVwVDZ+WuIciXAc2OHzbMD6K2hoDKS9pQ5e9tIMzS
Gr9fri1d7hIi/TdZmYQuXHA0WHBYXdBAoFUCBxvrM0k1aFrpGHKmNIfganGelDBv
fFm6N3ZOUHMm3ny3H/hMkMwJ29xVn0tMICIr+4sys0JRNMk2dD2grReAv6SXG2jj
spl8HPazP9nDzrG0J+JlYk/zNiQTjg==
=zp7I
-----END PGP SIGNATURE-----

--x6mwduzw5bnatglb--
