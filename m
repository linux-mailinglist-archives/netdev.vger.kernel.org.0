Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AABC433DEAD
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 21:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhCPU0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 16:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbhCPU0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 16:26:07 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A877FC06175F
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 13:26:07 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id m7so19595416iow.7
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 13:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bvkqNr1q78jgqt9ME2KjhcsSH1MGlZ3R4wsxExVXRtc=;
        b=aQI+a21P3/jQfp2XBCLpKA2XaF4d5h3u1dOHvC7XfJmy4Pv2OZk9eXfxC3Ka9vZNLg
         EO21aV6GaVbMhwaByQY77Pz3lOGWZjsBh3Dtk919+/lWVtXwxYwuLSv2mdgmQ6lqIupI
         nBE5rQzNd5O5jMR29ufLhcU7SA4WqArxE/PD8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bvkqNr1q78jgqt9ME2KjhcsSH1MGlZ3R4wsxExVXRtc=;
        b=acdMAmPb2mAFuiWSNVAQW/dbhGzhdppkFpP83i7o8pnlTj2WL5iuqVe19y8/B6fJZJ
         UTuNH3nCndg4KnKRBJuSfE23wE+imWCYIFC6FSwaEzkEN11X+pE6PIYbqZaa44lDA5zK
         YQIjun3mfFz3RB6Ykktswb+4/s0uTCraY4N6/RTVXd43Wx8K+HnFG8cReJdw3P4mgRTf
         AHyYUVrmA4u5HCNPyaLZFcqeIn6FgTmE3TgdaQ7r/WKT44JKT6MVkSHgi5ZydPRdMKQC
         QF19KLgeHy5nOACIhgOsdXP+FlsTy6iNe/NgHeEM/zyRQ91qGx2SeT3Un7u+szR875qE
         eszA==
X-Gm-Message-State: AOAM532hLX58LpRnnJUctWJehJ1KQFiz7pc+C7Ph1bsWqr0GyOlvgJLr
        tLal87xvrH8ApapU8smkw+vnlg==
X-Google-Smtp-Source: ABdhPJzy4mGSz2YUBoXl8UAsu2NnVceuM4ynQkpHc0OrhVOY9bLUogPf0mJ7kYjy/ReSLuG6SxRI0Q==
X-Received: by 2002:a05:6638:140e:: with SMTP id k14mr376382jad.31.1615926367038;
        Tue, 16 Mar 2021 13:26:07 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id v4sm9907370ilo.26.2021.03.16.13.26.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 13:26:06 -0700 (PDT)
Subject: Re: [PATCH] dt-bindings: Drop type references on common properties
To:     Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Maxime Ripard <mripard@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mark Brown <broonie@kernel.org>,
        Cheng-Yi Chiang <cychiang@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefan Wahren <wahrenst@gmx.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Odelu Kukatla <okukatla@codeaurora.org>,
        Alex Elder <elder@kernel.org>, Suman Anna <s-anna@ti.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org
References: <20210316194858.3527845-1-robh@kernel.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <b7599ef5-899f-5c38-d3e4-8ac8cfe06c56@ieee.org>
Date:   Tue, 16 Mar 2021 15:26:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210316194858.3527845-1-robh@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/16/21 2:48 PM, Rob Herring wrote:
> Users of common properties shouldn't have a type definition as the
> common schemas already have one. Drop all the unnecessary type
> references in the tree.
> 
> A meta-schema update to catch these is pending.

For net/qcom,ipa.yaml:

Acked-by: Alex Elder <elder@linaro.org>

> 
> Cc: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Cheng-Yi Chiang <cychiang@chromium.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Stefan Wahren <wahrenst@gmx.net>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Cc: Odelu Kukatla <okukatla@codeaurora.org>
> Cc: Alex Elder <elder@kernel.org>
> Cc: Suman Anna <s-anna@ti.com>
> Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Cc: linux-gpio@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-can@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-remoteproc@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>   .../bindings/arm/bcm/raspberrypi,bcm2835-firmware.yaml       | 5 +----
>   Documentation/devicetree/bindings/arm/cpus.yaml              | 2 --
>   .../bindings/display/allwinner,sun4i-a10-tcon.yaml           | 1 -
>   .../devicetree/bindings/gpio/socionext,uniphier-gpio.yaml    | 3 +--
>   .../devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml      | 1 -
>   .../devicetree/bindings/interconnect/qcom,rpmh.yaml          | 1 -
>   .../bindings/memory-controllers/nvidia,tegra210-emc.yaml     | 2 +-
>   Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml   | 1 -
>   Documentation/devicetree/bindings/net/qcom,ipa.yaml          | 1 -
>   Documentation/devicetree/bindings/nvmem/nvmem-consumer.yaml  | 2 --
>   .../devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml   | 2 +-
>   Documentation/devicetree/bindings/sound/ak4642.yaml          | 2 --
>   .../devicetree/bindings/sound/google,cros-ec-codec.yaml      | 2 +-
>   Documentation/devicetree/bindings/sound/renesas,rsnd.yaml    | 1 -
>   .../devicetree/bindings/thermal/qcom-spmi-adc-tm5.yaml       | 1 -
>   Documentation/devicetree/bindings/usb/usb.yaml               | 1 -
>   16 files changed, 5 insertions(+), 23 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/bcm/raspberrypi,bcm2835-firmware.yaml b/Documentation/devicetree/bindings/arm/bcm/raspberrypi,bcm2835-firmware.yaml
> index a2c63c8b1d10..c6144c8421fa 100644
> --- a/Documentation/devicetree/bindings/arm/bcm/raspberrypi,bcm2835-firmware.yaml
> +++ b/Documentation/devicetree/bindings/arm/bcm/raspberrypi,bcm2835-firmware.yaml
> @@ -26,10 +26,7 @@ properties:
>         - const: simple-mfd
>   
>     mboxes:
> -    $ref: '/schemas/types.yaml#/definitions/phandle'
> -    description: |
> -      Phandle to the firmware device's Mailbox.
> -      (See: ../mailbox/mailbox.txt for more information)
> +    maxItems: 1
>   
>     clocks:
>       type: object
> diff --git a/Documentation/devicetree/bindings/arm/cpus.yaml b/Documentation/devicetree/bindings/arm/cpus.yaml
> index 26b886b20b27..6be4a8852ee5 100644
> --- a/Documentation/devicetree/bindings/arm/cpus.yaml
> +++ b/Documentation/devicetree/bindings/arm/cpus.yaml
> @@ -256,13 +256,11 @@ properties:
>         where voltage is in V, frequency is in MHz.
>   
>     power-domains:
> -    $ref: '/schemas/types.yaml#/definitions/phandle-array'
>       description:
>         List of phandles and PM domain specifiers, as defined by bindings of the
>         PM domain provider (see also ../power_domain.txt).
>   
>     power-domain-names:
> -    $ref: '/schemas/types.yaml#/definitions/string-array'
>       description:
>         A list of power domain name strings sorted in the same order as the
>         power-domains property.
> diff --git a/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml b/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml
> index c13faf3e6581..3a7d5d731712 100644
> --- a/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml
> +++ b/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml
> @@ -73,7 +73,6 @@ properties:
>     clock-output-names:
>       description:
>         Name of the LCD pixel clock created.
> -    $ref: /schemas/types.yaml#/definitions/string-array
>       maxItems: 1
>   
>     dmas:
> diff --git a/Documentation/devicetree/bindings/gpio/socionext,uniphier-gpio.yaml b/Documentation/devicetree/bindings/gpio/socionext,uniphier-gpio.yaml
> index 1a54db04f29d..bcafa494ed7a 100644
> --- a/Documentation/devicetree/bindings/gpio/socionext,uniphier-gpio.yaml
> +++ b/Documentation/devicetree/bindings/gpio/socionext,uniphier-gpio.yaml
> @@ -43,8 +43,7 @@ properties:
>   
>     gpio-ranges: true
>   
> -  gpio-ranges-group-names:
> -    $ref: /schemas/types.yaml#/definitions/string-array
> +  gpio-ranges-group-names: true
>   
>     socionext,interrupt-ranges:
>       description: |
> diff --git a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
> index 6f2398cdc82d..1e7894e524f9 100644
> --- a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
> @@ -102,7 +102,6 @@ patternProperties:
>   
>         st,adc-channel-names:
>           description: List of single-ended channel names.
> -        $ref: /schemas/types.yaml#/definitions/string-array
>   
>         st,filter-order:
>           description: |
> diff --git a/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml b/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
> index 799e73cdb90b..13da7b29c707 100644
> --- a/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
> +++ b/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
> @@ -82,7 +82,6 @@ properties:
>         this interconnect to send RPMh commands.
>   
>     qcom,bcm-voter-names:
> -    $ref: /schemas/types.yaml#/definitions/string-array
>       description: |
>         Names for each of the qcom,bcm-voters specified.
>   
> diff --git a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra210-emc.yaml b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra210-emc.yaml
> index 49ab09252e52..bc8477e7ab19 100644
> --- a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra210-emc.yaml
> +++ b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra210-emc.yaml
> @@ -34,7 +34,7 @@ properties:
>         - description: EMC general interrupt
>   
>     memory-region:
> -    $ref: /schemas/types.yaml#/definitions/phandle
> +    maxItems: 1
>       description:
>         phandle to a reserved memory region describing the table of EMC
>         frequencies trained by the firmware
> diff --git a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
> index fe6a949a2eab..55bff1586b6f 100644
> --- a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
> +++ b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
> @@ -57,7 +57,6 @@ properties:
>         - const: per
>   
>     clock-frequency:
> -    $ref: /schemas/types.yaml#/definitions/uint32
>       description: |
>         The oscillator frequency driving the flexcan device, filled in by the
>         boot loader. This property should only be used the used operating system
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> index 8f86084bf12e..4e8dee4aa90d 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> @@ -100,7 +100,6 @@ properties:
>         - description: Whether the IPA clock is enabled (if valid)
>   
>     qcom,smem-state-names:
> -    $ref: /schemas/types.yaml#/definitions/string-array
>       description: The names of the state bits used for SMP2P output
>       items:
>         - const: ipa-clock-enabled-valid
> diff --git a/Documentation/devicetree/bindings/nvmem/nvmem-consumer.yaml b/Documentation/devicetree/bindings/nvmem/nvmem-consumer.yaml
> index d5d7f113bade..828e4a1ece41 100644
> --- a/Documentation/devicetree/bindings/nvmem/nvmem-consumer.yaml
> +++ b/Documentation/devicetree/bindings/nvmem/nvmem-consumer.yaml
> @@ -23,12 +23,10 @@ properties:
>         List of phandle to the nvmem data cells.
>   
>     nvmem-names:
> -    $ref: /schemas/types.yaml#/definitions/string-array
>       description:
>         Names for the each nvmem provider.
>   
>     nvmem-cell-names:
> -    $ref: /schemas/types.yaml#/definitions/string-array
>       description:
>         Names for each nvmem-cells specified.
>   
> diff --git a/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml b/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml
> index 1a1159097a2a..73400bc6e91d 100644
> --- a/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml
> +++ b/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml
> @@ -93,7 +93,7 @@ properties:
>   # The following are the optional properties:
>   
>     memory-region:
> -    $ref: /schemas/types.yaml#/definitions/phandle
> +    maxItems: 1
>       description: |
>         phandle to the reserved memory node to be associated
>         with the remoteproc device. The reserved memory node
> diff --git a/Documentation/devicetree/bindings/sound/ak4642.yaml b/Documentation/devicetree/bindings/sound/ak4642.yaml
> index 6cd213be2266..1e2caa29790e 100644
> --- a/Documentation/devicetree/bindings/sound/ak4642.yaml
> +++ b/Documentation/devicetree/bindings/sound/ak4642.yaml
> @@ -29,11 +29,9 @@ properties:
>   
>     clock-frequency:
>       description: common clock binding; frequency of MCKO
> -    $ref: /schemas/types.yaml#/definitions/uint32
>   
>     clock-output-names:
>       description: common clock name
> -    $ref: /schemas/types.yaml#/definitions/string
>   
>   required:
>     - compatible
> diff --git a/Documentation/devicetree/bindings/sound/google,cros-ec-codec.yaml b/Documentation/devicetree/bindings/sound/google,cros-ec-codec.yaml
> index acfb9db021dc..77adbebed824 100644
> --- a/Documentation/devicetree/bindings/sound/google,cros-ec-codec.yaml
> +++ b/Documentation/devicetree/bindings/sound/google,cros-ec-codec.yaml
> @@ -32,7 +32,7 @@ properties:
>             The last one integer is the length of the shared memory.
>   
>     memory-region:
> -    $ref: '/schemas/types.yaml#/definitions/phandle'
> +    maxItems: 1
>       description: |
>         Shared memory region to EC.  A "shared-dma-pool".
>         See ../reserved-memory/reserved-memory.txt for details.
> diff --git a/Documentation/devicetree/bindings/sound/renesas,rsnd.yaml b/Documentation/devicetree/bindings/sound/renesas,rsnd.yaml
> index 2e1046513603..e494a0416748 100644
> --- a/Documentation/devicetree/bindings/sound/renesas,rsnd.yaml
> +++ b/Documentation/devicetree/bindings/sound/renesas,rsnd.yaml
> @@ -78,7 +78,6 @@ properties:
>   
>     clock-frequency:
>       description: for audio_clkout0/1/2/3
> -    $ref: /schemas/types.yaml#/definitions/uint32-array
>   
>     clkout-lr-asynchronous:
>       description: audio_clkoutn is asynchronizes with lr-clock.
> diff --git a/Documentation/devicetree/bindings/thermal/qcom-spmi-adc-tm5.yaml b/Documentation/devicetree/bindings/thermal/qcom-spmi-adc-tm5.yaml
> index 95a728f4d333..3ea8c0c1f45f 100644
> --- a/Documentation/devicetree/bindings/thermal/qcom-spmi-adc-tm5.yaml
> +++ b/Documentation/devicetree/bindings/thermal/qcom-spmi-adc-tm5.yaml
> @@ -59,7 +59,6 @@ patternProperties:
>   
>       properties:
>         reg:
> -        $ref: /schemas/types.yaml#/definitions/uint32
>           description: Specify the sensor channel. There are 8 channels in PMIC5's ADC TM
>           minimum: 0
>           maximum: 7
> diff --git a/Documentation/devicetree/bindings/usb/usb.yaml b/Documentation/devicetree/bindings/usb/usb.yaml
> index 78491e66ed24..939f217b8c7b 100644
> --- a/Documentation/devicetree/bindings/usb/usb.yaml
> +++ b/Documentation/devicetree/bindings/usb/usb.yaml
> @@ -16,7 +16,6 @@ properties:
>       pattern: "^usb(@.*)?"
>   
>     phys:
> -    $ref: /schemas/types.yaml#/definitions/phandle-array
>       description:
>         List of all the USB PHYs on this HCD
>   
> 

