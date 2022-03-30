Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1CC4EC7B4
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 17:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347791AbiC3PGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 11:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347772AbiC3PGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 11:06:00 -0400
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C859C75219;
        Wed, 30 Mar 2022 08:04:14 -0700 (PDT)
Received: by mail-ot1-f49.google.com with SMTP id i23-20020a9d6117000000b005cb58c354e6so15083754otj.10;
        Wed, 30 Mar 2022 08:04:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a0Qx16jN1XmN4Y2BBIC8WZKR/lqJ3CCvy460j4hfpJU=;
        b=3pZvNGKpXmGd8MmuIG0vUmJ/PY0eUewq4tpTqMN57oPl+XLuu9EREsOx00MblhFyur
         MYwHUU7oXc4CvIE4iFOMTBW2HfkiiSBaSmX97Z3IGpzii9xZgHONscasPij5H5FeaeCF
         CR3/XF+5P7OEXHeT+Bx/h2Z89flcEngbEth8aQFyrgy/SOmhn1F8gLPFHebGW0PvKvl9
         YtTD1ttarUrqf3NjeCigziwmqQIqZWLsdY+OcADx08jxzTBzklAmidK1pZ22O2x4Rqfc
         bKtl7BeDwADSdqwZEyYQP3BbkY9Jx0TNk3gdDOv9Wh4qK0edfAbvLez5umuCrL3w4zN3
         jUgQ==
X-Gm-Message-State: AOAM531l2A5rjo7mN5FjZDloEfI6OEINf2QrzJyzyacjuuJYw2IVr8FP
        6GdrgaezKKbmMQYWAFLPuQ==
X-Google-Smtp-Source: ABdhPJw4BtyiHMI8Rkn8KkRu0zRrS/KBtlV7cGVu+PN3sHJ9/fQoVaJv4gJd0mwesxt2MLGtea2lyA==
X-Received: by 2002:a05:6830:2055:b0:5b2:5659:542f with SMTP id f21-20020a056830205500b005b25659542fmr3433041otp.189.1648652653992;
        Wed, 30 Mar 2022 08:04:13 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id u2-20020a056870304200b000ddb1828e3csm9878600oau.19.2022.03.30.08.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 08:04:12 -0700 (PDT)
Received: (nullmailer pid 3056199 invoked by uid 1000);
        Wed, 30 Mar 2022 15:04:11 -0000
Date:   Wed, 30 Mar 2022 10:04:11 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 1/2] dt-bindings: update Krzysztof Kozlowski's email
Message-ID: <YkRxa1yweG7ace6r@robh.at.kernel.org>
References: <20220330074016.12896-1-krzysztof.kozlowski@linaro.org>
 <20220330074016.12896-2-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330074016.12896-2-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 09:40:15AM +0200, Krzysztof Kozlowski wrote:
> From: Krzysztof Kozlowski <krzk@kernel.org>
> 
> Krzysztof Kozlowski's @canonical.com email stopped working, so switch to
> generic @kernel.org account for all Devicetree bindings.
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  .../devicetree/bindings/clock/samsung,exynos-audss-clock.yaml   | 2 +-
>  .../devicetree/bindings/clock/samsung,exynos-clock.yaml         | 2 +-
>  .../devicetree/bindings/clock/samsung,exynos-ext-clock.yaml     | 2 +-
>  .../devicetree/bindings/clock/samsung,exynos4412-isp-clock.yaml | 2 +-
>  .../devicetree/bindings/clock/samsung,exynos5260-clock.yaml     | 2 +-
>  .../devicetree/bindings/clock/samsung,exynos5410-clock.yaml     | 2 +-
>  .../devicetree/bindings/clock/samsung,exynos5433-clock.yaml     | 2 +-
>  .../devicetree/bindings/clock/samsung,exynos7-clock.yaml        | 2 +-
>  .../devicetree/bindings/clock/samsung,exynos7885-clock.yaml     | 2 +-
>  .../devicetree/bindings/clock/samsung,exynos850-clock.yaml      | 2 +-
>  Documentation/devicetree/bindings/clock/samsung,s2mps11.yaml    | 2 +-
>  .../devicetree/bindings/clock/samsung,s5pv210-audss-clock.yaml  | 2 +-
>  .../devicetree/bindings/clock/samsung,s5pv210-clock.yaml        | 2 +-
>  .../devicetree/bindings/devfreq/event/samsung,exynos-nocp.yaml  | 2 +-
>  .../devicetree/bindings/devfreq/event/samsung,exynos-ppmu.yaml  | 2 +-
>  .../bindings/display/samsung/samsung,exynos-hdmi-ddc.yaml       | 2 +-
>  .../bindings/display/samsung/samsung,exynos-hdmi.yaml           | 2 +-
>  .../bindings/display/samsung/samsung,exynos-mixer.yaml          | 2 +-
>  .../bindings/display/samsung/samsung,exynos5433-decon.yaml      | 2 +-
>  .../bindings/display/samsung/samsung,exynos5433-mic.yaml        | 2 +-
>  .../bindings/display/samsung/samsung,exynos7-decon.yaml         | 2 +-
>  .../devicetree/bindings/display/samsung/samsung,fimd.yaml       | 2 +-
>  Documentation/devicetree/bindings/extcon/maxim,max77843.yaml    | 2 +-
>  Documentation/devicetree/bindings/hwmon/lltc,ltc4151.yaml       | 2 +-
>  Documentation/devicetree/bindings/hwmon/microchip,mcp3021.yaml  | 2 +-
>  Documentation/devicetree/bindings/hwmon/sensirion,sht15.yaml    | 2 +-
>  Documentation/devicetree/bindings/hwmon/ti,tmp102.yaml          | 2 +-
>  Documentation/devicetree/bindings/hwmon/ti,tmp108.yaml          | 2 +-
>  Documentation/devicetree/bindings/i2c/i2c-exynos5.yaml          | 2 +-
>  Documentation/devicetree/bindings/i2c/samsung,s3c2410-i2c.yaml  | 2 +-
>  .../interrupt-controller/samsung,exynos4210-combiner.yaml       | 2 +-
>  Documentation/devicetree/bindings/leds/maxim,max77693.yaml      | 2 +-
>  .../devicetree/bindings/memory-controllers/brcm,dpfe-cpu.yaml   | 2 +-
>  .../bindings/memory-controllers/ddr/jedec,lpddr2-timings.yaml   | 2 +-
>  .../bindings/memory-controllers/ddr/jedec,lpddr2.yaml           | 2 +-
>  .../bindings/memory-controllers/ddr/jedec,lpddr3-timings.yaml   | 2 +-
>  .../bindings/memory-controllers/ddr/jedec,lpddr3.yaml           | 2 +-
>  .../memory-controllers/marvell,mvebu-sdram-controller.yaml      | 2 +-
>  .../bindings/memory-controllers/qca,ath79-ddr-controller.yaml   | 2 +-
>  .../bindings/memory-controllers/renesas,h8300-bsc.yaml          | 2 +-
>  .../bindings/memory-controllers/samsung,exynos5422-dmc.yaml     | 2 +-
>  .../bindings/memory-controllers/synopsys,ddrc-ecc.yaml          | 2 +-
>  .../devicetree/bindings/memory-controllers/ti,da8xx-ddrctl.yaml | 2 +-
>  Documentation/devicetree/bindings/mfd/maxim,max14577.yaml       | 2 +-
>  Documentation/devicetree/bindings/mfd/maxim,max77686.yaml       | 2 +-
>  Documentation/devicetree/bindings/mfd/maxim,max77693.yaml       | 2 +-
>  Documentation/devicetree/bindings/mfd/maxim,max77802.yaml       | 2 +-
>  Documentation/devicetree/bindings/mfd/maxim,max77843.yaml       | 2 +-
>  .../devicetree/bindings/mfd/samsung,exynos5433-lpass.yaml       | 2 +-
>  Documentation/devicetree/bindings/mfd/samsung,s2mpa01.yaml      | 2 +-
>  Documentation/devicetree/bindings/mfd/samsung,s2mps11.yaml      | 2 +-
>  Documentation/devicetree/bindings/mfd/samsung,s5m8767.yaml      | 2 +-
>  Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml      | 2 +-
>  Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml          | 2 +-
>  Documentation/devicetree/bindings/net/nfc/nxp,pn532.yaml        | 2 +-
>  Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml        | 2 +-
>  Documentation/devicetree/bindings/net/nfc/st,st-nci.yaml        | 2 +-
>  Documentation/devicetree/bindings/net/nfc/st,st21nfca.yaml      | 2 +-
>  Documentation/devicetree/bindings/net/nfc/st,st95hf.yaml        | 2 +-
>  Documentation/devicetree/bindings/net/nfc/ti,trf7970a.yaml      | 2 +-
>  Documentation/devicetree/bindings/phy/samsung,dp-video-phy.yaml | 2 +-
>  .../devicetree/bindings/phy/samsung,exynos-hdmi-phy.yaml        | 2 +-
>  .../devicetree/bindings/phy/samsung,exynos5250-sata-phy.yaml    | 2 +-
>  .../devicetree/bindings/phy/samsung,mipi-video-phy.yaml         | 2 +-
>  Documentation/devicetree/bindings/phy/samsung,usb2-phy.yaml     | 2 +-
>  Documentation/devicetree/bindings/phy/samsung,usb3-drd-phy.yaml | 2 +-
>  .../devicetree/bindings/pinctrl/samsung,pinctrl-gpio-bank.yaml  | 2 +-
>  .../devicetree/bindings/pinctrl/samsung,pinctrl-pins-cfg.yaml   | 2 +-
>  .../bindings/pinctrl/samsung,pinctrl-wakeup-interrupt.yaml      | 2 +-
>  Documentation/devicetree/bindings/pinctrl/samsung,pinctrl.yaml  | 2 +-
>  .../devicetree/bindings/power/supply/maxim,max14577.yaml        | 2 +-
>  .../devicetree/bindings/power/supply/maxim,max77693.yaml        | 2 +-
>  Documentation/devicetree/bindings/regulator/maxim,max14577.yaml | 2 +-
>  Documentation/devicetree/bindings/regulator/maxim,max77686.yaml | 2 +-
>  Documentation/devicetree/bindings/regulator/maxim,max77693.yaml | 2 +-
>  Documentation/devicetree/bindings/regulator/maxim,max77802.yaml | 2 +-
>  Documentation/devicetree/bindings/regulator/maxim,max77843.yaml | 2 +-
>  Documentation/devicetree/bindings/regulator/maxim,max8952.yaml  | 2 +-
>  Documentation/devicetree/bindings/regulator/maxim,max8973.yaml  | 2 +-
>  Documentation/devicetree/bindings/regulator/maxim,max8997.yaml  | 2 +-
>  .../devicetree/bindings/regulator/samsung,s2mpa01.yaml          | 2 +-
>  .../devicetree/bindings/regulator/samsung,s2mps11.yaml          | 2 +-
>  .../devicetree/bindings/regulator/samsung,s2mps13.yaml          | 2 +-
>  .../devicetree/bindings/regulator/samsung,s2mps14.yaml          | 2 +-
>  .../devicetree/bindings/regulator/samsung,s2mps15.yaml          | 2 +-
>  .../devicetree/bindings/regulator/samsung,s2mpu02.yaml          | 2 +-
>  .../devicetree/bindings/regulator/samsung,s5m8767.yaml          | 2 +-
>  .../devicetree/bindings/rng/samsung,exynos5250-trng.yaml        | 2 +-
>  Documentation/devicetree/bindings/rng/timeriomem_rng.yaml       | 2 +-
>  Documentation/devicetree/bindings/soc/samsung/exynos-usi.yaml   | 2 +-
>  Documentation/devicetree/bindings/sound/samsung,arndale.yaml    | 2 +-
>  Documentation/devicetree/bindings/sound/samsung,smdk5250.yaml   | 2 +-
>  Documentation/devicetree/bindings/sound/samsung,snow.yaml       | 2 +-
>  Documentation/devicetree/bindings/sound/samsung,tm2.yaml        | 2 +-
>  .../devicetree/bindings/spi/samsung,spi-peripheral-props.yaml   | 2 +-
>  Documentation/devicetree/bindings/spi/samsung,spi.yaml          | 2 +-
>  .../devicetree/bindings/thermal/samsung,exynos-thermal.yaml     | 2 +-
>  Documentation/devicetree/bindings/usb/samsung,exynos-dwc3.yaml  | 2 +-
>  Documentation/devicetree/bindings/usb/samsung,exynos-usb2.yaml  | 2 +-
>  99 files changed, 99 insertions(+), 99 deletions(-)

Acked-by: Rob Herring <robh@kernel.org>

Arnd suggested 5.19, but this one needs to be 5.18.

Rob
