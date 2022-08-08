Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199B058C9DB
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 15:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243216AbiHHN4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 09:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237479AbiHHN4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 09:56:15 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCA2D113;
        Mon,  8 Aug 2022 06:56:12 -0700 (PDT)
Received: from fraeml703-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4M1d5j361Yz6H74W;
        Mon,  8 Aug 2022 21:56:09 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Mon, 8 Aug 2022 15:56:09 +0200
Received: from localhost (10.122.247.231) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 8 Aug
 2022 14:56:09 +0100
Date:   Mon, 8 Aug 2022 14:56:08 +0100
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
        "Tim Harvey" <tharvey@gateworks.com>,
        Robert Jones <rjones@gateworks.com>,
        "Lee Jones" <lee@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Sebastian Reichel <sre@kernel.org>,
        "Liam Girdwood" <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "Ricardo Rivera-Matos" <r-rivera-matos@ti.com>,
        <linux-hwmon@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-leds@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 5/5] dt-bindings: Drop Dan Murphy
Message-ID: <20220808145608.00002bf8@huawei.com>
In-Reply-To: <20220808104712.54315-6-krzysztof.kozlowski@linaro.org>
References: <20220808104712.54315-1-krzysztof.kozlowski@linaro.org>
        <20220808104712.54315-6-krzysztof.kozlowski@linaro.org>
Organization: Huawei Technologies R&D (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.122.247.231]
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
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

On Mon,  8 Aug 2022 13:47:12 +0300
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:

> Emails to Dan Murphy bounce ("550 Invalid recipient <dmurphy@ti.com>
> (#5.1.1)").
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  Documentation/devicetree/bindings/iio/adc/ti,ads124s08.yaml     | 2 +-
>  .../devicetree/bindings/leds/leds-class-multicolor.yaml         | 2 +-
>  Documentation/devicetree/bindings/leds/leds-lp50xx.yaml         | 2 +-
>  Documentation/devicetree/bindings/net/ti,dp83822.yaml           | 2 +-
>  Documentation/devicetree/bindings/net/ti,dp83867.yaml           | 2 +-
>  Documentation/devicetree/bindings/net/ti,dp83869.yaml           | 2 +-
>  Documentation/devicetree/bindings/power/supply/bq2515x.yaml     | 1 -
>  Documentation/devicetree/bindings/power/supply/bq25980.yaml     | 1 -
>  Documentation/devicetree/bindings/sound/tas2562.yaml            | 2 +-
>  Documentation/devicetree/bindings/sound/tlv320adcx140.yaml      | 2 +-
>  10 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/iio/adc/ti,ads124s08.yaml b/Documentation/devicetree/bindings/iio/adc/ti,ads124s08.yaml
> index 9f5e96439c01..8f50f0f719df 100644
> --- a/Documentation/devicetree/bindings/iio/adc/ti,ads124s08.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/ti,ads124s08.yaml
> @@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  title: Texas Instruments' ads124s08 and ads124s06 ADC chip
>  
>  maintainers:
> -  - Dan Murphy <dmurphy@ti.com>
> +  - Jonathan Cameron <jic23@kernel.org>
For this one,
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

(I'm fine with using my kernel.org address for bindings)

