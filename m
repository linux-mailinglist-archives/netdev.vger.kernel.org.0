Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 875A260D764
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 00:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbiJYWww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 18:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbiJYWwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 18:52:50 -0400
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4106A2AB4;
        Tue, 25 Oct 2022 15:52:48 -0700 (PDT)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-13be3ef361dso5334386fac.12;
        Tue, 25 Oct 2022 15:52:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vG/lM5Scm6C9fOjiqfUwMglRna/2JcnpcVVOfgMSFA8=;
        b=olCjmLfJzbRfBXfq37NiKrcBsXljjtDNLHug9VvhPMC8vdS3PMVoolfqw1jSP9Lo3G
         aC1gHUera6n09znBDfgK7EFXuHLUciRZ+UiEGAjvBf4dcJ9oPZ1tBa1C+nT8vjpfvb4o
         UswJXpFHXy26RPn1ksSGY8mJlpzB3bDtEN4ZTjlkkYZTnVmUvKsH6Dx+Ef3m0r8QZ/6k
         Zysoq7C+NfLtKVwxe5xxtwK9/IuYrk3jPcJK3XBoB3BwIwaT2/wlEcLWWv/Ej/vxQiNJ
         Ui1bnQL/cZ2nJPQmyST/X4tNA50A6K9FFAt4RpoPaYaNPq3IVoXHA2IF4mjpCdS2VjPm
         LMQg==
X-Gm-Message-State: ACrzQf11RREkmAEQ8+xslqvwbt8ZjUPF5TxPvWezG0030xUpNdCP5jJs
        lJ/qyCaSEUAFZ9Sq80RPpg==
X-Google-Smtp-Source: AMsMyM7uqt69DYPo5oMYk1VBEOnMyfPkaQavwbL3DqnR48ZxOmOrmki3NBlMxEca4YIAYU4wk/sTMw==
X-Received: by 2002:a05:6870:8306:b0:13c:c80:6cbd with SMTP id p6-20020a056870830600b0013c0c806cbdmr405081oae.68.1666738368011;
        Tue, 25 Oct 2022 15:52:48 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id eo33-20020a056870eca100b0010d5d5c3fc3sm2300105oab.8.2022.10.25.15.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:52:47 -0700 (PDT)
Received: (nullmailer pid 3412950 invoked by uid 1000);
        Tue, 25 Oct 2022 22:52:48 -0000
Date:   Tue, 25 Oct 2022 17:52:48 -0500
From:   Rob Herring <robh@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, daniel@makrotopia.org
Subject: Re: [PATCH v2 net-next 2/6] dt-bindings: net: mediatek: add WED RX
 binding for MT7986 eth driver
Message-ID: <20221025225248.GA3405306-robh@kernel.org>
References: <cover.1666549145.git.lorenzo@kernel.org>
 <337ef332ca50e6a40f3fdceeb7262d91165c6323.1666549145.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <337ef332ca50e6a40f3fdceeb7262d91165c6323.1666549145.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 23, 2022 at 08:28:06PM +0200, Lorenzo Bianconi wrote:
> Document the binding for the RX Wireless Ethernet Dispatch core on the
> MT7986 ethernet driver used to offload traffic received by WLAN NIC and
> forwarded to LAN/WAN one.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
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
> +    maxItems: 3

What is each entry? Need to define them.

> +    description:
> +      phandles to nodes describing reserved memory used by mt7986-wed firmware
> +      (see bindings/reserved-memory/reserved-memory.txt)

What does that document say?

(You don't need generic descriptions/refs of common properties)

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

This does nothing. You need the opposite? Disallow these properties for 
7622?

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

Why a new example? 
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

Don't need to show /reserved-memory in examples.

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

Don't really need to show these either. You already have them in their 
own schemas and we don't need 2 examples.

Didn't I already say this?

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
> +        compatible = "mediatek,mt7986-wo-ccif","syscon";
> +        reg = <0 0x151a5000 0 0x1000>;
> +        interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
> +      };
> +    };
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-dlm.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-dlm.yaml
> new file mode 100644
> index 000000000000..db9252598a42
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-dlm.yaml
> @@ -0,0 +1,50 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-dlm.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: MediaTek Wireless Ethernet Dispatch WO hw rx ring interface for MT7986
> +
> +maintainers:
> +  - Lorenzo Bianconi <lorenzo@kernel.org>
> +  - Felix Fietkau <nbd@nbd.name>
> +
> +description:
> +  The mediatek wo-dlm provides a configuration interface for WED WO
> +  rx ring on MT7986 soc.
> +
> +properties:
> +  compatible:
> +    const: mediatek,mt7986-wo-dlm
> +
> +  reg:
> +    maxItems: 1
> +
> +  resets:
> +    maxItems: 1
> +
> +  reset-names:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - resets
> +  - reset-names
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    soc {
> +      #address-cells = <2>;
> +      #size-cells = <2>;
> +
> +      wo_dlm0: wo-dlm@151e8000 {
> +        compatible = "mediatek,mt7986-wo-dlm";
> +        reg = <0 0x151e8000 0 0x2000>;
> +        resets = <&ethsysrst 0>;
> +        reset-names = "wocpu_rst";
> +      };
> +    };
> -- 
> 2.37.3
> 
> 
