Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B68923E9C0
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 11:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgHGJG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 05:06:58 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:35376 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgHGJG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 05:06:58 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id AE7051C0BD9; Fri,  7 Aug 2020 11:06:53 +0200 (CEST)
Date:   Fri, 7 Aug 2020 11:06:53 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek =?utf-8?B?QmVow7pu?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v4 0/2] Add support for LEDs on
 Marvell PHYs
Message-ID: <20200807090653.ihnt2arywqtpdzjg@duo.ucw.cz>
References: <20200728150530.28827-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tuqlwx4lnotoz6lx"
Content-Disposition: inline
In-Reply-To: <20200728150530.28827-1-marek.behun@nic.cz>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tuqlwx4lnotoz6lx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> this is v4 of my RFC adding support for LEDs connected to Marvell PHYs.
>=20
> Please note that if you want to test this, you still need to first apply
> the patch adding the LED private triggers support from Pavel's tree.
> https://git.kernel.org/pub/scm/linux/kernel/git/pavel/linux-leds.git/comm=
it/?h=3Dfor-next&id=3D93690cdf3060c61dfce813121d0bfc055e7fa30d
>=20
> What I still don't like about this is that the LEDs created by the code
> don't properly support device names. LEDs should have name in format
> "device:color:function", for example "eth0:green:activity".
>=20
> The code currently looks for attached netdev for a given PHY, but
> at the time this happens there is no netdev attached, so the LEDs gets
> names without the device part (ie ":green:activity").
>=20
> This can be addressed in next version by renaming the LED when a netdev
> is attached to the PHY, but first a API for LED device renaming needs to
> be proposed. I am going to try to do that. This would also solve the
> same problem when userspace renames an interface.
>=20
> And no, I don't want phydev name there.

Ummm. Can we get little more explanation on that? I fear that LED
device renaming will be tricky and phydev would work around that
nicely.

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--tuqlwx4lnotoz6lx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXy0ZrQAKCRAw5/Bqldv6
8o/UAJ9nvd57fgnTIHmdYW/OH4c5swwXJQCguYTbyQen7XuCNSviqkB7ZxmHeYs=
=WH64
-----END PGP SIGNATURE-----

--tuqlwx4lnotoz6lx--
