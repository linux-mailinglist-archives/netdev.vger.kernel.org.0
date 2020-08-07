Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB7723E9D5
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 11:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgHGJLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 05:11:23 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:35850 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgHGJLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 05:11:22 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id F0F901C0BD9; Fri,  7 Aug 2020 11:11:19 +0200 (CEST)
Date:   Fri, 7 Aug 2020 11:11:19 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek Behun <marek.behun@nic.cz>, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, jacek.anaszewski@gmail.com,
        Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v3 2/2] net: phy: marvell: add
 support for PHY LEDs via LED class
Message-ID: <20200807091119.b7vcdk4fxz7le3zp@duo.ucw.cz>
References: <20200724164603.29148-1-marek.behun@nic.cz>
 <20200724164603.29148-3-marek.behun@nic.cz>
 <20200725172318.GK1472201@lunn.ch>
 <20200725200224.3f03c041@nic.cz>
 <20200725184846.GO1472201@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="deiezzmxyvff7ovy"
Content-Disposition: inline
In-Reply-To: <20200725184846.GO1472201@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--deiezzmxyvff7ovy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2020-07-25 20:48:46, Andrew Lunn wrote:
> > > > +#if 0
> > > > +	/* LED_COLOR_ID_MULTI is not yet merged in Linus' tree */
> > > > +	/* TODO: Support DUAL MODE */
> > > > +	if (color =3D=3D LED_COLOR_ID_MULTI) {
> > > > +		phydev_warn(phydev, "node %pOF: This driver does not yet support=
 multicolor LEDs\n",
> > > > +			    np);
> > > > +		return -ENOTSUPP;
> > > > +	}
> > > > +#endif =20
> > >=20
> > > Code getting committed should not be using #if 0. Is the needed code
> > > in the LED tree? Do we want to consider a stable branch of the LED
> > > tree which DaveM can pull into net-next? Or do you want to wait until
> > > the next merge cycle?
> >=20
> > That's why this is RFC. But yes, I would like to have this merged for
> > 5.9, so maybe we should ask Dave. Is this common? Do we also need to
> > tell Pavel or how does this work?
>=20
> The Pavel needs to create a stable branch. DaveM then merges that
> branch into net-next. Your patches can then be merged. When Linus
> pulls the two branches, led and net-next, git sees the exact same
> patches twice, and simply drops them from the second pull request.
>=20
> So you need to ask Pavel and DaveM if they are willing to do this.

Multicolor should be upstream now, so I believe this is no longer
required?

> > I also want this code to be generalized somehow so that it can be
> > reused. The problem is that I want to have support for DUAL mode, which
> > is Marvell specific, and a DUAL LED needs to be defined in device tree.
>=20
> It sounds like you first need to teach the LED core about dual LEDs
> and triggers which affect two LEDs..

Umm. Yes, triggers for controlling both intensity and hue will be
interesting. Suggestions welcome.

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--deiezzmxyvff7ovy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXy0atwAKCRAw5/Bqldv6
8hAmAKCvo/m/bATu/BHcZE9ByZbwMU7WUQCfecdgdfdiv5MBWfUc08dUT8HNswk=
=5G/j
-----END PGP SIGNATURE-----

--deiezzmxyvff7ovy--
