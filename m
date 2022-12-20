Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70DD651AF7
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 07:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbiLTGx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 01:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiLTGx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 01:53:57 -0500
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378C29FEB;
        Mon, 19 Dec 2022 22:53:55 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id A5EEF24E023;
        Tue, 20 Dec 2022 14:53:43 +0800 (CST)
Received: from EXMBX173.cuchost.com (172.16.6.93) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 20 Dec
 2022 14:53:43 +0800
Received: from [192.168.120.49] (171.223.208.138) by EXMBX173.cuchost.com
 (172.16.6.93) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 20 Dec
 2022 14:53:41 +0800
Message-ID: <9bdb7929-a801-d244-2731-dd55541ad2ce@starfivetech.com>
Date:   Tue, 20 Dec 2022 14:53:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 4/9] dt-bindings: net: Add bindings for StarFive dwmac
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
References: <20221216070632.11444-1-yanhong.wang@starfivetech.com>
 <20221216070632.11444-5-yanhong.wang@starfivetech.com>
 <2da394a6-411a-ca2b-90d3-7e97f3637d9f@linaro.org>
From:   yanhong wang <yanhong.wang@starfivetech.com>
In-Reply-To: <2da394a6-411a-ca2b-90d3-7e97f3637d9f@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX173.cuchost.com
 (172.16.6.93)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/12/16 19:05, Krzysztof Kozlowski wrote:
> On 16/12/2022 08:06, Yanhong Wang wrote:
>> Add documentation to describe StarFive dwmac driver(GMAC).
>> 
>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>> ---
>>  .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
>>  .../bindings/net/starfive,jh71x0-dwmac.yaml   | 103 ++++++++++++++++++
>>  MAINTAINERS                                   |   5 +
>>  3 files changed, 109 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/starfive,jh71x0-dwmac.yaml
>> 
>> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> index 7870228b4cd3..cdb045d1c618 100644
>> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> @@ -91,6 +91,7 @@ properties:
>>          - snps,dwmac-5.20
>>          - snps,dwxgmac
>>          - snps,dwxgmac-2.10
>> +        - starfive,jh7110-dwmac
>>  
>>    reg:
>>      minItems: 1
>> diff --git a/Documentation/devicetree/bindings/net/starfive,jh71x0-dwmac.yaml b/Documentation/devicetree/bindings/net/starfive,jh71x0-dwmac.yaml
>> new file mode 100644
>> index 000000000000..5cb1272fe959
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/starfive,jh71x0-dwmac.yaml
>> @@ -0,0 +1,103 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +# Copyright (C) 2022 StarFive Technology Co., Ltd.
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/starfive,jh71x0-dwmac.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: StarFive JH71x0 DWMAC glue layer
>> +
>> +maintainers:
>> +  - Yanhong Wang <yanhong.wang@starfivetech.com>
>> +
>> +select:
>> +  properties:
>> +    compatible:
>> +      contains:
>> +        enum:
>> +          - starfive,jh7110-dwmac
>> +  required:
>> +    - compatible
>> +
>> +allOf:
>> +  - $ref: snps,dwmac.yaml#
>> +
>> +properties:
>> +  compatible:
>> +    items:
>> +      - enum:
>> +          - starfive,jh7110-dwmac
> 
> Is it going to grow with new models? If yes, when? If not, filename does
> not match compatible.

I will update the filename in the next version.

> 
>> +      - const: snps,dwmac-5.20
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
>> +    items:
>> +      - const: stmmaceth
>> +      - const: pclk
>> +      - const: ptp_ref
>> +      - const: tx
>> +      - const: gtxc
>> +      - const: gtx
> 
> missing resets and reset-names.
> 

I will add resets and reset-names in the next version.

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
> Best regards,
> Krzysztof
> 
