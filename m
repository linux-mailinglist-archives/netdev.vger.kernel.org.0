Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9521E3811EC
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 22:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhENUmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 16:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbhENUmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 16:42:00 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE965C061574
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 13:40:48 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lhebq-0006gJ-Pc; Fri, 14 May 2021 22:40:34 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:d2a9:f0ae:b10b:5ba5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 72CC96246D5;
        Fri, 14 May 2021 20:40:30 +0000 (UTC)
Date:   Fri, 14 May 2021 22:40:29 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/2] can: c_can: add ethtool support
Message-ID: <20210514204029.6zdrynvt46knc5c7@pengutronix.de>
References: <20210514165549.14365-2-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cktin5chp3dhzdpq"
Content-Disposition: inline
In-Reply-To: <20210514165549.14365-2-dariobin@libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cktin5chp3dhzdpq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.05.2021 18:55:47, Dario Binacchi wrote:
> With commit 132f2d45fb23 ("can: c_can: add support to 64 message objects")
> the number of message objects used for reception / transmission depends
> on FIFO size.
> The ethtools API support allows you to retrieve this info. Driver info
> has been added too.
>=20
> Signed-off-by: Dario Binacchi <dariobin@libero.it>

Applied to linux-can-next/testing

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--cktin5chp3dhzdpq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCe4DkACgkQqclaivrt
76nJDAf/Ug4AYRXPZMIoZQQ31dvajRuOknziK+XvMu6AwR1f7DoP+XNoH9JPW9Vp
lDyRG80Qe2e/c6vFwCi4fBfAnHmrfblla/y1aij6hvcwCEiVpw2Zq5w1+1W3EblF
xRkoC5CV8dzSJb8uvc6khJcjiQhcwBtmvCqyQ8QUWNyNtIc77ZeiObS2YOqb5YP6
H31WU4b47L5IDP69gh9Yea2vgrlaFEK/GJEAkF++QTOjdfc198ea2Ctb4MfilU7t
bzqP0WJC8clq2k0E2G+wk/WTvxuFRvL6Zkb1RBPgXsMiqz1vuVhlzfqowUF2gYO6
wYkIub6Qm30b8HpQPP+rldTGDv7oLA==
=DtEI
-----END PGP SIGNATURE-----

--cktin5chp3dhzdpq--
