Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8072C24308C
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 23:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgHLVfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 17:35:05 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:53986 "EHLO
        asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgHLVfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 17:35:03 -0400
Received: from ravnborg.org (unknown [188.228.123.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk3.altibox.net (Postfix) with ESMTPS id DE6062002E;
        Wed, 12 Aug 2020 23:34:54 +0200 (CEST)
Date:   Wed, 12 Aug 2020 23:34:53 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-pm@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-spi@vger.kernel.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-i2c@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-input@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Whitespace clean-ups in schema files
Message-ID: <20200812213453.GA690477@ravnborg.org>
References: <20200812203618.2656699-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812203618.2656699-1-robh@kernel.org>
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=f+hm+t6M c=1 sm=1 tr=0
        a=S6zTFyMACwkrwXSdXUNehg==:117 a=S6zTFyMACwkrwXSdXUNehg==:17
        a=kj9zAlcOel0A:10 a=7gkXJVJtAAAA:8 a=S2FyQyr5uj24keYp2QUA:9
        a=CjuIK1q_8ugA:10 a=c0zojPR3vx4A:10 a=E9Po1WZjFZOl8hwRPBS3:22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob.

On Wed, Aug 12, 2020 at 02:36:18PM -0600, Rob Herring wrote:
> Clean-up incorrect indentation, extra spaces, long lines, and missing
> EOF newline in schema files. Most of the clean-ups are for list
> indentation which should always be 2 spaces more than the preceding
> keyword.
> 
> Found with yamllint (which I plan to integrate into the checks).

I have browsed through the patch - and there was only a few things
that jumped at me.

With these points considered:
Acked-by: Sam Ravnborg <sam@ravnborg.org>

I expect only some (few) of my points to actually results in any updates.

I look forward to have the lint functionality as part of the built-in
tools so we catch these things early.

	Sam

> diff --git a/Documentation/devicetree/bindings/arm/fsl.yaml b/Documentation/devicetree/bindings/arm/fsl.yaml
> index f63895c8ce2d..88814a2a14a5 100644
> --- a/Documentation/devicetree/bindings/arm/fsl.yaml
> +++ b/Documentation/devicetree/bindings/arm/fsl.yaml
> @@ -273,8 +273,8 @@ properties:
>                - fsl,imx6ull-14x14-evk     # i.MX6 UltraLiteLite 14x14 EVK Board
>                - kontron,imx6ull-n6411-som # Kontron N6411 SOM
>                - myir,imx6ull-mys-6ulx-eval # MYiR Tech iMX6ULL Evaluation Board
> -              - toradex,colibri-imx6ull-eval            # Colibri iMX6ULL Module on Colibri Evaluation Board
> -              - toradex,colibri-imx6ull-wifi-eval       # Colibri iMX6ULL Wi-Fi / Bluetooth Module on Colibri Evaluation Board
> +              - toradex,colibri-imx6ull-eval      # Colibri iMX6ULL Module on Colibri Eval Board
> +              - toradex,colibri-imx6ull-wifi-eval # Colibri iMX6ULL Wi-Fi / BT Module on Colibri Eval Board
>            - const: fsl,imx6ull

This change looks bad as it drops the alignment with the comments below.
See following patch chunck:

>
>        - description: Kontron N6411 S Board
> @@ -312,9 +312,12 @@ properties:
>                - toradex,colibri-imx7d                   # Colibri iMX7 Dual Module
>                - toradex,colibri-imx7d-aster             # Colibri iMX7 Dual Module on Aster Carrier Board
>                - toradex,colibri-imx7d-emmc              # Colibri iMX7 Dual 1GB (eMMC) Module
> -              - toradex,colibri-imx7d-emmc-aster        # Colibri iMX7 Dual 1GB (eMMC) Module on Aster Carrier Board
> -              - toradex,colibri-imx7d-emmc-eval-v3      # Colibri iMX7 Dual 1GB (eMMC) Module on Colibri Evaluation Board V3
> -              - toradex,colibri-imx7d-eval-v3           # Colibri iMX7 Dual Module on Colibri Evaluation Board V3
> +              - toradex,colibri-imx7d-emmc-aster        # Colibri iMX7 Dual 1GB (eMMC) Module on
> +                                                        #  Aster Carrier Board



> diff --git a/Documentation/devicetree/bindings/display/panel/ilitek,ili9322.yaml b/Documentation/devicetree/bindings/display/panel/ilitek,ili9322.yaml
> index 177d48c5bd97..e89c1ea62ffa 100644
> --- a/Documentation/devicetree/bindings/display/panel/ilitek,ili9322.yaml
> +++ b/Documentation/devicetree/bindings/display/panel/ilitek,ili9322.yaml
> @@ -25,8 +25,7 @@ properties:
>    compatible:
>      items:
>        - enum:
> -        - dlink,dir-685-panel
> -
> +          - dlink,dir-685-panel
>        - const: ilitek,ili9322
>
>    reset-gpios: true
> diff --git a/Documentation/devicetree/bindings/display/panel/ilitek,ili9881c.yaml b/Documentation/devicetree/bindings/display/panel/ilitek,ili9881c.yaml
> index a39332276bab..76a9068a85dd 100644
> --- a/Documentation/devicetree/bindings/display/panel/ilitek,ili9881c.yaml
> +++ b/Documentation/devicetree/bindings/display/panel/ilitek,ili9881c.yaml
> @@ -13,8 +13,7 @@ properties:
>    compatible:
>      items:
>        - enum:
> -        - bananapi,lhr050h41
> -
> +          - bananapi,lhr050h41
>        - const: ilitek,ili9881c
>

The extra lines is a simple way to indicate that here shall be added
more in the future. So I like the empty line.


> diff --git a/Documentation/devicetree/bindings/leds/backlight/qcom-wled.yaml b/Documentation/devicetree/bindings/leds/backlight/qcom-wled.yaml
> index 32e0896c6bc1..47938e372987 100644
> --- a/Documentation/devicetree/bindings/leds/backlight/qcom-wled.yaml
> +++ b/Documentation/devicetree/bindings/leds/backlight/qcom-wled.yaml
> @@ -79,7 +79,8 @@ properties:
>      description: |
>        kHz; switching frequency.
>      $ref: /schemas/types.yaml#/definitions/uint32
> -    enum: [ 600, 640, 685, 738, 800, 872, 960, 1066, 1200, 1371, 1600, 1920, 2400, 3200, 4800, 9600 ]
> +    enum: [ 600, 640, 685, 738, 800, 872, 960, 1066, 1200, 1371, 1600, 1920,
> +            2400, 3200, 4800, 9600 ]
>
>    qcom,ovp:
>      description: |

In the modern world we are living in now line length of 100 chars are
OK. checkpatch and coding_style is updated to reflected this.

> diff --git a/Documentation/devicetree/bindings/spi/mikrotik,rb4xx-spi.yaml b/Documentation/devicetree/bindings/spi/mikrotik,rb4xx-spi.yaml
> index 4ddb42a4ae05..9102feae90a2 100644
> --- a/Documentation/devicetree/bindings/spi/mikrotik,rb4xx-spi.yaml
> +++ b/Documentation/devicetree/bindings/spi/mikrotik,rb4xx-spi.yaml
> @@ -33,4 +33,5 @@ examples:
>          reg = <0x1f000000 0x10>;
>      };
>
> -...
> \ No newline at end of file
> +...
> +

Added one line too much?

 diff --git a/Documentation/devicetree/bindings/spi/spi-mux.yaml b/Documentation/devicetree/bindings/spi/spi-mux.yaml
> index 0ae692dc28b5..3d3fed63409b 100644
> --- a/Documentation/devicetree/bindings/spi/spi-mux.yaml
> +++ b/Documentation/devicetree/bindings/spi/spi-mux.yaml
> @@ -43,47 +43,47 @@ properties:
>      maxItems: 1
>
>  required:
> -   - compatible
> -   - reg
> -   - spi-max-frequency
> -   - mux-controls
> +  - compatible
> +  - reg
> +  - spi-max-frequency
> +  - mux-controls
>
>  examples:
> -   - |
> -     #include <dt-bindings/gpio/gpio.h>
> -     mux: mux-controller {
> -       compatible = "gpio-mux";
> -       #mux-control-cells = <0>;
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +    mux: mux-controller {
> +        compatible = "gpio-mux";
> +        #mux-control-cells = <0>;
>
> -       mux-gpios = <&gpio0 3 GPIO_ACTIVE_HIGH>;
> -     };
> +        mux-gpios = <&gpio0 3 GPIO_ACTIVE_HIGH>;
> +    };

Example is updated to use 4-space indent. I like.

But many other examples are left untouched.

So I wonder if updating all examples to the same indent should
be left for another mega-patch?

> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
> index f3d847832fdc..2baee2c817c1 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
> @@ -993,7 +993,8 @@ patternProperties:
>    "^sst,.*":
>      description: Silicon Storage Technology, Inc.
>    "^sstar,.*":
> -    description: Xiamen Xingchen(SigmaStar) Technology Co., Ltd. (formerly part of MStar Semiconductor, Inc.)
> +    description: Xiamen Xingchen(SigmaStar) Technology Co., Ltd.
> +      (formerly part of MStar Semiconductor, Inc.)
>    "^st,.*":
>      description: STMicroelectronics
>    "^starry,.*":

Did you check that they are all in alphabetical order?
I would be suprised if this is the only issue in this file.


