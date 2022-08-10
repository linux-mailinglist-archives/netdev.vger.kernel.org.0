Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17BE258EADF
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 13:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiHJLBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 07:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbiHJLBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 07:01:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCDA6BD6F;
        Wed, 10 Aug 2022 04:01:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 985E3B81B5B;
        Wed, 10 Aug 2022 11:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE0CC433D6;
        Wed, 10 Aug 2022 11:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660129279;
        bh=6x6su5oHn4WjBSWBtUvgxfhKdMjczpssjP15rky0Ucc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KMY2BViRwxO+LS6lTNRSgjQQ0lxdAhWdIrWx87oKITfqA8c3unrpEe7yDrvdit6aP
         LAJh1oADLa4m6DCanxivY6NzKxMsGIuHST3i3MzzmjjgMVlog/k0ZPOuyoDeIpgEXx
         UZ8VIDuSks9qlXahIc5IeJ5OVKApkhOtMLYZl/glbvW2lmz4Q7fkrhkSzpM5OdrLs1
         vOKs3vJGcttXSz343CpoH1x0KvOn8EnpiFTNHcpw5q4kgTWmAzyFstxLwmo0z9ctHY
         DkBAqyv5xIbwGRFXuxNQ2reCX6YRtl9sY824SJ4PaxHM3m8ht49/FEZms4NYXFEnvJ
         Xg4XqbbvEYd+w==
Date:   Wed, 10 Aug 2022 12:01:10 +0100
From:   Lee Jones <lee@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Michael Hennerich <Michael.Hennerich@analog.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pavel Machek <pavel@ucw.cz>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Reichel <sre@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Andrew Davis <afd@ti.com>,
        linux-hwmon@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-leds@vger.kernel.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v2 4/5] dt-bindings: Drop Robert Jones
Message-ID: <YvOP9qr2CR9n1FCe@google.com>
References: <20220809162752.10186-1-krzysztof.kozlowski@linaro.org>
 <20220809162752.10186-5-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220809162752.10186-5-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 09 Aug 2022, Krzysztof Kozlowski wrote:

> Emails to Robert Jones bounce ("550 5.2.1 The email account that you
> tried to reach is disabled").
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> ---
> 
> For maintainers entry see:
> https://lore.kernel.org/all/20220808111113.71890-1-krzysztof.kozlowski@linaro.org/
> ---
>  Documentation/devicetree/bindings/iio/imu/nxp,fxos8700.yaml | 2 +-
>  Documentation/devicetree/bindings/mfd/gateworks-gsc.yaml    | 1 -

Any reason to submit these as one patch?

>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/iio/imu/nxp,fxos8700.yaml b/Documentation/devicetree/bindings/iio/imu/nxp,fxos8700.yaml
> index 479e7065d4eb..0203b83b8587 100644
> --- a/Documentation/devicetree/bindings/iio/imu/nxp,fxos8700.yaml
> +++ b/Documentation/devicetree/bindings/iio/imu/nxp,fxos8700.yaml
> @@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  title: Freescale FXOS8700 Inertial Measurement Unit
>  
>  maintainers:
> -  - Robert Jones <rjones@gateworks.com>
> +  - Jonathan Cameron <jic23@kernel.org>
>  
>  description: |
>    Accelerometer and magnetometer combo device with an i2c and SPI interface.
> diff --git a/Documentation/devicetree/bindings/mfd/gateworks-gsc.yaml b/Documentation/devicetree/bindings/mfd/gateworks-gsc.yaml
> index 5a1e8d21f7a0..5e0fe3ebe1d2 100644
> --- a/Documentation/devicetree/bindings/mfd/gateworks-gsc.yaml
> +++ b/Documentation/devicetree/bindings/mfd/gateworks-gsc.yaml
> @@ -19,7 +19,6 @@ description: |
>  
>  maintainers:
>    - Tim Harvey <tharvey@gateworks.com>
> -  - Robert Jones <rjones@gateworks.com>
>  
>  properties:
>    $nodename:

-- 
Lee Jones [李琼斯]
