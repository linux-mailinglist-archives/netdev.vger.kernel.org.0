Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534601AB9AC
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 09:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439131AbgDPHTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 03:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2438730AbgDPHTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 03:19:25 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404D0C03C1A7
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 00:19:20 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id i10so3514526wrv.10
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 00:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=3AEaWn5XeJ7hcX74F4NzwZbogUqZr77xLF5d73BlBfw=;
        b=x+7x1SRD1y/LTZJxHdO7NBoPBhyXEErUVgwIai9Txb2aqME7MbBYVN8PkA7MmFMlG/
         +PTNeDQuJeOieuyql513BpDrE+TR0fX/mGtYOkCA4N6z7VRTvWgnydlKHHjdN1pHbDi6
         FcrLT7q9Xm6W6XF2DKy+sVxRvrx2e8zXuCLbQfQ8d2nPd/iJ34SsziQVe8hgIZhAVDz1
         X39oeCEgZoTyWJybNtbP4u4Ik4a22WiM6sS1Gf+7ektT/jxfmy4EaiaU+raISKCA976c
         DL5uziLMISTg53DG/aGMYXA9DS9lwHatzi8LUvPjSHKrnZk+uf82Nr0GKjoaC8YAX62l
         Ovyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3AEaWn5XeJ7hcX74F4NzwZbogUqZr77xLF5d73BlBfw=;
        b=XwrfEOB080iKEPPE+3KOC0RUKNk3nGxXp+1ZoIWzSJ1yvkG39luJoJeeXVaFOV9au/
         +26R+ZkZEuZ5cY1yBvkYt97En7wdcWIa/17qvumA72uSpEXNc7FICYbqc3sISvW08NTf
         EQpOIGGpb4Ix96w1HStQ38U5G+vQix+D+Cz8sM8/FwfwWKlX0OtG+n/OSXi8nFqcoYI5
         exbWpqZIDPLmMwWv5KNvhloi1l2BU6CXsb0YtyRlJV0Yz4Uz3+ANTgY/78nHkILchcyU
         Sd3ktgEMgz/6xksLcPLlHoc4mnzQk7VtMQ9gsDd/cbR/n7Ws1uthldfcTkJjqyWFoac5
         4JYw==
X-Gm-Message-State: AGi0PuYD0EnzeCIzcoG7bCMlxeK/mrgSr3VUdlGpFus8OZ7MTL4SqRD+
        1UoSn192qHxjql74kWC6TDTtQQ==
X-Google-Smtp-Source: APiQypLCNVZBL4RMlNf7UZFX5oU2xDT6SF7MjxuD7BsWZie9pUbnFA9tcL+f+7W6lePE+UdiJ1fBjg==
X-Received: by 2002:adf:e4cc:: with SMTP id v12mr8967305wrm.106.1587021558557;
        Thu, 16 Apr 2020 00:19:18 -0700 (PDT)
Received: from dell ([95.149.164.124])
        by smtp.gmail.com with ESMTPSA id p16sm19943946wro.21.2020.04.16.00.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 00:19:17 -0700 (PDT)
Date:   Thu, 16 Apr 2020 08:20:18 +0100
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
Subject: Re: [PATCH 1/2] dt-bindings: Clean-up schema indentation formatting
Message-ID: <20200416072018.GS2167633@dell>
References: <20200416005549.9683-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200416005549.9683-1-robh@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Apr 2020, Rob Herring wrote:

> Fix various inconsistencies in schema indentation. Most of these are
> list indentation which should be 2 spaces more than the start of the
> enclosing keyword. This doesn't matter functionally, but affects running
> scripts which do transforms on the schema files.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../devicetree/bindings/arm/altera.yaml       |  6 +-
>  .../amlogic/amlogic,meson-gx-ao-secure.yaml   |  2 +-
>  .../devicetree/bindings/arm/bitmain.yaml      |  2 +-
>  .../devicetree/bindings/arm/nxp/lpc32xx.yaml  |  9 ++-
>  .../bindings/arm/socionext/uniphier.yaml      | 26 ++++----
>  .../bindings/arm/stm32/st,mlahb.yaml          |  2 +-
>  .../bindings/arm/stm32/st,stm32-syscon.yaml   |  6 +-
>  .../bindings/ata/faraday,ftide010.yaml        |  4 +-
>  .../bindings/bus/allwinner,sun8i-a23-rsb.yaml |  4 +-
>  .../clock/allwinner,sun4i-a10-gates-clk.yaml  |  8 +--
>  .../devicetree/bindings/clock/fsl,plldig.yaml | 17 +++--
>  .../devicetree/bindings/clock/qcom,mmcc.yaml  | 16 ++---
>  .../bindings/connector/usb-connector.yaml     |  6 +-
>  .../crypto/allwinner,sun4i-a10-crypto.yaml    | 14 ++--
>  .../bindings/crypto/allwinner,sun8i-ce.yaml   | 16 ++---
>  .../bindings/crypto/amlogic,gxl-crypto.yaml   |  2 +-
>  .../display/allwinner,sun4i-a10-hdmi.yaml     | 40 ++++++------
>  .../display/allwinner,sun4i-a10-tcon.yaml     | 58 ++++++++---------
>  .../display/allwinner,sun6i-a31-mipi-dsi.yaml | 28 ++++----
>  .../display/allwinner,sun8i-a83t-dw-hdmi.yaml | 10 +--
>  .../bindings/display/bridge/lvds-codec.yaml   | 18 +++---
>  .../display/panel/sony,acx424akp.yaml         |  2 +-
>  .../display/panel/xinpeng,xpp055c272.yaml     |  4 +-
>  .../bindings/display/renesas,cmm.yaml         | 16 ++---
>  .../devicetree/bindings/dma/ti/k3-udma.yaml   |  8 +--
>  .../bindings/gpio/brcm,xgs-iproc-gpio.yaml    |  2 +-
>  .../bindings/gpu/arm,mali-midgard.yaml        | 18 +++---
>  .../devicetree/bindings/gpu/vivante,gc.yaml   |  2 +-
>  .../devicetree/bindings/i2c/i2c-rk3x.yaml     | 10 +--
>  .../bindings/iio/adc/adi,ad7124.yaml          |  4 +-
>  .../bindings/iio/adc/lltc,ltc2496.yaml        |  6 +-
>  .../input/allwinner,sun4i-a10-lradc-keys.yaml |  4 +-
>  .../bindings/input/touchscreen/goodix.yaml    |  2 +-
>  .../bindings/interconnect/qcom,msm8916.yaml   |  4 +-
>  .../bindings/interconnect/qcom,msm8974.yaml   |  4 +-
>  .../bindings/interconnect/qcom,qcs404.yaml    |  4 +-
>  .../allwinner,sun7i-a20-sc-nmi.yaml           | 12 ++--
>  .../intel,ixp4xx-interrupt.yaml               |  8 +--
>  .../interrupt-controller/st,stm32-exti.yaml   | 12 ++--
>  .../bindings/iommu/samsung,sysmmu.yaml        | 10 +--
>  .../bindings/mailbox/st,stm32-ipcc.yaml       |  2 +-
>  .../media/allwinner,sun4i-a10-csi.yaml        | 28 ++++----
>  .../bindings/media/amlogic,gx-vdec.yaml       | 14 ++--
>  .../bindings/media/renesas,ceu.yaml           | 28 ++++----
>  .../bindings/media/renesas,vin.yaml           |  8 +--
>  .../devicetree/bindings/media/ti,vpe.yaml     |  2 +-
>  .../memory-controllers/fsl/imx8m-ddrc.yaml    |  6 +-

>  .../bindings/mfd/st,stm32-lptimer.yaml        |  4 +-
>  .../bindings/mfd/st,stm32-timers.yaml         |  4 +-
>  .../devicetree/bindings/mfd/syscon.yaml       | 12 ++--

Acked-by: Lee Jones <lee.jones@linaro.org>

>  .../devicetree/bindings/mmc/cdns,sdhci.yaml   |  2 +-
>  .../bindings/mmc/rockchip-dw-mshc.yaml        | 16 ++---
>  .../bindings/mmc/socionext,uniphier-sd.yaml   | 14 ++--
>  .../devicetree/bindings/mtd/denali,nand.yaml  |  4 +-
>  .../net/allwinner,sun8i-a83t-emac.yaml        |  4 +-
>  .../bindings/net/can/bosch,m_can.yaml         | 52 +++++++--------
>  .../bindings/net/renesas,ether.yaml           |  4 +-
>  .../bindings/net/ti,cpsw-switch.yaml          | 12 ++--
>  .../bindings/net/ti,davinci-mdio.yaml         | 27 ++++----
>  .../bindings/phy/intel,lgm-emmc-phy.yaml      |  2 +-
>  .../devicetree/bindings/pwm/pwm-samsung.yaml  | 16 ++---
>  .../bindings/remoteproc/st,stm32-rproc.yaml   |  2 +-
>  .../reset/brcm,bcm7216-pcie-sata-rescal.yaml  |  4 +-
>  .../devicetree/bindings/rtc/st,stm32-rtc.yaml | 38 +++++------
>  .../bindings/serial/amlogic,meson-uart.yaml   | 16 ++---
>  .../devicetree/bindings/serial/rs485.yaml     | 17 ++---
>  .../bindings/soc/amlogic/amlogic,canvas.yaml  | 10 +--
>  .../bindings/sound/renesas,fsi.yaml           | 16 ++---
>  .../bindings/spi/qcom,spi-qcom-qspi.yaml      | 10 +--
>  .../devicetree/bindings/spi/renesas,hspi.yaml |  4 +-
>  .../devicetree/bindings/spi/spi-pl022.yaml    |  2 +-
>  .../bindings/spi/st,stm32-qspi.yaml           |  4 +-
>  .../allwinner,sun4i-a10-system-control.yaml   | 64 +++++++++----------
>  .../bindings/thermal/amlogic,thermal.yaml     | 10 +--
>  .../bindings/timer/arm,arch_timer.yaml        |  4 +-
>  .../bindings/timer/arm,arch_timer_mmio.yaml   |  4 +-
>  .../devicetree/bindings/usb/dwc2.yaml         |  8 +--
>  77 files changed, 450 insertions(+), 450 deletions(-)

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
