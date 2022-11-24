Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344DC637C5D
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiKXO7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiKXO7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:59:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD5D10EA35;
        Thu, 24 Nov 2022 06:59:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38C17621A8;
        Thu, 24 Nov 2022 14:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CCAC433D6;
        Thu, 24 Nov 2022 14:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669301948;
        bh=nSBbA0yT0iOMP+Chy8tXuZKeJthAWp2datFpACAVtvk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g/Z3XTip6g2FFmhrf9q8UschEx45weHmYzYe79H8we9sEIqYNBGMcUwUSPidJztHO
         EoJzTvZD3z+NDD9JMtHvEj2fc7JtF0W7dcaODw8FbII7IMM9Wm0vJeRsVixP0jK3xU
         BaWqLTeZ0AN5DXC/qD9A3fPsNK7Mq0dBos/Fo3mo7kS2QA5fAuCocrjcrPfIQckCkg
         W/c4cENdBvarlEWR9kDnN5cacS4gkkB0A7sTN7erTqL5hGvL5fCZZff48TWtCX4WW9
         bAFx68QM6jUNzLf5rE3FYsARfEuiv6CaM29wT1sOR6D5KoY1RAkp0bSbhwEHs//8tP
         kR7J0rMgtQcug==
Received: by mercury (Postfix, from userid 1000)
        id 43C24106092A; Thu, 24 Nov 2022 15:59:06 +0100 (CET)
Date:   Thu, 24 Nov 2022 15:59:06 +0100
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
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v2 7/9] dt-bindings: drop redundant part of title
 (beginning)
Message-ID: <20221124145906.i3xjt4cqwhbqpcop@mercury.elektranox.org>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
 <20221121110615.97962-8-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="at2ocn3dkmbrzexs"
Content-Disposition: inline
In-Reply-To: <20221121110615.97962-8-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--at2ocn3dkmbrzexs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 21, 2022 at 12:06:13PM +0100, Krzysztof Kozlowski wrote:
> The Devicetree bindings document does not have to say in the title that
> it is a "Devicetree binding", but instead just describe the hardware.
>=20
> Drop beginning "Devicetree bindings" in various forms:
>=20
>   find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
>     -exec sed -i -e 's/^title: [dD]evice[ -]\?[tT]ree [bB]indings\? for \=
([tT]he \)\?\(.*\)$/title: \u\2/' {} \;
>=20
>   find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
>     -exec sed -i -e 's/^title: [bB]indings\? for \([tT]he \)\?\(.*\)$/tit=
le: \u\2/' {} \;
>=20
>   find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
>     -exec sed -i -e 's/^title: [dD][tT] [bB]indings\? for \([tT]he \)\?\(=
=2E*\)$/title: \u\2/' {} \;
>=20
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> ---

=2E..

>  Documentation/devicetree/bindings/power/supply/bq2415x.yaml     | 2 +-
>  Documentation/devicetree/bindings/power/supply/bq24190.yaml     | 2 +-
>  Documentation/devicetree/bindings/power/supply/bq24257.yaml     | 2 +-
>  Documentation/devicetree/bindings/power/supply/bq24735.yaml     | 2 +-
>  Documentation/devicetree/bindings/power/supply/bq25890.yaml     | 2 +-
>  Documentation/devicetree/bindings/power/supply/isp1704.yaml     | 2 +-
>  .../devicetree/bindings/power/supply/lltc,ltc294x.yaml          | 2 +-
>  .../devicetree/bindings/power/supply/richtek,rt9455.yaml        | 2 +-
>  Documentation/devicetree/bindings/power/supply/ti,lp8727.yaml   | 2 +-

=2E..

> diff --git a/Documentation/devicetree/bindings/power/supply/bq2415x.yaml =
b/Documentation/devicetree/bindings/power/supply/bq2415x.yaml
> index a3c00e078918..f7287ffd4b12 100644
> --- a/Documentation/devicetree/bindings/power/supply/bq2415x.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/bq2415x.yaml
> @@ -5,7 +5,7 @@
>  $id: http://devicetree.org/schemas/power/supply/bq2415x.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: Binding for TI bq2415x Li-Ion Charger
> +title: TI bq2415x Li-Ion Charger
> =20
>  maintainers:
>    - Sebastian Reichel <sre@kernel.org>
> diff --git a/Documentation/devicetree/bindings/power/supply/bq24190.yaml =
b/Documentation/devicetree/bindings/power/supply/bq24190.yaml
> index 4884ec90e2b8..001c0ffb408d 100644
> --- a/Documentation/devicetree/bindings/power/supply/bq24190.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/bq24190.yaml
> @@ -5,7 +5,7 @@
>  $id: http://devicetree.org/schemas/power/supply/bq24190.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: Binding for TI BQ2419x Li-Ion Battery Charger
> +title: TI BQ2419x Li-Ion Battery Charger
> =20
>  maintainers:
>    - Sebastian Reichel <sre@kernel.org>
> diff --git a/Documentation/devicetree/bindings/power/supply/bq24257.yaml =
b/Documentation/devicetree/bindings/power/supply/bq24257.yaml
> index c7406bef0fa8..cc45939d385b 100644
> --- a/Documentation/devicetree/bindings/power/supply/bq24257.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/bq24257.yaml
> @@ -5,7 +5,7 @@
>  $id: http://devicetree.org/schemas/power/supply/bq24257.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: Binding for bq24250, bq24251 and bq24257 Li-Ion Charger
> +title: Bq24250, bq24251 and bq24257 Li-Ion Charger
> =20
>  maintainers:
>    - Sebastian Reichel <sre@kernel.org>
> diff --git a/Documentation/devicetree/bindings/power/supply/bq24735.yaml =
b/Documentation/devicetree/bindings/power/supply/bq24735.yaml
> index dd9176ce71b3..388ee16f8a1e 100644
> --- a/Documentation/devicetree/bindings/power/supply/bq24735.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/bq24735.yaml
> @@ -5,7 +5,7 @@
>  $id: http://devicetree.org/schemas/power/supply/bq24735.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: Binding for TI BQ24735 Li-Ion Battery Charger
> +title: TI BQ24735 Li-Ion Battery Charger
> =20
>  maintainers:
>    - Sebastian Reichel <sre@kernel.org>
> diff --git a/Documentation/devicetree/bindings/power/supply/bq25890.yaml =
b/Documentation/devicetree/bindings/power/supply/bq25890.yaml
> index ee51b6335e72..dae27e93af09 100644
> --- a/Documentation/devicetree/bindings/power/supply/bq25890.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/bq25890.yaml
> @@ -5,7 +5,7 @@
>  $id: http://devicetree.org/schemas/power/supply/bq25890.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: Binding for bq25890, bq25892, bq25895 and bq25896 Li-Ion Charger
> +title: Bq25890, bq25892, bq25895 and bq25896 Li-Ion Charger
> =20
>  maintainers:
>    - Sebastian Reichel <sre@kernel.org>
> diff --git a/Documentation/devicetree/bindings/power/supply/isp1704.yaml =
b/Documentation/devicetree/bindings/power/supply/isp1704.yaml
> index 7e3449ed70d4..fb3a812aa5a9 100644
> --- a/Documentation/devicetree/bindings/power/supply/isp1704.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/isp1704.yaml
> @@ -5,7 +5,7 @@
>  $id: http://devicetree.org/schemas/power/supply/isp1704.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: Binding for NXP ISP1704 USB Charger Detection
> +title: NXP ISP1704 USB Charger Detection
> =20
>  maintainers:
>    - Sebastian Reichel <sre@kernel.org>
> diff --git a/Documentation/devicetree/bindings/power/supply/lltc,ltc294x.=
yaml b/Documentation/devicetree/bindings/power/supply/lltc,ltc294x.yaml
> index 109b41a0d56c..774582cd3a2c 100644
> --- a/Documentation/devicetree/bindings/power/supply/lltc,ltc294x.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/lltc,ltc294x.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/power/supply/lltc,ltc294x.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: Binding for LTC2941, LTC2942, LTC2943 and LTC2944 battery fuel ga=
uges
> +title: LTC2941, LTC2942, LTC2943 and LTC2944 battery fuel gauges
> =20
>  description: |
>    All chips measure battery capacity.
> diff --git a/Documentation/devicetree/bindings/power/supply/richtek,rt945=
5.yaml b/Documentation/devicetree/bindings/power/supply/richtek,rt9455.yaml
> index bce15101318e..27bebc1757ba 100644
> --- a/Documentation/devicetree/bindings/power/supply/richtek,rt9455.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/richtek,rt9455.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/power/supply/richtek,rt9455.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: Binding for Richtek rt9455 battery charger
> +title: Richtek rt9455 battery charger
> =20
>  maintainers:
>    - Sebastian Reichel <sre@kernel.org>
> diff --git a/Documentation/devicetree/bindings/power/supply/ti,lp8727.yam=
l b/Documentation/devicetree/bindings/power/supply/ti,lp8727.yaml
> index 93654e732cda..ce6fbdba8f6b 100644
> --- a/Documentation/devicetree/bindings/power/supply/ti,lp8727.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/ti,lp8727.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/power/supply/ti,lp8727.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: Binding for TI/National Semiconductor LP8727 Charger
> +title: TI/National Semiconductor LP8727 Charger
> =20
>  maintainers:
>    - Sebastian Reichel <sre@kernel.org>

Acked-by: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--at2ocn3dkmbrzexs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmN/hrkACgkQ2O7X88g7
+poXLxAAo+A6KhvLNIyc9xLROpqlxyJWMCG/yc5TCq1ZV1KgtGo9x3TZ3o9jSbKp
oekN2QIztickZoLQSKjVm2iIp8twlpC2BQeOiMoqZGAsVzkC3Fht+HBjyK5PfyWL
BGctUAmwRbv16bKPVxPD9R3/Il3D4eTShapIzQ826hitd6/0nF5F1B+DDfs2LCIe
Nl+peFHpzF5xrOyXaY61rRnWzRoXpw9oXcVGWqzw8xqfXZUQ2Oi714/ftE3MXkZk
sKAPq+X6fo3+5lDQeP1TZCW7YeTnXImWP11UJEoJuIsrzoQxHAbrr/aamurwe7vS
CvH8FWs7Gb5FYu+kxis4aQxtKfGcMMS1KgJ50YVHeJdjKuKFP1L4QHOWwRhhOosR
X4TvrxYD0uFWa/utXiWoCT5OslqtqU17wys+S4zf8CLNwhOW1PLceLPH6Q/X3VkM
XPBzM+6B5ltN+WXIQ2QDD5pFRZmh+kv3H5Ueoid7S/u7PxYOV1byRJeLsA9cMfyB
th8k4KLJJQRuBgiOA6WwH9S0lac850zd5J9fkf+/J580liH9B/v+ukcIC8LpONts
oFwtQsBwgqGWUOmHPmBOdsouumwrbYddnzolFrf20kvZK36bUQBQekmGJt+NgJKo
wzC+XHhNGQc1pbe7IMj3hyGY1i5d8gB9KgBz4sCmiGwLr0Tvfww=
=l6tX
-----END PGP SIGNATURE-----

--at2ocn3dkmbrzexs--
