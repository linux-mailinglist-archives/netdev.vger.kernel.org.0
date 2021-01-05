Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C2B2EB663
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbhAEXoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:44:19 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:41808 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbhAEXoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 18:44:18 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 105Ngoas062857;
        Tue, 5 Jan 2021 17:42:50 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1609890170;
        bh=6dhfOFmcZvlhHUA7H0jJjPacgVUfTjK3LaKxIV3EFVQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=u1+jEY40acep8COqpooLBvAa/WyVfwYiXTGsLN1HL2YcOpLEpp0hCHrnIXdd6IzIy
         fHAzrBaAirWjFfMrAP+xFL+7SAXEdOrf7GANCKEuuar4UWoXdhijvqdt3EbqDOHdEO
         6nydFbUDiEqnSRWNDoCilUL5yH/+xXexFR7kwmQ4=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 105NgoF5036388
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 5 Jan 2021 17:42:50 -0600
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 5 Jan
 2021 17:42:49 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 5 Jan 2021 17:42:49 -0600
Received: from [10.250.37.61] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 105Ngn67081191;
        Tue, 5 Jan 2021 17:42:49 -0600
Subject: Re: [PATCH] dt-bindings: Add missing array size constraints
To:     Mathieu Poirier <mathieu.poirier@linaro.org>,
        Rob Herring <robh@kernel.org>
CC:     <devicetree@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        <linux-usb@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        <linux-remoteproc@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <dri-devel@lists.freedesktop.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        <linux-ide@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <netdev@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Marc Zyngier <maz@kernel.org>,
        <linux-riscv@lists.infradead.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Chen-Yu Tsai <wens@csie.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        <linux-serial@vger.kernel.org>, <linux-input@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-media@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        <linux-pm@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Stephen Boyd <sboyd@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-spi@vger.kernel.org>, Sebastian Reichel <sre@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <jic23@kernel.org>, <paul@crapouillou.net>
References: <20210104230253.2805217-1-robh@kernel.org>
 <20210105232729.GA2864340@xps15>
From:   Suman Anna <s-anna@ti.com>
Message-ID: <3223d736-285a-7465-03c6-4b73198fdaca@ti.com>
Date:   Tue, 5 Jan 2021 17:42:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210105232729.GA2864340@xps15>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/21 5:27 PM, Mathieu Poirier wrote:
> Adding Suman and Paul - guys please have a look.
> 
> On Mon, Jan 04, 2021 at 04:02:53PM -0700, Rob Herring wrote:
>> DT properties which can have multiple entries need to specify what the
>> entries are and define how many entries there can be. In the case of
>> only a single entry, just 'maxItems: 1' is sufficient.
>>
>> Add the missing entry constraints. These were found with a modified
>> meta-schema. Unfortunately, there are a few cases where the size
>> constraints are not defined such as common bindings, so the meta-schema
>> can't be part of the normal checks.
>>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: Stephen Boyd <sboyd@kernel.org>
>> Cc: Thierry Reding <thierry.reding@gmail.com>
>> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Cc: Chanwoo Choi <cw00.choi@samsung.com>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>> Cc: Jonathan Cameron <jic23@kernel.org>
>> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>> Cc: Chen-Yu Tsai <wens@csie.org>
>> Cc: Ulf Hansson <ulf.hansson@linaro.org>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Sebastian Reichel <sre@kernel.org>
>> Cc: Ohad Ben-Cohen <ohad@wizery.com>
>> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Rob Herring <robh@kernel.org>
>> ---
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-ide@vger.kernel.org
>> Cc: linux-clk@vger.kernel.org
>> Cc: dri-devel@lists.freedesktop.org
>> Cc: linux-gpio@vger.kernel.org
>> Cc: linux-iio@vger.kernel.org
>> Cc: linux-input@vger.kernel.org
>> Cc: linux-media@vger.kernel.org
>> Cc: linux-mmc@vger.kernel.org
>> Cc: netdev@vger.kernel.org
>> Cc: linux-pm@vger.kernel.org
>> Cc: linux-remoteproc@vger.kernel.org
>> Cc: linux-riscv@lists.infradead.org
>> Cc: linux-serial@vger.kernel.org
>> Cc: alsa-devel@alsa-project.org
>> Cc: linux-spi@vger.kernel.org
>> Cc: linux-usb@vger.kernel.org
>> ---
>>  .../socionext,uniphier-system-cache.yaml      |  4 ++--
>>  .../bindings/ata/sata_highbank.yaml           |  1 +
>>  .../bindings/clock/canaan,k210-clk.yaml       |  1 +
>>  .../bindings/display/brcm,bcm2711-hdmi.yaml   |  1 +
>>  .../bindings/display/brcm,bcm2835-hdmi.yaml   |  1 +
>>  .../display/panel/jdi,lt070me05000.yaml       |  1 +
>>  .../display/panel/mantix,mlaf057we51-x.yaml   |  3 ++-
>>  .../display/panel/novatek,nt36672a.yaml       |  1 +
>>  .../devicetree/bindings/dsp/fsl,dsp.yaml      |  2 +-
>>  .../devicetree/bindings/eeprom/at25.yaml      |  3 +--
>>  .../bindings/extcon/extcon-ptn5150.yaml       |  2 ++
>>  .../bindings/gpio/gpio-pca95xx.yaml           |  1 +
>>  .../bindings/iio/adc/adi,ad7768-1.yaml        |  2 ++
>>  .../bindings/iio/adc/aspeed,ast2400-adc.yaml  |  1 +
>>  .../bindings/iio/adc/lltc,ltc2496.yaml        |  2 +-
>>  .../bindings/iio/adc/qcom,spmi-vadc.yaml      |  1 +
>>  .../bindings/iio/adc/st,stm32-adc.yaml        |  2 ++
>>  .../iio/magnetometer/asahi-kasei,ak8975.yaml  |  1 +
>>  .../iio/potentiometer/adi,ad5272.yaml         |  1 +
>>  .../input/touchscreen/elan,elants_i2c.yaml    |  1 +
>>  .../interrupt-controller/fsl,intmux.yaml      |  2 +-
>>  .../interrupt-controller/st,stm32-exti.yaml   |  2 ++
>>  .../allwinner,sun4i-a10-video-engine.yaml     |  1 +
>>  .../devicetree/bindings/media/i2c/imx219.yaml |  1 +
>>  .../memory-controllers/exynos-srom.yaml       |  2 ++
>>  .../bindings/misc/fsl,dpaa2-console.yaml      |  1 +
>>  .../bindings/mmc/mmc-controller.yaml          |  2 ++
>>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   |  1 +
>>  .../bindings/net/ti,k3-am654-cpts.yaml        |  1 +
>>  .../phy/allwinner,sun4i-a10-usb-phy.yaml      |  2 ++
>>  .../phy/allwinner,sun50i-a64-usb-phy.yaml     |  2 ++
>>  .../phy/allwinner,sun50i-h6-usb-phy.yaml      |  2 ++
>>  .../phy/allwinner,sun5i-a13-usb-phy.yaml      |  2 ++
>>  .../phy/allwinner,sun6i-a31-usb-phy.yaml      |  2 ++
>>  .../phy/allwinner,sun8i-a23-usb-phy.yaml      |  2 ++
>>  .../phy/allwinner,sun8i-a83t-usb-phy.yaml     |  2 ++
>>  .../phy/allwinner,sun8i-h3-usb-phy.yaml       |  2 ++
>>  .../phy/allwinner,sun8i-r40-usb-phy.yaml      |  2 ++
>>  .../phy/allwinner,sun8i-v3s-usb-phy.yaml      |  2 ++
>>  .../phy/allwinner,sun9i-a80-usb-phy.yaml      | 19 ++++++++-----------
>>  .../phy/socionext,uniphier-ahci-phy.yaml      |  2 +-
>>  .../phy/socionext,uniphier-pcie-phy.yaml      |  2 +-
>>  .../phy/socionext,uniphier-usb3hs-phy.yaml    |  2 +-
>>  .../phy/socionext,uniphier-usb3ss-phy.yaml    |  2 +-
>>  .../bindings/phy/ti,phy-gmii-sel.yaml         |  2 +-
>>  .../pinctrl/aspeed,ast2400-pinctrl.yaml       |  3 +--
>>  .../pinctrl/aspeed,ast2500-pinctrl.yaml       |  4 ++--
>>  .../bindings/power/supply/bq25980.yaml        |  1 +
>>  .../bindings/remoteproc/ingenic,vpu.yaml      |  2 +-
>>  .../remoteproc/ti,omap-remoteproc.yaml        |  3 +++
>>  .../bindings/riscv/sifive-l2-cache.yaml       |  1 +
>>  .../bindings/serial/renesas,hscif.yaml        |  2 ++
>>  .../bindings/serial/renesas,scif.yaml         |  2 ++
>>  .../bindings/serial/renesas,scifa.yaml        |  2 ++
>>  .../bindings/serial/renesas,scifb.yaml        |  2 ++
>>  .../sound/allwinner,sun4i-a10-codec.yaml      |  1 +
>>  .../bindings/sound/google,sc7180-trogdor.yaml |  1 +
>>  .../bindings/sound/samsung,aries-wm8994.yaml  |  3 +++
>>  .../bindings/sound/samsung,midas-audio.yaml   |  2 ++
>>  .../devicetree/bindings/sound/tas2562.yaml    |  2 ++
>>  .../devicetree/bindings/sound/tas2770.yaml    |  2 ++
>>  .../bindings/sound/tlv320adcx140.yaml         |  1 +
>>  .../devicetree/bindings/spi/renesas,rspi.yaml |  2 ++
>>  .../devicetree/bindings/sram/sram.yaml        |  2 ++
>>  .../timer/allwinner,sun4i-a10-timer.yaml      |  2 ++
>>  .../bindings/timer/intel,ixp4xx-timer.yaml    |  2 +-
>>  .../usb/allwinner,sun4i-a10-musb.yaml         |  2 +-
>>  .../bindings/usb/brcm,usb-pinmap.yaml         |  3 +++
>>  .../devicetree/bindings/usb/generic-ehci.yaml |  1 +
>>  .../devicetree/bindings/usb/generic-ohci.yaml |  1 +
>>  .../devicetree/bindings/usb/ingenic,musb.yaml |  2 +-
>>  .../bindings/usb/renesas,usbhs.yaml           |  1 +
>>  .../devicetree/bindings/usb/ti,j721e-usb.yaml |  3 ++-
>>  .../bindings/usb/ti,keystone-dwc3.yaml        |  2 ++
>>  74 files changed, 118 insertions(+), 33 deletions(-)
>>

[snip]

>>  
>> diff --git a/Documentation/devicetree/bindings/remoteproc/ingenic,vpu.yaml b/Documentation/devicetree/bindings/remoteproc/ingenic,vpu.yaml
>> index c019f9fbe916..d0aa91bbf5e5 100644
>> --- a/Documentation/devicetree/bindings/remoteproc/ingenic,vpu.yaml
>> +++ b/Documentation/devicetree/bindings/remoteproc/ingenic,vpu.yaml
>> @@ -44,7 +44,7 @@ properties:
>>        - const: vpu
>>  
>>    interrupts:
>> -    description: VPU hardware interrupt
>> +    maxItems: 1
>>  
>>  required:
>>    - compatible
>> diff --git a/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml b/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml
>> index 084960a8f17a..1a1159097a2a 100644
>> --- a/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml
>> +++ b/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml
>> @@ -70,10 +70,13 @@ properties:
>>        the firmware image.
>>  
>>    clocks:
>> +    maxItems: 1
>>      description: |
>>        Main functional clock for the remote processor
>>  
>>    resets:
>> +    minItems: 1
>> +    maxItems: 2

While this works for passing the schema, if we want to be specifically accurate
between the different remoteprocs, the DSPs will have 1 items while the IPUs
should have 2 items.

I can submit an incremental update if that's ok. Otherwise, for this file,

Reviewed-by: Suman Anna <s-anna@ti.com>


>>      description: |
>>        Reset handles for the remote processor
>>  

[snip]

regards
Suman
