Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE6A58C743
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 13:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242677AbiHHLIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 07:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241944AbiHHLIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 07:08:09 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0846B0B
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 04:08:07 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id l10so4832933lje.7
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 04:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=G5McPA5IZBMFjJ0FWkBGoduD3K8bZspnlviNAqde1yc=;
        b=U/8GdIPAOfjfBSkPjG5qZxEpHYx+/y1PqJjkW7q9XPKi+rNH9/dxiBi1yihCy+h293
         iNwxkcW7qy7LPeMGxSs5rHpkJQq5EwzuHdr+LCPHKjOeQ83rg8iKzV3zZarNThEsWH0w
         CmC/o7Zp4FC1+BWdTxPiNp8JkSwzUoXh7tQIU56sUavV8iNgWPijx/uuF0xZaPPcxocb
         /f7wX+tz8FQi5OrTmy4E+tsl100B6B6g7NsVYajrm5YYsymY0zrRboDLbi4cvxNVYAbc
         0EoeM/cP8He8woq/BuYMI7uO1xTTlUTwupdPNkoU6aX4x7Uw/vfB35BO1qPupE6jKKH6
         esHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=G5McPA5IZBMFjJ0FWkBGoduD3K8bZspnlviNAqde1yc=;
        b=3yiMtkAjDvDFN8GiWLt5IUHcsqCKKjBBp6xrOBAkUBRduFmYQPkoUPzh+HL/8Y6aiF
         zckK9E7blk2NRYg/qgDj9A2+KhSZ+NQ/Ardz1y63zec1SJaGgrGUi+PeH1917wuh/9EZ
         JVsy5s8nsj++N1dTuzQmBvjzbhiQcbYLo5XIGSkhTyCqsXd5aUF5gPefYMk9RE+1MAmH
         iWa24Go9KIODmPbb66ggyV92/VBOtfwKnFo1JUlvyBWYktyPFUFJkrug/AH0EMc9kayv
         1b5aPDjKxLAxj6z6/vck5+8ilL1YnQ9CudarqhAd5e5Bv4QH4JwIQ7nBPch++1U79PPw
         hR+Q==
X-Gm-Message-State: ACgBeo2xhwspfAlS3NLka2yOi3moM557+T1GcphofGBFWkd97Ik9p4nK
        AWYMPRBzsxBeZ61Y3Kc+sP8RzA==
X-Google-Smtp-Source: AA6agR5I5A6dxgwMS+V5R6U4to3TDtNl7lNnpi0SFDGcuvZCIrUri2LyMgMT9eOhaBiYlWL8+eDong==
X-Received: by 2002:a2e:2ac1:0:b0:25e:4b39:e3cb with SMTP id q184-20020a2e2ac1000000b0025e4b39e3cbmr5854240ljq.458.1659956886352;
        Mon, 08 Aug 2022 04:08:06 -0700 (PDT)
Received: from [192.168.1.39] ([83.146.140.105])
        by smtp.gmail.com with ESMTPSA id t16-20020a2e9d10000000b0025e6a598019sm1338801lji.131.2022.08.08.04.08.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 04:08:05 -0700 (PDT)
Message-ID: <43b3c497-97fd-29aa-a07b-bcd6413802c4@linaro.org>
Date:   Mon, 8 Aug 2022 14:08:03 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 5/5] dt-bindings: Drop Dan Murphy
Content-Language: en-US
To:     Michael Hennerich <Michael.Hennerich@analog.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pavel Machek <pavel@ucw.cz>,
        Tim Harvey <tharvey@gateworks.com>,
        Robert Jones <rjones@gateworks.com>,
        Lee Jones <lee@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Reichel <sre@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Ricardo Rivera-Matos <r-rivera-matos@ti.com>,
        linux-hwmon@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-leds@vger.kernel.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org
References: <20220808104712.54315-1-krzysztof.kozlowski@linaro.org>
 <20220808104712.54315-6-krzysztof.kozlowski@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220808104712.54315-6-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/08/2022 13:47, Krzysztof Kozlowski wrote:
> Emails to Dan Murphy bounce ("550 Invalid recipient <dmurphy@ti.com>
> (#5.1.1)").


(...)

>  description: |
> diff --git a/Documentation/devicetree/bindings/power/supply/bq25980.yaml b/Documentation/devicetree/bindings/power/supply/bq25980.yaml
> index 4883527ab5c7..509a0667b04e 100644
> --- a/Documentation/devicetree/bindings/power/supply/bq25980.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/bq25980.yaml
> @@ -8,7 +8,6 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  title: TI BQ25980 Flash Charger
>  
>  maintainers:
> -  - Dan Murphy <dmurphy@ti.com>
>    - Ricardo Rivera-Matos <r-rivera-matos@ti.com>

Ricardo's also bounces... Does it mean TI is not interested in
maintaining mainline support for its drivers?

Best regards,
Krzysztof
