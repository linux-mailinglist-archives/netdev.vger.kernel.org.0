Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D0C1D576C
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgEORTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:19:08 -0400
Received: from www.zeus03.de ([194.117.254.33]:51850 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgEORTI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 13:19:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=iMZTqvDDUa0ON0gCVwAQj5ux/EUE
        N72+SP2tHEQXgYM=; b=w2tKfYQTa5Xl3459sryX+TmmEzz+sDUzic3lAKDPEI2t
        A1mzLUKWleYBdLsy9SdhZU32sp8rTSoqFwGv+Djg47jGCrTie+VU7Q4T27/Qek4w
        GaTcto34n+YbiTBgHkTrZJDbQ1Kgu4RXXEF8R4/8Xk8I/Qr4SMgbfbLIfKfC9eE=
Received: (qmail 71206 invoked from network); 15 May 2020 19:12:24 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 15 May 2020 19:12:24 +0200
X-UD-Smtp-Session: l3s3148p1@IcvC6rKlSKogAwDPXwnHAMSqtBM6FBGP
Date:   Fri, 15 May 2020 19:12:24 +0200
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
Subject: Re: [PATCH 01/17] dt-bindings: i2c: renesas,i2c: Document r8a7742
 support
Message-ID: <20200515171224.GC19423@ninjato>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-2-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gr/z0/N6AeWAPJVB"
Content-Disposition: inline
In-Reply-To: <1589555337-5498-2-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gr/z0/N6AeWAPJVB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2020 at 04:08:41PM +0100, Lad Prabhakar wrote:
> Document i2c controller for RZ/G1H (R8A7742) SoC, which is compatible
> with R-Car Gen2 SoC family.
>=20
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renes=
as.com>

Dunno if patches need to be this fine-grained (e.g. group all simple additi=
ons
like this in one patch) but still:

Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--gr/z0/N6AeWAPJVB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl6+zXgACgkQFA3kzBSg
KbbZYRAAnpWxFnEIbwAA3+z7ZFTNEQvQyjAWSXleeUFyvVU26eqXC8qcOAuqZKNM
4Ik55pniyFLew2G3ylqjufEenb0X7pi6w7Pw9A+yOhn3umK2b/JizUh0dDO9jW3U
R5rI4mLQq4VWip5O2l0StaSiKCgnYBzybv/ztZazwY+5Y85nhtXz4qgmmKxclZ1t
+GQH8ihEzPNJxTSX8CgMpQWt5/JZaKpRZYmtUQQ8cXTXHv/U4pVki+ZVHiUluLRB
g2/2/WI/cJp38dMgJm/1Gjt2edLVqVqoonW+dnJqRTFELjoT8vpD2bHfWrtEOFDr
wU9I5zgtbqJQCIFCufjUXexvuGg6xzVI7eRvjf75m4ehNZHRZ9nNNCMeB5D3HRKP
SQfKh+2jn8h3oDUO2eGab7raKvorGP8FSRU5wHxqx4sKKXTryRbWk+KQAbyM5Epg
nRzcGPyJO4dZdm8kFwSkl/L++4VzTrFZqRdgMo0DUpoKSgcwMaV0Wa5d9uhhMK+b
Nyc2a0zrTbNb8eh0Ts/KZDwmj5XThuNyGBx6mUGAdgf8NBfLKJDd/+DNR590cNK0
27xX9aRUKh/4wqoaDdurat/xThcqH8tSf93/Rj+BNku3NqSZglCbyzO/gtujdjtQ
XBap60Anoz7TVCVvpo1iPdwrgOd0Op4KUrkC6Dq8VZ8RDXFU+AU=
=eH8I
-----END PGP SIGNATURE-----

--gr/z0/N6AeWAPJVB--
