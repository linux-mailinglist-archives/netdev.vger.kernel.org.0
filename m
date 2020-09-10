Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A146D2645F3
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 14:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730696AbgIJM0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 08:26:23 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:41632 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730654AbgIJMWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 08:22:47 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 30DA81C0B9C; Thu, 10 Sep 2020 14:22:41 +0200 (CEST)
Date:   Thu, 10 Sep 2020 14:22:40 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 5/7] net: phy: add support for LEDs
 controlled by ethernet PHY chips
Message-ID: <20200910122240.GB7907@duo.ucw.cz>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909162552.11032-6-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="R3G7APHDIzY6R/pk"
Content-Disposition: inline
In-Reply-To: <20200909162552.11032-6-marek.behun@nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2020-09-09 18:25:50, Marek Beh=FAn wrote:
> This patch uses the new API for HW controlled LEDs to add support for
> probing and control of LEDs connected to an ethernet PHY chip.
>=20
> A PHY driver wishing to utilize this API needs to implement the methods
> in struct hw_controlled_led_ops and set the member led_ops in struct
> phy_driver to point to that structure.
>=20
> Signed-off-by: Marek Beh=FAn <marek.behun@nic.cz>

Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--R3G7APHDIzY6R/pk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX1oakAAKCRAw5/Bqldv6
8uUTAKCLN7qshmbM2XNee7PS+Fxx3IsflACgm4lcbbH6gCzPO0xUOjAz10xDqGg=
=GLyw
-----END PGP SIGNATURE-----

--R3G7APHDIzY6R/pk--
