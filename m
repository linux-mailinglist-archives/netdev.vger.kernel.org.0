Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA099193390
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 23:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbgCYWHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 18:07:53 -0400
Received: from foss.arm.com ([217.140.110.172]:53740 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727357AbgCYWHw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 18:07:52 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F6641FB;
        Wed, 25 Mar 2020 15:07:51 -0700 (PDT)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE6623F71E;
        Wed, 25 Mar 2020 15:07:50 -0700 (PDT)
Date:   Wed, 25 Mar 2020 22:07:49 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Brian Masney <masneyb@onstation.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guillaume La Roque <glaroque@baylibre.com>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Jonathan Cameron <jic23@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zhang Rui <rui.zhang@intel.com>,
        dri-devel@lists.freedesktop.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] dt-bindings: Add missing 'additionalProperties:
 false'
Message-ID: <20200325220749.GF12169@sirena.org.uk>
References: <20200325220542.19189-1-robh@kernel.org>
 <20200325220542.19189-5-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sDKAb4OeUBrWWL6P"
Content-Disposition: inline
In-Reply-To: <20200325220542.19189-5-robh@kernel.org>
X-Cookie: Do not stamp.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--sDKAb4OeUBrWWL6P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 25, 2020 at 04:05:41PM -0600, Rob Herring wrote:
> Setting 'additionalProperties: false' is frequently omitted, but is
> important in order to check that there aren't extra undocumented
> properties in a binding.
>=20
> Ideally, we'd just add this automatically and make this the default, but
> there's some cases where it doesn't work. For example, if a common
> schema is referenced, then properties in the common schema aren't part
> of what's considered for 'additionalProperties'. Also, sometimes there
> are bus specific properties such as 'spi-max-frequency' that go into
> bus child nodes, but aren't defined in the child node's schema.

Acked-by: Mark Brown <broonie@kernel.org>

--sDKAb4OeUBrWWL6P
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl571jQACgkQJNaLcl1U
h9Afjwf/TlVFnvMm+meLOwlfTMDT7xvKv6i3g4S/t/OkkG/qfuDfUpRz0LarRYTg
8163ZrHY0aAQmLzyxMQR2cBhzM1tfANuY93djQNhe1ac6MUdNxTGLm1n+m9xh/o8
IsSrgrnEqXCNCgqkAvPcDY7qkeLi68p5VqJIfdOjjeJkusQL3Q0kQUv7kpi6cgXn
5Y+PlKm4cxLmOxFeUmCLQKocDSMttTCjxA/jm7jX+CWzKJjObhgsoHP9rg+uIO+1
VHCHKXwxl1a8dhfG9ZnUxXY9UqGqGINojiPmRtTBX5oZqY95zShlcNiJ2HNaRRsT
oIsZgkZuypvPpKies+jaVF2IuoSbcA==
=EzfV
-----END PGP SIGNATURE-----

--sDKAb4OeUBrWWL6P--
