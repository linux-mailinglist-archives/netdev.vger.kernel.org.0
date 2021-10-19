Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B2843321D
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 11:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235043AbhJSJZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 05:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbhJSJZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 05:25:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC323C06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 02:23:33 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mclLB-00052N-CE; Tue, 19 Oct 2021 11:23:25 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-6267-dd6f-bd00-49b6.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:6267:dd6f:bd00:49b6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 27707697F76;
        Tue, 19 Oct 2021 09:23:21 +0000 (UTC)
Date:   Tue, 19 Oct 2021 11:23:20 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Meng Li <Meng.Li@windriver.com>
Cc:     wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        mailhol.vincent@wanadoo.fr, socketcan@hartkopp.net,
        ramesh.shanmugasundaram@bp.renesas.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver: net: can: disable clock when it is in enable
 status
Message-ID: <20211019092320.wrs2o7cmn4pmnirt@pengutronix.de>
References: <20211019091416.16923-1-Meng.Li@windriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gcthovzhffxiqrug"
Content-Disposition: inline
In-Reply-To: <20211019091416.16923-1-Meng.Li@windriver.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gcthovzhffxiqrug
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19.10.2021 17:14:16, Meng Li wrote:
> If disable a clock when it is already in disable status, there
> will be a warning trace generated. So, it is need to confirm
> whether what status the clock is in before disable it.
>=20
> Fixes: a23b97e6255b ("can: rcar_can: Move Renesas CAN driver to rcar dir")
> Cc: stable@vger.kernel.org
> Signed-off-by: Meng Li <Meng.Li@windriver.com>

Thanks for your patch. This problem should have been resolved with:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=
=3Df7c05c3987dcfde9a4e8c2d533db013fabebca0d

regards
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--gcthovzhffxiqrug
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmFujoAACgkQqclaivrt
76nC/gf/TRlVrZAuKsSSQtKrMHoOPskhErX7SyAT4+3HLmjHx9ZI7TNUsQxzky5n
1tuEXlcPzKC8TGSqFrrBBqIUTGEFgZFozuzDBhEvh/AUQRpyP+BTxr1tRrVMBEvl
mxI9HYl/WDw38CgLNoqKuh1XlNcOPKjyXYnqWMCfmC5qAD3ilkKz+hjTyHwHxOKV
bvicXaMaeHsle9kDMpPYA0gZ8WLxXuykBlLhZsaQXeYS8Xoq3cWfDQFPQkMT5g+l
0qzusN90qhQfHYaZlxgXso6dhe9dxYP0G0AgGZCzWdyLhyNqZ4PfmtJeDMsAJrsK
wEhtgYcl+LMQ7o8ivu8sBoFPWh0LmA==
=LeJ8
-----END PGP SIGNATURE-----

--gcthovzhffxiqrug--
