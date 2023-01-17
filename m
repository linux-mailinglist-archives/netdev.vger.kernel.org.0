Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D01666D724
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 08:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235953AbjAQHqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 02:46:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235943AbjAQHqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 02:46:11 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2232423DA9
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 23:46:10 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d2so9518141wrp.8
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 23:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DMmc7/6yXt4mypmxVkgQDFhHLoHU+0OuLMviLqWVx+A=;
        b=JSyDCVbIbjBQ1xD2ArsijWppzNSE86iMsxJQ+4itnbir88y3d9yVVcRwLsdC7oQ+cg
         UrPyDarZRi4gwrrFCg2blJJKaTO7lYAl2CLauthE9EjaLCz1ufELFDIuCRMYuvWWUe47
         YLuySGp5G1jQiObp2sqR9c9NO/c7iLnkDbecmzXBO7Ag3Ay53v0bTcfJ7Y3BaXNJDoFI
         3O/ZTWfGflEe1U446bWlySQ9XqmlefUQG4jfIPI9UEvravTyZsNu/vczsAaALblx4gq4
         Ak1yaNfXziEuP3wB49E5afCS7aqst6+CBDIo1t4Q0iOK9LfYPhtA1tqcKx+G+S/+tVcN
         9jVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DMmc7/6yXt4mypmxVkgQDFhHLoHU+0OuLMviLqWVx+A=;
        b=4XeChVQPUHtSscoD3xg9yIqBG8Nbh2PApfZlmysFS90hbkiuuHGSqU6r0boEGYTLMV
         B3OH49BYZvq1qLincH5o9gaytU7t/suSbKGivUlxsxSBrVHCWIoW8lEw87wMInvyQs2p
         VR8twtDSvah+uoxhtdcVhwlray2cNV9PCr6VjVdESmQq0jPxGoJwccMtgrLABwFrWXeE
         vSNN53I1S0vhDrQoT8ftJiMYF5Lqrho+Y936N6W6ZGnxGkfd+3edpkzJkQATgq8GcbNy
         z0wZ+YRM2pzzumLkL8ED25Kj89dKM5e+2aPeVCCtL1o4C944I02hVoDaWVialDk44nWs
         rgLQ==
X-Gm-Message-State: AFqh2kpN+mmvP9B1iuF2KXjeo45OVhaeJrFJxyWTWXpESCrwVqhoP2Si
        EEstlRGdpBDenuWLYPle8puWPA==
X-Google-Smtp-Source: AMrXdXtUxakW05hWNg2POhjXdlv3VgtuswvL3Udt4m7t6k4qlXSnBGFVf8dJ2ejUwjfcGDH9YjSn+A==
X-Received: by 2002:adf:fa88:0:b0:2bd:d85f:55cc with SMTP id h8-20020adffa88000000b002bdd85f55ccmr1960711wrr.21.1673941568684;
        Mon, 16 Jan 2023 23:46:08 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id i6-20020adfe486000000b002423dc3b1a9sm27630444wrm.52.2023.01.16.23.46.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 23:46:08 -0800 (PST)
Message-ID: <8ee5f6ef-80cb-2e0f-6681-598ccc697291@linaro.org>
Date:   Tue, 17 Jan 2023 08:46:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 2/7] dt-bindings: net: snps,dwmac: Update the maxitems
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
References: <20230106030001.1952-1-yanhong.wang@starfivetech.com>
 <20230106030001.1952-3-yanhong.wang@starfivetech.com>
 <2328562d-59a2-f60e-b17b-6cf16392e01f@linaro.org>
 <84e783a6-0aea-a6ba-13a0-fb29c66cc81a@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <84e783a6-0aea-a6ba-13a0-fb29c66cc81a@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/01/2023 07:52, yanhong wang wrote:
> 
> 
> On 2023/1/6 20:44, Krzysztof Kozlowski wrote:
>> On 06/01/2023 03:59, Yanhong Wang wrote:
>>> Some boards(such as StarFive VisionFive v2) require more than one value
>>> which defined by resets property, so the original definition can not
>>> meet the requirements. In order to adapt to different requirements,
>>> adjust the maxitems number definition.
>>>
>>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>>> ---
>>>  .../devicetree/bindings/net/snps,dwmac.yaml   | 36 ++++++++++++++-----
>>>  1 file changed, 28 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> index e26c3e76ebb7..f7693e8c8d6d 100644
>>> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> @@ -132,14 +132,6 @@ properties:
>>>          - pclk
>>>          - ptp_ref
>>>  
>>> -  resets:
>>> -    maxItems: 1
>>> -    description:
>>> -      MAC Reset signal.
>>> -
>>> -  reset-names:
>>> -    const: stmmaceth
>>> -
>>>    power-domains:
>>>      maxItems: 1
>>>  
>>> @@ -463,6 +455,34 @@ allOf:
>>>              Enables the TSO feature otherwise it will be managed by
>>>              MAC HW capability register.
>>>  
>>> +  - if:
>>> +      properties:
>>> +        compatible:
>>> +          contains:
>>> +            const: starfive,jh7110-dwmac
>>> +
>>
>> Looking at your next binding patch, this seems a bit clearer. First of
>> all, this patch on itself has little sense. It's not usable on its own,
>> because you need the next one.
>>
>> Probably the snps,dwmac should be just split into common parts used by
>> devices. It makes code much less readable and unnecessary complicated to
>> support in one schema both devices and re-usability.
>>
>> Otherwise I propose to make the resets/reset-names just like clocks are
>> made: define here wide constraints and update all other users of this
>> binding to explicitly restrict resets.
>>
>>
> 
> Thanks, refer to the definition of clocks. If it is defined as follows, is it OK?
> 
> properties:
>   resets:
>     minItems: 1
>     maxItems: 3
>     additionalItems: true

Drop

>     items:
>       - description: MAC Reset signal.

Drop both

> 
>   reset-names:
>     minItems: 1
>     maxItems: 3
>     additionalItems: true

Drop

>     contains:
>       enum:
>         - stmmaceth

Drop all

> 
> 
> allOf:
>   - if:
>       properties:
>         compatible:
>           contains:
>             const: starfive,jh7110-dwmac
>     then:
>       properties:
>         resets:
>           minItems: 2
>           maxItems: 2
>         reset-names:
>           items:
>             - const: stmmaceth
>             - const: ahb
>       required:
>         - resets
>         - reset-names  
>     else:
>       properties:
>         resets:
>           maxItems: 1
>           description:
>             MAC Reset signal.
> 
>         reset-names:
>           const: stmmaceth
> 
> Do you have any other better suggestions?

More or less like this but the allOf should not be in snps,dwmac schema
but in individual schemas. The snps,dwmac is growing unmaintainable...

Best regards,
Krzysztof

