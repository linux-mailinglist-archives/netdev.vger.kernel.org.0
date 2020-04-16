Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6EA31ABFBB
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 13:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633955AbgDPLiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 07:38:52 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:59097 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2506487AbgDPLiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 07:38:16 -0400
Received: from localhost (lfbn-lyo-1-9-35.w86-202.abo.wanadoo.fr [86.202.105.35])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 004C1200011;
        Thu, 16 Apr 2020 11:37:45 +0000 (UTC)
Date:   Thu, 16 Apr 2020 13:37:45 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
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
        Jonathan Cameron <jic23@kernel.org>,
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
Message-ID: <20200416113745.GS34509@piout.net>
References: <20200416005549.9683-1-robh@kernel.org>
 <20200416005549.9683-2-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200416005549.9683-2-robh@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/04/2020 19:55:49-0500, Rob Herring wrote:
> json-schema versions draft7 and earlier have a weird behavior in that
> any keywords combined with a '$ref' are ignored (silently). The correct
> form was to put a '$ref' under an 'allOf'. This behavior is now changed
> in the 2019-09 json-schema spec and '$ref' can be mixed with other
> keywords. The json-schema library doesn't yet support this, but the
> tooling now does a fixup for this and either way works.
> 
> This has been a constant source of review comments, so let's change this
> treewide so everyone copies the simpler syntax.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>

Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

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
>  .../input/allwinner,sun4i-a10-lradc-keys.yaml |   5 +-
>  .../devicetree/bindings/input/input.yaml      |   9 +-
>  .../interrupt-controller/arm,gic-v3.yaml      |  39 ++-
>  .../devicetree/bindings/iommu/arm,smmu.yaml   |   3 +-
>  .../devicetree/bindings/leds/common.yaml      |  13 +-
>  .../devicetree/bindings/leds/leds-gpio.yaml   |   3 +-
>  .../bindings/leds/rohm,bd71828-leds.yaml      |  10 +-
>  .../bindings/mailbox/st,stm32-ipcc.yaml       |   5 +-
>  .../bindings/media/amlogic,gx-vdec.yaml       |   6 +-
>  .../media/amlogic,meson-gx-ao-cec.yaml        |   3 +-
>  .../devicetree/bindings/media/rc.yaml         | 265 +++++++++---------
>  .../bindings/media/renesas,vin.yaml           |   7 +-
>  .../memory-controllers/exynos-srom.yaml       |  14 +-
>  .../nvidia,tegra124-emc.yaml                  |   9 +-
>  .../nvidia,tegra124-mc.yaml                   |   3 +-
>  .../nvidia,tegra30-emc.yaml                   |   9 +-
>  .../memory-controllers/nvidia,tegra30-mc.yaml |   3 +-
>  .../bindings/mfd/allwinner,sun4i-a10-ts.yaml  |  20 +-
>  .../bindings/mfd/st,stm32-timers.yaml         |  33 ++-
>  .../devicetree/bindings/mfd/st,stpmic1.yaml   |   9 +-
>  .../devicetree/bindings/mfd/syscon.yaml       |   5 +-
>  .../devicetree/bindings/mmc/aspeed,sdhci.yaml |   4 +-
>  .../devicetree/bindings/mmc/cdns,sdhci.yaml   |  77 +++--
>  .../bindings/mmc/mmc-controller.yaml          |  37 ++-
>  .../bindings/mmc/rockchip-dw-mshc.yaml        |   6 +-
>  .../bindings/mmc/synopsys-dw-mshc-common.yaml |  14 +-
>  .../mtd/allwinner,sun4i-a10-nand.yaml         |  13 +-
>  .../bindings/mtd/nand-controller.yaml         |  27 +-
>  .../bindings/net/can/bosch,m_can.yaml         |  59 ++--
>  .../bindings/net/ethernet-controller.yaml     |  34 +--
>  .../devicetree/bindings/net/qca,ar803x.yaml   |  17 +-
>  .../devicetree/bindings/net/snps,dwmac.yaml   |  22 +-
>  .../bindings/net/ti,cpsw-switch.yaml          |   3 +-
>  .../bindings/net/ti,davinci-mdio.yaml         |   7 +-
>  .../bindings/pci/intel-gw-pcie.yaml           |   7 +-
>  .../pinctrl/allwinner,sun4i-a10-pinctrl.yaml  |  12 +-
>  .../pinctrl/aspeed,ast2400-pinctrl.yaml       |  37 ++-
>  .../pinctrl/aspeed,ast2500-pinctrl.yaml       |  45 ++-
>  .../pinctrl/aspeed,ast2600-pinctrl.yaml       | 108 ++++---
>  .../bindings/pinctrl/fsl,imx8mp-pinctrl.yaml  |  31 +-
>  .../bindings/pinctrl/intel,lgm-io.yaml        |   4 +-
>  .../bindings/pinctrl/pinmux-node.yaml         |   3 +-
>  .../bindings/pinctrl/st,stm32-pinctrl.yaml    |  56 ++--
>  .../bindings/power/amlogic,meson-ee-pwrc.yaml |   3 +-
>  .../devicetree/bindings/pwm/pwm-samsung.yaml  |  11 +-
>  .../bindings/regulator/gpio-regulator.yaml    |  35 ++-
>  .../bindings/regulator/mps,mpq7920.yaml       |  31 +-
>  .../bindings/regulator/regulator.yaml         |   5 +-
>  .../regulator/rohm,bd71828-regulator.yaml     |  34 +--
>  .../bindings/regulator/st,stm32-booster.yaml  |   3 +-
>  .../regulator/st,stm32mp1-pwr-reg.yaml        |   3 +-
>  .../bindings/remoteproc/st,stm32-rproc.yaml   |   9 +-
>  .../bindings/reset/intel,rcu-gw.yaml          |   3 +-
>  .../devicetree/bindings/riscv/cpus.yaml       |  20 +-
>  .../devicetree/bindings/rtc/st,stm32-rtc.yaml |   9 +-
>  .../devicetree/bindings/serial/pl011.yaml     |  10 +-
>  .../devicetree/bindings/serial/rs485.yaml     |  26 +-
>  .../bindings/serial/samsung_uart.yaml         |   5 +-
>  .../bindings/sound/adi,adau7118.yaml          |  20 +-
>  .../sound/allwinner,sun4i-a10-codec.yaml      |  41 ++-
>  .../bindings/sound/qcom,wcd934x.yaml          |   3 +-
>  .../bindings/spi/renesas,sh-msiof.yaml        |  42 ++-
>  .../bindings/spi/spi-controller.yaml          |  14 +-
>  .../devicetree/bindings/spi/spi-pl022.yaml    |  55 ++--
>  .../devicetree/bindings/spi/spi-sifive.yaml   |  14 +-
>  .../bindings/thermal/qcom-tsens.yaml          |   7 +-
>  .../bindings/timer/arm,arch_timer_mmio.yaml   |   7 +-
>  91 files changed, 881 insertions(+), 1103 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/cpus.yaml b/Documentation/devicetree/bindings/arm/cpus.yaml
> index a01814765ddb..3338bae4cee3 100644
> --- a/Documentation/devicetree/bindings/arm/cpus.yaml
> +++ b/Documentation/devicetree/bindings/arm/cpus.yaml
> @@ -171,49 +171,48 @@ properties:
>        - qcom,scorpion
> 
>    enable-method:
> -    allOf:
> -      - $ref: '/schemas/types.yaml#/definitions/string'
> -      - oneOf:
> +    $ref: '/schemas/types.yaml#/definitions/string'
> +    oneOf:
>            # On ARM v8 64-bit this property is required
> -          - enum:
> -              - psci
> -              - spin-table
> +      - enum:
> +          - psci
> +          - spin-table
>            # On ARM 32-bit systems this property is optional
> -          - enum:
> -              - actions,s500-smp
> -              - allwinner,sun6i-a31
> -              - allwinner,sun8i-a23
> -              - allwinner,sun9i-a80-smp
> -              - allwinner,sun8i-a83t-smp
> -              - amlogic,meson8-smp
> -              - amlogic,meson8b-smp
> -              - arm,realview-smp
> -              - aspeed,ast2600-smp
> -              - brcm,bcm11351-cpu-method
> -              - brcm,bcm23550
> -              - brcm,bcm2836-smp
> -              - brcm,bcm63138
> -              - brcm,bcm-nsp-smp
> -              - brcm,brahma-b15
> -              - marvell,armada-375-smp
> -              - marvell,armada-380-smp
> -              - marvell,armada-390-smp
> -              - marvell,armada-xp-smp
> -              - marvell,98dx3236-smp
> -              - marvell,mmp3-smp
> -              - mediatek,mt6589-smp
> -              - mediatek,mt81xx-tz-smp
> -              - qcom,gcc-msm8660
> -              - qcom,kpss-acc-v1
> -              - qcom,kpss-acc-v2
> -              - renesas,apmu
> -              - renesas,r9a06g032-smp
> -              - rockchip,rk3036-smp
> -              - rockchip,rk3066-smp
> -              - socionext,milbeaut-m10v-smp
> -              - ste,dbx500-smp
> -              - ti,am3352
> -              - ti,am4372
> +      - enum:
> +          - actions,s500-smp
> +          - allwinner,sun6i-a31
> +          - allwinner,sun8i-a23
> +          - allwinner,sun9i-a80-smp
> +          - allwinner,sun8i-a83t-smp
> +          - amlogic,meson8-smp
> +          - amlogic,meson8b-smp
> +          - arm,realview-smp
> +          - aspeed,ast2600-smp
> +          - brcm,bcm11351-cpu-method
> +          - brcm,bcm23550
> +          - brcm,bcm2836-smp
> +          - brcm,bcm63138
> +          - brcm,bcm-nsp-smp
> +          - brcm,brahma-b15
> +          - marvell,armada-375-smp
> +          - marvell,armada-380-smp
> +          - marvell,armada-390-smp
> +          - marvell,armada-xp-smp
> +          - marvell,98dx3236-smp
> +          - marvell,mmp3-smp
> +          - mediatek,mt6589-smp
> +          - mediatek,mt81xx-tz-smp
> +          - qcom,gcc-msm8660
> +          - qcom,kpss-acc-v1
> +          - qcom,kpss-acc-v2
> +          - renesas,apmu
> +          - renesas,r9a06g032-smp
> +          - rockchip,rk3036-smp
> +          - rockchip,rk3066-smp
> +          - socionext,milbeaut-m10v-smp
> +          - ste,dbx500-smp
> +          - ti,am3352
> +          - ti,am4372
> 
>    cpu-release-addr:
>      $ref: '/schemas/types.yaml#/definitions/uint64'
> diff --git a/Documentation/devicetree/bindings/arm/l2c2x0.yaml b/Documentation/devicetree/bindings/arm/l2c2x0.yaml
> index 5d1d50eea26e..6b8f4d4fa580 100644
> --- a/Documentation/devicetree/bindings/arm/l2c2x0.yaml
> +++ b/Documentation/devicetree/bindings/arm/l2c2x0.yaml
> @@ -70,43 +70,39 @@ properties:
>      description: Cycles of latency for Data RAM accesses. Specifies 3 cells of
>        read, write and setup latencies. Minimum valid values are 1. Controllers
>        without setup latency control should use a value of 0.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
> -      - minItems: 2
> -        maxItems: 3
> -        items:
> -          minimum: 0
> -          maximum: 8
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    minItems: 2
> +    maxItems: 3
> +    items:
> +      minimum: 0
> +      maximum: 8
> 
>    arm,tag-latency:
>      description: Cycles of latency for Tag RAM accesses. Specifies 3 cells of
>        read, write and setup latencies. Controllers without setup latency control
>        should use 0. Controllers without separate read and write Tag RAM latency
>        values should only use the first cell.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
> -      - minItems: 1
> -        maxItems: 3
> -        items:
> -          minimum: 0
> -          maximum: 8
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    minItems: 1
> +    maxItems: 3
> +    items:
> +      minimum: 0
> +      maximum: 8
> 
>    arm,dirty-latency:
>      description: Cycles of latency for Dirty RAMs. This is a single cell.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - minimum: 1
> -        maximum: 8
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    minimum: 1
> +    maximum: 8
> 
>    arm,filter-ranges:
>      description: <start length> Starting address and length of window to
>        filter. Addresses in the filter window are directed to the M1 port. Other
>        addresses will go to the M0 port.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
> -      - items:
> -          minItems: 2
> -          maxItems: 2
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    items:
> +      minItems: 2
> +      maxItems: 2
> 
>    arm,io-coherent:
>      description: indicates that the system is operating in an hardware
> @@ -131,36 +127,31 @@ properties:
>    arm,double-linefill:
>      description: Override double linefill enable setting. Enable if
>        non-zero, disable if zero.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [ 0, 1 ]
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1]
> 
>    arm,double-linefill-incr:
>      description: Override double linefill on INCR read. Enable
>        if non-zero, disable if zero.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [ 0, 1 ]
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1]
> 
>    arm,double-linefill-wrap:
>      description: Override double linefill on WRAP read. Enable
>        if non-zero, disable if zero.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [ 0, 1 ]
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1]
> 
>    arm,prefetch-drop:
>      description: Override prefetch drop enable setting. Enable if non-zero,
>        disable if zero.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [ 0, 1 ]
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1]
> 
>    arm,prefetch-offset:
>      description: Override prefetch offset value.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [ 0, 1, 2, 3, 4, 5, 6, 7, 15, 23, 31 ]
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1, 2, 3, 4, 5, 6, 7, 15, 23, 31]
> 
>    arm,shared-override:
>      description: The default behavior of the L220 or PL310 cache
> @@ -193,35 +184,31 @@ properties:
>      description: |
>        Data prefetch. Value: <0> (forcibly disable), <1>
>        (forcibly enable), property absent (retain settings set by firmware)
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [ 0, 1 ]
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1]
> 
>    prefetch-instr:
>      description: |
>        Instruction prefetch. Value: <0> (forcibly disable),
>        <1> (forcibly enable), property absent (retain settings set by
>        firmware)
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [ 0, 1 ]
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1]
> 
>    arm,dynamic-clock-gating:
>      description: |
>        L2 dynamic clock gating. Value: <0> (forcibly
>        disable), <1> (forcibly enable), property absent (OS specific behavior,
>        preferably retain firmware settings)
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [ 0, 1 ]
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1]
> 
>    arm,standby-mode:
>      description: L2 standby mode enable. Value <0> (forcibly disable),
>        <1> (forcibly enable), property absent (OS specific behavior,
>        preferably retain firmware settings)
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [ 0, 1 ]
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1]
> 
>    arm,early-bresp-disable:
>      description: Disable the CA9 optimization Early BRESP (PL310)
> diff --git a/Documentation/devicetree/bindings/arm/psci.yaml b/Documentation/devicetree/bindings/arm/psci.yaml
> index 9247b58c26fc..4f9b361aefd6 100644
> --- a/Documentation/devicetree/bindings/arm/psci.yaml
> +++ b/Documentation/devicetree/bindings/arm/psci.yaml
> @@ -69,13 +69,12 @@ properties:
> 
>    method:
>      description: The method of calling the PSCI firmware.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/string-array
> -      - enum:
> -          # SMC #0, with the register assignments specified in this binding.
> -          - smc
> +    $ref: /schemas/types.yaml#/definitions/string-array
> +    enum:
> +
> +      - smc
>            # HVC #0, with the register assignments specified in this binding.
> -          - hvc
> +      - hvc
> 
>    cpu_suspend:
>      $ref: /schemas/types.yaml#/definitions/uint32
> @@ -107,8 +106,8 @@ properties:
> 
>  patternProperties:
>    "^power-domain-":
> -    allOf:
> -      - $ref: "../power/power-domain.yaml#"
> +    $ref: "../power/power-domain.yaml#"
> +
>      type: object
>      description: |
>        ARM systems can have multiple cores, sometimes in an hierarchical
> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-chipid.yaml b/Documentation/devicetree/bindings/arm/samsung/exynos-chipid.yaml
> index 0425d333b50d..f99c0c6df21b 100644
> --- a/Documentation/devicetree/bindings/arm/samsung/exynos-chipid.yaml
> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos-chipid.yaml
> @@ -22,9 +22,8 @@ properties:
>        Adaptive Supply Voltage bin selection. This can be used
>        to determine the ASV bin of an SoC if respective information
>        is missing in the CHIPID registers or in the OTP memory.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [ 0, 1, 2, 3 ]
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1, 2, 3]
> 
>  required:
>    - compatible
> diff --git a/Documentation/devicetree/bindings/bus/allwinner,sun50i-a64-de2.yaml b/Documentation/devicetree/bindings/bus/allwinner,sun50i-a64-de2.yaml
> index f0b3d30fbb76..0503651cd214 100644
> --- a/Documentation/devicetree/bindings/bus/allwinner,sun50i-a64-de2.yaml
> +++ b/Documentation/devicetree/bindings/bus/allwinner,sun50i-a64-de2.yaml
> @@ -31,12 +31,11 @@ properties:
>      maxItems: 1
> 
>    allwinner,sram:
> -    allOf:
> -      - $ref: /schemas/types.yaml#definitions/phandle-array
> -      - maxItems: 1
>      description:
>        The SRAM that needs to be claimed to access the display engine
>        bus.
> +    $ref: /schemas/types.yaml#definitions/phandle-array
> +    maxItems: 1
> 
>    ranges: true
> 
> diff --git a/Documentation/devicetree/bindings/clock/fixed-factor-clock.yaml b/Documentation/devicetree/bindings/clock/fixed-factor-clock.yaml
> index b567f8092f8c..f415845b38dd 100644
> --- a/Documentation/devicetree/bindings/clock/fixed-factor-clock.yaml
> +++ b/Documentation/devicetree/bindings/clock/fixed-factor-clock.yaml
> @@ -24,9 +24,8 @@ properties:
> 
>    clock-div:
>      description: Fixed divider
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - minimum: 1
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    minimum: 1
> 
>    clock-mult:
>      description: Fixed multiplier
> diff --git a/Documentation/devicetree/bindings/connector/usb-connector.yaml b/Documentation/devicetree/bindings/connector/usb-connector.yaml
> index 369c58e22a06..03b92b6f35fa 100644
> --- a/Documentation/devicetree/bindings/connector/usb-connector.yaml
> +++ b/Documentation/devicetree/bindings/connector/usb-connector.yaml
> @@ -27,8 +27,8 @@ properties:
>      description: Size of the connector, should be specified in case of
>        non-fullsize 'usb-a-connector' or 'usb-b-connector' compatible
>        connectors.
> -    allOf:
> -      - $ref: /schemas/types.yaml#definitions/string
> +    $ref: /schemas/types.yaml#definitions/string
> +
>      enum:
>        - mini
>        - micro
> @@ -57,8 +57,8 @@ properties:
>    power-role:
>      description: Determines the power role that the Type C connector will
>        support. "dual" refers to Dual Role Port (DRP).
> -    allOf:
> -      - $ref: /schemas/types.yaml#definitions/string
> +    $ref: /schemas/types.yaml#definitions/string
> +
>      enum:
>        - source
>        - sink
> @@ -66,18 +66,18 @@ properties:
> 
>    try-power-role:
>      description: Preferred power role.
> -    allOf:
> -      - $ref: /schemas/types.yaml#definitions/string
> +    $ref: /schemas/types.yaml#definitions/string
> +
>      enum:
> -     - source
> -     - sink
> -     - dual
> +      - source
> +      - sink
> +      - dual
> 
>    data-role:
>      description: Data role if Type C connector supports USB data. "dual" refers
>        Dual Role Device (DRD).
> -    allOf:
> -      - $ref: /schemas/types.yaml#definitions/string
> +    $ref: /schemas/types.yaml#definitions/string
> +
>      enum:
>        - host
>        - device
> @@ -95,8 +95,7 @@ properties:
>        defined in dt-bindings/usb/pd.h.
>      minItems: 1
>      maxItems: 7
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> 
>    sink-pdos:
>      description: An array of u32 with each entry providing supported power sink
> @@ -108,8 +107,7 @@ properties:
>        in dt-bindings/usb/pd.h.
>      minItems: 1
>      maxItems: 7
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> 
>    op-sink-microwatt:
>      description: Sink required operating power in microwatt, if source can't
> diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml b/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
> index 57ae1c0b6d18..6dd658f0912c 100644
> --- a/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
> +++ b/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
> @@ -36,11 +36,10 @@ properties:
> 
>    dma-maxburst:
>      description: Set number of maximum dma burst supported
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - minimum: 0
> -      - maximum: 2
> -      - default: 0
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    minimum: 0
> +    maximum: 2
> +    default: 0
> 
>  required:
>    - compatible
> diff --git a/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-display-engine.yaml b/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-display-engine.yaml
> index 944ff2f1cf93..e77523b02fad 100644
> --- a/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-display-engine.yaml
> +++ b/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-display-engine.yaml
> @@ -66,10 +66,9 @@ properties:
>        - allwinner,sun50i-h6-display-engine
> 
>    allwinner,pipelines:
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/phandle-array
> -      - minItems: 1
> -        maxItems: 2
> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> +    minItems: 1
> +    maxItems: 2
>      description: |
>        Available display engine frontends (DE 1.0) or mixers (DE
>        2.0/3.0) available.
> diff --git a/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml b/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml
> index 87cb77b32ee3..4c15a2644a7c 100644
> --- a/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml
> +++ b/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml
> @@ -71,11 +71,10 @@ properties:
>      maxItems: 4
> 
>    clock-output-names:
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/string-array
> -      - maxItems: 1
>      description:
>        Name of the LCD pixel clock created.
> +    $ref: /schemas/types.yaml#/definitions/string-array
> +    maxItems: 1
> 
>    dmas:
>      maxItems: 1
> diff --git a/Documentation/devicetree/bindings/display/panel/panel-common.yaml b/Documentation/devicetree/bindings/display/panel/panel-common.yaml
> index ed051ba12084..b05573de08f3 100644
> --- a/Documentation/devicetree/bindings/display/panel/panel-common.yaml
> +++ b/Documentation/devicetree/bindings/display/panel/panel-common.yaml
> @@ -48,9 +48,8 @@ properties:
>    rotation:
>      description:
>        Display rotation in degrees counter clockwise (0,90,180,270)
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [ 0, 90, 180, 270 ]
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 90, 180, 270]
> 
>    # Display Timings
>    panel-timing:
> diff --git a/Documentation/devicetree/bindings/dma/dma-common.yaml b/Documentation/devicetree/bindings/dma/dma-common.yaml
> index 02a34ba2b49b..c36592683340 100644
> --- a/Documentation/devicetree/bindings/dma/dma-common.yaml
> +++ b/Documentation/devicetree/bindings/dma/dma-common.yaml
> @@ -31,8 +31,7 @@ properties:
>        kernel. i.e. first channel corresponds to LSB.
>        The first item in the array is for channels 0-31, the second is for
>        channels 32-63, etc.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>      items:
>        minItems: 1
>        # Should be enough
> diff --git a/Documentation/devicetree/bindings/dma/ti/k3-udma.yaml b/Documentation/devicetree/bindings/dma/ti/k3-udma.yaml
> index 85056982a242..10b74095935f 100644
> --- a/Documentation/devicetree/bindings/dma/ti/k3-udma.yaml
> +++ b/Documentation/devicetree/bindings/dma/ti/k3-udma.yaml
> @@ -78,25 +78,21 @@ properties:
> 
>    ti,sci:
>      description: phandle to TI-SCI compatible System controller node
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/phandle
> +    $ref: /schemas/types.yaml#/definitions/phandle
> 
>    ti,sci-dev-id:
>      description: TI-SCI device id of UDMAP
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> +    $ref: /schemas/types.yaml#/definitions/uint32
> 
>    ti,ringacc:
>      description: phandle to the ring accelerator node
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/phandle
> +    $ref: /schemas/types.yaml#/definitions/phandle
> 
>    ti,sci-rm-range-tchan:
>      description: |
>        Array of UDMA tchan resource subtypes for resource allocation for this
>        host
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>      minItems: 1
>      # Should be enough
>      maxItems: 255
> @@ -105,8 +101,7 @@ properties:
>      description: |
>        Array of UDMA rchan resource subtypes for resource allocation for this
>        host
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>      minItems: 1
>      # Should be enough
>      maxItems: 255
> @@ -115,8 +110,7 @@ properties:
>      description: |
>        Array of UDMA rflow resource subtypes for resource allocation for this
>        host
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>      minItems: 1
>      # Should be enough
>      maxItems: 255
> diff --git a/Documentation/devicetree/bindings/eeprom/at24.yaml b/Documentation/devicetree/bindings/eeprom/at24.yaml
> index a15787e504f0..de513fe333a7 100644
> --- a/Documentation/devicetree/bindings/eeprom/at24.yaml
> +++ b/Documentation/devicetree/bindings/eeprom/at24.yaml
> @@ -118,14 +118,13 @@ properties:
>      maxItems: 1
> 
>    pagesize:
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
>      description:
>        The length of the pagesize for writing. Please consult the
>        manual of your device, that value varies a lot. A wrong value
>        may result in data loss! If not specified, a safety value of
>        '1' is used which will be very slow.
> -    enum: [ 1, 8, 16, 32, 64, 128, 258 ]
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [1, 8, 16, 32, 64, 128, 258]
>      default: 1
> 
>    read-only:
> @@ -148,18 +147,16 @@ properties:
>    wp-gpios: true
> 
>    address-width:
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
>      description:
>        Number of address bits.
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      default: 8
>      enum: [ 8, 16 ]
> 
>    num-addresses:
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
>      description:
>        Total number of i2c slave addresses this device takes.
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      default: 1
>      minimum: 1
>      maximum: 8
> diff --git a/Documentation/devicetree/bindings/example-schema.yaml b/Documentation/devicetree/bindings/example-schema.yaml
> index 62811a1b5058..c9534d2164a2 100644
> --- a/Documentation/devicetree/bindings/example-schema.yaml
> +++ b/Documentation/devicetree/bindings/example-schema.yaml
> @@ -138,12 +138,8 @@ properties:
>    # 'description'.
>    vendor,int-property:
>      description: Vendor specific properties must have a description
> -    # 'allOf' is the json-schema way of subclassing a schema. Here the base
> -    # type schema is referenced and then additional constraints on the values
> -    # are added.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [2, 4, 6, 8, 10]
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [2, 4, 6, 8, 10]
> 
>    vendor,bool-property:
>      description: Vendor specific properties must have a description. Boolean
> @@ -154,11 +150,10 @@ properties:
>    vendor,string-array-property:
>      description: Vendor specific properties should reference a type in the
>        core schema.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/string-array
> -      - items:
> -          - enum: [ foo, bar ]
> -          - enum: [ baz, boo ]
> +    $ref: /schemas/types.yaml#/definitions/string-array
> +    items:
> +      - enum: [foo, bar]
> +      - enum: [baz, boo]
> 
>    vendor,property-in-standard-units-microvolt:
>      description: Vendor specific properties having a standard unit suffix
> diff --git a/Documentation/devicetree/bindings/hwmon/adi,ltc2947.yaml b/Documentation/devicetree/bindings/hwmon/adi,ltc2947.yaml
> index 44a63fffb4be..eef614962b10 100644
> --- a/Documentation/devicetree/bindings/hwmon/adi,ltc2947.yaml
> +++ b/Documentation/devicetree/bindings/hwmon/adi,ltc2947.yaml
> @@ -38,20 +38,18 @@ properties:
>        the accumulated values, this entry can also have two items which sets
>        energy1/charge1 and energy2/charger2 respectively. Check table 12 of the
>        datasheet for more information on the supported options.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
> -      - minItems: 2
> -        maxItems: 2
> -        items:
> -          enum: [0, 1, 2, 3]
> -          default: 0
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    minItems: 2
> +    maxItems: 2
> +    items:
> +      enum: [0, 1, 2, 3]
> +      default: 0
> 
>    adi,accumulation-deadband-microamp:
>      description:
>        This property controls the Accumulation Dead band which allows to set the
>        level of current below which no accumulation takes place.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      maximum: 255
>      default: 0
> 
> @@ -61,8 +59,7 @@ properties:
>        active high, setting it to zero makets it active low. When this property
>        is present, the GPIO is automatically configured as output and set to
>        control a fan as a function of measured temperature.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      enum: [0, 1]
>      default: 0
> 
> @@ -74,13 +71,12 @@ properties:
>        registers. Check table 13 of the datasheet for more information on the
>        supported options. This property cannot be used together with
>        adi,gpio-out-pol.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
> -      - minItems: 2
> -        maxItems: 2
> -        items:
> -          enum: [0, 1, 2]
> -          default: 0
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    minItems: 2
> +    maxItems: 2
> +    items:
> +      enum: [0, 1, 2]
> +      default: 0
> 
>  required:
>    - compatible
> diff --git a/Documentation/devicetree/bindings/hwmon/ti,tmp513.yaml b/Documentation/devicetree/bindings/hwmon/ti,tmp513.yaml
> index 3f043e943668..90b2fa3f7752 100644
> --- a/Documentation/devicetree/bindings/hwmon/ti,tmp513.yaml
> +++ b/Documentation/devicetree/bindings/hwmon/ti,tmp513.yaml
> @@ -45,16 +45,14 @@ properties:
>        The gain value for the PGA function. This is 8, 4, 2 or 1.
>        The PGA gain affect the shunt voltage range.
>        The range will be equal to: pga-gain * 40mV
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      enum: [1, 2, 4, 8]
>      default: 8
> 
>    ti,bus-range-microvolt:
>      description: |
>        This is the operating range of the bus voltage in microvolt
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      enum: [16000000, 32000000]
>      default: 32000000
> 
> @@ -63,14 +61,13 @@ properties:
>        Array of three(TMP513) or two(TMP512) n-Factor value for each remote
>        temperature channel.
>        See datasheet Table 11 for n-Factor range list and value interpretation.
> -    allOf:
> -      - $ref: /schemas/types.yaml#definitions/uint32-array
> -      - minItems: 2
> -        maxItems: 3
> -        items:
> -          default: 0x00
> -          minimum: 0x00
> -          maximum: 0xFF
> +    $ref: /schemas/types.yaml#definitions/uint32-array
> +    minItems: 2
> +    maxItems: 3
> +    items:
> +      default: 0x00
> +      minimum: 0x00
> +      maximum: 0xFF
> 
>  required:
>    - compatible
> diff --git a/Documentation/devicetree/bindings/i2c/st,stm32-i2c.yaml b/Documentation/devicetree/bindings/i2c/st,stm32-i2c.yaml
> index 900ec1ab6a47..96630f225207 100644
> --- a/Documentation/devicetree/bindings/i2c/st,stm32-i2c.yaml
> +++ b/Documentation/devicetree/bindings/i2c/st,stm32-i2c.yaml
> @@ -30,11 +30,10 @@ allOf:
>                         Fast Mode Plus speed is selected by slave.
>                         Format is phandle to syscfg / register offset within
>                         syscfg / register bitmask for FMP bit.
> -          allOf:
> -            - $ref: "/schemas/types.yaml#/definitions/phandle-array"
> -            - items:
> -                minItems: 3
> -                maxItems: 3
> +          $ref: "/schemas/types.yaml#/definitions/phandle-array"
> +          items:
> +            minItems: 3
> +            maxItems: 3
> 
>    - if:
>        properties:
> diff --git a/Documentation/devicetree/bindings/iio/adc/adi,ad7124.yaml b/Documentation/devicetree/bindings/iio/adc/adi,ad7124.yaml
> index 97087a45ce54..deb34deff0e8 100644
> --- a/Documentation/devicetree/bindings/iio/adc/adi,ad7124.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/adi,ad7124.yaml
> @@ -83,9 +83,8 @@ patternProperties:
>            1: REFIN2(+)/REFIN2(−).
>            3: AVDD
>            If this field is left empty, internal reference is selected.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> -          - enum: [0, 1, 3]
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        enum: [0, 1, 3]
> 
>        diff-channels:
>          description: see Documentation/devicetree/bindings/iio/adc/adc.txt
> diff --git a/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.yaml b/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.yaml
> index 97f521d654ea..6a991e9f78e2 100644
> --- a/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.yaml
> @@ -18,8 +18,7 @@ properties:
> 
>    vref-supply:
>      description: phandle to an external regulator providing the reference voltage
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/phandle
> +    $ref: /schemas/types.yaml#/definitions/phandle
> 
>    reg:
>      description: spi chipselect number according to the usual spi bindings
> diff --git a/Documentation/devicetree/bindings/iio/adc/microchip,mcp3911.yaml b/Documentation/devicetree/bindings/iio/adc/microchip,mcp3911.yaml
> index 8ffeceb6abae..95ab285f4eba 100644
> --- a/Documentation/devicetree/bindings/iio/adc/microchip,mcp3911.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/microchip,mcp3911.yaml
> @@ -38,10 +38,9 @@ properties:
> 
>    microchip,device-addr:
>      description: Device address when multiple MCP3911 chips are present on the same SPI bus.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [0, 1, 2, 3]
> -      - default: 0
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1, 2, 3]
> +    default: 0
> 
>    vref-supply:
>      description: |
> diff --git a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
> index b1627441a0b2..d69ca492d020 100644
> --- a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
> @@ -95,16 +95,14 @@ patternProperties:
>            On stm32h7 and stm32mp1:
>            - For st,stm32-dfsdm-adc: up to 8 channels numbered from 0 to 7.
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
> 
>        st,adc-channel-names:
>          description: List of single-ended channel names.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/string-array
> +        $ref: /schemas/types.yaml#/definitions/string-array
> 
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
> 
>        "#io-channel-cells":
>          const: 1
> @@ -129,9 +126,8 @@ patternProperties:
>            - "MANCH_R": manchester codec, rising edge = logic 0, falling edge = logic 1
>            - "MANCH_F": manchester codec, rising edge = logic 1, falling edge = logic 0
>          items:
> -          enum: [ SPI_R, SPI_F, MANCH_R, MANCH_F ]
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/non-unique-string-array
> +          enum: [SPI_R, SPI_F, MANCH_R, MANCH_F]
> +        $ref: /schemas/types.yaml#/definitions/non-unique-string-array
> 
>        st,adc-channel-clk-src:
>          description: |
> @@ -141,9 +137,8 @@ patternProperties:
>            - "CLKOUT_F": internal SPI clock divided by 2 (falling edge).
>            - "CLKOUT_R": internal SPI clock divided by 2 (rising edge).
>          items:
> -          enum: [ CLKIN, CLKOUT, CLKOUT_F, CLKOUT_R ]
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/non-unique-string-array
> +          enum: [CLKIN, CLKOUT, CLKOUT_F, CLKOUT_R]
> +        $ref: /schemas/types.yaml#/definitions/non-unique-string-array
> 
>        st,adc-alt-channel:
>          description:
> diff --git a/Documentation/devicetree/bindings/iio/light/tsl2772.yaml b/Documentation/devicetree/bindings/iio/light/tsl2772.yaml
> index e8f7d1ada57b..d81229857944 100644
> --- a/Documentation/devicetree/bindings/iio/light/tsl2772.yaml
> +++ b/Documentation/devicetree/bindings/iio/light/tsl2772.yaml
> @@ -33,13 +33,12 @@ properties:
> 
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
> 
>    interrupts:
>      maxItems: 1
> diff --git a/Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.yaml b/Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.yaml
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
> 
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
> 
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
> 
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
> 
> @@ -210,9 +205,8 @@ patternProperties:
>          description:
>            Identifies the number of wires used by the RTD. Setting this
>            property to 5 means 4 wires with Kelvin Rsense.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> -          - enum: [2, 3, 4, 5]
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        enum: [2, 3, 4, 5]
> 
>        adi,rsense-share:
>          description:
> @@ -237,18 +231,16 @@ patternProperties:
>          description:
>            This property set the RTD curve used and the corresponding
>            Callendar-VanDusen constants. Look at table 30 of the datasheet.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> -          - minimum: 0
> -            maximum: 3
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        minimum: 0
> +        maximum: 3
> 
>        adi,custom-rtd:
>          description:
>            This is a table, where each entry should be a pair of
>            resistance(ohm)-temperature(K). The entries added here are in uohm
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
> 
> @@ -314,10 +305,9 @@ patternProperties:
>            This property controls the magnitude of the excitation current
>            applied to the thermistor. Value 0 set's the sensor in auto-range
>            mode.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> -          - enum: [0, 250, 500, 1000, 5000, 10000, 25000, 50000, 100000,
> -                   250000, 500000, 1000000]
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        enum: [0, 250, 500, 1000, 5000, 10000, 25000, 50000, 100000, 250000,
> +          500000, 1000000]
> 
>        adi,custom-thermistor:
>          description:
> @@ -325,8 +315,7 @@ patternProperties:
>            resistance(ohm)-temperature(K). The entries added here are in uohm
>            and uK only for custom thermistors. For more details look at table
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
> 
>        adi,single-ended:
> @@ -379,8 +366,7 @@ patternProperties:
> 
>        adi,sensor-type:
>          description: Identifies the sensor as a rsense.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> +        $ref: /schemas/types.yaml#/definitions/uint32
>          const: 29
> 
>        adi,rsense-val-milli-ohms:
> diff --git a/Documentation/devicetree/bindings/input/allwinner,sun4i-a10-lradc-keys.yaml b/Documentation/devicetree/bindings/input/allwinner,sun4i-a10-lradc-keys.yaml
> index 512a6af5aa42..cffd02028d02 100644
> --- a/Documentation/devicetree/bindings/input/allwinner,sun4i-a10-lradc-keys.yaml
> +++ b/Documentation/devicetree/bindings/input/allwinner,sun4i-a10-lradc-keys.yaml
> @@ -42,9 +42,8 @@ patternProperties:
>          description: Keycode to emit
> 
>        channel:
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> -          - enum: [0, 1]
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        enum: [0, 1]
>          description: ADC Channel this key is attached to
> 
>        voltage:
> diff --git a/Documentation/devicetree/bindings/input/input.yaml b/Documentation/devicetree/bindings/input/input.yaml
> index 6d519046b3af..8edcb3c31270 100644
> --- a/Documentation/devicetree/bindings/input/input.yaml
> +++ b/Documentation/devicetree/bindings/input/input.yaml
> @@ -18,11 +18,10 @@ properties:
>      description:
>        Specifies an array of numeric keycode values to be used for reporting
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
> 
>    poll-interval:
>      description: Poll interval time in milliseconds.
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml b/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml
> index 66aacd106503..1ecd1831cf02 100644
> --- a/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml
> +++ b/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml
> @@ -91,18 +91,16 @@ properties:
>      description:
>        If using padding pages, specifies the stride of consecutive
>        redistributors. Must be a multiple of 64kB.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint64
> -      - multipleOf: 0x10000
> -        exclusiveMinimum: 0
> +    $ref: /schemas/types.yaml#/definitions/uint64
> +    multipleOf: 0x10000
> +    exclusiveMinimum: 0
> 
>    "#redistributor-regions":
>      description:
>        The number of independent contiguous regions occupied by the
>        redistributors. Required if more than one such region is present.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - maximum: 4096   # Should be enough?
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    maximum: 4096
> 
>    msi-controller:
>      description:
> @@ -114,22 +112,20 @@ properties:
>        A list of pairs <intid span>, where "intid" is the first SPI of a range
>        that can be used an MBI, and "span" the size of that range. Multiple
>        ranges can be provided.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-matrix
> -      - items:
> -          minItems: 2
> -          maxItems: 2
> +    $ref: /schemas/types.yaml#/definitions/uint32-matrix
> +    items:
> +      minItems: 2
> +      maxItems: 2
> 
>    mbi-alias:
>      description:
>        Address property. Base address of an alias of the GICD region containing
>        only the {SET,CLR}SPI registers to be used if isolation is required,
>        and if supported by the HW.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
> -      - items:
> -          minItems: 1
> -          maxItems: 2
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    items:
> +      minItems: 1
> +      maxItems: 2
> 
>    ppi-partitions:
>      type: object
> @@ -188,11 +184,10 @@ patternProperties:
>          description:
>            (u32, u32) tuple describing the untranslated
>            address and size of the pre-ITS window.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32-array
> -          - items:
> -              minItems: 2
> -              maxItems: 2
> +        $ref: /schemas/types.yaml#/definitions/uint32-array
> +        items:
> +          minItems: 2
> +          maxItems: 2
> 
>      required:
>        - compatible
> diff --git a/Documentation/devicetree/bindings/iommu/arm,smmu.yaml b/Documentation/devicetree/bindings/iommu/arm,smmu.yaml
> index 6515dbe47508..3aa554878b90 100644
> --- a/Documentation/devicetree/bindings/iommu/arm,smmu.yaml
> +++ b/Documentation/devicetree/bindings/iommu/arm,smmu.yaml
> @@ -56,8 +56,7 @@ properties:
> 
>    '#global-interrupts':
>      description: The number of global interrupts exposed by the device.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      minimum: 0
>      maximum: 260   # 2 secure, 2 non-secure, and up to 256 perf counters
> 
> diff --git a/Documentation/devicetree/bindings/leds/common.yaml b/Documentation/devicetree/bindings/leds/common.yaml
> index 4c270fde4567..a2a541bca73c 100644
> --- a/Documentation/devicetree/bindings/leds/common.yaml
> +++ b/Documentation/devicetree/bindings/leds/common.yaml
> @@ -41,8 +41,7 @@ properties:
>        Color of the LED. Use one of the LED_COLOR_ID_* prefixed definitions from
>        the header include/dt-bindings/leds/common.h. If there is no matching
>        LED_COLOR_ID available, add a new one.
> -    allOf:
> -      - $ref: /schemas/types.yaml#definitions/uint32
> +    $ref: /schemas/types.yaml#definitions/uint32
>      minimum: 0
>      maximum: 8
> 
> @@ -67,8 +66,7 @@ properties:
>        produced where the LED momentarily turns off (or on). The "keep" setting
>        will keep the LED at whatever its current state is, without producing a
>        glitch.
> -    allOf:
> -      - $ref: /schemas/types.yaml#definitions/string
> +    $ref: /schemas/types.yaml#definitions/string
>      enum:
>        - on
>        - off
> @@ -79,8 +77,8 @@ properties:
>      description:
>        This parameter, if present, is a string defining the trigger assigned to
>        the LED.
> -    allOf:
> -      - $ref: /schemas/types.yaml#definitions/string
> +    $ref: /schemas/types.yaml#definitions/string
> +
>      enum:
>          # LED will act as a back-light, controlled by the framebuffer system
>        - backlight
> @@ -111,8 +109,7 @@ properties:
>            brightness and duration (in ms).  The exact format is
>            described in:
>            Documentation/devicetree/bindings/leds/leds-trigger-pattern.txt
> -    allOf:
> -      - $ref: /schemas/types.yaml#definitions/uint32-matrix
> +    $ref: /schemas/types.yaml#definitions/uint32-matrix
>      items:
>        minItems: 2
>        maxItems: 2
> diff --git a/Documentation/devicetree/bindings/leds/leds-gpio.yaml b/Documentation/devicetree/bindings/leds/leds-gpio.yaml
> index 0e75b185dd19..7ad2baeda0b0 100644
> --- a/Documentation/devicetree/bindings/leds/leds-gpio.yaml
> +++ b/Documentation/devicetree/bindings/leds/leds-gpio.yaml
> @@ -24,8 +24,7 @@ patternProperties:
>    "(^led-[0-9a-f]$|led)":
>      type: object
> 
> -    allOf:
> -      - $ref: common.yaml#
> +    $ref: common.yaml#
> 
>      properties:
>        gpios:
> diff --git a/Documentation/devicetree/bindings/leds/rohm,bd71828-leds.yaml b/Documentation/devicetree/bindings/leds/rohm,bd71828-leds.yaml
> index 90edf9d33b33..aa715edd93b0 100644
> --- a/Documentation/devicetree/bindings/leds/rohm,bd71828-leds.yaml
> +++ b/Documentation/devicetree/bindings/leds/rohm,bd71828-leds.yaml
> @@ -34,11 +34,11 @@ patternProperties:
>          #- $ref: "common.yaml#"
>        rohm,led-compatible:
>          description: LED identification string
> -        allOf:
> -          - $ref: "/schemas/types.yaml#/definitions/string"
> -          - enum:
> -            - bd71828-ambled
> -            - bd71828-grnled
> +        $ref: "/schemas/types.yaml#/definitions/string"
> +        enum:
> +
> +          - bd71828-ambled
> +          - bd71828-grnled
>        function:
>          description:
>            Purpose of LED as defined in dt-bindings/leds/common.h
> diff --git a/Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml b/Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml
> index db851541d619..3b7ab61a144f 100644
> --- a/Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml
> +++ b/Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml
> @@ -49,9 +49,8 @@ properties:
> 
>    st,proc-id:
>      description: Processor id using the mailbox (0 or 1)
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [ 0, 1 ]
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1]
> 
>  required:
>    - compatible
> diff --git a/Documentation/devicetree/bindings/media/amlogic,gx-vdec.yaml b/Documentation/devicetree/bindings/media/amlogic,gx-vdec.yaml
> index 5a1da4029c37..b902495d278b 100644
> --- a/Documentation/devicetree/bindings/media/amlogic,gx-vdec.yaml
> +++ b/Documentation/devicetree/bindings/media/amlogic,gx-vdec.yaml
> @@ -77,13 +77,11 @@ properties:
> 
>    amlogic,ao-sysctrl:
>      description: should point to the AOBUS sysctrl node
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/phandle
> +    $ref: /schemas/types.yaml#/definitions/phandle
> 
>    amlogic,canvas:
>      description: should point to a canvas provider node
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/phandle
> +    $ref: /schemas/types.yaml#/definitions/phandle
> 
>  allOf:
>    - if:
> diff --git a/Documentation/devicetree/bindings/media/amlogic,meson-gx-ao-cec.yaml b/Documentation/devicetree/bindings/media/amlogic,meson-gx-ao-cec.yaml
> index 95ffa8bc0533..c08e2ddf292a 100644
> --- a/Documentation/devicetree/bindings/media/amlogic,meson-gx-ao-cec.yaml
> +++ b/Documentation/devicetree/bindings/media/amlogic,meson-gx-ao-cec.yaml
> @@ -35,8 +35,7 @@ properties:
> 
>    hdmi-phandle:
>      description: phandle to the HDMI controller
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/phandle
> +    $ref: /schemas/types.yaml#/definitions/phandle
> 
>  allOf:
>    - if:
> diff --git a/Documentation/devicetree/bindings/media/rc.yaml b/Documentation/devicetree/bindings/media/rc.yaml
> index b27c9385d490..ded2ac43237d 100644
> --- a/Documentation/devicetree/bindings/media/rc.yaml
> +++ b/Documentation/devicetree/bindings/media/rc.yaml
> @@ -18,136 +18,135 @@ properties:
>      description:
>        Specifies the scancode/key mapping table defined in-kernel for
>        the remote controller.
> -    allOf:
> -      - $ref: '/schemas/types.yaml#/definitions/string'
> -      - enum:
> -          - rc-adstech-dvb-t-pci
> -          - rc-alink-dtu-m
> -          - rc-anysee
> -          - rc-apac-viewcomp
> -          - rc-astrometa-t2hybrid
> -          - rc-asus-pc39
> -          - rc-asus-ps3-100
> -          - rc-ati-tv-wonder-hd-600
> -          - rc-ati-x10
> -          - rc-avermedia
> -          - rc-avermedia-a16d
> -          - rc-avermedia-cardbus
> -          - rc-avermedia-dvbt
> -          - rc-avermedia-m135a
> -          - rc-avermedia-m733a-rm-k6
> -          - rc-avermedia-rm-ks
> -          - rc-avertv-303
> -          - rc-azurewave-ad-tu700
> -          - rc-beelink-gs1
> -          - rc-behold
> -          - rc-behold-columbus
> -          - rc-budget-ci-old
> -          - rc-cec
> -          - rc-cinergy
> -          - rc-cinergy-1400
> -          - rc-d680-dmb
> -          - rc-delock-61959
> -          - rc-dib0700-nec
> -          - rc-dib0700-rc5
> -          - rc-digitalnow-tinytwin
> -          - rc-digittrade
> -          - rc-dm1105-nec
> -          - rc-dntv-live-dvb-t
> -          - rc-dntv-live-dvbt-pro
> -          - rc-dtt200u
> -          - rc-dvbsky
> -          - rc-dvico-mce
> -          - rc-dvico-portable
> -          - rc-em-terratec
> -          - rc-empty
> -          - rc-encore-enltv
> -          - rc-encore-enltv-fm53
> -          - rc-encore-enltv2
> -          - rc-evga-indtube
> -          - rc-eztv
> -          - rc-flydvb
> -          - rc-flyvideo
> -          - rc-fusionhdtv-mce
> -          - rc-gadmei-rm008z
> -          - rc-geekbox
> -          - rc-genius-tvgo-a11mce
> -          - rc-gotview7135
> -          - rc-hauppauge
> -          - rc-hisi-poplar
> -          - rc-hisi-tv-demo
> -          - rc-imon-mce
> -          - rc-imon-pad
> -          - rc-imon-rsc
> -          - rc-iodata-bctv7e
> -          - rc-it913x-v1
> -          - rc-it913x-v2
> -          - rc-kaiomy
> -          - rc-khadas
> -          - rc-kworld-315u
> -          - rc-kworld-pc150u
> -          - rc-kworld-plus-tv-analog
> -          - rc-leadtek-y04g0051
> -          - rc-lme2510
> -          - rc-manli
> -          - rc-medion-x10
> -          - rc-medion-x10-digitainer
> -          - rc-medion-x10-or2x
> -          - rc-msi-digivox-ii
> -          - rc-msi-digivox-iii
> -          - rc-msi-tvanywhere
> -          - rc-msi-tvanywhere-plus
> -          - rc-nebula
> -          - rc-nec-terratec-cinergy-xs
> -          - rc-norwood
> -          - rc-npgtech
> -          - rc-odroid
> -          - rc-pctv-sedna
> -          - rc-pinnacle-color
> -          - rc-pinnacle-grey
> -          - rc-pinnacle-pctv-hd
> -          - rc-pixelview
> -          - rc-pixelview-002t
> -          - rc-pixelview-mk12
> -          - rc-pixelview-new
> -          - rc-powercolor-real-angel
> -          - rc-proteus-2309
> -          - rc-purpletv
> -          - rc-pv951
> -          - rc-rc5-tv
> -          - rc-rc6-mce
> -          - rc-real-audio-220-32-keys
> -          - rc-reddo
> -          - rc-snapstream-firefly
> -          - rc-streamzap
> -          - rc-su3000
> -          - rc-tango
> -          - rc-tanix-tx3mini
> -          - rc-tanix-tx5max
> -          - rc-tbs-nec
> -          - rc-technisat-ts35
> -          - rc-technisat-usb2
> -          - rc-terratec-cinergy-c-pci
> -          - rc-terratec-cinergy-s2-hd
> -          - rc-terratec-cinergy-xs
> -          - rc-terratec-slim
> -          - rc-terratec-slim-2
> -          - rc-tevii-nec
> -          - rc-tivo
> -          - rc-total-media-in-hand
> -          - rc-total-media-in-hand-02
> -          - rc-trekstor
> -          - rc-tt-1500
> -          - rc-twinhan-dtv-cab-ci
> -          - rc-twinhan1027
> -          - rc-videomate-k100
> -          - rc-videomate-s350
> -          - rc-videomate-tv-pvr
> -          - rc-videostrong-kii-pro
> -          - rc-wetek-hub
> -          - rc-wetek-play2
> -          - rc-winfast
> -          - rc-winfast-usbii-deluxe
> -          - rc-x96max
> -          - rc-xbox-dvd
> -          - rc-zx-irdec
> +    $ref: '/schemas/types.yaml#/definitions/string'
> +    enum:
> +      - rc-adstech-dvb-t-pci
> +      - rc-alink-dtu-m
> +      - rc-anysee
> +      - rc-apac-viewcomp
> +      - rc-astrometa-t2hybrid
> +      - rc-asus-pc39
> +      - rc-asus-ps3-100
> +      - rc-ati-tv-wonder-hd-600
> +      - rc-ati-x10
> +      - rc-avermedia
> +      - rc-avermedia-a16d
> +      - rc-avermedia-cardbus
> +      - rc-avermedia-dvbt
> +      - rc-avermedia-m135a
> +      - rc-avermedia-m733a-rm-k6
> +      - rc-avermedia-rm-ks
> +      - rc-avertv-303
> +      - rc-azurewave-ad-tu700
> +      - rc-beelink-gs1
> +      - rc-behold
> +      - rc-behold-columbus
> +      - rc-budget-ci-old
> +      - rc-cec
> +      - rc-cinergy
> +      - rc-cinergy-1400
> +      - rc-d680-dmb
> +      - rc-delock-61959
> +      - rc-dib0700-nec
> +      - rc-dib0700-rc5
> +      - rc-digitalnow-tinytwin
> +      - rc-digittrade
> +      - rc-dm1105-nec
> +      - rc-dntv-live-dvb-t
> +      - rc-dntv-live-dvbt-pro
> +      - rc-dtt200u
> +      - rc-dvbsky
> +      - rc-dvico-mce
> +      - rc-dvico-portable
> +      - rc-em-terratec
> +      - rc-empty
> +      - rc-encore-enltv
> +      - rc-encore-enltv-fm53
> +      - rc-encore-enltv2
> +      - rc-evga-indtube
> +      - rc-eztv
> +      - rc-flydvb
> +      - rc-flyvideo
> +      - rc-fusionhdtv-mce
> +      - rc-gadmei-rm008z
> +      - rc-geekbox
> +      - rc-genius-tvgo-a11mce
> +      - rc-gotview7135
> +      - rc-hauppauge
> +      - rc-hisi-poplar
> +      - rc-hisi-tv-demo
> +      - rc-imon-mce
> +      - rc-imon-pad
> +      - rc-imon-rsc
> +      - rc-iodata-bctv7e
> +      - rc-it913x-v1
> +      - rc-it913x-v2
> +      - rc-kaiomy
> +      - rc-khadas
> +      - rc-kworld-315u
> +      - rc-kworld-pc150u
> +      - rc-kworld-plus-tv-analog
> +      - rc-leadtek-y04g0051
> +      - rc-lme2510
> +      - rc-manli
> +      - rc-medion-x10
> +      - rc-medion-x10-digitainer
> +      - rc-medion-x10-or2x
> +      - rc-msi-digivox-ii
> +      - rc-msi-digivox-iii
> +      - rc-msi-tvanywhere
> +      - rc-msi-tvanywhere-plus
> +      - rc-nebula
> +      - rc-nec-terratec-cinergy-xs
> +      - rc-norwood
> +      - rc-npgtech
> +      - rc-odroid
> +      - rc-pctv-sedna
> +      - rc-pinnacle-color
> +      - rc-pinnacle-grey
> +      - rc-pinnacle-pctv-hd
> +      - rc-pixelview
> +      - rc-pixelview-002t
> +      - rc-pixelview-mk12
> +      - rc-pixelview-new
> +      - rc-powercolor-real-angel
> +      - rc-proteus-2309
> +      - rc-purpletv
> +      - rc-pv951
> +      - rc-rc5-tv
> +      - rc-rc6-mce
> +      - rc-real-audio-220-32-keys
> +      - rc-reddo
> +      - rc-snapstream-firefly
> +      - rc-streamzap
> +      - rc-su3000
> +      - rc-tango
> +      - rc-tanix-tx3mini
> +      - rc-tanix-tx5max
> +      - rc-tbs-nec
> +      - rc-technisat-ts35
> +      - rc-technisat-usb2
> +      - rc-terratec-cinergy-c-pci
> +      - rc-terratec-cinergy-s2-hd
> +      - rc-terratec-cinergy-xs
> +      - rc-terratec-slim
> +      - rc-terratec-slim-2
> +      - rc-tevii-nec
> +      - rc-tivo
> +      - rc-total-media-in-hand
> +      - rc-total-media-in-hand-02
> +      - rc-trekstor
> +      - rc-tt-1500
> +      - rc-twinhan-dtv-cab-ci
> +      - rc-twinhan1027
> +      - rc-videomate-k100
> +      - rc-videomate-s350
> +      - rc-videomate-tv-pvr
> +      - rc-videostrong-kii-pro
> +      - rc-wetek-hub
> +      - rc-wetek-play2
> +      - rc-winfast
> +      - rc-winfast-usbii-deluxe
> +      - rc-x96max
> +      - rc-xbox-dvd
> +      - rc-zx-irdec
> diff --git a/Documentation/devicetree/bindings/media/renesas,vin.yaml b/Documentation/devicetree/bindings/media/renesas,vin.yaml
> index ecc09f1124d4..6d473cdcb16a 100644
> --- a/Documentation/devicetree/bindings/media/renesas,vin.yaml
> +++ b/Documentation/devicetree/bindings/media/renesas,vin.yaml
> @@ -116,10 +116,9 @@ properties:
>    #The per-board settings for Gen3 and RZ/G2 platforms:
>    renesas,id:
>      description: VIN channel number
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - minimum: 0
> -      - maximum: 15
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    minimum: 0
> +    maximum: 15
> 
>    ports:
>      type: object
> diff --git a/Documentation/devicetree/bindings/memory-controllers/exynos-srom.yaml b/Documentation/devicetree/bindings/memory-controllers/exynos-srom.yaml
> index cdfe3f7f0ea9..0dc008e816e2 100644
> --- a/Documentation/devicetree/bindings/memory-controllers/exynos-srom.yaml
> +++ b/Documentation/devicetree/bindings/memory-controllers/exynos-srom.yaml
> @@ -51,11 +51,10 @@ patternProperties:
>          maxItems: 1
> 
>        reg-io-width:
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> -          - enum: [1, 2]
>          description:
>            Data width in bytes (1 or 2). If omitted, default of 1 is used.
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        enum: [1, 2]
> 
>        samsung,srom-page-mode:
>          description:
> @@ -64,11 +63,10 @@ patternProperties:
>          type: boolean
> 
>        samsung,srom-timing:
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32-array
> -          - items:
> -              minItems: 6
> -              maxItems: 6
> +        $ref: /schemas/types.yaml#/definitions/uint32-array
> +        items:
> +          minItems: 6
> +          maxItems: 6
>          description: |
>            Array of 6 integers, specifying bank timings in the following order:
>            Tacp, Tcah, Tcoh, Tacc, Tcos, Tacs.
> diff --git a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra124-emc.yaml b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra124-emc.yaml
> index 3e0a8a92d652..a3b36dea88b6 100644
> --- a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra124-emc.yaml
> +++ b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra124-emc.yaml
> @@ -73,10 +73,9 @@ patternProperties:
>                timings
> 
>            nvidia,emc-auto-cal-interval:
> -            allOf:
> -              - $ref: /schemas/types.yaml#/definitions/uint32
>              description:
>                pad calibration interval in microseconds
> +            $ref: /schemas/types.yaml#/definitions/uint32
>              minimum: 0
>              maximum: 2097151
> 
> @@ -136,11 +135,10 @@ patternProperties:
>                value of the EMC_XM2DQSPADCTRL2 register for this set of timings
> 
>            nvidia,emc-zcal-cnt-long:
> -            allOf:
> -              - $ref: /schemas/types.yaml#/definitions/uint32
>              description:
>                number of EMC clocks to wait before issuing any commands after
>                clock change
> +            $ref: /schemas/types.yaml#/definitions/uint32
>              minimum: 0
>              maximum: 1023
> 
> @@ -150,12 +148,11 @@ patternProperties:
>                value of the EMC_ZCAL_INTERVAL register for this set of timings
> 
>            nvidia,emc-configuration:
> -            allOf:
> -              - $ref: /schemas/types.yaml#/definitions/uint32-array
>              description:
>                EMC timing characterization data. These are the registers (see
>                section "15.6.2 EMC Registers" in the TRM) whose values need to
>                be specified, according to the board documentation.
> +            $ref: /schemas/types.yaml#/definitions/uint32-array
>              items:
>                - description: EMC_RC
>                - description: EMC_RFC
> diff --git a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra124-mc.yaml b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra124-mc.yaml
> index 22a94b6fdbde..30d9fb193d7f 100644
> --- a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra124-mc.yaml
> +++ b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra124-mc.yaml
> @@ -60,8 +60,7 @@ patternProperties:
>              maximum: 1066000000
> 
>            nvidia,emem-configuration:
> -            allOf:
> -              - $ref: /schemas/types.yaml#/definitions/uint32-array
> +            $ref: /schemas/types.yaml#/definitions/uint32-array
>              description: |
>                Values to be written to the EMEM register block. See section
>                "15.6.1 MC Registers" in the TRM.
> diff --git a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra30-emc.yaml b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra30-emc.yaml
> index e4135bac6957..112bae2fcbbd 100644
> --- a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra30-emc.yaml
> +++ b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra30-emc.yaml
> @@ -56,10 +56,9 @@ patternProperties:
>              maximum: 900000000
> 
>            nvidia,emc-auto-cal-interval:
> -            allOf:
> -              - $ref: /schemas/types.yaml#/definitions/uint32
>              description:
>                Pad calibration interval in microseconds.
> +            $ref: /schemas/types.yaml#/definitions/uint32
>              minimum: 0
>              maximum: 2097151
> 
> @@ -79,11 +78,10 @@ patternProperties:
>                Mode Register 0.
> 
>            nvidia,emc-zcal-cnt-long:
> -            allOf:
> -              - $ref: /schemas/types.yaml#/definitions/uint32
>              description:
>                Number of EMC clocks to wait before issuing any commands after
>                sending ZCAL_MRW_CMD.
> +            $ref: /schemas/types.yaml#/definitions/uint32
>              minimum: 0
>              maximum: 1023
> 
> @@ -98,12 +96,11 @@ patternProperties:
>                FBIO "read" FIFO periodic resetting enabled.
> 
>            nvidia,emc-configuration:
> -            allOf:
> -              - $ref: /schemas/types.yaml#/definitions/uint32-array
>              description:
>                EMC timing characterization data. These are the registers
>                (see section "18.13.2 EMC Registers" in the TRM) whose values
>                need to be specified, according to the board documentation.
> +            $ref: /schemas/types.yaml#/definitions/uint32-array
>              items:
>                - description: EMC_RC
>                - description: EMC_RFC
> diff --git a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra30-mc.yaml b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra30-mc.yaml
> index 4b9196c83291..84fd57bcf0dc 100644
> --- a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra30-mc.yaml
> +++ b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra30-mc.yaml
> @@ -77,8 +77,7 @@ patternProperties:
>              maximum: 900000000
> 
>            nvidia,emem-configuration:
> -            allOf:
> -              - $ref: /schemas/types.yaml#/definitions/uint32-array
> +            $ref: /schemas/types.yaml#/definitions/uint32-array
>              description: |
>                Values to be written to the EMEM register block. See section
>                "18.13.1 MC Registers" in the TRM.
> diff --git a/Documentation/devicetree/bindings/mfd/allwinner,sun4i-a10-ts.yaml b/Documentation/devicetree/bindings/mfd/allwinner,sun4i-a10-ts.yaml
> index 39afacc447b2..f591332fc462 100644
> --- a/Documentation/devicetree/bindings/mfd/allwinner,sun4i-a10-ts.yaml
> +++ b/Documentation/devicetree/bindings/mfd/allwinner,sun4i-a10-ts.yaml
> @@ -31,19 +31,19 @@ properties:
>      description: A touchscreen is attached to the controller
> 
>    allwinner,tp-sensitive-adjust:
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - minimum: 0
> -        maximum: 15
> -        default: 15
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    minimum: 0
> +    maximum: 15
> +    default: 15
> +
>      description: Sensitivity of pen down detection
> 
>    allwinner,filter-type:
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - minimum: 0
> -        maximum: 3
> -        default: 1
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    minimum: 0
> +    maximum: 3
> +    default: 1
> +
>      description: |
>        Select median and averaging filter. Sample used for median /
>        averaging filter:
> diff --git a/Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml b/Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml
> index 4acda7ce3b44..f212fc6e1661 100644
> --- a/Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml
> +++ b/Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml
> @@ -67,23 +67,22 @@ properties:
>          description:
>            One or two <index level filter> to describe break input
>            configurations.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32-matrix
> -          - items:
> -              items:
> -                - description: |
> -                    "index" indicates on which break input (0 or 1) the
> -                    configuration should be applied.
> -                  enum: [ 0 , 1]
> -                - description: |
> -                    "level" gives the active level (0=low or 1=high) of the
> -                    input signal for this configuration
> -                  enum: [ 0, 1 ]
> -                - description: |
> -                    "filter" gives the filtering value (up to 15) to be applied.
> -                  maximum: 15
> -            minItems: 1
> -            maxItems: 2
> +        $ref: /schemas/types.yaml#/definitions/uint32-matrix
> +        items:
> +          items:
> +            - description: |
> +                "index" indicates on which break input (0 or 1) the
> +                configuration should be applied.
> +              enum: [0, 1]
> +            - description: |
> +                "level" gives the active level (0=low or 1=high) of the
> +                input signal for this configuration
> +              enum: [0, 1]
> +            - description: |
> +                "filter" gives the filtering value (up to 15) to be applied.
> +              maximum: 15
> +        minItems: 1
> +        maxItems: 2
> 
>      required:
>        - "#pwm-cells"
> diff --git a/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml b/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml
> index d9ad9260e348..a10dceae9bc5 100644
> --- a/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml
> +++ b/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml
> @@ -29,8 +29,7 @@ properties:
>    onkey:
>      type: object
> 
> -    allOf:
> -      - $ref: ../input/input.yaml
> +    $ref: ../input/input.yaml
> 
>      properties:
>        compatible:
> @@ -68,8 +67,7 @@ properties:
>    watchdog:
>      type: object
> 
> -    allOf:
> -      - $ref: ../watchdog/watchdog.yaml
> +    $ref: ../watchdog/watchdog.yaml
> 
>      properties:
>        compatible:
> @@ -190,8 +188,7 @@ properties:
>          description: STPMIC1 voltage regulators supplies
> 
>        "^(buck[1-4]|ldo[1-6]|boost|vref_ddr|pwr_sw[1-2])$":
> -        allOf:
> -          - $ref: ../regulator/regulator.yaml
> +        $ref: ../regulator/regulator.yaml
> 
>        "^ldo[1-2,5-6]$":
>          type: object
> diff --git a/Documentation/devicetree/bindings/mfd/syscon.yaml b/Documentation/devicetree/bindings/mfd/syscon.yaml
> index 7a39486b215a..19bdaf781853 100644
> --- a/Documentation/devicetree/bindings/mfd/syscon.yaml
> +++ b/Documentation/devicetree/bindings/mfd/syscon.yaml
> @@ -52,9 +52,8 @@ properties:
>      description: |
>        The size (in bytes) of the IO accesses that should be performed
>        on the device.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [ 1, 2, 4, 8 ]
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [1, 2, 4, 8]
> 
>    hwlocks:
>      maxItems: 1
> diff --git a/Documentation/devicetree/bindings/mmc/aspeed,sdhci.yaml b/Documentation/devicetree/bindings/mmc/aspeed,sdhci.yaml
> index 200de9396036..987b287f3bff 100644
> --- a/Documentation/devicetree/bindings/mmc/aspeed,sdhci.yaml
> +++ b/Documentation/devicetree/bindings/mmc/aspeed,sdhci.yaml
> @@ -41,8 +41,8 @@ properties:
>  patternProperties:
>    "^sdhci@[0-9a-f]+$":
>      type: object
> -    allOf:
> -        - $ref: mmc-controller.yaml
> +    $ref: mmc-controller.yaml
> +
>      properties:
>        compatible:
>          enum:
> diff --git a/Documentation/devicetree/bindings/mmc/cdns,sdhci.yaml b/Documentation/devicetree/bindings/mmc/cdns,sdhci.yaml
> index d43a0c557a44..d93f7794a85f 100644
> --- a/Documentation/devicetree/bindings/mmc/cdns,sdhci.yaml
> +++ b/Documentation/devicetree/bindings/mmc/cdns,sdhci.yaml
> @@ -36,91 +36,80 @@ properties:
> 
>    cdns,phy-input-delay-sd-highspeed:
>      description: Value of the delay in the input path for SD high-speed timing
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/uint32"
> -      - minimum: 0
> -      - maximum: 0x1f
> +    $ref: "/schemas/types.yaml#/definitions/uint32"
> +    minimum: 0
> +    maximum: 0x1f
> 
>    cdns,phy-input-delay-legacy:
>      description: Value of the delay in the input path for legacy timing
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/uint32"
> -      - minimum: 0
> -      - maximum: 0x1f
> +    $ref: "/schemas/types.yaml#/definitions/uint32"
> +    minimum: 0
> +    maximum: 0x1f
> 
>    cdns,phy-input-delay-sd-uhs-sdr12:
>      description: Value of the delay in the input path for SD UHS SDR12 timing
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/uint32"
> -      - minimum: 0
> -      - maximum: 0x1f
> +    $ref: "/schemas/types.yaml#/definitions/uint32"
> +    minimum: 0
> +    maximum: 0x1f
> 
>    cdns,phy-input-delay-sd-uhs-sdr25:
>      description: Value of the delay in the input path for SD UHS SDR25 timing
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/uint32"
> -      - minimum: 0
> -      - maximum: 0x1f
> +    $ref: "/schemas/types.yaml#/definitions/uint32"
> +    minimum: 0
> +    maximum: 0x1f
> 
>    cdns,phy-input-delay-sd-uhs-sdr50:
>      description: Value of the delay in the input path for SD UHS SDR50 timing
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/uint32"
> -      - minimum: 0
> -      - maximum: 0x1f
> +    $ref: "/schemas/types.yaml#/definitions/uint32"
> +    minimum: 0
> +    maximum: 0x1f
> 
>    cdns,phy-input-delay-sd-uhs-ddr50:
>      description: Value of the delay in the input path for SD UHS DDR50 timing
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/uint32"
> -      - minimum: 0
> -      - maximum: 0x1f
> +    $ref: "/schemas/types.yaml#/definitions/uint32"
> +    minimum: 0
> +    maximum: 0x1f
> 
>    cdns,phy-input-delay-mmc-highspeed:
>      description: Value of the delay in the input path for MMC high-speed timing
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/uint32"
> -      - minimum: 0
> -      - maximum: 0x1f
> +    $ref: "/schemas/types.yaml#/definitions/uint32"
> +    minimum: 0
> +    maximum: 0x1f
> 
>    cdns,phy-input-delay-mmc-ddr:
>      description: Value of the delay in the input path for eMMC high-speed DDR timing
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/uint32"
> -      - minimum: 0
> -      - maximum: 0x1f
> 
>    # PHY DLL clock delays:
>    # Each delay property represents the fraction of the clock period.
>    # The approximate delay value will be
>    # (<delay property value>/128)*sdmclk_clock_period.
> +    $ref: "/schemas/types.yaml#/definitions/uint32"
> +    minimum: 0
> +    maximum: 0x1f
> 
>    cdns,phy-dll-delay-sdclk:
>      description: |
>        Value of the delay introduced on the sdclk output for all modes except
>        HS200, HS400 and HS400_ES.
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/uint32"
> -      - minimum: 0
> -      - maximum: 0x7f
> +    $ref: "/schemas/types.yaml#/definitions/uint32"
> +    minimum: 0
> +    maximum: 0x7f
> 
>    cdns,phy-dll-delay-sdclk-hsmmc:
>      description: |
>        Value of the delay introduced on the sdclk output for HS200, HS400 and
>        HS400_ES speed modes.
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/uint32"
> -      - minimum: 0
> -      - maximum: 0x7f
> +    $ref: "/schemas/types.yaml#/definitions/uint32"
> +    minimum: 0
> +    maximum: 0x7f
> 
>    cdns,phy-dll-delay-strobe:
>      description: |
>        Value of the delay introduced on the dat_strobe input used in
>        HS400 / HS400_ES speed modes.
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/uint32"
> -      - minimum: 0
> -      - maximum: 0x7f
> +    $ref: "/schemas/types.yaml#/definitions/uint32"
> +    minimum: 0
> +    maximum: 0x7f
> 
>  required:
>    - compatible
> diff --git a/Documentation/devicetree/bindings/mmc/mmc-controller.yaml b/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
> index acc9f10871d4..4931fab34d81 100644
> --- a/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
> +++ b/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
> @@ -76,20 +76,18 @@ properties:
>    # Other properties
> 
>    bus-width:
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [1, 4, 8]
> -        default: 1
>      description:
>        Number of data lines.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [1, 4, 8]
> +    default: 1
> 
>    max-frequency:
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - minimum: 400000
> -      - maximum: 200000000
>      description:
>        Maximum operating frequency of the bus.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    minimum: 400000
> +    maximum: 200000000
> 
>    disable-wp:
>      $ref: /schemas/types.yaml#/definitions/flag
> @@ -212,13 +210,12 @@ properties:
>        eMMC HS400 enhanced strobe mode is supported
> 
>    dsr:
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - minimum: 0
> -      - maximum: 0xffff
>      description:
>        Value the card Driver Stage Register (DSR) should be programmed
>        with.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    minimum: 0
> +    maximum: 0xffff
> 
>    no-sdio:
>      $ref: /schemas/types.yaml#/definitions/flag
> @@ -238,25 +235,23 @@ properties:
>        initialization.
> 
>    fixed-emmc-driver-type:
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - minimum: 0
> -      - maximum: 4
>      description:
>        For non-removable eMMC, enforce this driver type. The value is
>        the driver type as specified in the eMMC specification (table
>        206 in spec version 5.1)
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    minimum: 0
> +    maximum: 4
> 
>    post-power-on-delay-ms:
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - default: 10
>      description:
>        It was invented for MMC pwrseq-simple which could be referred to
>        mmc-pwrseq-simple.txt. But now it\'s reused as a tunable delay
>        waiting for I/O signalling and card power supply to be stable,
>        regardless of whether pwrseq-simple is used. Default to 10ms if
>        no available.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    default: 10
> 
>    supports-cqe:
>      $ref: /schemas/types.yaml#/definitions/flag
> @@ -333,8 +328,8 @@ patternProperties:
>        - reg
> 
>    "^clk-phase-(legacy|sd-hs|mmc-(hs|hs[24]00|ddr52)|uhs-(sdr(12|25|50|104)|ddr50))$":
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +
>      minItems: 2
>      maxItems: 2
>      items:
> diff --git a/Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.yaml b/Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.yaml
> index 4ee3ed6efab4..42d44cbf962f 100644
> --- a/Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.yaml
> +++ b/Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.yaml
> @@ -76,8 +76,7 @@ properties:
>        high speed modes.
> 
>    rockchip,default-sample-phase:
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      minimum: 0
>      maximum: 360
>      default: 0
> @@ -87,8 +86,7 @@ properties:
>        If not specified 0 deg will be used.
> 
>    rockchip,desired-num-phases:
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      minimum: 0
>      maximum: 360
>      default: 360
> diff --git a/Documentation/devicetree/bindings/mmc/synopsys-dw-mshc-common.yaml b/Documentation/devicetree/bindings/mmc/synopsys-dw-mshc-common.yaml
> index 890d47a87ac5..85bd528e9a14 100644
> --- a/Documentation/devicetree/bindings/mmc/synopsys-dw-mshc-common.yaml
> +++ b/Documentation/devicetree/bindings/mmc/synopsys-dw-mshc-common.yaml
> @@ -27,39 +27,35 @@ properties:
>        clock to this at probe time.
> 
>    fifo-depth:
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
>      description:
>        The maximum size of the tx/rx fifo's. If this property is not
>        specified, the default value of the fifo size is determined from the
>        controller registers.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> 
>    card-detect-delay:
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - default: 0
>      description:
>        Delay in milli-seconds before detecting card after card
>        insert event. The default value is 0.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    default: 0
> 
>    data-addr:
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
>      description:
>        Override fifo address with value provided by DT. The default FIFO reg
>        offset is assumed as 0x100 (version < 0x240A) and 0x200(version >= 0x240A)
>        by driver. If the controller does not follow this rule, please use
>        this property to set fifo address in device tree.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> 
>    fifo-watermark-aligned:
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/flag
>      description:
>        Data done irq is expected if data length is less than
>        watermark in PIO mode. But fifo watermark is requested to be aligned
>        with data length in some SoC so that TX/RX irq can be generated with
>        data done irq. Add this watermark quirk to mark this requirement and
>        force fifo watermark setting accordingly.
> +    $ref: /schemas/types.yaml#/definitions/flag
> 
>    dmas:
>      maxItems: 1
> diff --git a/Documentation/devicetree/bindings/mtd/allwinner,sun4i-a10-nand.yaml b/Documentation/devicetree/bindings/mtd/allwinner,sun4i-a10-nand.yaml
> index 5d3fa412aabd..c033ac3f147d 100644
> --- a/Documentation/devicetree/bindings/mtd/allwinner,sun4i-a10-nand.yaml
> +++ b/Documentation/devicetree/bindings/mtd/allwinner,sun4i-a10-nand.yaml
> @@ -75,13 +75,12 @@ patternProperties:
>        allwinner,rb:
>          description:
>            Contains the native Ready/Busy IDs.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32-array
> -          - minItems: 1
> -            maxItems: 2
> -            items:
> -              minimum: 0
> -              maximum: 1
> +        $ref: /schemas/types.yaml#/definitions/uint32-array
> +        minItems: 1
> +        maxItems: 2
> +        items:
> +          minimum: 0
> +          maximum: 1
> 
>      additionalProperties: false
> 
> diff --git a/Documentation/devicetree/bindings/mtd/nand-controller.yaml b/Documentation/devicetree/bindings/mtd/nand-controller.yaml
> index d261b7096c69..cde7c4d79efe 100644
> --- a/Documentation/devicetree/bindings/mtd/nand-controller.yaml
> +++ b/Documentation/devicetree/bindings/mtd/nand-controller.yaml
> @@ -47,29 +47,26 @@ patternProperties:
>            Contains the native Ready/Busy IDs.
> 
>        nand-ecc-mode:
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/string
> -          - enum: [ none, soft, hw, hw_syndrome, hw_oob_first, on-die ]
>          description:
>            Desired ECC engine, either hardware (most of the time
>            embedded in the NAND controller) or software correction
>            (Linux will handle the calculations). soft_bch is deprecated
>            and should be replaced by soft and nand-ecc-algo.
> +        $ref: /schemas/types.yaml#/definitions/string
> +        enum: [none, soft, hw, hw_syndrome, hw_oob_first, on-die]
> 
>        nand-ecc-algo:
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/string
> -          - enum: [ hamming, bch, rs ]
>          description:
>            Desired ECC algorithm.
> +        $ref: /schemas/types.yaml#/definitions/string
> +        enum: [hamming, bch, rs]
> 
>        nand-bus-width:
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> -          - enum: [ 8, 16 ]
> -          - default: 8
>          description:
>            Bus width to the NAND chip
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        enum: [8, 16]
> +        default: 8
> 
>        nand-on-flash-bbt:
>          $ref: /schemas/types.yaml#/definitions/flag
> @@ -83,18 +80,16 @@ patternProperties:
>            build a volatile BBT in RAM.
> 
>        nand-ecc-strength:
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> -          - minimum: 1
>          description:
>            Maximum number of bits that can be corrected per ECC step.
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        minimum: 1
> 
>        nand-ecc-step-size:
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> -          - minimum: 1
>          description:
>            Number of data bytes covered by a single ECC step.
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        minimum: 1
> 
>        nand-ecc-maximize:
>          $ref: /schemas/types.yaml#/definitions/flag
> diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> index 7a784dc4e513..798fa5fb7bb2 100644
> --- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> +++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> @@ -76,36 +76,35 @@ properties:
> 
>        Please refer to 2.4.1 Message RAM Configuration in Bosch
>        M_CAN user manual for details.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/int32-array
> -      - items:
> -         items:
> -           - description: The 'offset' is an address offset of the Message RAM
> -                          where the following elements start from. This is usually
> -                          set to 0x0 if you're using a private Message RAM.
> -             default: 0
> -           - description: 11-bit Filter 0-128 elements / 0-128 words
> -             minimum: 0
> -             maximum: 128
> -           - description: 29-bit Filter 0-64 elements / 0-128 words
> -             minimum: 0
> -             maximum: 64
> -           - description: Rx FIFO 0 0-64 elements / 0-1152 words
> -             minimum: 0
> -             maximum: 64
> -           - description: Rx FIFO 1 0-64 elements / 0-1152 words
> -             minimum: 0
> -             maximum: 64
> -           - description: Rx Buffers 0-64 elements / 0-1152 words
> -             minimum: 0
> -             maximum: 64
> -           - description: Tx Event FIFO 0-32 elements / 0-64 words
> -             minimum: 0
> -             maximum: 32
> -           - description: Tx Buffers 0-32 elements / 0-576 words
> -             minimum: 0
> -             maximum: 32
> -        maxItems: 1
> +    $ref: /schemas/types.yaml#/definitions/int32-array
> +    items:
> +      items:
> +        - description: The 'offset' is an address offset of the Message RAM where
> +            the following elements start from. This is usually set to 0x0 if
> +            you're using a private Message RAM.
> +          default: 0
> +        - description: 11-bit Filter 0-128 elements / 0-128 words
> +          minimum: 0
> +          maximum: 128
> +        - description: 29-bit Filter 0-64 elements / 0-128 words
> +          minimum: 0
> +          maximum: 64
> +        - description: Rx FIFO 0 0-64 elements / 0-1152 words
> +          minimum: 0
> +          maximum: 64
> +        - description: Rx FIFO 1 0-64 elements / 0-1152 words
> +          minimum: 0
> +          maximum: 64
> +        - description: Rx Buffers 0-64 elements / 0-1152 words
> +          minimum: 0
> +          maximum: 64
> +        - description: Tx Event FIFO 0-32 elements / 0-64 words
> +          minimum: 0
> +          maximum: 32
> +        - description: Tx Buffers 0-32 elements / 0-576 words
> +          minimum: 0
> +          maximum: 32
> +    maxItems: 1
> 
>    can-transceiver:
>      $ref: can-transceiver.yaml#
> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> index ac471b60ed6a..1c4474036d46 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -14,25 +14,23 @@ properties:
>      pattern: "^ethernet(@.*)?$"
> 
>    local-mac-address:
> -    allOf:
> -      - $ref: /schemas/types.yaml#definitions/uint8-array
> -      - items:
> -          - minItems: 6
> -            maxItems: 6
>      description:
>        Specifies the MAC address that was assigned to the network device.
> +    $ref: /schemas/types.yaml#definitions/uint8-array
> +    items:
> +      - minItems: 6
> +        maxItems: 6
> 
>    mac-address:
> -    allOf:
> -      - $ref: /schemas/types.yaml#definitions/uint8-array
> -      - items:
> -          - minItems: 6
> -            maxItems: 6
>      description:
>        Specifies the MAC address that was last used by the boot
>        program; should be used in cases where the MAC address assigned
>        to the device by the boot program is different from the
>        local-mac-address property.
> +    $ref: /schemas/types.yaml#definitions/uint8-array
> +    items:
> +      - minItems: 6
> +        maxItems: 6
> 
>    max-frame-size:
>      $ref: /schemas/types.yaml#definitions/uint32
> @@ -133,15 +131,14 @@ properties:
>        is used for components that can have configurable fifo sizes.
> 
>    managed:
> -    allOf:
> -      - $ref: /schemas/types.yaml#definitions/string
> -      - default: auto
> -        enum:
> -          - auto
> -          - in-band-status
>      description:
>        Specifies the PHY management type. If auto is set and fixed-link
>        is not specified, it uses MDIO for management.
> +    $ref: /schemas/types.yaml#definitions/string
> +    default: auto
> +    enum:
> +      - auto
> +      - in-band-status
> 
>    fixed-link:
>      allOf:
> @@ -183,11 +180,10 @@ properties:
>          then:
>            properties:
>              speed:
> -              allOf:
> -                - $ref: /schemas/types.yaml#definitions/uint32
> -                - enum: [10, 100, 1000]
>                description:
>                  Link speed.
> +              $ref: /schemas/types.yaml#definitions/uint32
> +              enum: [10, 100, 1000]
> 
>              full-duplex:
>                $ref: /schemas/types.yaml#definitions/flag
> diff --git a/Documentation/devicetree/bindings/net/qca,ar803x.yaml b/Documentation/devicetree/bindings/net/qca,ar803x.yaml
> index 5a6c9d20c0ba..1788884b8c28 100644
> --- a/Documentation/devicetree/bindings/net/qca,ar803x.yaml
> +++ b/Documentation/devicetree/bindings/net/qca,ar803x.yaml
> @@ -20,15 +20,13 @@ allOf:
>  properties:
>    qca,clk-out-frequency:
>      description: Clock output frequency in Hertz.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [ 25000000, 50000000, 62500000, 125000000 ]
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [25000000, 50000000, 62500000, 125000000]
> 
>    qca,clk-out-strength:
>      description: Clock output driver strength.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [ 0, 1, 2 ]
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1, 2]
> 
>    qca,keep-pll-enabled:
>      description: |
> @@ -52,17 +50,14 @@ properties:
>      type: object
>      description:
>        Initial data for the VDDIO regulator. Set this to 1.5V or 1.8V.
> -    allOf:
> -      - $ref: /schemas/regulator/regulator.yaml
> +    $ref: /schemas/regulator/regulator.yaml
> 
>    vddh-regulator:
>      type: object
>      description:
>        Dummy subnode to model the external connection of the PHY VDDH
>        regulator to VDDIO.
> -    allOf:
> -      - $ref: /schemas/regulator/regulator.yaml
> -
> +    $ref: /schemas/regulator/regulator.yaml
> 
>  examples:
>    - |
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index e08cd4c4d568..3c825c74d596 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -199,14 +199,13 @@ properties:
> 
>    snps,reset-delays-us:
>      deprecated: true
> -    allOf:
> -      - $ref: /schemas/types.yaml#definitions/uint32-array
> -      - minItems: 3
> -        maxItems: 3
>      description:
>        Triplet of delays. The 1st cell is reset pre-delay in micro
>        seconds. The 2nd cell is reset pulse in micro seconds. The 3rd
>        cell is reset post-delay in micro seconds.
> +    $ref: /schemas/types.yaml#definitions/uint32-array
> +    minItems: 3
> +    maxItems: 3
> 
>    snps,aal:
>      $ref: /schemas/types.yaml#definitions/flag
> @@ -301,27 +300,24 @@ allOf:
>      then:
>        properties:
>          snps,pbl:
> -          allOf:
> -            - $ref: /schemas/types.yaml#definitions/uint32
> -            - enum: [2, 4, 8]
>            description:
>              Programmable Burst Length (tx and rx)
> +          $ref: /schemas/types.yaml#definitions/uint32
> +          enum: [2, 4, 8]
> 
>          snps,txpbl:
> -          allOf:
> -            - $ref: /schemas/types.yaml#definitions/uint32
> -            - enum: [2, 4, 8]
>            description:
>              Tx Programmable Burst Length. If set, DMA tx will use this
>              value rather than snps,pbl.
> +          $ref: /schemas/types.yaml#definitions/uint32
> +          enum: [2, 4, 8]
> 
>          snps,rxpbl:
> -          allOf:
> -            - $ref: /schemas/types.yaml#definitions/uint32
> -            - enum: [2, 4, 8]
>            description:
>              Rx Programmable Burst Length. If set, DMA rx will use this
>              value rather than snps,pbl.
> +          $ref: /schemas/types.yaml#definitions/uint32
> +          enum: [2, 4, 8]
> 
>          snps,no-pbl-x8:
>            $ref: /schemas/types.yaml#definitions/flag
> diff --git a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
> index 8fc8d3be303b..1dd5a9bd9db7 100644
> --- a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
> @@ -150,10 +150,9 @@ properties:
>  patternProperties:
>    "^mdio@":
>      type: object
> -    allOf:
> -      - $ref: "ti,davinci-mdio.yaml#"
>      description:
>        CPSW MDIO bus.
> +    $ref: "ti,davinci-mdio.yaml#"
> 
> 
>  required:
> diff --git a/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml b/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
> index 2ea14ab29254..d454c1fab930 100644
> --- a/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
> @@ -40,10 +40,9 @@ properties:
>    ti,hwmods:
>      description: TI hwmod name
>      deprecated: true
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/string-array
> -      - items:
> -          const: davinci_mdio
> +    $ref: /schemas/types.yaml#/definitions/string-array
> +    items:
> +      const: davinci_mdio
> 
>  if:
>    properties:
> diff --git a/Documentation/devicetree/bindings/pci/intel-gw-pcie.yaml b/Documentation/devicetree/bindings/pci/intel-gw-pcie.yaml
> index 48a98dae00de..64b2c64ca806 100644
> --- a/Documentation/devicetree/bindings/pci/intel-gw-pcie.yaml
> +++ b/Documentation/devicetree/bindings/pci/intel-gw-pcie.yaml
> @@ -71,10 +71,9 @@ properties:
> 
>    max-link-speed:
>      description: Specify PCI Gen for link capability.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [ 1, 2, 3, 4 ]
> -      - default: 1
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [1, 2, 3, 4]
> +    default: 1
> 
>    bus-range:
>      description: Range of bus numbers associated with this controller.
> diff --git a/Documentation/devicetree/bindings/pinctrl/allwinner,sun4i-a10-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/allwinner,sun4i-a10-pinctrl.yaml
> index bfefd09d8c1e..7556be6e2754 100644
> --- a/Documentation/devicetree/bindings/pinctrl/allwinner,sun4i-a10-pinctrl.yaml
> +++ b/Documentation/devicetree/bindings/pinctrl/allwinner,sun4i-a10-pinctrl.yaml
> @@ -84,13 +84,12 @@ properties:
>    gpio-line-names: true
> 
>    input-debounce:
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
> -      - minItems: 1
> -        maxItems: 5
>      description:
>        Debouncing periods in microseconds, one period per interrupt
>        bank found in the controller
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    minItems: 1
> +    maxItems: 5
> 
>  patternProperties:
>    # It's pretty scary, but the basic idea is that:
> @@ -115,9 +114,8 @@ patternProperties:
>        bias-pull-down: true
> 
>        drive-strength:
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> -          - enum: [ 10, 20, 30, 40 ]
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        enum: [10, 20, 30, 40]
> 
>      required:
>        - pins
> diff --git a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2400-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2400-pinctrl.yaml
> index 7651a675ab2d..017d9593573b 100644
> --- a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2400-pinctrl.yaml
> +++ b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2400-pinctrl.yaml
> @@ -33,26 +33,23 @@ patternProperties:
>      then:
>        patternProperties:
>          "^function|groups$":
> -          allOf:
> -            - $ref: "/schemas/types.yaml#/definitions/string"
> -            - enum: [ ACPI, ADC0, ADC1, ADC10, ADC11, ADC12, ADC13, ADC14,
> -              ADC15, ADC2, ADC3, ADC4, ADC5, ADC6, ADC7, ADC8, ADC9, BMCINT,
> -              DDCCLK, DDCDAT, EXTRST, FLACK, FLBUSY, FLWP, GPID, GPID0, GPID2,
> -              GPID4, GPID6, GPIE0, GPIE2, GPIE4, GPIE6, I2C10, I2C11, I2C12,
> -              I2C13, I2C14, I2C3, I2C4, I2C5, I2C6, I2C7, I2C8, I2C9, LPCPD,
> -              LPCPME, LPCRST, LPCSMI, MAC1LINK, MAC2LINK, MDIO1, MDIO2, NCTS1,
> -              NCTS2, NCTS3, NCTS4, NDCD1, NDCD2, NDCD3, NDCD4, NDSR1, NDSR2,
> -              NDSR3, NDSR4, NDTR1, NDTR2, NDTR3, NDTR4, NDTS4, NRI1, NRI2,
> -              NRI3, NRI4, NRTS1, NRTS2, NRTS3, OSCCLK, PWM0, PWM1, PWM2, PWM3,
> -              PWM4, PWM5, PWM6, PWM7, RGMII1, RGMII2, RMII1, RMII2, ROM16,
> -              ROM8, ROMCS1, ROMCS2, ROMCS3, ROMCS4, RXD1, RXD2, RXD3, RXD4,
> -              SALT1, SALT2, SALT3, SALT4, SD1, SD2, SGPMCK, SGPMI, SGPMLD,
> -              SGPMO, SGPSCK, SGPSI0, SGPSI1, SGPSLD, SIOONCTRL, SIOPBI, SIOPBO,
> -              SIOPWREQ, SIOPWRGD, SIOS3, SIOS5, SIOSCI, SPI1, SPI1DEBUG,
> -              SPI1PASSTHRU, SPICS1, TIMER3, TIMER4, TIMER5, TIMER6, TIMER7,
> -              TIMER8, TXD1, TXD2, TXD3, TXD4, UART6, USB11D1, USB11H2, USB2D1,
> -              USB2H1, USBCKI, VGABIOS_ROM, VGAHS, VGAVS, VPI18, VPI24, VPI30,
> -              VPO12, VPO24, WDTRST1, WDTRST2 ]
> +          $ref: "/schemas/types.yaml#/definitions/string"
> +          enum: [ACPI, ADC0, ADC1, ADC10, ADC11, ADC12, ADC13, ADC14, ADC15,
> +            ADC2, ADC3, ADC4, ADC5, ADC6, ADC7, ADC8, ADC9, BMCINT, DDCCLK, DDCDAT,
> +            EXTRST, FLACK, FLBUSY, FLWP, GPID, GPID0, GPID2, GPID4, GPID6, GPIE0,
> +            GPIE2, GPIE4, GPIE6, I2C10, I2C11, I2C12, I2C13, I2C14, I2C3, I2C4,
> +            I2C5, I2C6, I2C7, I2C8, I2C9, LPCPD, LPCPME, LPCRST, LPCSMI, MAC1LINK,
> +            MAC2LINK, MDIO1, MDIO2, NCTS1, NCTS2, NCTS3, NCTS4, NDCD1, NDCD2,
> +            NDCD3, NDCD4, NDSR1, NDSR2, NDSR3, NDSR4, NDTR1, NDTR2, NDTR3, NDTR4,
> +            NDTS4, NRI1, NRI2, NRI3, NRI4, NRTS1, NRTS2, NRTS3, OSCCLK, PWM0,
> +            PWM1, PWM2, PWM3, PWM4, PWM5, PWM6, PWM7, RGMII1, RGMII2, RMII1,
> +            RMII2, ROM16, ROM8, ROMCS1, ROMCS2, ROMCS3, ROMCS4, RXD1, RXD2, RXD3,
> +            RXD4, SALT1, SALT2, SALT3, SALT4, SD1, SD2, SGPMCK, SGPMI, SGPMLD,
> +            SGPMO, SGPSCK, SGPSI0, SGPSI1, SGPSLD, SIOONCTRL, SIOPBI, SIOPBO,
> +            SIOPWREQ, SIOPWRGD, SIOS3, SIOS5, SIOSCI, SPI1, SPI1DEBUG, SPI1PASSTHRU,
> +            SPICS1, TIMER3, TIMER4, TIMER5, TIMER6, TIMER7, TIMER8, TXD1, TXD2,
> +            TXD3, TXD4, UART6, USB11D1, USB11H2, USB2D1, USB2H1, USBCKI, VGABIOS_ROM,
> +            VGAHS, VGAVS, VPI18, VPI24, VPI30, VPO12, VPO24, WDTRST1, WDTRST2]
> 
>  required:
>    - compatible
> diff --git a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2500-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2500-pinctrl.yaml
> index 36feaf5e2dff..0172b78e2f27 100644
> --- a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2500-pinctrl.yaml
> +++ b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2500-pinctrl.yaml
> @@ -29,8 +29,8 @@ properties:
>    aspeed,external-nodes:
>      minItems: 2
>      maxItems: 2
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/phandle-array
> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> +
>      description: |
>        A cell of phandles to external controller nodes:
>        0: compatible with "aspeed,ast2500-gfx", "syscon"
> @@ -43,28 +43,25 @@ patternProperties:
>      then:
>        patternProperties:
>          "^function|groups$":
> -          allOf:
> -            - $ref: "/schemas/types.yaml#/definitions/string"
> -            - enum: [ ACPI, ADC0, ADC1, ADC10, ADC11, ADC12, ADC13, ADC14,
> -              ADC15, ADC2, ADC3, ADC4, ADC5, ADC6, ADC7, ADC8, ADC9, BMCINT,
> -              DDCCLK, DDCDAT, ESPI, FWSPICS1, FWSPICS2, GPID0, GPID2, GPID4,
> -              GPID6, GPIE0, GPIE2, GPIE4, GPIE6, I2C10, I2C11, I2C12, I2C13,
> -              I2C14, I2C3, I2C4, I2C5, I2C6, I2C7, I2C8, I2C9, LAD0, LAD1,
> -              LAD2, LAD3, LCLK, LFRAME, LPCHC, LPCPD, LPCPLUS, LPCPME, LPCRST,
> -              LPCSMI, LSIRQ, MAC1LINK, MAC2LINK, MDIO1, MDIO2, NCTS1, NCTS2,
> -              NCTS3, NCTS4, NDCD1, NDCD2, NDCD3, NDCD4, NDSR1, NDSR2, NDSR3,
> -              NDSR4, NDTR1, NDTR2, NDTR3, NDTR4, NRI1, NRI2, NRI3, NRI4, NRTS1,
> -              NRTS2, NRTS3, NRTS4, OSCCLK, PEWAKE, PNOR, PWM0, PWM1, PWM2,
> -              PWM3, PWM4, PWM5, PWM6, PWM7, RGMII1, RGMII2, RMII1, RMII2, RXD1,
> -              RXD2, RXD3, RXD4, SALT1, SALT10, SALT11, SALT12, SALT13, SALT14,
> -              SALT2, SALT3, SALT4, SALT5, SALT6, SALT7, SALT8, SALT9, SCL1,
> -              SCL2, SD1, SD2, SDA1, SDA2, SGPS1, SGPS2, SIOONCTRL, SIOPBI,
> -              SIOPBO, SIOPWREQ, SIOPWRGD, SIOS3, SIOS5, SIOSCI, SPI1, SPI1CS1,
> -              SPI1DEBUG, SPI1PASSTHRU, SPI2CK, SPI2CS0, SPI2CS1, SPI2MISO,
> -              SPI2MOSI, TIMER3, TIMER4, TIMER5, TIMER6, TIMER7, TIMER8, TXD1,
> -              TXD2, TXD3, TXD4, UART6, USB11BHID, USB2AD, USB2AH, USB2BD,
> -              USB2BH, USBCKI, VGABIOSROM, VGAHS, VGAVS, VPI24, VPO, WDTRST1,
> -              WDTRST2, ]
> +          $ref: "/schemas/types.yaml#/definitions/string"
> +          enum: [ACPI, ADC0, ADC1, ADC10, ADC11, ADC12, ADC13, ADC14, ADC15,
> +            ADC2, ADC3, ADC4, ADC5, ADC6, ADC7, ADC8, ADC9, BMCINT, DDCCLK, DDCDAT,
> +            ESPI, FWSPICS1, FWSPICS2, GPID0, GPID2, GPID4, GPID6, GPIE0, GPIE2,
> +            GPIE4, GPIE6, I2C10, I2C11, I2C12, I2C13, I2C14, I2C3, I2C4, I2C5,
> +            I2C6, I2C7, I2C8, I2C9, LAD0, LAD1, LAD2, LAD3, LCLK, LFRAME, LPCHC,
> +            LPCPD, LPCPLUS, LPCPME, LPCRST, LPCSMI, LSIRQ, MAC1LINK, MAC2LINK,
> +            MDIO1, MDIO2, NCTS1, NCTS2, NCTS3, NCTS4, NDCD1, NDCD2, NDCD3, NDCD4,
> +            NDSR1, NDSR2, NDSR3, NDSR4, NDTR1, NDTR2, NDTR3, NDTR4, NRI1, NRI2,
> +            NRI3, NRI4, NRTS1, NRTS2, NRTS3, NRTS4, OSCCLK, PEWAKE, PNOR, PWM0,
> +            PWM1, PWM2, PWM3, PWM4, PWM5, PWM6, PWM7, RGMII1, RGMII2, RMII1,
> +            RMII2, RXD1, RXD2, RXD3, RXD4, SALT1, SALT10, SALT11, SALT12, SALT13,
> +            SALT14, SALT2, SALT3, SALT4, SALT5, SALT6, SALT7, SALT8, SALT9, SCL1,
> +            SCL2, SD1, SD2, SDA1, SDA2, SGPS1, SGPS2, SIOONCTRL, SIOPBI, SIOPBO,
> +            SIOPWREQ, SIOPWRGD, SIOS3, SIOS5, SIOSCI, SPI1, SPI1CS1, SPI1DEBUG,
> +            SPI1PASSTHRU, SPI2CK, SPI2CS0, SPI2CS1, SPI2MISO, SPI2MOSI, TIMER3,
> +            TIMER4, TIMER5, TIMER6, TIMER7, TIMER8, TXD1, TXD2, TXD3, TXD4, UART6,
> +            USB11BHID, USB2AD, USB2AH, USB2BD, USB2BH, USBCKI, VGABIOSROM, VGAHS,
> +            VGAVS, VPI24, VPO, WDTRST1, WDTRST2]
> 
>  required:
>    - compatible
> diff --git a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.yaml
> index 45af29bc3202..1506726c7fea 100644
> --- a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.yaml
> +++ b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.yaml
> @@ -30,64 +30,58 @@ patternProperties:
>      then:
>        properties:
>          function:
> -          allOf:
> -            - $ref: "/schemas/types.yaml#/definitions/string"
> -            - enum: [ ADC0, ADC1, ADC10, ADC11, ADC12, ADC13, ADC14, ADC15,
> -              ADC2, ADC3, ADC4, ADC5, ADC6, ADC7, ADC8, ADC9, BMCINT, EMMC,
> -              ESPI, ESPIALT, FSI1, FSI2, FWSPIABR, FWSPID, FWSPIWP, GPIT0,
> -              GPIT1, GPIT2, GPIT3, GPIT4, GPIT5, GPIT6, GPIT7, GPIU0, GPIU1,
> -              GPIU2, GPIU3, GPIU4, GPIU5, GPIU6, GPIU7, I2C1, I2C10, I2C11,
> -              I2C12, I2C13, I2C14, I2C15, I2C16, I2C2, I2C3, I2C4, I2C5, I2C6,
> -              I2C7, I2C8, I2C9, I3C3, I3C4, I3C5, I3C6, JTAGM, LHPD, LHSIRQ,
> -              LPC, LPCHC, LPCPD, LPCPME, LPCSMI, LSIRQ, MACLINK1, MACLINK2,
> -              MACLINK3, MACLINK4, MDIO1, MDIO2, MDIO3, MDIO4, NCTS1, NCTS2,
> -              NCTS3, NCTS4, NDCD1, NDCD2, NDCD3, NDCD4, NDSR1, NDSR2, NDSR3,
> -              NDSR4, NDTR1, NDTR2, NDTR3, NDTR4, NRI1, NRI2, NRI3, NRI4, NRTS1,
> -              NRTS2, NRTS3, NRTS4, OSCCLK, PEWAKE, PWM0, PWM1, PWM10, PWM11,
> -              PWM12, PWM13, PWM14, PWM15, PWM2, PWM3, PWM4, PWM5, PWM6, PWM7,
> -              PWM8, PWM9, RGMII1, RGMII2, RGMII3, RGMII4, RMII1, RMII2, RMII3,
> -              RMII4, RXD1, RXD2, RXD3, RXD4, SALT1, SALT10, SALT11, SALT12,
> -              SALT13, SALT14, SALT15, SALT16, SALT2, SALT3, SALT4, SALT5,
> -              SALT6, SALT7, SALT8, SALT9, SD1, SD2, SGPM1, SGPS1, SIOONCTRL,
> -              SIOPBI, SIOPBO, SIOPWREQ, SIOPWRGD, SIOS3, SIOS5, SIOSCI, SPI1,
> -              SPI1ABR, SPI1CS1, SPI1WP, SPI2, SPI2CS1, SPI2CS2, TACH0, TACH1,
> -              TACH10, TACH11, TACH12, TACH13, TACH14, TACH15, TACH2, TACH3,
> -              TACH4, TACH5, TACH6, TACH7, TACH8, TACH9, THRU0, THRU1, THRU2,
> -              THRU3, TXD1, TXD2, TXD3, TXD4, UART10, UART11, UART12, UART13,
> -              UART6, UART7, UART8, UART9, USBAD, USBADP, USB2AH, USB2AHP,
> -              USB2BD, USB2BH, VB, VGAHS, VGAVS, WDTRST1, WDTRST2, WDTRST3,
> -              WDTRST4, ]
> +          $ref: "/schemas/types.yaml#/definitions/string"
> +          enum: [ADC0, ADC1, ADC10, ADC11, ADC12, ADC13, ADC14, ADC15, ADC2,
> +            ADC3, ADC4, ADC5, ADC6, ADC7, ADC8, ADC9, BMCINT, EMMC, ESPI, ESPIALT,
> +            FSI1, FSI2, FWSPIABR, FWSPID, FWSPIWP, GPIT0, GPIT1, GPIT2, GPIT3,
> +            GPIT4, GPIT5, GPIT6, GPIT7, GPIU0, GPIU1, GPIU2, GPIU3, GPIU4, GPIU5,
> +            GPIU6, GPIU7, I2C1, I2C10, I2C11, I2C12, I2C13, I2C14, I2C15, I2C16,
> +            I2C2, I2C3, I2C4, I2C5, I2C6, I2C7, I2C8, I2C9, I3C3, I3C4, I3C5,
> +            I3C6, JTAGM, LHPD, LHSIRQ, LPC, LPCHC, LPCPD, LPCPME, LPCSMI, LSIRQ,
> +            MACLINK1, MACLINK2, MACLINK3, MACLINK4, MDIO1, MDIO2, MDIO3, MDIO4,
> +            NCTS1, NCTS2, NCTS3, NCTS4, NDCD1, NDCD2, NDCD3, NDCD4, NDSR1, NDSR2,
> +            NDSR3, NDSR4, NDTR1, NDTR2, NDTR3, NDTR4, NRI1, NRI2, NRI3, NRI4,
> +            NRTS1, NRTS2, NRTS3, NRTS4, OSCCLK, PEWAKE, PWM0, PWM1, PWM10, PWM11,
> +            PWM12, PWM13, PWM14, PWM15, PWM2, PWM3, PWM4, PWM5, PWM6, PWM7, PWM8,
> +            PWM9, RGMII1, RGMII2, RGMII3, RGMII4, RMII1, RMII2, RMII3, RMII4,
> +            RXD1, RXD2, RXD3, RXD4, SALT1, SALT10, SALT11, SALT12, SALT13, SALT14,
> +            SALT15, SALT16, SALT2, SALT3, SALT4, SALT5, SALT6, SALT7, SALT8,
> +            SALT9, SD1, SD2, SGPM1, SGPS1, SIOONCTRL, SIOPBI, SIOPBO, SIOPWREQ,
> +            SIOPWRGD, SIOS3, SIOS5, SIOSCI, SPI1, SPI1ABR, SPI1CS1, SPI1WP, SPI2,
> +            SPI2CS1, SPI2CS2, TACH0, TACH1, TACH10, TACH11, TACH12, TACH13, TACH14,
> +            TACH15, TACH2, TACH3, TACH4, TACH5, TACH6, TACH7, TACH8, TACH9, THRU0,
> +            THRU1, THRU2, THRU3, TXD1, TXD2, TXD3, TXD4, UART10, UART11, UART12,
> +            UART13, UART6, UART7, UART8, UART9, USBAD, USBADP, USB2AH, USB2AHP,
> +            USB2BD, USB2BH, VB, VGAHS, VGAVS, WDTRST1, WDTRST2, WDTRST3, WDTRST4]
> +
>          groups:
> -          allOf:
> -            - $ref: "/schemas/types.yaml#/definitions/string"
> -            - enum: [ ADC0, ADC1, ADC10, ADC11, ADC12, ADC13, ADC14, ADC15,
> -              ADC2, ADC3, ADC4, ADC5, ADC6, ADC7, ADC8, ADC9, BMCINT, EMMCG1,
> -              EMMCG4, EMMCG8, ESPI, ESPIALT, FSI1, FSI2, FWSPIABR, FWSPID,
> -              FWQSPID, FWSPIWP, GPIT0, GPIT1, GPIT2, GPIT3, GPIT4, GPIT5,
> -              GPIT6, GPIT7, GPIU0, GPIU1, GPIU2, GPIU3, GPIU4, GPIU5, GPIU6,
> -              GPIU7, HVI3C3, HVI3C4, I2C1, I2C10, I2C11, I2C12, I2C13, I2C14,
> -              I2C15, I2C16, I2C2, I2C3, I2C4, I2C5, I2C6, I2C7, I2C8, I2C9,
> -              I3C3, I3C4, I3C5, I3C6, JTAGM, LHPD, LHSIRQ, LPC, LPCHC, LPCPD,
> -              LPCPME, LPCSMI, LSIRQ, MACLINK1, MACLINK2, MACLINK3, MACLINK4,
> -              MDIO1, MDIO2, MDIO3, MDIO4, NCTS1, NCTS2, NCTS3, NCTS4, NDCD1,
> -              NDCD2, NDCD3, NDCD4, NDSR1, NDSR2, NDSR3, NDSR4, NDTR1, NDTR2,
> -              NDTR3, NDTR4, NRI1, NRI2, NRI3, NRI4, NRTS1, NRTS2, NRTS3, NRTS4,
> -              OSCCLK, PEWAKE, PWM0, PWM1, PWM10G0, PWM10G1, PWM11G0, PWM11G1,
> -              PWM12G0, PWM12G1, PWM13G0, PWM13G1, PWM14G0, PWM14G1, PWM15G0,
> -              PWM15G1, PWM2, PWM3, PWM4, PWM5, PWM6, PWM7, PWM8G0, PWM8G1,
> -              PWM9G0, PWM9G1, QSPI1, QSPI2, RGMII1, RGMII2, RGMII3, RGMII4,
> -              RMII1, RMII2, RMII3, RMII4, RXD1, RXD2, RXD3, RXD4, SALT1,
> -              SALT10G0, SALT10G1, SALT11G0, SALT11G1, SALT12G0, SALT12G1,
> -              SALT13G0, SALT13G1, SALT14G0, SALT14G1, SALT15G0, SALT15G1,
> -              SALT16G0, SALT16G1, SALT2, SALT3, SALT4, SALT5, SALT6, SALT7,
> -              SALT8, SALT9G0, SALT9G1, SD1, SD2, SD3, SGPM1, SGPS1, SIOONCTRL,
> -              SIOPBI, SIOPBO, SIOPWREQ, SIOPWRGD, SIOS3, SIOS5, SIOSCI, SPI1,
> -              SPI1ABR, SPI1CS1, SPI1WP, SPI2, SPI2CS1, SPI2CS2, TACH0, TACH1,
> -              TACH10, TACH11, TACH12, TACH13, TACH14, TACH15, TACH2, TACH3,
> -              TACH4, TACH5, TACH6, TACH7, TACH8, TACH9, THRU0, THRU1, THRU2,
> -              THRU3, TXD1, TXD2, TXD3, TXD4, UART10, UART11, UART12G0,
> -              UART12G1, UART13G0, UART13G1, UART6, UART7, UART8, UART9, USBA,
> -              USBB, VB, VGAHS, VGAVS, WDTRST1, WDTRST2, WDTRST3, WDTRST4, ]
> +          $ref: "/schemas/types.yaml#/definitions/string"
> +          enum: [ADC0, ADC1, ADC10, ADC11, ADC12, ADC13, ADC14, ADC15, ADC2,
> +            ADC3, ADC4, ADC5, ADC6, ADC7, ADC8, ADC9, BMCINT, EMMCG1, EMMCG4,
> +            EMMCG8, ESPI, ESPIALT, FSI1, FSI2, FWSPIABR, FWSPID, FWQSPID, FWSPIWP,
> +            GPIT0, GPIT1, GPIT2, GPIT3, GPIT4, GPIT5, GPIT6, GPIT7, GPIU0, GPIU1,
> +            GPIU2, GPIU3, GPIU4, GPIU5, GPIU6, GPIU7, HVI3C3, HVI3C4, I2C1, I2C10,
> +            I2C11, I2C12, I2C13, I2C14, I2C15, I2C16, I2C2, I2C3, I2C4, I2C5,
> +            I2C6, I2C7, I2C8, I2C9, I3C3, I3C4, I3C5, I3C6, JTAGM, LHPD, LHSIRQ,
> +            LPC, LPCHC, LPCPD, LPCPME, LPCSMI, LSIRQ, MACLINK1, MACLINK2, MACLINK3,
> +            MACLINK4, MDIO1, MDIO2, MDIO3, MDIO4, NCTS1, NCTS2, NCTS3, NCTS4,
> +            NDCD1, NDCD2, NDCD3, NDCD4, NDSR1, NDSR2, NDSR3, NDSR4, NDTR1, NDTR2,
> +            NDTR3, NDTR4, NRI1, NRI2, NRI3, NRI4, NRTS1, NRTS2, NRTS3, NRTS4,
> +            OSCCLK, PEWAKE, PWM0, PWM1, PWM10G0, PWM10G1, PWM11G0, PWM11G1, PWM12G0,
> +            PWM12G1, PWM13G0, PWM13G1, PWM14G0, PWM14G1, PWM15G0, PWM15G1, PWM2,
> +            PWM3, PWM4, PWM5, PWM6, PWM7, PWM8G0, PWM8G1, PWM9G0, PWM9G1, QSPI1,
> +            QSPI2, RGMII1, RGMII2, RGMII3, RGMII4, RMII1, RMII2, RMII3, RMII4,
> +            RXD1, RXD2, RXD3, RXD4, SALT1, SALT10G0, SALT10G1, SALT11G0, SALT11G1,
> +            SALT12G0, SALT12G1, SALT13G0, SALT13G1, SALT14G0, SALT14G1, SALT15G0,
> +            SALT15G1, SALT16G0, SALT16G1, SALT2, SALT3, SALT4, SALT5, SALT6,
> +            SALT7, SALT8, SALT9G0, SALT9G1, SD1, SD2, SD3, SGPM1, SGPS1, SIOONCTRL,
> +            SIOPBI, SIOPBO, SIOPWREQ, SIOPWRGD, SIOS3, SIOS5, SIOSCI, SPI1, SPI1ABR,
> +            SPI1CS1, SPI1WP, SPI2, SPI2CS1, SPI2CS2, TACH0, TACH1, TACH10, TACH11,
> +            TACH12, TACH13, TACH14, TACH15, TACH2, TACH3, TACH4, TACH5, TACH6,
> +            TACH7, TACH8, TACH9, THRU0, THRU1, THRU2, THRU3, TXD1, TXD2, TXD3,
> +            TXD4, UART10, UART11, UART12G0, UART12G1, UART13G0, UART13G1, UART6,
> +            UART7, UART8, UART9, USBA, USBB, VB, VGAHS, VGAVS, WDTRST1, WDTRST2,
> +            WDTRST3, WDTRST4]
> 
>  required:
>    - compatible
> diff --git a/Documentation/devicetree/bindings/pinctrl/fsl,imx8mp-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/fsl,imx8mp-pinctrl.yaml
> index 6297e78418cf..d474bc1f393b 100644
> --- a/Documentation/devicetree/bindings/pinctrl/fsl,imx8mp-pinctrl.yaml
> +++ b/Documentation/devicetree/bindings/pinctrl/fsl,imx8mp-pinctrl.yaml
> @@ -37,22 +37,21 @@ patternProperties:
>            be found in <arch/arm64/boot/dts/freescale/imx8mp-pinfunc.h>. The last
>            integer CONFIG is the pad setting value like pull-up on this pin. Please
>            refer to i.MX8M Plus Reference Manual for detailed CONFIG settings.
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32-matrix
> -          - items:
> -              items:
> -                - description: |
> -                    "mux_reg" indicates the offset of mux register.
> -                - description: |
> -                    "conf_reg" indicates the offset of pad configuration register.
> -                - description: |
> -                    "input_reg" indicates the offset of select input register.
> -                - description: |
> -                    "mux_val" indicates the mux value to be applied.
> -                - description: |
> -                    "input_val" indicates the select input value to be applied.
> -                - description: |
> -                    "pad_setting" indicates the pad configuration value to be applied.
> +        $ref: /schemas/types.yaml#/definitions/uint32-matrix
> +        items:
> +          items:
> +            - description: |
> +                "mux_reg" indicates the offset of mux register.
> +            - description: |
> +                "conf_reg" indicates the offset of pad configuration register.
> +            - description: |
> +                "input_reg" indicates the offset of select input register.
> +            - description: |
> +                "mux_val" indicates the mux value to be applied.
> +            - description: |
> +                "input_val" indicates the select input value to be applied.
> +            - description: |
> +                "pad_setting" indicates the pad configuration value to be applied.
> 
>      required:
>        - fsl,pins
> diff --git a/Documentation/devicetree/bindings/pinctrl/intel,lgm-io.yaml b/Documentation/devicetree/bindings/pinctrl/intel,lgm-io.yaml
> index cd2b436350ef..2c0acb405e6c 100644
> --- a/Documentation/devicetree/bindings/pinctrl/intel,lgm-io.yaml
> +++ b/Documentation/devicetree/bindings/pinctrl/intel,lgm-io.yaml
> @@ -24,12 +24,10 @@ properties:
>  patternProperties:
>    '-pins$':
>      type: object
> -    allOf:
> -      - $ref: pincfg-node.yaml#
> -      - $ref: pinmux-node.yaml#
>      description:
>        Pinctrl node's client devices use subnodes for desired pin configuration.
>        Client device subnodes use below standard properties.
> +    $ref: pinmux-node.yaml#
> 
>      properties:
>        function: true
> diff --git a/Documentation/devicetree/bindings/pinctrl/pinmux-node.yaml b/Documentation/devicetree/bindings/pinctrl/pinmux-node.yaml
> index 732d9075560b..ef8877ddb1eb 100644
> --- a/Documentation/devicetree/bindings/pinctrl/pinmux-node.yaml
> +++ b/Documentation/devicetree/bindings/pinctrl/pinmux-node.yaml
> @@ -122,11 +122,10 @@ properties:
>        this, "pins" or "pinmux" has to be specified)
> 
>    pinmux:
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
>      description:
>        The list of numeric pin ids and their mux settings that properties in the
>        node apply to (either this, "pins" or "groups" have to be specified)
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> 
>    pinctrl-pin-array:
>      $ref: /schemas/types.yaml#/definitions/uint32-array
> diff --git a/Documentation/devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml
> index 46a0478cb924..e9d6e54fc0a0 100644
> --- a/Documentation/devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml
> +++ b/Documentation/devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml
> @@ -37,21 +37,18 @@ properties:
>    hwlocks: true
> 
>    st,syscfg:
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/phandle-array"
>      description: Should be phandle/offset/mask
>        - Phandle to the syscon node which includes IRQ mux selection.
>        - The offset of the IRQ mux selection register.
>        - The field mask of IRQ mux, needed if different of 0xf.
> +    $ref: "/schemas/types.yaml#/definitions/phandle-array"
> 
>    st,package:
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [1, 2, 4, 8]
>      description:
>       Indicates the SOC package used.
>       More details in include/dt-bindings/pinctrl/stm32-pinfunc.h
> -
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [1, 2, 4, 8]
> 
>  patternProperties:
>    '^gpio@[0-9a-f]*$':
> @@ -78,33 +75,31 @@ patternProperties:
>          maximum: 16
> 
>        st,bank-name:
> -        allOf:
> -          - $ref: "/schemas/types.yaml#/definitions/string"
> -          - enum:
> -            - GPIOA
> -            - GPIOB
> -            - GPIOC
> -            - GPIOD
> -            - GPIOE
> -            - GPIOF
> -            - GPIOG
> -            - GPIOH
> -            - GPIOI
> -            - GPIOJ
> -            - GPIOK
> -            - GPIOZ
>          description:
>            Should be a name string for this bank as specified in the datasheet.
> +        $ref: "/schemas/types.yaml#/definitions/string"
> +        enum:
> 
> -      st,bank-ioport:
> -        allOf:
> -          - $ref: "/schemas/types.yaml#/definitions/uint32"
> -          - minimum: 0
> -          - maximum: 11
> +          - GPIOA
> +          - GPIOB
> +          - GPIOC
> +          - GPIOD
> +          - GPIOE
> +          - GPIOF
> +          - GPIOG
> +          - GPIOH
> +          - GPIOI
> +          - GPIOJ
> +          - GPIOK
> +          - GPIOZ
> 
> +      st,bank-ioport:
>          description:
>            Should correspond to the EXTI IOport selection (EXTI line used
>            to select GPIOs as interrupts).
> +        $ref: "/schemas/types.yaml#/definitions/uint32"
> +        minimum: 0
> +        maximum: 11
> 
>      required:
>        - gpio-controller
> @@ -125,8 +120,8 @@ patternProperties:
>            configuration, pullups, drive, output high/low and output speed.
>          properties:
>            pinmux:
> -            allOf:
> -              - $ref: "/schemas/types.yaml#/definitions/uint32-array"
> +            $ref: "/schemas/types.yaml#/definitions/uint32-array"
> +
>              description: |
>                Integer array, represents gpio pin number and mux setting.
>                Supported pin number and mux varies for different SoCs, and are
> @@ -180,9 +175,8 @@ patternProperties:
>                1: Medium speed
>                2: Fast speed
>                3: High speed
> -            allOf:
> -              - $ref: /schemas/types.yaml#/definitions/uint32
> -              - enum: [0, 1, 2, 3]
> +            $ref: /schemas/types.yaml#/definitions/uint32
> +            enum: [0, 1, 2, 3]
> 
>          required:
>            - pinmux
> diff --git a/Documentation/devicetree/bindings/power/amlogic,meson-ee-pwrc.yaml b/Documentation/devicetree/bindings/power/amlogic,meson-ee-pwrc.yaml
> index 6c6079fe1351..49fd3feabba5 100644
> --- a/Documentation/devicetree/bindings/power/amlogic,meson-ee-pwrc.yaml
> +++ b/Documentation/devicetree/bindings/power/amlogic,meson-ee-pwrc.yaml
> @@ -56,8 +56,7 @@ properties:
> 
>    amlogic,ao-sysctrl:
>      description: phandle to the AO sysctrl node
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/phandle
> +    $ref: /schemas/types.yaml#/definitions/phandle
> 
>  required:
>    - compatible
> diff --git a/Documentation/devicetree/bindings/pwm/pwm-samsung.yaml b/Documentation/devicetree/bindings/pwm/pwm-samsung.yaml
> index 4fe64f4dd594..fc799b0577d4 100644
> --- a/Documentation/devicetree/bindings/pwm/pwm-samsung.yaml
> +++ b/Documentation/devicetree/bindings/pwm/pwm-samsung.yaml
> @@ -78,12 +78,11 @@ properties:
>        A list of PWM channels used as PWM outputs on particular platform.
>        It is an array of up to 5 elements being indices of PWM channels
>        (from 0 to 4), the order does not matter.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
> -      - uniqueItems: true
> -      - items:
> -          minimum: 0
> -          maximum: 4
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    uniqueItems: true
> +    items:
> +      minimum: 0
> +      maximum: 4
> 
>  required:
>    - clocks
> diff --git a/Documentation/devicetree/bindings/regulator/gpio-regulator.yaml b/Documentation/devicetree/bindings/regulator/gpio-regulator.yaml
> index 9d3b28417fb6..605590384b48 100644
> --- a/Documentation/devicetree/bindings/regulator/gpio-regulator.yaml
> +++ b/Documentation/devicetree/bindings/regulator/gpio-regulator.yaml
> @@ -46,24 +46,22 @@ properties:
>          0: LOW
>          1: HIGH
>        Default is LOW if nothing else is specified.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
> -      - maxItems: 8
> -        items:
> -          enum: [ 0, 1 ]
> -          default: 0
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    maxItems: 8
> +    items:
> +      enum: [0, 1]
> +      default: 0
> 
>    states:
>      description: Selection of available voltages/currents provided by this
>        regulator and matching GPIO configurations to achieve them. If there are
>        no states in the "states" array, use a fixed regulator instead.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-matrix
> -      - maxItems: 8
> -        items:
> -          items:
> -            - description: Voltage in microvolts
> -            - description: GPIO group state value
> +    $ref: /schemas/types.yaml#/definitions/uint32-matrix
> +    maxItems: 8
> +    items:
> +      items:
> +        - description: Voltage in microvolts
> +        - description: GPIO group state value
> 
>    startup-delay-us:
>      description: startup time in microseconds
> @@ -81,12 +79,11 @@ properties:
> 
>    regulator-type:
>      description: Specifies what is being regulated.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/string
> -      - enum:
> -          - voltage
> -          - current
> -        default: voltage
> +    $ref: /schemas/types.yaml#/definitions/string
> +    enum:
> +      - voltage
> +      - current
> +    default: voltage
> 
>  required:
>    - compatible
> diff --git a/Documentation/devicetree/bindings/regulator/mps,mpq7920.yaml b/Documentation/devicetree/bindings/regulator/mps,mpq7920.yaml
> index a682af0dc67e..e5422eaf851d 100644
> --- a/Documentation/devicetree/bindings/regulator/mps,mpq7920.yaml
> +++ b/Documentation/devicetree/bindings/regulator/mps,mpq7920.yaml
> @@ -21,17 +21,17 @@ properties:
> 
>    regulators:
>      type: object
> -    allOf:
> -      - $ref: regulator.yaml#
> +    $ref: regulator.yaml#
> +
>      description: |
>        list of regulators provided by this controller, must be named
>        after their hardware counterparts BUCK[1-4], one LDORTC, and LDO[2-5]
> 
>      properties:
>        mps,switch-freq:
> -        allOf:
> -          - $ref: "/schemas/types.yaml#/definitions/uint8"
> -        enum: [ 0, 1, 2, 3 ]
> +        $ref: "/schemas/types.yaml#/definitions/uint8"
> +
> +        enum: [0, 1, 2, 3]
>          default: 2
>          description: |
>            switching frequency must be one of following corresponding value
> @@ -40,32 +40,29 @@ properties:
>      patternProperties:
>        "^ldo[1-4]$":
>          type: object
> -        allOf:
> -          - $ref: regulator.yaml#
> +        $ref: regulator.yaml#
> 
>        "^ldortc$":
>          type: object
> -        allOf:
> -          - $ref: regulator.yaml#
> +        $ref: regulator.yaml#
> 
>        "^buck[1-4]$":
>          type: object
> -        allOf:
> -          - $ref: regulator.yaml#
> +        $ref: regulator.yaml#
> 
>          properties:
>            mps,buck-softstart:
> -            allOf:
> -              - $ref: "/schemas/types.yaml#/definitions/uint8"
> -            enum: [ 0, 1, 2, 3 ]
> +            $ref: "/schemas/types.yaml#/definitions/uint8"
> +
> +            enum: [0, 1, 2, 3]
>              description: |
>                defines the soft start time of this buck, must be one of the following
>                corresponding values 150us, 300us, 610us, 920us
> 
>            mps,buck-phase-delay:
> -            allOf:
> -              - $ref: "/schemas/types.yaml#/definitions/uint8"
> -            enum: [ 0, 1, 2, 3 ]
> +            $ref: "/schemas/types.yaml#/definitions/uint8"
> +
> +            enum: [0, 1, 2, 3]
>              description: |
>                defines the phase delay of this buck, must be one of the following
>                corresponding values 0deg, 90deg, 180deg, 270deg
> diff --git a/Documentation/devicetree/bindings/regulator/regulator.yaml b/Documentation/devicetree/bindings/regulator/regulator.yaml
> index 91a39a33000b..ec505dbbf87c 100644
> --- a/Documentation/devicetree/bindings/regulator/regulator.yaml
> +++ b/Documentation/devicetree/bindings/regulator/regulator.yaml
> @@ -123,9 +123,8 @@ properties:
>        0: Disable active discharge.
>        1: Enable active discharge.
>        Absence of this property will leave configuration to default.
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/uint32"
> -      - enum: [ 0, 1 ]
> +    $ref: "/schemas/types.yaml#/definitions/uint32"
> +    enum: [0, 1]
> 
>    regulator-coupled-with:
>      description: Regulators with which the regulator is coupled. The linkage
> diff --git a/Documentation/devicetree/bindings/regulator/rohm,bd71828-regulator.yaml b/Documentation/devicetree/bindings/regulator/rohm,bd71828-regulator.yaml
> index 71ce032b8cf8..ac74e214b050 100644
> --- a/Documentation/devicetree/bindings/regulator/rohm,bd71828-regulator.yaml
> +++ b/Documentation/devicetree/bindings/regulator/rohm,bd71828-regulator.yaml
> @@ -24,10 +24,9 @@ description: |
>  patternProperties:
>    "^LDO[1-7]$":
>      type: object
> -    allOf:
> -      - $ref: regulator.yaml#
>      description:
>        Properties for single LDO regulator.
> +    $ref: regulator.yaml#
> 
>      properties:
>        regulator-name:
> @@ -37,10 +36,9 @@ patternProperties:
> 
>    "^BUCK[1-7]$":
>      type: object
> -    allOf:
> -      - $ref: regulator.yaml#
>      description:
>        Properties for single BUCK regulator.
> +    $ref: regulator.yaml#
> 
>      properties:
>        regulator-name:
> @@ -49,40 +47,36 @@ patternProperties:
>            should be "buck1", ..., "buck7"
> 
>        rohm,dvs-run-voltage:
> -        allOf:
> -          - $ref: "/schemas/types.yaml#/definitions/uint32"
> -          - minimum: 0
> -            maximum: 3300000
>          description:
>            PMIC default "RUN" state voltage in uV. See below table for
>            bucks which support this. 0 means disabled.
> +        $ref: "/schemas/types.yaml#/definitions/uint32"
> +        minimum: 0
> +        maximum: 3300000
> 
>        rohm,dvs-idle-voltage:
> -        allOf:
> -          - $ref: "/schemas/types.yaml#/definitions/uint32"
> -          - minimum: 0
> -            maximum: 3300000
>          description:
>            PMIC default "IDLE" state voltage in uV. See below table for
>            bucks which support this. 0 means disabled.
> +        $ref: "/schemas/types.yaml#/definitions/uint32"
> +        minimum: 0
> +        maximum: 3300000
> 
>        rohm,dvs-suspend-voltage:
> -        allOf:
> -          - $ref: "/schemas/types.yaml#/definitions/uint32"
> -          - minimum: 0
> -            maximum: 3300000
>          description:
>            PMIC default "SUSPEND" state voltage in uV. See below table for
>            bucks which support this. 0 means disabled.
> +        $ref: "/schemas/types.yaml#/definitions/uint32"
> +        minimum: 0
> +        maximum: 3300000
> 
>        rohm,dvs-lpsr-voltage:
> -        allOf:
> -          - $ref: "/schemas/types.yaml#/definitions/uint32"
> -          - minimum: 0
> -            maximum: 3300000
>          description:
>            PMIC default "LPSR" state voltage in uV. See below table for
>            bucks which support this. 0 means disabled.
> +        $ref: "/schemas/types.yaml#/definitions/uint32"
> +        minimum: 0
> +        maximum: 3300000
> 
>          # Supported default DVS states:
>          #     buck       |    run     |   idle    | suspend  | lpsr
> diff --git a/Documentation/devicetree/bindings/regulator/st,stm32-booster.yaml b/Documentation/devicetree/bindings/regulator/st,stm32-booster.yaml
> index 64f1183ce841..cb336b2c16af 100644
> --- a/Documentation/devicetree/bindings/regulator/st,stm32-booster.yaml
> +++ b/Documentation/devicetree/bindings/regulator/st,stm32-booster.yaml
> @@ -23,8 +23,7 @@ properties:
>        - st,stm32mp1-booster
> 
>    st,syscfg:
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/phandle-array"
> +    $ref: "/schemas/types.yaml#/definitions/phandle-array"
>      description: phandle to system configuration controller.
> 
>    vdda-supply:
> diff --git a/Documentation/devicetree/bindings/regulator/st,stm32mp1-pwr-reg.yaml b/Documentation/devicetree/bindings/regulator/st,stm32mp1-pwr-reg.yaml
> index 8d8f38fe85dc..e6322bc3e447 100644
> --- a/Documentation/devicetree/bindings/regulator/st,stm32mp1-pwr-reg.yaml
> +++ b/Documentation/devicetree/bindings/regulator/st,stm32mp1-pwr-reg.yaml
> @@ -26,8 +26,7 @@ patternProperties:
>    "^(reg11|reg18|usb33)$":
>      type: object
> 
> -    allOf:
> -      - $ref: "regulator.yaml#"
> +    $ref: "regulator.yaml#"
> 
>  required:
>    - compatible
> diff --git a/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml b/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml
> index 4ff4d3df0a06..4ffa25268fcc 100644
> --- a/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml
> +++ b/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml
> @@ -28,22 +28,20 @@ properties:
>      maxItems: 1
> 
>    st,syscfg-holdboot:
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/phandle-array"
>      description: remote processor reset hold boot
>        - Phandle of syscon block.
>        - The offset of the hold boot setting register.
>        - The field mask of the hold boot.
> +    $ref: "/schemas/types.yaml#/definitions/phandle-array"
>      maxItems: 1
> 
>    st,syscfg-tz:
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/phandle-array"
>      description:
>        Reference to the system configuration which holds the RCC trust zone mode
>        - Phandle of syscon block.
>        - The offset of the RCC trust zone mode register.
>        - The field mask of the RCC trust zone mode.
> +    $ref: "/schemas/types.yaml#/definitions/phandle-array"
>      maxItems: 1
> 
>    interrupts:
> @@ -90,8 +88,7 @@ properties:
>        (see ../reserved-memory/reserved-memory.txt)
> 
>    st,syscfg-pdds:
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/phandle-array"
> +    $ref: "/schemas/types.yaml#/definitions/phandle-array"
>      description: |
>        Reference to the system configuration which holds the remote
>          1st cell: phandle to syscon block
> diff --git a/Documentation/devicetree/bindings/reset/intel,rcu-gw.yaml b/Documentation/devicetree/bindings/reset/intel,rcu-gw.yaml
> index 8ac437282659..6b2d56cc3f38 100644
> --- a/Documentation/devicetree/bindings/reset/intel,rcu-gw.yaml
> +++ b/Documentation/devicetree/bindings/reset/intel,rcu-gw.yaml
> @@ -21,8 +21,7 @@ properties:
> 
>    intel,global-reset:
>      description: Global reset register offset and bit offset.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>      items:
>        - description: Register offset
>        - description: Register bit offset
> diff --git a/Documentation/devicetree/bindings/riscv/cpus.yaml b/Documentation/devicetree/bindings/riscv/cpus.yaml
> index 04819ad379c2..f80ba2c66f71 100644
> --- a/Documentation/devicetree/bindings/riscv/cpus.yaml
> +++ b/Documentation/devicetree/bindings/riscv/cpus.yaml
> @@ -40,24 +40,18 @@ properties:
>        and identifies the type of the hart.
> 
>    mmu-type:
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/string"
> -      - enum:
> -          - riscv,sv32
> -          - riscv,sv39
> -          - riscv,sv48
>      description:
>        Identifies the MMU address translation mode used on this
>        hart.  These values originate from the RISC-V Privileged
>        Specification document, available from
>        https://riscv.org/specifications/
> +    $ref: "/schemas/types.yaml#/definitions/string"
> +    enum:
> +      - riscv,sv32
> +      - riscv,sv39
> +      - riscv,sv48
> 
>    riscv,isa:
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/string"
> -      - enum:
> -          - rv64imac
> -          - rv64imafdc
>      description:
>        Identifies the specific RISC-V instruction set architecture
>        supported by the hart.  These are documented in the RISC-V
> @@ -67,6 +61,10 @@ properties:
>        While the isa strings in ISA specification are case
>        insensitive, letters in the riscv,isa string must be all
>        lowercase to simplify parsing.
> +    $ref: "/schemas/types.yaml#/definitions/string"
> +    enum:
> +      - rv64imac
> +      - rv64imafdc
> 
>    # RISC-V requires 'timebase-frequency' in /cpus, so disallow it here
>    timebase-frequency: false
> diff --git a/Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml b/Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml
> index 57b087574aa1..5456604b1c14 100644
> --- a/Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml
> +++ b/Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml
> @@ -32,11 +32,10 @@ properties:
>      maxItems: 1
> 
>    st,syscfg:
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/phandle-array"
> -      - items:
> -          minItems: 3
> -          maxItems: 3
> +    $ref: "/schemas/types.yaml#/definitions/phandle-array"
> +    items:
> +      minItems: 3
> +      maxItems: 3
>      description: |
>        Phandle/offset/mask triplet. The phandle to pwrcfg used to
>        access control register at offset, and change the dbp (Disable Backup
> diff --git a/Documentation/devicetree/bindings/serial/pl011.yaml b/Documentation/devicetree/bindings/serial/pl011.yaml
> index 1a64d59152aa..c23c93b400f0 100644
> --- a/Documentation/devicetree/bindings/serial/pl011.yaml
> +++ b/Documentation/devicetree/bindings/serial/pl011.yaml
> @@ -88,17 +88,15 @@ properties:
>      description:
>        Rate at which poll occurs when auto-poll is set.
>        default 100ms.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - default: 100
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    default: 100
> 
>    poll-timeout-ms:
>      description:
>        Poll timeout when auto-poll is set, default
>        3000ms.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - default: 3000
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    default: 3000
> 
>  required:
>    - compatible
> diff --git a/Documentation/devicetree/bindings/serial/rs485.yaml b/Documentation/devicetree/bindings/serial/rs485.yaml
> index 2b8261ea6d9c..8141e4aad530 100644
> --- a/Documentation/devicetree/bindings/serial/rs485.yaml
> +++ b/Documentation/devicetree/bindings/serial/rs485.yaml
> @@ -16,20 +16,18 @@ maintainers:
>  properties:
>    rs485-rts-delay:
>      description: prop-encoded-array <a b>
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
> -      - items:
> -          items:
> -            - description:
> -                Delay between rts signal and beginning of data sent in milliseconds.
> -                It corresponds to the delay before sending data.
> -              default: 0
> -              maximum: 1000
> -            - description:
> -                Delay between end of data sent and rts signal in milliseconds.
> -                It corresponds to the delay after sending data and actual release of the line.
> -              default: 0
> -              maximum: 1000
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    items:
> +      items:
> +        - description: Delay between rts signal and beginning of data sent in
> +            milliseconds. It corresponds to the delay before sending data.
> +          default: 0
> +          maximum: 1000
> +        - description: Delay between end of data sent and rts signal in milliseconds.
> +            It corresponds to the delay after sending data and actual release
> +            of the line.
> +          default: 0
> +          maximum: 1000
> 
>    rs485-rts-active-low:
>      description: drive RTS low when sending (default is high).
> diff --git a/Documentation/devicetree/bindings/serial/samsung_uart.yaml b/Documentation/devicetree/bindings/serial/samsung_uart.yaml
> index 9d2ce347875b..ff2f49fe322c 100644
> --- a/Documentation/devicetree/bindings/serial/samsung_uart.yaml
> +++ b/Documentation/devicetree/bindings/serial/samsung_uart.yaml
> @@ -51,9 +51,8 @@ properties:
> 
>    samsung,uart-fifosize:
>      description: The fifo size supported by the UART channel.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [16, 64, 256]
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [16, 64, 256]
> 
>  required:
>    - compatible
> diff --git a/Documentation/devicetree/bindings/sound/adi,adau7118.yaml b/Documentation/devicetree/bindings/sound/adi,adau7118.yaml
> index 76ee695097bf..fb78967ee17b 100644
> --- a/Documentation/devicetree/bindings/sound/adi,adau7118.yaml
> +++ b/Documentation/devicetree/bindings/sound/adi,adau7118.yaml
> @@ -35,23 +35,21 @@ properties:
>    adi,decimation-ratio:
>      description: |
>        This property set's the decimation ratio of PDM to PCM audio data.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum: [64, 32, 16]
> -        default: 64
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [64, 32, 16]
> +    default: 64
> 
>    adi,pdm-clk-map:
>      description: |
>        The ADAU7118 has two PDM clocks for the four Inputs. Each input must be
>        assigned to one of these two clocks. This property set's the mapping
>        between the clocks and the inputs.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32-array
> -      - minItems: 4
> -        maxItems: 4
> -        items:
> -          maximum: 1
> -        default: [0, 0, 1, 1]
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    minItems: 4
> +    maxItems: 4
> +    items:
> +      maximum: 1
> +    default: [0, 0, 1, 1]
> 
>  required:
>    - "#sound-dai-cells"
> diff --git a/Documentation/devicetree/bindings/sound/allwinner,sun4i-a10-codec.yaml b/Documentation/devicetree/bindings/sound/allwinner,sun4i-a10-codec.yaml
> index ea1d2efb2aaa..98938db56285 100644
> --- a/Documentation/devicetree/bindings/sound/allwinner,sun4i-a10-codec.yaml
> +++ b/Documentation/devicetree/bindings/sound/allwinner,sun4i-a10-codec.yaml
> @@ -57,32 +57,31 @@ properties:
>        A list of the connections between audio components.  Each entry
>        is a pair of strings, the first being the connection's sink, the
>        second being the connection's source.
> -    allOf:
> -      - $ref: /schemas/types.yaml#definitions/non-unique-string-array
> -      - minItems: 2
> -        maxItems: 18
> -        items:
> -          enum:
> +    $ref: /schemas/types.yaml#definitions/non-unique-string-array
> +    minItems: 2
> +    maxItems: 18
> +    items:
> +      enum:
>              # Audio Pins on the SoC
> -            - HP
> -            - HPCOM
> -            - LINEIN
> -            - LINEOUT
> -            - MIC1
> -            - MIC2
> -            - MIC3
> +        - HP
> +        - HPCOM
> +        - LINEIN
> +        - LINEOUT
> +        - MIC1
> +        - MIC2
> +        - MIC3
> 
>              # Microphone Biases from the SoC
> -            - HBIAS
> -            - MBIAS
> +        - HBIAS
> +        - MBIAS
> 
>              # Board Connectors
> -            - Headphone
> -            - Headset Mic
> -            - Line In
> -            - Line Out
> -            - Mic
> -            - Speaker
> +        - Headphone
> +        - Headset Mic
> +        - Line In
> +        - Line Out
> +        - Mic
> +        - Speaker
> 
>    allwinner,codec-analog-controls:
>      $ref: /schemas/types.yaml#/definitions/phandle
> diff --git a/Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml b/Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml
> index a495d5fc0d23..e8f716b5f875 100644
> --- a/Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml
> +++ b/Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml
> @@ -102,8 +102,7 @@ properties:
> 
>    gpio@42:
>      type: object
> -    allOf:
> -      - $ref: ../gpio/qcom,wcd934x-gpio.yaml#
> +    $ref: ../gpio/qcom,wcd934x-gpio.yaml#
> 
>  patternProperties:
>    "^.*@[0-9a-f]+$":
> diff --git a/Documentation/devicetree/bindings/spi/renesas,sh-msiof.yaml b/Documentation/devicetree/bindings/spi/renesas,sh-msiof.yaml
> index b6c1dd2a9c5e..c8f0985a8738 100644
> --- a/Documentation/devicetree/bindings/spi/renesas,sh-msiof.yaml
> +++ b/Documentation/devicetree/bindings/spi/renesas,sh-msiof.yaml
> @@ -96,43 +96,39 @@ properties:
> 
>    renesas,dtdl:
>      description: delay sync signal (setup) in transmit mode.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum:
> -          - 0    # no bit delay
> -          - 50   # 0.5-clock-cycle delay
> -          - 100  # 1-clock-cycle delay
> -          - 150  # 1.5-clock-cycle delay
> -          - 200  # 2-clock-cycle delay
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum:
> +      - 0        # no bit delay
> +      - 50       # 0.5-clock-cycle delay
> +      - 100      # 1-clock-cycle delay
> +      - 150      # 1.5-clock-cycle delay
> +      - 200      # 2-clock-cycle delay
> 
>    renesas,syncdl:
>      description: delay sync signal (hold) in transmit mode
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - enum:
> -          - 0    # no bit delay
> -          - 50   # 0.5-clock-cycle delay
> -          - 100  # 1-clock-cycle delay
> -          - 150  # 1.5-clock-cycle delay
> -          - 200  # 2-clock-cycle delay
> -          - 300  # 3-clock-cycle delay
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum:
> +      - 0        # no bit delay
> +      - 50       # 0.5-clock-cycle delay
> +      - 100      # 1-clock-cycle delay
> +      - 150      # 1.5-clock-cycle delay
> +      - 200      # 2-clock-cycle delay
> +      - 300      # 3-clock-cycle delay
> 
>    renesas,tx-fifo-size:
>      # deprecated for soctype-specific bindings
>      description: |
>        Override the default TX fifo size.  Unit is words.  Ignored if 0.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - maxItems: 1
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    maxItems: 1
>      default: 64
> 
>    renesas,rx-fifo-size:
>      # deprecated for soctype-specific bindings
>      description: |
>        Override the default RX fifo size.  Unit is words.  Ignored if 0.
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - maxItems: 1
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    maxItems: 1
>      default: 64
> 
>  required:
> diff --git a/Documentation/devicetree/bindings/spi/spi-controller.yaml b/Documentation/devicetree/bindings/spi/spi-controller.yaml
> index d8e5509a7081..c6a2f543648b 100644
> --- a/Documentation/devicetree/bindings/spi/spi-controller.yaml
> +++ b/Documentation/devicetree/bindings/spi/spi-controller.yaml
> @@ -115,24 +115,22 @@ patternProperties:
>            Maximum SPI clocking speed of the device in Hz.
> 
>        spi-rx-bus-width:
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> -          - enum: [ 1, 2, 4, 8 ]
> -          - default: 1
>          description:
>            Bus width to the SPI bus used for read transfers.
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        enum: [1, 2, 4, 8]
> +        default: 1
> 
>        spi-rx-delay-us:
>          description:
>            Delay, in microseconds, after a read transfer.
> 
>        spi-tx-bus-width:
> -        allOf:
> -          - $ref: /schemas/types.yaml#/definitions/uint32
> -          - enum: [ 1, 2, 4, 8 ]
> -          - default: 1
>          description:
>            Bus width to the SPI bus used for write transfers.
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        enum: [1, 2, 4, 8]
> +        default: 1
> 
>        spi-tx-delay-us:
>          description:
> diff --git a/Documentation/devicetree/bindings/spi/spi-pl022.yaml b/Documentation/devicetree/bindings/spi/spi-pl022.yaml
> index 22ba4e90655b..22999024477f 100644
> --- a/Documentation/devicetree/bindings/spi/spi-pl022.yaml
> +++ b/Documentation/devicetree/bindings/spi/spi-pl022.yaml
> @@ -80,55 +80,48 @@ patternProperties:
>      properties:
>        pl022,interface:
>          description: SPI interface type
> -        allOf:
> -          - $ref: "/schemas/types.yaml#/definitions/uint32"
> -          - enum:
> -              - 0  # SPI
> -              - 1  # Texas Instruments Synchronous Serial Frame Format
> -              - 2  # Microwire (Half Duplex)
> +        $ref: "/schemas/types.yaml#/definitions/uint32"
> +        enum:
> +          - 0      # SPI
> +          - 1      # Texas Instruments Synchronous Serial Frame Format
> +          - 2      # Microwire (Half Duplex)
> 
>        pl022,com-mode:
>          description: Specifies the transfer mode
> -        allOf:
> -          - $ref: "/schemas/types.yaml#/definitions/uint32"
> -          - enum:
> -              - 0  # interrupt mode
> -              - 1  # polling mode
> -              - 2  # DMA mode
> -            default: 1
> +        $ref: "/schemas/types.yaml#/definitions/uint32"
> +        enum:
> +          - 0      # interrupt mode
> +          - 1      # polling mode
> +          - 2      # DMA mode
> +        default: 1
> 
>        pl022,rx-level-trig:
>          description: Rx FIFO watermark level
> -        allOf:
> -          - $ref: "/schemas/types.yaml#/definitions/uint32"
> -          - minimum: 0
> -            maximum: 4
> +        $ref: "/schemas/types.yaml#/definitions/uint32"
> +        minimum: 0
> +        maximum: 4
> 
>        pl022,tx-level-trig:
>          description: Tx FIFO watermark level
> -        allOf:
> -          - $ref: "/schemas/types.yaml#/definitions/uint32"
> -          - minimum: 0
> -            maximum: 4
> +        $ref: "/schemas/types.yaml#/definitions/uint32"
> +        minimum: 0
> +        maximum: 4
> 
>        pl022,ctrl-len:
>          description: Microwire interface - Control length
> -        allOf:
> -          - $ref: "/schemas/types.yaml#/definitions/uint32"
> -          - minimum: 0x03
> -            maximum: 0x1f
> +        $ref: "/schemas/types.yaml#/definitions/uint32"
> +        minimum: 0x03
> +        maximum: 0x1f
> 
>        pl022,wait-state:
>          description: Microwire interface - Wait state
> -        allOf:
> -          - $ref: "/schemas/types.yaml#/definitions/uint32"
> -          - enum: [ 0, 1 ]
> +        $ref: "/schemas/types.yaml#/definitions/uint32"
> +        enum: [0, 1]
> 
>        pl022,duplex:
>          description: Microwire interface - Full/Half duplex
> -        allOf:
> -          - $ref: "/schemas/types.yaml#/definitions/uint32"
> -          - enum: [ 0, 1 ]
> +        $ref: "/schemas/types.yaml#/definitions/uint32"
> +        enum: [0, 1]
> 
>  required:
>    - compatible
> diff --git a/Documentation/devicetree/bindings/spi/spi-sifive.yaml b/Documentation/devicetree/bindings/spi/spi-sifive.yaml
> index 140e4351a19f..28040598bfae 100644
> --- a/Documentation/devicetree/bindings/spi/spi-sifive.yaml
> +++ b/Documentation/devicetree/bindings/spi/spi-sifive.yaml
> @@ -50,18 +50,16 @@ properties:
>    sifive,fifo-depth:
>      description:
>        Depth of hardware queues; defaults to 8
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/uint32"
> -      - enum: [ 8 ]
> -      - default: 8
> +    $ref: "/schemas/types.yaml#/definitions/uint32"
> +    enum: [8]
> +    default: 8
> 
>    sifive,max-bits-per-word:
>      description:
>        Maximum bits per word; defaults to 8
> -    allOf:
> -      - $ref: "/schemas/types.yaml#/definitions/uint32"
> -      - enum: [ 0, 1, 2, 3, 4, 5, 6, 7, 8 ]
> -      - default: 8
> +    $ref: "/schemas/types.yaml#/definitions/uint32"
> +    enum: [0, 1, 2, 3, 4, 5, 6, 7, 8]
> +    default: 8
> 
>  required:
>    - compatible
> diff --git a/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml b/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
> index 2ddd39d96766..d7be931b42d2 100644
> --- a/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
> +++ b/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
> @@ -73,12 +73,11 @@ properties:
>        - const: calib_sel
> 
>    "#qcom,sensors":
> -    allOf:
> -      - $ref: /schemas/types.yaml#/definitions/uint32
> -      - minimum: 1
> -      - maximum: 16
>      description:
>        Number of sensors enabled on this platform
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    minimum: 1
> +    maximum: 16
> 
>    "#thermal-sensor-cells":
>      const: 1
> diff --git a/Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.yaml b/Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.yaml
> index 6ff718ede184..d83a1f97f911 100644
> --- a/Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.yaml
> +++ b/Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.yaml
> @@ -65,10 +65,9 @@ patternProperties:
>      description: A timer node has up to 8 frame sub-nodes, each with the following properties.
>      properties:
>        frame-number:
> -        allOf:
> -          - $ref: "/schemas/types.yaml#/definitions/uint32"
> -          - minimum: 0
> -            maximum: 7
> +        $ref: "/schemas/types.yaml#/definitions/uint32"
> +        minimum: 0
> +        maximum: 7
> 
>        interrupts:
>          minItems: 1
> --
> 2.20.1

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
