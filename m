Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 375B3193379
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 23:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgCYWFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 18:05:47 -0400
Received: from mail-il1-f175.google.com ([209.85.166.175]:43780 "EHLO
        mail-il1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgCYWFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 18:05:47 -0400
Received: by mail-il1-f175.google.com with SMTP id g15so3465753ilj.10;
        Wed, 25 Mar 2020 15:05:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b/UNNUiqZNH/+Iv9VGZJuE2UKU7Uzk2Xjaa2yHi3k54=;
        b=h8YVqz004LvjsagR0EJUS0EuPZ3qLqxgEqYyDMivOMaWbrCU8E7pdyi9N4YIdg8OTX
         3tWrkESOi1CqPE1qEe+Z8nQaSdrAqf1fAsAFgL4Al+HS2vrqjLK1XboLDsNXhkx0ev6+
         0EZZ1UKqC1T5cMTOnIKLyvkt7RtlEhtjfMP9NOWwi+MkCZFC6Y5qyuIUUtL5NhYTYEVZ
         Q1EXNLNspmTlPRpT1q51dMo4o/k7vpdl0uRI2fGD+KPVdQZBnDZ4YdP25DXwvGkd5T+t
         /4TKrSZxtqZcjSgwNlngRlpGr2Bjw5wpdXxAkxOR3qZWFdfqYT72ssOzvRYmZeOobfg6
         52/A==
X-Gm-Message-State: ANhLgQ2E+MW6/mXKRRpf8ikFfyNvihMLGQ68XAOCjJDRRsehoMtdGkTN
        6HCStjWnRRwNi8P4jfI+4AMsPik=
X-Google-Smtp-Source: ADFU+vt2kokrkcEpGRLO2UvFmwmQbT400vUIkyFS/Pwj5bVyFFr+iqUWdZpWVM9WT6gFsFQdf7TdIQ==
X-Received: by 2002:a92:83ca:: with SMTP id p71mr5277381ilk.278.1585173944474;
        Wed, 25 Mar 2020 15:05:44 -0700 (PDT)
Received: from xps15.herring.priv ([64.188.179.250])
        by smtp.googlemail.com with ESMTPSA id v8sm102390ioh.40.2020.03.25.15.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 15:05:43 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Brian Masney <masneyb@onstation.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guillaume La Roque <glaroque@baylibre.com>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Jonathan Cameron <jic23@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zhang Rui <rui.zhang@intel.com>,
        dri-devel@lists.freedesktop.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 0/4] dt-bindings: additionalProperties clean-up
Date:   Wed, 25 Mar 2020 16:05:37 -0600
Message-Id: <20200325220542.19189-1-robh@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Setting 'additionalProperties: false' is frequently omitted, but is
important in order to check that there aren't extra undocumented
properties in a binding.

This series is a bunch of fixes in patches 1-3 found by setting
'additionalProperties: false' and then patch 4 sets additionalProperties
on a bunch of schema.

Rob


Rob Herring (4):
  dt-bindings: iio/accel: Drop duplicate adi,adxl345/6 from
    trivial-devices.yaml
  dt-bindings: sram: qcom: Clean-up 'ranges' and child node names
  dt-bindings: Clean-up schema errors due to missing
    'addtionalProperties: false'
  dt-bindings: Add missing 'additionalProperties: false'

 .../arm/altera/socfpga-clk-manager.yaml       |  2 ++
 .../amlogic/amlogic,meson-gx-ao-secure.yaml   |  2 ++
 .../bindings/arm/msm/qcom,llcc.yaml           |  2 ++
 .../devicetree/bindings/arm/renesas,prr.yaml  |  2 ++
 .../bindings/arm/samsung/exynos-chipid.yaml   |  2 ++
 .../devicetree/bindings/arm/samsung/pmu.yaml  |  2 ++
 .../arm/samsung/samsung-secure-firmware.yaml  |  2 ++
 .../bindings/arm/stm32/st,stm32-syscon.yaml   |  2 ++
 .../devicetree/bindings/clock/fsl,plldig.yaml |  5 ++++
 .../bindings/clock/imx8mn-clock.yaml          |  2 ++
 .../bindings/clock/imx8mp-clock.yaml          |  2 ++
 .../bindings/clock/milbeaut-clock.yaml        |  2 ++
 .../bindings/clock/qcom,gcc-apq8064.yaml      |  2 ++
 .../bindings/clock/qcom,gcc-ipq8074.yaml      |  2 ++
 .../bindings/clock/qcom,gcc-msm8996.yaml      |  2 ++
 .../bindings/clock/qcom,gcc-msm8998.yaml      |  2 ++
 .../bindings/clock/qcom,gcc-qcs404.yaml       |  2 ++
 .../bindings/clock/qcom,gcc-sc7180.yaml       |  2 ++
 .../bindings/clock/qcom,gcc-sm8150.yaml       |  2 ++
 .../devicetree/bindings/clock/qcom,gcc.yaml   |  2 ++
 .../devicetree/bindings/clock/qcom,mmcc.yaml  |  2 ++
 .../bindings/clock/qcom,msm8998-gpucc.yaml    |  2 ++
 .../bindings/clock/qcom,rpmhcc.yaml           |  2 ++
 .../bindings/clock/qcom,sc7180-dispcc.yaml    |  2 ++
 .../bindings/clock/qcom,sc7180-gpucc.yaml     |  2 ++
 .../bindings/clock/qcom,sc7180-videocc.yaml   |  2 ++
 .../bindings/clock/qcom,sdm845-dispcc.yaml    |  2 ++
 .../bindings/clock/qcom,sdm845-gpucc.yaml     |  2 ++
 .../bindings/clock/qcom,sdm845-videocc.yaml   |  2 ++
 .../bindings/display/amlogic,meson-vpu.yaml   |  2 ++
 .../bindings/dma/sifive,fu540-c000-pdma.yaml  |  2 ++
 .../devicetree/bindings/dsp/fsl,dsp.yaml      |  2 ++
 .../devicetree/bindings/eeprom/at24.yaml      |  2 ++
 ...ntel,ixp4xx-network-processing-engine.yaml |  3 +++
 .../bindings/gpio/brcm,xgs-iproc-gpio.yaml    |  2 ++
 .../gpio/socionext,uniphier-gpio.yaml         |  4 +++
 .../bindings/gpio/xylon,logicvc-gpio.yaml     |  2 ++
 .../bindings/gpu/arm,mali-bifrost.yaml        |  8 +++---
 .../bindings/gpu/arm,mali-midgard.yaml        |  5 ++++
 .../bindings/gpu/arm,mali-utgard.yaml         |  2 ++
 .../bindings/gpu/samsung-rotator.yaml         |  2 ++
 .../bindings/hwmon/adi,adm1177.yaml           |  2 ++
 .../bindings/hwmon/adi,ltc2947.yaml           |  2 ++
 .../bindings/hwmon/pmbus/ti,ucd90320.yaml     |  2 ++
 .../devicetree/bindings/hwmon/ti,tmp513.yaml  |  2 ++
 .../bindings/iio/accel/adi,adxl345.yaml       | 10 +++++---
 .../bindings/iio/accel/bosch,bma400.yaml      |  2 ++
 .../bindings/iio/adc/adi,ad7192.yaml          |  1 -
 .../bindings/iio/adc/adi,ad7780.yaml          |  2 ++
 .../bindings/iio/adc/avia-hx711.yaml          |  2 ++
 .../bindings/iio/adc/lltc,ltc2496.yaml        |  2 ++
 .../bindings/iio/adc/microchip,mcp3911.yaml   |  2 ++
 .../bindings/iio/adc/st,stm32-dfsdm-adc.yaml  |  2 ++
 .../iio/chemical/plantower,pms7003.yaml       |  2 ++
 .../iio/chemical/sensirion,sps30.yaml         |  2 ++
 .../bindings/iio/dac/lltc,ltc1660.yaml        |  2 ++
 .../bindings/iio/light/adux1020.yaml          |  2 ++
 .../devicetree/bindings/iio/light/bh1750.yaml |  2 ++
 .../bindings/iio/light/isl29018.yaml          |  2 ++
 .../bindings/iio/light/noa1305.yaml           |  2 ++
 .../bindings/iio/light/stk33xx.yaml           |  2 ++
 .../bindings/iio/light/tsl2583.yaml           |  2 ++
 .../bindings/iio/light/tsl2772.yaml           |  2 ++
 .../bindings/iio/light/veml6030.yaml          |  2 ++
 .../bindings/iio/pressure/asc,dlhl60d.yaml    |  2 ++
 .../bindings/iio/pressure/bmp085.yaml         |  5 ++++
 .../iio/proximity/devantech-srf04.yaml        |  2 ++
 .../bindings/iio/proximity/parallax-ping.yaml |  2 ++
 .../bindings/iio/temperature/adi,ltc2983.yaml |  2 ++
 .../bindings/input/gpio-vibrator.yaml         |  2 ++
 .../bindings/input/max77650-onkey.yaml        |  3 +++
 .../intel,ixp4xx-interrupt.yaml               |  2 ++
 .../bindings/iommu/samsung,sysmmu.yaml        |  2 ++
 .../bindings/leds/leds-max77650.yaml          |  3 +++
 .../bindings/leds/rohm,bd71828-leds.yaml      |  3 +++
 .../mailbox/amlogic,meson-gxbb-mhu.yaml       |  2 ++
 .../bindings/media/amlogic,gx-vdec.yaml       |  2 ++
 .../media/amlogic,meson-gx-ao-cec.yaml        | 11 +++++---
 .../bindings/media/renesas,ceu.yaml           |  2 ++
 .../devicetree/bindings/mfd/max77650.yaml     |  2 ++
 .../bindings/mfd/rohm,bd71828-pmic.yaml       |  5 ++++
 .../misc/intel,ixp4xx-ahb-queue-manager.yaml  |  2 ++
 .../bindings/net/ti,cpsw-switch.yaml          | 25 +++++++++++++------
 .../phy/allwinner,sun50i-h6-usb3-phy.yaml     |  2 ++
 .../phy/amlogic,meson-g12a-usb3-pcie-phy.yaml |  2 ++
 .../bindings/phy/intel,lgm-emmc-phy.yaml      |  2 ++
 .../bindings/phy/marvell,mmp3-hsic-phy.yaml   |  2 ++
 .../bindings/phy/ti,phy-j721e-wiz.yaml        |  2 ++
 .../pinctrl/aspeed,ast2400-pinctrl.yaml       |  2 ++
 .../pinctrl/aspeed,ast2500-pinctrl.yaml       |  2 ++
 .../pinctrl/aspeed,ast2600-pinctrl.yaml       |  2 ++
 .../bindings/pinctrl/st,stm32-pinctrl.yaml    |  2 ++
 .../bindings/power/amlogic,meson-ee-pwrc.yaml |  2 ++
 .../bindings/power/reset/syscon-poweroff.yaml |  2 ++
 .../bindings/power/reset/syscon-reboot.yaml   |  2 ++
 .../power/supply/max77650-charger.yaml        |  3 +++
 .../devicetree/bindings/ptp/ptp-idtcm.yaml    |  2 ++
 .../regulator/max77650-regulator.yaml         |  5 +++-
 .../bindings/reset/amlogic,meson-reset.yaml   |  2 ++
 .../reset/brcm,bcm7216-pcie-sata-rescal.yaml  |  2 ++
 .../bindings/rng/amlogic,meson-rng.yaml       |  2 ++
 .../devicetree/bindings/rng/brcm,bcm2835.yaml |  2 ++
 .../bindings/rtc/renesas,sh-rtc.yaml          |  2 ++
 .../devicetree/bindings/rtc/st,stm32-rtc.yaml |  2 ++
 .../bindings/serial/amlogic,meson-uart.yaml   |  2 ++
 .../bindings/soc/amlogic/amlogic,canvas.yaml  |  2 ++
 .../bindings/sound/adi,adau7118.yaml          |  2 ++
 .../bindings/sound/qcom,wcd934x.yaml          |  2 ++
 .../bindings/sound/renesas,fsi.yaml           |  2 ++
 .../bindings/sound/samsung,odroid.yaml        |  2 ++
 .../bindings/sound/samsung-i2s.yaml           |  2 ++
 .../devicetree/bindings/sram/qcom,ocmem.yaml  | 14 ++++++-----
 .../bindings/thermal/amlogic,thermal.yaml     |  4 +++
 .../bindings/timer/arm,arch_timer.yaml        |  2 ++
 .../bindings/timer/arm,arch_timer_mmio.yaml   |  4 +++
 .../bindings/timer/arm,global_timer.yaml      |  2 ++
 .../bindings/timer/intel,ixp4xx-timer.yaml    |  2 ++
 .../timer/samsung,exynos4210-mct.yaml         |  2 ++
 .../devicetree/bindings/trivial-devices.yaml  |  6 ++---
 119 files changed, 296 insertions(+), 29 deletions(-)

--
2.20.1
