Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5852696A4
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 22:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgINUai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 16:30:38 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:52572 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbgINUaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 16:30:25 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9D1521C0B79; Mon, 14 Sep 2020 22:30:21 +0200 (CEST)
Date:   Mon, 14 Sep 2020 22:30:06 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Yet another ethernet PHY LED control proposal
Message-ID: <20200914203006.GA20984@duo.ucw.cz>
References: <20200912011045.35bad071@nic.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <20200912011045.35bad071@nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I have been thinking about another way to implement ABI for HW control
> of ethernet PHY connected LEDs.
>=20
> This proposal is inspired by the fact that for some time there is a
> movement in the kernel to do transparent HW offloading of things (DSA
> is an example of that).

And it is good proposal.

> So currently we have the `netdev` trigger. When this is enabled for a
> LED, new files will appear in that LED's sysfs directory:
>   - `device_name` where user is supposed to write interface name
>   - `link` if set to 1, the LED will be ON if the interface is linked
>   - `rx` if set to 1, the LED will blink on receive event
>   - `tx` if set to 1, the LED will blink on transmit event
>   - `interval` specifies duration of the LED blink
>=20
> Now what is interesting is that almost all combinations of link/rx/tx
> settings are offloadable to a Marvell PHY! (Not to all LEDs, though...)
>=20
> So what if we abandoned the idea of a `hw` trigger, and instead just
> allowed a LED trigger to be offloadable, if that specific LED supports
> it?
>=20
> For the HW mode for different speed we can just expand the `link` sysfs
> file ABI, so that if user writes a specific speed to this file, instead
> of just "1", the LED will be on if the interface is linked on that
> specific speed. Or maybe another sysfs file could be used for "light on
> N mbps" setting...
>=20
> Afterwards we can figure out other possible modes.
>=20
> What do you think?

If this can be implemented (and it probably can) it is the best
solution :-).

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX1/SzgAKCRAw5/Bqldv6
8nyOAKCXZm+yb0nWq0MRdfDiltwvT2EfXACgrPumGW+HW9kr2bppVAtd5dXx9Ro=
=G7da
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
