Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8674339AB96
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 22:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhFCUKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 16:10:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230083AbhFCUKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 16:10:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EBE8611C9;
        Thu,  3 Jun 2021 20:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622750945;
        bh=vouxc5KMLEMa3QrqPqXja2Z4KHWtjXXf/sVDLuzgUZE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UYeXhRQkhsFG2wW4pMFx1ENgilnnfZtGlHetX3wkENSTPOwGglvuReS2frt1cjTtl
         JLKCPkpKMa+NFqpLVPYTtBPL0W7QDpwuraSUhXTED5ruFCTZ9l/ZX9j2f0fTHd72HX
         kez6g1QVBsDVie8+Ol70lWcbLUVi1CXU1PW0xR/2pCdlEh0uFsIt5t1odTPh3MK5Rr
         a5Km3PlwQZ/OU5n1g2kWDQQWpus4Z5O11Vo1RXQubZjb3F/M7e1Zij82vHdp1Vv0Lw
         PNnhqdSX0wMy7B0BUu9GlN4yLxGGR/WG4yMmJYO7tsywLyQGMS7Po49eXeaSRMo1qA
         +IfEKzjVtpXVQ==
Date:   Thu, 3 Jun 2021 22:09:02 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>, Keerthy <j-keerthy@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Mark Brown <broonie@kernel.org>, Nishanth Menon <nm@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tero Kristo <kristo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-can@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-spi@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 04/12] dt-bindings: clock: update ti,sci-clk.yaml
 references
Message-ID: <YLk23rrWN9ze+zru@kunai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>, Keerthy <j-keerthy@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Mark Brown <broonie@kernel.org>, Nishanth Menon <nm@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Stephen Boyd <sboyd@kernel.org>, Tero Kristo <kristo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Wolfgang Grandegger <wg@grandegger.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-spi@vger.kernel.org, netdev@vger.kernel.org
References: <cover.1622648507.git.mchehab+huawei@kernel.org>
 <0fae687366c09dfb510425b3c88316a727b27d6d.1622648507.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="HwDyggedf9K45ZIg"
Content-Disposition: inline
In-Reply-To: <0fae687366c09dfb510425b3c88316a727b27d6d.1622648507.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--HwDyggedf9K45ZIg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 02, 2021 at 05:43:10PM +0200, Mauro Carvalho Chehab wrote:
> Changeset a7dbfa6f3877 ("dt-bindings: clock: Convert ti,sci-clk to json s=
chema")
> renamed: Documentation/devicetree/bindings/clock/ti,sci-clk.txt
> to: Documentation/devicetree/bindings/clock/ti,sci-clk.yaml.
>=20
> Update the cross-references accordingly.
>=20
> Fixes: a7dbfa6f3877 ("dt-bindings: clock: Convert ti,sci-clk to json sche=
ma")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Acked-by: Wolfram Sang <wsa@kernel.org> # for I2C


--HwDyggedf9K45ZIg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmC5Nt4ACgkQFA3kzBSg
KbYA5BAAmxrTszpFm+SFwkhyzevlAeZO+O6tTPRp2hAT0FogM2Us0fUzfwLEFgWP
dR+9Lw8BinKXs9tNQwP3RGM6/azDSnS8tL5a1l0aaI52mxwwu0zGKPZmCvvMizT2
AQX51DP3llTCDdTc85P1C7TYhRyhYy1GWPJrfhAxfUBS+maMcJJ3VX7rfnmQlAWG
6FOy1eZaCP2d2DxVZNlMi0TXsYuudltp75a0T7k8wesRQv+BEEE4MpyfFwDquX/N
3BtPLsuwSDnSQ1hL3gEPEbrm++yG+3g0PHdhWxdrDeRV/eRW8EM4rjJ0xHutgimp
LyQ0SnSdM6/EMF0h4jjQ2CPLGedDPpKkBdXsAH0yU8GqD2P5mijVUJHZqqyCKdz4
8elfRdDzaLOrwvZrqTQYqGpeup/953O/m8mbKfy0zhkc2X0Ceqmqb2iKDzvemODe
OpVnrneL06Fo3k9Mi0c828teZf7T4kZPBFI896XMP8MYeT7ghBaOrRBt6mIaefTN
dCZGUE9vm2SbKqBOJ88QHbyFwDwHDj7UU4O9uhZH77nUj3kzQC+yfp0xLhkkT3lE
ME9gAuT18XacriGNwHQVpMUPTvMAcLUWeHqfYIvPVd/HQRNMwV/IB2paBkGThO7/
gzP8cd9cYoh9D2thXE0J/EnXq+MPeo6KVP9Uirz9eSo6jxKoggM=
=2IA3
-----END PGP SIGNATURE-----

--HwDyggedf9K45ZIg--
