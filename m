Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00712C404D
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 13:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbgKYMe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 07:34:57 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:43922 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgKYMe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 07:34:56 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5200D1C0B7D; Wed, 25 Nov 2020 13:34:53 +0100 (CET)
Date:   Wed, 25 Nov 2020 13:34:52 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Ben Whitten <ben.whitten@gmail.com>
Subject: Re: [PATCH RFC leds + net-next 1/7] leds: trigger: netdev: don't
 explicitly zero kzalloced data
Message-ID: <20201125123452.GH29328@amd>
References: <20201030114435.20169-1-kabel@kernel.org>
 <20201030114435.20169-2-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BXr400anF0jyguTS"
Content-Disposition: inline
In-Reply-To: <20201030114435.20169-2-kabel@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--BXr400anF0jyguTS
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2020-10-30 12:44:29, Marek Beh=FAn wrote:
> The trigger_data struct is allocated with kzalloc, so we do not need to
> explicitly set members to zero.
>=20
> Signed-off-by: Marek Beh=FAn <kabel@kernel.org>

Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
http://www.livejournal.com/~pavelmachek

--BXr400anF0jyguTS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl++T2wACgkQMOfwapXb+vL8+wCfV9aovEv2ZXH7tU/+Thx4lu3g
ggkAnRrTzWt2MXjjQuEqXv8VdoR+GtsQ
=i18V
-----END PGP SIGNATURE-----

--BXr400anF0jyguTS--
