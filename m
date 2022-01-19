Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE0D49349D
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 06:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351543AbiASFsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 00:48:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234835AbiASFsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 00:48:41 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A01C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 21:48:40 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nA3pj-00043p-Ry; Wed, 19 Jan 2022 06:48:35 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 267D31D285;
        Wed, 19 Jan 2022 05:48:35 +0000 (UTC)
Date:   Wed, 19 Jan 2022 06:48:31 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Improve phandle-array schemas
Message-ID: <20220119054831.wvizk2dg5oomvppe@pengutronix.de>
References: <20220119015038.2433585-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cd724kalvprkppp2"
Content-Disposition: inline
In-Reply-To: <20220119015038.2433585-1-robh@kernel.org>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cd724kalvprkppp2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.01.2022 19:50:38, Rob Herring wrote:
> The 'phandle-array' type is a bit ambiguous. It can be either just an
> array of phandles or an array of phandles plus args. Many schemas for
> phandle-array properties aren't clear in the schema which case applies
> though the description usually describes it.
>=20
> The array of phandles case boils down to needing:
>=20
> items:
>   maxItems: 1
>=20
> The phandle plus args cases should typically take this form:
>=20
> items:
>   - items:
>       - description: A phandle
>       - description: 1st arg cell
>       - description: 2nd arg cell
>=20
> With this change, some examples need updating so that the bracketing of
> property values matches the schema.
>=20
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Chun-Kuang Hu <chunkuang.hu@kernel.org>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: Georgi Djakov <djakov@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Jingoo Han <jingoohan1@gmail.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Vivien Didelot <vivien.didelot@gmail.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Viresh Kumar <vireshk@kernel.org>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Kevin Hilman <khilman@kernel.org>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Jonathan Hunter <jonathanh@nvidia.com>
> Cc: Sudeep Holla <sudeep.holla@arm.com>
> Cc: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: linux-ide@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: dmaengine@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: iommu@lists.linux-foundation.org
> Cc: linux-leds@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-can@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Cc: linux-phy@lists.infradead.org
> Cc: linux-gpio@vger.kernel.org
> Cc: linux-riscv@lists.infradead.org
> Cc: linux-remoteproc@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
[...]
>  .../bindings/net/can/bosch,c_can.yaml         |  8 +-
>  .../bindings/net/can/fsl,flexcan.yaml         | 12 +--

For the net/can/ bindings:
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--cd724kalvprkppp2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHnpi0ACgkQqclaivrt
76niRAgArtrlVdIp1DLKdBWjiyWc6ZbIz9jdFaprFVg47/TzkaBd3ZTT9a1FpjlF
gCq8qOr7hLGYkROnpZ8/6H4wmf0/NXDNE4GsUG3nUD7PliT9YD7AX9cJUITYPGap
dVK64wzh6SRKWuing9Os5pav0Y/U5Z5cApzNqe4EcU2bdKD6SPYBJxetQAIqABTH
fFMmUiOf4v0uaAR7PRVxofrkLaU24WIp1G/ub648XP8aw2y+j8p5/A4GX9b7CpEv
lyotcksJ1BWdzMOYrLTJYaXsHz4z5YLAdzZOdE9rScNDHT3PtbYlO8dSB2q6idHh
/yQMBLl1AugbG627kBlt2tXau5JJjA==
=+LO6
-----END PGP SIGNATURE-----

--cd724kalvprkppp2--
