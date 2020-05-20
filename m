Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6E11DA986
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 06:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgETEzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 00:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbgETEzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 00:55:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086A8C061A0E
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 21:55:52 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jbGla-0006rY-Ag; Wed, 20 May 2020 06:55:42 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jbGlU-0003Zn-CO; Wed, 20 May 2020 06:55:36 +0200
Date:   Wed, 20 May 2020 06:55:36 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: [PATCH net-next v1 1/2] ethtool: provide UAPI for PHY Signal
 Quality Index (SQI)
Message-ID: <20200520045536.vgeg2p5qt6goqek6@pengutronix.de>
References: <20200519075200.24631-1-o.rempel@pengutronix.de>
 <20200519132630.GH610998@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ihqbxrolus2mvt2s"
Content-Disposition: inline
In-Reply-To: <20200519132630.GH610998@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:53:24 up 186 days, 20:11, 181 users,  load average: 0.00, 0.02,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ihqbxrolus2mvt2s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2020 at 03:26:30PM +0200, Andrew Lunn wrote:
> On Tue, May 19, 2020 at 09:51:59AM +0200, Oleksij Rempel wrote:
> > Signal Quality Index is a mandatory value required by "OPEN Alliance
> > SIG" for the 100Base-T1 PHYs [1]. This indicator can be used for cable
> > integrity diagnostic and investigating other noise sources and
> > implement by at least two vendors: NXP[2] and TI[3].
>=20
> Hi Oleksij
>=20
> With a multi part patch set, please always include a cover note,
> describing what the patchset as a whole does.

ok

> > +int __ethtool_get_sqi(struct net_device *dev)
> > +{
> > +	struct phy_device *phydev =3D dev->phydev;
> > +
> > +	if (!phydev->drv->get_sqi)
> > +		return -EOPNOTSUPP;
> > +
> > +	return phydev->drv->get_sqi(phydev);
> > +}
>=20
> You are not doing any locking here, which you should. Due to modules
> vs built in, it can be a bit tricky getting this right. Take a look at
> how ethtool ioctl.c uses phy_ethtool_get_stats() and that inline
> function itself.

ok.

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--ihqbxrolus2mvt2s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl7EuEcACgkQ4omh9DUa
UbNl2RAAi326N4L7jknXot/p/PdgUw1QAQENV2sQN9OMIn0dU0dK4D8NqJ00AQvo
ynonKKvhHBdJFIoTUqFgrEgewL2zKj9eTnc3yKN/+qXD+TqTWWBRXXAoHuYpJk/a
lPhC76X6euQmpH6NTm5D2iKx7OwQWkQ5tjmTRl3ciUguentjw5sNcbLNcrxq2/GB
tY2HCX0ib2om6Js8udSVWAKLxrmNIPvr5ttr0RbaMOzRDoBQ4knREPLZg59609K3
/BgsnnTBHS4HZi4QvAc2gYSoS/R7IHXE/XXi176tDHLHn6jsi01rfuP9eiEOfG9V
Gg1Tuy2shZDaIfUTuuMnLLX7UMUHFyM09qlEgYKMFPRWAUkbewByPH0rMuAcjWdE
kl7Mvyk4n3NzIss8M2HiYmSz8tACqP0TOP8uT45tcGNgQH9YeSwM6U70+y6LAB3E
TRJOiiNZz30PZ+qfq4rIMMhbS0C45xFwszb18iJSD9pCqBptQ+Xae0YEnWmK5LcF
64E+zAPkXuKRH0ZJlwwSdbSaqoyuXz9QPrkE8rOxchLEOplZlBT9CwFPIa29LjNa
nf/61/rpZNWUNJ0eRxuvky1RhsM+TmruwJrF4hJiz1lYQbgcLpF+coimE4Ynq3Po
4GK8zf/h6OIpkoMOfc6mE3M78jPh1CuQzHbw3FhTw1JwzOwGKK4=
=NNH9
-----END PGP SIGNATURE-----

--ihqbxrolus2mvt2s--
