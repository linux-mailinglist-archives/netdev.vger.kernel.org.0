Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A96035C127
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 11:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240374AbhDLJXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 05:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238409AbhDLJVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 05:21:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4B1C06134E
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 02:20:11 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lVsjk-0005qq-Hq; Mon, 12 Apr 2021 11:20:04 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:3d5d:9164:44d1:db57])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AFF9160CC68;
        Mon, 12 Apr 2021 09:20:02 +0000 (UTC)
Date:   Mon, 12 Apr 2021 11:20:01 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
Subject: Re: [PATCH v15 0/3] Introducing ETAS ES58X CAN USB interfaces
Message-ID: <20210412092001.7vp7dtbvsb6bgh2t@pengutronix.de>
References: <20210410095948.233305-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lmvu7bpch25yya7y"
Content-Disposition: inline
In-Reply-To: <20210410095948.233305-1-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lmvu7bpch25yya7y
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10.04.2021 18:59:45, Vincent Mailhol wrote:
> Here comes the 15th iteration of the patch. This new version addresses
> the comments received from Marc (thanks again for the review!) and
> simplify the device probing by using .driver_info.

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/=
usb/etas_es58x/es58x_core.c
index 35ba8af89b2e..7222b3b6ca46 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -1096,7 +1096,7 @@ static void es58x_increment_rx_errors(struct es58x_de=
vice *es58x_dev)
  *     be aligned.
  *
  * Sends the URB command to the device specific function. Manages the
- * errors throwed back by those functions.
+ * errors thrown back by those functions.
  */
 static void es58x_handle_urb_cmd(struct es58x_device *es58x_dev,
                                 const union es58x_urb_cmd *urb_cmd)

I have applied to linux-can-next/testing with the above spell fix.
Thanks for the steady work on this and all the other features.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--lmvu7bpch25yya7y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmB0ELwACgkQqclaivrt
76k1EQf/bDNVY5jlsoDnEytekfBndAaWBeFbxyFEdA3ZvKPdxdl6OPR2P3oV+ZNx
6xfRBahq1UecL4cdFjE9rILg3WEy66kImw/gS2mXJDehw0+d0bcYNGIv0BwbdAbQ
vMQ+OtnoOMxdHy5LjC9s8wFxCbrVWwl28vEvsi4PHmhTnOEke3pDTN6Q9/y2noot
RtE1dF8i6KwdKkaUsINmzNsu0a1mY1Jwh1u1giYaLhAWCHPV1bfX31VWnHQGaxv3
k/u71Q/4dNuITI9yPf6rLmw2/iEF/oepG1+8EpS7ie+cBHyke3oTEwOKjC7EJ9zg
MeMvuCjGSQaU0ahipgGhB307bs5FBg==
=aGCF
-----END PGP SIGNATURE-----

--lmvu7bpch25yya7y--
