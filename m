Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5E71ABE96
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 12:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505822AbgDPK6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 06:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505190AbgDPKtx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 06:49:53 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BEA4206B9;
        Thu, 16 Apr 2020 10:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587033627;
        bh=PbIJJBCyxb0zjE+EsVUIseBGje2iBqdBzd3TawdCtII=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qLx+neJh2XiUym52/Y5To6wDkJdF+YfeO3N39IXBEI/aglNs6bS7P/uMNiV4FoJl3
         TMp7QxwJIyoECwfzV+F5isAyTkbeACxvuyoa8MrjQkJVF1B64098yNWGLrS06i/htu
         0dOZ+2iYr9R63yIwg4ubkL8oPIU3RmTo6iLh2Iwc=
Date:   Thu, 16 Apr 2020 11:40:24 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, Vinod Koul <vkoul@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Fabio Estevam <festevam@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-i2c@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: Clean-up schema indentation formatting
Message-ID: <20200416104024.GD5354@sirena.org.uk>
References: <20200416005549.9683-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wLAMOaPNJ0fu1fTG"
Content-Disposition: inline
In-Reply-To: <20200416005549.9683-1-robh@kernel.org>
X-Cookie: Tempt me with a spoon!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wLAMOaPNJ0fu1fTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 15, 2020 at 07:55:48PM -0500, Rob Herring wrote:
> Fix various inconsistencies in schema indentation. Most of these are
> list indentation which should be 2 spaces more than the start of the
> enclosing keyword. This doesn't matter functionally, but affects running
> scripts which do transforms on the schema files.

Acked-by: Mark Brown <broonie@kernel.org>

--wLAMOaPNJ0fu1fTG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl6YNhcACgkQJNaLcl1U
h9CTpAf+IW4icH5zPKy5c7TecTxfEyWNDjNTt8Pa69ga67NVmMDHKzueRcPb7D3e
ihhK7zM0HDSd8aebO5YtW3GiVBBUyJ0m1CNYvbcsJscIhoOoco+NPJUss00w/0Zs
L0RHGHcgc6lhNve8n+r6QbzSYEeeT9QhqTaPtyPnvMDRUkAYgShAD0ejHjNQWYOt
3KuH8RD18xfK/PWSRsrrxCY3flOTx0RIpS9+oyO+JWIcKd6Y5lCZiBAXGrXEdEjx
bgRsC/mO1YSE03iuDgQnodKThzIoJrygjOkGGDJuYsKY5erh8JZ93l5KPoLkyKCT
SSA9qjNaVs+wMuSlq8WJ3w8m+z5cOA==
=dNaD
-----END PGP SIGNATURE-----

--wLAMOaPNJ0fu1fTG--
