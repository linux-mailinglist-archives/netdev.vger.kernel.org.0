Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB2B5FE380
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 22:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiJMUwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 16:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJMUwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 16:52:06 -0400
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7316030569;
        Thu, 13 Oct 2022 13:52:05 -0700 (PDT)
Received: by mail-oi1-f182.google.com with SMTP id j188so3067073oih.4;
        Thu, 13 Oct 2022 13:52:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+6eUBPj7f3lX67jMMfG6u5oR6lO2uaq6WkfouGNFxrA=;
        b=1wDfvJR26bya4nw+hG7nZwiZkQIgNhGoL/7yJ1RAouzIR269pPVFqDu1P/robbLUe6
         C1zKO6b0h5+vDyv9otmi4JPLgF0tHYJ/xAZ0IikLUYBVXdj9OcGS2ckK3OT99tY1MmSy
         hrygW4QUtb7dGwhM9voojiPT4/HP9XjuLgdHtJJ8kK2Aw5AiLryN9LHSBumQlJlf+tif
         NtodtbMQmfOTY9b78wKQzcTgjn+9wMpG8EJnrML6P5QE8OlXpKPZXM6IR6LxdRNCNnoS
         pGcedFZzVvDRuaGaHqqCEyE4OtgeqIhvOIuP5o3P/WEpRbFTYkbv5QpbnzIqN57Aga3A
         6xzQ==
X-Gm-Message-State: ACrzQf0BgqDkDt9eZk7NRVVFr7GL86SkbZBrPdj3FQVBTrST5/6tMm+N
        hVRQrVne7Gd+BrOrlujSDQ==
X-Google-Smtp-Source: AMsMyM4X3hvuuMQbnctaBL/Ei/QH+/IsIINQdWZuM91sUU89CyVhCKhQbqVVN4KSOH+UbnQZmi/Z7g==
X-Received: by 2002:a05:6808:d46:b0:350:cba9:1981 with SMTP id w6-20020a0568080d4600b00350cba91981mr5558218oik.130.1665694324575;
        Thu, 13 Oct 2022 13:52:04 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id s23-20020a056870631700b00132f141ef2dsm459964oao.56.2022.10.13.13.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 13:52:03 -0700 (PDT)
Received: (nullmailer pid 197172 invoked by uid 1000);
        Thu, 13 Oct 2022 20:52:04 -0000
Date:   Thu, 13 Oct 2022 15:52:04 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?Q?Micha=C5=82?= Grzelak <mig@semihalf.com>
Cc:     devicetree@vger.kernel.org, mw@semihalf.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        upstream@semihalf.com
Subject: Re: [PATCH v4 1/3] dt-bindings: net: marvell,pp2: convert to
 json-schema
Message-ID: <20221013205204.GA184111-robh@kernel.org>
References: <20221013165134.78234-1-mig@semihalf.com>
 <20221013165134.78234-2-mig@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221013165134.78234-2-mig@semihalf.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 06:51:32PM +0200, Michał Grzelak wrote:
> Convert the marvell,pp2 bindings from text to proper schema.
> 
> Move 'marvell,system-controller' and 'dma-coherent' properties from
> port up to the controller node, to match what is actually done in DT.
> 
> Rename all subnodes to match "^(ethernet-)?port@[0-9]+$" and deprecate
> port-id in favour of 'reg'.
> 
> Signed-off-by: Michał Grzelak <mig@semihalf.com>
> ---
>  .../devicetree/bindings/net/marvell,pp2.yaml  | 288 ++++++++++++++++++
>  .../devicetree/bindings/net/marvell-pp2.txt   | 141 ---------
>  MAINTAINERS                                   |   2 +-
>  3 files changed, 289 insertions(+), 142 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/marvell,pp2.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/marvell-pp2.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/marvell,pp2.yaml b/Documentation/devicetree/bindings/net/marvell,pp2.yaml
> new file mode 100644
> index 000000000000..c4b27338d740
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/marvell,pp2.yaml
> @@ -0,0 +1,288 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/marvell,pp2.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Marvell CN913X / Marvell Armada 375, 7K, 8K Ethernet Controller
> +
> +maintainers:
> +  - Marcin Wojtas <mw@semihalf.com>
> +  - Russell King <linux@armlinux.org>
> +
> +description: |
> +  Marvell Armada 375 Ethernet Controller (PPv2.1)
> +  Marvell Armada 7K/8K Ethernet Controller (PPv2.2)
> +  Marvell CN913X Ethernet Controller (PPv2.3)
> +
> +properties:
> +  compatible:
> +    enum:
> +      - marvell,armada-375-pp2
> +      - marvell,armada-7k-pp22
> +
> +  reg:
> +    minItems: 3
> +    maxItems: 4
> +
> +  "#address-cells":
> +    const: 1
> +
> +  "#size-cells":
> +    const: 0
> +
> +  clocks:
> +    minItems: 2
> +    items:
> +      - description: main controller clock
> +      - description: GOP clock
> +      - description: MG clock
> +      - description: MG Core clock
> +      - description: AXI clock
> +
> +  clock-names:
> +    minItems: 2
> +    items:
> +      - const: pp_clk
> +      - const: gop_clk
> +      - const: mg_clk
> +      - const: mg_core_clk
> +      - const: axi_clk
> +
> +  dma-coherent: true
> +
> +  marvell,system-controller:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description: a phandle to the system controller.
> +
> +patternProperties:
> +  '^(ethernet-)?port@[0-9]+$':

unit-addresses are hex. Though if there are 10 ports, then drop the '+'.

> +    type: object
> +    description: subnode for each ethernet port.
> +    $ref: ethernet-controller.yaml#
> +    unevaluatedProperties: false
> +
> +    properties:
> +      reg:
> +        $ref: /schemas/types.yaml#/definitions/uint32

'reg' is standard property and already has a type, so drop. But you 
should add:

maximum: 9

(assuming the range is 0-9)

> +        description: ID of the port from the MAC point of view.
> +
> +      interrupts:
> +        minItems: 1
> +        maxItems: 10
> +        description: interrupt(s) for the port
> +
> +      interrupt-names:
> +        minItems: 1
> +        items:
> +          - const: hif0
> +          - const: hif1
> +          - const: hif2
> +          - const: hif3
> +          - const: hif4
> +          - const: hif5
> +          - const: hif6
> +          - const: hif7
> +          - const: hif8
> +          - const: link
> +
> +        description: >
> +          if more than a single interrupt for is given, must be the
> +          name associated to the interrupts listed. Valid names are:
> +          "hifX", with X in [0..8], and "link". The names "tx-cpu0",
> +          "tx-cpu1", "tx-cpu2", "tx-cpu3" and "rx-shared" are supported
> +          for backward compatibility but shouldn't be used for new
> +          additions.
> +
> +      phys:
> +        $ref: /schemas/phy/phy-consumer.yaml#/properties/phys

Don't need a type. Need to define how many entries and what each one is 
if more than 1. For 1, just 'maxItems: 1'.

> +        description: Generic PHY, providing serdes lanes.
> +
> +      port-id:
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        deprecated: true
> +        description: >
> +          ID of the port from the MAC point of view.
> +          Legacy binding for backward compatibility.
> +
> +      marvell,loopback:
> +        $ref: /schemas/types.yaml#/definitions/flag
> +        description: port is loopback mode.
> +
> +      gop-port-id:
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        description: >
> +          only for marvell,armada-7k-pp22, ID of the port from the
> +          GOP (Group Of Ports) point of view. This ID is used to index the
> +          per-port registers in the second register area.
> +
> +    required:
> +      - reg
> +      - interrupts
> +      - port-id
> +      - phy-mode

Presumably the h/w doesn't support every possible mode listed in 
ethernet-controller.yaml, so you should limit it in this binding.

> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - clock-names
> +
> +allOf:
> +  - if:
> +      properties:
> +        compatible:
> +          const: marvell,armada-7k-pp22
> +    then:
> +      properties:
> +        reg:
> +          items:
> +            - description: Packet Processor registers
> +            - description: Networking interfaces registers
> +            - description: CM3 address space used for TX Flow Control
> +
> +        clocks:
> +          minItems: 5
> +
> +        clock-names:
> +          minItems: 5
> +
> +      patternProperties:
> +        '^(ethernet-)?port@[0-9]+$':
> +          required:
> +            - gop-port-id
> +
> +      required:
> +        - marvell,system-controller
> +    else:
> +      properties:
> +        reg:
> +          items:
> +            - description: Packet Processor registers
> +            - description: LMS registers
> +            - description: Register area per eth0
> +            - description: Register area per eth1
> +
> +        clocks:
> +          maxItems: 2
> +
> +        clock-names:
> +          maxItems: 2
> +
> +      patternProperties:
> +        '^(ethernet-)?port@[0-9]+$':
> +          properties:
> +            gop-port-id: false
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    // For Armada 375 variant
> +    #include <dt-bindings/interrupt-controller/mvebu-icu.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    ethernet@f0000 {
> +      #address-cells = <1>;

Use 4 space indentation for examples.

> +      #size-cells = <0>;
> +      compatible = "marvell,armada-375-pp2";
> +      reg = <0xf0000 0xa000>,
> +            <0xc0000 0x3060>,
> +            <0xc4000 0x100>,
> +            <0xc5000 0x100>;
> +      clocks = <&gateclk 3>, <&gateclk 19>;
> +      clock-names = "pp_clk", "gop_clk";
> +
> +      ethernet-port@0 {
> +        interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
> +        reg = <0>;
> +        port-id = <0>; /* For backward compatibility. */
> +        phy = <&phy0>;
> +        phy-mode = "rgmii-id";
> +      };
> +
> +      ethernet-port@1 {
> +        interrupts = <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
> +        reg = <1>;
> +        port-id = <1>; /* For backward compatibility. */
> +        phy = <&phy3>;
> +        phy-mode = "gmii";
> +      };
> +    };
> +
> +  - |
> +    // For Armada 7k/8k and Cn913x variants
> +    #include <dt-bindings/interrupt-controller/mvebu-icu.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    ethernet@0 {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +      compatible = "marvell,armada-7k-pp22";
> +      reg = <0x0 0x100000>, <0x129000 0xb000>, <0x220000 0x800>;
> +      clocks = <&cp0_clk 1 3>, <&cp0_clk 1 9>,
> +               <&cp0_clk 1 5>, <&cp0_clk 1 6>, <&cp0_clk 1 18>;
> +      clock-names = "pp_clk", "gop_clk", "mg_clk", "mg_core_clk", "axi_clk";
> +      marvell,system-controller = <&cp0_syscon0>;
> +
> +      ethernet-port@0 {
> +        interrupts = <ICU_GRP_NSR 39 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 43 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 47 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 51 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 55 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 59 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 63 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 67 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 71 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 129 IRQ_TYPE_LEVEL_HIGH>;
> +        interrupt-names = "hif0", "hif1", "hif2", "hif3", "hif4",
> +                          "hif5", "hif6", "hif7", "hif8", "link";
> +        phy-mode = "10gbase-r";
> +        phys = <&cp0_comphy4 0>;
> +        reg = <0>;
> +        port-id = <0>; /* For backward compatibility. */
> +        gop-port-id = <0>;
> +      };
> +
> +      ethernet-port@1 {
> +        interrupts = <ICU_GRP_NSR 40 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 44 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 48 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 52 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 56 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 60 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 64 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 68 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 72 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 128 IRQ_TYPE_LEVEL_HIGH>;
> +        interrupt-names = "hif0", "hif1", "hif2", "hif3", "hif4",
> +                          "hif5", "hif6", "hif7", "hif8", "link";
> +        phy-mode = "rgmii-id";
> +        reg = <1>;
> +        port-id = <1>; /* For backward compatibility. */
> +        gop-port-id = <2>;
> +      };
> +
> +      ethernet-port@2 {
> +        interrupts = <ICU_GRP_NSR 41 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 45 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 49 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 53 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 57 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 61 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 65 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 69 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 73 IRQ_TYPE_LEVEL_HIGH>,
> +                     <ICU_GRP_NSR 127 IRQ_TYPE_LEVEL_HIGH>;
> +        interrupt-names = "hif0", "hif1", "hif2", "hif3", "hif4",
> +                          "hif5", "hif6", "hif7", "hif8", "link";
> +        phy-mode = "2500base-x";
> +        managed = "in-band-status";
> +        phys = <&cp0_comphy5 2>;
> +        sfp = <&sfp_eth3>;
> +        reg = <2>;
> +        port-id = <2>; /* For backward compatibility. */
> +        gop-port-id = <3>;
> +      };
> +    };
