Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E69954CEA82
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 11:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbiCFKdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 05:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiCFKdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 05:33:07 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBB92E08F
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 02:32:16 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nQoBF-0004LB-VG; Sun, 06 Mar 2022 11:32:02 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-8f62-2f8a-935c-c311.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:8f62:2f8a:935c:c311])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2747C4379C;
        Sun,  6 Mar 2022 10:32:00 +0000 (UTC)
Date:   Sun, 6 Mar 2022 11:31:59 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org
Subject: Re: [PATCH net-next 2/8] can: Use netif_rx().
Message-ID: <20220306103159.finurle6fsuuh3dr@pengutronix.de>
References: <20220305221252.3063812-1-bigeasy@linutronix.de>
 <20220305221252.3063812-3-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="37qpbsa3ilj53aqo"
Content-Disposition: inline
In-Reply-To: <20220305221252.3063812-3-bigeasy@linutronix.de>
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


--37qpbsa3ilj53aqo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.03.2022 23:12:46, Sebastian Andrzej Siewior wrote:
> Since commit
>    baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any =
context.")
>=20
> the function netif_rx() can be used in preemptible/thread context as
> well as in interrupt context.
>=20
> Use netif_rx().
>=20
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: linux-can@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--37qpbsa3ilj53aqo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIkjZ0ACgkQrX5LkNig
010akQf+Pe/ERk+OrCqRrKodP5Ic/V8uImPdpETHM9mTPUP9lhYNiFQGW25qEhAe
8SXMU5GqMaVVdTYSgCoIejNGxAC7HeVJL9/H8HOkQBq83AQFvikGYTWKLZ8hn/q1
2WXLGKAPyGjZ0ra9kNszQrjD2YRu0fe0W5MgmVPtreDczRMq4OuO4DbWAPoc5pqi
FI/FxRMLaZgIWcacodMtATBlaxi9pQ7x7SWAPYriFgLJJ+S95hVVWqVI5i+XgQHR
3h4SCTQ6gfsJXg8mwkGrAIENy9p4Nea9TQu7WmlAuHRgqSVmHgxWCs8RQIBpDQvn
nS8e5yVP36DeXsR1OcyC2h1j9gnKlw==
=c2C9
-----END PGP SIGNATURE-----

--37qpbsa3ilj53aqo--
