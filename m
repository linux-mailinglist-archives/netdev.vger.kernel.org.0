Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1D922D67E
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 11:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgGYJlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 05:41:44 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:40924 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbgGYJln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 05:41:43 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E77261C0BD2; Sat, 25 Jul 2020 11:41:39 +0200 (CEST)
Date:   Sat, 25 Jul 2020 11:41:39 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek Behun <marek.behun@nic.cz>, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v2 1/1] net: phy: marvell: add
 support for PHY LEDs via LED class
Message-ID: <20200725094139.GA29992@amd>
References: <20200723181319.15988-1-marek.behun@nic.cz>
 <20200723181319.15988-2-marek.behun@nic.cz>
 <20200723213531.GK1553578@lunn.ch>
 <20200724005349.2e90a247@nic.cz>
 <20200724102403.wyuteeql3jn5xouw@duo.ucw.cz>
 <20200724131102.GD1472201@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <20200724131102.GD1472201@lunn.ch>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > My main issue though is whether one "hw-control" trigger should be
> > > registered via LED API and the specific mode should be chosen via
> > > another sysfs file as in this RFC, or whether each HW control mode
> > > should have its own trigger. The second solution would either result =
in
> > > a lot of registered triggers or complicate LED API, though...
> >=20
> > If you register say 5 triggers.... that's okay. If you do like 1024
> > additional triggers (it happened before!)... well please don't.
>=20
> Hi Pavel
>=20
> There tends to be around 15 different blink patterns per LED. And
> there can be 2 to 3 LEDs per PHY. The blink patterns can be different
> per PHY, or they can be the same. For the Marvell PHY we are looking
> at around 45. Most of the others PHYs tend to have the same patterns
> for all LEDs, so 15 triggers could be shared.
>=20
> But if you then think of a 10 port Ethernet switch, there could be 450
> triggers, if the triggers are not shared at all.
>=20
> So to some extent, it is a question of how much effort should be put
> in to sharing triggers.

It sounds to me ... lot of effort should be put to sharing triggers
there :-).

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8b/lMACgkQMOfwapXb+vKimwCfRGK+53fLznJ19wiqfJngn0BJ
16sAoIn1IOwQhTF57yjnfe5HHzqtQeVC
=93uu
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
