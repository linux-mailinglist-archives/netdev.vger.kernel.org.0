Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE14616696
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 16:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiKBPzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 11:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiKBPzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 11:55:16 -0400
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E752A70A;
        Wed,  2 Nov 2022 08:55:15 -0700 (PDT)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-13bef14ea06so20781416fac.3;
        Wed, 02 Nov 2022 08:55:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yJ1KZl0ZYc/PrtcTl/Fww5oSZQKJLFHM3K8L6B34cyE=;
        b=I+jgkY50nGGGiKvDIqg7J16AkJZQ+fDOOl+DS9atTCDBz7dKyd5AU3wC4XgR/1NWJQ
         TJrGfcnjGXuVoZ1o8HMQzLZAUBEKhDt+Wqlt9joC3YCvVsGsJIaJE15ZMAt1p0SF28MQ
         NcZLGk7yNqWOpGwQLs8xRP7G0nYkKvHgwcquMG1ui/Z7KGgM81q+Wgr0X02ywvkqTrj0
         qL6a1VBTdAf3Mw49Oy892Ge534cx9JqtLc4a8Qv3P3oWkM/82TP4XXbO3/1xYVtgYhyr
         ahH5TFDZm4T672gU7tnXMlTLrJEidUmHZJGHSchWLEpy+VNXY2exl9YNdwDWoVF8jQ60
         xNwQ==
X-Gm-Message-State: ACrzQf0G3RmTuDnFt2GReaSV/Gte13WfCsNynvNooHDugsIPQYRXy2IE
        pIxWIXO2LzTRGVzGovHNzzl5rW/PUw==
X-Google-Smtp-Source: AMsMyM4LwZ2d362JfSyWE2VV84DHCTsXjxNndMKAs7+hYnf4wxDIyBeFSuwLteaivZOdl1GYTKgAYQ==
X-Received: by 2002:a05:6870:738c:b0:13b:981a:29f7 with SMTP id z12-20020a056870738c00b0013b981a29f7mr25810730oam.230.1667404514174;
        Wed, 02 Nov 2022 08:55:14 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id y7-20020a056808130700b00359ba124b07sm3213874oiv.36.2022.11.02.08.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 08:55:13 -0700 (PDT)
Received: (nullmailer pid 3966054 invoked by uid 1000);
        Wed, 02 Nov 2022 15:55:15 -0000
Date:   Wed, 2 Nov 2022 10:55:15 -0500
From:   Rob Herring <robh@kernel.org>
To:     Chester Lin <clin@suse.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jan Petrous <jan.petrous@nxp.com>, netdev@vger.kernel.org,
        s32@nxp.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Matthias Brugger <mbrugger@suse.com>
Subject: Re: [PATCH 2/5] dt-bindings: net: add schema for NXP S32CC dwmac
 glue driver
Message-ID: <20221102155515.GA3959603-robh@kernel.org>
References: <20221031101052.14956-1-clin@suse.com>
 <20221031101052.14956-3-clin@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031101052.14956-3-clin@suse.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 06:10:49PM +0800, Chester Lin wrote:
> Add the DT schema for the DWMAC Ethernet controller on NXP S32 Common
> Chassis.
> 
> Signed-off-by: Jan Petrous <jan.petrous@nxp.com>
> Signed-off-by: Chester Lin <clin@suse.com>
> ---
>  .../bindings/net/nxp,s32cc-dwmac.yaml         | 145 ++++++++++++++++++
>  1 file changed, 145 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml b/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
> new file mode 100644
> index 000000000000..f6b8486f9d42
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
> @@ -0,0 +1,145 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +# Copyright 2021-2022 NXP
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/net/nxp,s32cc-dwmac.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: NXP S32CC DWMAC Ethernet controller
> +
> +maintainers:
> +  - Jan Petrous <jan.petrous@nxp.com>
> +  - Chester Lin <clin@suse.com>
> +
> +select:

Don't need this.

> +  properties:
> +    compatible:
> +      contains:
> +        enum:
> +          - nxp,s32cc-dwmac
> +  required:
> +    - compatible
> +
> +allOf:
> +  - $ref: "snps,dwmac.yaml#"
> +
> +properties:
> +  compatible:
> +    contains:

Drop 'contains'.

> +      enum:
> +        - nxp,s32cc-dwmac
> +
> +  reg:
> +    items:
> +      - description: Main GMAC registers
> +      - description: S32 MAC control registers
> +
> +  dma-coherent:
> +    description:
> +      Declares GMAC device as DMA coherent

Don't need a generic description. Just 'true' is enough.

> +
> +  clocks:
> +    items:
> +      - description: Main GMAC clock
> +      - description: Peripheral registers clock
> +      - description: Transmit SGMII clock
> +      - description: Transmit RGMII clock
> +      - description: Transmit RMII clock
> +      - description: Transmit MII clock
> +      - description: Receive SGMII clock
> +      - description: Receive RGMII clock
> +      - description: Receive RMII clock
> +      - description: Receive MII clock
> +      - description:
> +          PTP reference clock. This clock is used for programming the
> +          Timestamp Addend Register. If not passed then the system
> +          clock will be used.

If optional, then you need 'minItems'.

> +
> +  clock-names:
> +    items:
> +      - const: stmmaceth
> +      - const: pclk
> +      - const: tx_sgmii
> +      - const: tx_rgmii
> +      - const: tx_rmii
> +      - const: tx_mii
> +      - const: rx_sgmii
> +      - const: rx_rgmii
> +      - const: rx_rmii
> +      - const: rx_mii
> +      - const: ptp_ref
> +
> +  tx-fifo-depth:
> +    const: 20480
> +
> +  rx-fifo-depth:
> +    const: 20480
> +
> +required:
> +  - compatible
> +  - reg
> +  - tx-fifo-depth
> +  - rx-fifo-depth
> +  - clocks
> +  - clock-names
> +
> +additionalProperties: true

'true' is only allowed for common, incomplete schemas. Should be:

unevaluatedProperties: false

> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +
> +    #define S32GEN1_SCMI_CLK_GMAC0_AXI
> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_SGMII
> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_RGMII
> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_RMII
> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_MII
> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_SGMII
> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_RGMII
> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_RMII
> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_MII
> +    #define S32GEN1_SCMI_CLK_GMAC0_TS
> +
> +    soc {
> +      #address-cells = <1>;
> +      #size-cells = <1>;
> +
> +      gmac0: ethernet@4033c000 {
> +        compatible = "nxp,s32cc-dwmac";
> +        reg = <0x4033c000 0x2000>, /* gmac IP */
> +              <0x4007C004 0x4>;    /* S32 CTRL_STS reg */
> +        interrupt-parent = <&gic>;
> +        interrupts = <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>;
> +        interrupt-names = "macirq";
> +        phy-mode = "rgmii-id";
> +        tx-fifo-depth = <20480>;
> +        rx-fifo-depth = <20480>;
> +        dma-coherent;
> +        clocks = <&clks S32GEN1_SCMI_CLK_GMAC0_AXI>,
> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_AXI>,
> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_TX_SGMII>,
> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_TX_RGMII>,
> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_TX_RMII>,
> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_TX_MII>,
> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_RX_SGMII>,
> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_RX_RGMII>,
> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_RX_RMII>,
> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_RX_MII>,
> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_TS>;
> +        clock-names = "stmmaceth", "pclk",
> +                      "tx_sgmii", "tx_rgmii", "tx_rmii", "tx_mii",
> +                      "rx_sgmii", "rx_rgmii", "rx_rmii", "rx_mii",
> +                      "ptp_ref";
> +
> +        gmac0_mdio: mdio {
> +          #address-cells = <1>;
> +          #size-cells = <0>;
> +          compatible = "snps,dwmac-mdio";
> +
> +          ethernet-phy@4 {
> +            reg = <0x04>;
> +          };
> +        };
> +      };
> +    };
> -- 
> 2.37.3
> 
> 
