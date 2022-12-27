Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B516567F1
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 08:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiL0Hsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 02:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiL0Hse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 02:48:34 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132D2E1A;
        Mon, 26 Dec 2022 23:48:29 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id B471C24E2B2;
        Tue, 27 Dec 2022 15:48:21 +0800 (CST)
Received: from EXMBX173.cuchost.com (172.16.6.93) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 27 Dec
 2022 15:48:21 +0800
Received: from [192.168.120.49] (171.223.208.138) by EXMBX173.cuchost.com
 (172.16.6.93) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 27 Dec
 2022 15:48:20 +0800
Message-ID: <25fce6e7-604e-6c07-3ff1-b65a5115a491@starfivetech.com>
Date:   Tue, 27 Dec 2022 15:48:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 2/9] dt-bindings: net: snps,dwmac: Update the maxitems
 number of resets and reset-names
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
References: <20221216070632.11444-1-yanhong.wang@starfivetech.com>
 <20221216070632.11444-3-yanhong.wang@starfivetech.com>
 <040b56b1-c65c-34c3-e4a1-5cae4428d1d2@linaro.org>
 <7f4339df-6616-120f-f16a-cd38a2b6ea1d@starfivetech.com>
 <1a696768-45ef-0144-07f3-d356af9659e5@linaro.org>
Content-Language: en-US
From:   yanhong wang <yanhong.wang@starfivetech.com>
In-Reply-To: <1a696768-45ef-0144-07f3-d356af9659e5@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX173.cuchost.com
 (172.16.6.93)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/12/20 17:21, Krzysztof Kozlowski wrote:
> On 20/12/2022 07:48, yanhong wang wrote:
> 
>>>> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>>> index e26c3e76ebb7..7870228b4cd3 100644
>>>> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>>> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>>> @@ -133,12 +133,19 @@ properties:
>>>>          - ptp_ref
>>>>  
>>>>    resets:
>>>> -    maxItems: 1
>>>> -    description:
>>>> -      MAC Reset signal.
>>>> +    minItems: 1
>>>> +    maxItems: 3
>>>> +    additionalItems: true
>>>> +    items:
>>>> +      - description: MAC Reset signal
>>>>  
>>>>    reset-names:
>>>> -    const: stmmaceth
>>>> +    minItems: 1
>>>> +    maxItems: 3
>>>> +    additionalItems: true
>>>> +    contains:
>>>> +      enum:
>>>> +        - stmmaceth
>>>
>>> No, this is highly unspecific and you know affect all the schemas using
>>> snps,dwmac.yaml. Both lists must be specific - for your device and for
>>> others.
>>>
>> 
>> I have tried to define the resets in "starfive,jh71x0-dwmac.yaml", but it can not over-write the maxItems limit in "snps,dwmac.yaml",therefore, it will report error "reset-names: ['stmmaceth', 'ahb'] is too long"  running "make dt_binding_check". Do you have any suggestions to deal with this situation?
> 
> The solution is not to affect all schemas with allowing anything as reset.
> 
> If you need more items for your case, you can change snps,dwmac.yaml and
> add constraints in allOf:if:then: allowing it only for your compatible.
> There are plenty of examples how this is done, e.g.:
> 
> https://elixir.bootlin.com/linux/v5.19-rc6/source/Documentation/devicetree/bindings/clock/samsung,exynos7-clock.yaml#L57
> 

Thanks. Refer to the definition in the example and update the definition as follows:

snps,dwmac.yaml[Partial Content]:

properties:
  resets:
    maxItems: 1
    description:
      MAC Reset signal.

  reset-names:
    const: stmmaceth

allOf:
  - if:
      properties:
        compatible:
          contains:
            const: starfive,jh7110-dwmac

    then:
      properties:
        resets:
          minItems: 2
          maxItems: 2
        reset-names:
          items:
            - const: stmmaceth
            - const: ahb
      required:
        - resets
        - reset-names


starfive,jh7110-dwmac.yaml[Partial Content]:

properties:
  resets:
    items:
      - description: MAC Reset signal.
      - description: AHB Reset signal.

  reset-names:
    items:
      - const: stmmaceth
      - const: ahb

allOf:
  - $ref: snps,dwmac.yaml#

It will also report error "reset-names: ['stmmaceth', 'ahb'] is too long"  running "make dt_binding_check" with 'starfive,jh7110-dwmac.yaml'. Do you have any better suggestions to solve this problem?

>> 
>>> Best regards,
>>> Krzysztof
>>>
> 
> Best regards,
> Krzysztof
> 
