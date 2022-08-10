Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7500C58EA51
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 12:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbiHJKLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 06:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiHJKLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 06:11:33 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F37B6FA02;
        Wed, 10 Aug 2022 03:11:31 -0700 (PDT)
Received: from fraeml706-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4M2lyN2W4vz67xMg;
        Wed, 10 Aug 2022 18:08:44 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Wed, 10 Aug 2022 12:11:28 +0200
Received: from localhost (10.202.226.42) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 10 Aug
 2022 11:11:28 +0100
Date:   Wed, 10 Aug 2022 11:11:27 +0100
From:   Jonathan Cameron <Jonathan.Cameron@huawei.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
CC:     Michael Hennerich <Michael.Hennerich@analog.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pavel Machek <pavel@ucw.cz>,
        "Tim Harvey" <tharvey@gateworks.com>, Lee Jones <lee@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Sebastian Reichel" <sre@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Andrew Davis <afd@ti.com>,
        <linux-hwmon@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-leds@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH v2 5/5] dt-bindings: Drop Dan Murphy and Ricardo
 Rivera-Matos
Message-ID: <20220810111127.00003b83@huawei.com>
In-Reply-To: <20220809162752.10186-6-krzysztof.kozlowski@linaro.org>
References: <20220809162752.10186-1-krzysztof.kozlowski@linaro.org>
        <20220809162752.10186-6-krzysztof.kozlowski@linaro.org>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.42]
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  9 Aug 2022 19:27:52 +0300
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:

> Emails to Dan Murphy and Ricardo Rivera-Matos bounce ("550 Invalid
> recipient").  Andrew Davis agreed to take over the bindings.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> ---
> 
> Changes since v1:
> 1. Add Andrew Davis instead.
> 2. Not adding accumulated ack due to change above.
> ---
>  Documentation/devicetree/bindings/iio/adc/ti,ads124s08.yaml    | 2 +-
>  .../devicetree/bindings/leds/leds-class-multicolor.yaml        | 2 +-
>  Documentation/devicetree/bindings/leds/leds-lp50xx.yaml        | 2 +-
>  Documentation/devicetree/bindings/net/ti,dp83822.yaml          | 2 +-
>  Documentation/devicetree/bindings/net/ti,dp83867.yaml          | 2 +-
>  Documentation/devicetree/bindings/net/ti,dp83869.yaml          | 2 +-
>  Documentation/devicetree/bindings/power/supply/bq2515x.yaml    | 3 +--
>  Documentation/devicetree/bindings/power/supply/bq256xx.yaml    | 2 +-
>  Documentation/devicetree/bindings/power/supply/bq25980.yaml    | 3 +--
>  Documentation/devicetree/bindings/sound/tas2562.yaml           | 2 +-
>  Documentation/devicetree/bindings/sound/tlv320adcx140.yaml     | 2 +-
>  11 files changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/iio/adc/ti,ads124s08.yaml b/Documentation/devicetree/bindings/iio/adc/ti,ads124s08.yaml
> index 9f5e96439c01..2e6abc9d746a 100644
> --- a/Documentation/devicetree/bindings/iio/adc/ti,ads124s08.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/ti,ads124s08.yaml
> @@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  title: Texas Instruments' ads124s08 and ads124s06 ADC chip
>  
>  maintainers:
> -  - Dan Murphy <dmurphy@ti.com>
> +  - Andrew Davis <afd@ti.com>
For this one.

Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

>  
>  properties:
>    compatible:
> diff --git a/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml b/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml
> index 12693483231f..31840e33dcf5 100644
> --- a/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml
> +++ b/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml
> @@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  title: Common properties for the multicolor LED class.
>  
>  maintainers:
> -  - Dan Murphy <dmurphy@ti.com>
> +  - Andrew Davis <afd@ti.com>
>  
>  description: |
>    Bindings for multi color LEDs show how to describe current outputs of
> diff --git a/Documentation/devicetree/bindings/leds/leds-lp50xx.yaml b/Documentation/devicetree/bindings/leds/leds-lp50xx.yaml
> index e0b658f07973..63da380748bf 100644
> --- a/Documentation/devicetree/bindings/leds/leds-lp50xx.yaml
> +++ b/Documentation/devicetree/bindings/leds/leds-lp50xx.yaml
> @@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  title: LED driver for LP50XX RGB LED from Texas Instruments.
>  
>  maintainers:
> -  - Dan Murphy <dmurphy@ti.com>
> +  - Andrew Davis <afd@ti.com>
>  
>  description: |
>    The LP50XX is multi-channel, I2C RGB LED Drivers that can group RGB LEDs into
> diff --git a/Documentation/devicetree/bindings/net/ti,dp83822.yaml b/Documentation/devicetree/bindings/net/ti,dp83822.yaml
> index 75e8712e903a..f2489a9c852f 100644
> --- a/Documentation/devicetree/bindings/net/ti,dp83822.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,dp83822.yaml
> @@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
>  title: TI DP83822 ethernet PHY
>  
>  maintainers:
> -  - Dan Murphy <dmurphy@ti.com>
> +  - Andrew Davis <afd@ti.com>
>  
>  description: |
>    The DP83822 is a low-power, single-port, 10/100 Mbps Ethernet PHY. It
> diff --git a/Documentation/devicetree/bindings/net/ti,dp83867.yaml b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
> index 76ff08a477ba..b8c0e4b5b494 100644
> --- a/Documentation/devicetree/bindings/net/ti,dp83867.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
> @@ -11,7 +11,7 @@ allOf:
>    - $ref: "ethernet-controller.yaml#"
>  
>  maintainers:
> -  - Dan Murphy <dmurphy@ti.com>
> +  - Andrew Davis <afd@ti.com>
>  
>  description: |
>    The DP83867 device is a robust, low power, fully featured Physical Layer
> diff --git a/Documentation/devicetree/bindings/net/ti,dp83869.yaml b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
> index 1b780dce61ab..b04ff0014a59 100644
> --- a/Documentation/devicetree/bindings/net/ti,dp83869.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
> @@ -11,7 +11,7 @@ allOf:
>    - $ref: "ethernet-phy.yaml#"
>  
>  maintainers:
> -  - Dan Murphy <dmurphy@ti.com>
> +  - Andrew Davis <afd@ti.com>
>  
>  description: |
>    The DP83869HM device is a robust, fully-featured Gigabit (PHY) transceiver
> diff --git a/Documentation/devicetree/bindings/power/supply/bq2515x.yaml b/Documentation/devicetree/bindings/power/supply/bq2515x.yaml
> index 27db38577822..1a1b240034ef 100644
> --- a/Documentation/devicetree/bindings/power/supply/bq2515x.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/bq2515x.yaml
> @@ -8,8 +8,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  title: TI bq2515x 500-mA Linear charger family
>  
>  maintainers:
> -  - Dan Murphy <dmurphy@ti.com>
> -  - Ricardo Rivera-Matos <r-rivera-matos@ti.com>
> +  - Andrew Davis <afd@ti.com>
>  
>  description: |
>    The BQ2515x family is a highly integrated battery charge management IC that
> diff --git a/Documentation/devicetree/bindings/power/supply/bq256xx.yaml b/Documentation/devicetree/bindings/power/supply/bq256xx.yaml
> index 91abe5733c41..82f382a7ffb3 100644
> --- a/Documentation/devicetree/bindings/power/supply/bq256xx.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/bq256xx.yaml
> @@ -8,7 +8,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  title: TI bq256xx Switch Mode Buck Charger
>  
>  maintainers:
> -  - Ricardo Rivera-Matos <r-rivera-matos@ti.com>
> +  - Andrew Davis <afd@ti.com>
>  
>  description: |
>    The bq256xx devices are a family of highly-integrated battery charge
> diff --git a/Documentation/devicetree/bindings/power/supply/bq25980.yaml b/Documentation/devicetree/bindings/power/supply/bq25980.yaml
> index 4883527ab5c7..b687b8bcd705 100644
> --- a/Documentation/devicetree/bindings/power/supply/bq25980.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/bq25980.yaml
> @@ -8,8 +8,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  title: TI BQ25980 Flash Charger
>  
>  maintainers:
> -  - Dan Murphy <dmurphy@ti.com>
> -  - Ricardo Rivera-Matos <r-rivera-matos@ti.com>
> +  - Andrew Davis <afd@ti.com>
>  
>  description: |
>    The BQ25980, BQ25975, and BQ25960 are a series of flash chargers intended
> diff --git a/Documentation/devicetree/bindings/sound/tas2562.yaml b/Documentation/devicetree/bindings/sound/tas2562.yaml
> index 5f7dd5d6cbca..30f6b029ac08 100644
> --- a/Documentation/devicetree/bindings/sound/tas2562.yaml
> +++ b/Documentation/devicetree/bindings/sound/tas2562.yaml
> @@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
>  title: Texas Instruments TAS2562 Smart PA
>  
>  maintainers:
> -  - Dan Murphy <dmurphy@ti.com>
> +  - Andrew Davis <afd@ti.com>
>  
>  description: |
>    The TAS2562 is a mono, digital input Class-D audio amplifier optimized for
> diff --git a/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml b/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
> index bc2fb1a80ed7..ee698614862e 100644
> --- a/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
> +++ b/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
> @@ -8,7 +8,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  title: Texas Instruments TLV320ADCX140 Quad Channel Analog-to-Digital Converter
>  
>  maintainers:
> -  - Dan Murphy <dmurphy@ti.com>
> +  - Andrew Davis <afd@ti.com>
>  
>  description: |
>    The TLV320ADCX140 are multichannel (4-ch analog recording or 8-ch digital

