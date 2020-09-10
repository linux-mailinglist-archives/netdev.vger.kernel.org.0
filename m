Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E71264CCE
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 20:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgIJSYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:24:52 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:51162 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgIJSYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 14:24:38 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 923211C0B81; Thu, 10 Sep 2020 20:24:34 +0200 (CEST)
Date:   Thu, 10 Sep 2020 20:24:34 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 6/7] net: phy: marvell: add support
 for LEDs controlled by Marvell PHYs
Message-ID: <20200910182434.GA22845@duo.ucw.cz>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909162552.11032-7-marek.behun@nic.cz>
 <20200910122341.GC7907@duo.ucw.cz>
 <20200910131541.GD3316362@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <20200910131541.GD3316362@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2020-09-10 15:15:41, Andrew Lunn wrote:
> On Thu, Sep 10, 2020 at 02:23:41PM +0200, Pavel Machek wrote:
> > On Wed 2020-09-09 18:25:51, Marek Beh=FAn wrote:
> > > This patch adds support for controlling the LEDs connected to several
> > > families of Marvell PHYs via the PHY HW LED trigger API. These famili=
es
> > > are: 88E1112, 88E1121R, 88E1240, 88E1340S, 88E1510 and 88E1545. More =
can
> > > be added.
> > >=20
> > > This patch does not yet add support for compound LED modes. This could
> > > be achieved via the LED multicolor framework.
> > >=20
> > > Settings such as HW blink rate or pulse stretch duration are not yet
> > > supported.
> > >=20
> > > Signed-off-by: Marek Beh=FAn <marek.behun@nic.cz>
> >=20
> > I suggest limiting to "useful" hardware modes, and documenting what
> > those modes do somewhere.
>=20
> I think to keep the YAML DT verification happy, they will need to be
> listed in the marvell PHY binding documentation.

Well, this should really go to the sysfs documenation. Not sure what
to do with DT.

But perhaps driver can set reasonable defaults without DT input?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX1pvYgAKCRAw5/Bqldv6
8uyxAJ9VPfg8UCb8WW4rjkLFIjOYnJkPxQCfcni8b0CidtFJLAhvX8X3Eiwz3Xo=
=6n+e
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
