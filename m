Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91EBD68BA8A
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjBFKkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjBFKk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:40:27 -0500
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF47B457;
        Mon,  6 Feb 2023 02:40:07 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 316Ad9PP090498;
        Mon, 6 Feb 2023 04:39:09 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1675679949;
        bh=z4nwf/VDXcG4CYg6semyecFfe3EixsrC45ZlYCcCgyo=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=RT62vdH1NqF55aEsgFUHUh704Y0HdoUSB7SBVZzn+tAZOpbFu/qMM/Tj6R/1H0bZ9
         ZUDqiauBAx4VoGfzIeep6rji88RYZzsNPkburPfdWe9P8EQ2dsbCQNgHHF/2NzuvfR
         D76SK8422cFLPI6VapvenHFYaxiamt4KHenJm2CU=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 316Ad9J6097075
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 6 Feb 2023 04:39:09 -0600
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 6
 Feb 2023 04:39:08 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 6 Feb 2023 04:39:08 -0600
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 316Ad2pl002451;
        Mon, 6 Feb 2023 04:39:03 -0600
Message-ID: <81dc1c83-3e66-4612-9011-cf70fb624529@ti.com>
Date:   Mon, 6 Feb 2023 16:09:02 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [EXTERNAL] Re: [PATCH v4 1/2] dt-bindings: net: Add ICSSG
 Ethernet Driver bindings
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, <andrew@lunn.ch>
CC:     <nm@ti.com>, <ssantosh@kernel.org>, <srk@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <20230206060708.3574472-1-danishanwar@ti.com>
 <20230206060708.3574472-2-danishanwar@ti.com>
 <e0ab9ea1-59b7-506f-1e77-231a0cdc09bf@linaro.org>
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <e0ab9ea1-59b7-506f-1e77-231a0cdc09bf@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

Thanks for the comments.

On 06/02/23 13:20, Krzysztof Kozlowski wrote:
> On 06/02/2023 07:07, MD Danish Anwar wrote:
>> From: Puranjay Mohan <p-mohan@ti.com>
>>
>> Add a YAML binding document for the ICSSG Programmable real time unit
>> based Ethernet driver. This driver uses the PRU and PRUSS consumer APIs
> 
> You add a binding for the hardware, not for driver.
> 
>> to interface the PRUs and load/run the firmware for supporting ethernet
>> functionality.
> 
> Subject: drop second/last, redundant "driver bindings". The
> "dt-bindings" prefix is already stating that these are bindings.
> 

Sure I will modify the subject and commit description.

>>
>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>> Signed-off-by: Md Danish Anwar <danishanwar@ti.com>
>> ---
>>  .../bindings/net/ti,icssg-prueth.yaml         | 179 ++++++++++++++++++
>>  1 file changed, 179 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
>> new file mode 100644
>> index 000000000000..e4dee01a272a
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
>> @@ -0,0 +1,179 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/ti,icssg-prueth.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Texas Instruments ICSSG PRUSS Ethernet
>> +
>> +maintainers:
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
>> +  ti,sram:
>> +    $ref: /schemas/types.yaml#/definitions/phandle
>> +    description:
>> +      phandle to MSMC SRAM node
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
> 
> Bring some order or logic in the order of the properties. Keep the
> ethernet-ports as last property.
> 

Sure, I will re-arrange them.

>> +    type: object
>> +    additionalProperties: false
> 
> Blank line
> 
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

At least one ethernet port is required. Should I add the below line here for this?

   minItems: 1

>> Drop blank line
> 
>> +        $ref: ethernet-controller.yaml#
>> +
> 
> Drop blank line
> 
>> +        unevaluatedProperties: false
>> +
>> +        properties:
>> +          reg:
>> +            items:
>> +              - enum: [0, 1]
>> +            description: ICSSG PRUETH port number
>> +
>> +          interrupts-extended:
> 
> Just "interrupts"

I will drop / add blank lines and change this to just "interrupts".

>> +            maxItems: 1
>> +
>> +          ti,syscon-rgmii-delay:
>> +            items:
>> +              - items:
>> +                  - description: phandle to system controller node
>> +                  - description: The offset to ICSSG control register
>> +            $ref: /schemas/types.yaml#/definitions/phandle-array
>> +            description:
>> +              phandle to system controller node and register offset
>> +              to ICSSG control register for RGMII transmit delay
>> +
>> +        required:
>> +          - reg
> 
> required for ethernet-ports - at least one port is required, isn't it?

Yes, at least one ethernet port is required. Should I add "minItems: 1" in
patternProperties section or should I add a new required section in
patternProperties and mention something like port@0 as required?

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
>> +  - ti,sram
>> +  - dmas
>> +  - dma-names
>> +  - ethernet-ports
>> +  - ti,mii-g-rt
>> +  - interrupts
>> +  - interrupt-names
>> +
>> +unevaluatedProperties: false
>> +
>> +examples:
>> +  - |
>> +    /* Example k3-am654 base board SR2.0, dual-emac */
>> +    pruss2_eth: ethernet {
>> +        compatible = "ti,am654-icssg-prueth";
>> +        pinctrl-names = "default";
>> +        pinctrl-0 = <&icssg2_rgmii_pins_default>;
>> +        ti,sram = <&msmc_ram>;
>> +
>> +        ti,prus = <&pru2_0>, <&rtu2_0>, <&tx_pru2_0>,
>> +                  <&pru2_1>, <&rtu2_1>, <&tx_pru2_1>;
>> +        firmware-name = "ti-pruss/am65x-pru0-prueth-fw.elf",
>> +                        "ti-pruss/am65x-rtu0-prueth-fw.elf",
>> +                        "ti-pruss/am65x-txpru0-prueth-fw.elf",
>> +                        "ti-pruss/am65x-pru1-prueth-fw.elf",
>> +                        "ti-pruss/am65x-rtu1-prueth-fw.elf",
>> +                        "ti-pruss/am65x-txpru1-prueth-fw.elf";
>> +        ti,pruss-gp-mux-sel = <2>,      /* MII mode */
>> +                              <2>,
>> +                              <2>,
>> +                              <2>,      /* MII mode */
>> +                              <2>,
>> +                              <2>;
>> +        dmas = <&main_udmap 0xc300>, /* egress slice 0 */
>> +               <&main_udmap 0xc301>, /* egress slice 0 */
>> +               <&main_udmap 0xc302>, /* egress slice 0 */
>> +               <&main_udmap 0xc303>, /* egress slice 0 */
>> +               <&main_udmap 0xc304>, /* egress slice 1 */
>> +               <&main_udmap 0xc305>, /* egress slice 1 */
>> +               <&main_udmap 0xc306>, /* egress slice 1 */
>> +               <&main_udmap 0xc307>, /* egress slice 1 */
>> +               <&main_udmap 0x4300>, /* ingress slice 0 */
>> +               <&main_udmap 0x4301>; /* ingress slice 1 */
>> +        dma-names = "tx0-0", "tx0-1", "tx0-2", "tx0-3",
>> +                    "tx1-0", "tx1-1", "tx1-2", "tx1-3",
>> +                    "rx0", "rx1";
>> +        ti,mii-g-rt = <&icssg2_mii_g_rt>;
>> +        interrupts = <24 0 2>, <25 1 3>;
> 
> Aren't you open-coding some IRQ flags?
> 

These values are not open coded here. These values are the expected values for
interrupt node.

Here,

Cell 1 -> PRU System event number
Cell 2 -> PRU channel
Cell 3 -> PRU host_event (target)

This is documented in detail in
Documentation/devicetree/bindings/interrupt-controller/ti,pruss-intc.yaml

I also missed mentioning "interrupt-parent" in example section. I will add
interrupt-parent in next revision.

interrupt-parent = <&icssg2_intc>;

>> +        interrupt-names = "tx_ts0", "tx_ts1";
>> +        ethernet-ports {
> 
> 
> Best regards,
> Krzysztof
> 

-- 
Thanks and Regards,
Danish.
