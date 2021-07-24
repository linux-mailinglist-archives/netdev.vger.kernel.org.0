Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43E33D4A17
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 23:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhGXUqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 16:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhGXUqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 16:46:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A74CC061575
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 14:26:39 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m7PAC-0008Kz-54; Sat, 24 Jul 2021 23:26:28 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:41cc:c65c:f580:3bde])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E5E5D6571A6;
        Sat, 24 Jul 2021 21:26:23 +0000 (UTC)
Date:   Sat, 24 Jul 2021 23:26:23 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     socketcan@hartkopp.net, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] can: raw: fix raw_rcv panic for sock UAF
Message-ID: <20210724212623.65as5y2pbg4lnspr@pengutronix.de>
References: <20210722070819.1048263-1-william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="n7g5vkbmqkimt2k7"
Content-Disposition: inline
In-Reply-To: <20210722070819.1048263-1-william.xuanziyang@huawei.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--n7g5vkbmqkimt2k7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22.07.2021 15:08:19, Ziyang Xuan wrote:
> We get a bug during ltp can_filter test as following.

Applied to can/testing.

Thnx,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--n7g5vkbmqkimt2k7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmD8hXwACgkQqclaivrt
76kpzwf+IvbX45gTtbq+bVmqxxagIwV7wAFjfT0TCVXPynz/NWoFp7pCk9yWUdyj
o7P9B0S+ew4SanmD/CTjCBd9rcnj6VTeK64mGwZo7BX4HPXYUdPsC5C4n/C6ivji
uNJPE1nlgJ21+HVQTttjgBltHVQ60bmQUIarDwkGZEQopArFvynGxwTkZU6m/y9q
uTEcp97i3Sq2rXp+yY88mHwr3ApBaX33AHZY508jcMIo4hWTqs0ufzeAJYO6pa6W
7NUowWOBYTqw6XMUO1I6hXJ95UB/bsaoCRE0lNw5TiEv8VuJPeZ1or36BZikgbqE
97JqNendkCmvQIOGo78Ek3mi1887CA==
=aSm0
-----END PGP SIGNATURE-----

--n7g5vkbmqkimt2k7--
