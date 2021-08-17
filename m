Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBB73EF268
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 21:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbhHQTDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 15:03:17 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45988 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbhHQTDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 15:03:16 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 646AE1C0B77; Tue, 17 Aug 2021 21:02:42 +0200 (CEST)
Date:   Tue, 17 Aug 2021 21:02:42 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Michael Walle <michael@walle.cc>, andrew@lunn.ch,
        anthony.l.nguyen@intel.com, bigeasy@linutronix.de,
        davem@davemloft.net, dvorax.fuxbrumer@linux.intel.com,
        f.fainelli@gmail.com, jacek.anaszewski@gmail.com, kuba@kernel.org,
        kurt@linutronix.de, linux-leds@vger.kernel.org,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vinicius.gomes@intel.com, vitaly.lifshits@intel.com
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <20210817190241.GA15389@amd>
References: <20210727165605.5c8ddb68@thinkpad>
 <c56fd3dbe1037a5c2697b311f256b3d8@walle.cc>
 <20210727172828.1529c764@thinkpad>
 <8edcc387025a6212d58fe01865725734@walle.cc>
 <20210727183213.73f34141@thinkpad>
 <25d3e798-09f5-56b5-5764-c60435109dd2@gmail.com>
 <20210810172927.GB3302@amd>
 <20210810195550.261189b3@thinkpad>
 <20210810195335.GA7659@duo.ucw.cz>
 <20210810225353.6a19f772@thinkpad>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <20210810225353.6a19f772@thinkpad>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2021-08-10 22:53:53, Marek Beh=FAn wrote:
> On Tue, 10 Aug 2021 21:53:35 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
>=20
> > > Pavel, one point of the discussion is that in this case the LED is
> > > controlled by MAC, not PHY. So the question is whether we want to do
> > > "ethmacN" (in addition to "ethphyN"). =20
> >=20
> > Sorry, I missed that. I guess that yes, ethmacX is okay, too.
> >=20
> > Even better would be to find common term that could be used for both
> > ethmacN and ethphyN and just use that. (Except that we want to avoid
> > ethX). Maybe "ethportX" would be suitable?
>=20
> See
>   https://lore.kernel.org/linux-leds/YQAlPrF2uu3Gr+0d@lunn.ch/
> and
>   https://lore.kernel.org/linux-leds/20210727172828.1529c764@thinkpad/

Ok, I guess I'd preffer all LEDs corresponding to one port to be
grouped, but that may be hard to do.

Best regards,
							Pavel
--=20
http://www.livejournal.com/~pavelmachek

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmEcB9EACgkQMOfwapXb+vJaPQCfVl2WcOkhvfOj2sNF/w3cYLSz
TYMAoK3gL0TuDbwC/Rrz7JRoPSziZeSa
=Fd5E
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
