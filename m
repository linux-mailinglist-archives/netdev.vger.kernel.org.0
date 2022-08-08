Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B912758CB01
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 17:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238473AbiHHPFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 11:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbiHHPFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 11:05:23 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9D0E9F;
        Mon,  8 Aug 2022 08:05:21 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 278F4JoD126550;
        Mon, 8 Aug 2022 10:04:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1659971059;
        bh=NdjYuYrRgfFqkXrI7faf1aVXflieuCOWZNGCJMFOx94=;
        h=Date:Subject:To:References:From:In-Reply-To;
        b=lmySqfLgt6rnGnRx3ZDw9pTF65QwTb++SXCsh9IxxF9MAQRftqsa/WREeGJ17tqpA
         k/sw5R/YUoMY4tJ7HDRVaR9WOH2DGsonOxC62b5Vp7Cpp88RkVhE3Y2KkkcdnHE1Hm
         UYW69jWcmfDjbrWDx4ioxp0dues0NZ0ZN0Pbdg8I=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 278F4Jd1015602
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 8 Aug 2022 10:04:19 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 8
 Aug 2022 10:04:18 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 8 Aug 2022 10:04:18 -0500
Received: from [10.250.34.173] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 278F4HdP032491;
        Mon, 8 Aug 2022 10:04:17 -0500
Message-ID: <6ae15e00-36a4-09a8-112e-553ed8c5f4da@ti.com>
Date:   Mon, 8 Aug 2022 10:04:17 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5/5] dt-bindings: Drop Dan Murphy
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
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
        Mark Brown <broonie@kernel.org>, <linux-hwmon@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-iio@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-leds@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <alsa-devel@alsa-project.org>
References: <20220808104712.54315-1-krzysztof.kozlowski@linaro.org>
 <20220808104712.54315-6-krzysztof.kozlowski@linaro.org>
 <43b3c497-97fd-29aa-a07b-bcd6413802c4@linaro.org>
From:   Andrew Davis <afd@ti.com>
In-Reply-To: <43b3c497-97fd-29aa-a07b-bcd6413802c4@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/8/22 6:08 AM, Krzysztof Kozlowski wrote:
> On 08/08/2022 13:47, Krzysztof Kozlowski wrote:
>> Emails to Dan Murphy bounce ("550 Invalid recipient <dmurphy@ti.com>
>> (#5.1.1)").
> 
> 
> (...)
> 
>>   description: |
>> diff --git a/Documentation/devicetree/bindings/power/supply/bq25980.yaml b/Documentation/devicetree/bindings/power/supply/bq25980.yaml
>> index 4883527ab5c7..509a0667b04e 100644
>> --- a/Documentation/devicetree/bindings/power/supply/bq25980.yaml
>> +++ b/Documentation/devicetree/bindings/power/supply/bq25980.yaml
>> @@ -8,7 +8,6 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>>   title: TI BQ25980 Flash Charger
>>   
>>   maintainers:
>> -  - Dan Murphy <dmurphy@ti.com>
>>     - Ricardo Rivera-Matos <r-rivera-matos@ti.com>
> 
> Ricardo's also bounces... Does it mean TI is not interested in
> maintaining mainline support for its drivers?
> 

TI is still interested in maintaining support here. But as we know folks
come and go, so giving specific emails might not be the best option.
Doesn't look like the schema here allows free-form strings, but if it did
I'd recommend the TI E2E Power-Management support forum[0] added. Any
questions on Linux/DT for these parts posted there would land on my desk
just the same, or to whomever is assigned in the future with maintaining
these drivers.

Either way, I have several of these parts and can support these. Feel free
to replace Dan's email with my email if that works better.

Andrew

[0] https://e2e.ti.com/support/power-management-group/power-management/f/power-management-forum

> Best regards,
> Krzysztof
