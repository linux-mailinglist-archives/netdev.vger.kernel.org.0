Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB56F62DFB0
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 16:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240739AbiKQPVl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 17 Nov 2022 10:21:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240667AbiKQPVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 10:21:05 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505954AF16;
        Thu, 17 Nov 2022 07:18:13 -0800 (PST)
Received: from frapeml100008.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NCk2J3GTNz685ZJ;
        Thu, 17 Nov 2022 23:13:28 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 frapeml100008.china.huawei.com (7.182.85.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 16:18:11 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 17 Nov
 2022 15:18:10 +0000
Date:   Thu, 17 Nov 2022 15:18:09 +0000
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
CC:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-iio@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-leds@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-mips@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-can@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>, <linux-rtc@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-spi@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <linux-watchdog@vger.kernel.org>
Subject: Re: [RFC PATCH 4/9] dt-bindings: drop redundant part of title (end)
Message-ID: <20221117151809.0000205b@Huawei.com>
In-Reply-To: <20221117123850.368213-5-krzysztof.kozlowski@linaro.org>
References: <20221117123850.368213-1-krzysztof.kozlowski@linaro.org>
        <20221117123850.368213-5-krzysztof.kozlowski@linaro.org>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Nov 2022 13:38:45 +0100
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:

> The Devicetree bindings document does not have to say in the title that
> it is a "Devicetree binding", but instead just describe the hardware.
> 
> Drop trailing "Devicetree bindings" in various forms (also with
> trailling full stop):
> 
>   find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
>     -not -name 'trivial-devices.yaml' \
>     -exec sed -i -e 's/^title: \(.*\) [dD]evice[ -]\?[tT]ree [bB]indings\?\.\?$/title: \1/' {} \;
> 
>   find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
>     -not -name 'trivial-devices.yaml' \
>     -exec sed -i -e 's/^title: \(.*\) [dD]evice[ -]\?[nN]ode [bB]indings\?\.\?$/title: \1/' {} \;
> 
>   find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
>     -not -name 'trivial-devices.yaml' \
>     -exec sed -i -e 's/^title: \(.*\) [dD][tT] [bB]indings\?\.\?$/title: \1/' {} \;
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> #for iio
> ---
>  Documentation/devicetree/bindings/arm/bcm/bcm2835.yaml          | 2 +-
>  Documentation/devicetree/bindings/arm/bcm/brcm,bcm11351.yaml    | 2 +-
>  Documentation/devicetree/bindings/arm/bcm/brcm,bcm21664.yaml    | 2 +-
>  Documentation/devicetree/bindings/arm/bcm/brcm,bcm23550.yaml    | 2 +-
>  Documentation/devicetree/bindings/arm/bcm/brcm,bcm4708.yaml     | 2 +-
>  Documentation/devicetree/bindings/arm/bcm/brcm,bcmbca.yaml      | 2 +-
>  Documentation/devicetree/bindings/arm/bcm/brcm,cygnus.yaml      | 2 +-
>  Documentation/devicetree/bindings/arm/bcm/brcm,hr2.yaml         | 2 +-
>  Documentation/devicetree/bindings/arm/bcm/brcm,ns2.yaml         | 2 +-
>  Documentation/devicetree/bindings/arm/bcm/brcm,nsp.yaml         | 2 +-
>  Documentation/devicetree/bindings/arm/bcm/brcm,stingray.yaml    | 2 +-
>  Documentation/devicetree/bindings/arm/bcm/brcm,vulcan-soc.yaml  | 2 +-
>  .../devicetree/bindings/arm/firmware/linaro,optee-tz.yaml       | 2 +-
>  Documentation/devicetree/bindings/arm/hisilicon/hisilicon.yaml  | 2 +-
>  Documentation/devicetree/bindings/arm/keystone/ti,sci.yaml      | 2 +-
>  Documentation/devicetree/bindings/arm/marvell/armada-7k-8k.yaml | 2 +-
>  Documentation/devicetree/bindings/arm/mrvl/mrvl.yaml            | 2 +-
>  Documentation/devicetree/bindings/arm/mstar/mstar.yaml          | 2 +-
>  Documentation/devicetree/bindings/arm/npcm/npcm.yaml            | 2 +-
>  Documentation/devicetree/bindings/arm/nxp/lpc32xx.yaml          | 2 +-
>  Documentation/devicetree/bindings/arm/socionext/milbeaut.yaml   | 2 +-
>  Documentation/devicetree/bindings/arm/socionext/uniphier.yaml   | 2 +-
>  Documentation/devicetree/bindings/arm/sprd/sprd.yaml            | 2 +-
>  Documentation/devicetree/bindings/arm/stm32/stm32.yaml          | 2 +-
>  .../bindings/arm/sunxi/allwinner,sun6i-a31-cpuconfig.yaml       | 2 +-
>  .../devicetree/bindings/arm/sunxi/allwinner,sun9i-a80-prcm.yaml | 2 +-
>  .../bindings/arm/tegra/nvidia,tegra-ccplex-cluster.yaml         | 2 +-
>  Documentation/devicetree/bindings/arm/ti/k3.yaml                | 2 +-
>  Documentation/devicetree/bindings/arm/ti/ti,davinci.yaml        | 2 +-
>  Documentation/devicetree/bindings/clock/ingenic,cgu.yaml        | 2 +-
>  .../devicetree/bindings/clock/renesas,versaclock7.yaml          | 2 +-
>  Documentation/devicetree/bindings/display/bridge/anx6345.yaml   | 2 +-
>  .../devicetree/bindings/display/bridge/chrontel,ch7033.yaml     | 2 +-
>  .../devicetree/bindings/display/bridge/ite,it6505.yaml          | 2 +-
>  .../devicetree/bindings/display/bridge/ite,it66121.yaml         | 2 +-
>  Documentation/devicetree/bindings/display/bridge/ps8640.yaml    | 2 +-
>  Documentation/devicetree/bindings/display/ingenic,ipu.yaml      | 2 +-
>  Documentation/devicetree/bindings/display/ingenic,lcd.yaml      | 2 +-
>  .../devicetree/bindings/display/mediatek/mediatek,cec.yaml      | 2 +-
>  .../devicetree/bindings/display/mediatek/mediatek,dsi.yaml      | 2 +-
>  .../devicetree/bindings/display/mediatek/mediatek,hdmi-ddc.yaml | 2 +-
>  .../devicetree/bindings/display/mediatek/mediatek,hdmi.yaml     | 2 +-
>  .../devicetree/bindings/display/panel/ilitek,ili9163.yaml       | 2 +-
>  Documentation/devicetree/bindings/display/panel/panel-lvds.yaml | 2 +-
>  .../devicetree/bindings/display/panel/visionox,rm69299.yaml     | 2 +-
>  Documentation/devicetree/bindings/dma/ingenic,dma.yaml          | 2 +-
>  Documentation/devicetree/bindings/dma/ti/k3-bcdma.yaml          | 2 +-
>  Documentation/devicetree/bindings/dma/ti/k3-pktdma.yaml         | 2 +-
>  Documentation/devicetree/bindings/dma/ti/k3-udma.yaml           | 2 +-
>  .../devicetree/bindings/dma/xilinx/xlnx,zynqmp-dpdma.yaml       | 2 +-
>  Documentation/devicetree/bindings/eeprom/microchip,93lc46b.yaml | 2 +-
>  Documentation/devicetree/bindings/i2c/ingenic,i2c.yaml          | 2 +-
>  .../devicetree/bindings/iio/adc/allwinner,sun8i-a33-ths.yaml    | 2 +-
>  Documentation/devicetree/bindings/iio/adc/ti,palmas-gpadc.yaml  | 2 +-
>  .../devicetree/bindings/input/pine64,pinephone-keyboard.yaml    | 2 +-
>  .../devicetree/bindings/input/touchscreen/chipone,icn8318.yaml  | 2 +-
>  .../devicetree/bindings/input/touchscreen/pixcir,pixcir_ts.yaml | 2 +-
>  .../devicetree/bindings/input/touchscreen/silead,gsl1680.yaml   | 2 +-
>  .../devicetree/bindings/interrupt-controller/ingenic,intc.yaml  | 2 +-
>  .../bindings/interrupt-controller/realtek,rtl-intc.yaml         | 2 +-
>  .../devicetree/bindings/media/i2c/dongwoon,dw9768.yaml          | 2 +-
>  Documentation/devicetree/bindings/media/i2c/ov8856.yaml         | 2 +-
>  Documentation/devicetree/bindings/media/i2c/ovti,ov02a10.yaml   | 2 +-
>  Documentation/devicetree/bindings/media/i2c/ovti,ov5640.yaml    | 2 +-
>  Documentation/devicetree/bindings/media/i2c/ovti,ov5648.yaml    | 2 +-
>  Documentation/devicetree/bindings/media/i2c/ovti,ov8865.yaml    | 2 +-
>  Documentation/devicetree/bindings/media/i2c/st,st-vgxy61.yaml   | 2 +-
>  .../bindings/memory-controllers/ingenic,nemc-peripherals.yaml   | 2 +-
>  .../devicetree/bindings/memory-controllers/ingenic,nemc.yaml    | 2 +-
>  .../devicetree/bindings/memory-controllers/ti,gpmc.yaml         | 2 +-
>  Documentation/devicetree/bindings/mips/ingenic/devices.yaml     | 2 +-
>  .../devicetree/bindings/mips/lantiq/lantiq,dma-xway.yaml        | 2 +-
>  Documentation/devicetree/bindings/mips/loongson/devices.yaml    | 2 +-
>  Documentation/devicetree/bindings/mmc/ingenic,mmc.yaml          | 2 +-
>  Documentation/devicetree/bindings/mtd/ingenic,nand.yaml         | 2 +-
>  .../devicetree/bindings/net/can/allwinner,sun4i-a10-can.yaml    | 2 +-
>  Documentation/devicetree/bindings/net/can/bosch,c_can.yaml      | 2 +-
>  Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml     | 2 +-
>  Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml    | 2 +-
>  Documentation/devicetree/bindings/net/dsa/dsa-port.yaml         | 2 +-
>  Documentation/devicetree/bindings/net/dsa/dsa.yaml              | 2 +-
>  .../devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml       | 2 +-
>  Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml      | 2 +-
>  Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml      | 2 +-
>  Documentation/devicetree/bindings/net/wireless/esp,esp8089.yaml | 2 +-
>  .../devicetree/bindings/net/wireless/microchip,wilc1000.yaml    | 2 +-
>  Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml  | 2 +-
>  Documentation/devicetree/bindings/nvmem/qcom,spmi-sdam.yaml     | 2 +-
>  Documentation/devicetree/bindings/phy/ingenic,phy-usb.yaml      | 2 +-
>  Documentation/devicetree/bindings/pinctrl/ingenic,pinctrl.yaml  | 2 +-
>  .../devicetree/bindings/power/reset/xlnx,zynqmp-power.yaml      | 2 +-
>  .../devicetree/bindings/power/supply/maxim,ds2760.yaml          | 2 +-
>  .../devicetree/bindings/power/supply/maxim,max14656.yaml        | 2 +-
>  Documentation/devicetree/bindings/rtc/epson,rx8900.yaml         | 2 +-
>  Documentation/devicetree/bindings/rtc/ingenic,rtc.yaml          | 2 +-
>  Documentation/devicetree/bindings/rtc/renesas,rzn1-rtc.yaml     | 2 +-
>  Documentation/devicetree/bindings/serial/brcm,bcm7271-uart.yaml | 2 +-
>  Documentation/devicetree/bindings/serial/ingenic,uart.yaml      | 2 +-
>  Documentation/devicetree/bindings/serial/serial.yaml            | 2 +-
>  Documentation/devicetree/bindings/soc/mediatek/mtk-svs.yaml     | 2 +-
>  Documentation/devicetree/bindings/sound/cirrus,cs42l51.yaml     | 2 +-
>  Documentation/devicetree/bindings/sound/ingenic,aic.yaml        | 2 +-
>  Documentation/devicetree/bindings/sound/ingenic,codec.yaml      | 2 +-
>  .../devicetree/bindings/sound/qcom,lpass-rx-macro.yaml          | 2 +-
>  .../devicetree/bindings/sound/qcom,lpass-tx-macro.yaml          | 2 +-
>  .../devicetree/bindings/sound/qcom,lpass-va-macro.yaml          | 2 +-
>  .../devicetree/bindings/sound/qcom,lpass-wsa-macro.yaml         | 2 +-
>  Documentation/devicetree/bindings/sound/realtek,rt1015p.yaml    | 2 +-
>  Documentation/devicetree/bindings/sound/realtek,rt5682s.yaml    | 2 +-
>  Documentation/devicetree/bindings/sound/ti,src4xxx.yaml         | 2 +-
>  Documentation/devicetree/bindings/spi/ingenic,spi.yaml          | 2 +-
>  Documentation/devicetree/bindings/spi/spi-gpio.yaml             | 2 +-
>  Documentation/devicetree/bindings/timer/ingenic,tcu.yaml        | 2 +-
>  Documentation/devicetree/bindings/usb/ingenic,musb.yaml         | 2 +-
>  Documentation/devicetree/bindings/usb/maxim,max33359.yaml       | 2 +-
>  Documentation/devicetree/bindings/usb/mediatek,mt6360-tcpc.yaml | 2 +-
>  Documentation/devicetree/bindings/usb/ti,tps6598x.yaml          | 2 +-
>  Documentation/devicetree/bindings/usb/willsemi,wusb3801.yaml    | 2 +-
>  118 files changed, 118 insertions(+), 118 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/bcm/bcm2835.yaml b/Documentation/devicetree/bindings/arm/bcm/bcm2835.yaml
> index 8051a75c2c79..162a39dab218 100644
> --- a/Documentation/devicetree/bindings/arm/bcm/bcm2835.yaml
> +++ b/Documentation/devicetree/bindings/arm/bcm/bcm2835.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/bcm/bcm2835.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Broadcom BCM2711/BCM2835 Platforms Device Tree Bindings
> +title: Broadcom BCM2711/BCM2835 Platforms
>  
>  maintainers:
>    - Eric Anholt <eric@anholt.net>
> diff --git a/Documentation/devicetree/bindings/arm/bcm/brcm,bcm11351.yaml b/Documentation/devicetree/bindings/arm/bcm/brcm,bcm11351.yaml
> index c60324357435..f2bcac0096b7 100644
> --- a/Documentation/devicetree/bindings/arm/bcm/brcm,bcm11351.yaml
> +++ b/Documentation/devicetree/bindings/arm/bcm/brcm,bcm11351.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/bcm/brcm,bcm11351.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Broadcom BCM11351 device tree bindings
> +title: Broadcom BCM11351
>  
>  maintainers:
>    - Florian Fainelli <f.fainelli@gmail.com>
> diff --git a/Documentation/devicetree/bindings/arm/bcm/brcm,bcm21664.yaml b/Documentation/devicetree/bindings/arm/bcm/brcm,bcm21664.yaml
> index b3020757380f..cf4e254e32f1 100644
> --- a/Documentation/devicetree/bindings/arm/bcm/brcm,bcm21664.yaml
> +++ b/Documentation/devicetree/bindings/arm/bcm/brcm,bcm21664.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/bcm/brcm,bcm21664.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Broadcom BCM21664 device tree bindings
> +title: Broadcom BCM21664
>  
>  maintainers:
>    - Florian Fainelli <f.fainelli@gmail.com>
> diff --git a/Documentation/devicetree/bindings/arm/bcm/brcm,bcm23550.yaml b/Documentation/devicetree/bindings/arm/bcm/brcm,bcm23550.yaml
> index 37f3a6fcde76..eafec29ba7ab 100644
> --- a/Documentation/devicetree/bindings/arm/bcm/brcm,bcm23550.yaml
> +++ b/Documentation/devicetree/bindings/arm/bcm/brcm,bcm23550.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/bcm/brcm,bcm23550.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Broadcom BCM23550 device tree bindings
> +title: Broadcom BCM23550
>  
>  maintainers:
>    - Florian Fainelli <f.fainelli@gmail.com>
> diff --git a/Documentation/devicetree/bindings/arm/bcm/brcm,bcm4708.yaml b/Documentation/devicetree/bindings/arm/bcm/brcm,bcm4708.yaml
> index 52b575c40599..454b0e93245d 100644
> --- a/Documentation/devicetree/bindings/arm/bcm/brcm,bcm4708.yaml
> +++ b/Documentation/devicetree/bindings/arm/bcm/brcm,bcm4708.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/bcm/brcm,bcm4708.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Broadcom BCM4708 device tree bindings
> +title: Broadcom BCM4708
>  
>  description:
>    Broadcom BCM4708/47081/4709/47094/53012 Wi-Fi/network SoCs based
> diff --git a/Documentation/devicetree/bindings/arm/bcm/brcm,bcmbca.yaml b/Documentation/devicetree/bindings/arm/bcm/brcm,bcmbca.yaml
> index 84866e29cab0..07892cbdd23c 100644
> --- a/Documentation/devicetree/bindings/arm/bcm/brcm,bcmbca.yaml
> +++ b/Documentation/devicetree/bindings/arm/bcm/brcm,bcmbca.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/bcm/brcm,bcmbca.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Broadcom Broadband SoC device tree bindings
> +title: Broadcom Broadband SoC
>  
>  description:
>    Broadcom Broadband SoCs include family of high performance DSL/PON/Wireless
> diff --git a/Documentation/devicetree/bindings/arm/bcm/brcm,cygnus.yaml b/Documentation/devicetree/bindings/arm/bcm/brcm,cygnus.yaml
> index 432ccf990f9e..a0a3f32db54e 100644
> --- a/Documentation/devicetree/bindings/arm/bcm/brcm,cygnus.yaml
> +++ b/Documentation/devicetree/bindings/arm/bcm/brcm,cygnus.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/bcm/brcm,cygnus.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Broadcom Cygnus device tree bindings
> +title: Broadcom Cygnus
>  
>  maintainers:
>    - Ray Jui <rjui@broadcom.com>
> diff --git a/Documentation/devicetree/bindings/arm/bcm/brcm,hr2.yaml b/Documentation/devicetree/bindings/arm/bcm/brcm,hr2.yaml
> index 294948399f82..cc6add0e933a 100644
> --- a/Documentation/devicetree/bindings/arm/bcm/brcm,hr2.yaml
> +++ b/Documentation/devicetree/bindings/arm/bcm/brcm,hr2.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/bcm/brcm,hr2.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Broadcom Hurricane 2 device tree bindings
> +title: Broadcom Hurricane 2
>  
>  description:
>    Broadcom Hurricane 2 family of SoCs are used for switching control. These SoCs
> diff --git a/Documentation/devicetree/bindings/arm/bcm/brcm,ns2.yaml b/Documentation/devicetree/bindings/arm/bcm/brcm,ns2.yaml
> index c4847abbecd8..6696598eca0e 100644
> --- a/Documentation/devicetree/bindings/arm/bcm/brcm,ns2.yaml
> +++ b/Documentation/devicetree/bindings/arm/bcm/brcm,ns2.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/bcm/brcm,ns2.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Broadcom North Star 2 (NS2) device tree bindings
> +title: Broadcom North Star 2 (NS2)
>  
>  maintainers:
>    - Ray Jui <rjui@broadcom.com>
> diff --git a/Documentation/devicetree/bindings/arm/bcm/brcm,nsp.yaml b/Documentation/devicetree/bindings/arm/bcm/brcm,nsp.yaml
> index 7d184ba7d180..a43b2d4d936b 100644
> --- a/Documentation/devicetree/bindings/arm/bcm/brcm,nsp.yaml
> +++ b/Documentation/devicetree/bindings/arm/bcm/brcm,nsp.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/bcm/brcm,nsp.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Broadcom Northstar Plus device tree bindings
> +title: Broadcom Northstar Plus
>  
>  description:
>    Broadcom Northstar Plus family of SoCs are used for switching control
> diff --git a/Documentation/devicetree/bindings/arm/bcm/brcm,stingray.yaml b/Documentation/devicetree/bindings/arm/bcm/brcm,stingray.yaml
> index c638e04ebae0..c6ccb78aab0a 100644
> --- a/Documentation/devicetree/bindings/arm/bcm/brcm,stingray.yaml
> +++ b/Documentation/devicetree/bindings/arm/bcm/brcm,stingray.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/bcm/brcm,stingray.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Broadcom Stingray device tree bindings
> +title: Broadcom Stingray
>  
>  maintainers:
>    - Ray Jui <rjui@broadcom.com>
> diff --git a/Documentation/devicetree/bindings/arm/bcm/brcm,vulcan-soc.yaml b/Documentation/devicetree/bindings/arm/bcm/brcm,vulcan-soc.yaml
> index 4eba182abd53..3f441352fbf0 100644
> --- a/Documentation/devicetree/bindings/arm/bcm/brcm,vulcan-soc.yaml
> +++ b/Documentation/devicetree/bindings/arm/bcm/brcm,vulcan-soc.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/bcm/brcm,vulcan-soc.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Broadcom Vulcan device tree bindings
> +title: Broadcom Vulcan
>  
>  maintainers:
>    - Robert Richter <rrichter@marvell.com>
> diff --git a/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.yaml b/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.yaml
> index 9a426110a14a..d4dc0749f9fd 100644
> --- a/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.yaml
> +++ b/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/firmware/linaro,optee-tz.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: OP-TEE Device Tree Bindings
> +title: OP-TEE
>  
>  maintainers:
>    - Jens Wiklander <jens.wiklander@linaro.org>
> diff --git a/Documentation/devicetree/bindings/arm/hisilicon/hisilicon.yaml b/Documentation/devicetree/bindings/arm/hisilicon/hisilicon.yaml
> index b38458022946..540876322040 100644
> --- a/Documentation/devicetree/bindings/arm/hisilicon/hisilicon.yaml
> +++ b/Documentation/devicetree/bindings/arm/hisilicon/hisilicon.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/hisilicon/hisilicon.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Hisilicon Platforms Device Tree Bindings
> +title: Hisilicon Platforms
>  
>  maintainers:
>    - Wei Xu <xuwei5@hisilicon.com>
> diff --git a/Documentation/devicetree/bindings/arm/keystone/ti,sci.yaml b/Documentation/devicetree/bindings/arm/keystone/ti,sci.yaml
> index 34f5f877d444..91b96065f7df 100644
> --- a/Documentation/devicetree/bindings/arm/keystone/ti,sci.yaml
> +++ b/Documentation/devicetree/bindings/arm/keystone/ti,sci.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/keystone/ti,sci.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: TI-SCI controller device node bindings
> +title: TI-SCI controller
>  
>  maintainers:
>    - Nishanth Menon <nm@ti.com>
> diff --git a/Documentation/devicetree/bindings/arm/marvell/armada-7k-8k.yaml b/Documentation/devicetree/bindings/arm/marvell/armada-7k-8k.yaml
> index e9bf3054529f..52d78521e412 100644
> --- a/Documentation/devicetree/bindings/arm/marvell/armada-7k-8k.yaml
> +++ b/Documentation/devicetree/bindings/arm/marvell/armada-7k-8k.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/marvell/armada-7k-8k.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Marvell Armada 7K/8K Platforms Device Tree Bindings
> +title: Marvell Armada 7K/8K Platforms
>  
>  maintainers:
>    - Gregory CLEMENT <gregory.clement@bootlin.com>
> diff --git a/Documentation/devicetree/bindings/arm/mrvl/mrvl.yaml b/Documentation/devicetree/bindings/arm/mrvl/mrvl.yaml
> index d58116136154..4c43eaf3632e 100644
> --- a/Documentation/devicetree/bindings/arm/mrvl/mrvl.yaml
> +++ b/Documentation/devicetree/bindings/arm/mrvl/mrvl.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/mrvl/mrvl.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Marvell Platforms Device Tree Bindings
> +title: Marvell Platforms
>  
>  maintainers:
>    - Lubomir Rintel <lkundrak@v3.sk>
> diff --git a/Documentation/devicetree/bindings/arm/mstar/mstar.yaml b/Documentation/devicetree/bindings/arm/mstar/mstar.yaml
> index 8892eb6bd3ef..937059fcc7b3 100644
> --- a/Documentation/devicetree/bindings/arm/mstar/mstar.yaml
> +++ b/Documentation/devicetree/bindings/arm/mstar/mstar.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/mstar/mstar.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: MStar platforms device tree bindings
> +title: MStar platforms
>  
>  maintainers:
>    - Daniel Palmer <daniel@thingy.jp>
> diff --git a/Documentation/devicetree/bindings/arm/npcm/npcm.yaml b/Documentation/devicetree/bindings/arm/npcm/npcm.yaml
> index 43409e5721d5..6871483947c5 100644
> --- a/Documentation/devicetree/bindings/arm/npcm/npcm.yaml
> +++ b/Documentation/devicetree/bindings/arm/npcm/npcm.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/npcm/npcm.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: NPCM Platforms Device Tree Bindings
> +title: NPCM Platforms
>  
>  maintainers:
>    - Jonathan Neuschäfer <j.neuschaefer@gmx.net>
> diff --git a/Documentation/devicetree/bindings/arm/nxp/lpc32xx.yaml b/Documentation/devicetree/bindings/arm/nxp/lpc32xx.yaml
> index 214c97bc3063..f1bd6f50e726 100644
> --- a/Documentation/devicetree/bindings/arm/nxp/lpc32xx.yaml
> +++ b/Documentation/devicetree/bindings/arm/nxp/lpc32xx.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/nxp/lpc32xx.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: NXP LPC32xx Platforms Device Tree Bindings
> +title: NXP LPC32xx Platforms
>  
>  maintainers:
>    - Roland Stigge <stigge@antcom.de>
> diff --git a/Documentation/devicetree/bindings/arm/socionext/milbeaut.yaml b/Documentation/devicetree/bindings/arm/socionext/milbeaut.yaml
> index aa1d4afbc510..5a428a885760 100644
> --- a/Documentation/devicetree/bindings/arm/socionext/milbeaut.yaml
> +++ b/Documentation/devicetree/bindings/arm/socionext/milbeaut.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/socionext/milbeaut.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Milbeaut platforms device tree bindings
> +title: Milbeaut platforms
>  
>  maintainers:
>    - Taichi Sugaya <sugaya.taichi@socionext.com>
> diff --git a/Documentation/devicetree/bindings/arm/socionext/uniphier.yaml b/Documentation/devicetree/bindings/arm/socionext/uniphier.yaml
> index 8c0e91658474..a141da880469 100644
> --- a/Documentation/devicetree/bindings/arm/socionext/uniphier.yaml
> +++ b/Documentation/devicetree/bindings/arm/socionext/uniphier.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/socionext/uniphier.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Socionext UniPhier platform device tree bindings
> +title: Socionext UniPhier platform
>  
>  maintainers:
>    - Masahiro Yamada <yamada.masahiro@socionext.com>
> diff --git a/Documentation/devicetree/bindings/arm/sprd/sprd.yaml b/Documentation/devicetree/bindings/arm/sprd/sprd.yaml
> index 2c12e571394b..eaa67b8e0d6c 100644
> --- a/Documentation/devicetree/bindings/arm/sprd/sprd.yaml
> +++ b/Documentation/devicetree/bindings/arm/sprd/sprd.yaml
> @@ -5,7 +5,7 @@
>  $id: http://devicetree.org/schemas/arm/sprd/sprd.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Unisoc platforms device tree bindings
> +title: Unisoc platforms
>  
>  maintainers:
>    - Orson Zhai <orsonzhai@gmail.com>
> diff --git a/Documentation/devicetree/bindings/arm/stm32/stm32.yaml b/Documentation/devicetree/bindings/arm/stm32/stm32.yaml
> index 44f5c5855af8..13e34241145b 100644
> --- a/Documentation/devicetree/bindings/arm/stm32/stm32.yaml
> +++ b/Documentation/devicetree/bindings/arm/stm32/stm32.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/stm32/stm32.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: STMicroelectronics STM32 Platforms Device Tree Bindings
> +title: STMicroelectronics STM32 Platforms
>  
>  maintainers:
>    - Alexandre Torgue <alexandre.torgue@foss.st.com>
> diff --git a/Documentation/devicetree/bindings/arm/sunxi/allwinner,sun6i-a31-cpuconfig.yaml b/Documentation/devicetree/bindings/arm/sunxi/allwinner,sun6i-a31-cpuconfig.yaml
> index f3878e0b3cc4..d805c4508b4e 100644
> --- a/Documentation/devicetree/bindings/arm/sunxi/allwinner,sun6i-a31-cpuconfig.yaml
> +++ b/Documentation/devicetree/bindings/arm/sunxi/allwinner,sun6i-a31-cpuconfig.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/sunxi/allwinner,sun6i-a31-cpuconfig.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Allwinner CPU Configuration Controller Device Tree Bindings
> +title: Allwinner CPU Configuration Controller
>  
>  maintainers:
>    - Chen-Yu Tsai <wens@csie.org>
> diff --git a/Documentation/devicetree/bindings/arm/sunxi/allwinner,sun9i-a80-prcm.yaml b/Documentation/devicetree/bindings/arm/sunxi/allwinner,sun9i-a80-prcm.yaml
> index 668aadbfe4c0..644f391afb32 100644
> --- a/Documentation/devicetree/bindings/arm/sunxi/allwinner,sun9i-a80-prcm.yaml
> +++ b/Documentation/devicetree/bindings/arm/sunxi/allwinner,sun9i-a80-prcm.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/sunxi/allwinner,sun9i-a80-prcm.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Allwinner A80 PRCM Device Tree Bindings
> +title: Allwinner A80 PRCM
>  
>  maintainers:
>    - Chen-Yu Tsai <wens@csie.org>
> diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra-ccplex-cluster.yaml b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra-ccplex-cluster.yaml
> index 869c266e7ebc..6089a96eae4f 100644
> --- a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra-ccplex-cluster.yaml
> +++ b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra-ccplex-cluster.yaml
> @@ -4,7 +4,7 @@
>  $id: "http://devicetree.org/schemas/arm/tegra/nvidia,tegra-ccplex-cluster.yaml#"
>  $schema: "http://devicetree.org/meta-schemas/core.yaml#"
>  
> -title: NVIDIA Tegra CPU COMPLEX CLUSTER area device tree bindings
> +title: NVIDIA Tegra CPU COMPLEX CLUSTER area
>  
>  maintainers:
>    - Sumit Gupta <sumitg@nvidia.com>
> diff --git a/Documentation/devicetree/bindings/arm/ti/k3.yaml b/Documentation/devicetree/bindings/arm/ti/k3.yaml
> index 28b8232e1c5b..49718804fd43 100644
> --- a/Documentation/devicetree/bindings/arm/ti/k3.yaml
> +++ b/Documentation/devicetree/bindings/arm/ti/k3.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/ti/k3.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Texas Instruments K3 Multicore SoC architecture device tree bindings
> +title: Texas Instruments K3 Multicore SoC architecture
>  
>  maintainers:
>    - Nishanth Menon <nm@ti.com>
> diff --git a/Documentation/devicetree/bindings/arm/ti/ti,davinci.yaml b/Documentation/devicetree/bindings/arm/ti/ti,davinci.yaml
> index c022d325fc08..1656d1a4476f 100644
> --- a/Documentation/devicetree/bindings/arm/ti/ti,davinci.yaml
> +++ b/Documentation/devicetree/bindings/arm/ti/ti,davinci.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/arm/ti/ti,davinci.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Texas Instruments DaVinci Platforms Device Tree Bindings
> +title: Texas Instruments DaVinci Platforms
>  
>  maintainers:
>    - Sekhar Nori <nsekhar@ti.com>
> diff --git a/Documentation/devicetree/bindings/clock/ingenic,cgu.yaml b/Documentation/devicetree/bindings/clock/ingenic,cgu.yaml
> index df256ebcd366..9e733b10c392 100644
> --- a/Documentation/devicetree/bindings/clock/ingenic,cgu.yaml
> +++ b/Documentation/devicetree/bindings/clock/ingenic,cgu.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/clock/ingenic,cgu.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ingenic SoCs CGU devicetree bindings
> +title: Ingenic SoCs CGU
>  
>  description: |
>    The CGU in an Ingenic SoC provides all the clocks generated on-chip. It
> diff --git a/Documentation/devicetree/bindings/clock/renesas,versaclock7.yaml b/Documentation/devicetree/bindings/clock/renesas,versaclock7.yaml
> index 8d4eb4475fc8..b339f1f9f072 100644
> --- a/Documentation/devicetree/bindings/clock/renesas,versaclock7.yaml
> +++ b/Documentation/devicetree/bindings/clock/renesas,versaclock7.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/clock/renesas,versaclock7.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Renesas Versaclock7 Programmable Clock Device Tree Bindings
> +title: Renesas Versaclock7 Programmable Clock
>  
>  maintainers:
>    - Alex Helms <alexander.helms.jy@renesas.com>
> diff --git a/Documentation/devicetree/bindings/display/bridge/anx6345.yaml b/Documentation/devicetree/bindings/display/bridge/anx6345.yaml
> index 1c0406c38fe5..9bf2cbcea69f 100644
> --- a/Documentation/devicetree/bindings/display/bridge/anx6345.yaml
> +++ b/Documentation/devicetree/bindings/display/bridge/anx6345.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/display/bridge/anx6345.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Analogix ANX6345 eDP Transmitter Device Tree Bindings
> +title: Analogix ANX6345 eDP Transmitter
>  
>  maintainers:
>    - Torsten Duwe <duwe@lst.de>
> diff --git a/Documentation/devicetree/bindings/display/bridge/chrontel,ch7033.yaml b/Documentation/devicetree/bindings/display/bridge/chrontel,ch7033.yaml
> index bb6289c7d375..b0589fa16736 100644
> --- a/Documentation/devicetree/bindings/display/bridge/chrontel,ch7033.yaml
> +++ b/Documentation/devicetree/bindings/display/bridge/chrontel,ch7033.yaml
> @@ -5,7 +5,7 @@
>  $id: http://devicetree.org/schemas/display/bridge/chrontel,ch7033.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Chrontel CH7033 Video Encoder Device Tree Bindings
> +title: Chrontel CH7033 Video Encoder
>  
>  maintainers:
>    - Lubomir Rintel <lkundrak@v3.sk>
> diff --git a/Documentation/devicetree/bindings/display/bridge/ite,it6505.yaml b/Documentation/devicetree/bindings/display/bridge/ite,it6505.yaml
> index 833d11b2303a..b697c42399ea 100644
> --- a/Documentation/devicetree/bindings/display/bridge/ite,it6505.yaml
> +++ b/Documentation/devicetree/bindings/display/bridge/ite,it6505.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/display/bridge/ite,it6505.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: ITE it6505 Device Tree Bindings
> +title: ITE it6505
>  
>  maintainers:
>    - Allen Chen <allen.chen@ite.com.tw>
> diff --git a/Documentation/devicetree/bindings/display/bridge/ite,it66121.yaml b/Documentation/devicetree/bindings/display/bridge/ite,it66121.yaml
> index 1b2185be92cd..d3454da1247a 100644
> --- a/Documentation/devicetree/bindings/display/bridge/ite,it66121.yaml
> +++ b/Documentation/devicetree/bindings/display/bridge/ite,it66121.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/display/bridge/ite,it66121.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: ITE it66121 HDMI bridge Device Tree Bindings
> +title: ITE it66121 HDMI bridge
>  
>  maintainers:
>    - Phong LE <ple@baylibre.com>
> diff --git a/Documentation/devicetree/bindings/display/bridge/ps8640.yaml b/Documentation/devicetree/bindings/display/bridge/ps8640.yaml
> index 8ab156e0a8cf..28811aff2c5a 100644
> --- a/Documentation/devicetree/bindings/display/bridge/ps8640.yaml
> +++ b/Documentation/devicetree/bindings/display/bridge/ps8640.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/display/bridge/ps8640.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: MIPI DSI to eDP Video Format Converter Device Tree Bindings
> +title: MIPI DSI to eDP Video Format Converter
>  
>  maintainers:
>    - Nicolas Boichat <drinkcat@chromium.org>
> diff --git a/Documentation/devicetree/bindings/display/ingenic,ipu.yaml b/Documentation/devicetree/bindings/display/ingenic,ipu.yaml
> index 3f93def2c5a2..319bd7c88fe3 100644
> --- a/Documentation/devicetree/bindings/display/ingenic,ipu.yaml
> +++ b/Documentation/devicetree/bindings/display/ingenic,ipu.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/display/ingenic,ipu.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ingenic SoCs Image Processing Unit (IPU) devicetree bindings
> +title: Ingenic SoCs Image Processing Unit (IPU)
>  
>  maintainers:
>    - Paul Cercueil <paul@crapouillou.net>
> diff --git a/Documentation/devicetree/bindings/display/ingenic,lcd.yaml b/Documentation/devicetree/bindings/display/ingenic,lcd.yaml
> index c0bb02fb49f4..6d4c00f3fcc8 100644
> --- a/Documentation/devicetree/bindings/display/ingenic,lcd.yaml
> +++ b/Documentation/devicetree/bindings/display/ingenic,lcd.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/display/ingenic,lcd.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ingenic SoCs LCD controller devicetree bindings
> +title: Ingenic SoCs LCD controller
>  
>  maintainers:
>    - Paul Cercueil <paul@crapouillou.net>
> diff --git a/Documentation/devicetree/bindings/display/mediatek/mediatek,cec.yaml b/Documentation/devicetree/bindings/display/mediatek/mediatek,cec.yaml
> index 66288b9f0aa6..080cf321209e 100644
> --- a/Documentation/devicetree/bindings/display/mediatek/mediatek,cec.yaml
> +++ b/Documentation/devicetree/bindings/display/mediatek/mediatek,cec.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/display/mediatek/mediatek,cec.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Mediatek HDMI CEC Controller Device Tree Bindings
> +title: Mediatek HDMI CEC Controller
>  
>  maintainers:
>    - CK Hu <ck.hu@mediatek.com>
> diff --git a/Documentation/devicetree/bindings/display/mediatek/mediatek,dsi.yaml b/Documentation/devicetree/bindings/display/mediatek/mediatek,dsi.yaml
> index b18d6a57c6e1..4707b60238b0 100644
> --- a/Documentation/devicetree/bindings/display/mediatek/mediatek,dsi.yaml
> +++ b/Documentation/devicetree/bindings/display/mediatek/mediatek,dsi.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/display/mediatek/mediatek,dsi.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: MediaTek DSI Controller Device Tree Bindings
> +title: MediaTek DSI Controller
>  
>  maintainers:
>    - Chun-Kuang Hu <chunkuang.hu@kernel.org>
> diff --git a/Documentation/devicetree/bindings/display/mediatek/mediatek,hdmi-ddc.yaml b/Documentation/devicetree/bindings/display/mediatek/mediatek,hdmi-ddc.yaml
> index b6fcdfb99ab2..bd8f7b8ae0ff 100644
> --- a/Documentation/devicetree/bindings/display/mediatek/mediatek,hdmi-ddc.yaml
> +++ b/Documentation/devicetree/bindings/display/mediatek/mediatek,hdmi-ddc.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/display/mediatek/mediatek,hdmi-ddc.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Mediatek HDMI DDC Device Tree Bindings
> +title: Mediatek HDMI DDC
>  
>  maintainers:
>    - CK Hu <ck.hu@mediatek.com>
> diff --git a/Documentation/devicetree/bindings/display/mediatek/mediatek,hdmi.yaml b/Documentation/devicetree/bindings/display/mediatek/mediatek,hdmi.yaml
> index bdaf0b51e68c..8afdd67d6780 100644
> --- a/Documentation/devicetree/bindings/display/mediatek/mediatek,hdmi.yaml
> +++ b/Documentation/devicetree/bindings/display/mediatek/mediatek,hdmi.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/display/mediatek/mediatek,hdmi.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Mediatek HDMI Encoder Device Tree Bindings
> +title: Mediatek HDMI Encoder
>  
>  maintainers:
>    - CK Hu <ck.hu@mediatek.com>
> diff --git a/Documentation/devicetree/bindings/display/panel/ilitek,ili9163.yaml b/Documentation/devicetree/bindings/display/panel/ilitek,ili9163.yaml
> index a4154b51043e..90e323e19edb 100644
> --- a/Documentation/devicetree/bindings/display/panel/ilitek,ili9163.yaml
> +++ b/Documentation/devicetree/bindings/display/panel/ilitek,ili9163.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/display/panel/ilitek,ili9163.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ilitek ILI9163 display panels device tree bindings
> +title: Ilitek ILI9163 display panels
>  
>  maintainers:
>    - Daniel Mack <daniel@zonque.org>
> diff --git a/Documentation/devicetree/bindings/display/panel/panel-lvds.yaml b/Documentation/devicetree/bindings/display/panel/panel-lvds.yaml
> index fcc50db6a812..c77ee034310a 100644
> --- a/Documentation/devicetree/bindings/display/panel/panel-lvds.yaml
> +++ b/Documentation/devicetree/bindings/display/panel/panel-lvds.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/display/panel/panel-lvds.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Generic LVDS Display Panel Device Tree Bindings
> +title: Generic LVDS Display Panel
>  
>  maintainers:
>    - Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> diff --git a/Documentation/devicetree/bindings/display/panel/visionox,rm69299.yaml b/Documentation/devicetree/bindings/display/panel/visionox,rm69299.yaml
> index 076b057b4af5..481ef051df1e 100644
> --- a/Documentation/devicetree/bindings/display/panel/visionox,rm69299.yaml
> +++ b/Documentation/devicetree/bindings/display/panel/visionox,rm69299.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/display/panel/visionox,rm69299.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Visionox model RM69299 Panels Device Tree Bindings.
> +title: Visionox model RM69299 Panels
>  
>  maintainers:
>    - Harigovindan P <harigovi@codeaurora.org>
> diff --git a/Documentation/devicetree/bindings/dma/ingenic,dma.yaml b/Documentation/devicetree/bindings/dma/ingenic,dma.yaml
> index e42b8ce948db..fd5b0a8eaed8 100644
> --- a/Documentation/devicetree/bindings/dma/ingenic,dma.yaml
> +++ b/Documentation/devicetree/bindings/dma/ingenic,dma.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/dma/ingenic,dma.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ingenic SoCs DMA Controller DT bindings
> +title: Ingenic SoCs DMA Controller
>  
>  maintainers:
>    - Paul Cercueil <paul@crapouillou.net>
> diff --git a/Documentation/devicetree/bindings/dma/ti/k3-bcdma.yaml b/Documentation/devicetree/bindings/dma/ti/k3-bcdma.yaml
> index 08627d91e607..a702d2c2ff8d 100644
> --- a/Documentation/devicetree/bindings/dma/ti/k3-bcdma.yaml
> +++ b/Documentation/devicetree/bindings/dma/ti/k3-bcdma.yaml
> @@ -6,7 +6,7 @@
>  $id: http://devicetree.org/schemas/dma/ti/k3-bcdma.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Texas Instruments K3 DMSS BCDMA Device Tree Bindings
> +title: Texas Instruments K3 DMSS BCDMA
>  
>  maintainers:
>    - Peter Ujfalusi <peter.ujfalusi@gmail.com>
> diff --git a/Documentation/devicetree/bindings/dma/ti/k3-pktdma.yaml b/Documentation/devicetree/bindings/dma/ti/k3-pktdma.yaml
> index 507d16d84ade..a69f62f854d8 100644
> --- a/Documentation/devicetree/bindings/dma/ti/k3-pktdma.yaml
> +++ b/Documentation/devicetree/bindings/dma/ti/k3-pktdma.yaml
> @@ -6,7 +6,7 @@
>  $id: http://devicetree.org/schemas/dma/ti/k3-pktdma.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Texas Instruments K3 DMSS PKTDMA Device Tree Bindings
> +title: Texas Instruments K3 DMSS PKTDMA
>  
>  maintainers:
>    - Peter Ujfalusi <peter.ujfalusi@gmail.com>
> diff --git a/Documentation/devicetree/bindings/dma/ti/k3-udma.yaml b/Documentation/devicetree/bindings/dma/ti/k3-udma.yaml
> index 6a09bbf83d46..7ff428ad3aae 100644
> --- a/Documentation/devicetree/bindings/dma/ti/k3-udma.yaml
> +++ b/Documentation/devicetree/bindings/dma/ti/k3-udma.yaml
> @@ -6,7 +6,7 @@
>  $id: http://devicetree.org/schemas/dma/ti/k3-udma.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Texas Instruments K3 NAVSS Unified DMA Device Tree Bindings
> +title: Texas Instruments K3 NAVSS Unified DMA
>  
>  maintainers:
>    - Peter Ujfalusi <peter.ujfalusi@gmail.com>
> diff --git a/Documentation/devicetree/bindings/dma/xilinx/xlnx,zynqmp-dpdma.yaml b/Documentation/devicetree/bindings/dma/xilinx/xlnx,zynqmp-dpdma.yaml
> index 2a595b18ff6c..825294e3f0e8 100644
> --- a/Documentation/devicetree/bindings/dma/xilinx/xlnx,zynqmp-dpdma.yaml
> +++ b/Documentation/devicetree/bindings/dma/xilinx/xlnx,zynqmp-dpdma.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/dma/xilinx/xlnx,zynqmp-dpdma.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Xilinx ZynqMP DisplayPort DMA Controller Device Tree Bindings
> +title: Xilinx ZynqMP DisplayPort DMA Controller
>  
>  description: |
>    These bindings describe the DMA engine included in the Xilinx ZynqMP
> diff --git a/Documentation/devicetree/bindings/eeprom/microchip,93lc46b.yaml b/Documentation/devicetree/bindings/eeprom/microchip,93lc46b.yaml
> index 0c2f5ddb79c5..5476bed79f16 100644
> --- a/Documentation/devicetree/bindings/eeprom/microchip,93lc46b.yaml
> +++ b/Documentation/devicetree/bindings/eeprom/microchip,93lc46b.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/eeprom/microchip,93lc46b.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Microchip 93xx46 SPI compatible EEPROM family dt bindings
> +title: Microchip 93xx46 SPI compatible EEPROM family
>  
>  maintainers:
>    - Cory Tusar <cory.tusar@pid1solutions.com>
> diff --git a/Documentation/devicetree/bindings/i2c/ingenic,i2c.yaml b/Documentation/devicetree/bindings/i2c/ingenic,i2c.yaml
> index af6d64a6da6e..b61fdc9548d8 100644
> --- a/Documentation/devicetree/bindings/i2c/ingenic,i2c.yaml
> +++ b/Documentation/devicetree/bindings/i2c/ingenic,i2c.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/i2c/ingenic,i2c.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ingenic SoCs I2C controller devicetree bindings
> +title: Ingenic SoCs I2C controller
>  
>  maintainers:
>    - Paul Cercueil <paul@crapouillou.net>
> diff --git a/Documentation/devicetree/bindings/iio/adc/allwinner,sun8i-a33-ths.yaml b/Documentation/devicetree/bindings/iio/adc/allwinner,sun8i-a33-ths.yaml
> index 15c514b83583..a73a355fc665 100644
> --- a/Documentation/devicetree/bindings/iio/adc/allwinner,sun8i-a33-ths.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/allwinner,sun8i-a33-ths.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/iio/adc/allwinner,sun8i-a33-ths.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Allwinner A33 Thermal Sensor Device Tree Bindings
> +title: Allwinner A33 Thermal Sensor
>  
>  maintainers:
>    - Chen-Yu Tsai <wens@csie.org>
> diff --git a/Documentation/devicetree/bindings/iio/adc/ti,palmas-gpadc.yaml b/Documentation/devicetree/bindings/iio/adc/ti,palmas-gpadc.yaml
> index 57a31356082e..720c16a108d4 100644
> --- a/Documentation/devicetree/bindings/iio/adc/ti,palmas-gpadc.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/ti,palmas-gpadc.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/iio/adc/ti,palmas-gpadc.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Palmas general purpose ADC IP block devicetree bindings
> +title: Palmas general purpose ADC IP block
>  
>  maintainers:
>    - Tony Lindgren <tony@atomide.com>
> diff --git a/Documentation/devicetree/bindings/input/pine64,pinephone-keyboard.yaml b/Documentation/devicetree/bindings/input/pine64,pinephone-keyboard.yaml
> index e4a0ac0fff9a..490f6c3d9e4b 100644
> --- a/Documentation/devicetree/bindings/input/pine64,pinephone-keyboard.yaml
> +++ b/Documentation/devicetree/bindings/input/pine64,pinephone-keyboard.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/input/pine64,pinephone-keyboard.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Pine64 PinePhone keyboard device tree bindings
> +title: Pine64 PinePhone keyboard
>  
>  maintainers:
>    - Samuel Holland <samuel@sholland.org>
> diff --git a/Documentation/devicetree/bindings/input/touchscreen/chipone,icn8318.yaml b/Documentation/devicetree/bindings/input/touchscreen/chipone,icn8318.yaml
> index 9df685bdc5db..74a8a01e0745 100644
> --- a/Documentation/devicetree/bindings/input/touchscreen/chipone,icn8318.yaml
> +++ b/Documentation/devicetree/bindings/input/touchscreen/chipone,icn8318.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/input/touchscreen/chipone,icn8318.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: ChipOne ICN8318 Touchscreen Controller Device Tree Bindings
> +title: ChipOne ICN8318 Touchscreen Controller
>  
>  maintainers:
>    - Dmitry Torokhov <dmitry.torokhov@gmail.com>
> diff --git a/Documentation/devicetree/bindings/input/touchscreen/pixcir,pixcir_ts.yaml b/Documentation/devicetree/bindings/input/touchscreen/pixcir,pixcir_ts.yaml
> index f9998edbff70..3305eda5ed88 100644
> --- a/Documentation/devicetree/bindings/input/touchscreen/pixcir,pixcir_ts.yaml
> +++ b/Documentation/devicetree/bindings/input/touchscreen/pixcir,pixcir_ts.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/input/touchscreen/pixcir,pixcir_ts.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Pixcir Touchscreen Controller Device Tree Bindings
> +title: Pixcir Touchscreen Controller
>  
>  maintainers:
>    - Dmitry Torokhov <dmitry.torokhov@gmail.com>
> diff --git a/Documentation/devicetree/bindings/input/touchscreen/silead,gsl1680.yaml b/Documentation/devicetree/bindings/input/touchscreen/silead,gsl1680.yaml
> index eec6f7f6f0a3..95b554be25b4 100644
> --- a/Documentation/devicetree/bindings/input/touchscreen/silead,gsl1680.yaml
> +++ b/Documentation/devicetree/bindings/input/touchscreen/silead,gsl1680.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/input/touchscreen/silead,gsl1680.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Silead GSL1680 Touchscreen Controller Device Tree Bindings
> +title: Silead GSL1680 Touchscreen Controller
>  
>  maintainers:
>    - Dmitry Torokhov <dmitry.torokhov@gmail.com>
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/ingenic,intc.yaml b/Documentation/devicetree/bindings/interrupt-controller/ingenic,intc.yaml
> index 0358a7739c8e..609308a5f91d 100644
> --- a/Documentation/devicetree/bindings/interrupt-controller/ingenic,intc.yaml
> +++ b/Documentation/devicetree/bindings/interrupt-controller/ingenic,intc.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/interrupt-controller/ingenic,intc.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ingenic SoCs interrupt controller devicetree bindings
> +title: Ingenic SoCs interrupt controller
>  
>  maintainers:
>    - Paul Cercueil <paul@crapouillou.net>
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/realtek,rtl-intc.yaml b/Documentation/devicetree/bindings/interrupt-controller/realtek,rtl-intc.yaml
> index 13a893b18fb6..fb5593724059 100644
> --- a/Documentation/devicetree/bindings/interrupt-controller/realtek,rtl-intc.yaml
> +++ b/Documentation/devicetree/bindings/interrupt-controller/realtek,rtl-intc.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/interrupt-controller/realtek,rtl-intc.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Realtek RTL SoC interrupt controller devicetree bindings
> +title: Realtek RTL SoC interrupt controller
>  
>  description:
>    Interrupt controller and router for Realtek MIPS SoCs, allowing each SoC
> diff --git a/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9768.yaml b/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9768.yaml
> index 21864ab86ec4..82d3d18c16a1 100644
> --- a/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9768.yaml
> +++ b/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9768.yaml
> @@ -5,7 +5,7 @@
>  $id: http://devicetree.org/schemas/media/i2c/dongwoon,dw9768.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Dongwoon Anatech DW9768 Voice Coil Motor (VCM) Lens Device Tree Bindings
> +title: Dongwoon Anatech DW9768 Voice Coil Motor (VCM) Lens
>  
>  maintainers:
>    - Dongchun Zhu <dongchun.zhu@mediatek.com>
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov8856.yaml b/Documentation/devicetree/bindings/media/i2c/ov8856.yaml
> index baf92aaaf049..e17288d57981 100644
> --- a/Documentation/devicetree/bindings/media/i2c/ov8856.yaml
> +++ b/Documentation/devicetree/bindings/media/i2c/ov8856.yaml
> @@ -5,7 +5,7 @@
>  $id: http://devicetree.org/schemas/media/i2c/ov8856.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Omnivision OV8856 CMOS Sensor Device Tree Bindings
> +title: Omnivision OV8856 CMOS Sensor
>  
>  maintainers:
>    - Dongchun Zhu <dongchun.zhu@mediatek.com>
> diff --git a/Documentation/devicetree/bindings/media/i2c/ovti,ov02a10.yaml b/Documentation/devicetree/bindings/media/i2c/ovti,ov02a10.yaml
> index 63a040944f3d..54df9d73dc86 100644
> --- a/Documentation/devicetree/bindings/media/i2c/ovti,ov02a10.yaml
> +++ b/Documentation/devicetree/bindings/media/i2c/ovti,ov02a10.yaml
> @@ -5,7 +5,7 @@
>  $id: http://devicetree.org/schemas/media/i2c/ovti,ov02a10.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Omnivision OV02A10 CMOS Sensor Device Tree Bindings
> +title: Omnivision OV02A10 CMOS Sensor
>  
>  maintainers:
>    - Dongchun Zhu <dongchun.zhu@mediatek.com>
> diff --git a/Documentation/devicetree/bindings/media/i2c/ovti,ov5640.yaml b/Documentation/devicetree/bindings/media/i2c/ovti,ov5640.yaml
> index 540fd69ac39f..a621032f9bd0 100644
> --- a/Documentation/devicetree/bindings/media/i2c/ovti,ov5640.yaml
> +++ b/Documentation/devicetree/bindings/media/i2c/ovti,ov5640.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/media/i2c/ovti,ov5640.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: OmniVision OV5640 Image Sensor Device Tree Bindings
> +title: OmniVision OV5640 Image Sensor
>  
>  maintainers:
>    - Steve Longerbeam <slongerbeam@gmail.com>
> diff --git a/Documentation/devicetree/bindings/media/i2c/ovti,ov5648.yaml b/Documentation/devicetree/bindings/media/i2c/ovti,ov5648.yaml
> index 246dc5fec716..61e4e9cf8783 100644
> --- a/Documentation/devicetree/bindings/media/i2c/ovti,ov5648.yaml
> +++ b/Documentation/devicetree/bindings/media/i2c/ovti,ov5648.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/media/i2c/ovti,ov5648.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: OmniVision OV5648 Image Sensor Device Tree Bindings
> +title: OmniVision OV5648 Image Sensor
>  
>  maintainers:
>    - Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> diff --git a/Documentation/devicetree/bindings/media/i2c/ovti,ov8865.yaml b/Documentation/devicetree/bindings/media/i2c/ovti,ov8865.yaml
> index b962863e4f65..6bac326dceaf 100644
> --- a/Documentation/devicetree/bindings/media/i2c/ovti,ov8865.yaml
> +++ b/Documentation/devicetree/bindings/media/i2c/ovti,ov8865.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/media/i2c/ovti,ov8865.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: OmniVision OV8865 Image Sensor Device Tree Bindings
> +title: OmniVision OV8865 Image Sensor
>  
>  maintainers:
>    - Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> diff --git a/Documentation/devicetree/bindings/media/i2c/st,st-vgxy61.yaml b/Documentation/devicetree/bindings/media/i2c/st,st-vgxy61.yaml
> index 6597e1d0e65f..8c28848b226a 100644
> --- a/Documentation/devicetree/bindings/media/i2c/st,st-vgxy61.yaml
> +++ b/Documentation/devicetree/bindings/media/i2c/st,st-vgxy61.yaml
> @@ -5,7 +5,7 @@
>  $id: http://devicetree.org/schemas/media/i2c/st,st-vgxy61.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: STMicroelectronics VGxy61 HDR Global Shutter Sensor Family Device Tree Bindings
> +title: STMicroelectronics VGxy61 HDR Global Shutter Sensor Family
>  
>  maintainers:
>    - Benjamin Mugnier <benjamin.mugnier@foss.st.com>
> diff --git a/Documentation/devicetree/bindings/memory-controllers/ingenic,nemc-peripherals.yaml b/Documentation/devicetree/bindings/memory-controllers/ingenic,nemc-peripherals.yaml
> index b8ed52a44d57..89ebe3979012 100644
> --- a/Documentation/devicetree/bindings/memory-controllers/ingenic,nemc-peripherals.yaml
> +++ b/Documentation/devicetree/bindings/memory-controllers/ingenic,nemc-peripherals.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/memory-controllers/ingenic,nemc-peripherals.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ingenic SoCs NAND / External Memory Controller (NEMC) devicetree bindings
> +title: Ingenic SoCs NAND / External Memory Controller (NEMC)
>  
>  maintainers:
>    - Paul Cercueil <paul@crapouillou.net>
> diff --git a/Documentation/devicetree/bindings/memory-controllers/ingenic,nemc.yaml b/Documentation/devicetree/bindings/memory-controllers/ingenic,nemc.yaml
> index dd13a5106d6c..a02724221ff3 100644
> --- a/Documentation/devicetree/bindings/memory-controllers/ingenic,nemc.yaml
> +++ b/Documentation/devicetree/bindings/memory-controllers/ingenic,nemc.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/memory-controllers/ingenic,nemc.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ingenic SoCs NAND / External Memory Controller (NEMC) devicetree bindings
> +title: Ingenic SoCs NAND / External Memory Controller (NEMC)
>  
>  maintainers:
>    - Paul Cercueil <paul@crapouillou.net>
> diff --git a/Documentation/devicetree/bindings/memory-controllers/ti,gpmc.yaml b/Documentation/devicetree/bindings/memory-controllers/ti,gpmc.yaml
> index e188a4bf755c..4f30173ad747 100644
> --- a/Documentation/devicetree/bindings/memory-controllers/ti,gpmc.yaml
> +++ b/Documentation/devicetree/bindings/memory-controllers/ti,gpmc.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/memory-controllers/ti,gpmc.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Texas Instruments GPMC Memory Controller device-tree bindings
> +title: Texas Instruments GPMC Memory Controller
>  
>  maintainers:
>    - Tony Lindgren <tony@atomide.com>
> diff --git a/Documentation/devicetree/bindings/mips/ingenic/devices.yaml b/Documentation/devicetree/bindings/mips/ingenic/devices.yaml
> index ee00d414df10..f2e822afe7fb 100644
> --- a/Documentation/devicetree/bindings/mips/ingenic/devices.yaml
> +++ b/Documentation/devicetree/bindings/mips/ingenic/devices.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/mips/ingenic/devices.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ingenic XBurst based Platforms Device Tree Bindings
> +title: Ingenic XBurst based Platforms
>  
>  maintainers:
>    - 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
> diff --git a/Documentation/devicetree/bindings/mips/lantiq/lantiq,dma-xway.yaml b/Documentation/devicetree/bindings/mips/lantiq/lantiq,dma-xway.yaml
> index 40130fefa2b4..15d41bdbdc26 100644
> --- a/Documentation/devicetree/bindings/mips/lantiq/lantiq,dma-xway.yaml
> +++ b/Documentation/devicetree/bindings/mips/lantiq/lantiq,dma-xway.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/mips/lantiq/lantiq,dma-xway.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Lantiq Xway SoCs DMA Controller DT bindings
> +title: Lantiq Xway SoCs DMA Controller
>  
>  maintainers:
>    - John Crispin <john@phrozen.org>
> diff --git a/Documentation/devicetree/bindings/mips/loongson/devices.yaml b/Documentation/devicetree/bindings/mips/loongson/devices.yaml
> index 9fee6708e6f5..f13ce386f42c 100644
> --- a/Documentation/devicetree/bindings/mips/loongson/devices.yaml
> +++ b/Documentation/devicetree/bindings/mips/loongson/devices.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/mips/loongson/devices.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Loongson based Platforms Device Tree Bindings
> +title: Loongson based Platforms
>  
>  maintainers:
>    - Jiaxun Yang <jiaxun.yang@flygoat.com>
> diff --git a/Documentation/devicetree/bindings/mmc/ingenic,mmc.yaml b/Documentation/devicetree/bindings/mmc/ingenic,mmc.yaml
> index 2d10aedf2e00..bb4e0be0c893 100644
> --- a/Documentation/devicetree/bindings/mmc/ingenic,mmc.yaml
> +++ b/Documentation/devicetree/bindings/mmc/ingenic,mmc.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/mmc/ingenic,mmc.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ingenic SoCs MMC Controller DT bindings
> +title: Ingenic SoCs MMC Controller
>  
>  maintainers:
>    - Paul Cercueil <paul@crapouillou.net>
> diff --git a/Documentation/devicetree/bindings/mtd/ingenic,nand.yaml b/Documentation/devicetree/bindings/mtd/ingenic,nand.yaml
> index 8c272c842bfd..cd1aa91d4b2b 100644
> --- a/Documentation/devicetree/bindings/mtd/ingenic,nand.yaml
> +++ b/Documentation/devicetree/bindings/mtd/ingenic,nand.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/mtd/ingenic,nand.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ingenic SoCs NAND controller devicetree bindings
> +title: Ingenic SoCs NAND controller
>  
>  maintainers:
>    - Paul Cercueil <paul@crapouillou.net>
> diff --git a/Documentation/devicetree/bindings/net/can/allwinner,sun4i-a10-can.yaml b/Documentation/devicetree/bindings/net/can/allwinner,sun4i-a10-can.yaml
> index 3c51b2d02957..9c494957a07a 100644
> --- a/Documentation/devicetree/bindings/net/can/allwinner,sun4i-a10-can.yaml
> +++ b/Documentation/devicetree/bindings/net/can/allwinner,sun4i-a10-can.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/net/can/allwinner,sun4i-a10-can.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Allwinner A10 CAN Controller Device Tree Bindings
> +title: Allwinner A10 CAN Controller
>  
>  maintainers:
>    - Chen-Yu Tsai <wens@csie.org>
> diff --git a/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
> index 51aa89ac7e85..4d7d67ee175a 100644
> --- a/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
> +++ b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/net/can/bosch,c_can.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Bosch C_CAN/D_CAN controller Device Tree Bindings
> +title: Bosch C_CAN/D_CAN controller
>  
>  description: Bosch C_CAN/D_CAN controller for CAN bus
>  
> diff --git a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
> index 4635cb96fc64..a009a4402938 100644
> --- a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
> +++ b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/net/can/ctu,ctucanfd.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: CTU CAN FD Open-source IP Core Device Tree Bindings
> +title: CTU CAN FD Open-source IP Core
>  
>  description: |
>    Open-source CAN FD IP core developed at the Czech Technical University in Prague
> diff --git a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> index 259a0c6547f3..2a6d126606ca 100644
> --- a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/net/dsa/arrow,xrs700x.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Arrow SpeedChips XRS7000 Series Switch Device Tree Bindings
> +title: Arrow SpeedChips XRS7000 Series Switch
>  
>  allOf:
>    - $ref: dsa.yaml#
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> index 9abb8eba5fad..b173fceb8998 100644
> --- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/net/dsa/dsa-port.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ethernet Switch port Device Tree Bindings
> +title: Ethernet Switch port
>  
>  maintainers:
>    - Andrew Lunn <andrew@lunn.ch>
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> index b9d48e357e77..5469ae8a4389 100644
> --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/net/dsa/dsa.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ethernet Switch Device Tree Bindings
> +title: Ethernet Switch
>  
>  maintainers:
>    - Andrew Lunn <andrew@lunn.ch>
> diff --git a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
> index 73b774eadd0b..b0869df3059c 100644
> --- a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/net/dsa/hirschmann,hellcreek.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Hirschmann Hellcreek TSN Switch Device Tree Bindings
> +title: Hirschmann Hellcreek TSN Switch
>  
>  allOf:
>    - $ref: dsa.yaml#
> diff --git a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
> index 8d93ed9c172c..347a0e1b3d3f 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/net/dsa/mscc,ocelot.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Microchip Ocelot Switch Family Device Tree Bindings
> +title: Microchip Ocelot Switch Family
>  
>  maintainers:
>    - Vladimir Oltean <vladimir.oltean@nxp.com>
> diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
> index 1e26d876d146..df98a16e4e75 100644
> --- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/net/dsa/nxp,sja1105.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: NXP SJA1105 Automotive Ethernet Switch Family Device Tree Bindings
> +title: NXP SJA1105 Automotive Ethernet Switch Family
>  
>  description:
>    The SJA1105 SPI interface requires a CS-to-CLK time (t2 in UM10944.pdf) of at
> diff --git a/Documentation/devicetree/bindings/net/wireless/esp,esp8089.yaml b/Documentation/devicetree/bindings/net/wireless/esp,esp8089.yaml
> index 284ef45add99..5557676e9d4b 100644
> --- a/Documentation/devicetree/bindings/net/wireless/esp,esp8089.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/esp,esp8089.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/net/wireless/esp,esp8089.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Espressif ESP8089 Device Tree Bindings
> +title: Espressif ESP8089
>  
>  maintainers:
>    - Hans de Goede <hdegoede@redhat.com>
> diff --git a/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml b/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
> index b3405f284580..2460ccc08237 100644
> --- a/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/net/wireless/microchip,wilc1000.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Microchip WILC wireless devicetree bindings
> +title: Microchip WILC wireless
>  
>  maintainers:
>    - Adham Abozaeid <adham.abozaeid@microchip.com>
> diff --git a/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml b/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
> index b35d2f3ad1ad..583db5d42226 100644
> --- a/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
> @@ -6,7 +6,7 @@
>  $id: http://devicetree.org/schemas/net/wireless/silabs,wfx.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Silicon Labs WFxxx devicetree bindings
> +title: Silicon Labs WFxxx
>  
>  maintainers:
>    - Jérôme Pouiller <jerome.pouiller@silabs.com>
> diff --git a/Documentation/devicetree/bindings/nvmem/qcom,spmi-sdam.yaml b/Documentation/devicetree/bindings/nvmem/qcom,spmi-sdam.yaml
> index ee79e13b5fe0..e08504ef3b6e 100644
> --- a/Documentation/devicetree/bindings/nvmem/qcom,spmi-sdam.yaml
> +++ b/Documentation/devicetree/bindings/nvmem/qcom,spmi-sdam.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/nvmem/qcom,spmi-sdam.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Qualcomm Technologies, Inc. SPMI SDAM DT bindings
> +title: Qualcomm Technologies, Inc. SPMI SDAM
>  
>  maintainers:
>    - Shyam Kumar Thella <sthella@codeaurora.org>
> diff --git a/Documentation/devicetree/bindings/phy/ingenic,phy-usb.yaml b/Documentation/devicetree/bindings/phy/ingenic,phy-usb.yaml
> index 5cab21648632..30b42008db06 100644
> --- a/Documentation/devicetree/bindings/phy/ingenic,phy-usb.yaml
> +++ b/Documentation/devicetree/bindings/phy/ingenic,phy-usb.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/phy/ingenic,phy-usb.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ingenic SoCs USB PHY devicetree bindings
> +title: Ingenic SoCs USB PHY
>  
>  maintainers:
>    - Paul Cercueil <paul@crapouillou.net>
> diff --git a/Documentation/devicetree/bindings/pinctrl/ingenic,pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/ingenic,pinctrl.yaml
> index c2c370448b81..a4397930e0e8 100644
> --- a/Documentation/devicetree/bindings/pinctrl/ingenic,pinctrl.yaml
> +++ b/Documentation/devicetree/bindings/pinctrl/ingenic,pinctrl.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/pinctrl/ingenic,pinctrl.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ingenic SoCs pin controller devicetree bindings
> +title: Ingenic SoCs pin controller
>  
>  description: >
>    Please refer to pinctrl-bindings.txt in this directory for details of the
> diff --git a/Documentation/devicetree/bindings/power/reset/xlnx,zynqmp-power.yaml b/Documentation/devicetree/bindings/power/reset/xlnx,zynqmp-power.yaml
> index 46de35861738..11f1f98c1cdc 100644
> --- a/Documentation/devicetree/bindings/power/reset/xlnx,zynqmp-power.yaml
> +++ b/Documentation/devicetree/bindings/power/reset/xlnx,zynqmp-power.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/power/reset/xlnx,zynqmp-power.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Xilinx Zynq MPSoC Power Management Device Tree Bindings
> +title: Xilinx Zynq MPSoC Power Management
>  
>  maintainers:
>    - Michal Simek <michal.simek@xilinx.com>
> diff --git a/Documentation/devicetree/bindings/power/supply/maxim,ds2760.yaml b/Documentation/devicetree/bindings/power/supply/maxim,ds2760.yaml
> index c838efcf7e16..5faa2418fe2f 100644
> --- a/Documentation/devicetree/bindings/power/supply/maxim,ds2760.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/maxim,ds2760.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/power/supply/maxim,ds2760.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Maxim DS2760 DT bindings
> +title: Maxim DS2760
>  
>  maintainers:
>    - Sebastian Reichel <sre@kernel.org>
> diff --git a/Documentation/devicetree/bindings/power/supply/maxim,max14656.yaml b/Documentation/devicetree/bindings/power/supply/maxim,max14656.yaml
> index 070ef6f96e60..711066b8cdb9 100644
> --- a/Documentation/devicetree/bindings/power/supply/maxim,max14656.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/maxim,max14656.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/power/supply/maxim,max14656.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Maxim MAX14656 DT bindings
> +title: Maxim MAX14656
>  
>  maintainers:
>    - Sebastian Reichel <sre@kernel.org>
> diff --git a/Documentation/devicetree/bindings/rtc/epson,rx8900.yaml b/Documentation/devicetree/bindings/rtc/epson,rx8900.yaml
> index d12855e7ffd7..1df7c45d95c1 100644
> --- a/Documentation/devicetree/bindings/rtc/epson,rx8900.yaml
> +++ b/Documentation/devicetree/bindings/rtc/epson,rx8900.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/rtc/epson,rx8900.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: EPSON RX8900 / Microcrystal RV8803 Real-Time Clock DT bindings
> +title: EPSON RX8900 / Microcrystal RV8803 Real-Time Clock
>  
>  maintainers:
>    - Marek Vasut <marex@denx.de>
> diff --git a/Documentation/devicetree/bindings/rtc/ingenic,rtc.yaml b/Documentation/devicetree/bindings/rtc/ingenic,rtc.yaml
> index b235b2441997..af78b67b3da4 100644
> --- a/Documentation/devicetree/bindings/rtc/ingenic,rtc.yaml
> +++ b/Documentation/devicetree/bindings/rtc/ingenic,rtc.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/rtc/ingenic,rtc.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ingenic SoCs Real-Time Clock DT bindings
> +title: Ingenic SoCs Real-Time Clock
>  
>  maintainers:
>    - Paul Cercueil <paul@crapouillou.net>
> diff --git a/Documentation/devicetree/bindings/rtc/renesas,rzn1-rtc.yaml b/Documentation/devicetree/bindings/rtc/renesas,rzn1-rtc.yaml
> index 2d4741f51663..f6e0c613af67 100644
> --- a/Documentation/devicetree/bindings/rtc/renesas,rzn1-rtc.yaml
> +++ b/Documentation/devicetree/bindings/rtc/renesas,rzn1-rtc.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/rtc/renesas,rzn1-rtc.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Renesas RZ/N1 SoCs Real-Time Clock DT bindings
> +title: Renesas RZ/N1 SoCs Real-Time Clock
>  
>  maintainers:
>    - Miquel Raynal <miquel.raynal@bootlin.com>
> diff --git a/Documentation/devicetree/bindings/serial/brcm,bcm7271-uart.yaml b/Documentation/devicetree/bindings/serial/brcm,bcm7271-uart.yaml
> index 6d176588df47..89c462653e2d 100644
> --- a/Documentation/devicetree/bindings/serial/brcm,bcm7271-uart.yaml
> +++ b/Documentation/devicetree/bindings/serial/brcm,bcm7271-uart.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/serial/brcm,bcm7271-uart.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Broadcom 8250 based serial port devicetree bindings
> +title: Broadcom 8250 based serial port
>  
>  maintainers:
>    - Al Cooper <alcooperx@gmail.com>
> diff --git a/Documentation/devicetree/bindings/serial/ingenic,uart.yaml b/Documentation/devicetree/bindings/serial/ingenic,uart.yaml
> index 315ceb722e19..d5f153bdeb0d 100644
> --- a/Documentation/devicetree/bindings/serial/ingenic,uart.yaml
> +++ b/Documentation/devicetree/bindings/serial/ingenic,uart.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/serial/ingenic,uart.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ingenic SoCs UART controller devicetree bindings
> +title: Ingenic SoCs UART controller
>  
>  maintainers:
>    - Paul Cercueil <paul@crapouillou.net>
> diff --git a/Documentation/devicetree/bindings/serial/serial.yaml b/Documentation/devicetree/bindings/serial/serial.yaml
> index c75ba3fb6465..11e822bf09e2 100644
> --- a/Documentation/devicetree/bindings/serial/serial.yaml
> +++ b/Documentation/devicetree/bindings/serial/serial.yaml
> @@ -4,7 +4,7 @@
>  $id: "http://devicetree.org/schemas/serial/serial.yaml#"
>  $schema: "http://devicetree.org/meta-schemas/core.yaml#"
>  
> -title: Serial Interface Generic DT Bindings
> +title: Serial Interface Generic
>  
>  maintainers:
>    - Rob Herring <robh@kernel.org>
> diff --git a/Documentation/devicetree/bindings/soc/mediatek/mtk-svs.yaml b/Documentation/devicetree/bindings/soc/mediatek/mtk-svs.yaml
> index d911fa2d40ef..f21eb907ee90 100644
> --- a/Documentation/devicetree/bindings/soc/mediatek/mtk-svs.yaml
> +++ b/Documentation/devicetree/bindings/soc/mediatek/mtk-svs.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/soc/mediatek/mtk-svs.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: MediaTek Smart Voltage Scaling (SVS) Device Tree Bindings
> +title: MediaTek Smart Voltage Scaling (SVS)
>  
>  maintainers:
>    - Roger Lu <roger.lu@mediatek.com>
> diff --git a/Documentation/devicetree/bindings/sound/cirrus,cs42l51.yaml b/Documentation/devicetree/bindings/sound/cirrus,cs42l51.yaml
> index 963a871e74da..1a4e00a8c5ca 100644
> --- a/Documentation/devicetree/bindings/sound/cirrus,cs42l51.yaml
> +++ b/Documentation/devicetree/bindings/sound/cirrus,cs42l51.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/sound/cirrus,cs42l51.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: CS42L51 audio codec DT bindings
> +title: CS42L51 audio codec
>  
>  maintainers:
>    - Olivier Moysan <olivier.moysan@foss.st.com>
> diff --git a/Documentation/devicetree/bindings/sound/ingenic,aic.yaml b/Documentation/devicetree/bindings/sound/ingenic,aic.yaml
> index c4f9b3c2bde5..a96cc2098539 100644
> --- a/Documentation/devicetree/bindings/sound/ingenic,aic.yaml
> +++ b/Documentation/devicetree/bindings/sound/ingenic,aic.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/sound/ingenic,aic.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ingenic SoCs AC97 / I2S Controller (AIC) DT bindings
> +title: Ingenic SoCs AC97 / I2S Controller (AIC)
>  
>  maintainers:
>    - Paul Cercueil <paul@crapouillou.net>
> diff --git a/Documentation/devicetree/bindings/sound/ingenic,codec.yaml b/Documentation/devicetree/bindings/sound/ingenic,codec.yaml
> index 48aae54dd643..23a606931347 100644
> --- a/Documentation/devicetree/bindings/sound/ingenic,codec.yaml
> +++ b/Documentation/devicetree/bindings/sound/ingenic,codec.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/sound/ingenic,codec.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ingenic JZ47xx internal codec DT bindings
> +title: Ingenic JZ47xx internal codec
>  
>  maintainers:
>    - Paul Cercueil <paul@crapouillou.net>
> diff --git a/Documentation/devicetree/bindings/sound/qcom,lpass-rx-macro.yaml b/Documentation/devicetree/bindings/sound/qcom,lpass-rx-macro.yaml
> index 14016671f32b..42facaba3f83 100644
> --- a/Documentation/devicetree/bindings/sound/qcom,lpass-rx-macro.yaml
> +++ b/Documentation/devicetree/bindings/sound/qcom,lpass-rx-macro.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/sound/qcom,lpass-rx-macro.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: LPASS(Low Power Audio Subsystem) RX Macro audio codec DT bindings
> +title: LPASS(Low Power Audio Subsystem) RX Macro audio codec
>  
>  maintainers:
>    - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> diff --git a/Documentation/devicetree/bindings/sound/qcom,lpass-tx-macro.yaml b/Documentation/devicetree/bindings/sound/qcom,lpass-tx-macro.yaml
> index e647ba392a0f..a2afa85c1b2f 100644
> --- a/Documentation/devicetree/bindings/sound/qcom,lpass-tx-macro.yaml
> +++ b/Documentation/devicetree/bindings/sound/qcom,lpass-tx-macro.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/sound/qcom,lpass-tx-macro.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: LPASS(Low Power Audio Subsystem) TX Macro audio codec DT bindings
> +title: LPASS(Low Power Audio Subsystem) TX Macro audio codec
>  
>  maintainers:
>    - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> diff --git a/Documentation/devicetree/bindings/sound/qcom,lpass-va-macro.yaml b/Documentation/devicetree/bindings/sound/qcom,lpass-va-macro.yaml
> index c36caf90b837..625be7e5aaf7 100644
> --- a/Documentation/devicetree/bindings/sound/qcom,lpass-va-macro.yaml
> +++ b/Documentation/devicetree/bindings/sound/qcom,lpass-va-macro.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/sound/qcom,lpass-va-macro.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: LPASS(Low Power Audio Subsystem) VA Macro audio codec DT bindings
> +title: LPASS(Low Power Audio Subsystem) VA Macro audio codec
>  
>  maintainers:
>    - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> diff --git a/Documentation/devicetree/bindings/sound/qcom,lpass-wsa-macro.yaml b/Documentation/devicetree/bindings/sound/qcom,lpass-wsa-macro.yaml
> index 155c7344412a..09f541887423 100644
> --- a/Documentation/devicetree/bindings/sound/qcom,lpass-wsa-macro.yaml
> +++ b/Documentation/devicetree/bindings/sound/qcom,lpass-wsa-macro.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/sound/qcom,lpass-wsa-macro.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: LPASS(Low Power Audio Subsystem) VA Macro audio codec DT bindings
> +title: LPASS(Low Power Audio Subsystem) VA Macro audio codec
>  
>  maintainers:
>    - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> diff --git a/Documentation/devicetree/bindings/sound/realtek,rt1015p.yaml b/Documentation/devicetree/bindings/sound/realtek,rt1015p.yaml
> index ea7d4900ee4a..7dac9e6f7f08 100644
> --- a/Documentation/devicetree/bindings/sound/realtek,rt1015p.yaml
> +++ b/Documentation/devicetree/bindings/sound/realtek,rt1015p.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/sound/realtek,rt1015p.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Realtek rt1015p codec devicetree bindings
> +title: Realtek rt1015p codec
>  
>  maintainers:
>    - Tzung-Bi Shih <tzungbi@kernel.org>
> diff --git a/Documentation/devicetree/bindings/sound/realtek,rt5682s.yaml b/Documentation/devicetree/bindings/sound/realtek,rt5682s.yaml
> index dc418652f241..73a4a509fd86 100644
> --- a/Documentation/devicetree/bindings/sound/realtek,rt5682s.yaml
> +++ b/Documentation/devicetree/bindings/sound/realtek,rt5682s.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/sound/realtek,rt5682s.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Realtek rt5682s codec devicetree bindings
> +title: Realtek rt5682s codec
>  
>  maintainers:
>    - Derek Fang <derek.fang@realtek.com>
> diff --git a/Documentation/devicetree/bindings/sound/ti,src4xxx.yaml b/Documentation/devicetree/bindings/sound/ti,src4xxx.yaml
> index 9681b72b4918..d5e3cbe9b935 100644
> --- a/Documentation/devicetree/bindings/sound/ti,src4xxx.yaml
> +++ b/Documentation/devicetree/bindings/sound/ti,src4xxx.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/sound/ti,src4xxx.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Texas Instruments SRC4392 Device Tree Bindings
> +title: Texas Instruments SRC4392
>  
>  description: |
>    The SRC4392 is a digital audio codec that can be connected via
> diff --git a/Documentation/devicetree/bindings/spi/ingenic,spi.yaml b/Documentation/devicetree/bindings/spi/ingenic,spi.yaml
> index 360f76c226d9..c08d55b900bb 100644
> --- a/Documentation/devicetree/bindings/spi/ingenic,spi.yaml
> +++ b/Documentation/devicetree/bindings/spi/ingenic,spi.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/spi/ingenic,spi.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ingenic SoCs SPI controller devicetree bindings
> +title: Ingenic SoCs SPI controller
>  
>  maintainers:
>    - Artur Rojek <contact@artur-rojek.eu>
> diff --git a/Documentation/devicetree/bindings/spi/spi-gpio.yaml b/Documentation/devicetree/bindings/spi/spi-gpio.yaml
> index 0d0b6d9dad1c..f29b89076c99 100644
> --- a/Documentation/devicetree/bindings/spi/spi-gpio.yaml
> +++ b/Documentation/devicetree/bindings/spi/spi-gpio.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/spi/spi-gpio.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: SPI-GPIO devicetree bindings
> +title: SPI-GPIO
>  
>  maintainers:
>    - Rob Herring <robh@kernel.org>
> diff --git a/Documentation/devicetree/bindings/timer/ingenic,tcu.yaml b/Documentation/devicetree/bindings/timer/ingenic,tcu.yaml
> index a84fef0fe628..2d14610888a7 100644
> --- a/Documentation/devicetree/bindings/timer/ingenic,tcu.yaml
> +++ b/Documentation/devicetree/bindings/timer/ingenic,tcu.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/timer/ingenic,tcu.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ingenic SoCs Timer/Counter Unit (TCU) devicetree bindings
> +title: Ingenic SoCs Timer/Counter Unit (TCU)
>  
>  description: |
>    For a description of the TCU hardware and drivers, have a look at
> diff --git a/Documentation/devicetree/bindings/usb/ingenic,musb.yaml b/Documentation/devicetree/bindings/usb/ingenic,musb.yaml
> index 59212358fcce..4cc1496a913c 100644
> --- a/Documentation/devicetree/bindings/usb/ingenic,musb.yaml
> +++ b/Documentation/devicetree/bindings/usb/ingenic,musb.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/usb/ingenic,musb.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ingenic JZ47xx USB IP DT bindings
> +title: Ingenic JZ47xx USB IP
>  
>  maintainers:
>    - Paul Cercueil <paul@crapouillou.net>
> diff --git a/Documentation/devicetree/bindings/usb/maxim,max33359.yaml b/Documentation/devicetree/bindings/usb/maxim,max33359.yaml
> index 93a19eda610b..8e513a6af378 100644
> --- a/Documentation/devicetree/bindings/usb/maxim,max33359.yaml
> +++ b/Documentation/devicetree/bindings/usb/maxim,max33359.yaml
> @@ -4,7 +4,7 @@
>  $id: "http://devicetree.org/schemas/usb/maxim,max33359.yaml#"
>  $schema: "http://devicetree.org/meta-schemas/core.yaml#"
>  
> -title: Maxim TCPCI Type-C PD controller DT bindings
> +title: Maxim TCPCI Type-C PD controller
>  
>  maintainers:
>    - Badhri Jagan Sridharan <badhri@google.com>
> diff --git a/Documentation/devicetree/bindings/usb/mediatek,mt6360-tcpc.yaml b/Documentation/devicetree/bindings/usb/mediatek,mt6360-tcpc.yaml
> index 8db1f8b597c3..c72257c19220 100644
> --- a/Documentation/devicetree/bindings/usb/mediatek,mt6360-tcpc.yaml
> +++ b/Documentation/devicetree/bindings/usb/mediatek,mt6360-tcpc.yaml
> @@ -4,7 +4,7 @@
>  $id: "http://devicetree.org/schemas/usb/mediatek,mt6360-tcpc.yaml#"
>  $schema: "http://devicetree.org/meta-schemas/core.yaml#"
>  
> -title: Mediatek MT6360 Type-C Port Switch and Power Delivery controller DT bindings
> +title: Mediatek MT6360 Type-C Port Switch and Power Delivery controller
>  
>  maintainers:
>    - ChiYuan Huang <cy_huang@richtek.com>
> diff --git a/Documentation/devicetree/bindings/usb/ti,tps6598x.yaml b/Documentation/devicetree/bindings/usb/ti,tps6598x.yaml
> index a4c53b1f1af3..fef4acdc4773 100644
> --- a/Documentation/devicetree/bindings/usb/ti,tps6598x.yaml
> +++ b/Documentation/devicetree/bindings/usb/ti,tps6598x.yaml
> @@ -4,7 +4,7 @@
>  $id: "http://devicetree.org/schemas/usb/ti,tps6598x.yaml#"
>  $schema: "http://devicetree.org/meta-schemas/core.yaml#"
>  
> -title: Texas Instruments 6598x Type-C Port Switch and Power Delivery controller DT bindings
> +title: Texas Instruments 6598x Type-C Port Switch and Power Delivery controller
>  
>  maintainers:
>    - Bryan O'Donoghue <bryan.odonoghue@linaro.org>
> diff --git a/Documentation/devicetree/bindings/usb/willsemi,wusb3801.yaml b/Documentation/devicetree/bindings/usb/willsemi,wusb3801.yaml
> index 5aa4ffd67119..937670de01cc 100644
> --- a/Documentation/devicetree/bindings/usb/willsemi,wusb3801.yaml
> +++ b/Documentation/devicetree/bindings/usb/willsemi,wusb3801.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/usb/willsemi,wusb3801.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: WUSB3801 Type-C port controller DT bindings
> +title: WUSB3801 Type-C port controller
>  
>  description:
>    The Will Semiconductor WUSB3801 is a USB Type-C port controller which

