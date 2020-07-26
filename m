Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A251922DF14
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 14:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgGZMfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 08:35:32 -0400
Received: from www.zeus03.de ([194.117.254.33]:40028 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727038AbgGZMf1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jul 2020 08:35:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=hAn/LE/O5d3kxI+zRKnrNTOzPNdu
        g55BS3PlBbqbkJU=; b=3MJ7whwPdGP07MOckxZuQXNLp9AS5PydqOUWUjnhNGs0
        /ygHQgdVM2x4IK/MtT1F3yEwT1ut9AYnVGGr9FqADjhd+oPIpAvZr+BNTWUX27L4
        F6X/cRcF8BiDuVy6q1EvbMDmKS5Tk/FLrY9aLvfbfUvL9xR/BgY+7WIXIm+KyS0=
Received: (qmail 40443 invoked from network); 26 Jul 2020 14:35:24 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 26 Jul 2020 14:35:24 +0200
X-UD-Smtp-Session: l3s3148p1@wgOmcFer/o8gAwDPXy27AOM4pzPBFrIA
Date:   Sun, 26 Jul 2020 14:35:23 +0200
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
Subject: Re: [PATCH 12/20] dt-bindings: i2c: renesas,iic: Document r8a774e1
 support
Message-ID: <20200726123523.GD2484@ninjato>
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-13-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="YToU2i3Vx8H2dn7O"
Content-Disposition: inline
In-Reply-To: <1594811350-14066-13-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--YToU2i3Vx8H2dn7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 15, 2020 at 12:09:02PM +0100, Lad Prabhakar wrote:
> Document IIC controller for RZ/G2H (R8A774E1) SoC, which is compatible
> with R-Car Gen3 SoC family.
>=20
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renes=
as.com>

Applied to for-next, thanks!


--YToU2i3Vx8H2dn7O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl8deIsACgkQFA3kzBSg
KbZtUQ/+JiFdXGopN/62fLmk1CxZX8mBIzoyojCZ2h3EScRmzR7ZPXc+JBB2nDdj
LW1Rnv2JMK+Grggia9/QsY4fPQHIyclI36TdZjYSqN6pf1CNCj1edHRwG3UmH5NX
wDE/uaHhcDuluDGRxx4yeRugfTrIu2uPVaLEmLnWxeQLNPQetBGOYkhqrQ1Nq124
DlNu+O274kobkRLex7AgtEDKQifMt5+xxWddrfpuitktDS2GuOQameQlVxLP0KJ9
WLZMlv1Axh9jF9J/Zj+i1q3c1HAk/I5coZ5GLE0v5tjm38/lzo2ysi8lJbW7qyJK
g9z/XvhRfD3FVm9+0Pejmf9/gmhzV7xHJQgELNOXrUvLs5v4ZeqPJxjGIF3ioSZb
cURJ14zLCLzDya8omSqxlw9A+efai0pmWCqf0TA7U43USV1fXt2w6FbevI+rpqZG
xuo/XSRsXgKSXZpGHUzf/YmYVNTNXZ9220lFmBgBoM3716H+SXlSlXjW42n40J3q
KxhmVu+kCjATOz67YUjGeHM03FDh2u2/qkPFgO5fQOSBqinaub81RYUbZEBlGggu
+mr8XVxUe/GsIFHuevSwmRpSTyoSc1SCyt4W3OkyCEh1xsJWKnrbqeJhdjruqXZY
HtmnMFsLCgIunvtHSMu7nQCJDI4Q7s9f+oxVxO1Wtx+RNrir5Yc=
=YVyw
-----END PGP SIGNATURE-----

--YToU2i3Vx8H2dn7O--
