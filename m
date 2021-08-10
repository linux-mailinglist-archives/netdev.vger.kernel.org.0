Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833873E83F9
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 21:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbhHJTyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 15:54:00 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:38190 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbhHJTyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 15:54:00 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 086F41C0B77; Tue, 10 Aug 2021 21:53:36 +0200 (CEST)
Date:   Tue, 10 Aug 2021 21:53:35 +0200
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
Message-ID: <20210810195335.GA7659@duo.ucw.cz>
References: <YP9n+VKcRDIvypes@lunn.ch>
 <20210727081528.9816-1-michael@walle.cc>
 <20210727165605.5c8ddb68@thinkpad>
 <c56fd3dbe1037a5c2697b311f256b3d8@walle.cc>
 <20210727172828.1529c764@thinkpad>
 <8edcc387025a6212d58fe01865725734@walle.cc>
 <20210727183213.73f34141@thinkpad>
 <25d3e798-09f5-56b5-5764-c60435109dd2@gmail.com>
 <20210810172927.GB3302@amd>
 <20210810195550.261189b3@thinkpad>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <20210810195550.261189b3@thinkpad>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > So "r8159-0300:green:activity" would be closer to the naming we want,
> > but lets not do that, we really want this to be similar to what others
> > are doing, and that probably means "ethphy3:green:activity" AFAICT.
>=20
> Pavel, one point of the discussion is that in this case the LED is
> controlled by MAC, not PHY. So the question is whether we want to do
> "ethmacN" (in addition to "ethphyN").

Sorry, I missed that. I guess that yes, ethmacX is okay, too.

Even better would be to find common term that could be used for both
ethmacN and ethphyN and just use that. (Except that we want to avoid
ethX). Maybe "ethportX" would be suitable?

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYRLZPwAKCRAw5/Bqldv6
8sdjAKCkAKuAMaqBPjpUyAOgAZjoOmL/oACgocl7dFzICwE5ufhlQTgqYj76Mco=
=HcHL
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
