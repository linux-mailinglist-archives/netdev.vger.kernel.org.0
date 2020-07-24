Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E184E22C30B
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 12:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgGXKYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 06:24:06 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:44534 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgGXKYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 06:24:05 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A08C61C0BD2; Fri, 24 Jul 2020 12:24:03 +0200 (CEST)
Date:   Fri, 24 Jul 2020 12:24:03 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v2 1/1] net: phy: marvell: add
 support for PHY LEDs via LED class
Message-ID: <20200724102403.wyuteeql3jn5xouw@duo.ucw.cz>
References: <20200723181319.15988-1-marek.behun@nic.cz>
 <20200723181319.15988-2-marek.behun@nic.cz>
 <20200723213531.GK1553578@lunn.ch>
 <20200724005349.2e90a247@nic.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ysrch4gnwfoyfyze"
Content-Disposition: inline
In-Reply-To: <20200724005349.2e90a247@nic.cz>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ysrch4gnwfoyfyze
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > I expect some of this should be moved into the phylib core. We don't
> > want each PHY inventing its own way to do this. The core should
> > provide a framework and the PHY driver fills in the gaps.
> >=20
> > Take a look at for example mscc_main.c and its LED information. It has
> > pretty similar hardware to the Marvell. And microchip.c also has LED
> > handling, etc.
>=20
> OK, this makes sense. I will have to think about this a little.
>=20
> My main issue though is whether one "hw-control" trigger should be
> registered via LED API and the specific mode should be chosen via
> another sysfs file as in this RFC, or whether each HW control mode
> should have its own trigger. The second solution would either result in
> a lot of registered triggers or complicate LED API, though...

If you register say 5 triggers.... that's okay. If you do like 1024
additional triggers (it happened before!)... well please don't.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ysrch4gnwfoyfyze
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXxq2wwAKCRAw5/Bqldv6
8u7ZAJ9lXMT7/Hz6EZY8muVKbQEzv3r8uwCdFNbG/KOaa+zUTk9YHdfH0Ah3YZU=
=wMRI
-----END PGP SIGNATURE-----

--ysrch4gnwfoyfyze--
