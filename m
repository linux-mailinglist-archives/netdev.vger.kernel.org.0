Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5151AF20D
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 18:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgDRQDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 12:03:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726471AbgDRQDn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 12:03:43 -0400
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 265E021D93;
        Sat, 18 Apr 2020 16:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587225820;
        bh=1De5fPfA8NlpQyTocewa07h9s/10o7DRNH2qDVFvqA8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hCjq0MAZUj3JKbCWIjnXWIz9oU3vpGOMvk/gvn814KBjM6utN9lAFJL+B2m6MmgOb
         k0FKGfq6P773PBXkOofNwvIhcReneAEe9NcOSIdyxXFv35zQTjjLRM7pO4ATd9ITv9
         kAdnoppSvnbrv7agegq0zfHzkamIw7ZjHlwMbaT8=
Date:   Sat, 18 Apr 2020 17:03:30 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, Vinod Koul <vkoul@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-i2c@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: Remove cases of 'allOf' containing a
 '$ref'
Message-ID: <20200418170330.65bff80c@archlinux>
In-Reply-To: <20200416005549.9683-2-robh@kernel.org>
References: <20200416005549.9683-1-robh@kernel.org>
        <20200416005549.9683-2-robh@kernel.org>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Apr 2020 19:55:49 -0500
Rob Herring <robh@kernel.org> wrote:

> json-schema versions draft7 and earlier have a weird behavior in that
> any keywords combined with a '$ref' are ignored (silently). The correct
> form was to put a '$ref' under an 'allOf'. This behavior is now changed
> in the 2019-09 json-schema spec and '$ref' can be mixed with other
> keywords. The json-schema library doesn't yet support this, but the
> tooling now does a fixup for this and either way works.
>=20
> This has been a constant source of review comments, so let's change this
> treewide so everyone copies the simpler syntax.
>=20
> Signed-off-by: Rob Herring <robh@kernel.org>

A few unrelated white space changes in enums in the IIO chunks.

Don't suppose they matter but maybe need the description to mention there
may be some minor formatting changes as well in some cases.

Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> #for-iio

> ---
>  .../devicetree/bindings/arm/cpus.yaml         |  81 +++---
>  .../devicetree/bindings/arm/l2c2x0.yaml       |  87 +++---
>  .../devicetree/bindings/arm/psci.yaml         |  15 +-
>  .../bindings/arm/samsung/exynos-chipid.yaml   |   5 +-
>  .../bus/allwinner,sun50i-a64-de2.yaml         |   5 +-
>  .../bindings/clock/fixed-factor-clock.yaml    |   5 +-
>  .../bindings/connector/usb-connector.yaml     |  28 +-
>  .../bindings/crypto/st,stm32-hash.yaml        |   9 +-
>  .../allwinner,sun4i-a10-display-engine.yaml   |   7 +-
>  .../display/allwinner,sun4i-a10-tcon.yaml     |   5 +-
>  .../bindings/display/panel/panel-common.yaml  |   5 +-
>  .../devicetree/bindings/dma/dma-common.yaml   |   3 +-
>  .../devicetree/bindings/dma/ti/k3-udma.yaml   |  18 +-
>  .../devicetree/bindings/eeprom/at24.yaml      |  11 +-
>  .../devicetree/bindings/example-schema.yaml   |  17 +-
>  .../bindings/hwmon/adi,ltc2947.yaml           |  32 +--
>  .../devicetree/bindings/hwmon/ti,tmp513.yaml  |  21 +-
>  .../devicetree/bindings/i2c/st,stm32-i2c.yaml |   9 +-
>  .../bindings/iio/adc/adi,ad7124.yaml          |   5 +-
>  .../bindings/iio/adc/lltc,ltc2496.yaml        |   3 +-
>  .../bindings/iio/adc/microchip,mcp3911.yaml   |   7 +-
>  .../bindings/iio/adc/st,stm32-dfsdm-adc.yaml  |  31 +-
>  .../bindings/iio/light/tsl2772.yaml           |  13 +-
>  .../bindings/iio/temperature/adi,ltc2983.yaml |  56 ++--

...

> diff --git a/Documentation/devicetree/bindings/iio/adc/adi,ad7124.yaml b/=
Documentation/devicetree/bindings/iio/adc/adi,ad7124.yaml
> index 97087a45ce54..deb34deff0e8 100644
> --- a/Documentation/devicetree/bindings/iio/adc/adi,ad7124.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/adi,ad7124.yaml
> @@ -83,9 +83,8 @@ patternProperties:
>            1: REFIN2(+)/REFIN2(=E2=88=92).
>            3: AVDD
>            If this field is left empty, internal reference is selected.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> -          - enum: [0, 1, 3]
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        enum: [0, 1, 3]
>=20
>        diff-channels:
>          description: see Documentation/devicetree/bindings/iio/adc/adc.t=
xt
> diff --git a/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.yaml =
b/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.yaml
> index 97f521d654ea..6a991e9f78e2 100644
> --- a/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.yaml
> @@ -18,8 +18,7 @@ properties:
>=20
>    vref-supply:
>      description: phandle to an external regulator providing the referenc=
e voltage
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/phandle
> +    $ref: /schemas/types.yaml#/definitions/phandle
>=20
>    reg:
>      description: spi chipselect number according to the usual spi bindin=
gs
> diff --git a/Documentation/devicetree/bindings/iio/adc/microchip,mcp3911.=
yaml b/Documentation/devicetree/bindings/iio/adc/microchip,mcp3911.yaml
> index 8ffeceb6abae..95ab285f4eba 100644
> --- a/Documentation/devicetree/bindings/iio/adc/microchip,mcp3911.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/microchip,mcp3911.yaml
> @@ -38,10 +38,9 @@ properties:
>=20
>    microchip,device-addr:
>      description: Device address when multiple MCP3911 chips are present =
on the same SPI bus.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [0, 1, 2, 3]
> -      - default: 0
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1, 2, 3]
> +    default: 0
>=20
>    vref-supply:
>      description: |
> diff --git a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc=
.yaml b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
> index b1627441a0b2..d69ca492d020 100644
> --- a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
> @@ -95,16 +95,14 @@ patternProperties:
>            On stm32h7 and stm32mp1:
>            - For st,stm32-dfsdm-adc: up to 8 channels numbered from 0 to =
7.
>            - For st,stm32-dfsdm-dmic: 1 channel numbered from 0 to 7.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32-array
> -          - items:
> -              minimum: 0
> -              maximum: 7
> +        $ref: /schemas/types.yaml#/definitions/uint32-array
> +        items:
> +          minimum: 0
> +          maximum: 7
>=20
>        st,adc-channel-names:
>          description: List of single-ended channel names.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/string-array
> +        $ref: /schemas/types.yaml#/definitions/string-array
>=20
>        st,filter-order:
>          description: |
> @@ -112,11 +110,10 @@ patternProperties:
>            - 0: FastSinC
>            - [1-5]: order 1 to 5.
>            For audio purpose it is recommended to use order 3 to 5.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> -          - items:
> -              minimum: 0
> -              maximum: 5
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        items:
> +          minimum: 0
> +          maximum: 5
>=20
>        "#io-channel-cells":
>          const: 1
> @@ -129,9 +126,8 @@ patternProperties:
>            - "MANCH_R": manchester codec, rising edge =3D logic 0, fallin=
g edge =3D logic 1
>            - "MANCH_F": manchester codec, rising edge =3D logic 1, fallin=
g edge =3D logic 0
>          items:
> -          enum: [ SPI_R, SPI_F, MANCH_R, MANCH_F ]
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/non-unique-string-arr=
ay
> +          enum: [SPI_R, SPI_F, MANCH_R, MANCH_F]

I don't suppose it matters much but unrelated change.

> +        $ref: /schemas/types.yaml#/definitions/non-unique-string-array
>=20
>        st,adc-channel-clk-src:
>          description: |
> @@ -141,9 +137,8 @@ patternProperties:
>            - "CLKOUT_F": internal SPI clock divided by 2 (falling edge).
>            - "CLKOUT_R": internal SPI clock divided by 2 (rising edge).
>          items:
> -          enum: [ CLKIN, CLKOUT, CLKOUT_F, CLKOUT_R ]

Unrelated change.

> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/non-unique-string-arr=
ay
> +          enum: [CLKIN, CLKOUT, CLKOUT_F, CLKOUT_R]
> +        $ref: /schemas/types.yaml#/definitions/non-unique-string-array
>=20
>        st,adc-alt-channel:
>          description:
> diff --git a/Documentation/devicetree/bindings/iio/light/tsl2772.yaml b/D=
ocumentation/devicetree/bindings/iio/light/tsl2772.yaml
> index e8f7d1ada57b..d81229857944 100644
> --- a/Documentation/devicetree/bindings/iio/light/tsl2772.yaml
> +++ b/Documentation/devicetree/bindings/iio/light/tsl2772.yaml
> @@ -33,13 +33,12 @@ properties:
>=20
>    amstaos,proximity-diodes:
>      description: Proximity diodes to enable
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
> -      - minItems: 1
> -        maxItems: 2
> -        items:
> -          minimum: 0
> -          maximum: 1
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    minItems: 1
> +    maxItems: 2
> +    items:
> +      minimum: 0
> +      maximum: 1
>=20
>    interrupts:
>      maxItems: 1
> diff --git a/Documentation/devicetree/bindings/iio/temperature/adi,ltc298=
3.yaml b/Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.yaml
> index 8fb46de6641d..9480ede59c37 100644
> --- a/Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.yaml
> +++ b/Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.yaml
> @@ -42,10 +42,9 @@ properties:
>        0 - 50/60Hz rejection
>        1 - 60Hz rejection
>        2 - 50Hz rejection
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - minimum: 0
> -        maximum: 2
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    minimum: 0
> +    maximum: 2
>=20
>    '#address-cells':
>      const: 1
> @@ -91,8 +90,7 @@ patternProperties:
>            7 - Type T Thermocouple
>            8 - Type B Thermocouple
>            9 - Custom Thermocouple
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> +        $ref: /schemas/types.yaml#/definitions/uint32
>          minimum: 1
>          maximum: 9
>=20
> @@ -121,8 +119,7 @@ patternProperties:
>            more details look at table 69 and 70.
>            Note should be signed, but dtc doesn't currently maintain the
>            sign.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint64-matrix
> +        $ref: /schemas/types.yaml#/definitions/uint64-matrix
>          minItems: 3
>          maxItems: 64
>          items:
> @@ -138,8 +135,7 @@ patternProperties:
>      properties:
>        adi,sensor-type:
>          description: Identifies the sensor as a diode.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> +        $ref: /schemas/types.yaml#/definitions/uint32
>          const: 28
>=20
>        adi,single-ended:
> @@ -196,8 +192,7 @@ patternProperties:
>            16 - RTD PT-1000 (0.00375)
>            17 - RTD NI-120
>            18 - RTD Custom
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> +        $ref: /schemas/types.yaml#/definitions/uint32
>          minimum: 10
>          maximum: 18
>=20
> @@ -210,9 +205,8 @@ patternProperties:
>          description:
>            Identifies the number of wires used by the RTD. Setting this
>            property to 5 means 4 wires with Kelvin Rsense.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> -          - enum: [2, 3, 4, 5]
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        enum: [2, 3, 4, 5]
>=20
>        adi,rsense-share:
>          description:
> @@ -237,18 +231,16 @@ patternProperties:
>          description:
>            This property set the RTD curve used and the corresponding
>            Callendar-VanDusen constants. Look at table 30 of the datashee=
t.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> -          - minimum: 0
> -            maximum: 3
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        minimum: 0
> +        maximum: 3
>=20
>        adi,custom-rtd:
>          description:
>            This is a table, where each entry should be a pair of
>            resistance(ohm)-temperature(K). The entries added here are in =
uohm
>            and uK. For more details values look at table 74 and 75.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint64-matrix
> +        $ref: /schemas/types.yaml#/definitions/uint64-matrix
>          items:
>            minItems: 3
>            maxItems: 64
> @@ -280,8 +272,7 @@ patternProperties:
>            25 - Thermistor Spectrum 1003k 1kohm
>            26 - Thermistor Custom Steinhart-Hart
>            27 - Custom Thermistor
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> +        $ref: /schemas/types.yaml#/definitions/uint32
>          minimum: 19
>          maximum: 27
>=20
> @@ -314,10 +305,9 @@ patternProperties:
>            This property controls the magnitude of the excitation current
>            applied to the thermistor. Value 0 set's the sensor in auto-ra=
nge
>            mode.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> -          - enum: [0, 250, 500, 1000, 5000, 10000, 25000, 50000, 100000,
> -                   250000, 500000, 1000000]
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        enum: [0, 250, 500, 1000, 5000, 10000, 25000, 50000, 100000, 250=
000,
> +          500000, 1000000]
>=20
>        adi,custom-thermistor:
>          description:
> @@ -325,8 +315,7 @@ patternProperties:
>            resistance(ohm)-temperature(K). The entries added here are in =
uohm
>            and uK only for custom thermistors. For more details look at t=
able
>            78 and 79.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint64-matrix
> +        $ref: /schemas/types.yaml#/definitions/uint64-matrix
>          minItems: 3
>          maxItems: 64
>          items:
> @@ -339,8 +328,7 @@ patternProperties:
>            be programmed into the device memory using this property. For
>            Steinhart sensors the coefficients are given in the raw
>            format. Look at table 82 for more information.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32-array
> +        $ref: /schemas/types.yaml#/definitions/uint32-array
>          items:
>            minItems: 6
>            maxItems: 6
> @@ -358,8 +346,7 @@ patternProperties:
>      properties:
>        adi,sensor-type:
>          description: Identifies the sensor as a direct adc.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> +        $ref: /schemas/types.yaml#/definitions/uint32
>          const: 30
>=20
>        adi,single-ended:
> @@ -379,8 +366,7 @@ patternProperties:
>=20
>        adi,sensor-type:
>          description: Identifies the sensor as a rsense.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> +        $ref: /schemas/types.yaml#/definitions/uint32
>          const: 29
>=20
>        adi,rsense-val-milli-ohms:
> diff --git a/Documentation/devicetree/bindings/input/allwinner,sun4i-a10-=
lradc-keys.yaml b/Documentation/devicetree/bindings/input/allwinner,sun4i-a=
10-lradc-keys.yaml
> index 512a6af5aa42..cffd02028d02 100644
> --- a/Documentation/devicetree/bindings/input/allwinner,sun4i-a10-lradc-k=
eys.yaml
> +++ b/Documentation/devicetree/bindings/input/allwinner,sun4i-a10-lradc-k=
eys.yaml
> @@ -42,9 +42,8 @@ patternProperties:
>          description: Keycode to emit
>=20
>        channel:
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> -          - enum: [0, 1]
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        enum: [0, 1]
>          description: ADC Channel this key is attached to
>=20
>        voltage:
> diff --git a/Documentation/devicetree/bindings/input/input.yaml b/Documen=
tation/devicetree/bindings/input/input.yaml
> index 6d519046b3af..8edcb3c31270 100644
> --- a/Documentation/devicetree/bindings/input/input.yaml
> +++ b/Documentation/devicetree/bindings/input/input.yaml
> @@ -18,11 +18,10 @@ properties:
>      description:
>        Specifies an array of numeric keycode values to be used for report=
ing
>        button presses.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
> -      - items:
> -          minimum: 0
> -          maximum: 0xff
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    items:
> +      minimum: 0
> +      maximum: 0xff
>=20
>    poll-interval:
>      description: Poll interval time in milliseconds.
...
