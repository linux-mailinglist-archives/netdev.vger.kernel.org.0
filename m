Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C65D4206B8
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 09:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhJDHkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 03:40:33 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:36646 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbhJDHkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 03:40:31 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0E62A1C0B76; Mon,  4 Oct 2021 09:38:42 +0200 (CEST)
Date:   Mon, 4 Oct 2021 09:38:41 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: are device names part of sysfs ABI? (was Re: devicename part of
 LEDs under ethernet MAC / PHY)
Message-ID: <20211004073841.GA20163@amd>
References: <20211001133057.5287f150@thinkpad>
 <YVb/HSLqcOM6drr1@lunn.ch>
 <20211001144053.3952474a@thinkpad>
 <20211003225338.76092ec3@thinkpad>
 <YVqhMeuDI0IZL/zY@kroah.com>
 <20211004090438.588a8a89@thinkpad>
 <YVqo64vS4ox9P9hk@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <YVqo64vS4ox9P9hk@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > Are device names (as returned by dev_name() function) also part of
> > > > sysfs ABI? Should these names be stable across reboots / kernel
> > > > upgrades? =20
> > >=20
> > > Stable in what exact way?
> >=20
> > Example:
> > - Board has an ethernet PHYs that is described in DT, and therefore
> >   has stable sysfs path (derived from DT path), something like
> >     /sys/devices/.../mdio_bus/f1072004.mdio-mii/f1072004.mdio-mii:01
>=20
> None of the numbers there are "stable", right?

At least f1072004 part is stable (and probably whole path). DT has
advantages here, and we should provide stable paths when we can.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmFar4AACgkQMOfwapXb+vK1sgCgtfhhY9twaL0KgQm9FOL3VLwb
xdQAoI9WQF6v3AbSYLUg1EZELXzIEFLV
=UMpO
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
