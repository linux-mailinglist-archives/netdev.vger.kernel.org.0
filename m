Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83E71611E8D
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 02:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiJ2ACG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 20:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiJ2ACE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 20:02:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31C51E3EC2;
        Fri, 28 Oct 2022 17:02:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CAC162AE5;
        Sat, 29 Oct 2022 00:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE6EC433D6;
        Sat, 29 Oct 2022 00:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667001722;
        bh=QnaYasSdM5B/yzLuw3zzoPodRiTLv1KIznsWbl1FuFo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=AC4WYziOq9s7E/21avvWJQFF5vteGPVqa+XruAfA5VI/iHJa5wr/8O+y30Df5sm4Z
         ToUsQLhoxaXnXEhRITDB7smsV5dB5RyIbabak8VOn7RFTQMWv3CXhnB5ZKuBwRUezg
         ESBTQUyro83m4nZQ1rXlpzgF+x4vCmA7nCulUMGRy4ves8G4Y+VG5bHpgLmm/+xlGU
         x24AAx9nky8ZhYTEQ5NNZz3cYJVOgYPFR1COwEEVEcNbMVi0wdMf6+HAURYHn1eghQ
         s1DSCaLG2YKKSJFSmrCoP6G2VQodGhD+bA8J83le9nwV2K2hwE1hISvKQZzwOFWuhO
         xkStkFVhuZaJg==
Message-ID: <8d067556-a6ee-ac6c-3ff1-d3906d9e9899@kernel.org>
Date:   Fri, 28 Oct 2022 20:01:58 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v2 net-next 2/6] dt-bindings: net: mediatek: add WED RX
 binding for MT7986 eth driver
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org, daniel@makrotopia.org
References: <cover.1666549145.git.lorenzo@kernel.org>
 <337ef332ca50e6a40f3fdceeb7262d91165c6323.1666549145.git.lorenzo@kernel.org>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <337ef332ca50e6a40f3fdceeb7262d91165c6323.1666549145.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/10/2022 14:28, Lorenzo Bianconi wrote:
> Document the binding for the RX Wireless Ethernet Dispatch core on the
> MT7986 ethernet driver used to offload traffic received by WLAN NIC and
> forwarded to LAN/WAN one.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Please use scripts/get_maintainers.pl to get a list of necessary people
and lists to CC.  It might happen, that command when run on an older
kernel, gives you outdated entries.  Therefore please be sure you base
your patches on recent Linux kernel.

> ---
>  .../arm/mediatek/mediatek,mt7622-wed.yaml     | 91 +++++++++++++++++++
>  .../arm/mediatek/mediatek,mt7986-wo-boot.yaml | 46 ++++++++++
>  .../arm/mediatek/mediatek,mt7986-wo-ccif.yaml | 49 ++++++++++
>  .../arm/mediatek/mediatek,mt7986-wo-dlm.yaml  | 50 ++++++++++
>  4 files changed, 236 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-boot.yaml
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-ccif.yaml
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-dlm.yaml
> 
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
> index 84fb0a146b6e..8e2905004790 100644
> --- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
> @@ -29,6 +29,41 @@ properties:
>    interrupts:
>      maxItems: 1
>  
> +  memory-region:
> +    minItems: 3

No need for minItems.

> +    maxItems: 3
> +    description:
> +      phandles to nodes describing reserved memory used by mt7986-wed firmware
> +      (see bindings/reserved-memory/reserved-memory.txt)
> +
> +  mediatek,wo-ccif:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      Phandle to the mediatek wed-wo controller.
> +
> +  mediatek,wo-boot:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      Phandle to the mediatek wed-wo boot interface.
> +
> +  mediatek,wo-dlm:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      Phandle to the mediatek wed-wo rx hw ring.
> +
> +allOf:
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: mediatek,mt7986-wed
> +    then:
> +      properties:
> +        mediatek,wo-boot: true
> +        mediatek,wo-ccif: true
> +        mediatek,wo-dlm: true
> +        memory-region: true
> +
>  required:
>    - compatible
>    - reg
> @@ -49,3 +84,59 @@ examples:
>          interrupts = <GIC_SPI 214 IRQ_TYPE_LEVEL_LOW>;
>        };
>      };
> +
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    soc {
> +      #address-cells = <2>;
> +      #size-cells = <2>;
> +      reserved-memory {
> +        #address-cells = <2>;
> +        #size-cells = <2>;
> +
> +        wo_emi: wo-emi@4fd00000 {
> +          reg = <0 0x4fd00000 0 0x40000>;
> +          no-map;
> +        };
> +
> +        wo_data: wo-data@4fd80000 {
> +          reg = <0 0x4fd80000 0 0x240000>;
> +          no-map;
> +        };
> +
> +        wo_ilm: wo-ilm@151e0000 {
> +          reg = <0 0x151e0000 0 0x8000>;
> +          no-map;
> +        };
> +      };
> +
> +      wo_boot: wo-boot@15194000 {
> +        compatible = "mediatek,mt7986-wo-boot","syscon";
> +        reg = <0 0x15194000 0 0x1000>;
> +      };
> +
> +      wo_ccif0: wo-ccif@151a5000 {
> +        compatible = "mediatek,mt7986-wo-ccif","syscon";
> +        reg = <0 0x151a5000 0 0x1000>;
> +        interrupts = <GIC_SPI 211 IRQ_TYPE_LEVEL_HIGH>;
> +      };
> +
> +      wo_dlm0: wo-dlm@151e8000 {
> +        compatible = "mediatek,mt7986-wo-dlm";
> +        reg = <0 0x151e8000 0 0x2000>;
> +        resets = <&ethsysrst 0>;
> +        reset-names = "wocpu_rst";
> +      };
> +
> +      wed1: wed@1020a000 {
> +        compatible = "mediatek,mt7986-wed","syscon";
> +        reg = <0 0x15010000 0 0x1000>;
> +        interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
> +
> +        memory-region = <&wo_emi>, <&wo_data>, <&wo_ilm>;
> +        mediatek,wo-ccif = <&wo_ccif0>;
> +        mediatek,wo-boot = <&wo_boot>;
> +        mediatek,wo-dlm = <&wo_dlm0>;
> +      };
> +    };
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-boot.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-boot.yaml
> new file mode 100644
> index 000000000000..ce9c971e6604
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-boot.yaml
> @@ -0,0 +1,46 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-boot.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title:
> +  MediaTek Wireless Ethernet Dispatch WO boot controller interface for MT7986
> +
> +maintainers:
> +  - Lorenzo Bianconi <lorenzo@kernel.org>
> +  - Felix Fietkau <nbd@nbd.name>
> +
> +description:
> +  The mediatek wo-boot provides a configuration interface for WED WO
> +  boot controller on MT7986 soc.
> +
> +properties:
> +  compatible:
> +    items:
> +      - enum:
> +          - mediatek,mt7986-wo-boot
> +      - const: syscon
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    soc {
> +      #address-cells = <2>;
> +      #size-cells = <2>;
> +      wo_boot: wo-boot@15194000 {
> +        compatible = "mediatek,mt7986-wo-boot","syscon";
> +        reg = <0 0x15194000 0 0x1000>;
> +      };
> +    };
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-ccif.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-ccif.yaml
> new file mode 100644
> index 000000000000..48cb27bcc4cd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-ccif.yaml
> @@ -0,0 +1,49 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-ccif.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"

No improvements...

> +
> +title: MediaTek Wireless Ethernet Dispatch WO Controller for MT7986
> +
> +maintainers:
> +  - Lorenzo Bianconi <lorenzo@kernel.org>
> +  - Felix Fietkau <nbd@nbd.name>
> +
> +description:
> +  The mediatek wo-ccif provides a configuration interface for WED WO
> +  controller on MT7986 soc.
> +
> +properties:
> +  compatible:
> +    items:
> +      - enum:
> +          - mediatek,mt7986-wo-ccif
> +      - const: syscon
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    soc {
> +      #address-cells = <2>;
> +      #size-cells = <2>;
> +      wo_ccif0: wo-ccif@151a5000 {

This is still not entirely generic... What is wo-ccif?


> +        compatible = "mediatek,mt7986-wo-ccif","syscon";

Missing space.

All comments might apply to other places.


Best regards,
Krzysztof

