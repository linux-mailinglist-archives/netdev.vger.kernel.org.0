Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFECD686512
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 12:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbjBALLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 06:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbjBALLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 06:11:08 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CC0518DD;
        Wed,  1 Feb 2023 03:11:00 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 311BAO7W095237;
        Wed, 1 Feb 2023 05:10:24 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1675249824;
        bh=C2fkhzDKpyC6VYBjXs0epirB6kkQ1d7SHJaX7hY3p5M=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=Kd3elvazf8+kce8AdbbtUdUzRirqwPadF0fPGxFHnfxBtAKUlrOTMGFP4lce9y5wQ
         j4RT3xYu7Rk5dIfpoDse84jM9sFXwU32pvGT/gtoT1bWAShi08/qbvKA7q8KDuI7Zy
         iUm/Sb/bG8V7jYIfuixeEvW+QXwFq7E0WWWbtaQM=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 311BAOvh004554
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 1 Feb 2023 05:10:24 -0600
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 1
 Feb 2023 05:10:24 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 1 Feb 2023 05:10:24 -0600
Received: from [10.24.69.114] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 311BAIUQ129851;
        Wed, 1 Feb 2023 05:10:18 -0600
Message-ID: <703df816-e7bf-dfef-4a55-6fd784f5854c@ti.com>
Date:   Wed, 1 Feb 2023 16:40:17 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [EXTERNAL] Re: [PATCH v3 1/2] dt-bindings: net: Add ICSSG
 Ethernet Driver bindings
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Suman Anna <s-anna@ti.com>, Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, <andrew@lunn.ch>
CC:     <nm@ti.com>, <ssantosh@kernel.org>, <srk@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <20221223110930.1337536-1-danishanwar@ti.com>
 <20221223110930.1337536-2-danishanwar@ti.com>
 <b17e9a32-cfdb-223c-f500-c897061753f6@linaro.org>
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <b17e9a32-cfdb-223c-f500-c897061753f6@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

On 23/12/22 17:01, Krzysztof Kozlowski wrote:
> On 23/12/2022 12:09, MD Danish Anwar wrote:
>> From: Puranjay Mohan <p-mohan@ti.com>
>>
>> Add a YAML binding document for the ICSSG Programmable real time unit
>> based Ethernet driver. This driver uses the PRU and PRUSS consumer APIs
>> to interface the PRUs and load/run the firmware for supporting ethernet
>> functionality.
>>
>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>> Signed-off-by: Md Danish Anwar <danishanwar@ti.com>
>> ---
>>  .../bindings/net/ti,icssg-prueth.yaml         | 174 ++++++++++++++++++
>>  1 file changed, 174 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
>> new file mode 100644
>> index 000000000000..7659f5fd3132
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
>> @@ -0,0 +1,174 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/ti,icssg-prueth.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title:
>> +  Texas Instruments ICSSG PRUSS Ethernet
> 
> Keep it in one line.
> 

Sure, I'll do it.

>> +
>> +maintainers:
>> +  - Puranjay Mohan <p-mohan@ti.com>
>> +  - Md Danish Anwar <danishanwar@ti.com>
>> +
>> +description:
>> +  Ethernet based on the Programmable Real-Time
>> +  Unit and Industrial Communication Subsystem.
>> +
>> +allOf:
>> +  - $ref: /schemas/remoteproc/ti,pru-consumer.yaml#
>> +
>> +properties:
>> +  compatible:
>> +    enum:
>> +      - ti,am654-icssg-prueth  # for AM65x SoC family
>> +
>> +  sram:
>> +    description:
>> +      phandle to MSMC SRAM node
> 
> Where does the definition of this come from? If from nowhere, usually
> you need vendor prefix and type/ref.
> 

It is phandle to sram node in SoC DT file. I'll change it to ti,sram as it is
TI specific. I'll also add $ref: /schemas/types.yaml#/definitions/phandle

>> +
>> +  dmas:
>> +    maxItems: 10
>> +
>> +  dma-names:
>> +    items:
>> +      - const: tx0-0
>> +      - const: tx0-1
>> +      - const: tx0-2
>> +      - const: tx0-3
>> +      - const: tx1-0
>> +      - const: tx1-1
>> +      - const: tx1-2
>> +      - const: tx1-3
>> +      - const: rx0
>> +      - const: rx1
>> +
>> +  ethernet-ports:
>> +    type: object
>> +    properties:
>> +      '#address-cells':
>> +        const: 1
>> +      '#size-cells':
>> +        const: 0
>> +
>> +    patternProperties:
>> +      ^port@[0-1]$:
>> +        type: object
>> +        description: ICSSG PRUETH external ports
>> +
>> +        $ref: ethernet-controller.yaml#
>> +
>> +        unevaluatedProperties: false
>> +        additionalProperties: false
> 
> You cannot have both. Did you test the binding? I doubt it...
> 

Sorry, must have missed it in testing. I will remove additionalProperties and
just keep unevaluatedProperties.

>> +        properties:
>> +          reg:
>> +            items:
>> +              - enum: [0, 1]
>> +            description: ICSSG PRUETH port number
>> +
>> +          ti,syscon-rgmii-delay:
>> +            $ref: /schemas/types.yaml#/definitions/phandle-array
>> +            description:
>> +              phandle to system controller node and register offset
>> +              to ICSSG control register for RGMII transmit delay
> 
> You need to describe the items. And in your own bindings from TI you
> will even find example...
> 

Sure. I'll describe the items for this.

>> +
>> +        required:
>> +          - reg
>> +
>> +  ti,mii-g-rt:
>> +    $ref: /schemas/types.yaml#/definitions/phandle
>> +    description: |
>> +      phandle to MII_G_RT module's syscon regmap.
>> +
>> +  ti,mii-rt:
>> +    $ref: /schemas/types.yaml#/definitions/phandle
>> +    description: |
>> +      phandle to MII_RT module's syscon regmap
> 
> Why do you have so many phandles? Aren't you missing some phys?
> 

That is because control bits were sprinkled around System Control register so
we need to use syscon regmap to access them.

>> +
>> +  interrupts:
>> +    minItems: 2
> 
> Drop minItems
> 

Sure. I'll drop minItems.

>> +    maxItems: 2
>> +    description: |
>> +      Interrupt specifiers to TX timestamp IRQ.
>> +
>> +  interrupt-names:
>> +    items:
>> +      - const: tx_ts0
>> +      - const: tx_ts1
>> +
>> +required:
>> +  - compatible
>> +  - sram
>> +  - ti,mii-g-rt
> 
> Keep same order as in properties:.
> 

Sure, I will make sure it has same order as in properties.

>> +  - dmas
>> +  - dma-names
>> +  - ethernet-ports
>> +  - interrupts
>> +  - interrupt-names
>> +
>> +unevaluatedProperties: false
>> +
>> +examples:
>> +  - |
>> +
> 
> No need for blank line.
> 

I'll remove this blank line.

>> +    /* Example k3-am654 base board SR2.0, dual-emac */
>> +    pruss2_eth: pruss2_eth {
> 
> No underscores in node names.
> 
> Node names should be generic.
> https://devicetree-specification.readthedocs.io/en/latest/chapter2-devicetree-basics.html#generic-names-recommendation
> 

I will change the node name 'pruss2_eth' to generic for example 'ethernet'.

>> +        compatible = "ti,am654-icssg-prueth";
>> +        pinctrl-names = "default";
>> +        pinctrl-0 = <&icssg2_rgmii_pins_default>;
>> +        sram = <&msmc_ram>;
>> +
>> +        ti,prus = <&pru2_0>, <&rtu2_0>, <&tx_pru2_0>,
>> +                  <&pru2_1>, <&rtu2_1>, <&tx_pru2_1>;
>> +        firmware-name = "ti-pruss/am65x-pru0-prueth-fw.elf",
>> +                        "ti-pruss/am65x-rtu0-prueth-fw.elf",
>> +                        "ti-pruss/am65x-txpru0-prueth-fw.elf",
>> +                        "ti-pruss/am65x-pru1-prueth-fw.elf",
>> +                        "ti-pruss/am65x-rtu1-prueth-fw.elf",
>> +                        "ti-pruss/am65x-txpru1-prueth-fw.elf";
> 
> I really doubt it was tested... and maybe there will be no testing from
> Rob's bot due to dependency.
> 
> Please post dt_binding_check testing results.
> 

I had run dt_binding check before posting, must have missed these errors. I
will be careful to check for this errors before posting patches.

I will post new revision after doing the above mentioned changes. I will make
sure to do testing properly.

> Best regards,
> Krzysztof
> 

-- 
Thanks and Regards,
Danish.
