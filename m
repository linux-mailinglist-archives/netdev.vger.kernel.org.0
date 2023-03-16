Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010156BC76A
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 08:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjCPHkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 03:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCPHkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 03:40:16 -0400
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141DE12BC5;
        Thu, 16 Mar 2023 00:40:12 -0700 (PDT)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id C4B4D24E313;
        Thu, 16 Mar 2023 15:40:09 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 16 Mar
 2023 15:40:09 +0800
Received: from [192.168.120.42] (171.223.208.138) by EXMBX162.cuchost.com
 (172.16.6.72) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 16 Mar
 2023 15:40:08 +0800
Message-ID: <aa27adda-587a-6e53-d62a-c644c5620e07@starfivetech.com>
Date:   Thu, 16 Mar 2023 15:40:06 +0800
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
From:   Guo Samin <samin.guo@starfivetech.com>
In-Reply-To: <cfeec762-de75-f90f-7ba1-6c0bd8b70dff@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Re: [PATCH v7 4/6] dt-bindings: net: Add support StarFive dwmac
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
to: Samin Guo <samin.guo@starfivetech.com>, linux-riscv@lists.infradead.org, netdev@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
data: 2023/3/16

> On 16/03/2023 05:37, Samin Guo wrote:
>> From: Yanhong Wang <yanhong.wang@starfivetech.com>
>>
>> Add documentation to describe StarFive dwmac driver(GMAC).
>>
> Thank you for your patch. There is something to discuss/improve.
> 
>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
>> Tested-by: Tommaso Merciai <tomm.merciai@gmail.com>
>> ---
>>  .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
>>  .../bindings/net/starfive,jh7110-dwmac.yaml   | 130 ++++++++++++++++++
>>  MAINTAINERS                                   |   6 +
>>  3 files changed, 137 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> index e4519cf722ab..245f7d713261 100644
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
>> diff --git a/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml b/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
>> new file mode 100644
>> index 000000000000..b59e6bd8201f
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
>> @@ -0,0 +1,130 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +# Copyright (C) 2022 StarFive Technology Co., Ltd.
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/starfive,jh7110-dwmac.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: StarFive JH7110 DWMAC glue layer
>> +
>> +maintainers:
>> +  - Emil Renner Berthing <kernel@esmil.dk>
>> +  - Samin Guo <samin.guo@starfivetech.com>
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
>> +properties:
>> +  compatible:
>> +    items:
>> +      - enum:
>> +          - starfive,jh7110-dwmac
>> +      - const: snps,dwmac-5.20
>> +
> 
> reg:
>   maxItems: 1
Thanks, I will add it in next version.
> 
> 
>> +  clocks:
>> +    items:
>> +      - description: GMAC main clock
>> +      - description: GMAC AHB clock
>> +      - description: PTP clock
>> +      - description: TX clock
>> +      - description: GTX clock
>> +
>> +  clock-names:
>> +    items:
>> +      - const: stmmaceth
>> +      - const: pclk
>> +      - const: ptp_ref
>> +      - const: tx
>> +      - const: gtx
>> +
> 
> interrupts: ???
Thanks, I will add it in next version.
> 
>> +  resets:
>> +    items:
>> +      - description: MAC Reset signal.
>> +      - description: AHB Reset signal.
>> +
>> +  reset-names:
>> +    items:
>> +      - const: stmmaceth
>> +      - const: ahb
>> +
>> +  starfive,tx-use-rgmii-clk:
>> +    description:
>> +      Tx clock is provided by external rgmii clock.
>> +    type: boolean
>> +
>> +  starfive,syscon:
>> +    $ref: /schemas/types.yaml#/definitions/phandle-array
>> +    items:
>> +      - items:
>> +          - description: phandle to syscon that configures phy mode
>> +          - description: Offset of phy mode selection
>> +          - description: Shift of phy mode selection
>> +    description:
>> +      A phandle to syscon with two arguments that configure phy mode.
>> +      The argument one is the offset of phy mode selection, the
>> +      argument two is the shift of phy mode selection.
>> +
>> +allOf:
>> +  - $ref: snps,dwmac.yaml#
>> +
>> +unevaluatedProperties: false
>> +
> Best regards,
> Krzysztof
> 

Best regards,
Samin
