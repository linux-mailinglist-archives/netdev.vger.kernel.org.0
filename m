Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E799F56414F
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 18:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbiGBQMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 12:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbiGBQMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 12:12:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F55E0B8
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 09:12:09 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o7fik-0002zG-SK; Sat, 02 Jul 2022 18:11:46 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 138CBA5964;
        Sat,  2 Jul 2022 16:11:41 +0000 (UTC)
Date:   Sat, 2 Jul 2022 18:11:41 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 1/6] dt-bindings: can: sja1000: Convert to json-schema
Message-ID: <20220702161141.cfeemj2hobei2z4k@pengutronix.de>
References: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
 <20220702140130.218409-2-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kg7mrcpo3dm2jeux"
Content-Disposition: inline
In-Reply-To: <20220702140130.218409-2-biju.das.jz@bp.renesas.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kg7mrcpo3dm2jeux
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.07.2022 15:01:25, Biju Das wrote:
> Convert the NXP SJA1000 CAN Controller Device Tree binding
> documentation to json-schema.
>=20
> Update the example to match reality.
>=20
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  .../bindings/net/can/nxp,sja1000.yaml         | 106 ++++++++++++++++++
>  .../devicetree/bindings/net/can/sja1000.txt   |  58 ----------
>  2 files changed, 106 insertions(+), 58 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/can/nxp,sja1000=
=2Eyaml
>  delete mode 100644 Documentation/devicetree/bindings/net/can/sja1000.txt
>=20
> diff --git a/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml b=
/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
> new file mode 100644
> index 000000000000..91d0f1b25d10
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
> @@ -0,0 +1,106 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/can/nxp,sja1000.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Memory mapped SJA1000 CAN controller from NXP (formerly Philips)
> +
> +maintainers:
> +  - Wolfgang Grandegger <wg@grandegger.com>

Please add:

allOf:
  - $ref: can-controller.yaml#

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--kg7mrcpo3dm2jeux
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLAbjoACgkQrX5LkNig
010c0wf/TU+eiTGp7fNfKgBWIZhVVz+u0Pouz0Dz8z8hN5QZn0x3lnTDlt6Nx3IK
55uSlIJxSkdGX87XpoZ1KdGHJiN/r3GCm6eQGPBz1BmPmjXE2/Oy7EQwy5dyaKpt
f8eJC2nbAe6U/7DixxA6XlOvoh6qyRpkS7qXlc4CnxRHlEFYYcFBVH7pdrZCFMBy
RLeuKhyepu/QD5bCZetfjHrfHYQy2CB7nh5/EUVeR2hV3Kpww5kRnNeA0zRdUktz
n5NZ8+QWIniJEXu+YChdCOnztqZ6ljHbJctO3a7L2gf/uh7j8etY+vY4CpQQs9On
RSvNn4wxuRxtCncrDRO4/Op+E0QQuQ==
=YVj9
-----END PGP SIGNATURE-----

--kg7mrcpo3dm2jeux--
