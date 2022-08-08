Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A8758CA08
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 15:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243505AbiHHN7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 09:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243247AbiHHN7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 09:59:30 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35635E0FF;
        Mon,  8 Aug 2022 06:59:28 -0700 (PDT)
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4M1d4N2Sxyz67Y4H;
        Mon,  8 Aug 2022 21:55:00 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 8 Aug 2022 15:59:25 +0200
Received: from localhost (10.122.247.231) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 8 Aug
 2022 14:59:24 +0100
Date:   Mon, 8 Aug 2022 14:59:24 +0100
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
Subject: Re: [PATCH 1/5] dt-bindings: iio: Drop Joachim Eastwood
Message-ID: <20220808145924.00005e14@huawei.com>
In-Reply-To: <20220808104712.54315-2-krzysztof.kozlowski@linaro.org>
References: <20220808104712.54315-1-krzysztof.kozlowski@linaro.org>
        <20220808104712.54315-2-krzysztof.kozlowski@linaro.org>
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

On Mon,  8 Aug 2022 13:47:08 +0300
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:

> Emails to Joachim Eastwood bounce ("552 5.2.2 The email account that you
> tried to reach is over quota and inactive.").
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  Documentation/devicetree/bindings/iio/accel/fsl,mma7455.yaml   | 1 -
>  Documentation/devicetree/bindings/iio/adc/nxp,lpc1850-adc.yaml | 2 +-
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/iio/accel/fsl,mma7455.yaml b/Documentation/devicetree/bindings/iio/accel/fsl,mma7455.yaml
> index 7c8f8bdc2333..9c7c66feeffc 100644
> --- a/Documentation/devicetree/bindings/iio/accel/fsl,mma7455.yaml
> +++ b/Documentation/devicetree/bindings/iio/accel/fsl,mma7455.yaml
> @@ -7,7 +7,6 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  title: Freescale MMA7455 and MMA7456 three axis accelerometers
>  
>  maintainers:
> -  - Joachim Eastwood <manabian@gmail.com>
>    - Jonathan Cameron <jic23@kernel.org>
>  
>  description:
> diff --git a/Documentation/devicetree/bindings/iio/adc/nxp,lpc1850-adc.yaml b/Documentation/devicetree/bindings/iio/adc/nxp,lpc1850-adc.yaml
> index 6404fb73f8ed..43abb300fa3d 100644
> --- a/Documentation/devicetree/bindings/iio/adc/nxp,lpc1850-adc.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/nxp,lpc1850-adc.yaml
> @@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  title: NXP LPC1850 ADC bindings
>  
>  maintainers:
> -  - Joachim Eastwood <manabian@gmail.com>
> +  - Jonathan Cameron <jic23@kernel.org>
>  
>  description:
>    Supports the ADC found on the LPC1850 SoC.

lore
