Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D6A3F7D65
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 22:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235933AbhHYU4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 16:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230025AbhHYU4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 16:56:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 221C76108E;
        Wed, 25 Aug 2021 20:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629924926;
        bh=gjZeZMGJIoheKp31xKi7pLwU9TfiEyPpquQWCgvZtE4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y9boM9pg89jRKmwouT/QTKTfP6cnbbCCCS7xmR/j11WJTKQOoI8xp/F9tCG875w14
         t6ZHgrFxWueYM1Y92Rl7sM+t1APG8oB3pawMogJMmlk55scB1wpiiS9VEVKHn2TSfQ
         v6b9DHSD8GG1ExHf6HWDK/0ILsqf5kdC4LZvW8txDVi7va9/vzSeyJvT19soF4LTaO
         UhE+SSACe6K2tgwjuD324QiY1xyoXVmyl0z/7jdZ80aCjvvWDXLZHJ4EY3w0hYaMuh
         LCtCQKRsN60dvSDuUXJopL0P8Y23dbW9YmOT36artHj8pWjc7htojIylo/VltN2sRE
         hShhViV80NumQ==
Date:   Wed, 25 Aug 2021 22:55:21 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vinod Koul <vkoul@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Vignesh R <vigneshr@ti.com>, Marc Zyngier <maz@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        dmaengine@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-serial@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Use 'enum' instead of 'oneOf' plus 'const'
 entries
Message-ID: <YSauOeE4lBfeDiGw@kunai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Maxime Ripard <mripard@kernel.org>, Vignesh R <vigneshr@ti.com>,
        Marc Zyngier <maz@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        dmaengine@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-serial@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-spi@vger.kernel.org
References: <20210824202014.978922-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="l25l+0aqVZr4EHUF"
Content-Disposition: inline
In-Reply-To: <20210824202014.978922-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--l25l+0aqVZr4EHUF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 24, 2021 at 03:20:14PM -0500, Rob Herring wrote:
> 'enum' is equivalent to 'oneOf' with a list of 'const' entries, but 'enum'
> is more concise and yields better error messages.
>=20
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Vignesh R <vigneshr@ti.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: dmaengine@vger.kernel.org
> Cc: linux-i2c@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> Cc: linux-phy@lists.infradead.org
> Cc: linux-serial@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Cc: linux-spi@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>

Acked-by: Wolfram Sang <wsa@kernel.org> # for I2C

Thanks!


--l25l+0aqVZr4EHUF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmEmrjQACgkQFA3kzBSg
KbZM6Q//Y9REdiq/zJ83ZpDra3byCGjog62qLvRAGT4bIWJksXDHZQIAI+VT4f6T
bcW/EdAoYI1thOwyeO0PFXFAocKX3YZqx8y3bUw/vQXhQmDi3lhbeA3nmGlGl5zF
DJoaMXH/hK7uuwmdyeoHFpedIP5M+gHnvDyC4ZarCzeWuZBWMf4fwFyOgVS4PtHw
nRqm4E9bfQNCveZ/YxIQdbJFg8x419pJ49q3xqnLPweEAPs0h27mIG45IrPwHw8A
aVOGhHDvGqA3HduEiFmcLZWL7Ud3ariS19SSiHwdcdTPXtYBI+JPJh+arDDaJ2JF
8sgn/OSkymL9JZa0mg5Y3O9+FczVUlHALdrC+eSxkOlfXNR3xOJzetBC12vBlH44
6gBxucO3QoyujUTd7gsfaVIn5XqssAsWn2BYD9iM5j0D74Quyb2t1m10e6wMRWVv
/wSiWLnsC6dSO2jpulphC/G/Fyw+YcPfmvm402PlgOY5tzsY6sVS6eqyegvMReUP
oc26QyGtdxBy9Ksr54/s3N8WV14vcJm/mjCLH3ejKPrtBvOyu9sXEFmyV6lhB9r2
pEr0igI5TSC1J9EHQyvT10B56KbKlz4ZLB44daIOAYCvAIrlVRd+Yn/Nnmvk0mbs
7bnP+mB18KKgKC6GdNtfMyyZFCetGmhPLp1n1JUeoTlACwJF++Q=
=9C1H
-----END PGP SIGNATURE-----

--l25l+0aqVZr4EHUF--
