Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96FF22D66E
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 11:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgGYJXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 05:23:43 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:39824 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgGYJXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 05:23:43 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6B2BB1C0BD2; Sat, 25 Jul 2020 11:23:40 +0200 (CEST)
Date:   Sat, 25 Jul 2020 11:23:39 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v3 2/2] net: phy: marvell: add
 support for PHY LEDs via LED class
Message-ID: <20200725092339.GB29492@amd>
References: <20200724164603.29148-1-marek.behun@nic.cz>
 <20200724164603.29148-3-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="nVMJ2NtxeReIH9PS"
Content-Disposition: inline
In-Reply-To: <20200724164603.29148-3-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--nVMJ2NtxeReIH9PS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> +static const struct marvell_led_mode_info marvell_led_mode_info[] =3D {
> +	{ "link",			{ 0x0,  -1, 0x0,  -1,  -1,  -1, }, 0 },
> +	{ "link/act",			{ 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, }, 0 },
> +	{ "1Gbps/100Mbps/10Mbps",	{ 0x2,  -1,  -1,  -1,  -1,  -1, }, 0 },

is this "1Gbps-10Mbps"?

> +	{ "act",			{ 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, }, 0 },
> +	{ "blink-act",			{ 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, }, 0 },
> +	{ "tx",				{ 0x5,  -1, 0x5,  -1, 0x5, 0x5, }, 0 },
> +	{ "tx",				{  -1,  -1,  -1, 0x5,  -1,  -1, }, L3V5_TRANS },
> +	{ "rx",				{  -1,  -1,  -1,  -1, 0x0, 0x0, }, 0 },
> +	{ "rx",				{  -1, 0x0,  -1,  -1,  -1,  -1, }, L1V0_RECV },
> +	{ "copper",			{ 0x6,  -1,  -1,  -1,  -1,  -1, }, 0 },
> +	{ "copper",			{  -1, 0x0,  -1,  -1,  -1,  -1, }, L1V0_COPPER },
> +	{ "1Gbps",			{ 0x7,  -1,  -1,  -1,  -1,  -1, }, 0 },
> +	{ "link/rx",			{  -1, 0x2,  -1, 0x2, 0x2, 0x2, }, 0 },
> +	{ "100Mbps-fiber",		{  -1, 0x5,  -1,  -1,  -1,  -1, }, L1V5_100_FIBER },
> +	{ "100Mbps-10Mbps",		{  -1, 0x5,  -1,  -1,  -1,  -1, }, L1V5_100_10 },
> +	{ "1Gbps-100Mbps",		{  -1, 0x6,  -1,  -1,  -1,  -1, }, 0 },
> +	{ "1Gbps-10Mbps",		{  -1,  -1, 0x6, 0x6,  -1,  -1, }, 0 },
> +	{ "100Mbps",			{  -1, 0x7,  -1,  -1,  -1,  -1, }, 0 },
> +	{ "10Mbps",			{  -1,  -1, 0x7,  -1,  -1,  -1, }, 0 },
> +	{ "fiber",			{  -1,  -1,  -1, 0x0,  -1,  -1, }, L3V0_FIBER },
> +	{ "fiber",			{  -1,  -1,  -1, 0x7,  -1,  -1, }, L3V7_FIBER },
> +	{ "FullDuplex",			{  -1,  -1,  -1, 0x7,  -1,  -1, }, L3V7_DUPLEX },
> +	{ "FullDuplex",			{  -1,  -1,  -1,  -1, 0x6, 0x6, }, 0 },
> +	{ "FullDuplex/collision",	{  -1,  -1,  -1,  -1, 0x7, 0x7, }, 0 },
> +	{ "FullDuplex/collision",	{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_DUPLE=
X },
> +	{ "ptp",			{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_PTP },
> +	{ "init",			{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_INIT },
> +	{ "los",			{  -1,  -1,  -1, 0x0,  -1,  -1, }, L3V0_LOS },
> +	{ "hi-z",			{ 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, }, 0 },
> +	{ "blink",			{ 0xb, 0xb, 0xb, 0xb, 0xb, 0xb, }, 0 },
> +};

Certainly more documentation will be required here, what "ptp" setting
does, for example, is not very obvious to me.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--nVMJ2NtxeReIH9PS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8b+hsACgkQMOfwapXb+vKU6ACfT0Z9Jb+xsTChrjwsBriFCKe4
cXkAnjrAUBLfN2uko9/metSzwjACK4K0
=b6TH
-----END PGP SIGNATURE-----

--nVMJ2NtxeReIH9PS--
