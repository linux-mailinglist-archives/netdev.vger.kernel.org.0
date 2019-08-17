Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86B7E910AE
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 16:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfHQOFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 10:05:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59474 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfHQOFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 10:05:05 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 5823B8044A; Sat, 17 Aug 2019 16:04:49 +0200 (CEST)
Date:   Sat, 17 Aug 2019 16:05:02 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Matthias Kaehlcke <mka@chromium.org>, jacek.anaszewski@gmail.com,
        linux-leds@vger.kernel.org, dmurphy@ti.com
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v6 4/4] net: phy: realtek: Add LED configuration support
 for RTL8211E
Message-ID: <20190817140502.GA5878@amd>
References: <20190813191147.19936-1-mka@chromium.org>
 <20190813191147.19936-5-mka@chromium.org>
 <20190816201342.GB1646@bug>
 <20190816212728.GW250418@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <20190816212728.GW250418@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2019-08-16 14:27:28, Matthias Kaehlcke wrote:
> On Fri, Aug 16, 2019 at 10:13:42PM +0200, Pavel Machek wrote:
> > On Tue 2019-08-13 12:11:47, Matthias Kaehlcke wrote:
> > > Add a .config_led hook which is called by the PHY core when
> > > configuration data for a PHY LED is available. Each LED can be
> > > configured to be solid 'off, solid 'on' for certain (or all)
> > > link speeds or to blink on RX/TX activity.
> > >=20
> > > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> >=20
> > THis really needs to go through the LED subsystem,
>=20
> Sorry, I used what get_maintainers.pl threw at me, I should have
> manually cc-ed the LED list.
>=20
> > and use the same userland interfaces as the rest of the system.
>=20
> With the PHY maintainers we discussed to define a binding that is
> compatible with that of the LED one, to have the option to integrate
> it with the LED subsystem later. The integration itself is beyond the
> scope of this patchset.

Yes, I believe the integration is neccessary. Using same binding is
neccessary for that, but not sufficient. For example, we need
compatible trigger names, too.

So... I'd really like to see proper integration is possible before we
merge this.

Best regards,

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1YCY4ACgkQMOfwapXb+vLWawCfRWR0PDijLDYNaPyitgHnT8lZ
gP0AoKg13Rvbd2LdaNcuMCeR8ISyxfLv
=ya1+
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
