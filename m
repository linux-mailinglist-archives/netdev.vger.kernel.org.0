Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F282EA9AC
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 12:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729435AbhAELS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 06:18:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729196AbhAELSy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 06:18:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 736B5229C5;
        Tue,  5 Jan 2021 11:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609845492;
        bh=GDmYQRHGn/AcnFt3hdxGi1mf2d4j0SgudD/3lB6HiLU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MGoc1AfjFEcjnH2LG9n6lBEYoM6Ri+jtRDQ3pMETkgkS4xWatgY5WzBCv7tGFTTX4
         9deGZUIgeLAhm1VPGBdYES++ZORJDj29LOoOSG8tACOto7uS1nWJwFUZ5fw3Q/9+7t
         9Rnjcz0F86y/qp986vAfUr6GinSVP0XwPgyXu3vSEN7cNL4OxE10chjJdGA85/nxVF
         lPpoMqPvAHjIz+Tazlv2fQtQtSQARqHG/OYlCfxgVMRWyanIC2bLCSGkFIWiXyTy98
         QR/IH6Kj4pkkDkHe387Q3RpA+JZkCdNIme8yoaM7itWnaNn71YrIoqeYgceFoOyLsB
         SI0+F1HbHOM4g==
Received: by earth.universe (Postfix, from userid 1000)
        id 4BD5B3C0C94; Tue,  5 Jan 2021 12:18:10 +0100 (CET)
Date:   Tue, 5 Jan 2021 12:18:10 +0100
From:   Sebastian Reichel <sre@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Stephen Boyd <sboyd@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Add missing array size constraints
Message-ID: <20210105111810.5sdfmjga5in5wgvx@earth.universe>
References: <20210104230253.2805217-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vyuzhxvp4ms2cjlb"
Content-Disposition: inline
In-Reply-To: <20210104230253.2805217-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vyuzhxvp4ms2cjlb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rob,

On Mon, Jan 04, 2021 at 04:02:53PM -0700, Rob Herring wrote:
> DT properties which can have multiple entries need to specify what the
> entries are and define how many entries there can be. In the case of
> only a single entry, just 'maxItems: 1' is sufficient.
>=20
> Add the missing entry constraints. These were found with a modified
> meta-schema. Unfortunately, there are a few cases where the size
> constraints are not defined such as common bindings, so the meta-schema
> can't be part of the normal checks.
>=20
> [...]
>  .../bindings/power/supply/bq25980.yaml        |  1 +
> [...]

Acked-by: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--vyuzhxvp4ms2cjlb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAl/0SucACgkQ2O7X88g7
+ppIAQ/8CwCUtes2Mr7K09stdBuNtR3gBayMxcQnnIM6AQvBexKzq6gM2xpDIPB8
YVpTjaGQkOcwS3BMu7BsRT4t2s3KXy9lVS5jkChykskjyAyr9a7QPsK7MVZVRh2Q
U896qS+zI2nsNdeX6+kT10+29b7PcoEvTJRtEPEFlsq4UoFbMAsdJhtHBo9v1oUP
cJMT7NSkqtcHM9HeSPZFCTLyAsoGFPYMTneKdN9ZVlPHoQRkCH0k3vyHMmKKPWAQ
uafDLlP+nvs9Ug/FSsFsoaLcixHHAI+GkVj48muZL7EVAygGTbrRA27r0txduvfj
DOxfT7BdNOMkmDge0RR2vk29V/2WYsEg4vwi3uyP2BDQsdXEYpwTn00IJ5IJgcqE
EAjq7hWsSo7zd8VkMc/CLN1a1W+PEpIJ0CGfS4cLtAMwRLNLdPA+FS4UaBCAoS4k
T9AZGFXABwtQQHyOAHD8/Hjs5vexDnWdvcRyCuDqgt6YeUX6Lu8pRTWx5lkWPkLy
GZf/jppVAnP/gtnsOOJnPL37jxbOpelu+4UopYZ/j9YLJb+M7P2xYhsYuRlnKn0r
aAgoNpEXu3TNpex2apw+Cm70EiidWAGcWqvrOCWhdqWBulGJ+O4v1DYe536LLoZN
rdX4Hbkx7kBMNJ1ZZVIA3x9YzLwGKo/1nnV2q7fUdTzUEobcJWQ=
=gWL0
-----END PGP SIGNATURE-----

--vyuzhxvp4ms2cjlb--
