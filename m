Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDD61E1BE8
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 09:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731470AbgEZHGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 03:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730279AbgEZHGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 03:06:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC0EC061A0E
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 00:06:04 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jdTez-0001OC-Lf; Tue, 26 May 2020 09:06:01 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jdTey-0006fQ-QE; Tue, 26 May 2020 09:06:00 +0200
Date:   Tue, 26 May 2020 09:06:00 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        mkl@pengutronix.de, kernel@pengutronix.de,
        David Jander <david@protonic.nl>
Subject: PHYs with advanced cable diagnostic support
Message-ID: <20200526070600.hw3fjlvevjy4prho@pengutronix.de>
References: <20200511141310.GA2543@pengutronix.de>
 <20200511145926.GC8503@lion.mk-sys.cz>
 <20200512064858.GA16536@pengutronix.de>
 <20200512130418.GF409897@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="h6z4u5j6gfsdwci3"
Content-Disposition: inline
In-Reply-To: <20200512130418.GF409897@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:43:22 up 192 days, 22:01, 191 users,  load average: 1.24, 1.29,
 1.07
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--h6z4u5j6gfsdwci3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

I was looking for PHYs with more advanced cable testing support and
information how it should be done properly.

So far I found this links:

A general information with some interesting examples:
https://www.ti.com/lit/an/slyt755/slyt755.pdf

A PHY with the impulse amplitude and times storage, for multiple
impulses:
http://www.ti.com/lit/ds/symlink/dp83867cr.pdf
---------------------------------------------------------------------------=
-----
TDR measurement is allowed in the DP83867 in the following scenarios:
* While Link partner is disconnected - cable is unplugged at the other side
* Link partner is connected but remains quiet (for example,in power-down mo=
de)
* TDR could be automatically activated when the link fails or is dropped by
setting bit 7 of register 0x0009(CFG1). The results of the TDR run after the
link fails are saved in the TDR registers.
---------------------------------------------------------------------------=
-----

It has following configuration bits:
- TDR AUTO RUN: Automatic TDR on Link Down (can be done is software for
  all PHYs)
- TDR_AVG_NUM: number Of TDR Cycles (is it good to know, how many TDR
  cycle we do?)
- TDR_CYCLE_TIME: Set the time for each TDR cycle (is it needed to
  sample only nearest damage? Probably this well need an UAPI for this)

Making an automatic cable test on the link drop seems to be an
interesting idea. May be we should do it for all PHY with cable test
support?

Regards,
Oleksij

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--h6z4u5j6gfsdwci3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl7Mv9QACgkQ4omh9DUa
UbOJaQ//eDnEn7kp2z0unTeLELVWAwUEKFyWDStrw6+m2Eo2oBsvnJI5jLN0jGWo
jGF8SVy9GGBmjhPWhRWZX+sLNWx5Yc78aDJOVF8SjvH052rjh8n2XzIw1lwVrtwn
Ok3wCbRlRFEyySuLTdWrRSjEY40XTYEDaoxdvR0L3PmmAng6uaSdYTcoPmWvYyfQ
0L9jnjKbIUuOjpql1vZeb1QyHsQMRMk4V/L1NkevWVp189d4lj2UO9IQ/kB490AN
ktlH+fIHtM52EjMS7sBCcH2bT+2L8L2ETS3pO7+Fy6h+vywF9rLA8XP8xl1D0EjD
i692EM/XK/UyCOeSBe2jLHRgdjOMME5Hz3EDbxve0X4cPWD2s+ROd+uCFatW57KV
qxotpJRe+mRLSd6xhzhQu0lssGwsFb1EFritowHM5pnWcsYXMqplyeUdZlYwtz63
atETfzAL5PJ86tfPchDkNG0WLB+FdUqxGyTqgmxs7C0CQiaf0uG4myYFnvBJyWEV
rosMNnJ3MZejVotcjUzLOBU6q2HKOuHD5n51x2eB6PzI0yc3335CiulzMicu5Osy
YD8RnTriBD40PN3vTi4fgDiuC6MAp6O9Qcv+8E/aJYdUcz3yNYU1ic6Xf5BmMj9l
Vfrq6Kg9p1y1+q6SzGBnmESJkfNVCXV0IzJh4DZbdKRLGVxIe0w=
=C1rV
-----END PGP SIGNATURE-----

--h6z4u5j6gfsdwci3--
