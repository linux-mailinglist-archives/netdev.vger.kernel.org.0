Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C93DF14D2B6
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 22:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgA2VsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 16:48:10 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:53395 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgA2VsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 16:48:09 -0500
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1iwvBv-0002C0-L5; Wed, 29 Jan 2020 22:48:07 +0100
Received: from mgr by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mgr@pengutronix.de>)
        id 1iwvBt-0006r3-3p; Wed, 29 Jan 2020 22:48:05 +0100
Date:   Wed, 29 Jan 2020 22:48:05 +0100
From:   Michael Grzeschik <mgr@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kernel@pengutronix.de
Subject: Re: [PATCH] mdio-bitbang: add support for lowlevel mdio read/write
Message-ID: <20200129214805.l4djnzrzpk7inkvk@pengutronix.de>
References: <20191107154201.GF7344@lunn.ch>
 <20191218162919.5293-1-m.grzeschik@pengutronix.de>
 <20191221164110.GL30801@lunn.ch>
 <20200129154201.oaxjbqkkyifvf5gg@pengutronix.de>
 <20200129155346.GG12180@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lj3mvo2wyac5j44g"
Content-Disposition: inline
In-Reply-To: <20200129155346.GG12180@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:42:48 up 206 days,  3:52, 89 users,  load average: 0.35, 0.25,
 0.20
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lj3mvo2wyac5j44g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 29, 2020 at 04:53:46PM +0100, Andrew Lunn wrote:
> On Wed, Jan 29, 2020 at 04:42:01PM +0100, Michael Grzeschik wrote:
> > Hi Andrew!
> >=20
> > I tested your patch. But it works only partially. For the case that
> > the upper driver is directly communicating in SMI mode with the phy,
> > this works fine. But the regular MDIO connection does not work anymore
> > afterwards.
> >=20
> > The normals MDIO communication still needs to work, as mdio-gpio is
> > calling of_mdiobus_register that on the other end calls get_phy_device
> > and tries to communicate via regular MDIO to the device.
>=20
> Do you mean you have a mix of devices on the bus, some standards
> comformant, and others using this hacked up SMI0 mode?

Actually it is the same device used in both modes. The SMI0
mode is used by the switch driver to address the extended switch
functions. But on the same bus we have the fec connected to
the cpu bound fixed-phy (microchip,ks8863) via MDIO.

> You need to specify per device if SMI0 should be used?

Yes, we have to use the same bus fot both modes SMI0 and MDIO.

 Michael

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--lj3mvo2wyac5j44g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEElXvEUs6VPX6mDPT8C+njFXoeLGQFAl4x/ZEACgkQC+njFXoe
LGTaJg//SPMBAgzFT76dvhEaaSs+KKmIzRgOVoBkYwE1ohnemSB3nuRyOn1xT8YB
/Mtc60Do0s3JZE8/Yg9Ba0dgC+OXodmOE2kmTBbJ0X/3lZWDaxA+6SE503PjpDIp
p6O2RM8WhOEjYvWeadyw3MDSTZRzJHVo6b5ocO7aEtrrzDIsSZA48qy6VX4Pjtgy
hbfXJHMK1+5rTPkpuL6K1N/pWeBxXd2iqzKI+LXFeFegTHzl2nyhRfUkQ98tXOrb
tqzqQ7OHB7NAFA54WD5J9TorY3GbBUP0OcolGO5RteFK8Z4Y7LrTW/ko6w9YGyeY
JfPbDDmjZcD1D1dztXSo97+d/U4JuOgha/bAIztN2m55SZM7vGZeHrCfPoDNX8kw
hdMS9NVv2sdEAI1G7Gdkrwh/H+Rx+ffbwYGqH/b7YqOfckBigU8rIn/5LcsZwC5T
WFw+pooA2UiuXE1m3q1/CbSJ7d4IjFRah2e/bQMj3ZVtQLLn2qrZMK5xvgi1TYDj
hO2le2UvhYruV2ztqpJ7yhKT7+q2NmkV2uZ62tQHBd6zBsT52InHteBnzDdTFQVs
28NnZImBfioTABF0S/EZg9Gd6zFvrBWYMg4rfX4X5jyqwxavUkp1GXQb7/EUroNd
e0bxgZV5cGLoyGhQ8Mo0LPoDvkJjIBur8sEyI8b9wiDh7kO3xmM=
=nwnv
-----END PGP SIGNATURE-----

--lj3mvo2wyac5j44g--
