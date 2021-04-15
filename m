Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F094036052D
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 11:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbhDOJEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 05:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbhDOJDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 05:03:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6C7C06175F
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 02:03:26 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lWxu9-00013A-Ns; Thu, 15 Apr 2021 11:03:17 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:983:856d:54dc:ee1c])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E2DC960F2D5;
        Thu, 15 Apr 2021 09:03:14 +0000 (UTC)
Date:   Thu, 15 Apr 2021 11:03:14 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Colin King <colin.king@canonical.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] can: etas_es58x: Fix potential null pointer
 dereference on pointer cf
Message-ID: <20210415090314.vvyvr2wihwnauyi6@pengutronix.de>
References: <20210415085535.1808272-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7e3ebrdbrcx3sqls"
Content-Disposition: inline
In-Reply-To: <20210415085535.1808272-1-colin.king@canonical.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7e3ebrdbrcx3sqls
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.04.2021 09:55:35, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>=20
> The pointer cf is being null checked earlier in the code, however the
> update of the rx_bytes statistics is dereferencing cf without null
> checking cf.  Fix this by moving the statement into the following code
> block that has a null cf check.
>=20
> Addresses-Coverity: ("Dereference after null check")
> Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CA=
N USB interfaces")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

A somewhat different fix is already in net-next/master

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/=
?id=3De2b1e4b532abdd39bfb7313146153815e370d60c

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--7e3ebrdbrcx3sqls
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmB4AU8ACgkQqclaivrt
76kJ4Qf6AjMxbSUwQpN3Q7AkPMl6N7dnvgRstIgDwT/bEwd+/CKvK2Wortipw6Pa
FbWHTZp+L1/S2Cue4uDFyqn/aJ4hwDYwp1qSImA3cwqsb1WV40/+VVjO1UBHEBA7
Apz7ycNmGVVvGS6wqvqOvxERLCccEiyny+QJoNeDaRiEZ5DcKHfvgrF8lMG5qolO
uGSp6jS/1OE4QlqUMNYuKIPRqWOZNIhd5JnzQPx2EnTQ3MR5HMD1sJZRh42qa6Ov
1ZcE15c2W6B8IJBAuvCbf9m+fCpNB0lYwM4SrvDa7vJtRp3ctJdcC70W4m2XXrUe
Dwi/OimD4yCeTWuetmUu9Yy3FCGdLg==
=/Z25
-----END PGP SIGNATURE-----

--7e3ebrdbrcx3sqls--
