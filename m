Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF06E1D5749
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgEORRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:17:05 -0400
Received: from www.zeus03.de ([194.117.254.33]:51086 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgEORRD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 13:17:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=y/oPAlM3y149jK6KpGqj8Z5Pq8h3
        NvzaLZuF1iAdHP4=; b=CYrRX15UMLFe4N6YaFxcYR8WOHMQYtKoR7HPoaaAO+Rl
        dR/GJ7di9Z84KJeaSs8G3YYjMiWTux0qNUlZFXyV6WGdCGWDxmCWhm+4rW2owioe
        XIcDBF0dR2IqrM+SWBqISth438neo+uCJqOloNYRaYYbdCMCnL00HQYTE31gGj4=
Received: (qmail 72585 invoked from network); 15 May 2020 19:17:00 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 15 May 2020 19:17:00 +0200
X-UD-Smtp-Session: l3s3148p1@hA4w+7KlTKogAwDPXwnHAMSqtBM6FBGP
Date:   Fri, 15 May 2020 19:17:00 +0200
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 04/17] dt-bindings: mmc: renesas,sdhi: Document r8a7742
 support
Message-ID: <20200515171700.GE19423@ninjato>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-5-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="u5E4XgoOPWr4PD9E"
Content-Disposition: inline
In-Reply-To: <1589555337-5498-5-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--u5E4XgoOPWr4PD9E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2020 at 04:08:44PM +0100, Lad Prabhakar wrote:
> Document SDHI controller for RZ/G1H (R8A7742) SoC, which is compatible
> with R-Car Gen2 SoC family.
>=20
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renes=
as.com>

Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--u5E4XgoOPWr4PD9E
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl6+zowACgkQFA3kzBSg
KbbvIw/9EYa5/sZYqiy76zk/MTv8kk/gPlGwTIjDi2HRy9v89chDKR0n3nVsmAh9
syTTZT+eIjYSBFMHNr16WfrLBEEe8lWND0daeubEka3tu3/XMcuBOzMXydVzjpdt
cf6ypbS1YrjSgy8ITo2w8rROpvDv4evP4UKSlJrar7ABLKuY0HZZ3b6JXXjy3JIx
/JueAAj1RqIwJ/2wTUiBdThfKDKh1tzm2fhV41dfd4t1S8NOnhBzz9zjnDJQ/8Zg
FJA9TBgPznA16ybyW+kx01+smxxPiKp0uaICTVzftA09Zi+/dkjuFpWx6GShPZ7G
08bcdZRD5wNjRWcDxXt12oh6l4x2rnwebBl+5FpzJAPc7imRBIcYvuVpJI3Ev9aL
TDaqoKUWO4k+qHzP5f67cAjARnHh3SyJTePon+1k1L4k1vNC691utDTiGhdEaQ+E
uLNcMR9bcuFkjQMkKTV7AY07sE6ojXxlKhvGaR122Z5LxtW5+ah620e0QkxArqJ7
xLbjpahEKrAV4vunMDWW8+vEY3uTLHOM/EvBACC6CL52B3nQPEeRwhbrqYpHhb1l
PuaOBezOdCOpIOnNm+zHFX5JD7YPNQ3bRh6VjSBgW66yX+mjlkJJV7QR3qXPx4RR
hCOU+zTdBNM9mgXSidnl9M7slanJKkKmCn4LszbKUAj2+G+Wdsg=
=m9/n
-----END PGP SIGNATURE-----

--u5E4XgoOPWr4PD9E--
