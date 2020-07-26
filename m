Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB2022DF0A
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 14:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgGZMf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 08:35:28 -0400
Received: from www.zeus03.de ([194.117.254.33]:39948 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbgGZMfX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jul 2020 08:35:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=onAeRnhffhF8ckRwRk4DsGKcuZ5Z
        A3FW02cG3cQyVvk=; b=xOPdX7zIGdV+hLDlDtvJQrla1xgvXVqgjudDwZNJcY/y
        UxH6Uxc3rBrfVuJ6qwDWL6hBSBtWw2GhDWVjKC9p7CtD5q6fULK7WI9rNWEzztj8
        c6QmeBMw5XkrgpSXrqPG+G4nlMniocnv8rbnHt5MagEQJ3i3L88k/ge12XmPocY=
Received: (qmail 40298 invoked from network); 26 Jul 2020 14:35:19 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 26 Jul 2020 14:35:19 +0200
X-UD-Smtp-Session: l3s3148p1@D31ocFer/I8gAwDPXy27AOM4pzPBFrIA
Date:   Sun, 26 Jul 2020 14:35:19 +0200
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Niklas <niklas.soderlund@ragnatech.se>,
        Zhang Rui <rui.zhang@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Magnus Damm <magnus.damm@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 11/20] dt-bindings: i2c: renesas,i2c: Document r8a774e1
 support
Message-ID: <20200726123519.GC2484@ninjato>
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-12-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ZwgA9U+XZDXt4+m+"
Content-Disposition: inline
In-Reply-To: <1594811350-14066-12-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZwgA9U+XZDXt4+m+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 15, 2020 at 12:09:01PM +0100, Lad Prabhakar wrote:
> Document i2c controller for RZ/G2H (R8A774E1) SoC, which is compatible
> with R-Car Gen3 SoC family.
>=20
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renes=
as.com>

Applied to for-next, thanks!


--ZwgA9U+XZDXt4+m+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl8deIcACgkQFA3kzBSg
KbZbZA//W705bUta/I2fFJX9THCgPXeyts2P3gy1nQcBJvGROOzL6jZJne4W6nHR
fJdAUnOfyZMTkCvfgnGGrnCa2QRrIgIYmnx1ZpF+dONaPYJPkZOOXoven13LjohY
0lswiHVVEsKsESNlA8agcPm9Gniuvb8jpzUfpaTOZd2VQr6vV7YSoq53HXOKka+s
mXwwe5J31Mc/DnJ7Yu0bZYo9jyFdKg4xSXrTwAz5FK+OqdYEyY9Qnu3ne0JZ4k99
xPaCx5h0DQcoR4rOqIi21dedGiJ7iRuao1sDBgq5X1BxHIzJ5q+1HW1xiwMTdj/d
6xA2PN1HxqaZ3Ff6p0tamC5AgmjgMQrFJj2cFI+fF/1VWp62V3O8oNZ/5b3f7bP4
4f5ZwCfNYTcGB9tJnDxqTsAHAXAhnxlNc56kCWEZhTzKDzE7gW+H6+90OZEtzeA5
Akq7504HPVrlgmL52JBbNcunDvs1eTc9ROjPVYJPGu5BKrcB+m2a0HCwhi2nJRBT
XE//0zGPvPpiq+wYvUiyxmrBWTE/qKJekKoyLUmEIYlaDy9IdDEes5m9yJFlmsAy
tvXt/lsCak31bfhyHa6HQQ3O8tjC5h+DTpJ4G1zp4u3d1yqBJcobgbySqibzKalP
BdwAoJP8ng3+Q1MBRngxSYyKZvv7J3uderjW7yq8BN8+KwjU+uE=
=FNmn
-----END PGP SIGNATURE-----

--ZwgA9U+XZDXt4+m+--
