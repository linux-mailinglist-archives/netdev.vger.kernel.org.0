Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB91538FD6
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 13:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343769AbiEaL1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 07:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235213AbiEaL1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 07:27:52 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236DA5640F;
        Tue, 31 May 2022 04:27:51 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 24VBRb64008005;
        Tue, 31 May 2022 06:27:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1653996457;
        bh=qJ0RI2D54rKAOY4QFUK9uMZFWGnHAFI7WYW4XE7wRGM=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=mzSCa0LUoZcXg8mXCsxilQxTtla1SylCI8AnRA6eAYZUldoj9ywO0d4TsDWyn+DY1
         wNB1D2oo1X7ksVXAHkmk4Xf791PGZ/seQ1lUYRKH4bG9tKhyN/i7pkMAhc+Mu6o6VW
         mrXlBoznJ5Xd8b31b3MvUx+nGeTSxoyK8185jkIY=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 24VBRbCa043686
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 31 May 2022 06:27:37 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 31
 May 2022 06:27:36 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 31 May 2022 06:27:36 -0500
Received: from [172.24.220.119] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 24VBRSXt018027;
        Tue, 31 May 2022 06:27:29 -0500
Message-ID: <faff79c9-7e1e-a69b-f314-6c00dedf1722@ti.com>
Date:   Tue, 31 May 2022 16:57:27 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 1/2] dt-bindings: net: Add ICSSG Ethernet Driver
 bindings
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <nm@ti.com>, <ssantosh@kernel.org>,
        <s-anna@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@kernel.org>, <grygorii.strashko@ti.com>, <vigneshr@ti.com>,
        <kishon@ti.com>, <robh+dt@kernel.org>, <afd@ti.com>,
        <andrew@lunn.ch>
References: <20220531095108.21757-1-p-mohan@ti.com>
 <20220531095108.21757-2-p-mohan@ti.com>
 <4ccba38a-ccde-83cd-195b-77db7a64477c@linaro.org>
From:   Puranjay Mohan <p-mohan@ti.com>
In-Reply-To: <4ccba38a-ccde-83cd-195b-77db7a64477c@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

On 31/05/22 15:38, Krzysztof Kozlowski wrote:
> On 31/05/2022 11:51, Puranjay Mohan wrote:
>> Add a YAML binding document for the ICSSG Programmable real time unit
>> based Ethernet driver. This driver uses the PRU and PRUSS consumer APIs
>> to interface the PRUs and load/run the firmware for supporting ethernet
>> functionality.
>>
>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>> ---
>> v1: https://lore.kernel.org/all/20220506052433.28087-2-p-mohan@ti.com/ 
>> v1 -> v2:
>> * Addressed Rob's Comments
> 
> Nope, they were not addressed.

I am trying my best to address them but I am new to DT Schemas, so, I
misunderstood a few comments.

> 
>> * It includes indentation, formatting, and other minor changes.
>> ---
>>  .../bindings/net/ti,icssg-prueth.yaml         | 181 ++++++++++++++++++
>>  1 file changed, 181 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
>> new file mode 100644
>> index 000000000000..40af968e9178
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
>> @@ -0,0 +1,181 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/ti,icssg-prueth.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: |+
> 
> Missed Rob's comment.

Sorry, Will remove this in next version.

> 
>> +  Texas Instruments ICSSG PRUSS Ethernet
>> +
>> +maintainers:
>> +  - Puranjay Mohan <p-mohan@ti.com>
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
>> +  pinctrl-0:
>> +    maxItems: 1
>> +
>> +  pinctrl-names:
>> +    items:
>> +      - const: default
> 
> You do not need these usually, they are coming from schema.

Will remove in next version.

> 
>> +
>> +  sram:
>> +    description:
>> +      phandle to MSMC SRAM node
>> +
>> +  dmas:
>> +    maxItems: 10
>> +    description:
>> +      list of phandles and specifiers to UDMA.
> 
> Please follow Rob's comment - drop description.

I misunderstood his comment, I thought he is asking to remove the
reference to the .txt file (Which I removed). I will remove it in next
version.

> 
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
> 
> How did you implement Rob's comments here?

He said ethernet-port is preferred but all other drivers were using
"port" so I though it is not compulsory. Will change it if it compulsory
to use ethernet-port

> 
>> +        type: object
>> +        description: ICSSG PRUETH external ports
>> +
>> +        $ref: ethernet-controller.yaml#
>> +
>> +        unevaluatedProperties: false
>> +        additionalProperties: true
> 
> No one proposed to add additionalProperties:true... Does it even work?

This is my mistake, will remove it in next version.

> 
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
>> +
>> +  interrupts:
>> +    minItems: 2
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
>> +    /* Example k3-am654 base board SR2.0, dual-emac */
>> +    pruss2_eth: pruss2_eth {
>> +            compatible = "ti,am654-icssg-prueth";
> 
> Again missed Rob's comment.

One of Rob's comment was to make the indentation as 4 which I have done.

The second comment was about 'ti,prus'.

So, ti,prus , firmware-name, and ti,pruss-gp-mux-sel are a part of
remoteproc/ti,pru-consumer.yaml which I have included with

allOf:
  - $ref: /schemas/remoteproc/ti,pru-consumer.yaml#

So, I thought it is not required to add them again.

I will add it in next version, if that is how it should be done.

> 
> Really, you ignored four of his comments. Please respect reviewers time
> but not forcing them to repeat same review comments.

I am really sorry for this.

Thanks,
Puranjay Mohan


> 
> Best regards,
> Krzysztof
