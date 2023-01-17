Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1374366D7D7
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 09:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236116AbjAQIPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 03:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236082AbjAQIO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 03:14:56 -0500
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF7327D52;
        Tue, 17 Jan 2023 00:14:54 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 37D8D24E226;
        Tue, 17 Jan 2023 16:14:53 +0800 (CST)
Received: from EXMBX073.cuchost.com (172.16.6.83) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 17 Jan
 2023 16:14:53 +0800
Received: from [192.168.120.49] (171.223.208.138) by EXMBX073.cuchost.com
 (172.16.6.83) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 17 Jan
 2023 16:14:52 +0800
Message-ID: <bb1f3c71-e1a7-cd2d-b728-6e9027dae150@starfivetech.com>
Date:   Tue, 17 Jan 2023 16:14:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 2/7] dt-bindings: net: snps,dwmac: Update the maxitems
 number of resets and reset-names
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
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
 <8ee5f6ef-80cb-2e0f-6681-598ccc697291@linaro.org>
From:   yanhong wang <yanhong.wang@starfivetech.com>
In-Reply-To: <8ee5f6ef-80cb-2e0f-6681-598ccc697291@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX073.cuchost.com
 (172.16.6.83)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/1/17 15:46, Krzysztof Kozlowski wrote:
> On 17/01/2023 07:52, yanhong wang wrote:
>> 
>> 
>> On 2023/1/6 20:44, Krzysztof Kozlowski wrote:
>>> On 06/01/2023 03:59, Yanhong Wang wrote:
>>>> Some boards(such as StarFive VisionFive v2) require more than one value
>>>> which defined by resets property, so the original definition can not
>>>> meet the requirements. In order to adapt to different requirements,
>>>> adjust the maxitems number definition.
>>>>
>>>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>>>> ---
>>>>  .../devicetree/bindings/net/snps,dwmac.yaml   | 36 ++++++++++++++-----
>>>>  1 file changed, 28 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>>> index e26c3e76ebb7..f7693e8c8d6d 100644
>>>> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>>> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>>> @@ -132,14 +132,6 @@ properties:
>>>>          - pclk
>>>>          - ptp_ref
>>>>  
>>>> -  resets:
>>>> -    maxItems: 1
>>>> -    description:
>>>> -      MAC Reset signal.
>>>> -
>>>> -  reset-names:
>>>> -    const: stmmaceth
>>>> -
>>>>    power-domains:
>>>>      maxItems: 1
>>>>  
>>>> @@ -463,6 +455,34 @@ allOf:
>>>>              Enables the TSO feature otherwise it will be managed by
>>>>              MAC HW capability register.
>>>>  
>>>> +  - if:
>>>> +      properties:
>>>> +        compatible:
>>>> +          contains:
>>>> +            const: starfive,jh7110-dwmac
>>>> +
>>>
>>> Looking at your next binding patch, this seems a bit clearer. First of
>>> all, this patch on itself has little sense. It's not usable on its own,
>>> because you need the next one.
>>>
>>> Probably the snps,dwmac should be just split into common parts used by
>>> devices. It makes code much less readable and unnecessary complicated to
>>> support in one schema both devices and re-usability.
>>>
>>> Otherwise I propose to make the resets/reset-names just like clocks are
>>> made: define here wide constraints and update all other users of this
>>> binding to explicitly restrict resets.
>>>
>>>
>> 
>> Thanks, refer to the definition of clocks. If it is defined as follows, is it OK?
>> 
>> properties:
>>   resets:
>>     minItems: 1
>>     maxItems: 3
>>     additionalItems: true
> 
> Drop
> 
>>     items:
>>       - description: MAC Reset signal.
> 
> Drop both
> 
>> 
>>   reset-names:
>>     minItems: 1
>>     maxItems: 3
>>     additionalItems: true
> 
> Drop
> 
>>     contains:
>>       enum:
>>         - stmmaceth
> 
> Drop all
> 
>> 
>> 
>> allOf:
>>   - if:
>>       properties:
>>         compatible:
>>           contains:
>>             const: starfive,jh7110-dwmac
>>     then:
>>       properties:
>>         resets:
>>           minItems: 2
>>           maxItems: 2
>>         reset-names:
>>           items:
>>             - const: stmmaceth
>>             - const: ahb
>>       required:
>>         - resets
>>         - reset-names  
>>     else:
>>       properties:
>>         resets:
>>           maxItems: 1
>>           description:
>>             MAC Reset signal.
>> 
>>         reset-names:
>>           const: stmmaceth
>> 
>> Do you have any other better suggestions?
> 
> More or less like this but the allOf should not be in snps,dwmac schema
> but in individual schemas. The snps,dwmac is growing unmaintainable...
> 

Thanks, it is defined as follows, is it right?

properties:
  resets:
    minItems: 1
    maxItems: 3
    additionalItems: true

  reset-names:
    minItems: 1
    maxItems: 3
    additionalItems: true


> Best regards,
> Krzysztof
> 
