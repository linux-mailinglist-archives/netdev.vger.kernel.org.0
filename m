Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52C71C671D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 06:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgEFEvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 00:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgEFEvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 00:51:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D82C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 21:51:35 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jWC1j-0000J1-MN; Wed, 06 May 2020 06:51:23 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jWC1e-0006qW-QW; Wed, 06 May 2020 06:51:18 +0200
Date:   Wed, 6 May 2020 06:51:18 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
Message-ID: <20200506045118.hl3sfmww2ncfh5ze@pengutronix.de>
References: <20200422072137.8517-1-o.rempel@pengutronix.de>
 <71dea993-b420-e994-ffa8-87350e157cda@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="l5xaumdvxm7xwgpw"
Content-Disposition: inline
In-Reply-To: <71dea993-b420-e994-ffa8-87350e157cda@ti.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:46:43 up 172 days, 20:05, 176 users,  load average: 0.04, 0.07,
 0.07
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--l5xaumdvxm7xwgpw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grygorii,

On Tue, May 05, 2020 at 09:26:46PM +0300, Grygorii Strashko wrote:
>=20
>=20
> On 22/04/2020 10:21, Oleksij Rempel wrote:
> > Add support for following phy-modes: rgmii, rgmii-id, rgmii-txid, rgmii=
-rxid.
> >=20
> > This PHY has an internal RX delay of 1.2ns and no delay for TX.
> >=20
> > The pad skew registers allow to set the total TX delay to max 1.38ns and
> > the total RX delay to max of 2.58ns (configurable 1.38ns + build in
> > 1.2ns) and a minimal delay of 0ns.
> >=20
> > According to the RGMII v1.3 specification the delay provided by PCB tra=
ces
> > should be between 1.5ns and 2.0ns. The RGMII v2.0 allows to provide this
> > delay by MAC or PHY. So, we configure this PHY to the best values we can
> > get by this HW: TX delay to 1.38ns (max supported value) and RX delay to
> > 1.80ns (best calculated delay)
> >=20
> > The phy-modes can still be fine tuned/overwritten by *-skew-ps
> > device tree properties described in:
> > Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
> >=20
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> > changes v3:
> > - change delay on RX line to 1.80ns
> > - add warning if *-skew-ps properties are used together with not rgmii
> >    mode.
> >=20
> > changes v2:
> > - change RX_ID value from 0x1a to 0xa. The overflow bit was detected by
> >    FIELD_PREP() build check.
> >    Reported-by: kbuild test robot <lkp@intel.com>
> >=20
> >   drivers/net/phy/micrel.c | 128 +++++++++++++++++++++++++++++++++++++--
> >   1 file changed, 123 insertions(+), 5 deletions(-)
> >=20
>=20
> This patch broke networking on at least 5 TI boards:
> am572x-idk
> am571x-idk
> am43xx-hsevm
> am43xx-gpevm
> am437x-idk
>=20
> am57xx I can fix.
>=20
> am437x need to investigate.

Please try:
	phy-mode =3D "rgmii-txid"

I assume your boards are using "rgmii" which should be used only if you
boards have extra long clk traces.

Regards,
Oleksij
--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--l5xaumdvxm7xwgpw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl6yQkIACgkQ4omh9DUa
UbMp2A/+J8sk5MKQrPLpxu0jbGmvE3SO4JOpyFLJVxg83qR0ndhzuRXM2o0AKz7a
v5BmOL+e926ev0iisyOdzsNSdWh5xlV3FiIT1sUOSyfigVsgKUVe5Jb7n8q+QiKi
5NEyB6LckWrWnfkEp5OFyAh0wY3+GX/RUQEeQQ4sLBUNyyhHCSKR5WAxLkZ24M8P
K+b/g/DbRJGWCiasnFnOJZTdHjW7MWtxBUBoxEYPt9LtyGWJ5E8S8R93jmztaLJr
wFSrX0Wi0UrAYX+OCLGerw6N2biFrU7jQeXs5Gup+fwq9+MfAm7s2R16ecqNVzdy
r1N6exEX+POV0BAgovn8sG8pUSij36d41Iiuqt85o9ZXXEnNB5l2XCPlhbKIltT/
dJQR9F5TwhIM6zc6jnU0DvAtdl3WvkvU0gZab2hmC00Wigpsdw6sNmsUyfEOVC2R
207W76WNCEJnQJw81z8QJiQcvgFhr/HaSdvLvzAmXbOj23PxV+wgp8vVawmgGcLR
kIsJDwu4TBUS3SZfoKXcYberpHvaSZaikijpJxCJs2NMND/3Cgn/WzNCkBrbaFQL
znUhKYUoPX6isaX+e4i4DxEe+35tTggQhQZ+E0Pk+lppkDIecyHrGOCM3NTUBDA3
NM3UoHo/K1XyIpTbPWuQp6o1U5KMQPA4SQbdOSdkw7S+0++zglY=
=tVb8
-----END PGP SIGNATURE-----

--l5xaumdvxm7xwgpw--
