Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9BD453903B
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 14:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343874AbiEaMBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 08:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238225AbiEaMBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 08:01:34 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D613490CC3
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 05:01:32 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id jx22so26060958ejb.12
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 05:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9m1AKxIKpBOrpgKNCQswOv5BEEg74xfUnH4p95pE0Iw=;
        b=SHfiVo2JGBy9urqWEOop6MF6w+4wlZeWdDY1LgpUjcIay15tWjPFosBYJQwwg6FjwW
         xQpNqYVSmiFUKjNQ+ewkjgVRf0YMH6+vCFp82TkN8BquafHSLrvXdRRvYJHm0bSB27R1
         MB1egy6sIg3M0zDBk0bZAMJEZrHAs3QtI5sEILgzF2mAEzN3+7GRIshE2KCBwQ3FZDyM
         iLUwa7yDozDzkcI5+tKK775xzimUwB/wzVFpHjjrfmutvareSYgZC8Byyx1tLVbV0Gg/
         b0SmzfkPT455ZBljp9vtbuQpaz71AUPHBVSqNCQYV3zvUMXlSWi2wNGyCQl59kiTB8m1
         A6LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9m1AKxIKpBOrpgKNCQswOv5BEEg74xfUnH4p95pE0Iw=;
        b=T4252Uohmq3dgLzB/ojmBydd5xRaoiZ3okwLcTzr0oyOI0hDWFYVacWm6qjA0wOWB6
         PjsAOx2PitCcuCPUbV9vuaChumlrl1eg+cQyzN5Mj2FpwrxHf5j49fEca15V0Sg7SdYF
         oru5RzVzwyHhp8cVzAezk6xZd/kismTAmHl3dcsVFPJlgTSeQCkLDq2uoejWbh26tSi/
         s0N1HXQATfpLEjVODyLEOMDemLB0kaRfu2xPK5kuANMOQ5z5M44tfkWVXVnqnRpjgAku
         byJ5+iCumXYCQoj4Mr8b4JjzFd56zwqiKHhgtcq/1l/aHG/C6GmitKQVgDRLnzvCU6ln
         3qUQ==
X-Gm-Message-State: AOAM533/Ikqq5wfcJTdgMFVUlNxicJ7TDg5TUnS9a2Ft9W0jA+Pe59Zc
        Ovm0OQoeZDlblO+KJvg2us964A==
X-Google-Smtp-Source: ABdhPJxHgVT1VxJPKc4NOyeIRvx19A/V04OMD+Gv/i2sdGRSIMB/6647wknXUWrWohNzzTuXeyBrBA==
X-Received: by 2002:a17:906:6a24:b0:6fe:fa6b:4386 with SMTP id qw36-20020a1709066a2400b006fefa6b4386mr34917333ejc.351.1653998491476;
        Tue, 31 May 2022 05:01:31 -0700 (PDT)
Received: from [192.168.0.179] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id g16-20020a50d0d0000000b0042dc9aafbfbsm4910687edf.39.2022.05.31.05.01.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 05:01:31 -0700 (PDT)
Message-ID: <ec9991e3-71b0-3671-8975-292287714f95@linaro.org>
Date:   Tue, 31 May 2022 14:01:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 1/2] dt-bindings: net: Add ICSSG Ethernet Driver
 bindings
Content-Language: en-US
To:     Puranjay Mohan <p-mohan@ti.com>, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, nm@ti.com, ssantosh@kernel.org,
        s-anna@ti.com, linux-arm-kernel@lists.infradead.org,
        rogerq@kernel.org, grygorii.strashko@ti.com, vigneshr@ti.com,
        kishon@ti.com, robh+dt@kernel.org, afd@ti.com, andrew@lunn.ch
References: <20220531095108.21757-1-p-mohan@ti.com>
 <20220531095108.21757-2-p-mohan@ti.com>
 <4ccba38a-ccde-83cd-195b-77db7a64477c@linaro.org>
 <faff79c9-7e1e-a69b-f314-6c00dedf1722@ti.com>
 <a47f5d18-9ecc-a679-b407-799e4a15c6cf@linaro.org>
 <c13f79c9-ffca-d81d-8904-95c424dd19bc@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <c13f79c9-ffca-d81d-8904-95c424dd19bc@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/05/2022 13:59, Puranjay Mohan wrote:
> Hi Krzysztof,
> 
> On 31/05/22 17:18, Krzysztof Kozlowski wrote:
>> On 31/05/2022 13:27, Puranjay Mohan wrote:
>>>>> +examples:
>>>>> +  - |
>>>>> +
>>>>> +    /* Example k3-am654 base board SR2.0, dual-emac */
>>>>> +    pruss2_eth: pruss2_eth {
>>>>> +            compatible = "ti,am654-icssg-prueth";
>>>>
>>>> Again missed Rob's comment.
>>>
>>> One of Rob's comment was to make the indentation as 4 which I have done.
>>
>> I clearly do not see indentation of 4, but there is 8 instead.
> 
> I changed the indentation at the wrong place.
> 
>>
>> Let's count:
>> +    pruss2_eth: pruss2_eth {
> ^ here, it was 8 in v1 so, I changed it to 4
> 
>> +            compatible = "ti,am654-icssg-prueth";
>>      12345678^
>>
> 
> Compatible is the child of pruss2_eth, so, It should have 4+4 = 8?

Yes. Indentation of four means first block is indented with 4 spaces.
The next block 4+4. The next one 4+4+4.

Best regards,
Krzysztof
