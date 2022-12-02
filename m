Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C782C6400DC
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 08:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbiLBHHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 02:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiLBHHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 02:07:30 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E9DBF905;
        Thu,  1 Dec 2022 23:07:24 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id 61E6F24DEED;
        Fri,  2 Dec 2022 15:07:22 +0800 (CST)
Received: from EXMBX173.cuchost.com (172.16.6.93) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 2 Dec
 2022 15:07:22 +0800
Received: from [192.168.120.49] (171.223.208.138) by EXMBX173.cuchost.com
 (172.16.6.93) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 2 Dec
 2022 15:07:21 +0800
Message-ID: <87fa4a7e-8bd1-0be2-083d-c87aabb05af6@starfivetech.com>
Date:   Fri, 2 Dec 2022 15:07:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 3/7] dt-bindings: net: Add bindings for StarFive dwmac
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
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
 <20221201090242.2381-4-yanhong.wang@starfivetech.com>
 <36565cc1-3c48-0fa8-f98b-414a7ac8f5bf@linaro.org>
From:   yanhong wang <yanhong.wang@starfivetech.com>
In-Reply-To: <36565cc1-3c48-0fa8-f98b-414a7ac8f5bf@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS064.cuchost.com (172.16.6.24) To EXMBX173.cuchost.com
 (172.16.6.93)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/12/2 0:21, Krzysztof Kozlowski wrote:
> On 01/12/2022 10:02, Yanhong Wang wrote:
>> Add bindings for the StarFive dwmac module on the StarFive RISC-V SoCs.
> 
> Subject: drop second, redundant "bindings".
> 

I'll fix the title in the next version.

>> 
>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>> ---
>>  .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
>>  .../bindings/net/starfive,dwmac-plat.yaml     | 106 ++++++++++++++++++
>>  MAINTAINERS                                   |   5 +
>>  3 files changed, 112 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml
>> 
>> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> index d8779d3de3d6..13c5928d7170 100644
>> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> @@ -33,6 +33,7 @@ select:
>>            - snps,dwmac-5.20
>>            - snps,dwxgmac
>>            - snps,dwxgmac-2.10
>> +          - starfive,dwmac
>>  
>>            # Deprecated
>>            - st,spear600-gmac
>> diff --git a/Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml b/Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml
>> new file mode 100644
>> index 000000000000..561cf2a713ab
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml
> 
> Filename should base on compatible.
> 

Will update file name.

>> @@ -0,0 +1,106 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +# Copyright (C) 2022 StarFive Technology Co., Ltd.
>> +%YAML 1.2
>> +---
>> +$id: "http://devicetree.org/schemas/net/dwmac-starfive.yaml#"
> 
> Does not look like you tested the bindings. Please run `make
> dt_binding_check` (see
> Documentation/devicetree/bindings/writing-schema.rst for instructions).
> 
>> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> 
> Drop quotes from both lines.
> 

Will remove quotes.

>> +
>> +title: StarFive DWMAC glue layer
>> +
>> +maintainers:
>> +  - Yanhong Wang <yanhong.wang@starfivetech.com>
>> +
>> +select:
>> +  properties:
>> +    compatible:
>> +      contains:
>> +        enum:
>> +          - starfive,dwmac
>> +  required:
>> +    - compatible
>> +
>> +allOf:
>> +  - $ref: "snps,dwmac.yaml#"
> 
> Drop quotes.
> 

Will remove quotes.

>> +
>> +properties:
>> +  compatible:
>> +    oneOf:
> 
> Drop oneOf. You do not have more cases here.
> 

Will remove oneOf.

>> +      - items:
>> +          - enum:
>> +               - starfive,dwmac
> 
> Wrong indentation.... kind of expected since you did not test the bindings.
> 

Will fix.

>> +          - const: snps,dwmac-5.20
>> +
>> +  clocks:
>> +    items:
>> +      - description: GMAC main clock
>> +      - description: GMAC AHB clock
>> +      - description: PTP clock
>> +      - description: TX clock
>> +      - description: GTXC clock
>> +      - description: GTX clock
>> +
>> +  clock-names:
>> +    contains:
>> +      enum:
>> +        - stmmaceth
>> +        - pclk
>> +        - ptp_ref
>> +        - tx
>> +        - gtxc
>> +        - gtx
> 
> Names should be specific and with fixed order, just like clocks are.
> 

Will fix.

>> +
>> +required:
>> +  - compatible
>> +  - clocks
>> +  - clock-names
>> +  - resets
>> +  - reset-names
>> +
>> +unevaluatedProperties: false
>> +
> 
> Best regards,
> Krzysztof
> 
