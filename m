Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0AD43FB4C
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 13:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbhJ2LVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 07:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbhJ2LVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 07:21:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74401C061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 04:18:34 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mgPu3-0003KQ-7n; Fri, 29 Oct 2021 13:18:31 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-e533-710f-3fbf-10c2.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:e533:710f:3fbf:10c2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 12EDE6A093C;
        Fri, 29 Oct 2021 11:18:29 +0000 (UTC)
Date:   Fri, 29 Oct 2021 13:18:29 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, Lukas Magel <lukas.magel@escrypt.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] can: etas_es58x: es58x_init_netdev: populate
 net_device::dev_port
Message-ID: <20211029111829.crrwdjizlflzzhq2@pengutronix.de>
References: <20211026180553.1953189-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uy25gtrfe76thjxs"
Content-Disposition: inline
In-Reply-To: <20211026180553.1953189-1-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uy25gtrfe76thjxs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.10.2021 03:05:53, Vincent Mailhol wrote:
> The field dev_port of struct net_device indicates the port number of a
> network device [1]. This patch populates this field.
>=20
> This field can be helpful to distinguish between the two network
> interfaces of a dual channel device (i.e. ES581.4 or ES582.1). Indeed,
> at the moment, all the network interfaces of a same device share the
> same static udev attributes c.f. output of:
>=20
> | udevadm info --attribute-walk /sys/class/net/canX
>=20
> The dev_port attribute can then be used to write some udev rules to,
> for example, assign a permanent name to each network interface based
> on the serial/dev_port pair (which is convenient when you have a test
> bench with several CAN devices connected simultaneously and wish to
> keep consistent interface names upon reboot).
>=20
> [1] https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-class-net
>=20
> Suggested-by: Lukas Magel <lukas.magel@escrypt.com>
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Applied to linux-can-next/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--uy25gtrfe76thjxs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmF72IIACgkQqclaivrt
76n3lwgAr84LUlouhT0DZCuwsQHZBXAVmr3wUfbQ6Uk4RKffeVuoIhKUpbeNIDPc
CWYJZP9nAcKLgHaLABPyEnP9urU2kytPXw4b/Z7yuKTSaJmfcM3Jedl3aQXdqiTT
LoyD5V/BO76NvTWicez6hbPzIgQbcuQW4VnMWM+sE9I5W43M0al+UC9eSj44xhyQ
Oy20F0y478r+xp8JtsYNNQXZ2WLqnOJN4MaC0j217WAQ6JX5GQ7GHaIiUEiFPHng
gP4unE2lyBwC/TGtkHzxVZ7bMPqCJ+Hcsuapwrll/KmImN2vRQDQJ8aGHo7lA/ua
yn5EmHQpE6xoHuZPGHoNBVmBfRedAw==
=y899
-----END PGP SIGNATURE-----

--uy25gtrfe76thjxs--
