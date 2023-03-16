Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C747B6BCC61
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 11:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjCPKTD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 16 Mar 2023 06:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjCPKS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 06:18:57 -0400
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172C8BCB9C;
        Thu, 16 Mar 2023 03:18:49 -0700 (PDT)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id D3AC224E3AD;
        Thu, 16 Mar 2023 18:18:47 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 16 Mar
 2023 18:18:47 +0800
Received: from [192.168.120.42] (171.223.208.138) by EXMBX162.cuchost.com
 (172.16.6.72) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 16 Mar
 2023 18:18:46 +0800
Message-ID: <ed8dbe90-ee1d-405a-5aa6-cbc16a0057ac@starfivetech.com>
Date:   Thu, 16 Mar 2023 18:18:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v7 4/6] dt-bindings: net: Add support StarFive dwmac
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
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        Tommaso Merciai <tomm.merciai@gmail.com>
References: <20230316043714.24279-1-samin.guo@starfivetech.com>
 <20230316043714.24279-5-samin.guo@starfivetech.com>
 <cfeec762-de75-f90f-7ba1-6c0bd8b70dff@linaro.org>
 <93a3b4bb-35a4-da7c-6816-21225b42f79b@starfivetech.com>
 <9038dba0-6f72-44a1-9f57-1c08b03b9c31@linaro.org>
 <d2bb7fa5-206f-2059-bde0-b65e1acc44de@starfivetech.com>
 <c716e535-7426-56da-ca6f-51c7d7d69bb3@linaro.org>
 <b7766151-cf21-a5b4-e0ef-7b070e9e5c33@starfivetech.com>
 <d2eda9a8-f532-d7f0-7ef3-b3b8e1a0a79f@linaro.org>
From:   Guo Samin <samin.guo@starfivetech.com>
In-Reply-To: <d2eda9a8-f532-d7f0-7ef3-b3b8e1a0a79f@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



-------- 原始信息 --------
Re: [PATCH v7 4/6] dt-bindings: net: Add support StarFive dwmac
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
to : Guo Samin <samin.guo@starfivetech.com>, linux-riscv@lists.infradead.org, netdev@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
data: 2023/3/16

> On 16/03/2023 09:28, Guo Samin wrote:
>>
>>
>> -------- 原始信息 --------
>> 主题: Re: [PATCH v7 4/6] dt-bindings: net: Add support StarFive dwmac
>> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>> 收件人: Guo Samin <samin.guo@starfivetech.com>, linux-riscv@lists.infradead.org, netdev@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
>> 日期: 2023/3/16
>>
>>> On 16/03/2023 09:15, Guo Samin wrote:
>>>>>>> interrupts: ???
>>>>>>>
>>>>>>
>>>>>> Hi Krzysztof, 
>>>>>>
>>>>>> snps,dwmac.yaml has defined the reg/interrupt/interrupt-names nodes,
>>>>>> and the JH7110 SoC is also applicable.
>>>>>> Maybe just add reg/interrupt/interrupt-names to the required ?
>>>>>
>>>>> You need to constrain them.
>>>>
>>>>
>>>> I see. I will add reg constraints in the next version, thanks.
>>>>
>>>> I have one more question, the interrupts/interrup-names of JH7110 SoC's gmac are exactly the same as snps,dwmac.yaml,
>>>> do these also need to be constrained?
>>>
>>> The interrupts on common binding are variable, so you need to constrain
>>> them - you have fixed number of them, right?
>>>
>>> Best regards,
>>> Krzysztof
>>>
>>
>> Yes, JH7110 fixed is 3 pcs. Thanks, I will constrain them.
> 
> Then just minItems: 3, maxItems: 3 here should be enough
> 
> Best regards,
> Krzysztof
> 

Hi Krzysztof,

Thank you for the suggestion. 
I'll change it like this in the next version, is right?


$ git diff
--- a/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
@@ -27,6 +27,9 @@ properties:
           - starfive,jh7110-dwmac
       - const: snps,dwmac-5.20
 
+  reg:
+    maxItems: 1
+
   clocks:
     items:
       - description: GMAC main clock
@@ -43,6 +46,14 @@ properties:
       - const: tx
       - const: gtx
 
+  interrupts:
+    minItems: 3
+    maxItems: 3
+
+  interrupt-names:
+    minItems: 3
+    maxItems: 3
+
   resets:
     items:
       - description: MAC Reset signal.
@@ -77,8 +88,11 @@ unevaluatedProperties: false
 
 required:
   - compatible
+  - reg
   - clocks
   - clock-names
+  - interrupts
+  - interrupt-names
   - resets
   - reset-names





Best regards,
Samin
