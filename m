Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2582D3AB507
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 15:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbhFQNld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 09:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbhFQNlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 09:41:24 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1D8C061574;
        Thu, 17 Jun 2021 06:39:16 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id a6so3225210ioe.0;
        Thu, 17 Jun 2021 06:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8uLouHcYHuvh5T6xM8yIVrzF523FcxAB8VCcMY44PSs=;
        b=DrkJglOKwg+WmIiFFG6K712yfI6x/RLf5UEIcKJydGaOBMRZNFam7wWwsGYeL6N5JC
         40XbFWouWd4QbPoLw8juqNhDZjeFW8IIRYwllHXIDFq7EEBSOdqop4JrK/NiPWcrxHZP
         /7Xin9xwWygH3SObqeMvZKjZ2iaQKa1insYgEv0RWSpNGlKsE4RoDeEL46eBil9pauhu
         NNEsvRKP+YC8j+BjCLOuR9lNaBR92oHV3zowMDb2lWi+WdOnuqIjH2NQUK2KvphQxb1t
         hK2dV+lsVMmfmM0S2aVlI4PLW+ESdaXkuzI8NPiT9kFyN0CohBvacdSflevgnk8XhAvL
         2/nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8uLouHcYHuvh5T6xM8yIVrzF523FcxAB8VCcMY44PSs=;
        b=UmvHzrrm1XoMTphnbEhgZho3vQQozBoUG9e497vImcNb7/N4rrHRPh0us3T5opzGKG
         c25fJdQQfCNQkdhSMg4WZBNDtBB4kajxQxmwi8hQMqiQK9KK8ptyfxkXOPJGvXLp7Iqd
         Ahclu1nWudjxZaPwpn0MkbnC0QkrIcmHX5ufGppAkoWJHzNq4D9jWT1Zbn+ze66QMKyE
         k/6bn41x8pLJ2i8yWRjJMSNw1uZMJHRx3IzNUumuzXCXFQzlQn7plorqLVJX32361Hav
         +peDKGXiI7oRpp5hmPwiCJkuRmwyFti1qpVcolsWjAdapHlSmW0nGkXuOEwjC3H7Omek
         y9pA==
X-Gm-Message-State: AOAM531q429JijDXscApyyjVwEp0RhfgdwpFDsH1d0jDZOoO6md27W0D
        1go6JUQNmEoLhtr3Ku9vOorpIgpj4rVsNxfJdYo=
X-Google-Smtp-Source: ABdhPJxnfkeEWGUJgQcDn0I2Ve0wSFkY7REYvBKyja2+qam6LK577H+YFA9dEQrKZJ960bwwySGIDnthxfzoxsKE1u0=
X-Received: by 2002:a5d:97d9:: with SMTP id k25mr3918157ios.197.1623937155671;
 Thu, 17 Jun 2021 06:39:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210615191543.1043414-1-robh@kernel.org>
In-Reply-To: <20210615191543.1043414-1-robh@kernel.org>
From:   Jassi Brar <jassisinghbrar@gmail.com>
Date:   Thu, 17 Jun 2021 08:39:04 -0500
Message-ID: <CABb+yY1hR8=7Bc7tw8koqNd2_r0-P6HiHkoyb0j=C7QbN4Dvrw@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: Drop redundant minItems/maxItems
To:     Rob Herring <robh@kernel.org>
Cc:     Devicetree List <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-crypto@vger.kernel.org, dri-devel@lists.freedesktop.org,
        dmaengine@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-iio@vger.kernel.org, alsa-devel@alsa-project.org,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        linux-can@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org,
        linux-spi <linux-spi@vger.kernel.org>, linux-pm@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Stephen Boyd <sboyd@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Vinod Koul <vkoul@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Lee Jones <lee.jones@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 2:15 PM Rob Herring <robh@kernel.org> wrote:
>
> If a property has an 'items' list, then a 'minItems' or 'maxItems' with t=
he
> same size as the list is redundant and can be dropped. Note that is DT
> schema specific behavior and not standard json-schema behavior. The tooli=
ng
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
> Cc: "Uwe Kleine-K=C3=B6nig" <u.kleine-koenig@pengutronix.de>
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
mailbox stuff
Acked-by: Jassi Brar <jassisinghbrar@gmail.com>

thanks.
