Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03EED1C31E3
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 06:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgEDElQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 00:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgEDElO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 00:41:14 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C773C061A0E
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 21:41:14 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jVSug-0003Ve-H5; Mon, 04 May 2020 06:41:06 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jVSuf-0004v2-Qf; Mon, 04 May 2020 06:41:05 +0200
Date:   Mon, 4 May 2020 06:41:05 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: [PATCH net-next v4 0/2] provide support for PHY master/slave
 configuration
Message-ID: <20200504044105.rhjucllibspdsrxe@pengutronix.de>
References: <20200504043320.29041-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="al4i3sobqapo63vk"
Content-Disposition: inline
In-Reply-To: <20200504043320.29041-1-o.rempel@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:40:27 up 170 days, 19:59, 170 users,  load average: 1.13, 0.59,
 0.24
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--al4i3sobqapo63vk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

please ignore it, i send it by accident.

On Mon, May 04, 2020 at 06:33:18AM +0200, Oleksij Rempel wrote:
> changes v3:
> - rename port_mode to master_slave=20
> - move validation code to net/ethtool/linkmodes.c=20
> - add UNSUPPORTED state and avoid sending unsupported fields
> - more formatting and naming fixes
> - tja11xx: support only force mode
> - tja11xx: mark state as unsupported
>=20
> changes v3:
> - provide separate field for config and state.
> - make state rejected on set
> - add validation
>=20
> changes v2:
> - change names. Use MASTER_PREFERRED instead of MULTIPORT
> - configure master/slave only on request. Default configuration can be
>   provided by PHY or eeprom
> - status and configuration to the user space.
>=20
> Oleksij Rempel (2):
>   ethtool: provide UAPI for PHY master/slave configuration.
>   net: phy: tja11xx: add support for master-slave configuration
>=20
>  Documentation/networking/ethtool-netlink.rst | 35 ++++----
>  drivers/net/phy/nxp-tja11xx.c                | 47 +++++++++-
>  drivers/net/phy/phy.c                        |  4 +-
>  drivers/net/phy/phy_device.c                 | 95 ++++++++++++++++++++
>  include/linux/phy.h                          |  3 +
>  include/uapi/linux/ethtool.h                 | 16 +++-
>  include/uapi/linux/ethtool_netlink.h         |  2 +
>  include/uapi/linux/mii.h                     |  2 +
>  net/ethtool/linkmodes.c                      | 48 ++++++++++
>  9 files changed, 233 insertions(+), 19 deletions(-)
>=20
> --=20
> 2.26.2
>=20
>=20

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--al4i3sobqapo63vk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl6vnN0ACgkQ4omh9DUa
UbMisw//S+5fk4z2WYhenaLbiVvUUQXXS1a7PjerkTG6xeqYZdeSi1bz2m+JLlqS
Yl5tI6lJmrWtS3qcZF35BkTVsnXTdss/+kQZxax39DJdKygCynfQtCzcWGyTZGFD
p2q/ckLpFrGDrv2xw4JcP/8qFi+ur/X5/+6RPlQA8Ee0lFIomKRfBsazNpehXHgd
kIKl7aZQPuiGK4Ne87RTAygJcXn/zuVWQmv0TW+nc/heQgXAqX9zRFAf5nej2b0F
XiQT/RcznTJAfQHms8iDsjRH8w7AP7xXlkERcwAcFaMqOSxuiJOIUmyDrZ1LfSgr
z4vdBosjMpFYMbCpmEuqkJfkTqvcax1Cm4yxjW0eo63rCKihjb9SXPdAUTvwG4RZ
CfCD7B89/mmx4GzQ6TQhQDH+aqWviGFeJsGFNuN2dBt2I028bIT/4jhMjSVrS8Ny
SS+CSfg1lVZ3ChfW+3fekBn5CavJ65jQsCiKqNQj08Wm+tgVazORV2NNMg3jb689
p6UM203Mj5O1wtZIp3951P2W9HwSLBCqlEDkiB47M8izEPz+28N71N9r/1tMgQ9Y
Hw7yAwQJ0/InT8VtnaN6mlcgUyjS8Xtch+SkiIHvtf2U1eKgWcnDch/gtybfkPCy
RwetP/nzIeZ6kVdKDxYOqHBaT9+ByryfdOKIW5dVQmR4nBTFEt0=
=ikpK
-----END PGP SIGNATURE-----

--al4i3sobqapo63vk--
