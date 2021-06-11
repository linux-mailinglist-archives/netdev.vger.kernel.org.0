Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8493A3C83
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 09:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhFKHFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 03:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhFKHFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 03:05:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B018BC061574
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 00:03:19 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lrbC5-0007o2-Rg; Fri, 11 Jun 2021 09:03:05 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:4d4a:8a80:782c:77df])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 98DF6638E82;
        Fri, 11 Jun 2021 07:02:58 +0000 (UTC)
Date:   Fri, 11 Jun 2021 09:02:57 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     13145886936@163.com
Cc:     robin@protonic.nl, linux@rempel-privat.de, kernel@pengutronix.de,
        socketcan@hartkopp.net, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
Subject: Re: [PATCH net-next] can: j1939: socket: correct a grammatical error
Message-ID: <20210611070257.xbca7pi6hwjrynsn@pengutronix.de>
References: <20210611043933.17047-1-13145886936@163.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lpt7vlyp74ppkexj"
Content-Disposition: inline
In-Reply-To: <20210611043933.17047-1-13145886936@163.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lpt7vlyp74ppkexj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11.06.2021 12:39:33, 13145886936@163.com wrote:
> From: gushengxian <gushengxian@yulong.com>
>=20
> Correct a grammatical error.
>=20
> Signed-off-by: gushengxian <gushengxian@yulong.com>

Applied can-next/testing.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--lpt7vlyp74ppkexj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDDCp8ACgkQqclaivrt
76nxrQf/b0qn6ydgv+6zMROr7Yd7xpct4O1iDdgH2SfflTnQGQ/J21sU9UL71nKM
c0peAaZDERVcUeWpfitgAQ0CHSe6sEZ+ueB69W3GYL6gW3gJMU02Rexr2BtXir8G
YI7xsyNS/5ARS7XUMj30XA+Vf5qnyUnjf6kGHC6+dekDhMWIKtHhivp+tHMGZ+rz
3Enn0pW/ayAatm3+0WY1CRKYM0vfRPzEShMFt0cOb7prxhq2YMU9HSE+fkNuDmoZ
7Rm2x48XRrMuxSKfaDJiqBxx0rLWwLJN3mKEck1/yKpZInJBr51Qh+jS0eD3M36Q
5TcSjTokeNnbTqepzmYKPGcegVgd+w==
=FTh+
-----END PGP SIGNATURE-----

--lpt7vlyp74ppkexj--
