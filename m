Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5348B1BEF58
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 06:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgD3EiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 00:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726430AbgD3EiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 00:38:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08280C035494
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 21:38:06 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jU0xS-0001ne-Lx; Thu, 30 Apr 2020 06:37:58 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jU0xL-0004yF-Jz; Thu, 30 Apr 2020 06:37:51 +0200
Date:   Thu, 30 Apr 2020 06:37:51 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michal Kubecek <mkubecek@suse.cz>, Marek Vasut <marex@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        mkl@pengutronix.de, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Herber <christian.herber@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v3 1/2] ethtool: provide UAPI for PHY
 master/slave configuration.
Message-ID: <20200430043751.ojvcgtubkbfunolb@pengutronix.de>
References: <20200428075308.2938-1-o.rempel@pengutronix.de>
 <20200428075308.2938-2-o.rempel@pengutronix.de>
 <20200429181614.GL30459@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fwcyervo5zssj2lh"
Content-Disposition: inline
In-Reply-To: <20200429181614.GL30459@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:28:59 up 166 days, 19:47, 163 users,  load average: 0.03, 0.04,
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


--fwcyervo5zssj2lh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, Apr 29, 2020 at 08:16:14PM +0200, Andrew Lunn wrote:
> On Tue, Apr 28, 2020 at 09:53:07AM +0200, Oleksij Rempel wrote:
>=20
> Hi Oleksij
>=20
> Sorry for taking a while to review this. I was busy fixing the FEC
> driver which i broke :-(

Not problem.
Interesting, what is wrong with FEC? We use it a lot.

> > --- a/Documentation/networking/ethtool-netlink.rst
> > +++ b/Documentation/networking/ethtool-netlink.rst
> > @@ -399,6 +399,8 @@ Kernel response contents:
> >    ``ETHTOOL_A_LINKMODES_PEER``          bitset  partner link modes
> >    ``ETHTOOL_A_LINKMODES_SPEED``         u32     link speed (Mb/s)
> >    ``ETHTOOL_A_LINKMODES_DUPLEX``        u8      duplex mode
> > +  ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG``  u8      Master/slave port =
mode
> > +  ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE``  u8      Master/slave por=
t mode
> >    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> I've not used Sphinx for a while. But it used to be, tables had to be
> correctly aligned. I think you need to pad the other rows with spaces.
>
> Also, the comments should differ. The first is how we want it
> configured, the second is the current state.

ok

> > =20
> >  For ``ETHTOOL_A_LINKMODES_OURS``, value represents advertised modes an=
d mask
> > @@ -421,6 +423,7 @@ Request contents:
> >    ``ETHTOOL_A_LINKMODES_PEER``          bitset  partner link modes
> >    ``ETHTOOL_A_LINKMODES_SPEED``         u32     link speed (Mb/s)
> >    ``ETHTOOL_A_LINKMODES_DUPLEX``        u8      duplex mode
> > +  ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG``  u8      Master/slave port =
mode
> >    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Same table cleanup needed here.
>=20
> > +static int genphy_read_master_slave(struct phy_device *phydev)
> > +{
> > +	int cfg, state =3D 0;
> > +	u16 val;
> > +
> > +	phydev->master_slave_get =3D 0;
> > +	phydev->master_slave_state =3D 0;
>=20
> Could you use the _UNKNOWN #defined here?

ok

> > diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> > index 92f737f101178..eb680e3d6bda5 100644
> > --- a/include/uapi/linux/ethtool.h
> > +++ b/include/uapi/linux/ethtool.h
> > @@ -1666,6 +1666,31 @@ static inline int ethtool_validate_duplex(__u8 d=
uplex)
> >  	return 0;
> >  }
> > =20
> > +static inline int ethtool_validate_master_slave_cfg(__u8 cfg)
> > +{
> > +	switch (cfg) {
> > +	case PORT_MODE_CFG_MASTER_PREFERRED:
> > +	case PORT_MODE_CFG_SLAVE_PREFERRED:
> > +	case PORT_MODE_CFG_MASTER_FORCE:
> > +	case PORT_MODE_CFG_SLAVE_FORCE:
> > +	case PORT_MODE_CFG_UNKNOWN:
> > +		return 1;
> > +	}
> > +
> > +	return 0;
> > +}
>=20
> Does this need to be an inline function?=20

Yes, otherwise we get a lot of "defined but not used " warnings.


Regards,
Oleksij
--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--fwcyervo5zssj2lh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl6qVhsACgkQ4omh9DUa
UbNsaRAAgpvXXG1Cv1zCv9M/hxQhnTtifA8Q06Xx3G19QNul0DDTqlWIWfWs3mZh
4bxq6NhdzLVlXHHvRMUVjYARsHDD19bmfpspTMMC9Z8Z6BEOLEv885XRFZa+9Goi
wBHDJvr40q0LmcftXcmnjYje2eS9shKQMiBwT4j2MEzHSKTyHD5LZmxXsjv8JoIP
tOqgq4kYb5dXm5joMo4SNQieegfadtAwAtVqYSVkoWxKi3ljVXWgdiqD2a7iW5G6
wpXuUHYDq+G+wajc4mPRMMTy9hug5eXDel5OgaSqwHUEJSZmGS4loMUjUjR148Ij
HdwjwenAHRX8hFxN16zpC+Ml5gSm8zvl9Z4Uwh70/adzs+eJrnqyT3jgl2RKL3jN
wxcQsWue9y4tbx5IIlSrVyVB4iXRUP+6wK1+njkWGajIyl7i6d7rU6PJEbx5BE3l
DttVdjKZGXfZLTheb9eV8ZUCN/FRTyv3+PtVWrjfjnZqn2go8dJypvLj84kQUV8p
Ec0kaVggHfGEuJQvMZigJaaOX0ZRt3nLMVUS/1ciRBD3ov1wJO4Q72v2+IuwlBwV
iNc2KLNURTgsADlrBDpr2xlBQvx+wVlXoxGP9Gq/f8ZnYmQCTEfzR7JHP7NJfny4
v18LUWY8yYWtRLQteSkJUhwr6mpKx0GtacSF4hettXs48nFB1W8=
=ZGcl
-----END PGP SIGNATURE-----

--fwcyervo5zssj2lh--
