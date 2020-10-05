Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808FC283B21
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 17:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbgJEPjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 11:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727972AbgJEPjW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 11:39:22 -0400
Received: from earth.universe (dyndsl-095-033-158-146.ewe-ip-backbone.de [95.33.158.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CD5C2085B;
        Mon,  5 Oct 2020 15:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601912361;
        bh=YDa9qgcYN/rLvsHl7wxHnDzXxyPxrajJMh139W2bTQc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yt3ruZa68573tch0c/Ho1ALzHfCpTDMLesbdlPmWRDYNKB50IT55EoZp87fsRkzgz
         7+6j5JNoNjJ3AsqOjA1un0djegx8x339kHr5uakI101R3J4o5G+KgoyioglXZXg5dL
         Bxy38eyfhsJbMySPsKZTFlatV3r6LR8AuCR8oLYA=
Received: by earth.universe (Postfix, from userid 1000)
        id 1CDCB3C0C87; Mon,  5 Oct 2020 17:39:19 +0200 (CEST)
Date:   Mon, 5 Oct 2020 17:39:19 +0200
From:   Sebastian Reichel <sre@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-iio@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, alsa-devel@alsa-project.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, linux-clk@vger.kernel.org,
        linux-leds@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-rockchip@lists.infradead.org, linux-serial@vger.kernel.org,
        linux-mips@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        linux-media@vger.kernel.org, linux-pm@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-gpio@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        openipmi-developer@lists.sourceforge.net,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-hwmon@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-mmc@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-spi@vger.kernel.org,
        Vinod Koul <vkoul@kernel.org>, netdev@vger.kernel.org,
        Baolin Wang <baolin.wang7@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH] dt-bindings: Another round of adding missing
 'additionalProperties'
Message-ID: <20201005153919.llmcjbz4hiqvzd4x@earth.universe>
References: <20201002234143.3570746-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ruzfmjzmyxibtjj5"
Content-Disposition: inline
In-Reply-To: <20201002234143.3570746-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ruzfmjzmyxibtjj5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 02, 2020 at 06:41:43PM -0500, Rob Herring wrote:
> Another round of wack-a-mole. The json-schema default is additional
> unknown properties are allowed, but for DT all properties should be
> defined.
>=20
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>=20
> I'll take this thru the DT tree.
>=20
>  [...]
>  .../bindings/power/supply/cw2015_battery.yaml |  2 ++
>  .../bindings/power/supply/rohm,bd99954.yaml   |  8 ++++++++
> [...]

Acked-by: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--ruzfmjzmyxibtjj5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAl97PhAACgkQ2O7X88g7
+pqkbg/9HQHD97P7Thh0rG2tNf/oTuwqdbqpGz8XffiIbWso3SaAukPavFc/b34T
Bhf9ldAe4Jy7Sz8qDavKYO8qMWOF8av5Je5ajNG3fFmRAO28Jz1vcRsxn7JiTvlU
SnlrNgxMlppGfzCt59G/IH6GyJVUVhZduf1HhaterbutugRNLE6LKY85rtwPlCR6
d4+sJE+gKYJmNhxj1XYyVrXoWQs22IA8nJggb2g2l5nHfFolffKHFRXTX5Ax7WFL
vhm/uSgz/4T9RyObm3lx4ODSSZqC3oc1E0DR3jf97rWH6xGUVFuJoAtE5ZpS5AJt
uC3k2QQJ8mCt5fUA+khtnS4DIsF07uOzd5Hbex8NcXiFnlO/9GYWlmGXxlAnhdrk
vSk8jlPgslc4xKpae1y8DFQiMndd9+1g0b4ZOJ6RnhaNpnOoFOIIPmC2ViRnQ8/0
kv5w7Hop2CIxAYj3Jk1IzlmtbmJeQt39ya7uHNJhV2ISd8P3AmrkcNedPd8OV7MO
7DrV+n/aKjH2gLYX0+377iH59APbluDQd64e+iDir2L5PP4BWXmyMOGqZ+Od7ScJ
YT7hlpoKPVwZ1lqta77S7LDpYrRtyv8Ce5EsFineimEc1b4N51GTMh6lDPIGVcXz
Xa1GC6kpGXU9Cx39fOb5K64cnrJ5Whplgiyv+4xd1suU1q25CZM=
=XHTx
-----END PGP SIGNATURE-----

--ruzfmjzmyxibtjj5--
