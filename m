Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D961AB9BE
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 09:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439243AbgDPHVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 03:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439227AbgDPHVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 03:21:42 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF903C08C5F2
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 00:21:33 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id v8so1788919wma.0
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 00:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=PfcEIjHVOwJJoI3IG1yq+hLuJEPuCeMcpBtriOzJSVE=;
        b=fWro629AKCHe7c1PY8qWNnc/MO1FUAtCQOwruVmdsj4Kyvr1SDGr9Xgc/VGuT4Ao08
         aszgwv1hJNkmDxBtLtWK7K2S9mv6z5/c8TCmg4n+kwj4eAnnvC2Dt4pvdKuMnlfnbcGf
         puxMyauwUmvCn/LNyQLnyjFrS1Kzkios1/MsF6m/I4GPnRVdRC2+tstnjmmO650ZwQzj
         4aWRTSNgkZKvvDPkpZ/B7oqv4O1vvl2M0bRRRPUNQCjnZDrbzcP/JjjuClCaNvbDFuVJ
         cZP/dedvaVFsRZKmIeGsiWSNvkLi9aAZR4c6U1deMU+GHzWLDixE4IBaBhe7BLuqYxXC
         CRaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PfcEIjHVOwJJoI3IG1yq+hLuJEPuCeMcpBtriOzJSVE=;
        b=LvvssJHi6wk78Z9Nd4LvHedXLHqrTf049CeaXCTrdmj3S2N1EMf3q0G/x3J8POSdcK
         rBgQRBNf9Uw2+TBqtc9Ej7F7vaD3PiwMJLINocbJlKqwxv6lpmxM37/WMz3xYpFSYKQS
         NXM0YNAQtUrbiaC9n8KozYDT0Sp7/p/cUo/bc/humOs8YFY3rj5HBbkI5yHUaNY7k4vE
         HvyJoWCxUjx+EfRkUsz6ANuPibvg7VgARwLG58u7NwfG2Hwxf+Q2rfjGHWArQOC6+joi
         o7nI6anziHzFOEZHuh6yfFaVRBlOO4Ii48EtCXuU0L33sY2QimlBrPsW1ei4LIpHjO1Z
         LoCg==
X-Gm-Message-State: AGi0PuZUsu/X5EBGbzzMEsbTcvkyRSCDiefqgSTk/1/Ses6VpwRbZlpL
        welQy+nJdvQ9Dh4NXpTggMCVpA==
X-Google-Smtp-Source: APiQypKxoroogYo0WPMcKERsdRMrzAoaU5nNn92qAMbIpRzZIzICMY0kveTYaemzAUSe6fR6V9LLBA==
X-Received: by 2002:a1c:990d:: with SMTP id b13mr3217540wme.179.1587021691888;
        Thu, 16 Apr 2020 00:21:31 -0700 (PDT)
Received: from dell ([95.149.164.124])
        by smtp.gmail.com with ESMTPSA id h188sm2608116wme.8.2020.04.16.00.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 00:21:31 -0700 (PDT)
Date:   Thu, 16 Apr 2020 08:22:31 +0100
From:   Lee Jones <lee.jones@linaro.org>
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
Message-ID: <20200416072231.GT2167633@dell>
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

On Wed, 15 Apr 2020, Rob Herring wrote:

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

Acked-by: Lee Jones <lee.jones@linaro.org>

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

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
