Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85200651D2B
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 10:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbiLTJV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 04:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbiLTJVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 04:21:54 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303B22650
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 01:21:53 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id f20so11802101lja.4
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 01:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DazyWikdI/OzsaaGF39wdaaOlC0XReiy+hFbZZu2Q1I=;
        b=Hjx00EFpYwP45LwbOziknhwz2zKD+sbAMQ86G061nKhGmmw4qE9jTARKz07mPQht/T
         1k3StqDnfBGg121+F/oghnfJ9rq45ATS7T/HkmOYgKWBy4gkWf1knqsSRRSXgICSBb64
         LOnH0EU+gXHUGouF9PyD26nOG17gg7A6Ree5Xf6VXHvU3FD28v/R/8J3IMmUXbgrPHuZ
         PwNTg1Ah8mxrVtEKBQ+uyoqNGDocJ5EoyqxLd3xjEQiPYtsUzWa5ZBVVxPSI8FTARB/J
         UQc7cBaoU0zJ6qX97ehqfCmzi4XGWcNRqqIsqHj3v6iy/p7nocOFGOsMiylkAUKKB76R
         KD3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DazyWikdI/OzsaaGF39wdaaOlC0XReiy+hFbZZu2Q1I=;
        b=cFwApOQrhj2krmXC4LKElulhV6eUkLmIY9fCeuTTFhSlgSnSW+wTooZSSgcvjWReZ9
         KYBK0wMZCAV16s+s4KSUc0KmECxO6Q6Gs8bwiZ6+3UZACEvTq03Cl8g1J9llAfata9MY
         SAEdlSJ4NGDznhltC5ryVUYqpf0ajy4Wo8Cw9vsBxVTqyfz+LrQZTJx9RptKij1yF9pN
         hHJvWVXKjH4ApqxUOwcOyWqcmJguKHOiIUc0D7X+cN+N+hIg+vMriC5vMTB50hUqxAmn
         Oy3Akoo8XPbcX5Tz/H7zwNQ7g2Fhn6s0ZMgFxFat1Jqc+Emw2EtMwrO/ntjjz9XpEbj3
         RV2w==
X-Gm-Message-State: ANoB5pmWm+4ADjiUGi+uBAG8NMGWQGvBPnN5D0opr3ZQ5KbngaHtPhRj
        tEJI3GP4CmfpPVHaLV4Adpt23Q==
X-Google-Smtp-Source: AA0mqf7cINmxUQTVHIA51W+eyOnDgUmlNBK3MC35Vz0emZ06VI2+JlnPdeEHi9nVd6I2/sVZYIoByA==
X-Received: by 2002:a2e:3205:0:b0:27b:490b:8478 with SMTP id y5-20020a2e3205000000b0027b490b8478mr10500411ljy.36.1671528111530;
        Tue, 20 Dec 2022 01:21:51 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id s8-20020a05651c048800b00279d73cdf83sm943007ljc.128.2022.12.20.01.21.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 01:21:51 -0800 (PST)
Message-ID: <1a696768-45ef-0144-07f3-d356af9659e5@linaro.org>
Date:   Tue, 20 Dec 2022 10:21:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 2/9] dt-bindings: net: snps,dwmac: Update the maxitems
 number of resets and reset-names
Content-Language: en-US
To:     yanhong wang <yanhong.wang@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
References: <20221216070632.11444-1-yanhong.wang@starfivetech.com>
 <20221216070632.11444-3-yanhong.wang@starfivetech.com>
 <040b56b1-c65c-34c3-e4a1-5cae4428d1d2@linaro.org>
 <7f4339df-6616-120f-f16a-cd38a2b6ea1d@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <7f4339df-6616-120f-f16a-cd38a2b6ea1d@starfivetech.com>
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

On 20/12/2022 07:48, yanhong wang wrote:

>>> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> index e26c3e76ebb7..7870228b4cd3 100644
>>> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> @@ -133,12 +133,19 @@ properties:
>>>          - ptp_ref
>>>  
>>>    resets:
>>> -    maxItems: 1
>>> -    description:
>>> -      MAC Reset signal.
>>> +    minItems: 1
>>> +    maxItems: 3
>>> +    additionalItems: true
>>> +    items:
>>> +      - description: MAC Reset signal
>>>  
>>>    reset-names:
>>> -    const: stmmaceth
>>> +    minItems: 1
>>> +    maxItems: 3
>>> +    additionalItems: true
>>> +    contains:
>>> +      enum:
>>> +        - stmmaceth
>>
>> No, this is highly unspecific and you know affect all the schemas using
>> snps,dwmac.yaml. Both lists must be specific - for your device and for
>> others.
>>
> 
> I have tried to define the resets in "starfive,jh71x0-dwmac.yaml", but it can not over-write the maxItems limit in "snps,dwmac.yaml",therefore, it will report error "reset-names: ['stmmaceth', 'ahb'] is too long"  running "make dt_binding_check". Do you have any suggestions to deal with this situation?

The solution is not to affect all schemas with allowing anything as reset.

If you need more items for your case, you can change snps,dwmac.yaml and
add constraints in allOf:if:then: allowing it only for your compatible.
There are plenty of examples how this is done, e.g.:

https://elixir.bootlin.com/linux/v5.19-rc6/source/Documentation/devicetree/bindings/clock/samsung,exynos7-clock.yaml#L57

> 
>> Best regards,
>> Krzysztof
>>

Best regards,
Krzysztof

