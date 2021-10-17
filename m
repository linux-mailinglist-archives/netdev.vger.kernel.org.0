Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D4B43080C
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 12:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245338AbhJQKnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 06:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245333AbhJQKnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 06:43:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D26C061765
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 03:41:00 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mc3b1-0001xb-0R; Sun, 17 Oct 2021 12:40:51 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-11af-1534-a8a1-94ea.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:11af:1534:a8a1:94ea])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 045946958B1;
        Sun, 17 Oct 2021 10:40:49 +0000 (UTC)
Date:   Sun, 17 Oct 2021 12:40:48 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     robin@protonic.nl, linux@rempel-privat.de, socketcan@hartkopp.net,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] can: j1939: fix errant alert in j1939_tp_rxtimer
Message-ID: <20211017104048.lkodbwh3f5iqqgcq@pengutronix.de>
References: <20210906094219.95924-1-william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tbw24fem2sqsw5rh"
Content-Disposition: inline
In-Reply-To: <20210906094219.95924-1-william.xuanziyang@huawei.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tbw24fem2sqsw5rh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 06.09.2021 17:42:19, Ziyang Xuan wrote:
> When the session state is J1939_SESSION_DONE, j1939_tp_rxtimer() will
> give an alert "rx timeout, send abort", but do nothing actually.
> Move the alert into session active judgment condition, it is more
> reasonable.
>=20
> One of the scenarioes is that j1939_tp_rxtimer() execute followed by
             scenarios

Typo fixed while applying.

> j1939_xtp_rx_abort_one(). After j1939_xtp_rx_abort_one(), the session
> state is J1939_SESSION_DONE, then j1939_tp_rxtimer() give an alert.
>=20
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>

Added to linux-can/testing, added stable on Cc.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--tbw24fem2sqsw5rh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmFr/a4ACgkQqclaivrt
76mBJwf9G6w7bBDtIoaURGYok6UdZsn3FikNLn2EpTiYbO4c0rQb0oEdrHLm2vaS
hD/889Mcn0GYgStPgbAeF756pQbwtndVQUU2iIzpEXKbhX3914wdQ8TOzZbRiWbY
jQ+zmBZibV06rlfN2r4n6iWQrBX2UCuHU0B5NBTWIQQvm/LfRHQVmZSmgRGQrE5H
Pb/B/GkeWXOMYfMihcCdV3krfmNscLjXG2te+yOmNVIQXC9p9/zVwjLIAht1HpsE
FLc1eWPpeMOlLPlyor0Wyx+DZBug2zPQ5laUMQPeza6U6YFA80xYssQpC2nIGyma
xflHutzNaKoTeMsM0NHnplP/jXpygg==
=FaKl
-----END PGP SIGNATURE-----

--tbw24fem2sqsw5rh--
