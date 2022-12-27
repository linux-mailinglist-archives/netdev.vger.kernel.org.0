Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E00E6568F6
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 10:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiL0Jir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 04:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiL0Jio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 04:38:44 -0500
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D99395B1;
        Tue, 27 Dec 2022 01:38:40 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 0E8D324E052;
        Tue, 27 Dec 2022 17:38:33 +0800 (CST)
Received: from EXMBX173.cuchost.com (172.16.6.93) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 27 Dec
 2022 17:38:33 +0800
Received: from [192.168.120.49] (171.223.208.138) by EXMBX173.cuchost.com
 (172.16.6.93) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 27 Dec
 2022 17:38:31 +0800
Message-ID: <134a2ead-e272-c32e-b14f-a9e98c8924ac@starfivetech.com>
Date:   Tue, 27 Dec 2022 17:38:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 5/9] dt-bindings: net: motorcomm: add support for
 Motorcomm YT8531
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
 <20221216070632.11444-6-yanhong.wang@starfivetech.com>
 <994718d8-f3ee-af5e-bda7-f913f66597ce@linaro.org>
From:   yanhong wang <yanhong.wang@starfivetech.com>
In-Reply-To: <994718d8-f3ee-af5e-bda7-f913f66597ce@linaro.org>
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



On 2022/12/16 19:15, Krzysztof Kozlowski wrote:
> On 16/12/2022 08:06, Yanhong Wang wrote:
>> Add support for Motorcomm Technology YT8531 10/100/1000 Ethernet PHY.
>> The document describe details of clock delay train configuration.
>> 
>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> 
> Missing vendor prefix documentation. I don't think you tested this at
> all with checkpatch and dt_binding_check.
> 
>> ---
>>  .../bindings/net/motorcomm,yt8531.yaml        | 111 ++++++++++++++++++
>>  MAINTAINERS                                   |   1 +
>>  2 files changed, 112 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/motorcomm,yt8531.yaml
>> 
>> diff --git a/Documentation/devicetree/bindings/net/motorcomm,yt8531.yaml b/Documentation/devicetree/bindings/net/motorcomm,yt8531.yaml
>> new file mode 100644
>> index 000000000000..c5b8a09a78bb
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/motorcomm,yt8531.yaml
>> @@ -0,0 +1,111 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/motorcomm,yt8531.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Motorcomm YT8531 Gigabit Ethernet PHY
>> +
>> +maintainers:
>> +  - Yanhong Wang <yanhong.wang@starfivetech.com>
>> +
> 
> Why there is no reference to ethernet-phy.yaml?
> 
>> +select:
>> +  properties:
>> +    $nodename:
>> +      pattern: "^ethernet-phy(@[a-f0-9]+)?$"
> 
> I don't think that's correct approach. You know affect all phys.
> 
>> +
>> +  required:
>> +    - $nodename
>> +
>> +properties:
>> +  $nodename:
>> +    pattern: "^ethernet-phy(@[a-f0-9]+)?$"
> 
> Just reference ethernet-phy.yaml.
> 
>> +
>> +  reg:
>> +    minimum: 0
>> +    maximum: 31
>> +    description:
>> +      The ID number for the PHY.
> 
> Drop duplicated properties.
> 
>> +
>> +  rxc_dly_en:
> 
> No underscores in node names. Missing vendor prefix. Both apply to all
> your other custom properties, unless they are not custom but generic.
> 
> Missing ref.
> 
>> +    description: |
>> +      RGMII Receive PHY Clock Delay defined with fixed 2ns.This is used for
> 
> After every full stop goes space.
> 
>> +      PHY that have configurable RX internal delays. If this property set
>> +      to 1, then automatically add 2ns delay pad for Receive PHY clock.
> 
> Nope, this is wrong. You wrote now boolean property as enum.
> 
>> +    enum: [0, 1]
>> +    default: 0
>> +
>> +  rx_delay_sel:
>> +    description: |
>> +      This is supplement to rxc_dly_en property,and it can
>> +      be specified in 150ps(pico seconds) steps. The effective
>> +      delay is: 150ps * N.
> 
> Nope. Use proper units and drop all this register stuff.
> 
>> +    minimum: 0
>> +    maximum: 15
>> +    default: 0
>> +
>> +  tx_delay_sel_fe:
>> +    description: |
>> +      RGMII Transmit PHY Clock Delay defined in pico seconds.This is used for
>> +      PHY's that have configurable TX internal delays when speed is 100Mbps
>> +      or 10Mbps. It can be specified in 150ps steps, the effective delay
>> +      is: 150ps * N.
> 
> The binding is in very poor shape. Please look carefully in
> example-schema. All my previous comments apply everywhere.
> 
>> +    minimum: 0
>> +    maximum: 15
>> +    default: 15
>> +
>> +  tx_delay_sel:
>> +    description: |
>> +      RGMII Transmit PHY Clock Delay defined in pico seconds.This is used for
>> +      PHY's that have configurable TX internal delays when speed is 1000Mbps.
>> +      It can be specified in 150ps steps, the effective delay is: 150ps * N.
>> +    minimum: 0
>> +    maximum: 15
>> +    default: 1
>> +
>> +  tx_inverted_10:
>> +    description: |
>> +      Use original or inverted RGMII Transmit PHY Clock to drive the RGMII
>> +      Transmit PHY Clock delay train configuration when speed is 10Mbps.
>> +      0: original   1: inverted
>> +    enum: [0, 1]
>> +    default: 0
>> +
>> +  tx_inverted_100:
>> +    description: |
>> +      Use original or inverted RGMII Transmit PHY Clock to drive the RGMII
>> +      Transmit PHY Clock delay train configuration when speed is 100Mbps.
>> +      0: original   1: inverted
>> +    enum: [0, 1]
>> +    default: 0
>> +
>> +  tx_inverted_1000:
>> +    description: |
>> +      Use original or inverted RGMII Transmit PHY Clock to drive the RGMII
>> +      Transmit PHY Clock delay train configuration when speed is 1000Mbps.
>> +      0: original   1: inverted
>> +    enum: [0, 1]
>> +    default: 0
>> +
>> +required:
>> +  - reg
>> +
>> +additionalProperties: true
> 
> This must be false. After referencing ethernet-phy this should be
> unevaluatedProperties: false.
> 
> 

Thanks. Parts of this patch exist already, after discussion unanimity was achieved,
i will remove the parts of YT8531 in the next version.

> Best regards,
> Krzysztof
> 
