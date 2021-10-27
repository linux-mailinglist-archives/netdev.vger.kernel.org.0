Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A68743C418
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 09:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240545AbhJ0Hlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 03:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240542AbhJ0Hlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 03:41:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96828C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 00:39:10 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mfdWd-0006Vw-Cs; Wed, 27 Oct 2021 09:39:07 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-7316-ec5d-e57a-90b9.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:7316:ec5d:e57a:90b9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 0F75C69EDB8;
        Wed, 27 Oct 2021 07:39:06 +0000 (UTC)
Date:   Wed, 27 Oct 2021 09:39:05 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] can: etas_es58x: es58x_rx_err_msg: fix memory leak in
 error path
Message-ID: <20211027073905.aff3mmonp7a3itrn@pengutronix.de>
References: <20211026180740.1953265-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="so4fmimmw6kiun32"
Content-Disposition: inline
In-Reply-To: <20211026180740.1953265-1-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--so4fmimmw6kiun32
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.10.2021 03:07:40, Vincent Mailhol wrote:
> In es58x_rx_err_msg(), if can->do_set_mode() fails, the function
> directly returns without calling netif_rx(skb). This means that the
> skb previously allocated by alloc_can_err_skb() is not freed. In other
> terms, this is a memory leak.
>=20
> This patch simply removes the return statement in the error branch and
> let the function continue.
>=20
> * Appendix: how the issue was found *

Thanks for the explanation, but I think I'll remove the appendix while
applying.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--so4fmimmw6kiun32
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmF5AhYACgkQqclaivrt
76nlNgf+Nst6/jhatMuQ6s55GqXjlZM4LItQalQjTFtFT8heBKLfM3/CypSNlkGe
T5/1RfrQCGnLMMlnk3bbl/01DR5dG8CqnU1wNahQcQydYSe2ApXYE7hgM2ow6NLn
wHgtpD8IW30GDyNRDgjv8woi0UUpk52wqz4hsmUE3OhzBhhMHSZ+sydSIIrlwARF
35VDMgHaW8d8FLOLgHkQ84zAnLsvdhe2gDAHSoKHygUcLG1cOQeUuBD9c9Ugq1xD
nKIj2fW0i0G8ojCUB1vg45D/SR1oRdgNa+XH08nDOjMR29NM+6ALgQ8zzHza4KF0
1OPX3s4bxeqz6h3bosAZuSR9JxIzOQ==
=wcGt
-----END PGP SIGNATURE-----

--so4fmimmw6kiun32--
