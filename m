Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263F66AD69B
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 05:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjCGE6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 23:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjCGE6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 23:58:33 -0500
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8090D34333;
        Mon,  6 Mar 2023 20:58:29 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3274vsKS065528;
        Mon, 6 Mar 2023 22:57:54 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678165074;
        bh=nVLfv1pht9lV4ARBLhJxKopJa8+Mpr5Jx0LHAfUS/+U=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=gd4GVk1bs/nm6Ij0vx+dbm+P4b1Vrowj12e+31Gzpeg9Mx8/6zawdsmlLNNQrWHVW
         hmvMqB2ZBMhaDEUcVqaygRTS9l61S1kpknO+mmjY8lQ8laLgfBiUe8aVg++YYZTRCO
         pqWRrbIvzBKaIvByUGwU8W8wo778JD9w6Kl4XmVw=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3274vsa3016099
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 6 Mar 2023 22:57:54 -0600
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 6
 Mar 2023 22:57:54 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 6 Mar 2023 22:57:54 -0600
Received: from [10.24.69.114] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3274vmdq119234;
        Mon, 6 Mar 2023 22:57:48 -0600
Message-ID: <43df3c2c-d0d0-f2b8-cf8b-8a2453ca43b4@ti.com>
Date:   Tue, 7 Mar 2023 10:27:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [EXTERNAL] Re: [PATCH v5 1/2] dt-bindings: net: Add ICSSG
 Ethernet
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>, MD Danish Anwar <danishanwar@ti.com>
CC:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, <andrew@lunn.ch>,
        <nm@ti.com>, <ssantosh@kernel.org>, <srk@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <20230210114957.2667963-1-danishanwar@ti.com>
 <20230210114957.2667963-2-danishanwar@ti.com>
 <20230210192001.GB2923614-robh@kernel.org>
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <20230210192001.GB2923614-robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On 11/02/23 00:50, Rob Herring wrote:
> On Fri, Feb 10, 2023 at 05:19:56PM +0530, MD Danish Anwar wrote:
>> From: Puranjay Mohan <p-mohan@ti.com>
>>
>> Add a YAML binding document for the ICSSG Programmable real time unit
>> based Ethernet hardware. The ICSSG driver uses the PRU and PRUSS consumer
>> APIs to interface the PRUs and load/run the firmware for supporting
>> ethernet functionality.
>>
>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>> Signed-off-by: Md Danish Anwar <danishanwar@ti.com>
>> ---
>>  .../bindings/net/ti,icssg-prueth.yaml         | 184 ++++++++++++++++++
>>  1 file changed, 184 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
>> new file mode 100644
>> index 000000000000..8b860f29ecc0
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
>> @@ -0,0 +1,184 @@
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
> 
> Odd line wrap length. It should be 80 chars.
> 

Sure, I will modify it.

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
> 
> I believe we have a standard 'sram' property to point to SRAM nodes 
> assuming this is just mmio-sram or similar.
> 

Yes, we have standard 'sram' property but Krzysztof had asked me to make the
sram property vendor specific in last revision of this series.

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
> 
> Don't need '|'
> 

Sure, I will drop this.

>> +      Interrupt specifiers to TX timestamp IRQ.
>> +
>> +  interrupt-names:
>> +    items:
>> +      - const: tx_ts0
>> +      - const: tx_ts1
>> +
>> +  ethernet-ports:
>> +    type: object
>> +    additionalProperties: false
>> +
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
>> +        $ref: ethernet-controller.yaml#
>> +        unevaluatedProperties: false
>> +
>> +        properties:
>> +          reg:
>> +            items:
>> +              - enum: [0, 1]
>> +            description: ICSSG PRUETH port number
>> +
>> +          interrupts:
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
>> +    anyOf:
>> +      - required:
>> +          - port@0
>> +      - required:
>> +          - port@1
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
>> +        interrupt-parent = <&icssg2_intc>;
>> +        interrupts = <24 0 2>, <25 1 3>;
>> +        interrupt-names = "tx_ts0", "tx_ts1";
>> +        ethernet-ports {
>> +            #address-cells = <1>;
>> +            #size-cells = <0>;
>> +            pruss2_emac0: port@0 {
>> +                reg = <0>;
>> +                phy-handle = <&pruss2_eth0_phy>;
>> +                phy-mode = "rgmii-id";
>> +                interrupts-extended = <&icssg2_intc 24>;
>> +                ti,syscon-rgmii-delay = <&scm_conf 0x4120>;
>> +                /* Filled in by bootloader */
>> +                local-mac-address = [00 00 00 00 00 00];
>> +            };
>> +
>> +            pruss2_emac1: port@1 {
>> +                reg = <1>;
>> +                phy-handle = <&pruss2_eth1_phy>;
>> +                phy-mode = "rgmii-id";
>> +                interrupts-extended = <&icssg2_intc 25>;
>> +                ti,syscon-rgmii-delay = <&scm_conf 0x4124>;
>> +                /* Filled in by bootloader */
>> +                local-mac-address = [00 00 00 00 00 00];
>> +            };
>> +        };
>> +    };
>> -- 
>> 2.25.1
>>

-- 
Thanks and Regards,
Danish.
