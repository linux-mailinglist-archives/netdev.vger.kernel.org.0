Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE6352234A
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 20:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348502AbiEJSLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 14:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348509AbiEJSLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 14:11:17 -0400
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678C65C76C;
        Tue, 10 May 2022 11:07:19 -0700 (PDT)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-d6e29fb3d7so19233349fac.7;
        Tue, 10 May 2022 11:07:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3L1rSCpF9l+zeG9AhsUaEM+AudM4l85p/MJLH0e44Qo=;
        b=M49FWHBVQSQ836/FuvkyRiNntzn+ciM4T2TCuf53VwMvB27Umn5FWB3rpeSg7guDHY
         WYAObVvqA4YuLblZzn1ej9WW3Gqyb81JX7msyoElf/PTkJEu7kuCSO0n4siCF4436xQR
         8fYx1rpZQqU5hyZnXEQ709DDM09qJxBhKytmUj+XV5diGdMgxMAL5e2u7KqZKO5OafBS
         Oe/yjVjpz2eV+0jxRE3XF/GrWNhanutAgvb30ixBn5KZ5QbW7YIoLk7f/4Kf4/n0ZAUy
         6tW5gs1p3KE1x7LEzYN8lbyr7R/T9gz90VCN0xeNwiX7bYWSENH7RDdxI3GDEvBxg09Y
         H3ag==
X-Gm-Message-State: AOAM531YJh9mpWU0YEGJyDHWSxEJiOMFRpgyy9FX/Zk9034oU3TmolM0
        s4plCqZpEeBH36QMEZt5vzZSEL8m+A==
X-Google-Smtp-Source: ABdhPJzog2Lk5E4Z3iWOg1giGgAMCsL5o42Z0jQ+v4oRFzdtl7nUweahq97ee0E1EIGIunqy4HAvgg==
X-Received: by 2002:a05:6870:9694:b0:ec:abf0:cc2f with SMTP id o20-20020a056870969400b000ecabf0cc2fmr735899oaq.235.1652206038579;
        Tue, 10 May 2022 11:07:18 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id p22-20020a056870831600b000eb0e40b4b8sm6161808oae.48.2022.05.10.11.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 11:07:17 -0700 (PDT)
Received: (nullmailer pid 2307606 invoked by uid 1000);
        Tue, 10 May 2022 18:07:16 -0000
Date:   Tue, 10 May 2022 13:07:16 -0500
From:   Rob Herring <robh@kernel.org>
To:     Puranjay Mohan <p-mohan@ti.com>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org, nm@ti.com,
        ssantosh@kernel.org, s-anna@ti.com,
        linux-arm-kernel@lists.infradead.org, rogerq@kernel.org,
        grygorii.strashko@ti.com, vigneshr@ti.com, kishon@ti.com,
        afd@ti.com, andrew@lunn.ch
Subject: Re: [PATCH 1/2] dt-bindings: net: Add ICSSG Ethernet Driver bindings
Message-ID: <Ynqp1LhWWtXjA8kT@robh.at.kernel.org>
References: <20220506052433.28087-1-p-mohan@ti.com>
 <20220506052433.28087-2-p-mohan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506052433.28087-2-p-mohan@ti.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 10:54:32AM +0530, Puranjay Mohan wrote:
> Add a YAML binding document for the ICSSG Programmable real time unit
> based Ethernet driver. This driver uses the PRU and PRUSS consumer APIs
> to interface the PRUs and load/run the firmware for supporting ethernet
> functionality.
> 
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> ---
>  .../bindings/net/ti,icssg-prueth.yaml         | 174 ++++++++++++++++++
>  1 file changed, 174 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> new file mode 100644
> index 000000000000..ca6f0af411cf
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> @@ -0,0 +1,174 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/ti,icssg-prueth.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: |+
> +  Texas Instruments ICSSG PRUSS Ethernet
> +
> +maintainers:
> +  - Puranjay Mohan <p-mohan@ti.com>
> +
> +description: |+

Don't need '|+'

> +  Ethernet based on the Programmable Real-Time Unit and Industrial Communication Subsystem.

Wrap the line at 80.

> +
> +allOf:
> +  - $ref: /schemas/remoteproc/ti,pru-consumer.yaml#
> +
> +properties:
> +  compatible:
> +    enum:
> +      - ti,am654-icssg-prueth  # for AM65x SoC family
> +
> +  sram:
> +    description: |
> +      phandle to MSMC SRAM node
> +
> +  dmas:
> +    minItems: 10
> +    maxItems: 10

Just maxItems is enough.

> +    description: |
> +      list of phandles and specifiers to UDMA as specified in bindings/dma/ti/k3-udma.txt.

Drop. First, we don't want new references to .txt files. Second, the 
specific provider is generally outside the scope of a binding.

> +
> +  dma-names:
> +    items:
> +      - const: tx0-0
> +      - const: tx0-1
> +      - const: tx0-2
> +      - const: tx0-3
> +      - const: tx1-0
> +      - const: tx1-1
> +      - const: tx1-2
> +      - const: tx1-3
> +      - const: rx0
> +      - const: rx1
> +
> +  ethernet-ports:
> +    type: object
> +    properties:
> +      '#address-cells':
> +        const: 1
> +      '#size-cells':
> +        const: 0
> +
> +    patternProperties:
> +      ^port@[0-1]$:

ethernet-port is preferred.

> +        type: object
> +        description: ICSSG PRUETH external ports
> +
> +        $ref: ethernet-controller.yaml#

           unevaluatedProperties: false

> +
> +        properties:
> +          reg:
> +            items:
> +              - enum: [0, 1]
> +            description: ICSSG PRUETH port number
> +
> +          ti,syscon-rgmii-delay:
> +            $ref: /schemas/types.yaml#/definitions/phandle-array
> +            description:
> +              phandle to system controller node and register offset
> +              to ICSSG control register for RGMII transmit delay
> +
> +        required:
> +          - reg
> +
> +    additionalProperties: false

For indented cases, I think it is easier to read if this is above 
'properties'.

> +
> +  ti,mii-g-rt:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description: |
> +      phandle to MII_G_RT module's syscon regmap.
> +
> +  ti,mii-rt:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description: |
> +      phandle to MII_RT module's syscon regmap
> +
> +  interrupts:
> +    minItems: 2
> +    maxItems: 2
> +    description: |
> +      Interrupt specifiers to TX timestamp IRQ.
> +
> +  interrupt-names:
> +    items:
> +      - const: tx_ts0
> +      - const: tx_ts1
> +
> +required:
> +  - compatible
> +  - sram
> +  - ti,mii-g-rt
> +  - dmas
> +  - dma-names
> +  - ethernet-ports
> +  - interrupts
> +  - interrupt-names
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +
> +    /* Example k3-am654 base board SR2.0, dual-emac */
> +        pruss2_eth: pruss2_eth {

Indentation here should be 4.

> +                compatible = "ti,am654-icssg-prueth";
> +                pinctrl-names = "default";
> +                pinctrl-0 = <&icssg2_rgmii_pins_default>;
> +                sram = <&msmc_ram>;
> +
> +                ti,prus = <&pru2_0>, <&rtu2_0>, <&tx_pru2_0>, <&pru2_1>, <&rtu2_1>, <&tx_pru2_1>;

Required?

You should also list this in properties and define how many entries.

> +                firmware-name = "ti-pruss/am65x-pru0-prueth-fw.elf",
> +                                "ti-pruss/am65x-rtu0-prueth-fw.elf",
> +                                "ti-pruss/am65x-txpru0-prueth-fw.elf",
> +                                "ti-pruss/am65x-pru1-prueth-fw.elf",
> +                                "ti-pruss/am65x-rtu1-prueth-fw.elf",
> +                                "ti-pruss/am65x-txpru1-prueth-fw.elf";
> +                ti,pruss-gp-mux-sel = <2>,      /* MII mode */
> +                                      <2>,
> +                                      <2>,
> +                                      <2>,      /* MII mode */
> +                                      <2>,
> +                                      <2>;
> +                ti,mii-g-rt = <&icssg2_mii_g_rt>;
> +                dmas = <&main_udmap 0xc300>, /* egress slice 0 */
> +                       <&main_udmap 0xc301>, /* egress slice 0 */
> +                       <&main_udmap 0xc302>, /* egress slice 0 */
> +                       <&main_udmap 0xc303>, /* egress slice 0 */
> +                       <&main_udmap 0xc304>, /* egress slice 1 */
> +                       <&main_udmap 0xc305>, /* egress slice 1 */
> +                       <&main_udmap 0xc306>, /* egress slice 1 */
> +                       <&main_udmap 0xc307>, /* egress slice 1 */
> +                       <&main_udmap 0x4300>, /* ingress slice 0 */
> +                       <&main_udmap 0x4301>; /* ingress slice 1 */
> +                dma-names = "tx0-0", "tx0-1", "tx0-2", "tx0-3",
> +                            "tx1-0", "tx1-1", "tx1-2", "tx1-3",
> +                            "rx0", "rx1";
> +                interrupts = <24 0 2>, <25 1 3>;
> +                interrupt-names = "tx_ts0", "tx_ts1";
> +                ethernet-ports {
> +                        #address-cells = <1>;
> +                        #size-cells = <0>;
> +                        pruss2_emac0: port@0 {
> +                                reg = <0>;
> +                                phy-handle = <&pruss2_eth0_phy>;
> +                                phy-mode = "rgmii-rxid";
> +                                interrupts-extended = <&icssg2_intc 24>;
> +                                ti,syscon-rgmii-delay = <&scm_conf 0x4120>;
> +                                /* Filled in by bootloader */
> +                                local-mac-address = [00 00 00 00 00 00];
> +                        };
> +
> +                        pruss2_emac1: port@1 {
> +                                reg = <1>;
> +                                phy-handle = <&pruss2_eth1_phy>;
> +                                phy-mode = "rgmii-rxid";
> +                                interrupts-extended = <&icssg2_intc 25>;
> +                                ti,syscon-rgmii-delay = <&scm_conf 0x4124>;
> +                                /* Filled in by bootloader */
> +                                local-mac-address = [00 00 00 00 00 00];
> +                        };
> +                };
> +        };
> -- 
> 2.17.1
> 
> 
