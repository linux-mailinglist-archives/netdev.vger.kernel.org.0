Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50ADF6ED60A
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 22:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbjDXURe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 16:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbjDXURd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 16:17:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2D0526F
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 13:17:32 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pr2cX-0001Uq-2a; Mon, 24 Apr 2023 22:17:09 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 263201B6632;
        Mon, 24 Apr 2023 20:17:07 +0000 (UTC)
Date:   Mon, 24 Apr 2023 22:17:06 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Judith Mendez <jm@ti.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Schuyler Patton <spatton@ti.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH v2 2/4] dt-bindings: net: can: Add poll-interval for MCAN
Message-ID: <20230424-pessimist-stability-0b86683e469e-mkl@pengutronix.de>
References: <20230424195402.516-1-jm@ti.com>
 <20230424195402.516-3-jm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4nll47yvmo6txgb2"
Content-Disposition: inline
In-Reply-To: <20230424195402.516-3-jm@ti.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
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


--4nll47yvmo6txgb2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24.04.2023 14:54:00, Judith Mendez wrote:
> On AM62x SoC, MCANs on MCU domain do not have hardware interrupt
> routed to A53 Linux, instead they will use software interrupt by
> hrtimer. To enable timer method, interrupts should be optional so
> remove interrupts property from required section and introduce
> poll-interval property.
>=20
> Signed-off-by: Judith Mendez <jm@ti.com>

The bindings update should go in before the patch.

> ---
> Changelog:
> v2:
>   1. Add poll-interval property to enable timer polling method
>   2. Add example using poll-interval property
>  =20
>  .../bindings/net/can/bosch,m_can.yaml         | 26 ++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b=
/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> index 67879aab623b..1c64c7a0c3df 100644
> --- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> +++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> @@ -40,6 +40,10 @@ properties:
>        - const: int1
>      minItems: 1
> =20
> +  poll-interval:
> +    $ref: /schemas/types.yaml#/definitions/flag
> +    description: Poll interval time in milliseconds.
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

That's not what the code does.

> +
>    clocks:
>      items:
>        - description: peripheral clock
> @@ -122,15 +126,13 @@ required:
>    - compatible
>    - reg
>    - reg-names
> -  - interrupts
> -  - interrupt-names
>    - clocks
>    - clock-names
>    - bosch,mram-cfg

Is it possible to specify that you either need "interrupts" and
"interrupt-names" or "poll-interval"?

> =20
>  additionalProperties: false
> =20
> -examples:
> +example with interrupts:
>    - |
>      #include <dt-bindings/clock/imx6sx-clock.h>
>      can@20e8000 {
> @@ -149,4 +151,22 @@ examples:
>        };
>      };
> =20
> +example with timer polling:
> +  - |
> +    #include <dt-bindings/clock/imx6sx-clock.h>
> +    can@20e8000 {
> +      compatible =3D "bosch,m_can";
> +      reg =3D <0x020e8000 0x4000>, <0x02298000 0x4000>;
> +      reg-names =3D "m_can", "message_ram";
> +      poll-interval;
> +      clocks =3D <&clks IMX6SX_CLK_CANFD>,
> +               <&clks IMX6SX_CLK_CANFD>;
> +      clock-names =3D "hclk", "cclk";
> +      bosch,mram-cfg =3D <0x0 0 0 32 0 0 0 1>;
> +
> +      can-transceiver {
> +        max-bitrate =3D <5000000>;
> +      };
> +    };
> +
>  ...
> --=20
> 2.17.1
>=20
>=20

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--4nll47yvmo6txgb2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRG478ACgkQvlAcSiqK
BOh3iQgAhiH/Oo1tJ2SG+P1STaBF17i+tU9zbvB8eHpMdMUAM9LG9a04Mxe67Mi/
Wn93/J3l4VZvFt/Xv9Jn7zGbh8mraj2xhrtrsIjjjDsmuvEHMy2nDSEduZ162hfg
aMYku2xpo0znEwL4sZT9egnDgwI55t770t4kLIjGhrojc3//QH7pxDsXNl+oczIl
82RV/kJd5eWGHDW/zxIS9lq7jevPt6x05lAXe1jINL5uLgzmcyJf3q8h/1znOlH9
KJo6rhQ7pyM8z3rqkNz+Ro3HB5O92QHAI4uGpHqR5Y4CJ5pozk+3SRg1Vbiq6tdc
VVGxrT4kHRnjlx+yCDnW1vwAYMgL4g==
=lyyE
-----END PGP SIGNATURE-----

--4nll47yvmo6txgb2--
