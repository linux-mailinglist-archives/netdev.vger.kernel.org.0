Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7977A64068B
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 13:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbiLBMPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 07:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233345AbiLBMPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 07:15:23 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6DDD5847
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 04:15:23 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p14we-0008Hv-0H; Fri, 02 Dec 2022 13:15:08 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:63a6:d4c5:22e2:f72a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1C95A13156D;
        Fri,  2 Dec 2022 12:15:04 +0000 (UTC)
Date:   Fri, 2 Dec 2022 13:14:58 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Max Staudt <max@enpas.org>
Cc:     "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        dario.binacchi@amarulasolutions.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Palethorpe <richard.palethorpe@suse.com>,
        Petr Vorel <petr.vorel@suse.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org, ltp@lists.linux.it
Subject: Re: [PATCH] can: slcan: fix freed work crash
Message-ID: <20221202121458.qeqjzewvdbnqhvnt@pengutronix.de>
References: <20221201073426.17328-1-jirislaby@kernel.org>
 <20221202035242.155d54f4.max@enpas.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="x4q6zeagiapw3mdj"
Content-Disposition: inline
In-Reply-To: <20221202035242.155d54f4.max@enpas.org>
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


--x4q6zeagiapw3mdj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.12.2022 03:52:42, Max Staudt wrote:
> (CC: ltp@lists.linux.it because Petr did so.)
>=20
> Hi Jiry,
>=20
> Thanks for finding this!
>=20
>=20
> Your patch looks correct to me, so please have a
>=20
>   Reviewed-by: Max Staudt <max@enpas.org>
>=20
> for both this patch to slcan, as well as an 1:1 patch to can327.

Max, can you create a patch for the can327 driver?

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--x4q6zeagiapw3mdj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOJ7D8ACgkQrX5LkNig
013NnAf/Z62/13CIDQ7V894/ROU5ZGk6S6LRPGG/p7Q4oFGe7BxjDOn4Izk+wTGX
kisclotCPB1hsAfPi988cEjHEe2b6CXib1aZmtJOyGC8cuTgRvBimHElXGgDIUJe
NYsq2C+WZsGSQqHX6eSClICQZ0DrIsyidSrhZ3gsl0KKGxxLEV1oKhlYjLhM7Hx2
Ntd/uU3oFiOAIoRtDXORfGf1kleLK/XTvJMv1gg+NkTuYYh01HKXK7d42bthX1tP
X0a28lItgg4SyQMXm6tX3KJ8AMsbpMKHPhIjXSB/Fild1XdAvnhxnNuZYg4w1oPI
/Ib6xzyF13qn8t2HKAY0C8C3YfnTzw==
=EslA
-----END PGP SIGNATURE-----

--x4q6zeagiapw3mdj--
