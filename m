Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF202637C42
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiKXO6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiKXO6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:58:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD9A6DCD4;
        Thu, 24 Nov 2022 06:58:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DF08B82839;
        Thu, 24 Nov 2022 14:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1066C433C1;
        Thu, 24 Nov 2022 14:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669301877;
        bh=p8YNNsJqpgLW4+75mbpTUMSskutGGu2ScGLQuz97/CU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z85hV3GcsUlbCTjPlVv/H72vQ+xmBWe+vqlz0voXhm4iQJHuIV/NBu2cEWX7ynF1t
         avV0nCOFQ23EiTTU07b9SckKZ9+wMf8vHYHIXfq/kwXM5uLNsTlU26VBMD27aPbl+9
         uGJvbKpJGrhoOOir+IniU+vJJBLdtpUv2ulYHXxUNW6g9lwE5n8hKk6OZAksCbwy/m
         +qMvS4xS7U8LLfkf4dZ6XAY9baM08mtOnOCVHknPXqEx++34nwMJ+lpIb0rAHuoWCM
         BxcjSQbsuITduJCjn6IJg0lunYZ3gm6WxgG+Cz/FItsvZ0fatR9ExK4SGPQrEDOvKF
         Uh0wp/yd2/Vcw==
Received: by mercury (Postfix, from userid 1000)
        id 347D4106092A; Thu, 24 Nov 2022 15:57:55 +0100 (CET)
Date:   Thu, 24 Nov 2022 15:57:55 +0100
From:   Sebastian Reichel <sre@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-watchdog@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Viresh Kumar <vireshk@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH v2 6/9] dt-bindings: drop redundant part of title (end,
 part three)
Message-ID: <20221124145755.plvlrcvnewym3vao@mercury.elektranox.org>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
 <20221121110615.97962-7-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xmpntro7zhggw4xy"
Content-Disposition: inline
In-Reply-To: <20221121110615.97962-7-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xmpntro7zhggw4xy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 21, 2022 at 12:06:12PM +0100, Krzysztof Kozlowski wrote:
> The Devicetree bindings document does not have to say in the title that
> it is a "binding", but instead just describe the hardware.
>=20
> Drop trailing "bindings" in various forms (also with trailling full
> stop):
>=20
>   find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
>     -not -name 'trivial-devices.yaml' \
>     -exec sed -i -e 's/^title: \(.*\) [bB]indings\?\.\?$/title: \1/' {} \;
>=20
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> ---

=2E..

>  .../devicetree/bindings/power/supply/dlg,da9150-charger.yaml    | 2 +-
>  .../devicetree/bindings/power/supply/dlg,da9150-fuel-gauge.yaml | 2 +-
>  .../devicetree/bindings/power/supply/ingenic,battery.yaml       | 2 +-
>  .../devicetree/bindings/power/supply/lltc,lt3651-charger.yaml   | 2 +-
>  .../devicetree/bindings/power/supply/sc2731-charger.yaml        | 2 +-
>  Documentation/devicetree/bindings/power/supply/sc27xx-fg.yaml   | 2 +-

=2E..

> diff --git a/Documentation/devicetree/bindings/power/supply/dlg,da9150-ch=
arger.yaml b/Documentation/devicetree/bindings/power/supply/dlg,da9150-char=
ger.yaml
> index b289388952bf..85bebebb285b 100644
> --- a/Documentation/devicetree/bindings/power/supply/dlg,da9150-charger.y=
aml
> +++ b/Documentation/devicetree/bindings/power/supply/dlg,da9150-charger.y=
aml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/power/supply/dlg,da9150-charger.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: Dialog Semiconductor DA9150 Charger Power Supply bindings
> +title: Dialog Semiconductor DA9150 Charger Power Supply
> =20
>  maintainers:
>    - Sebastian Reichel <sre@kernel.org>
> diff --git a/Documentation/devicetree/bindings/power/supply/dlg,da9150-fu=
el-gauge.yaml b/Documentation/devicetree/bindings/power/supply/dlg,da9150-f=
uel-gauge.yaml
> index d47caf59d204..7cc94b872937 100644
> --- a/Documentation/devicetree/bindings/power/supply/dlg,da9150-fuel-gaug=
e.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/dlg,da9150-fuel-gaug=
e.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/power/supply/dlg,da9150-fuel-gauge.ya=
ml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: Dialog Semiconductor DA9150 Fuel-Gauge Power Supply bindings
> +title: Dialog Semiconductor DA9150 Fuel-Gauge Power Supply
> =20
>  maintainers:
>    - Sebastian Reichel <sre@kernel.org>
> diff --git a/Documentation/devicetree/bindings/power/supply/ingenic,batte=
ry.yaml b/Documentation/devicetree/bindings/power/supply/ingenic,battery.ya=
ml
> index 42fcfc026972..741022b4449d 100644
> --- a/Documentation/devicetree/bindings/power/supply/ingenic,battery.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/ingenic,battery.yaml
> @@ -5,7 +5,7 @@
>  $id: http://devicetree.org/schemas/power/supply/ingenic,battery.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: Ingenic JZ47xx battery bindings
> +title: Ingenic JZ47xx battery
> =20
>  maintainers:
>    - Artur Rojek <contact@artur-rojek.eu>
> diff --git a/Documentation/devicetree/bindings/power/supply/lltc,lt3651-c=
harger.yaml b/Documentation/devicetree/bindings/power/supply/lltc,lt3651-ch=
arger.yaml
> index 76cedf95a12c..d26ed5eabe28 100644
> --- a/Documentation/devicetree/bindings/power/supply/lltc,lt3651-charger.=
yaml
> +++ b/Documentation/devicetree/bindings/power/supply/lltc,lt3651-charger.=
yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/power/supply/lltc,lt3651-charger.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: Analog Devices LT3651 Charger Power Supply bindings
> +title: Analog Devices LT3651 Charger Power Supply
> =20
>  maintainers:
>    - Sebastian Reichel <sre@kernel.org>
> diff --git a/Documentation/devicetree/bindings/power/supply/sc2731-charge=
r.yaml b/Documentation/devicetree/bindings/power/supply/sc2731-charger.yaml
> index 735f7d372ae1..a846a4d14ca9 100644
> --- a/Documentation/devicetree/bindings/power/supply/sc2731-charger.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/sc2731-charger.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/power/supply/sc2731-charger.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: Spreadtrum SC2731 PMICs battery charger binding
> +title: Spreadtrum SC2731 PMICs battery charger
> =20
>  maintainers:
>    - Sebastian Reichel <sre@kernel.org>
> diff --git a/Documentation/devicetree/bindings/power/supply/sc27xx-fg.yam=
l b/Documentation/devicetree/bindings/power/supply/sc27xx-fg.yaml
> index d90a838a1744..de43e45a43b7 100644
> --- a/Documentation/devicetree/bindings/power/supply/sc27xx-fg.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/sc27xx-fg.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/power/supply/sc27xx-fg.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: Spreadtrum SC27XX PMICs Fuel Gauge Unit Power Supply Bindings
> +title: Spreadtrum SC27XX PMICs Fuel Gauge Unit Power Supply
> =20
>  maintainers:
>    - Sebastian Reichel <sre@kernel.org>

Acked-by: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--xmpntro7zhggw4xy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmN/hnIACgkQ2O7X88g7
+ppYAhAAnHONtIui6zTaeZ02+2QlgCdz5G6TwfgDfu54I+2gFyqeByNDcTVUsi4v
Jn/apUs1XpI+UsptfOykULP3Z+kUftFWKjfqpO7dKAvNWbfJF0y9NDQ2WLHZaLvn
UZAtBxBvXEoPVX+Z+UcgdJ+oOb+XNJ0Pk8pmNsrHIbL5HdQmPeJ1J6u7VQS1/yYW
2wgX0w143GlDuL/XDWetHCAusKXKwgUw/3na1JQQsRnomfEELJKloPkRXg10Al0U
6FMotDn/4L4Orofg02sWlr7/ixgrsOx0zNUzeQ4KmznoqjgygCplPUrX8Je0iy44
ogcEuJ0FnX7aXL97MgRtu1CaTOfSqAvSmWQtX/kJso81n6y/Yy5EDnX95e03vK9Z
s5yFmwKzSL58HsSJTemXqrn61eXWBZz5/iv/vOAZtP9lLuChm7RMThTqVgsbUc9S
WNvUFqg+Oif0iEGchd5+skcB9f9aM1KXntdk9esUEf2T/OrBIC2UOlAyhbjq5ynt
sOLIZagwjrWKC4XFoZ8kzonwEyqpJGmZtEcqFS7s3ns1ytiCKj880AJ4U0aE1tBj
5sEnYC/U0CW+HjwJ84gWxETBrEEVp4BqjDfW5JtAygsqDQ7DD+WZ1hJ3sYSV/UR/
dpLgLYegcwWnhu8seLXGraMjQC3kTopbnqkqf0IBQhn0oyQ47XM=
=I0rl
-----END PGP SIGNATURE-----

--xmpntro7zhggw4xy--
