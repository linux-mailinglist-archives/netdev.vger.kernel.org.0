Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8548D193FB2
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 14:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbgCZN2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 09:28:17 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37475 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgCZN2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 09:28:16 -0400
Received: by mail-qk1-f193.google.com with SMTP id x3so6309537qki.4
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 06:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BUYYK3rI/J7AIiF9MH5Ik3vfaCaUNhpHForO9Ru5Zzs=;
        b=wcghrVVKANqQ+71hBa1DPneHhmgRB5n0SiESvnPjKMWGrlabzu/g2I1yo8f8lTCz31
         hriW5Vgys3yhkRfMSzA7bL0V3eIq81Tnc6FiXzi1A81LN8OXMsBQStOA5I1X+DL0WTF6
         D+vUULv2j3t/P4n1/rm+bBXbgH4/SI3LwcFgQKk+wZKb6Uw+clvNBpdNqfInCwYdum5w
         S0MCkpzVNvbl5fZ9+2KeuX0qVBFrMSCbyzhy9sm0CabTgC0bzyOlueNIy2q3hjSmznA+
         8e0bWVrNx9D6ok5N6T83H77dccTJb4dz6dD0VaQOqJ0dIPTvStFaInauglIbczOLsM27
         6H/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BUYYK3rI/J7AIiF9MH5Ik3vfaCaUNhpHForO9Ru5Zzs=;
        b=qTpmIq/QppoqL0h3J79MMj6eRTLY5dvyMFtcsoY7IUTAmtrsbUHtJXVwkb2JAWQfJ2
         msg8oFczoaEIFbV48aUG/snTKXNA+Qw8WE+l8vmByNcJWHrStgM18/iVnJ4KGJoAZqrz
         DbLt24ZnvkCOVrWNMKKNul4zOsM459A37kaF7Nf6bag8+LSnQQrdoMxQHfPbzVnpLOsg
         9ZdBN7un5jaVegC8wGgQX4h7VmX1/C0avqYgsH4Bv/h7xHqkLcFYHITSp4eeJZyo9J43
         Jo4tL9oM+2wvClJ7RyBXazf7/er2L0hgMcQmAiizpmySK85w0IUMn5/OxOmFcOWBJv1f
         2w8A==
X-Gm-Message-State: ANhLgQ1Vwu2H+XK1TdMU0YWIVZE9i80Q+9GB46MEnpNO8KfDfW26Fd+S
        /qHbnmpo4WVsISzY6xYGGYBki86OdNb7aGBzNoNDTA==
X-Google-Smtp-Source: ADFU+vuK1nOkqDqRb9JsLOiD3nL7zoy8hZ3WlhlqX1cmh/optUTbEhIBrQEnQXJ5OUiXvCWdPi2mLl6+QW07As74sF8=
X-Received: by 2002:a37:4901:: with SMTP id w1mr7125242qka.427.1585229291849;
 Thu, 26 Mar 2020 06:28:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200325220542.19189-1-robh@kernel.org> <20200325220542.19189-5-robh@kernel.org>
In-Reply-To: <20200325220542.19189-5-robh@kernel.org>
From:   Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date:   Thu, 26 Mar 2020 14:27:58 +0100
Message-ID: <CA+M3ks7Y9YEUP_pc_Hyffj5EaLFGEA5_91vH0QcPUCbkwz4VYw@mail.gmail.com>
Subject: Re: [PATCH 4/4] dt-bindings: Add missing 'additionalProperties: false'
To:     Rob Herring <robh@kernel.org>
Cc:     "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-iio@vger.kernel.org,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Guillaume La Roque <glaroque@baylibre.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Lee Jones <lee.jones@linaro.org>, linux-clk@vger.kernel.org,
        Kevin Hilman <khilman@baylibre.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Brian Masney <masneyb@onstation.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-gpio@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-amlogic@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@kernel.org>, netdev@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Hartmut Knaack <knaack.h@gmx.de>, linux-media@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <jic23@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le mer. 25 mars 2020 =C3=A0 23:06, Rob Herring <robh@kernel.org> a =C3=A9cr=
it :
>
> Setting 'additionalProperties: false' is frequently omitted, but is
> important in order to check that there aren't extra undocumented
> properties in a binding.
>
> Ideally, we'd just add this automatically and make this the default, but
> there's some cases where it doesn't work. For example, if a common
> schema is referenced, then properties in the common schema aren't part
> of what's considered for 'additionalProperties'. Also, sometimes there
> are bus specific properties such as 'spi-max-frequency' that go into
> bus child nodes, but aren't defined in the child node's schema.
>
> So let's stick with the json-schema defined default and add
> 'additionalProperties: false' where needed. This will be a continual
> review comment and game of wack-a-mole.

for stm32 bindings:
Reviewed-by Benjamin Gaignard <benjamin.gaignard@st.com>



>
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../devicetree/bindings/arm/altera/socfpga-clk-manager.yaml    | 2 ++
>  .../bindings/arm/amlogic/amlogic,meson-gx-ao-secure.yaml       | 2 ++
>  Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml       | 2 ++
>  Documentation/devicetree/bindings/arm/renesas,prr.yaml         | 2 ++
>  .../devicetree/bindings/arm/samsung/exynos-chipid.yaml         | 2 ++
>  Documentation/devicetree/bindings/arm/samsung/pmu.yaml         | 2 ++
>  .../bindings/arm/samsung/samsung-secure-firmware.yaml          | 2 ++
>  .../devicetree/bindings/arm/stm32/st,stm32-syscon.yaml         | 2 ++
>  Documentation/devicetree/bindings/clock/fsl,plldig.yaml        | 2 ++
>  Documentation/devicetree/bindings/clock/imx8mn-clock.yaml      | 2 ++
>  Documentation/devicetree/bindings/clock/imx8mp-clock.yaml      | 2 ++
>  Documentation/devicetree/bindings/clock/milbeaut-clock.yaml    | 2 ++
>  Documentation/devicetree/bindings/clock/qcom,gcc-apq8064.yaml  | 2 ++
>  Documentation/devicetree/bindings/clock/qcom,gcc-ipq8074.yaml  | 2 ++
>  Documentation/devicetree/bindings/clock/qcom,gcc-msm8996.yaml  | 2 ++
>  Documentation/devicetree/bindings/clock/qcom,gcc-msm8998.yaml  | 2 ++
>  Documentation/devicetree/bindings/clock/qcom,gcc-qcs404.yaml   | 2 ++
>  Documentation/devicetree/bindings/clock/qcom,gcc-sc7180.yaml   | 2 ++
>  Documentation/devicetree/bindings/clock/qcom,gcc-sm8150.yaml   | 2 ++
>  Documentation/devicetree/bindings/clock/qcom,gcc.yaml          | 2 ++
>  Documentation/devicetree/bindings/clock/qcom,mmcc.yaml         | 2 ++
>  .../devicetree/bindings/clock/qcom,msm8998-gpucc.yaml          | 2 ++
>  Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml       | 2 ++
>  .../devicetree/bindings/clock/qcom,sc7180-dispcc.yaml          | 2 ++
>  Documentation/devicetree/bindings/clock/qcom,sc7180-gpucc.yaml | 2 ++
>  .../devicetree/bindings/clock/qcom,sc7180-videocc.yaml         | 2 ++
>  .../devicetree/bindings/clock/qcom,sdm845-dispcc.yaml          | 2 ++
>  Documentation/devicetree/bindings/clock/qcom,sdm845-gpucc.yaml | 2 ++
>  .../devicetree/bindings/clock/qcom,sdm845-videocc.yaml         | 2 ++
>  .../devicetree/bindings/display/amlogic,meson-vpu.yaml         | 2 ++
>  .../devicetree/bindings/dma/sifive,fu540-c000-pdma.yaml        | 2 ++
>  Documentation/devicetree/bindings/dsp/fsl,dsp.yaml             | 2 ++
>  Documentation/devicetree/bindings/eeprom/at24.yaml             | 2 ++
>  .../firmware/intel,ixp4xx-network-processing-engine.yaml       | 3 +++
>  .../devicetree/bindings/gpio/brcm,xgs-iproc-gpio.yaml          | 2 ++
>  .../devicetree/bindings/gpio/socionext,uniphier-gpio.yaml      | 2 ++
>  Documentation/devicetree/bindings/gpio/xylon,logicvc-gpio.yaml | 2 ++
>  Documentation/devicetree/bindings/gpu/arm,mali-bifrost.yaml    | 2 ++
>  Documentation/devicetree/bindings/gpu/arm,mali-midgard.yaml    | 2 ++
>  Documentation/devicetree/bindings/gpu/arm,mali-utgard.yaml     | 2 ++
>  Documentation/devicetree/bindings/gpu/samsung-rotator.yaml     | 2 ++
>  Documentation/devicetree/bindings/hwmon/adi,adm1177.yaml       | 2 ++
>  Documentation/devicetree/bindings/hwmon/adi,ltc2947.yaml       | 2 ++
>  Documentation/devicetree/bindings/hwmon/pmbus/ti,ucd90320.yaml | 2 ++
>  Documentation/devicetree/bindings/hwmon/ti,tmp513.yaml         | 2 ++
>  Documentation/devicetree/bindings/iio/accel/bosch,bma400.yaml  | 2 ++
>  Documentation/devicetree/bindings/iio/adc/adi,ad7780.yaml      | 2 ++
>  Documentation/devicetree/bindings/iio/adc/avia-hx711.yaml      | 2 ++
>  Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.yaml    | 2 ++
>  .../devicetree/bindings/iio/adc/microchip,mcp3911.yaml         | 2 ++
>  .../devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml        | 2 ++
>  .../devicetree/bindings/iio/chemical/plantower,pms7003.yaml    | 2 ++
>  .../devicetree/bindings/iio/chemical/sensirion,sps30.yaml      | 2 ++
>  Documentation/devicetree/bindings/iio/dac/lltc,ltc1660.yaml    | 2 ++
>  Documentation/devicetree/bindings/iio/light/adux1020.yaml      | 2 ++
>  Documentation/devicetree/bindings/iio/light/bh1750.yaml        | 2 ++
>  Documentation/devicetree/bindings/iio/light/isl29018.yaml      | 2 ++
>  Documentation/devicetree/bindings/iio/light/noa1305.yaml       | 2 ++
>  Documentation/devicetree/bindings/iio/light/stk33xx.yaml       | 2 ++
>  Documentation/devicetree/bindings/iio/light/tsl2583.yaml       | 2 ++
>  Documentation/devicetree/bindings/iio/light/tsl2772.yaml       | 2 ++
>  Documentation/devicetree/bindings/iio/light/veml6030.yaml      | 2 ++
>  .../devicetree/bindings/iio/pressure/asc,dlhl60d.yaml          | 2 ++
>  Documentation/devicetree/bindings/iio/pressure/bmp085.yaml     | 2 ++
>  .../devicetree/bindings/iio/proximity/devantech-srf04.yaml     | 2 ++
>  .../devicetree/bindings/iio/proximity/parallax-ping.yaml       | 2 ++
>  .../devicetree/bindings/iio/temperature/adi,ltc2983.yaml       | 2 ++
>  Documentation/devicetree/bindings/input/gpio-vibrator.yaml     | 2 ++
>  Documentation/devicetree/bindings/input/max77650-onkey.yaml    | 3 +++
>  .../bindings/interrupt-controller/intel,ixp4xx-interrupt.yaml  | 2 ++
>  Documentation/devicetree/bindings/iommu/samsung,sysmmu.yaml    | 2 ++
>  Documentation/devicetree/bindings/leds/leds-max77650.yaml      | 3 +++
>  Documentation/devicetree/bindings/leds/rohm,bd71828-leds.yaml  | 3 +++
>  .../devicetree/bindings/mailbox/amlogic,meson-gxbb-mhu.yaml    | 2 ++
>  Documentation/devicetree/bindings/media/amlogic,gx-vdec.yaml   | 2 ++
>  .../devicetree/bindings/media/amlogic,meson-gx-ao-cec.yaml     | 2 ++
>  Documentation/devicetree/bindings/media/renesas,ceu.yaml       | 2 ++
>  Documentation/devicetree/bindings/mfd/max77650.yaml            | 2 ++
>  Documentation/devicetree/bindings/mfd/rohm,bd71828-pmic.yaml   | 2 ++
>  .../bindings/misc/intel,ixp4xx-ahb-queue-manager.yaml          | 2 ++
>  Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml      | 2 ++
>  .../devicetree/bindings/phy/allwinner,sun50i-h6-usb3-phy.yaml  | 2 ++
>  .../bindings/phy/amlogic,meson-g12a-usb3-pcie-phy.yaml         | 2 ++
>  Documentation/devicetree/bindings/phy/intel,lgm-emmc-phy.yaml  | 2 ++
>  .../devicetree/bindings/phy/marvell,mmp3-hsic-phy.yaml         | 2 ++
>  Documentation/devicetree/bindings/phy/ti,phy-j721e-wiz.yaml    | 2 ++
>  .../devicetree/bindings/pinctrl/aspeed,ast2400-pinctrl.yaml    | 2 ++
>  .../devicetree/bindings/pinctrl/aspeed,ast2500-pinctrl.yaml    | 2 ++
>  .../devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.yaml    | 2 ++
>  .../devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml          | 2 ++
>  .../devicetree/bindings/power/amlogic,meson-ee-pwrc.yaml       | 2 ++
>  .../devicetree/bindings/power/reset/syscon-poweroff.yaml       | 2 ++
>  .../devicetree/bindings/power/reset/syscon-reboot.yaml         | 2 ++
>  .../devicetree/bindings/power/supply/max77650-charger.yaml     | 3 +++
>  Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml           | 2 ++
>  .../devicetree/bindings/regulator/max77650-regulator.yaml      | 3 +++
>  .../devicetree/bindings/reset/amlogic,meson-reset.yaml         | 2 ++
>  .../bindings/reset/brcm,bcm7216-pcie-sata-rescal.yaml          | 2 ++
>  Documentation/devicetree/bindings/rng/amlogic,meson-rng.yaml   | 2 ++
>  Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml        | 2 ++
>  Documentation/devicetree/bindings/rtc/renesas,sh-rtc.yaml      | 2 ++
>  Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml        | 2 ++
>  .../devicetree/bindings/serial/amlogic,meson-uart.yaml         | 2 ++
>  .../devicetree/bindings/soc/amlogic/amlogic,canvas.yaml        | 2 ++
>  Documentation/devicetree/bindings/sound/adi,adau7118.yaml      | 2 ++
>  Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml      | 2 ++
>  Documentation/devicetree/bindings/sound/renesas,fsi.yaml       | 2 ++
>  Documentation/devicetree/bindings/sound/samsung,odroid.yaml    | 2 ++
>  Documentation/devicetree/bindings/sound/samsung-i2s.yaml       | 2 ++
>  Documentation/devicetree/bindings/sram/qcom,ocmem.yaml         | 2 ++
>  Documentation/devicetree/bindings/thermal/amlogic,thermal.yaml | 2 ++
>  Documentation/devicetree/bindings/timer/arm,arch_timer.yaml    | 2 ++
>  .../devicetree/bindings/timer/arm,arch_timer_mmio.yaml         | 2 ++
>  Documentation/devicetree/bindings/timer/arm,global_timer.yaml  | 2 ++
>  .../devicetree/bindings/timer/intel,ixp4xx-timer.yaml          | 2 ++
>  .../devicetree/bindings/timer/samsung,exynos4210-mct.yaml      | 2 ++
>  Documentation/devicetree/bindings/trivial-devices.yaml         | 2 ++
>  117 files changed, 240 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-clk-man=
ager.yaml b/Documentation/devicetree/bindings/arm/altera/socfpga-clk-manage=
r.yaml
> index e4131fa42b26..572381306681 100644
> --- a/Documentation/devicetree/bindings/arm/altera/socfpga-clk-manager.ya=
ml
> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-clk-manager.ya=
ml
> @@ -21,6 +21,8 @@ properties:
>  required:
>    - compatible
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      clkmgr@ffd04000 {
> diff --git a/Documentation/devicetree/bindings/arm/amlogic/amlogic,meson-=
gx-ao-secure.yaml b/Documentation/devicetree/bindings/arm/amlogic/amlogic,m=
eson-gx-ao-secure.yaml
> index 853d7d2b56f5..66213bd95e6e 100644
> --- a/Documentation/devicetree/bindings/arm/amlogic/amlogic,meson-gx-ao-s=
ecure.yaml
> +++ b/Documentation/devicetree/bindings/arm/amlogic/amlogic,meson-gx-ao-s=
ecure.yaml
> @@ -43,6 +43,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      ao-secure@140 {
> diff --git a/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml b/D=
ocumentation/devicetree/bindings/arm/msm/qcom,llcc.yaml
> index 79902f470e4b..c3a8604dfa80 100644
> --- a/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml
> +++ b/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml
> @@ -43,6 +43,8 @@ required:
>    - reg-names
>    - interrupts
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/arm-gic.h>
> diff --git a/Documentation/devicetree/bindings/arm/renesas,prr.yaml b/Doc=
umentation/devicetree/bindings/arm/renesas,prr.yaml
> index 7f8d17f33983..dd087643a9f8 100644
> --- a/Documentation/devicetree/bindings/arm/renesas,prr.yaml
> +++ b/Documentation/devicetree/bindings/arm/renesas,prr.yaml
> @@ -27,6 +27,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      prr: chipid@ff000044 {
> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-chipid.=
yaml b/Documentation/devicetree/bindings/arm/samsung/exynos-chipid.yaml
> index afcd70803c12..0425d333b50d 100644
> --- a/Documentation/devicetree/bindings/arm/samsung/exynos-chipid.yaml
> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos-chipid.yaml
> @@ -30,6 +30,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      chipid@10000000 {
> diff --git a/Documentation/devicetree/bindings/arm/samsung/pmu.yaml b/Doc=
umentation/devicetree/bindings/arm/samsung/pmu.yaml
> index 73b56fc5bf58..c9651892710e 100644
> --- a/Documentation/devicetree/bindings/arm/samsung/pmu.yaml
> +++ b/Documentation/devicetree/bindings/arm/samsung/pmu.yaml
> @@ -89,6 +89,8 @@ required:
>    - clock-names
>    - clocks
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/exynos5250.h>
> diff --git a/Documentation/devicetree/bindings/arm/samsung/samsung-secure=
-firmware.yaml b/Documentation/devicetree/bindings/arm/samsung/samsung-secu=
re-firmware.yaml
> index 51d23b6f8a94..3d9abad3c749 100644
> --- a/Documentation/devicetree/bindings/arm/samsung/samsung-secure-firmwa=
re.yaml
> +++ b/Documentation/devicetree/bindings/arm/samsung/samsung-secure-firmwa=
re.yaml
> @@ -23,6 +23,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      firmware@203f000 {
> diff --git a/Documentation/devicetree/bindings/arm/stm32/st,stm32-syscon.=
yaml b/Documentation/devicetree/bindings/arm/stm32/st,stm32-syscon.yaml
> index 0dedf94c8578..baff80197d5a 100644
> --- a/Documentation/devicetree/bindings/arm/stm32/st,stm32-syscon.yaml
> +++ b/Documentation/devicetree/bindings/arm/stm32/st,stm32-syscon.yaml
> @@ -29,6 +29,8 @@ required:
>    - reg
>    - clocks
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/stm32mp1-clks.h>
> diff --git a/Documentation/devicetree/bindings/clock/fsl,plldig.yaml b/Do=
cumentation/devicetree/bindings/clock/fsl,plldig.yaml
> index d1c040228cf7..a203d5d498db 100644
> --- a/Documentation/devicetree/bindings/clock/fsl,plldig.yaml
> +++ b/Documentation/devicetree/bindings/clock/fsl,plldig.yaml
> @@ -44,6 +44,8 @@ required:
>    - clocks
>    - '#clock-cells'
>
> +additionalProperties: false
> +
>  examples:
>    # Display PIXEL Clock node:
>    - |
> diff --git a/Documentation/devicetree/bindings/clock/imx8mn-clock.yaml b/=
Documentation/devicetree/bindings/clock/imx8mn-clock.yaml
> index cd0b8a341321..03386b0861a2 100644
> --- a/Documentation/devicetree/bindings/clock/imx8mn-clock.yaml
> +++ b/Documentation/devicetree/bindings/clock/imx8mn-clock.yaml
> @@ -52,6 +52,8 @@ required:
>    - clock-names
>    - '#clock-cells'
>
> +additionalProperties: false
> +
>  examples:
>    # Clock Control Module node:
>    - |
> diff --git a/Documentation/devicetree/bindings/clock/imx8mp-clock.yaml b/=
Documentation/devicetree/bindings/clock/imx8mp-clock.yaml
> index 89aee63c9019..4351a1dbb4f7 100644
> --- a/Documentation/devicetree/bindings/clock/imx8mp-clock.yaml
> +++ b/Documentation/devicetree/bindings/clock/imx8mp-clock.yaml
> @@ -52,6 +52,8 @@ required:
>    - clock-names
>    - '#clock-cells'
>
> +additionalProperties: false
> +
>  examples:
>    # Clock Control Module node:
>    - |
> diff --git a/Documentation/devicetree/bindings/clock/milbeaut-clock.yaml =
b/Documentation/devicetree/bindings/clock/milbeaut-clock.yaml
> index f0b804a7f096..0e8b07710451 100644
> --- a/Documentation/devicetree/bindings/clock/milbeaut-clock.yaml
> +++ b/Documentation/devicetree/bindings/clock/milbeaut-clock.yaml
> @@ -35,6 +35,8 @@ required:
>    - clocks
>    - '#clock-cells'
>
> +additionalProperties: false
> +
>  examples:
>    # Clock controller node:
>    - |
> diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-apq8064.yam=
l b/Documentation/devicetree/bindings/clock/qcom,gcc-apq8064.yaml
> index 3647007f82ca..eacccc88bbf6 100644
> --- a/Documentation/devicetree/bindings/clock/qcom,gcc-apq8064.yaml
> +++ b/Documentation/devicetree/bindings/clock/qcom,gcc-apq8064.yaml
> @@ -68,6 +68,8 @@ required:
>    - nvmem-cell-names
>    - '#thermal-sensor-cells'
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      clock-controller@900000 {
> diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-ipq8074.yam=
l b/Documentation/devicetree/bindings/clock/qcom,gcc-ipq8074.yaml
> index 89c6e070e7ac..98572b4a9b60 100644
> --- a/Documentation/devicetree/bindings/clock/qcom,gcc-ipq8074.yaml
> +++ b/Documentation/devicetree/bindings/clock/qcom,gcc-ipq8074.yaml
> @@ -40,6 +40,8 @@ required:
>    - '#clock-cells'
>    - '#reset-cells'
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      clock-controller@1800000 {
> diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-msm8996.yam=
l b/Documentation/devicetree/bindings/clock/qcom,gcc-msm8996.yaml
> index 18e4e77b8cfa..5a5b2214f0ca 100644
> --- a/Documentation/devicetree/bindings/clock/qcom,gcc-msm8996.yaml
> +++ b/Documentation/devicetree/bindings/clock/qcom,gcc-msm8996.yaml
> @@ -56,6 +56,8 @@ required:
>    - '#reset-cells'
>    - '#power-domain-cells'
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      clock-controller@300000 {
> diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-msm8998.yam=
l b/Documentation/devicetree/bindings/clock/qcom,gcc-msm8998.yaml
> index 1d3cae980471..a0bb713929b0 100644
> --- a/Documentation/devicetree/bindings/clock/qcom,gcc-msm8998.yaml
> +++ b/Documentation/devicetree/bindings/clock/qcom,gcc-msm8998.yaml
> @@ -66,6 +66,8 @@ required:
>    - '#reset-cells'
>    - '#power-domain-cells'
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/qcom,rpmcc.h>
> diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-qcs404.yaml=
 b/Documentation/devicetree/bindings/clock/qcom,gcc-qcs404.yaml
> index 8cdece395eba..ce06f3f8c3e3 100644
> --- a/Documentation/devicetree/bindings/clock/qcom,gcc-qcs404.yaml
> +++ b/Documentation/devicetree/bindings/clock/qcom,gcc-qcs404.yaml
> @@ -40,6 +40,8 @@ required:
>    - '#clock-cells'
>    - '#reset-cells'
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      clock-controller@1800000 {
> diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sc7180.yaml=
 b/Documentation/devicetree/bindings/clock/qcom,gcc-sc7180.yaml
> index ee4f968e2909..a345320e0e49 100644
> --- a/Documentation/devicetree/bindings/clock/qcom,gcc-sc7180.yaml
> +++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sc7180.yaml
> @@ -58,6 +58,8 @@ required:
>    - '#reset-cells'
>    - '#power-domain-cells'
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/qcom,rpmh.h>
> diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sm8150.yaml=
 b/Documentation/devicetree/bindings/clock/qcom,gcc-sm8150.yaml
> index 888e9a708390..36f3b3668ced 100644
> --- a/Documentation/devicetree/bindings/clock/qcom,gcc-sm8150.yaml
> +++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sm8150.yaml
> @@ -56,6 +56,8 @@ required:
>    - '#reset-cells'
>    - '#power-domain-cells'
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/qcom,rpmh.h>
> diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc.yaml b/Docu=
mentation/devicetree/bindings/clock/qcom,gcc.yaml
> index d18f8ab9eeee..e533bb0cfd2b 100644
> --- a/Documentation/devicetree/bindings/clock/qcom,gcc.yaml
> +++ b/Documentation/devicetree/bindings/clock/qcom,gcc.yaml
> @@ -74,6 +74,8 @@ required:
>    - '#reset-cells'
>    - '#power-domain-cells'
>
> +additionalProperties: false
> +
>  examples:
>    # Example for GCC for MSM8960:
>    - |
> diff --git a/Documentation/devicetree/bindings/clock/qcom,mmcc.yaml b/Doc=
umentation/devicetree/bindings/clock/qcom,mmcc.yaml
> index 85518494ce43..f684fe67db84 100644
> --- a/Documentation/devicetree/bindings/clock/qcom,mmcc.yaml
> +++ b/Documentation/devicetree/bindings/clock/qcom,mmcc.yaml
> @@ -74,6 +74,8 @@ required:
>    - '#reset-cells'
>    - '#power-domain-cells'
>
> +additionalProperties: false
> +
>  if:
>    properties:
>      compatible:
> diff --git a/Documentation/devicetree/bindings/clock/qcom,msm8998-gpucc.y=
aml b/Documentation/devicetree/bindings/clock/qcom,msm8998-gpucc.yaml
> index 7d853c1a85e5..d747bb58f0a7 100644
> --- a/Documentation/devicetree/bindings/clock/qcom,msm8998-gpucc.yaml
> +++ b/Documentation/devicetree/bindings/clock/qcom,msm8998-gpucc.yaml
> @@ -50,6 +50,8 @@ required:
>    - '#reset-cells'
>    - '#power-domain-cells'
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/qcom,gcc-msm8998.h>
> diff --git a/Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml b/D=
ocumentation/devicetree/bindings/clock/qcom,rpmhcc.yaml
> index 2cd158f13bab..c9fd748b4d7c 100644
> --- a/Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml
> +++ b/Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml
> @@ -35,6 +35,8 @@ required:
>    - compatible
>    - '#clock-cells'
>
> +additionalProperties: false
> +
>  examples:
>    # Example for GCC for SDM845: The below node should be defined inside
>    # &apps_rsc node.
> diff --git a/Documentation/devicetree/bindings/clock/qcom,sc7180-dispcc.y=
aml b/Documentation/devicetree/bindings/clock/qcom,sc7180-dispcc.yaml
> index 0429062f1585..58cdfd5924d3 100644
> --- a/Documentation/devicetree/bindings/clock/qcom,sc7180-dispcc.yaml
> +++ b/Documentation/devicetree/bindings/clock/qcom,sc7180-dispcc.yaml
> @@ -58,6 +58,8 @@ required:
>    - '#reset-cells'
>    - '#power-domain-cells'
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/qcom,gcc-sc7180.h>
> diff --git a/Documentation/devicetree/bindings/clock/qcom,sc7180-gpucc.ya=
ml b/Documentation/devicetree/bindings/clock/qcom,sc7180-gpucc.yaml
> index 5785192cc4be..8635e35fd3f0 100644
> --- a/Documentation/devicetree/bindings/clock/qcom,sc7180-gpucc.yaml
> +++ b/Documentation/devicetree/bindings/clock/qcom,sc7180-gpucc.yaml
> @@ -52,6 +52,8 @@ required:
>    - '#reset-cells'
>    - '#power-domain-cells'
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/qcom,gcc-sc7180.h>
> diff --git a/Documentation/devicetree/bindings/clock/qcom,sc7180-videocc.=
yaml b/Documentation/devicetree/bindings/clock/qcom,sc7180-videocc.yaml
> index 31df901884ac..0071b9701960 100644
> --- a/Documentation/devicetree/bindings/clock/qcom,sc7180-videocc.yaml
> +++ b/Documentation/devicetree/bindings/clock/qcom,sc7180-videocc.yaml
> @@ -48,6 +48,8 @@ required:
>    - '#reset-cells'
>    - '#power-domain-cells'
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/qcom,rpmh.h>
> diff --git a/Documentation/devicetree/bindings/clock/qcom,sdm845-dispcc.y=
aml b/Documentation/devicetree/bindings/clock/qcom,sdm845-dispcc.yaml
> index 89269ddfbdcd..ad47d747a3e4 100644
> --- a/Documentation/devicetree/bindings/clock/qcom,sdm845-dispcc.yaml
> +++ b/Documentation/devicetree/bindings/clock/qcom,sdm845-dispcc.yaml
> @@ -67,6 +67,8 @@ required:
>    - '#reset-cells'
>    - '#power-domain-cells'
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/qcom,gcc-sdm845.h>
> diff --git a/Documentation/devicetree/bindings/clock/qcom,sdm845-gpucc.ya=
ml b/Documentation/devicetree/bindings/clock/qcom,sdm845-gpucc.yaml
> index bac04f1c5d79..7a052ac5dc00 100644
> --- a/Documentation/devicetree/bindings/clock/qcom,sdm845-gpucc.yaml
> +++ b/Documentation/devicetree/bindings/clock/qcom,sdm845-gpucc.yaml
> @@ -52,6 +52,8 @@ required:
>    - '#reset-cells'
>    - '#power-domain-cells'
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/qcom,gcc-sdm845.h>
> diff --git a/Documentation/devicetree/bindings/clock/qcom,sdm845-videocc.=
yaml b/Documentation/devicetree/bindings/clock/qcom,sdm845-videocc.yaml
> index 9d216c0f11d4..2a6a81ab0318 100644
> --- a/Documentation/devicetree/bindings/clock/qcom,sdm845-videocc.yaml
> +++ b/Documentation/devicetree/bindings/clock/qcom,sdm845-videocc.yaml
> @@ -48,6 +48,8 @@ required:
>    - '#reset-cells'
>    - '#power-domain-cells'
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/qcom,rpmh.h>
> diff --git a/Documentation/devicetree/bindings/display/amlogic,meson-vpu.=
yaml b/Documentation/devicetree/bindings/display/amlogic,meson-vpu.yaml
> index d1205a6697a0..d8e573eeb5ec 100644
> --- a/Documentation/devicetree/bindings/display/amlogic,meson-vpu.yaml
> +++ b/Documentation/devicetree/bindings/display/amlogic,meson-vpu.yaml
> @@ -107,6 +107,8 @@ required:
>    - "#address-cells"
>    - "#size-cells"
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      vpu: vpu@d0100000 {
> diff --git a/Documentation/devicetree/bindings/dma/sifive,fu540-c000-pdma=
.yaml b/Documentation/devicetree/bindings/dma/sifive,fu540-c000-pdma.yaml
> index 2ca3ddbe1ff4..e7f2ad7dab5e 100644
> --- a/Documentation/devicetree/bindings/dma/sifive,fu540-c000-pdma.yaml
> +++ b/Documentation/devicetree/bindings/dma/sifive,fu540-c000-pdma.yaml
> @@ -43,6 +43,8 @@ required:
>    - interrupts
>    - '#dma-cells'
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      dma@3000000 {
> diff --git a/Documentation/devicetree/bindings/dsp/fsl,dsp.yaml b/Documen=
tation/devicetree/bindings/dsp/fsl,dsp.yaml
> index f04870d84542..a5dc070d0ca7 100644
> --- a/Documentation/devicetree/bindings/dsp/fsl,dsp.yaml
> +++ b/Documentation/devicetree/bindings/dsp/fsl,dsp.yaml
> @@ -68,6 +68,8 @@ required:
>    - mbox-names
>    - memory-region
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/firmware/imx/rsrc.h>
> diff --git a/Documentation/devicetree/bindings/eeprom/at24.yaml b/Documen=
tation/devicetree/bindings/eeprom/at24.yaml
> index 0f6d8db18d6c..a15787e504f0 100644
> --- a/Documentation/devicetree/bindings/eeprom/at24.yaml
> +++ b/Documentation/devicetree/bindings/eeprom/at24.yaml
> @@ -172,6 +172,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      i2c {
> diff --git a/Documentation/devicetree/bindings/firmware/intel,ixp4xx-netw=
ork-processing-engine.yaml b/Documentation/devicetree/bindings/firmware/int=
el,ixp4xx-network-processing-engine.yaml
> index 878a2079ebb6..1bd2870c3a9c 100644
> --- a/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-pro=
cessing-engine.yaml
> +++ b/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-pro=
cessing-engine.yaml
> @@ -34,9 +34,12 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      npe@c8006000 {
>           compatible =3D "intel,ixp4xx-network-processing-engine";
>           reg =3D <0xc8006000 0x1000>, <0xc8007000 0x1000>, <0xc8008000 0=
x1000>;
>      };
> +...
> diff --git a/Documentation/devicetree/bindings/gpio/brcm,xgs-iproc-gpio.y=
aml b/Documentation/devicetree/bindings/gpio/brcm,xgs-iproc-gpio.yaml
> index 64e279a4bc10..5f1ed20e43ee 100644
> --- a/Documentation/devicetree/bindings/gpio/brcm,xgs-iproc-gpio.yaml
> +++ b/Documentation/devicetree/bindings/gpio/brcm,xgs-iproc-gpio.yaml
> @@ -47,6 +47,8 @@ required:
>    - "#gpio-cells"
>    - gpio-controller
>
> +additionalProperties: false
> +
>  dependencies:
>    interrupt-controller: [ interrupts ]
>
> diff --git a/Documentation/devicetree/bindings/gpio/socionext,uniphier-gp=
io.yaml b/Documentation/devicetree/bindings/gpio/socionext,uniphier-gpio.ya=
ml
> index c58ff9a94f45..1a54db04f29d 100644
> --- a/Documentation/devicetree/bindings/gpio/socionext,uniphier-gpio.yaml
> +++ b/Documentation/devicetree/bindings/gpio/socionext,uniphier-gpio.yaml
> @@ -64,6 +64,8 @@ required:
>    - gpio-ranges
>    - socionext,interrupt-ranges
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> diff --git a/Documentation/devicetree/bindings/gpio/xylon,logicvc-gpio.ya=
ml b/Documentation/devicetree/bindings/gpio/xylon,logicvc-gpio.yaml
> index d102888c1be7..a36aec27069c 100644
> --- a/Documentation/devicetree/bindings/gpio/xylon,logicvc-gpio.yaml
> +++ b/Documentation/devicetree/bindings/gpio/xylon,logicvc-gpio.yaml
> @@ -49,6 +49,8 @@ required:
>    - "#gpio-cells"
>    - gpio-controller
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      logicvc: logicvc@43c00000 {
> diff --git a/Documentation/devicetree/bindings/gpu/arm,mali-bifrost.yaml =
b/Documentation/devicetree/bindings/gpu/arm,mali-bifrost.yaml
> index 05fd9a404ff7..0b229a7d4a98 100644
> --- a/Documentation/devicetree/bindings/gpu/arm,mali-bifrost.yaml
> +++ b/Documentation/devicetree/bindings/gpu/arm,mali-bifrost.yaml
> @@ -53,6 +53,8 @@ required:
>    - interrupt-names
>    - clocks
>
> +additionalProperties: false
> +
>  allOf:
>    - if:
>        properties:
> diff --git a/Documentation/devicetree/bindings/gpu/arm,mali-midgard.yaml =
b/Documentation/devicetree/bindings/gpu/arm,mali-midgard.yaml
> index 6819cde050df..0407e45eb8c4 100644
> --- a/Documentation/devicetree/bindings/gpu/arm,mali-midgard.yaml
> +++ b/Documentation/devicetree/bindings/gpu/arm,mali-midgard.yaml
> @@ -94,6 +94,8 @@ required:
>    - interrupt-names
>    - clocks
>
> +additionalProperties: false
> +
>  allOf:
>    - if:
>        properties:
> diff --git a/Documentation/devicetree/bindings/gpu/arm,mali-utgard.yaml b=
/Documentation/devicetree/bindings/gpu/arm,mali-utgard.yaml
> index afde81be3c29..f5401cc8de4a 100644
> --- a/Documentation/devicetree/bindings/gpu/arm,mali-utgard.yaml
> +++ b/Documentation/devicetree/bindings/gpu/arm,mali-utgard.yaml
> @@ -115,6 +115,8 @@ required:
>    - clocks
>    - clock-names
>
> +additionalProperties: false
> +
>  allOf:
>    - if:
>        properties:
> diff --git a/Documentation/devicetree/bindings/gpu/samsung-rotator.yaml b=
/Documentation/devicetree/bindings/gpu/samsung-rotator.yaml
> index f4dfa6fc724c..665c6e3b31d3 100644
> --- a/Documentation/devicetree/bindings/gpu/samsung-rotator.yaml
> +++ b/Documentation/devicetree/bindings/gpu/samsung-rotator.yaml
> @@ -36,6 +36,8 @@ required:
>    - clocks
>    - clock-names
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      rotator@12810000 {
> diff --git a/Documentation/devicetree/bindings/hwmon/adi,adm1177.yaml b/D=
ocumentation/devicetree/bindings/hwmon/adi,adm1177.yaml
> index 2a9822075b36..154bee851139 100644
> --- a/Documentation/devicetree/bindings/hwmon/adi,adm1177.yaml
> +++ b/Documentation/devicetree/bindings/hwmon/adi,adm1177.yaml
> @@ -47,6 +47,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> diff --git a/Documentation/devicetree/bindings/hwmon/adi,ltc2947.yaml b/D=
ocumentation/devicetree/bindings/hwmon/adi,ltc2947.yaml
> index 6a742a51e2f9..44a63fffb4be 100644
> --- a/Documentation/devicetree/bindings/hwmon/adi,ltc2947.yaml
> +++ b/Documentation/devicetree/bindings/hwmon/adi,ltc2947.yaml
> @@ -87,6 +87,8 @@ required:
>    - reg
>
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      spi {
> diff --git a/Documentation/devicetree/bindings/hwmon/pmbus/ti,ucd90320.ya=
ml b/Documentation/devicetree/bindings/hwmon/pmbus/ti,ucd90320.yaml
> index 5d42e1304202..e8feee38c76c 100644
> --- a/Documentation/devicetree/bindings/hwmon/pmbus/ti,ucd90320.yaml
> +++ b/Documentation/devicetree/bindings/hwmon/pmbus/ti,ucd90320.yaml
> @@ -32,6 +32,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      i2c {
> diff --git a/Documentation/devicetree/bindings/hwmon/ti,tmp513.yaml b/Doc=
umentation/devicetree/bindings/hwmon/ti,tmp513.yaml
> index 168235ad5d81..3f043e943668 100644
> --- a/Documentation/devicetree/bindings/hwmon/ti,tmp513.yaml
> +++ b/Documentation/devicetree/bindings/hwmon/ti,tmp513.yaml
> @@ -76,6 +76,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      i2c {
> diff --git a/Documentation/devicetree/bindings/iio/accel/bosch,bma400.yam=
l b/Documentation/devicetree/bindings/iio/accel/bosch,bma400.yaml
> index c1c6d6f223cf..8723a336229e 100644
> --- a/Documentation/devicetree/bindings/iio/accel/bosch,bma400.yaml
> +++ b/Documentation/devicetree/bindings/iio/accel/bosch,bma400.yaml
> @@ -36,6 +36,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> diff --git a/Documentation/devicetree/bindings/iio/adc/adi,ad7780.yaml b/=
Documentation/devicetree/bindings/iio/adc/adi,ad7780.yaml
> index 9acde6d2e2d9..a67ba67dab51 100644
> --- a/Documentation/devicetree/bindings/iio/adc/adi,ad7780.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/adi,ad7780.yaml
> @@ -67,6 +67,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> diff --git a/Documentation/devicetree/bindings/iio/adc/avia-hx711.yaml b/=
Documentation/devicetree/bindings/iio/adc/avia-hx711.yaml
> index 91ab9c842273..77605f17901c 100644
> --- a/Documentation/devicetree/bindings/iio/adc/avia-hx711.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/avia-hx711.yaml
> @@ -53,6 +53,8 @@ required:
>    - dout-gpios
>    - avdd-supply
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> diff --git a/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.yaml =
b/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.yaml
> index 59009997dca0..118809a03279 100644
> --- a/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.yaml
> @@ -32,6 +32,8 @@ required:
>    - vref-supply
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      spi {
> diff --git a/Documentation/devicetree/bindings/iio/adc/microchip,mcp3911.=
yaml b/Documentation/devicetree/bindings/iio/adc/microchip,mcp3911.yaml
> index 0ce290473fb0..8ffeceb6abae 100644
> --- a/Documentation/devicetree/bindings/iio/adc/microchip,mcp3911.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/microchip,mcp3911.yaml
> @@ -52,6 +52,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      spi {
> diff --git a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc=
.yaml b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
> index acf36eef728b..b1627441a0b2 100644
> --- a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
> @@ -69,6 +69,8 @@ required:
>    - "#address-cells"
>    - "#size-cells"
>
> +additionalProperties: false
> +
>  patternProperties:
>    "^filter@[0-9]+$":
>      type: object
> diff --git a/Documentation/devicetree/bindings/iio/chemical/plantower,pms=
7003.yaml b/Documentation/devicetree/bindings/iio/chemical/plantower,pms700=
3.yaml
> index 19e53930ebf6..1fe561574019 100644
> --- a/Documentation/devicetree/bindings/iio/chemical/plantower,pms7003.ya=
ml
> +++ b/Documentation/devicetree/bindings/iio/chemical/plantower,pms7003.ya=
ml
> @@ -38,6 +38,8 @@ required:
>    - compatible
>    - vcc-supply
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      serial {
> diff --git a/Documentation/devicetree/bindings/iio/chemical/sensirion,sps=
30.yaml b/Documentation/devicetree/bindings/iio/chemical/sensirion,sps30.ya=
ml
> index 50a50a0d7070..a93d1972a5c2 100644
> --- a/Documentation/devicetree/bindings/iio/chemical/sensirion,sps30.yaml
> +++ b/Documentation/devicetree/bindings/iio/chemical/sensirion,sps30.yaml
> @@ -24,6 +24,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      i2c {
> diff --git a/Documentation/devicetree/bindings/iio/dac/lltc,ltc1660.yaml =
b/Documentation/devicetree/bindings/iio/dac/lltc,ltc1660.yaml
> index a285eaba7125..e51a585bd5a3 100644
> --- a/Documentation/devicetree/bindings/iio/dac/lltc,ltc1660.yaml
> +++ b/Documentation/devicetree/bindings/iio/dac/lltc,ltc1660.yaml
> @@ -34,6 +34,8 @@ required:
>    - reg
>    - vref-supply
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      spi {
> diff --git a/Documentation/devicetree/bindings/iio/light/adux1020.yaml b/=
Documentation/devicetree/bindings/iio/light/adux1020.yaml
> index 69bd5c06319d..d7d14f2f1c20 100644
> --- a/Documentation/devicetree/bindings/iio/light/adux1020.yaml
> +++ b/Documentation/devicetree/bindings/iio/light/adux1020.yaml
> @@ -28,6 +28,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/irq.h>
> diff --git a/Documentation/devicetree/bindings/iio/light/bh1750.yaml b/Do=
cumentation/devicetree/bindings/iio/light/bh1750.yaml
> index 1cc60d7ecfa0..1a88b3c253d5 100644
> --- a/Documentation/devicetree/bindings/iio/light/bh1750.yaml
> +++ b/Documentation/devicetree/bindings/iio/light/bh1750.yaml
> @@ -28,6 +28,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      i2c {
> diff --git a/Documentation/devicetree/bindings/iio/light/isl29018.yaml b/=
Documentation/devicetree/bindings/iio/light/isl29018.yaml
> index cbb00be8f359..0ea278b07d1c 100644
> --- a/Documentation/devicetree/bindings/iio/light/isl29018.yaml
> +++ b/Documentation/devicetree/bindings/iio/light/isl29018.yaml
> @@ -38,6 +38,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/irq.h>
> diff --git a/Documentation/devicetree/bindings/iio/light/noa1305.yaml b/D=
ocumentation/devicetree/bindings/iio/light/noa1305.yaml
> index 17e7f140b69b..fe7bfe1adbda 100644
> --- a/Documentation/devicetree/bindings/iio/light/noa1305.yaml
> +++ b/Documentation/devicetree/bindings/iio/light/noa1305.yaml
> @@ -29,6 +29,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      i2c {
> diff --git a/Documentation/devicetree/bindings/iio/light/stk33xx.yaml b/D=
ocumentation/devicetree/bindings/iio/light/stk33xx.yaml
> index aae8a6d627c9..f92bf7b2b7f0 100644
> --- a/Documentation/devicetree/bindings/iio/light/stk33xx.yaml
> +++ b/Documentation/devicetree/bindings/iio/light/stk33xx.yaml
> @@ -30,6 +30,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/irq.h>
> diff --git a/Documentation/devicetree/bindings/iio/light/tsl2583.yaml b/D=
ocumentation/devicetree/bindings/iio/light/tsl2583.yaml
> index e86ef64ecf03..7b92ba8cbb9f 100644
> --- a/Documentation/devicetree/bindings/iio/light/tsl2583.yaml
> +++ b/Documentation/devicetree/bindings/iio/light/tsl2583.yaml
> @@ -32,6 +32,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      i2c {
> diff --git a/Documentation/devicetree/bindings/iio/light/tsl2772.yaml b/D=
ocumentation/devicetree/bindings/iio/light/tsl2772.yaml
> index ed2c3d5eadf5..e8f7d1ada57b 100644
> --- a/Documentation/devicetree/bindings/iio/light/tsl2772.yaml
> +++ b/Documentation/devicetree/bindings/iio/light/tsl2772.yaml
> @@ -62,6 +62,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/irq.h>
> diff --git a/Documentation/devicetree/bindings/iio/light/veml6030.yaml b/=
Documentation/devicetree/bindings/iio/light/veml6030.yaml
> index 0ff9b11f9d18..fb19a2d7a849 100644
> --- a/Documentation/devicetree/bindings/iio/light/veml6030.yaml
> +++ b/Documentation/devicetree/bindings/iio/light/veml6030.yaml
> @@ -45,6 +45,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/irq.h>
> diff --git a/Documentation/devicetree/bindings/iio/pressure/asc,dlhl60d.y=
aml b/Documentation/devicetree/bindings/iio/pressure/asc,dlhl60d.yaml
> index 9f5ca9c42025..64c18f1693f0 100644
> --- a/Documentation/devicetree/bindings/iio/pressure/asc,dlhl60d.yaml
> +++ b/Documentation/devicetree/bindings/iio/pressure/asc,dlhl60d.yaml
> @@ -33,6 +33,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/irq.h>
> diff --git a/Documentation/devicetree/bindings/iio/pressure/bmp085.yaml b=
/Documentation/devicetree/bindings/iio/pressure/bmp085.yaml
> index 5d4aec0e0d24..49257f9251e8 100644
> --- a/Documentation/devicetree/bindings/iio/pressure/bmp085.yaml
> +++ b/Documentation/devicetree/bindings/iio/pressure/bmp085.yaml
> @@ -52,6 +52,8 @@ required:
>    - vddd-supply
>    - vdda-supply
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> diff --git a/Documentation/devicetree/bindings/iio/proximity/devantech-sr=
f04.yaml b/Documentation/devicetree/bindings/iio/proximity/devantech-srf04.=
yaml
> index 4e80ea7c1475..7ac5eb7560e0 100644
> --- a/Documentation/devicetree/bindings/iio/proximity/devantech-srf04.yam=
l
> +++ b/Documentation/devicetree/bindings/iio/proximity/devantech-srf04.yam=
l
> @@ -56,6 +56,8 @@ required:
>    - trig-gpios
>    - echo-gpios
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> diff --git a/Documentation/devicetree/bindings/iio/proximity/parallax-pin=
g.yaml b/Documentation/devicetree/bindings/iio/proximity/parallax-ping.yaml
> index a079c9921af6..ada55f186f3c 100644
> --- a/Documentation/devicetree/bindings/iio/proximity/parallax-ping.yaml
> +++ b/Documentation/devicetree/bindings/iio/proximity/parallax-ping.yaml
> @@ -42,6 +42,8 @@ required:
>    - compatible
>    - ping-gpios
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> diff --git a/Documentation/devicetree/bindings/iio/temperature/adi,ltc298=
3.yaml b/Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.yaml
> index d4922f9f0376..acc030c1b20e 100644
> --- a/Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.yaml
> +++ b/Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.yaml
> @@ -398,6 +398,8 @@ required:
>    - reg
>    - interrupts
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/irq.h>
> diff --git a/Documentation/devicetree/bindings/input/gpio-vibrator.yaml b=
/Documentation/devicetree/bindings/input/gpio-vibrator.yaml
> index b98bf9363c8f..2384465eaa19 100644
> --- a/Documentation/devicetree/bindings/input/gpio-vibrator.yaml
> +++ b/Documentation/devicetree/bindings/input/gpio-vibrator.yaml
> @@ -26,6 +26,8 @@ required:
>    - compatible
>    - enable-gpios
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> diff --git a/Documentation/devicetree/bindings/input/max77650-onkey.yaml =
b/Documentation/devicetree/bindings/input/max77650-onkey.yaml
> index 2f2e0b6ebbbd..3a2ad6ec64db 100644
> --- a/Documentation/devicetree/bindings/input/max77650-onkey.yaml
> +++ b/Documentation/devicetree/bindings/input/max77650-onkey.yaml
> @@ -33,3 +33,6 @@ properties:
>
>  required:
>    - compatible
> +additionalProperties: false
> +
> +...
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/intel=
,ixp4xx-interrupt.yaml b/Documentation/devicetree/bindings/interrupt-contro=
ller/intel,ixp4xx-interrupt.yaml
> index 507c141ea760..ccc507f384d2 100644
> --- a/Documentation/devicetree/bindings/interrupt-controller/intel,ixp4xx=
-interrupt.yaml
> +++ b/Documentation/devicetree/bindings/interrupt-controller/intel,ixp4xx=
-interrupt.yaml
> @@ -44,6 +44,8 @@ required:
>    - interrupt-controller
>    - '#interrupt-cells'
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      intcon: interrupt-controller@c8003000 {
> diff --git a/Documentation/devicetree/bindings/iommu/samsung,sysmmu.yaml =
b/Documentation/devicetree/bindings/iommu/samsung,sysmmu.yaml
> index 7cdd3aaa2ba4..0e33cd9e010e 100644
> --- a/Documentation/devicetree/bindings/iommu/samsung,sysmmu.yaml
> +++ b/Documentation/devicetree/bindings/iommu/samsung,sysmmu.yaml
> @@ -80,6 +80,8 @@ required:
>    - clock-names
>    - "#iommu-cells"
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/exynos5250.h>
> diff --git a/Documentation/devicetree/bindings/leds/leds-max77650.yaml b/=
Documentation/devicetree/bindings/leds/leds-max77650.yaml
> index 8c43f1e1bf7d..c6f96cabd4d1 100644
> --- a/Documentation/devicetree/bindings/leds/leds-max77650.yaml
> +++ b/Documentation/devicetree/bindings/leds/leds-max77650.yaml
> @@ -49,3 +49,6 @@ required:
>    - compatible
>    - "#address-cells"
>    - "#size-cells"
> +additionalProperties: false
> +
> +...
> diff --git a/Documentation/devicetree/bindings/leds/rohm,bd71828-leds.yam=
l b/Documentation/devicetree/bindings/leds/rohm,bd71828-leds.yaml
> index b50f4bcc98f1..90edf9d33b33 100644
> --- a/Documentation/devicetree/bindings/leds/rohm,bd71828-leds.yaml
> +++ b/Documentation/devicetree/bindings/leds/rohm,bd71828-leds.yaml
> @@ -50,3 +50,6 @@ patternProperties:
>
>  required:
>    - compatible
> +additionalProperties: false
> +
> +...
> diff --git a/Documentation/devicetree/bindings/mailbox/amlogic,meson-gxbb=
-mhu.yaml b/Documentation/devicetree/bindings/mailbox/amlogic,meson-gxbb-mh=
u.yaml
> index 319280563648..aa2b3bf56b57 100644
> --- a/Documentation/devicetree/bindings/mailbox/amlogic,meson-gxbb-mhu.ya=
ml
> +++ b/Documentation/devicetree/bindings/mailbox/amlogic,meson-gxbb-mhu.ya=
ml
> @@ -41,6 +41,8 @@ required:
>    - interrupts
>    - "#mbox-cells"
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      mailbox@c883c404 {
> diff --git a/Documentation/devicetree/bindings/media/amlogic,gx-vdec.yaml=
 b/Documentation/devicetree/bindings/media/amlogic,gx-vdec.yaml
> index 335717e15970..37d77e065491 100644
> --- a/Documentation/devicetree/bindings/media/amlogic,gx-vdec.yaml
> +++ b/Documentation/devicetree/bindings/media/amlogic,gx-vdec.yaml
> @@ -124,6 +124,8 @@ required:
>    - amlogic,ao-sysctrl
>    - amlogic,canvas
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      vdec: video-decoder@c8820000 {
> diff --git a/Documentation/devicetree/bindings/media/amlogic,meson-gx-ao-=
cec.yaml b/Documentation/devicetree/bindings/media/amlogic,meson-gx-ao-cec.=
yaml
> index e8ce37fcbfec..95ffa8bc0533 100644
> --- a/Documentation/devicetree/bindings/media/amlogic,meson-gx-ao-cec.yam=
l
> +++ b/Documentation/devicetree/bindings/media/amlogic,meson-gx-ao-cec.yam=
l
> @@ -82,6 +82,8 @@ required:
>    - clocks
>    - clock-names
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      cec_AO: cec@100 {
> diff --git a/Documentation/devicetree/bindings/media/renesas,ceu.yaml b/D=
ocumentation/devicetree/bindings/media/renesas,ceu.yaml
> index 8e9251a0f9ef..fcb5f13704a5 100644
> --- a/Documentation/devicetree/bindings/media/renesas,ceu.yaml
> +++ b/Documentation/devicetree/bindings/media/renesas,ceu.yaml
> @@ -59,6 +59,8 @@ required:
>    - interrupts
>    - port
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/arm-gic.h>
> diff --git a/Documentation/devicetree/bindings/mfd/max77650.yaml b/Docume=
ntation/devicetree/bindings/mfd/max77650.yaml
> index 480385789394..b0a0f0d3d9d4 100644
> --- a/Documentation/devicetree/bindings/mfd/max77650.yaml
> +++ b/Documentation/devicetree/bindings/mfd/max77650.yaml
> @@ -73,6 +73,8 @@ required:
>    - gpio-controller
>    - "#gpio-cells"
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/irq.h>
> diff --git a/Documentation/devicetree/bindings/mfd/rohm,bd71828-pmic.yaml=
 b/Documentation/devicetree/bindings/mfd/rohm,bd71828-pmic.yaml
> index 38dc4f8b0ceb..3a6a1a26e2b3 100644
> --- a/Documentation/devicetree/bindings/mfd/rohm,bd71828-pmic.yaml
> +++ b/Documentation/devicetree/bindings/mfd/rohm,bd71828-pmic.yaml
> @@ -77,6 +77,8 @@ required:
>    - gpio-controller
>    - "#gpio-cells"
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/irq.h>
> diff --git a/Documentation/devicetree/bindings/misc/intel,ixp4xx-ahb-queu=
e-manager.yaml b/Documentation/devicetree/bindings/misc/intel,ixp4xx-ahb-qu=
eue-manager.yaml
> index 0ea21a6f70b4..38ab0499102d 100644
> --- a/Documentation/devicetree/bindings/misc/intel,ixp4xx-ahb-queue-manag=
er.yaml
> +++ b/Documentation/devicetree/bindings/misc/intel,ixp4xx-ahb-queue-manag=
er.yaml
> @@ -38,6 +38,8 @@ required:
>    - reg
>    - interrupts
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/irq.h>
> diff --git a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml b/=
Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
> index b9e9696da5be..976f139bb66e 100644
> --- a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
> @@ -167,6 +167,8 @@ required:
>    - '#address-cells'
>    - '#size-cells'
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/irq.h>
> diff --git a/Documentation/devicetree/bindings/phy/allwinner,sun50i-h6-us=
b3-phy.yaml b/Documentation/devicetree/bindings/phy/allwinner,sun50i-h6-usb=
3-phy.yaml
> index e5922b427342..c03b83103e87 100644
> --- a/Documentation/devicetree/bindings/phy/allwinner,sun50i-h6-usb3-phy.=
yaml
> +++ b/Documentation/devicetree/bindings/phy/allwinner,sun50i-h6-usb3-phy.=
yaml
> @@ -34,6 +34,8 @@ required:
>    - resets
>    - "#phy-cells"
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/sun50i-h6-ccu.h>
> diff --git a/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb=
3-pcie-phy.yaml b/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-=
usb3-pcie-phy.yaml
> index 346f9c35427c..453c083cf44c 100644
> --- a/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb3-pcie-=
phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb3-pcie-=
phy.yaml
> @@ -44,6 +44,8 @@ required:
>    - reset-names
>    - "#phy-cells"
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      phy@46000 {
> diff --git a/Documentation/devicetree/bindings/phy/intel,lgm-emmc-phy.yam=
l b/Documentation/devicetree/bindings/phy/intel,lgm-emmc-phy.yaml
> index 0ccee64c6962..9a346d6290d9 100644
> --- a/Documentation/devicetree/bindings/phy/intel,lgm-emmc-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/intel,lgm-emmc-phy.yaml
> @@ -40,6 +40,8 @@ required:
>    - reg
>    - clocks
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      sysconf: chiptop@e0200000 {
> diff --git a/Documentation/devicetree/bindings/phy/marvell,mmp3-hsic-phy.=
yaml b/Documentation/devicetree/bindings/phy/marvell,mmp3-hsic-phy.yaml
> index 5ab436189f3b..00609ace677c 100644
> --- a/Documentation/devicetree/bindings/phy/marvell,mmp3-hsic-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/marvell,mmp3-hsic-phy.yaml
> @@ -31,6 +31,8 @@ required:
>    - reset-gpios
>    - "#phy-cells"
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> diff --git a/Documentation/devicetree/bindings/phy/ti,phy-j721e-wiz.yaml =
b/Documentation/devicetree/bindings/phy/ti,phy-j721e-wiz.yaml
> index 452cee1aed32..fd1982c56104 100644
> --- a/Documentation/devicetree/bindings/phy/ti,phy-j721e-wiz.yaml
> +++ b/Documentation/devicetree/bindings/phy/ti,phy-j721e-wiz.yaml
> @@ -159,6 +159,8 @@ required:
>    - "#reset-cells"
>    - ranges
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/soc/ti,sci_pm_domain.h>
> diff --git a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2400-pin=
ctrl.yaml b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2400-pinctr=
l.yaml
> index 135c7dfbc180..7651a675ab2d 100644
> --- a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2400-pinctrl.ya=
ml
> +++ b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2400-pinctrl.ya=
ml
> @@ -57,6 +57,8 @@ patternProperties:
>  required:
>    - compatible
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      syscon: scu@1e6e2000 {
> diff --git a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2500-pin=
ctrl.yaml b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2500-pinctr=
l.yaml
> index 824f7fd1d51b..36feaf5e2dff 100644
> --- a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2500-pinctrl.ya=
ml
> +++ b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2500-pinctrl.ya=
ml
> @@ -70,6 +70,8 @@ required:
>    - compatible
>    - aspeed,external-nodes
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      apb {
> diff --git a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pin=
ctrl.yaml b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctr=
l.yaml
> index ac8d1c30a8ed..45af29bc3202 100644
> --- a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.ya=
ml
> +++ b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.ya=
ml
> @@ -92,6 +92,8 @@ patternProperties:
>  required:
>    - compatible
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      syscon: scu@1e6e2000 {
> diff --git a/Documentation/devicetree/bindings/pinctrl/st,stm32-pinctrl.y=
aml b/Documentation/devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml
> index ef4de32cb17c..46a0478cb924 100644
> --- a/Documentation/devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml
> +++ b/Documentation/devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml
> @@ -194,6 +194,8 @@ required:
>    - ranges
>    - pins-are-numbered
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/pinctrl/stm32-pinfunc.h>
> diff --git a/Documentation/devicetree/bindings/power/amlogic,meson-ee-pwr=
c.yaml b/Documentation/devicetree/bindings/power/amlogic,meson-ee-pwrc.yaml
> index d3098c924b25..6c6079fe1351 100644
> --- a/Documentation/devicetree/bindings/power/amlogic,meson-ee-pwrc.yaml
> +++ b/Documentation/devicetree/bindings/power/amlogic,meson-ee-pwrc.yaml
> @@ -68,6 +68,8 @@ required:
>    - "#power-domain-cells"
>    - amlogic,ao-sysctrl
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      pwrc: power-controller {
> diff --git a/Documentation/devicetree/bindings/power/reset/syscon-powerof=
f.yaml b/Documentation/devicetree/bindings/power/reset/syscon-poweroff.yaml
> index 520e07e6f21b..3412fe7e1e80 100644
> --- a/Documentation/devicetree/bindings/power/reset/syscon-poweroff.yaml
> +++ b/Documentation/devicetree/bindings/power/reset/syscon-poweroff.yaml
> @@ -41,6 +41,8 @@ required:
>    - regmap
>    - offset
>
> +additionalProperties: false
> +
>  allOf:
>    - if:
>        not:
> diff --git a/Documentation/devicetree/bindings/power/reset/syscon-reboot.=
yaml b/Documentation/devicetree/bindings/power/reset/syscon-reboot.yaml
> index d38006b1f1f4..b80772cb9f06 100644
> --- a/Documentation/devicetree/bindings/power/reset/syscon-reboot.yaml
> +++ b/Documentation/devicetree/bindings/power/reset/syscon-reboot.yaml
> @@ -41,6 +41,8 @@ required:
>    - regmap
>    - offset
>
> +additionalProperties: false
> +
>  allOf:
>    - if:
>        not:
> diff --git a/Documentation/devicetree/bindings/power/supply/max77650-char=
ger.yaml b/Documentation/devicetree/bindings/power/supply/max77650-charger.=
yaml
> index deef010ec535..62eeddb65aed 100644
> --- a/Documentation/devicetree/bindings/power/supply/max77650-charger.yam=
l
> +++ b/Documentation/devicetree/bindings/power/supply/max77650-charger.yam=
l
> @@ -32,3 +32,6 @@ properties:
>
>  required:
>    - compatible
> +additionalProperties: false
> +
> +...
> diff --git a/Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml b/Docum=
entation/devicetree/bindings/ptp/ptp-idtcm.yaml
> index 9e21b83d717e..239b49fad805 100644
> --- a/Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml
> +++ b/Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml
> @@ -55,6 +55,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      i2c@1 {
> diff --git a/Documentation/devicetree/bindings/regulator/max77650-regulat=
or.yaml b/Documentation/devicetree/bindings/regulator/max77650-regulator.ya=
ml
> index 50690487edc8..ce0a4021ae7f 100644
> --- a/Documentation/devicetree/bindings/regulator/max77650-regulator.yaml
> +++ b/Documentation/devicetree/bindings/regulator/max77650-regulator.yaml
> @@ -29,3 +29,6 @@ patternProperties:
>
>  required:
>    - compatible
> +additionalProperties: false
> +
> +...
> diff --git a/Documentation/devicetree/bindings/reset/amlogic,meson-reset.=
yaml b/Documentation/devicetree/bindings/reset/amlogic,meson-reset.yaml
> index b3f57d81f007..92922d3afd14 100644
> --- a/Documentation/devicetree/bindings/reset/amlogic,meson-reset.yaml
> +++ b/Documentation/devicetree/bindings/reset/amlogic,meson-reset.yaml
> @@ -29,6 +29,8 @@ required:
>    - reg
>    - "#reset-cells"
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      reset-controller@c884404 {
> diff --git a/Documentation/devicetree/bindings/reset/brcm,bcm7216-pcie-sa=
ta-rescal.yaml b/Documentation/devicetree/bindings/reset/brcm,bcm7216-pcie-=
sata-rescal.yaml
> index 411bd76f1b64..512a33bdb208 100644
> --- a/Documentation/devicetree/bindings/reset/brcm,bcm7216-pcie-sata-resc=
al.yaml
> +++ b/Documentation/devicetree/bindings/reset/brcm,bcm7216-pcie-sata-resc=
al.yaml
> @@ -28,6 +28,8 @@ required:
>    - reg
>    - "#reset-cells"
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      reset-controller@8b2c800 {
> diff --git a/Documentation/devicetree/bindings/rng/amlogic,meson-rng.yaml=
 b/Documentation/devicetree/bindings/rng/amlogic,meson-rng.yaml
> index a9ff3cb35c5e..444be32a8a29 100644
> --- a/Documentation/devicetree/bindings/rng/amlogic,meson-rng.yaml
> +++ b/Documentation/devicetree/bindings/rng/amlogic,meson-rng.yaml
> @@ -29,6 +29,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      rng@c8834000 {
> diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml b/Do=
cumentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> index 42d9a38e4e1a..89ab67f20a7f 100644
> --- a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> +++ b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> @@ -35,6 +35,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      rng {
> diff --git a/Documentation/devicetree/bindings/rtc/renesas,sh-rtc.yaml b/=
Documentation/devicetree/bindings/rtc/renesas,sh-rtc.yaml
> index dcff573cbdb1..b95cb017f469 100644
> --- a/Documentation/devicetree/bindings/rtc/renesas,sh-rtc.yaml
> +++ b/Documentation/devicetree/bindings/rtc/renesas,sh-rtc.yaml
> @@ -51,6 +51,8 @@ required:
>    - clocks
>    - clock-names
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/r7s72100-clock.h>
> diff --git a/Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml b/Do=
cumentation/devicetree/bindings/rtc/st,stm32-rtc.yaml
> index 0a54296d7218..48c6cafca90c 100644
> --- a/Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml
> +++ b/Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml
> @@ -111,6 +111,8 @@ required:
>    - clocks
>    - interrupts
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/mfd/stm32f4-rcc.h>
> diff --git a/Documentation/devicetree/bindings/serial/amlogic,meson-uart.=
yaml b/Documentation/devicetree/bindings/serial/amlogic,meson-uart.yaml
> index 214fe8beddc3..d4178ab0d675 100644
> --- a/Documentation/devicetree/bindings/serial/amlogic,meson-uart.yaml
> +++ b/Documentation/devicetree/bindings/serial/amlogic,meson-uart.yaml
> @@ -62,6 +62,8 @@ required:
>    - clocks
>    - clock-names
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      serial@84c0 {
> diff --git a/Documentation/devicetree/bindings/soc/amlogic/amlogic,canvas=
.yaml b/Documentation/devicetree/bindings/soc/amlogic/amlogic,canvas.yaml
> index f548594d020b..cb008fd188d8 100644
> --- a/Documentation/devicetree/bindings/soc/amlogic/amlogic,canvas.yaml
> +++ b/Documentation/devicetree/bindings/soc/amlogic/amlogic,canvas.yaml
> @@ -40,6 +40,8 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      canvas: video-lut@48 {
> diff --git a/Documentation/devicetree/bindings/sound/adi,adau7118.yaml b/=
Documentation/devicetree/bindings/sound/adi,adau7118.yaml
> index 75e0cbe6be70..76ee695097bf 100644
> --- a/Documentation/devicetree/bindings/sound/adi,adau7118.yaml
> +++ b/Documentation/devicetree/bindings/sound/adi,adau7118.yaml
> @@ -59,6 +59,8 @@ required:
>    - iovdd-supply
>    - dvdd-supply
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      i2c {
> diff --git a/Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml b/=
Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml
> index 38eaf0c028f9..a495d5fc0d23 100644
> --- a/Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml
> +++ b/Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml
> @@ -139,6 +139,8 @@ required:
>    - "#address-cells"
>    - "#size-cells"
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      codec@1,0{
> diff --git a/Documentation/devicetree/bindings/sound/renesas,fsi.yaml b/D=
ocumentation/devicetree/bindings/sound/renesas,fsi.yaml
> index 140a37fc3c0b..d1b65554e681 100644
> --- a/Documentation/devicetree/bindings/sound/renesas,fsi.yaml
> +++ b/Documentation/devicetree/bindings/sound/renesas,fsi.yaml
> @@ -63,6 +63,8 @@ required:
>    - reg
>    - interrupts
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      sh_fsi2: sound@ec230000 {
> diff --git a/Documentation/devicetree/bindings/sound/samsung,odroid.yaml =
b/Documentation/devicetree/bindings/sound/samsung,odroid.yaml
> index c6b244352d05..8ff2d39e7d17 100644
> --- a/Documentation/devicetree/bindings/sound/samsung,odroid.yaml
> +++ b/Documentation/devicetree/bindings/sound/samsung,odroid.yaml
> @@ -69,6 +69,8 @@ required:
>    - cpu
>    - codec
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      sound {
> diff --git a/Documentation/devicetree/bindings/sound/samsung-i2s.yaml b/D=
ocumentation/devicetree/bindings/sound/samsung-i2s.yaml
> index 53e3bad4178c..b2ad093d94df 100644
> --- a/Documentation/devicetree/bindings/sound/samsung-i2s.yaml
> +++ b/Documentation/devicetree/bindings/sound/samsung-i2s.yaml
> @@ -115,6 +115,8 @@ required:
>    - clocks
>    - clock-names
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/exynos-audss-clk.h>
> diff --git a/Documentation/devicetree/bindings/sram/qcom,ocmem.yaml b/Doc=
umentation/devicetree/bindings/sram/qcom,ocmem.yaml
> index 469cec133647..930188bc5e6a 100644
> --- a/Documentation/devicetree/bindings/sram/qcom,ocmem.yaml
> +++ b/Documentation/devicetree/bindings/sram/qcom,ocmem.yaml
> @@ -56,6 +56,8 @@ required:
>    - '#size-cells'
>    - ranges
>
> +additionalProperties: false
> +
>  patternProperties:
>    "-sram@[0-9a-f]+$":
>      type: object
> diff --git a/Documentation/devicetree/bindings/thermal/amlogic,thermal.ya=
ml b/Documentation/devicetree/bindings/thermal/amlogic,thermal.yaml
> index 93fe7b10a82e..e43ec50bda37 100644
> --- a/Documentation/devicetree/bindings/thermal/amlogic,thermal.yaml
> +++ b/Documentation/devicetree/bindings/thermal/amlogic,thermal.yaml
> @@ -42,6 +42,8 @@ required:
>    - clocks
>    - amlogic,ao-secure
>
> +additionalProperties: false
> +
>  examples:
>    - |
>          cpu_temp: temperature-sensor@ff634800 {
> diff --git a/Documentation/devicetree/bindings/timer/arm,arch_timer.yaml =
b/Documentation/devicetree/bindings/timer/arm,arch_timer.yaml
> index 6deead07728e..fa255672e8e5 100644
> --- a/Documentation/devicetree/bindings/timer/arm,arch_timer.yaml
> +++ b/Documentation/devicetree/bindings/timer/arm,arch_timer.yaml
> @@ -82,6 +82,8 @@ properties:
>  required:
>    - compatible
>
> +additionalProperties: false
> +
>  oneOf:
>    - required:
>        - interrupts
> diff --git a/Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.=
yaml b/Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.yaml
> index f7ef6646bade..582bbef62b95 100644
> --- a/Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.yaml
> +++ b/Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.yaml
> @@ -95,6 +95,8 @@ required:
>    - '#address-cells'
>    - '#size-cells'
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      timer@f0000000 {
> diff --git a/Documentation/devicetree/bindings/timer/arm,global_timer.yam=
l b/Documentation/devicetree/bindings/timer/arm,global_timer.yaml
> index 21c24a8e28fd..4956c8f409d2 100644
> --- a/Documentation/devicetree/bindings/timer/arm,global_timer.yaml
> +++ b/Documentation/devicetree/bindings/timer/arm,global_timer.yaml
> @@ -35,6 +35,8 @@ required:
>    - reg
>    - clocks
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      timer@2c000600 {
> diff --git a/Documentation/devicetree/bindings/timer/intel,ixp4xx-timer.y=
aml b/Documentation/devicetree/bindings/timer/intel,ixp4xx-timer.yaml
> index 2807225db902..1a721d8af67a 100644
> --- a/Documentation/devicetree/bindings/timer/intel,ixp4xx-timer.yaml
> +++ b/Documentation/devicetree/bindings/timer/intel,ixp4xx-timer.yaml
> @@ -32,6 +32,8 @@ required:
>    - reg
>    - interrupts
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/irq.h>
> diff --git a/Documentation/devicetree/bindings/timer/samsung,exynos4210-m=
ct.yaml b/Documentation/devicetree/bindings/timer/samsung,exynos4210-mct.ya=
ml
> index 273e359854dd..37bd01a62c52 100644
> --- a/Documentation/devicetree/bindings/timer/samsung,exynos4210-mct.yaml
> +++ b/Documentation/devicetree/bindings/timer/samsung,exynos4210-mct.yaml
> @@ -52,6 +52,8 @@ required:
>    - interrupts
>    - reg
>
> +additionalProperties: false
> +
>  examples:
>    - |
>      // In this example, the IP contains two local timers, using separate
> diff --git a/Documentation/devicetree/bindings/trivial-devices.yaml b/Doc=
umentation/devicetree/bindings/trivial-devices.yaml
> index 51d1f6e43c02..bcae5f9b1d7f 100644
> --- a/Documentation/devicetree/bindings/trivial-devices.yaml
> +++ b/Documentation/devicetree/bindings/trivial-devices.yaml
> @@ -369,4 +369,6 @@ required:
>    - compatible
>    - reg
>
> +additionalProperties: false
> +
>  ...
> --
> 2.20.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
