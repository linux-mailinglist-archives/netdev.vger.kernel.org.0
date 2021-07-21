Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A379C3D1651
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 20:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbhGURo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 13:44:28 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:36268 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbhGURo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 13:44:27 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 26F131C0B77; Wed, 21 Jul 2021 20:25:03 +0200 (CEST)
Date:   Wed, 21 Jul 2021 20:25:02 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Andrew Lunn <andrew@lunn.ch>, marek.behun@nic.cz
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <20210721182502.GB7554@duo.ucw.cz>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <20210716212427.821834-6-anthony.l.nguyen@intel.com>
 <f705bcd6-c55c-0b07-612f-38348d85bbee@gmail.com>
 <YPTKB0HGEtsydf9/@lunn.ch>
 <88d23db8-d2d2-5816-6ba1-3bd80738c398@gmail.com>
 <YPbu8xOFDRZWMTBe@lunn.ch>
 <3b7ad100-643e-c173-0d43-52e65d41c8c3@gmail.com>
 <YPgwr2MB5gQVgDff@lunn.ch>
 <20210721182314.GA7554@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <20210721182314.GA7554@duo.ucw.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > Now the (linked) LED devices are under /sys/class/net/<ifname>, but s=
till
> > > the primary LED devices are under /sys/class/leds and their names have
> > > to be unique therefore. The LED subsystem takes care of unique names,
> > > but in case of a second network interface the LED device name suddenly
> > > would be led0_1 (IIRC). So the names wouldn't be predictable, and I t=
hink
> > > that's not what we want.
> >=20
> > We need input from the LED maintainers, but do we actually need the
> > symbolic links in /sys/class/leds/? For this specific use case, not
> > generally. Allow an LED to opt out of the /sys/class/leds symlink.
> >=20
> > If we could drop those, we can relax the naming requirements so that
> > the names is unique to a parent device, not globally unique.
>=20
> Well, I believe we already negotiated acceptable naming with
> Marek... Is it unsuitable for some reason?

Sorry, hit send too soon.. Marek is now in cc list.

								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYPhmfgAKCRAw5/Bqldv6
8jy7AJ947Kk2HbiHiNzLaNnlUXecrsfk7ACcD9rrbLu7+FJNMwF0TOKlcSQB0Fs=
=OZIS
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
