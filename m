Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0865C3AC4CA
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 09:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbhFRHTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 03:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbhFRHTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 03:19:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582E7C061574
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 00:17:31 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lu8kk-0003gX-Sh; Fri, 18 Jun 2021 09:17:22 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:e7d0:b47e:7728:2b24])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 66FB563EA4B;
        Fri, 18 Jun 2021 07:15:33 +0000 (UTC)
Date:   Fri, 18 Jun 2021 09:15:32 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Robin van der Gracht <robin@protonic.nl>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        syzbot+bdf710cfc41c186fdff3@syzkaller.appspotmail.com,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] can: j1939: j1939_sk_init(): set SOCK_RCU_FREE to
 call sk_destruct() after RCU is done
Message-ID: <20210618071532.kr7o2rnx6ia4t6n6@pengutronix.de>
References: <20210617130623.12705-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="accmuapjky6tul3y"
Content-Disposition: inline
In-Reply-To: <20210617130623.12705-1-o.rempel@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--accmuapjky6tul3y
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17.06.2021 15:06:23, Oleksij Rempel wrote:
> Set SOCK_RCU_FREE to let RCU to call sk_destruct() on completion.
> Without this patch, we will run in to j1939_can_recv() after priv was
> freed by j1939_sk_release()->j1939_sk_sock_destruct()
>=20
> Reported-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Reported-by: syzbot+bdf710cfc41c186fdff3@syzkaller.appspotmail.com
> Fixes: 25fe97cb7620 ("can: j1939: move j1939_priv_put() into sk_destruct =
callback")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Applied to linux-can/testing.

Thanks,
Marc
--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--accmuapjky6tul3y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDMSBIACgkQqclaivrt
76l4EQf/eQFCAisRXL95N/VcHXQ0ZG5FhJztpGqR4PGTpK3XAvS2KaHwX2RpekDl
ezrqPMDsLeDVTVXhUYsLOQWrtfEXrUO2nk4Rhv83jxIDZy5RjOrtziPt9damyMJM
ZfIS5+bkInegRE8++p9nLYi1S2vuyzhhdMqe4jlRaQ8XRc7/naoOY9A/gUi7OCCR
v7aLBehASTxI/hskP7ETX3g0/p0CFFSBnkCdOlVObwTwHRHWrrky5jdICRC+GWcq
SF422Kfy61t0vdZ8yVkCIsuDDbqxhTRkOQo4rsSCbTaHRkqwGUC7HCHoSKO79Z6T
O5ux1T8aOwG+c8o6o/oqbVNEZrG5YA==
=ZtWx
-----END PGP SIGNATURE-----

--accmuapjky6tul3y--
