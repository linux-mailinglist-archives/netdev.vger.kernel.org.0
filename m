Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C462638ED
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 00:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgIIWUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 18:20:41 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47132 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgIIWUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 18:20:41 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 00D601C0B85; Thu, 10 Sep 2020 00:20:37 +0200 (CEST)
Date:   Thu, 10 Sep 2020 00:20:37 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 2/7] leds: add generic API for LEDs
 that can be controlled by hardware
Message-ID: <20200909222037.GA25392@amd>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909162552.11032-3-marek.behun@nic.cz>
 <20200909204815.GB20388@amd>
 <20200909232016.138bd1db@nic.cz>
 <20200909214009.GA16084@ucw.cz>
 <20200910001526.48a978c4@nic.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <20200910001526.48a978c4@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2020-09-10 00:15:26, Marek Behun wrote:
> On Wed, 9 Sep 2020 23:40:09 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
>=20
> > > >=20
> > > > 80 columns :-) (and please fix that globally, at least at places wh=
ere
> > > > it is easy, like comments).
> > > >  =20
> > >=20
> > > Linux is at 100 columns now since commit bdc48fa11e46, commited by
> > > Linus. See
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmit/scripts/checkpatch.pl?h=3Dv5.9-rc4&id=3Dbdc48fa11e46f867ea4d75fa59ee87=
a7f48be144
> > > There was actually an article about this on Phoronix, I think. =20
> >=20
> > It is not. Checkpatch no longer warns about it, but 80 columns is
> > still preffered, see Documentation/process/coding-style.rst . Plus,
> > you want me to take the patch, not Linus.
>=20
> Very well, I shall rewrap it to 80 columns :)

And thou shalt wrap to 80 columns ever after!
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl9ZVTUACgkQMOfwapXb+vLIvgCgoTckspcpoaiUIXVqhLkHIvoy
qEgAn3Lqj4ZT3FPSc8J+5WEU4d05rqZ/
=nEE1
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
