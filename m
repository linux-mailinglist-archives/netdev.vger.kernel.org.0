Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD852C3EA0
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 12:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbgKYK7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 05:59:47 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:37228 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgKYK7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 05:59:47 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 62AC41C0B7D; Wed, 25 Nov 2020 11:59:44 +0100 (CET)
Date:   Wed, 25 Nov 2020 11:59:43 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Alexander Dahl <ada@thorsis.com>
Cc:     linux-leds@vger.kernel.org, Marek Behun <marek.behun@nic.cz>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Alexander Dahl <post@lespocky.de>
Subject: Re: Request for Comment: LED device naming for netdev LEDs
Message-ID: <20201125105943.GG25562@amd>
References: <20200927004025.33c6cfce@nic.cz>
 <20200927025258.38585d5e@nic.cz>
 <2817077.TXCUc2rGbz@ada>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="m972NQjnE83KvVa/"
Content-Disposition: inline
In-Reply-To: <2817077.TXCUc2rGbz@ada>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--m972NQjnE83KvVa/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > What are your ideas about this problem?
> > >=20
> > > Marek
> >=20
> > BTW option b) and c) can be usable if we create a new utility, ledtool,
> > to report infromation about LEDs and configure LEDs.
> >=20
> > In that case it does not matter if the LED is named
> >   ethernet-adapter0:red:activity
> > or
> >   ethernet-phy0:red:activity
> > because this new ledtool utility could just look deeper into sysfs to
> > find out that the LED corresponds to eth0, whatever it name is.
>=20
> I like the idea to have such a tool.  What do you have in mind?  Sounds f=
or me=20
> like it would be somehow similar to libgpiod with gpio* for GPIO devices =
or=20
> like libevdev for input devices or like mtd-utils =E2=80=A6
>=20
> Especially a userspace library could be helpful to avoid reinventing the =
wheel=20
> on userspace developer side?
>=20
> Does anyone else know prior work for linux leds sysfs interface from=20
> userspace?

I have code in tui project which accesses the LEDs from python... and
I started writing ledtool in rust.

Anyway, I agree we should provide shared library, too. Going through
the fork/exec is just too ugly.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--m972NQjnE83KvVa/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEUEARECAAYFAl++OR8ACgkQMOfwapXb+vL3VgCgpDHzgOHE4cBhWLEsK2ZksRf8
z0cAl1h1EDhAo803N1rdJhjKFQZ75Ho=
=aOlu
-----END PGP SIGNATURE-----

--m972NQjnE83KvVa/--
