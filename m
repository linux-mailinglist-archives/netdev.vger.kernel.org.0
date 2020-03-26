Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3764C193F1A
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 13:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgCZMpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 08:45:20 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2608 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728134AbgCZMpU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 08:45:20 -0400
Received: from lhreml705-cah.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 0DAEA28515626089D084;
        Thu, 26 Mar 2020 12:45:18 +0000 (GMT)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml705-cah.china.huawei.com (10.201.108.46) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 26 Mar 2020 12:45:17 +0000
Received: from localhost (10.47.88.85) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 26 Mar
 2020 12:45:16 +0000
Date:   Thu, 26 Mar 2020 12:45:08 +0000
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Rob Herring <robh@kernel.org>
CC:     <devicetree@vger.kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        <linux-iio@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        "Masahiro Yamada" <yamada.masahiro@socionext.com>,
        Guillaume La Roque <glaroque@baylibre.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        "Lee Jones" <lee.jones@linaro.org>, <linux-clk@vger.kernel.org>,
        "Lars-Peter Clausen" <lars@metafoo.de>,
        Kevin Hilman <khilman@baylibre.com>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Brian Masney <masneyb@onstation.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        <linux-pm@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        <linux-gpio@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        <linux-amlogic@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@kernel.org>, <netdev@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "Hartmut Knaack" <knaack.h@gmx.de>, <linux-media@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH 3/4] dt-bindings: Clean-up schema errors due to missing
 'addtionalProperties: false'
Message-ID: <20200326124508.00003a52@Huawei.com>
In-Reply-To: <20200325220542.19189-4-robh@kernel.org>
References: <20200325220542.19189-1-robh@kernel.org>
        <20200325220542.19189-4-robh@kernel.org>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.88.85]
X-ClientProxiedBy: lhreml739-chm.china.huawei.com (10.201.108.189) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Mar 2020 16:05:40 -0600
Rob Herring <robh@kernel.org> wrote:

> Numerous schemas are missing 'additionalProperties: false' statements which
> ensures a binding doesn't have any extra undocumented properties or child
> nodes. Fixing this reveals various missing properties, so let's fix all
> those occurrences.
> 
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Hartmut Knaack <knaack.h@gmx.de>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Peter Meerwald-Stadler <pmeerw@pmeerw.net>
> Cc: Neil Armstrong <narmstrong@baylibre.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Kevin Hilman <khilman@baylibre.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Guillaume La Roque <glaroque@baylibre.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-clk@vger.kernel.org
> Cc: linux-gpio@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-iio@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: linux-amlogic@lists.infradead.org
> Cc: netdev@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> #for-iio

> ---
>  .../devicetree/bindings/clock/fsl,plldig.yaml |  3 +++
>  .../gpio/socionext,uniphier-gpio.yaml         |  2 ++
>  .../bindings/gpu/arm,mali-bifrost.yaml        |  6 ++---
>  .../bindings/gpu/arm,mali-midgard.yaml        |  3 +++
>  .../bindings/iio/adc/adi,ad7192.yaml          |  1 -
>  .../bindings/iio/pressure/bmp085.yaml         |  3 +++
>  .../media/amlogic,meson-gx-ao-cec.yaml        |  9 +++++---
>  .../bindings/mfd/rohm,bd71828-pmic.yaml       |  3 +++
>  .../bindings/net/ti,cpsw-switch.yaml          | 23 ++++++++++++-------
>  .../regulator/max77650-regulator.yaml         |  2 +-
>  .../bindings/thermal/amlogic,thermal.yaml     |  2 ++
>  .../bindings/timer/arm,arch_timer_mmio.yaml   |  2 ++
>  12 files changed, 43 insertions(+), 16 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/clock/fsl,plldig.yaml b/Documentation/devicetree/bindings/clock/fsl,plldig.yaml
> index c8350030b374..d1c040228cf7 100644
> --- a/Documentation/devicetree/bindings/clock/fsl,plldig.yaml
> +++ b/Documentation/devicetree/bindings/clock/fsl,plldig.yaml
> @@ -21,6 +21,9 @@ properties:
>    reg:
>      maxItems: 1
>  
> +  clocks:
> +    maxItems: 1
> +
>    '#clock-cells':
>      const: 0
>  
> diff --git a/Documentation/devicetree/bindings/gpio/socionext,uniphier-gpio.yaml b/Documentation/devicetree/bindings/gpio/socionext,uniphier-gpio.yaml
> index 580a39e09d39..c58ff9a94f45 100644
> --- a/Documentation/devicetree/bindings/gpio/socionext,uniphier-gpio.yaml
> +++ b/Documentation/devicetree/bindings/gpio/socionext,uniphier-gpio.yaml
> @@ -41,6 +41,8 @@ properties:
>      minimum: 0
>      maximum: 512
>  
> +  gpio-ranges: true
> +
>    gpio-ranges-group-names:
>      $ref: /schemas/types.yaml#/definitions/string-array
>  
> diff --git a/Documentation/devicetree/bindings/gpu/arm,mali-bifrost.yaml b/Documentation/devicetree/bindings/gpu/arm,mali-bifrost.yaml
> index e8b99adcb1bd..05fd9a404ff7 100644
> --- a/Documentation/devicetree/bindings/gpu/arm,mali-bifrost.yaml
> +++ b/Documentation/devicetree/bindings/gpu/arm,mali-bifrost.yaml
> @@ -43,6 +43,9 @@ properties:
>  
>    operating-points-v2: true
>  
> +  resets:
> +    maxItems: 2
> +
>  required:
>    - compatible
>    - reg
> @@ -57,9 +60,6 @@ allOf:
>            contains:
>              const: amlogic,meson-g12a-mali
>      then:
> -      properties:
> -        resets:
> -          minItems: 2
>        required:
>          - resets
>  
> diff --git a/Documentation/devicetree/bindings/gpu/arm,mali-midgard.yaml b/Documentation/devicetree/bindings/gpu/arm,mali-midgard.yaml
> index 8d966f3ff3db..6819cde050df 100644
> --- a/Documentation/devicetree/bindings/gpu/arm,mali-midgard.yaml
> +++ b/Documentation/devicetree/bindings/gpu/arm,mali-midgard.yaml
> @@ -75,6 +75,9 @@ properties:
>  
>    mali-supply: true
>  
> +  power-domains:
> +    maxItems: 1
> +
>    resets:
>      minItems: 1
>      maxItems: 2
> diff --git a/Documentation/devicetree/bindings/iio/adc/adi,ad7192.yaml b/Documentation/devicetree/bindings/iio/adc/adi,ad7192.yaml
> index 84d25bd39488..d0913034b1d8 100644
> --- a/Documentation/devicetree/bindings/iio/adc/adi,ad7192.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/adi,ad7192.yaml
> @@ -106,7 +106,6 @@ examples:
>          spi-cpha;
>          clocks = <&ad7192_mclk>;
>          clock-names = "mclk";
> -        #interrupt-cells = <2>;
>          interrupts = <25 0x2>;
>          interrupt-parent = <&gpio>;
>          dvdd-supply = <&dvdd>;
> diff --git a/Documentation/devicetree/bindings/iio/pressure/bmp085.yaml b/Documentation/devicetree/bindings/iio/pressure/bmp085.yaml
> index 519137e5c170..5d4aec0e0d24 100644
> --- a/Documentation/devicetree/bindings/iio/pressure/bmp085.yaml
> +++ b/Documentation/devicetree/bindings/iio/pressure/bmp085.yaml
> @@ -25,6 +25,9 @@ properties:
>        - bosch,bmp280
>        - bosch,bme280
>  
> +  reg:
> +    maxItems: 1
> +
>    vddd-supply:
>      description:
>        digital voltage regulator (see regulator/regulator.txt)
> diff --git a/Documentation/devicetree/bindings/media/amlogic,meson-gx-ao-cec.yaml b/Documentation/devicetree/bindings/media/amlogic,meson-gx-ao-cec.yaml
> index 41197578f19a..e8ce37fcbfec 100644
> --- a/Documentation/devicetree/bindings/media/amlogic,meson-gx-ao-cec.yaml
> +++ b/Documentation/devicetree/bindings/media/amlogic,meson-gx-ao-cec.yaml
> @@ -24,6 +24,12 @@ properties:
>    reg:
>      maxItems: 1
>  
> +  clocks:
> +    maxItems: 1
> +
> +  clock-names:
> +    maxItems: 1
> +
>    interrupts:
>      maxItems: 1
>  
> @@ -47,7 +53,6 @@ allOf:
>              - description: AO-CEC clock
>  
>          clock-names:
> -          maxItems: 1
>            items:
>              - const: core
>  
> @@ -66,7 +71,6 @@ allOf:
>              - description: AO-CEC clock generator source
>  
>          clock-names:
> -          maxItems: 1
>            items:
>              - const: oscin
>  
> @@ -88,4 +92,3 @@ examples:
>          clock-names = "core";
>          hdmi-phandle = <&hdmi_tx>;
>      };
> -
> diff --git a/Documentation/devicetree/bindings/mfd/rohm,bd71828-pmic.yaml b/Documentation/devicetree/bindings/mfd/rohm,bd71828-pmic.yaml
> index 4fbb9e734284..38dc4f8b0ceb 100644
> --- a/Documentation/devicetree/bindings/mfd/rohm,bd71828-pmic.yaml
> +++ b/Documentation/devicetree/bindings/mfd/rohm,bd71828-pmic.yaml
> @@ -41,6 +41,9 @@ properties:
>    "#clock-cells":
>      const: 0
>  
> +  clock-output-names:
> +    const: bd71828-32k-out
> +
>    rohm,charger-sense-resistor-ohms:
>      minimum: 10000000
>      maximum: 50000000
> diff --git a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
> index ac8c76369a86..b9e9696da5be 100644
> --- a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
> @@ -37,6 +37,12 @@ properties:
>      description:
>         The physical base address and size of full the CPSW module IO range
>  
> +  '#address-cells':
> +    const: 1
> +
> +  '#size-cells':
> +    const: 1
> +
>    ranges: true
>  
>    clocks:
> @@ -111,13 +117,6 @@ properties:
>              - reg
>              - phys
>  
> -  mdio:
> -    type: object
> -    allOf:
> -      - $ref: "ti,davinci-mdio.yaml#"
> -    description:
> -      CPSW MDIO bus.
> -
>    cpts:
>      type: object
>      description:
> @@ -148,6 +147,15 @@ properties:
>        - clocks
>        - clock-names
>  
> +patternProperties:
> +  "^mdio@":
> +    type: object
> +    allOf:
> +      - $ref: "ti,davinci-mdio.yaml#"
> +    description:
> +      CPSW MDIO bus.
> +
> +
>  required:
>    - compatible
>    - reg
> @@ -174,7 +182,6 @@ examples:
>          #address-cells = <1>;
>          #size-cells = <1>;
>          syscon = <&scm_conf>;
> -        inctrl-names = "default", "sleep";
>  
>          interrupts = <GIC_SPI 334 IRQ_TYPE_LEVEL_HIGH>,
>                       <GIC_SPI 335 IRQ_TYPE_LEVEL_HIGH>,
> diff --git a/Documentation/devicetree/bindings/regulator/max77650-regulator.yaml b/Documentation/devicetree/bindings/regulator/max77650-regulator.yaml
> index 7d724159f890..50690487edc8 100644
> --- a/Documentation/devicetree/bindings/regulator/max77650-regulator.yaml
> +++ b/Documentation/devicetree/bindings/regulator/max77650-regulator.yaml
> @@ -24,7 +24,7 @@ properties:
>      const: maxim,max77650-regulator
>  
>  patternProperties:
> -  "^regulator@[0-3]$":
> +  "^regulator-(ldo|sbb[0-2])$":
>      $ref: "regulator.yaml#"
>  
>  required:
> diff --git a/Documentation/devicetree/bindings/thermal/amlogic,thermal.yaml b/Documentation/devicetree/bindings/thermal/amlogic,thermal.yaml
> index f761681e4c0d..93fe7b10a82e 100644
> --- a/Documentation/devicetree/bindings/thermal/amlogic,thermal.yaml
> +++ b/Documentation/devicetree/bindings/thermal/amlogic,thermal.yaml
> @@ -32,6 +32,8 @@ properties:
>      description: phandle to the ao-secure syscon
>      $ref: '/schemas/types.yaml#/definitions/phandle'
>  
> +  '#thermal-sensor-cells':
> +    const: 0
>  
>  required:
>    - compatible
> diff --git a/Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.yaml b/Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.yaml
> index 102f319833d9..f7ef6646bade 100644
> --- a/Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.yaml
> +++ b/Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.yaml
> @@ -32,6 +32,8 @@ properties:
>    '#size-cells':
>      const: 1
>  
> +  ranges: true
> +
>    clock-frequency:
>      description: The frequency of the main counter, in Hz. Should be present
>        only where necessary to work around broken firmware which does not configure


