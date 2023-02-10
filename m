Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87486692632
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbjBJTUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbjBJTUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:20:05 -0500
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12587D899;
        Fri, 10 Feb 2023 11:20:03 -0800 (PST)
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-15fe106c7c7so7915697fac.8;
        Fri, 10 Feb 2023 11:20:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O0/BgPoPhr1KWdvyyKwGYcpVH7e6nXDxaQdDCUHcTK4=;
        b=W4Huzd90KKthrE41lgrteNnSvWTarK+kwyBiJZJMvebb8pZdOpcWwLOSF9AJfRbdEt
         ca+D+eXUd8Z6VKiRefoT08l+UYBcGyRB3SBn7TVVZQ7jePh6mqpp1qtd1pIezswNam5o
         0DaWKGzxcWJO7RbGqjssB1AdhmuU15ZyzTQc3ikcf65LGP4CFNjE/bw7bBI3i5ym1AR4
         37iF84hbeen/iasQmvGfgMw2d7JHuC1YKiZTairkHWgT8xVXDilEEVBwhU0vNNhTaFVA
         NpzdsLlqMw2Miajkqj8mQ0pVJ43cBhNZya/GvoRPYBVy442Qg8k3D+iuTV3pPy6BUwt3
         hjog==
X-Gm-Message-State: AO0yUKVwOtxfmEJE5pfBJRGIv5o/on6HKRF5uUjLHVQZKXFsrJpx+TU5
        4OzztYiK7fLffPvgaA9e+g==
X-Google-Smtp-Source: AK7set8JG94u8QaNAm6pZm73hOXlkC85NrnHVuzZmEXNlw4rAyD6NZ3YROCBaC4KXKBQbSt/GVtidw==
X-Received: by 2002:a05:6870:f106:b0:16a:b020:d05 with SMTP id k6-20020a056870f10600b0016ab0200d05mr2055688oac.19.1676056802853;
        Fri, 10 Feb 2023 11:20:02 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id ea53-20020a056870073500b0014fb4bdc746sm2264560oab.8.2023.02.10.11.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 11:20:02 -0800 (PST)
Received: (nullmailer pid 3034804 invoked by uid 1000);
        Fri, 10 Feb 2023 19:20:01 -0000
Date:   Fri, 10 Feb 2023 13:20:01 -0600
From:   Rob Herring <robh@kernel.org>
To:     MD Danish Anwar <danishanwar@ti.com>
Cc:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, andrew@lunn.ch, nm@ti.com,
        ssantosh@kernel.org, srk@ti.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 1/2] dt-bindings: net: Add ICSSG Ethernet
Message-ID: <20230210192001.GB2923614-robh@kernel.org>
References: <20230210114957.2667963-1-danishanwar@ti.com>
 <20230210114957.2667963-2-danishanwar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210114957.2667963-2-danishanwar@ti.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 05:19:56PM +0530, MD Danish Anwar wrote:
> From: Puranjay Mohan <p-mohan@ti.com>
> 
> Add a YAML binding document for the ICSSG Programmable real time unit
> based Ethernet hardware. The ICSSG driver uses the PRU and PRUSS consumer
> APIs to interface the PRUs and load/run the firmware for supporting
> ethernet functionality.
> 
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> Signed-off-by: Md Danish Anwar <danishanwar@ti.com>
> ---
>  .../bindings/net/ti,icssg-prueth.yaml         | 184 ++++++++++++++++++
>  1 file changed, 184 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> new file mode 100644
> index 000000000000..8b860f29ecc0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> @@ -0,0 +1,184 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/ti,icssg-prueth.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Texas Instruments ICSSG PRUSS Ethernet
> +
> +maintainers:
> +  - Md Danish Anwar <danishanwar@ti.com>
> +
> +description:
> +  Ethernet based on the Programmable Real-Time
> +  Unit and Industrial Communication Subsystem.

Odd line wrap length. It should be 80 chars.

> +
> +allOf:
> +  - $ref: /schemas/remoteproc/ti,pru-consumer.yaml#
> +
> +properties:
> +  compatible:
> +    enum:
> +      - ti,am654-icssg-prueth  # for AM65x SoC family
> +
> +  ti,sram:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      phandle to MSMC SRAM node

I believe we have a standard 'sram' property to point to SRAM nodes 
assuming this is just mmio-sram or similar.

> +
> +  dmas:
> +    maxItems: 10
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
> +    maxItems: 2
> +    description: |

Don't need '|'

> +      Interrupt specifiers to TX timestamp IRQ.
> +
> +  interrupt-names:
> +    items:
> +      - const: tx_ts0
> +      - const: tx_ts1
> +
> +  ethernet-ports:
> +    type: object
> +    additionalProperties: false
> +
> +    properties:
> +      '#address-cells':
> +        const: 1
> +      '#size-cells':
> +        const: 0
> +
> +    patternProperties:
> +      ^port@[0-1]$:
> +        type: object
> +        description: ICSSG PRUETH external ports
> +        $ref: ethernet-controller.yaml#
> +        unevaluatedProperties: false
> +
> +        properties:
> +          reg:
> +            items:
> +              - enum: [0, 1]
> +            description: ICSSG PRUETH port number
> +
> +          interrupts:
> +            maxItems: 1
> +
> +          ti,syscon-rgmii-delay:
> +            items:
> +              - items:
> +                  - description: phandle to system controller node
> +                  - description: The offset to ICSSG control register
> +            $ref: /schemas/types.yaml#/definitions/phandle-array
> +            description:
> +              phandle to system controller node and register offset
> +              to ICSSG control register for RGMII transmit delay
> +
> +        required:
> +          - reg
> +    anyOf:
> +      - required:
> +          - port@0
> +      - required:
> +          - port@1
> +
> +required:
> +  - compatible
> +  - ti,sram
> +  - dmas
> +  - dma-names
> +  - ethernet-ports
> +  - ti,mii-g-rt
> +  - interrupts
> +  - interrupt-names
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    /* Example k3-am654 base board SR2.0, dual-emac */
> +    pruss2_eth: ethernet {
> +        compatible = "ti,am654-icssg-prueth";
> +        pinctrl-names = "default";
> +        pinctrl-0 = <&icssg2_rgmii_pins_default>;
> +        ti,sram = <&msmc_ram>;
> +
> +        ti,prus = <&pru2_0>, <&rtu2_0>, <&tx_pru2_0>,
> +                  <&pru2_1>, <&rtu2_1>, <&tx_pru2_1>;
> +        firmware-name = "ti-pruss/am65x-pru0-prueth-fw.elf",
> +                        "ti-pruss/am65x-rtu0-prueth-fw.elf",
> +                        "ti-pruss/am65x-txpru0-prueth-fw.elf",
> +                        "ti-pruss/am65x-pru1-prueth-fw.elf",
> +                        "ti-pruss/am65x-rtu1-prueth-fw.elf",
> +                        "ti-pruss/am65x-txpru1-prueth-fw.elf";
> +        ti,pruss-gp-mux-sel = <2>,      /* MII mode */
> +                              <2>,
> +                              <2>,
> +                              <2>,      /* MII mode */
> +                              <2>,
> +                              <2>;
> +        dmas = <&main_udmap 0xc300>, /* egress slice 0 */
> +               <&main_udmap 0xc301>, /* egress slice 0 */
> +               <&main_udmap 0xc302>, /* egress slice 0 */
> +               <&main_udmap 0xc303>, /* egress slice 0 */
> +               <&main_udmap 0xc304>, /* egress slice 1 */
> +               <&main_udmap 0xc305>, /* egress slice 1 */
> +               <&main_udmap 0xc306>, /* egress slice 1 */
> +               <&main_udmap 0xc307>, /* egress slice 1 */
> +               <&main_udmap 0x4300>, /* ingress slice 0 */
> +               <&main_udmap 0x4301>; /* ingress slice 1 */
> +        dma-names = "tx0-0", "tx0-1", "tx0-2", "tx0-3",
> +                    "tx1-0", "tx1-1", "tx1-2", "tx1-3",
> +                    "rx0", "rx1";
> +        ti,mii-g-rt = <&icssg2_mii_g_rt>;
> +        interrupt-parent = <&icssg2_intc>;
> +        interrupts = <24 0 2>, <25 1 3>;
> +        interrupt-names = "tx_ts0", "tx_ts1";
> +        ethernet-ports {
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +            pruss2_emac0: port@0 {
> +                reg = <0>;
> +                phy-handle = <&pruss2_eth0_phy>;
> +                phy-mode = "rgmii-id";
> +                interrupts-extended = <&icssg2_intc 24>;
> +                ti,syscon-rgmii-delay = <&scm_conf 0x4120>;
> +                /* Filled in by bootloader */
> +                local-mac-address = [00 00 00 00 00 00];
> +            };
> +
> +            pruss2_emac1: port@1 {
> +                reg = <1>;
> +                phy-handle = <&pruss2_eth1_phy>;
> +                phy-mode = "rgmii-id";
> +                interrupts-extended = <&icssg2_intc 25>;
> +                ti,syscon-rgmii-delay = <&scm_conf 0x4124>;
> +                /* Filled in by bootloader */
> +                local-mac-address = [00 00 00 00 00 00];
> +            };
> +        };
> +    };
> -- 
> 2.25.1
> 
