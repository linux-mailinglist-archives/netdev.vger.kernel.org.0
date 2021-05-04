Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A41372FEE
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 20:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbhEDSuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 14:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbhEDSuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 14:50:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7528C061574
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 11:49:08 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1le06N-0001tO-A3; Tue, 04 May 2021 20:48:59 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:4880:7cee:6dec:c8f9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5BC2E61BEE7;
        Tue,  4 May 2021 18:48:55 +0000 (UTC)
Date:   Tue, 4 May 2021 20:48:54 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Schrempf Frieder <frieder.schrempf@kontron.de>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Timo =?utf-8?B?U2NobMO8w59sZXI=?= <schluessler@krause.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tim Harvey <tharvey@gateworks.com>, stable@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: mcp251x: Fix resume from sleep before interface was
 brought up
Message-ID: <20210504184854.urgotqioxtjwbqqs@pengutronix.de>
References: <bd466d82-db03-38b1-0a13-86aa124680ea@kontron.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="v3vthzpowlfzvmol"
Content-Disposition: inline
In-Reply-To: <bd466d82-db03-38b1-0a13-86aa124680ea@kontron.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--v3vthzpowlfzvmol
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.05.2021 18:01:48, Schrempf Frieder wrote:
> Since 8ce8c0abcba3 the driver queues work via priv->restart_work when
> resuming after suspend, even when the interface was not previously
> enabled. This causes a null dereference error as the workqueue is
> only allocated and initialized in mcp251x_open().
>=20
> To fix this we move the workqueue init to mcp251x_can_probe() as
> there is no reason to do it later and repeat it whenever
> mcp251x_open() is called.
>=20
> Fixes: 8ce8c0abcba3 ("can: mcp251x: only reset hardware as required")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>

Added to linux-can/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--v3vthzpowlfzvmol
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCRlxMACgkQqclaivrt
76nZFQf9EALD3jMJEXRfahZ9zzZjCS+oJe2TkoDOtMQx/TPnhe//XQfoRoRfvstv
e6AiN8Ir407VR6BSQaTTq6LaBd6VaoviRlywrUzbnKBzv4w2nvriWy250ML5KcST
8N+6lgvPhNOQP190kAUvYzy98mzWEbEMTIkknMnvz+wEz2JV70zD/AZAiTGUpQmE
fX+lc6RPC10zyX3QIXP6Um2yRit63INe4OFlzLv1dhfSeG89NTM+FcDnI2Nqeoqc
v4eTX2gC+k5kFNkI1xYdilv6w93gAB/YE10K0SwdjVxe7QdHsqVUy8eMpi+cDabH
9kZM4iWDNmeE4ayU2C3VZ+1hX/ANOw==
=thfL
-----END PGP SIGNATURE-----

--v3vthzpowlfzvmol--
