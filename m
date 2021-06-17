Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C47B3AB8EB
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 18:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbhFQQLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 12:11:08 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:37854 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233682AbhFQQKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 12:10:01 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 15HG62FL083373;
        Thu, 17 Jun 2021 11:06:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1623945962;
        bh=LVkWEpy5e6cRZkuXdEoUXgk9+WHo500mtyYaCdD+Lf0=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=jeALzHLk3n7+qQeuxED/H4L5B0pUGfd+IKm4cHUnNDcbGNi/N/vECD6HccgWs8Rdc
         A79ZIeBKglC2uQcNptT6Rqq9rI3jaHqWmNvG1vKe80Rl9RF+rCyfhlpGUEyO1JBVae
         q2yQKhqF9u2BVEw+7gi7jwzlSE7Jbm56DgmZH8PQ=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 15HG60jb058606
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Jun 2021 11:06:01 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 17
 Jun 2021 11:06:00 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Thu, 17 Jun 2021 11:06:00 -0500
Received: from [10.250.36.147] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 15HG5xDj116986;
        Thu, 17 Jun 2021 11:05:59 -0500
Subject: Re: [PATCH] dt-bindings: Drop redundant minItems/maxItems
To:     Rob Herring <robh@kernel.org>, <devicetree@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>, <alsa-devel@alsa-project.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Guenter Roeck <linux@roeck-us.net>,
        <linux-iio@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        <linux-remoteproc@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        <dri-devel@lists.freedesktop.org>, <linux-ide@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <linux-phy@lists.infradead.org>,
        <linux-riscv@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>, <linux-clk@vger.kernel.org>,
        <linux-rtc@vger.kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Marc Zyngier <maz@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        David Airlie <airlied@linux.ie>,
        <linux-serial@vger.kernel.org>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        <linux-media@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        <linux-pwm@vger.kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
        <linux-watchdog@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-can@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>, <netdev@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        <linux-usb@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-spi@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        <linux-crypto@vger.kernel.org>, Daniel Vetter <daniel@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <dmaengine@vger.kernel.org>, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <jic23@kernel.org>
References: <20210615191543.1043414-1-robh@kernel.org>
From:   Suman Anna <s-anna@ti.com>
Message-ID: <bb8c18f6-139d-76be-87e7-0c93e03cc92c@ti.com>
Date:   Thu, 17 Jun 2021 11:05:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210615191543.1043414-1-robh@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On 6/15/21 2:15 PM, Rob Herring wrote:
> If a property has an 'items' list, then a 'minItems' or 'maxItems' with the
> same size as the list is redundant and can be dropped. Note that is DT
> schema specific behavior and not standard json-schema behavior. The tooling
> will fixup the final schema adding any unspecified minItems/maxItems.
> 
> This condition is partially checked with the meta-schema already, but
> only if both 'minItems' and 'maxItems' are equal to the 'items' length.
> An improved meta-schema is pending.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Cc: Kamal Dasu <kdasu.kdev@gmail.com>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Jassi Brar <jassisinghbrar@gmail.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Vivien Didelot <vivien.didelot@gmail.com>
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Cc: Paul Walmsley <paul.walmsley@sifive.com>
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Albert Ou <aou@eecs.berkeley.edu>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../devicetree/bindings/ata/nvidia,tegra-ahci.yaml          | 1 -
>  .../devicetree/bindings/clock/allwinner,sun4i-a10-ccu.yaml  | 2 --
>  .../devicetree/bindings/clock/qcom,gcc-apq8064.yaml         | 1 -
>  Documentation/devicetree/bindings/clock/qcom,gcc-sdx55.yaml | 2 --
>  .../devicetree/bindings/clock/qcom,gcc-sm8350.yaml          | 2 --
>  .../devicetree/bindings/clock/sprd,sc9863a-clk.yaml         | 1 -
>  .../devicetree/bindings/crypto/allwinner,sun8i-ce.yaml      | 2 --
>  Documentation/devicetree/bindings/crypto/fsl-dcp.yaml       | 1 -
>  .../display/allwinner,sun4i-a10-display-backend.yaml        | 6 ------
>  .../bindings/display/allwinner,sun6i-a31-mipi-dsi.yaml      | 1 -
>  .../bindings/display/allwinner,sun8i-a83t-dw-hdmi.yaml      | 4 ----
>  .../bindings/display/allwinner,sun8i-a83t-hdmi-phy.yaml     | 2 --
>  .../bindings/display/allwinner,sun8i-r40-tcon-top.yaml      | 2 --
>  .../devicetree/bindings/display/bridge/cdns,mhdp8546.yaml   | 2 --
>  .../bindings/display/rockchip/rockchip,dw-hdmi.yaml         | 2 --
>  Documentation/devicetree/bindings/display/st,stm32-dsi.yaml | 2 --
>  .../devicetree/bindings/display/st,stm32-ltdc.yaml          | 1 -
>  .../devicetree/bindings/display/xlnx/xlnx,zynqmp-dpsub.yaml | 4 ----
>  .../devicetree/bindings/dma/renesas,rcar-dmac.yaml          | 1 -
>  .../devicetree/bindings/edac/amazon,al-mc-edac.yaml         | 2 --
>  Documentation/devicetree/bindings/eeprom/at24.yaml          | 1 -
>  Documentation/devicetree/bindings/example-schema.yaml       | 2 --
>  Documentation/devicetree/bindings/gpu/brcm,bcm-v3d.yaml     | 1 -
>  Documentation/devicetree/bindings/gpu/vivante,gc.yaml       | 1 -
>  Documentation/devicetree/bindings/i2c/brcm,brcmstb-i2c.yaml | 1 -
>  .../devicetree/bindings/i2c/marvell,mv64xxx-i2c.yaml        | 2 --
>  .../devicetree/bindings/i2c/mellanox,i2c-mlxbf.yaml         | 1 -
>  .../devicetree/bindings/iio/adc/amlogic,meson-saradc.yaml   | 1 -
>  .../devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml     | 2 --
>  .../bindings/interrupt-controller/fsl,irqsteer.yaml         | 1 -
>  .../bindings/interrupt-controller/loongson,liointc.yaml     | 1 -
>  Documentation/devicetree/bindings/iommu/arm,smmu-v3.yaml    | 1 -
>  .../devicetree/bindings/iommu/renesas,ipmmu-vmsa.yaml       | 1 -
>  .../devicetree/bindings/mailbox/st,stm32-ipcc.yaml          | 2 --
>  .../devicetree/bindings/media/amlogic,gx-vdec.yaml          | 1 -
>  Documentation/devicetree/bindings/media/i2c/adv7604.yaml    | 1 -
>  .../devicetree/bindings/media/marvell,mmp2-ccic.yaml        | 1 -
>  .../devicetree/bindings/media/qcom,sc7180-venus.yaml        | 1 -
>  .../devicetree/bindings/media/qcom,sdm845-venus-v2.yaml     | 1 -
>  .../devicetree/bindings/media/qcom,sm8250-venus.yaml        | 1 -
>  Documentation/devicetree/bindings/media/renesas,drif.yaml   | 1 -
>  .../bindings/memory-controllers/mediatek,smi-common.yaml    | 6 ++----
>  .../bindings/memory-controllers/mediatek,smi-larb.yaml      | 1 -
>  .../devicetree/bindings/mmc/allwinner,sun4i-a10-mmc.yaml    | 2 --
>  Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml    | 1 -
>  Documentation/devicetree/bindings/mmc/mtk-sd.yaml           | 2 --
>  Documentation/devicetree/bindings/mmc/renesas,sdhi.yaml     | 2 --
>  Documentation/devicetree/bindings/mmc/sdhci-am654.yaml      | 1 -
>  Documentation/devicetree/bindings/mmc/sdhci-pxa.yaml        | 1 -
>  .../devicetree/bindings/net/amlogic,meson-dwmac.yaml        | 2 --
>  .../devicetree/bindings/net/brcm,bcm4908-enet.yaml          | 2 --
>  Documentation/devicetree/bindings/net/can/bosch,m_can.yaml  | 2 --
>  Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml     | 2 --
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml       | 2 --
>  Documentation/devicetree/bindings/net/stm32-dwmac.yaml      | 1 -
>  Documentation/devicetree/bindings/pci/brcm,stb-pcie.yaml    | 2 --
>  Documentation/devicetree/bindings/pci/loongson.yaml         | 1 -
>  .../devicetree/bindings/pci/mediatek-pcie-gen3.yaml         | 1 -
>  .../devicetree/bindings/pci/microchip,pcie-host.yaml        | 2 --
>  Documentation/devicetree/bindings/perf/arm,cmn.yaml         | 1 -
>  .../devicetree/bindings/phy/brcm,bcm63xx-usbh-phy.yaml      | 1 -
>  .../devicetree/bindings/phy/brcm,brcmstb-usb-phy.yaml       | 3 ---
>  Documentation/devicetree/bindings/phy/brcm,sata-phy.yaml    | 1 -
>  Documentation/devicetree/bindings/phy/mediatek,tphy.yaml    | 2 --
>  .../devicetree/bindings/phy/phy-cadence-sierra.yaml         | 2 --
>  .../devicetree/bindings/phy/phy-cadence-torrent.yaml        | 4 ----
>  .../devicetree/bindings/phy/qcom,ipq806x-usb-phy-hs.yaml    | 1 -
>  .../devicetree/bindings/phy/qcom,ipq806x-usb-phy-ss.yaml    | 1 -
>  Documentation/devicetree/bindings/phy/qcom,qmp-phy.yaml     | 1 -
>  Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml   | 2 --
>  Documentation/devicetree/bindings/phy/renesas,usb2-phy.yaml | 2 --
>  Documentation/devicetree/bindings/phy/renesas,usb3-phy.yaml | 1 -
>  .../devicetree/bindings/pinctrl/actions,s500-pinctrl.yaml   | 1 -
>  .../devicetree/bindings/power/amlogic,meson-ee-pwrc.yaml    | 1 -
>  .../devicetree/bindings/pwm/allwinner,sun4i-a10-pwm.yaml    | 1 -
>  .../devicetree/bindings/remoteproc/st,stm32-rproc.yaml      | 2 --
>  .../devicetree/bindings/remoteproc/ti,k3-dsp-rproc.yaml     | 1 -
>  .../devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml  | 1 -
>  Documentation/devicetree/bindings/reset/fsl,imx-src.yaml    | 1 -
>  .../devicetree/bindings/riscv/sifive-l2-cache.yaml          | 1 -
>  .../devicetree/bindings/rtc/allwinner,sun6i-a31-rtc.yaml    | 1 -
>  Documentation/devicetree/bindings/rtc/imxdi-rtc.yaml        | 1 -
>  Documentation/devicetree/bindings/serial/fsl-lpuart.yaml    | 2 --
>  Documentation/devicetree/bindings/serial/samsung_uart.yaml  | 1 -
>  .../devicetree/bindings/soc/qcom/qcom,geni-se.yaml          | 1 -
>  Documentation/devicetree/bindings/soc/ti/ti,pruss.yaml      | 2 --
>  .../bindings/sound/nvidia,tegra-audio-graph-card.yaml       | 1 -
>  .../devicetree/bindings/sound/nvidia,tegra210-i2s.yaml      | 2 --
>  Documentation/devicetree/bindings/sound/st,stm32-sai.yaml   | 3 ---
>  .../devicetree/bindings/spi/amlogic,meson-gx-spicc.yaml     | 1 -
>  .../devicetree/bindings/spi/brcm,spi-bcm-qspi.yaml          | 2 --
>  .../bindings/thermal/allwinner,sun8i-a83t-ths.yaml          | 2 --
>  Documentation/devicetree/bindings/thermal/qcom-tsens.yaml   | 1 -
>  .../bindings/timer/allwinner,sun5i-a13-hstimer.yaml         | 1 -
>  Documentation/devicetree/bindings/timer/arm,arch_timer.yaml | 1 -
>  .../devicetree/bindings/timer/arm,arch_timer_mmio.yaml      | 2 --
>  .../devicetree/bindings/timer/intel,ixp4xx-timer.yaml       | 1 -
>  .../devicetree/bindings/usb/maxim,max3420-udc.yaml          | 2 --
>  .../devicetree/bindings/usb/nvidia,tegra-xudc.yaml          | 4 ----
>  Documentation/devicetree/bindings/usb/renesas,usbhs.yaml    | 3 ---
>  .../devicetree/bindings/watchdog/st,stm32-iwdg.yaml         | 1 -
>  101 files changed, 2 insertions(+), 163 deletions(-)
> 

[snip]

> diff --git a/Documentation/devicetree/bindings/remoteproc/ti,k3-dsp-rproc.yaml b/Documentation/devicetree/bindings/remoteproc/ti,k3-dsp-rproc.yaml
> index 6070456a7b67..f399743b631b 100644
> --- a/Documentation/devicetree/bindings/remoteproc/ti,k3-dsp-rproc.yaml
> +++ b/Documentation/devicetree/bindings/remoteproc/ti,k3-dsp-rproc.yaml
> @@ -57,7 +57,6 @@ properties:
>  
>    memory-region:
>      minItems: 2
> -    maxItems: 8
>      description: |
>        phandle to the reserved memory nodes to be associated with the remoteproc
>        device. There should be at least two reserved memory nodes defined. The

Does this enforce the maxItems to be 2 only now? Or should this be dropping the
minItems here which matches the length of items instead of maxItems?

I have originally listed the individual item list only for the mandatory items
and rest are scalable. I provided this through "additionalItems: true" under
this property.

Also, have the exact same usage in
Documentation/devicetree/bindings/remoteproc/ti,k3-r5f-rproc.yaml as well which
is not included in this patch.

> diff --git a/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml b/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml
> index 73400bc6e91d..75161f191ac3 100644
> --- a/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml
> +++ b/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml
> @@ -116,7 +116,6 @@ properties:
>        list, in the specified order, each representing the corresponding
>        internal RAM memory region.
>      minItems: 1
> -    maxItems: 3
>      items:
>        - const: l2ram
>        - const: l1pram


[snip]

> diff --git a/Documentation/devicetree/bindings/soc/ti/ti,pruss.yaml b/Documentation/devicetree/bindings/soc/ti/ti,pruss.yaml
> index dbc62821c60b..9790617af1bc 100644
> --- a/Documentation/devicetree/bindings/soc/ti/ti,pruss.yaml
> +++ b/Documentation/devicetree/bindings/soc/ti/ti,pruss.yaml
> @@ -100,7 +100,6 @@ patternProperties:
>      properties:
>        reg:
>          minItems: 2 # On AM437x one of two PRUSS units don't contain Shared RAM.
> -        maxItems: 3
>          items:
>            - description: Address and size of the Data RAM0.
>            - description: Address and size of the Data RAM1.
> @@ -111,7 +110,6 @@ patternProperties:
>  
>        reg-names:
>          minItems: 2
> -        maxItems: 3
>          items:
>            - const: dram0
>            - const: dram1


regards
Suman
