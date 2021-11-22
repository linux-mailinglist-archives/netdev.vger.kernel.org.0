Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C11459311
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240276AbhKVQey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:34:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230099AbhKVQeu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 11:34:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C2AB60F24;
        Mon, 22 Nov 2021 16:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637598699;
        bh=iFOBiXk1C/As6/il8FGU5DiqUhIBtU/YMVkyvDJzQME=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XYC0QVZe/yHz4tn1Ns+3SkcvOpWvBTvUo3eDiFl+LMVW2VmQVljeAVXqs+uEgWo5j
         Bn3Hr1OA1n9R+SqMDcTIBZ+U4CRlLsz5WrJ5U3phLVmG5YErMn8IAtyWdLD3GEgpTk
         1OFUk2QerMpoYcASzaxIN35W/DlD2VlfD7R7w8gpMfuFRpjGrwzFQRaP0E2f1lYvfD
         8oyujkH+Ipt5JGY4bNgZxPE/yxJYVGlRR+74nkiluH5nzYaUkeR7ovS8Gguch81/zw
         PTDrwU6YHu8IRdG4PltzeEvJO0VZVADDdju2Mi2EJ3rgjxwVY3lzLdY5MnHCtaHk5f
         GtEJSF+kC4eLw==
Date:   Mon, 22 Nov 2021 16:31:27 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Tony Lindgren <tony@atomide.com>,
        Russell King <linux@armlinux.org.uk>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Paul Walmsley <paul@pwsan.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Tero Kristo <kristo@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Benoit Parrot <bparrot@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, openbmc@lists.ozlabs.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH/RFC 14/17] regulator: ti-abb: Use bitfield helpers
Message-ID: <YZvF3yh9XnTcaXe9@sirena.org.uk>
References: <cover.1637592133.git.geert+renesas@glider.be>
 <c8508cae36c52c750dbb12493dd44d92fcf51ad4.1637592133.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jRjZyYaT+L2tgnde"
Content-Disposition: inline
In-Reply-To: <c8508cae36c52c750dbb12493dd44d92fcf51ad4.1637592133.git.geert+renesas@glider.be>
X-Cookie: Lake Erie died for your sins.
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jRjZyYaT+L2tgnde
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 22, 2021 at 04:54:07PM +0100, Geert Uytterhoeven wrote:
> Use the field_{get,prep}() helpers, instead of open-coding the same
> operations.

Acked-by: Mark Brown <broonie@kernel.org>

--jRjZyYaT+L2tgnde
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmGbxd8ACgkQJNaLcl1U
h9Au/Qf/V1gk6vuEyYqep3F+nkFeONrTZVKuCnRfhWw5gYk2o7IrGtqaN4L0XgcG
LQLotuaAu0BBZX/+cxF2XPbrWNjnR9MQMIUZo98nlGSTjxam1UhUdHJPbpXm2fbk
K8DExTJKv+DKeOGRk8LcmAyVHyrkTmZbcPcEE5qwaQldeS/Iuvmg6i889evqj3oD
FKHeZo8KvkL9B69w+j8bvlnCPiUZJd1spFZc3KMhS1N7HfzQxDGAIsEhezb0vSKa
Vu8+J+B7goS0IcpAHyB8ng4sUvJZAWDWTzaW+VKb818Swfd84YLF8vEEYabZTM9c
OVDG47kEUXwqHRPv3qz2+BqXpg9oYw==
=aIIx
-----END PGP SIGNATURE-----

--jRjZyYaT+L2tgnde--
