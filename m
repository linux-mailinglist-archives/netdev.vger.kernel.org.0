Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E003F1D19C0
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 17:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732015AbgEMPpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 11:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728490AbgEMPpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 11:45:53 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9CCC061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 08:45:53 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jYtZs-0004Pr-MC; Wed, 13 May 2020 17:45:48 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jYtZo-0002Hv-5S; Wed, 13 May 2020 17:45:44 +0200
Date:   Wed, 13 May 2020 17:45:44 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] net: phy: at803x: add cable test support
Message-ID: <20200513154544.gwcccvbicpvrj6vm@pengutronix.de>
References: <20200513120648.14415-1-o.rempel@pengutronix.de>
 <0c80397b-58b8-0807-0b98-695db8068e25@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="l4mc43ul3f7nhocp"
Content-Disposition: inline
In-Reply-To: <0c80397b-58b8-0807-0b98-695db8068e25@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:35:33 up 180 days,  6:54, 192 users,  load average: 0.06, 0.06,
 0.02
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--l4mc43ul3f7nhocp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 13, 2020 at 08:23:42AM -0700, Florian Fainelli wrote:
>=20
>=20
> On 5/13/2020 5:06 AM, Oleksij Rempel wrote:
> > The cable test seems to be support by all of currently support Atherso
> > PHYs, so add support for all of them. This patch was tested only on
> > AR9331 PHY with following results:
> > - No cable is detected as short
> > - A 15m long cable connected only on one side is detected as 9m open.
> > - A cable test with active link partner will provide no usable results.
>=20
> How does this relate to Michael's recent work here:
>=20
> https://www.spinics.net/lists/kernel/msg3509304.html

Uff.. i missed this. Then I'll need only to add some changes on top of
his patch.

Regards,
Oleksij
--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--l4mc43ul3f7nhocp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl68FiQACgkQ4omh9DUa
UbMiXxAAiOrCPbzXrEYAuGypWvsoxkF++QGU8vdMlA8GnrJqzvwiDc/IG4KoyILF
Yu40ODr7ySGS3m1BLfg+xwz/SZiZCS9j13s1e/pmGKeMVEBanVZ9V3KVRdZnCv86
+PYenNjsIIY4TojKGpdTqXVpYnLypWVyFQeJVraf7TEYpN/7iFXW8cAnqla0z3xO
D+OjhxiyEG0ULZU4BhxQi/vYvyZuXqp7io9U6IxPNV7KayW8f56TAvq1Ev0RSClT
ctknHooaYvvqQpMYR+5RGfICd1GNIxLxCzJzr6EdxJBndOYil7kokkuZxMoOzAOq
N15sY8D2AAXGEjiKABXw43cU2bQUGUfqbKSFteIbgxO3hFebSq9kqGGdguIgNuZS
0YLh6T4W3xpUgSPTM+emGHNoEDweIH5nUvEGlE4EjTmNBo87wNzT9ZI7kfkrL13X
DTDcU4ebPhh7JA/7WcdgX7hriUwxKOdt+4vb+nwu8ir7v6U77DJDNeheh8HfOHzh
OHkR2fKKt6lUr69eaI6Ki0Jk5CsSbxuh8wu8gDmiBMeV+X0JPr9k1WbEjHgm5Zmw
ul0SRCa5yE5DudHFGniT7Fv2AKr/eqVuGabuZNXFr2FVcz3Usl8uT3rDCtgJLJff
YX6rqvDW2kVcZ+hWKk5QSovbLV0jh1RHwBOgDnkus5gMITcKfMc=
=dJ9z
-----END PGP SIGNATURE-----

--l4mc43ul3f7nhocp--
