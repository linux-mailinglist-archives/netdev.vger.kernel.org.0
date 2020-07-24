Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A5E22D1DD
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 00:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgGXWir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 18:38:47 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:49636 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgGXWir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 18:38:47 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 82C521C0BD2; Sat, 25 Jul 2020 00:38:44 +0200 (CEST)
Date:   Sat, 25 Jul 2020 00:38:44 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     linux-leds@vger.kernel.org, jacek.anaszewski@gmail.com,
        Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v2 0/1] Add support for LEDs on
 Marvell PHYs
Message-ID: <20200724223844.GA24384@amd>
References: <20200723181319.15988-1-marek.behun@nic.cz>
 <20200724102901.qp65rtkxucauglsp@duo.ucw.cz>
 <20200724151233.35d799e8@dellmb.labs.office.nic.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <20200724151233.35d799e8@dellmb.labs.office.nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2020-07-24 15:12:33, Marek Beh=FAn wrote:
> On Fri, 24 Jul 2020 12:29:01 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
>=20
> > In future, would you expect having software "1000/100/10/nolink"
> > triggers I could activate on my scrollock LED (or on GPIO controlled
> > LEDs) to indicate network activity?
>=20
> Look at drivers/net/phy/phy_led_triggers.c, something like that could
> be actually implemented there.
>=20
> Some of the modes are useful, like the "1000/100/10/nolink". But some
> of them are pretty weird, and I don't think anyone actually uses it
> ("1000-10/else", which is on if the device is linked at 1000mbps ar
> 10mbps, and else off? who would sacrifies a LED for this?).
>=20
> I actually wanted to talk about the phy_led_triggers.c code. It
> registers several trigger for each PHY, with the name in form:
>   phy-device-name:mode
> where
>   phy-device-name is derived from OF
>     - sometimes it is in the form
>       d0032004.mdio-mii:01
>     - but sometimes in the form of whole OF path followed by ":" and
>       the PHY address:
>       /soc/internal-regs@d0000000/mdio@32004/switch0@10/mdio:08
>   mode is "link", "1Gbps", "100Mbps", "10Mbps" and so on"
>=20
> So I have a GPIO LED, and I can set it to sw trigger so that it is on
> when a specific PHY is linked on 1Gbps.
>=20
> The problem is that on Turris Mox I can connect up to three 8-port
> switches, which yields in 25 network PHYs overall. So reading the
> trigger file results in 4290 bytes (look at attachment cat_trigger.txt).
> I think the phy_led_triggers should have gone this way of having just
> one trigger (like netdev has), and specifying phy device via and mode
> via another file.

I agree with you. This is ... not pretty ... and it would be nice to
get it fixed.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8bYvMACgkQMOfwapXb+vL+6QCeNQBcceZTkyjl1bm+0JhHxnE8
wt8An3Z/sFRowDd/7dI0Kz7WamI0ivh2
=iB1C
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
