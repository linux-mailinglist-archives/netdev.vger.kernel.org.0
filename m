Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340B168D6A1
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 13:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbjBGM01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 07:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjBGM0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 07:26:22 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2181D37B40
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 04:26:18 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id m14so13341478wrg.13
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 04:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5xYnHX1Erl5u5KfXsFsM2CCOcYE1hgAFey0pHbtrlGw=;
        b=a0bYF8vFZ81omWoSjjcDJcOsQPx0IJKXO2MNRiT9l9onGXaGU/wJv/i2K99OGIqcp7
         ihdwgekxx34k/NvtSiaofvZjKIRkq1Gr46OJM4n4ysLojX6AZ2xR1xvSjnBut7H/2Mm5
         8fi1YvW7KVgOJ1rXKQn7mg4bC89gcex54BUyX418qwHJ7IdMfDUxIXyFJ1oW3XbTbubd
         /ieHDCdsL1zjj0I/unn0HAHeDghr6unOEfRIAlgeJ2dj8xHT/gk42owOCUPeMedXbbyz
         j+AivNuy9YL3wEAIJ2NKTETQpyVQuPor+n9so2GzpBypaEyYTWGpIOrft7HAPnHDPCTc
         IggQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5xYnHX1Erl5u5KfXsFsM2CCOcYE1hgAFey0pHbtrlGw=;
        b=joPSmiaVGONmnGMqLHkrliS7fwr8qg6q+RyEjVnpijpE35Lv1/wz7YlWq5CrYWlFlX
         mV5+sQMOW5SLjoYishv+jaRqSE+NbWEaJIFdmLB7KuNdSxJHmJ7EHX37dmBQuBIQepsy
         ykwNpER1QUxuUZ9FJJkZUPe8oHVYjqxBzuykZ/ikR4Ei7hhCE/VkJOfJ3kNim6bajPzb
         PEFci2TvofcLA//nvGvt5HTuZzpoLk0RUoOClleASCyBR5zxn8h/cPdgx/J2hDa5tL5f
         ffp/+qN0e4Oo8R7LFSPSG/s1lXK2ufJQRgKRlFFozXV3qCjvad2tEugRRKsIhqbm5+Qi
         Lz1A==
X-Gm-Message-State: AO0yUKUX5fFr3jsob6MvMmkstO48MmBHSTH5fvl3t8+sT3uOiO9FndNI
        TyK/n9Oe0UjOzb9u8TJVtYofiA==
X-Google-Smtp-Source: AK7set88Lxl1qHumI/CfBw3/LLuxkMuEJHa+tXasBGB44CpUVlsBGzjZqivjRlNLNjNxDs0SM2+K5w==
X-Received: by 2002:adf:efcc:0:b0:2c3:e07d:46cc with SMTP id i12-20020adfefcc000000b002c3e07d46ccmr2519530wrp.41.1675772776749;
        Tue, 07 Feb 2023 04:26:16 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id i14-20020a0560001ace00b002bfb8f829eesm11816006wry.71.2023.02.07.04.26.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 04:26:16 -0800 (PST)
Message-ID: <cd2f7933-6f51-5100-f7c1-cd9900e796e5@linaro.org>
Date:   Tue, 7 Feb 2023 13:26:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: Aw: Re: [PATCH] dt-bindings: mt76: add active-low property to led
Content-Language: en-US
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20230207102501.11418-1-linux@fw-web.de>
 <fe3673d9-b921-c445-0f5f-a6bc824e8582@linaro.org>
 <trinity-808b2619-4325-4d03-b2f5-1a7bc27d42ea-1675771928390@3c-app-gmx-bap02>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <trinity-808b2619-4325-4d03-b2f5-1a7bc27d42ea-1675771928390@3c-app-gmx-bap02>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/02/2023 13:12, Frank Wunderlich wrote:
>> Gesendet: Dienstag, 07. Februar 2023 um 11:40 Uhr
>> Von: "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>
>> On 07/02/2023 11:25, Frank Wunderlich wrote:
>>> From: Frank Wunderlich <frank-w@public-files.de>
>>>
>>> LEDs can be in low-active mode, so add dt property for it.
>>>
>>> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
>>> ---
>>>  .../devicetree/bindings/net/wireless/mediatek,mt76.yaml      | 5 +++++
>>>  1 file changed, 5 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
>>> index f0c78f994491..212508672979 100644
>>> --- a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
>>> +++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
>>> @@ -112,6 +112,11 @@ properties:
>>>      $ref: /schemas/leds/common.yaml#
>>>      additionalProperties: false
>>>      properties:
>>> +      led-active-low:
>>> +        description:
>>> +          LED is enabled with ground signal.
>>
>> What does it mean? You set voltage of regulator to 0? Or you set GPIO as
>> 0? If the latter, it's not the property of LED...
> 
> basicly it is a gpio-led mapped into the mt76 driver, but not passing gpio itself in this property (like gpio-led does).
> This gpio is set to 0 signal (gnd) to let the led go on ;) so imho it is a led-property, but below the wifi-node as
> the trigger comes from mt76 hardware, not an external (soc) gpio controller.
> 
> mt76 driver supports it already like i post change here:
> 

If the driver supports it already and it was never documented, please
state it. Your commit says you add a new property.

Best regards,
Krzysztof

