Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00FDE3E7E36
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 19:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbhHJR3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 13:29:52 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:54662 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhHJR3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 13:29:51 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3FB451C0B76; Tue, 10 Aug 2021 19:29:28 +0200 (CEST)
Date:   Tue, 10 Aug 2021 19:29:27 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Michael Walle <michael@walle.cc>, andrew@lunn.ch,
        anthony.l.nguyen@intel.com, bigeasy@linutronix.de,
        davem@davemloft.net, dvorax.fuxbrumer@linux.intel.com,
        f.fainelli@gmail.com, jacek.anaszewski@gmail.com, kuba@kernel.org,
        kurt@linutronix.de, linux-leds@vger.kernel.org,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vinicius.gomes@intel.com, vitaly.lifshits@intel.com
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <20210810172927.GB3302@amd>
References: <YP9n+VKcRDIvypes@lunn.ch>
 <20210727081528.9816-1-michael@walle.cc>
 <20210727165605.5c8ddb68@thinkpad>
 <c56fd3dbe1037a5c2697b311f256b3d8@walle.cc>
 <20210727172828.1529c764@thinkpad>
 <8edcc387025a6212d58fe01865725734@walle.cc>
 <20210727183213.73f34141@thinkpad>
 <25d3e798-09f5-56b5-5764-c60435109dd2@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="eAbsdosE1cNLO4uF"
Content-Disposition: inline
In-Reply-To: <25d3e798-09f5-56b5-5764-c60435109dd2@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--eAbsdosE1cNLO4uF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Yes, this still persists. But we really do not want to start
> > introducing namespaces to the LED subsystem.
>=20
> Did we come to any conclusion?
>=20
> My preliminary r8169 implementation now creates the following LED names:
>=20
> lrwxrwxrwx 1 root root 0 Jul 26 22:50 r8169-led0-0300 ->
> > ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/r8169-led=
0-0300

So "r8159-0300:green:activity" would be closer to the naming we want,
but lets not do that, we really want this to be similar to what others
are doing, and that probably means "ethphy3:green:activity" AFAICT.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--eAbsdosE1cNLO4uF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmESt3cACgkQMOfwapXb+vKYpwCgpEoYBuVyi5Ip8gI6t6ZnVsq9
onoAn0ZyFRyXBRj63c0SZWqdfuKzXrWM
=fwhc
-----END PGP SIGNATURE-----

--eAbsdosE1cNLO4uF--
