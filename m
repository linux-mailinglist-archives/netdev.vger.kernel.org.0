Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0895758C9F1
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 15:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243369AbiHHN5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 09:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243230AbiHHN5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 09:57:44 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2EE7DEC6;
        Mon,  8 Aug 2022 06:57:42 -0700 (PDT)
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4M1d7S15Zxz6H76x;
        Mon,  8 Aug 2022 21:57:40 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 8 Aug 2022 15:57:40 +0200
Received: from localhost (10.122.247.231) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 8 Aug
 2022 14:57:39 +0100
Date:   Mon, 8 Aug 2022 14:57:38 +0100
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
Subject: Re: [PATCH 3/5] dt-bindings: Drop Beniamin Bia and Stefan Popa
Message-ID: <20220808145738.000040f1@huawei.com>
In-Reply-To: <20220808104712.54315-4-krzysztof.kozlowski@linaro.org>
References: <20220808104712.54315-1-krzysztof.kozlowski@linaro.org>
        <20220808104712.54315-4-krzysztof.kozlowski@linaro.org>
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

On Mon,  8 Aug 2022 13:47:10 +0300
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:

> Emails to Beniamin Bia and Stefan Popa bounce ("550 5.1.10
> RESOLVER.ADR.RecipientNotFound; Recipient not found by SMTP address
> lookup").
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Fine by me.

Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  Documentation/devicetree/bindings/hwmon/adi,adm1177.yaml       | 1 -
>  Documentation/devicetree/bindings/iio/adc/adi,ad7091r5.yaml    | 2 +-
>  Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml      | 3 +--
>  .../devicetree/bindings/iio/amplifiers/adi,hmc425a.yaml        | 1 -
>  4 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/hwmon/adi,adm1177.yaml b/Documentation/devicetree/bindings/hwmon/adi,adm1177.yaml
> index 154bee851139..d794deb08bb7 100644
> --- a/Documentation/devicetree/bindings/hwmon/adi,adm1177.yaml
> +++ b/Documentation/devicetree/bindings/hwmon/adi,adm1177.yaml
> @@ -8,7 +8,6 @@ title: Analog Devices ADM1177 Hot Swap Controller and Digital Power Monitor
>  
>  maintainers:
>    - Michael Hennerich <michael.hennerich@analog.com>
> -  - Beniamin Bia <beniamin.bia@analog.com>
>  
>  description: |
>    Analog Devices ADM1177 Hot Swap Controller and Digital Power Monitor
> diff --git a/Documentation/devicetree/bindings/iio/adc/adi,ad7091r5.yaml b/Documentation/devicetree/bindings/iio/adc/adi,ad7091r5.yaml
> index 31ffa275f5fa..b97559f23b3a 100644
> --- a/Documentation/devicetree/bindings/iio/adc/adi,ad7091r5.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/adi,ad7091r5.yaml
> @@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  title: Analog Devices AD7091R5 4-Channel 12-Bit ADC
>  
>  maintainers:
> -  - Beniamin Bia <beniamin.bia@analog.com>
> +  - Michael Hennerich <michael.hennerich@analog.com>
>  
>  description: |
>    Analog Devices AD7091R5 4-Channel 12-Bit ADC
> diff --git a/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml b/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml
> index 73775174cf57..516fc24d3346 100644
> --- a/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml
> @@ -7,8 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  title: Analog Devices AD7606 Simultaneous Sampling ADC
>  
>  maintainers:
> -  - Beniamin Bia <beniamin.bia@analog.com>
> -  - Stefan Popa <stefan.popa@analog.com>
> +  - Michael Hennerich <michael.hennerich@analog.com>
>  
>  description: |
>    Analog Devices AD7606 Simultaneous Sampling ADC
> diff --git a/Documentation/devicetree/bindings/iio/amplifiers/adi,hmc425a.yaml b/Documentation/devicetree/bindings/iio/amplifiers/adi,hmc425a.yaml
> index a557761d8016..9fda56fa49c3 100644
> --- a/Documentation/devicetree/bindings/iio/amplifiers/adi,hmc425a.yaml
> +++ b/Documentation/devicetree/bindings/iio/amplifiers/adi,hmc425a.yaml
> @@ -8,7 +8,6 @@ title: HMC425A 6-bit Digital Step Attenuator
>  
>  maintainers:
>    - Michael Hennerich <michael.hennerich@analog.com>
> -  - Beniamin Bia <beniamin.bia@analog.com>
>  
>  description: |
>    Digital Step Attenuator IIO device with gpio interface.

