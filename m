Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF50F56415A
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 18:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbiGBQPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 12:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbiGBQPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 12:15:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B360AE0FE
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 09:15:03 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o7flf-0003Eu-FG; Sat, 02 Jul 2022 18:14:47 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9AB00A596E;
        Sat,  2 Jul 2022 16:14:45 +0000 (UTC)
Date:   Sat, 2 Jul 2022 18:14:45 +0200
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
Subject: Re: [PATCH 2/6] dt-bindings: can: nxp,sja1000: Document RZ/N1{D,S}
 support
Message-ID: <20220702161445.lwiumlsj6wumyein@pengutronix.de>
References: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
 <20220702140130.218409-3-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="s27sukapqayuwrca"
Content-Disposition: inline
In-Reply-To: <20220702140130.218409-3-biju.das.jz@bp.renesas.com>
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


--s27sukapqayuwrca
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.07.2022 15:01:26, Biju Das wrote:
> Add CAN binding documentation for Renesas RZ/N1 SoC.
>=20
> The SJA1000 CAN controller on RZ/N1 SoC has some differences compared
> to others like it has no clock divider register (CDR) support and it has
> no HW loopback(HW doesn't see tx messages on rx), so introduced a new
               ^^^

please add space.

> compatible 'renesas,rzn1-sja1000' to handle these differences.
>=20
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  .../bindings/net/can/nxp,sja1000.yaml         | 22 +++++++++++++++++++
>  1 file changed, 22 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml b=
/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
> index 91d0f1b25d10..d0d374b979ec 100644
> --- a/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
> +++ b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
> @@ -16,6 +16,12 @@ properties:
>          const: nxp,sja1000
>        - description: Technologic Systems SJA1000 CAN Controller
>          const: technologic,sja1000
> +      - description: Renesas RZ/N1 SJA1000 CAN Controller
> +        items:
> +          - enum:
> +              - renesas,r9a06g032-sja1000 # RZ/N1D
> +              - renesas,r9a06g033-sja1000 # RZ/N1S
> +          - const: renesas,rzn1-sja1000 # RZ/N1
> =20
>    reg:
>      maxItems: 1
> @@ -23,6 +29,12 @@ properties:
>    interrupts:
>      maxItems: 1
> =20
> +  clocks:
> +    maxItems: 1
> +
> +  clock-names:
> +    const: can_clk
> +
>    reg-io-width:
>      $ref: /schemas/types.yaml#/definitions/uint32
>      description: I/O register width (in bytes) implemented by this device
> @@ -91,6 +103,16 @@ allOf:
>        required:
>          - reg-io-width
> =20
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: renesas,rzn1-sja1000
> +    then:
> +      required:
> +        - clocks
> +        - clock-names
> +
>  unevaluatedProperties: false
> =20
>  examples:

Can you add an example, too?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--s27sukapqayuwrca
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLAbvIACgkQrX5LkNig
012iEAf/YHDy/iS30EuC+6cT2SUMaXoYcwBbbAi5DOJWNfvy3R7pte6t9ts/GzRX
HJww+bDBOUjRUeKg4XL7QZJfvq7JFq2masS52XKoZshGxbVMoaia5DVTkQ1eW6Yj
8abH7MEphxll8LTWx3ZSUHbje1nuZBVBR7T1p0bFxGkeqzgwLcJmZ4Bf11LgfT6N
w1TAHgEF/q4ub9AurMfDQbL1c+wqD+/0QkEAT2WXmFsgpsjsbR6XICvIO39kd5xb
5sFrImDy7IsCR8CFdURTK9X0oO5dwJzn0qWUeyTUWi15N2Svd4mg3vHfaYljtW9X
ZIK5HSU/r9EtCcJBFU23AytCAQCWTw==
=x+Mg
-----END PGP SIGNATURE-----

--s27sukapqayuwrca--
