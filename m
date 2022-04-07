Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8D24F855A
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 18:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345883AbiDGQ6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 12:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbiDGQ6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 12:58:41 -0400
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0F6FFF4F;
        Thu,  7 Apr 2022 09:56:41 -0700 (PDT)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-ddfa38f1c1so6970561fac.11;
        Thu, 07 Apr 2022 09:56:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=57Q8OXO7BdqRA4VCo1CnfvOYS04YZnH8X3yf4O0sei8=;
        b=HbwLDVLCkdE5eAyxGrVglRpyqdWGEnTr5Kl0SG279EM/UNWBv0hHGR30+2sBGVBLY6
         9TwSp+NayucW637R3PEbYoDne4mPoQvllwyyDfdbn0oI/kDqu+3Mvx0RVpo7qwTMe5zY
         5RRhk1bneQt/E9HbrqglwYrsXau99Dy5EYVvc0wtWA74Z7SU24T3IX5vK/2qgT4tSuiz
         NHy7i0VWm7dftwZfzPfUFVDxKwZylv2N8anTPLOBPKBVlGzR8vOT3GzYfOpQRWoVfrr2
         4QHVbgWo0vGOxff2uPW0ju+QSGGCIZ6ucVUh0a7sTThNtJmnHzNtBo4B4liK/T5EUZ/7
         Vt7A==
X-Gm-Message-State: AOAM532jxP58PEHpLuWyuRCM2eh703iAbjGMbaQgcxOpu4hLt6b6xgdt
        PKfk/yVJtaDyfwHWi4iWPw==
X-Google-Smtp-Source: ABdhPJxo1TIbRV2YwAwg/aLoxDI2UrimsMpXZ3Jxi+c84xJ+nsYVYYXxG1PmravHzw8SMpWwncDKHg==
X-Received: by 2002:a05:6870:9712:b0:e1:f96c:f62a with SMTP id n18-20020a056870971200b000e1f96cf62amr6984741oaq.58.1649350600428;
        Thu, 07 Apr 2022 09:56:40 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id u23-20020a056870d59700b000de821ba7cbsm7809576oao.15.2022.04.07.09.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 09:56:40 -0700 (PDT)
Received: (nullmailer pid 1397105 invoked by uid 1000);
        Thu, 07 Apr 2022 16:56:39 -0000
Date:   Thu, 7 Apr 2022 11:56:39 -0500
From:   Rob Herring <robh@kernel.org>
To:     Puranjay Mohan <p-mohan@ti.com>
Cc:     linux-kernel@vger.kernel.org, bjorn.andersson@linaro.org,
        mathieu.poirier@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org,
        nm@ti.com, ssantosh@kernel.org, s-anna@ti.com,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, vigneshr@ti.com,
        kishon@ti.com
Subject: Re: [RFC 12/13] dt-bindings: net: Add ICSSG Ethernet Driver bindings
Message-ID: <Yk8Xx4IRPHkPz+Fn@robh.at.kernel.org>
References: <20220406094358.7895-1-p-mohan@ti.com>
 <20220406094358.7895-13-p-mohan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406094358.7895-13-p-mohan@ti.com>
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

On Wed, Apr 06, 2022 at 03:13:57PM +0530, Puranjay Mohan wrote:
> Add a YAML binding document for the ICSSG Programmable real time unit
> based Ethernet driver. This driver uses the PRU and PRUSS consumer APIs
> to interface the PRUs and load/run the firmware for supporting ethernet
> functionality.
> 
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> ---
>  .../bindings/net/ti,icssg-prueth.yaml         | 172 ++++++++++++++++++
>  1 file changed, 172 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> new file mode 100644
> index 000000000000..8b8acb69e43e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> @@ -0,0 +1,172 @@
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
> +  Ethernet based on the Programmable Real-Time Unit and Industrial Communication Subsystem.
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
> +    description: |
> +      list of phandles and specifiers to UDMA as specified in bindings/dma/ti/k3-udma.txt.

How many?

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

Is there a minimum and maximum number? Is it really so variable?

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
> +      port@[0-1]:

fooport@0bar would be valid here.

'^port@[0-1]$'


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
> +    description: |
> +      Interrupt specifiers to TX timestamp IRQ.

How many?

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
> +                compatible = "ti,am654-icssg-prueth";
> +                pinctrl-names = "default";
> +                pinctrl-0 = <&icssg2_rgmii_pins_default>;
> +                sram = <&msmc_ram>;
> +
> +                ti,prus = <&pru2_0>, <&rtu2_0>, <&tx_pru2_0>, <&pru2_1>, <&rtu2_1>, <&tx_pru2_1>;
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
> +                       <&main_udmap 0x4301>, /* ingress slice 1 */
> +                       <&main_udmap 0x4302>, /* mgmnt rsp slice 0 */
> +                       <&main_udmap 0x4303>; /* mgmnt rsp slice 1 */
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
