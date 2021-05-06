Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B60C374F3A
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 08:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbhEFGMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 02:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbhEFGM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 02:12:26 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516F8C061574
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 23:11:28 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1leXEI-0001Oq-SB; Thu, 06 May 2021 08:11:22 +0200
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1leXEH-0006OC-76; Thu, 06 May 2021 08:11:21 +0200
Date:   Thu, 6 May 2021 08:11:21 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     David Miller <davem@davemloft.net>
Cc:     axboe@kernel.dk, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        sparclinux@vger.kernel.org, kuba@kernel.org, jirislaby@kernel.org
Subject: Re: [PATCH] sparc/vio: make remove callback return void
Message-ID: <20210506061121.3flqmvm4jok6zj5z@pengutronix.de>
References: <20210505201449.195627-1-u.kleine-koenig@pengutronix.de>
 <20210505.132739.2022645880622422332.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7ykpqbhtw2snraxa"
Content-Disposition: inline
In-Reply-To: <20210505.132739.2022645880622422332.davem@davemloft.net>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7ykpqbhtw2snraxa
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, May 05, 2021 at 01:27:39PM -0700, David Miller wrote:
> From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> Date: Wed,  5 May 2021 22:14:49 +0200
>=20
> > The driver core ignores the return value of struct bus_type::remove()
> > because there is only little that can be done. To simplify the quest to
> > make this function return void, let struct vio_driver::remove() return
> > void, too. All users already unconditionally return 0, this commit makes
> > it obvious that returning an error code is a bad idea and should prevent
> > that future driver authors consider returning an error code.
> >=20
> > Note there are two nominally different implementations for a vio bus:
> > one in arch/sparc/kernel/vio.c and the other in
> > arch/powerpc/platforms/pseries/vio.c. This patch only addresses the
> > former.
> >=20
> > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>=20
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks for your Ack. My expectation was that this patch will go via a
sparc tree. Does your Ack mean that you think it should take a different
path?

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--7ykpqbhtw2snraxa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmCTiIYACgkQwfwUeK3K
7Akyewf9GGuVOF+VCCZkBtEvuUsC2Pxxc/JoxB5DmIocsggrrpOh06j+LsYO0PKf
SUD3UB48kEWMEn7yvaPyYqM/5A5GZy/vvJb65UEMOrGjWz+x8nJUwxeUZZ9oUgje
mZglUAbfvEQfUCVAgnxjzn9Wp0WQAQ3RaShkT8QvFJ63fZHrbjkGbm9eRDf2Kktk
/V3ZULOJ1kHPT+XF8lGBQ58KRktmYht0T6+Mykc90usi+v7xQW6Wv/bRBETpOI3q
8nZQDDUdjxI/6AfPUPHReZwffZW8d8uEWvGoQhN+s+vfD0MgDua+EYPibke7VQQL
LPvVc0yb5Ye5diDYK6uaKxDbwBeLdg==
=OqA9
-----END PGP SIGNATURE-----

--7ykpqbhtw2snraxa--
