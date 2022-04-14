Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 016C2501482
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 17:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346350AbiDNO0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 10:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240224AbiDNOGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 10:06:19 -0400
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04FA38D83;
        Thu, 14 Apr 2022 07:00:43 -0700 (PDT)
Received: by mail-ot1-f45.google.com with SMTP id o20-20020a9d7194000000b005cb20cf4f1bso3428126otj.7;
        Thu, 14 Apr 2022 07:00:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OVJJMcvi6JtQDfLcdJN9K2xGxH+weojEfOQqVYGUrBI=;
        b=7I6Ig1ngvKAhKL7xIbuiu5PwuUcKvDL99dtysEoXqHmUuKynHv1Fq2r+z76aQzh3pg
         P86Pb6Y/LGRwbQ+KBtF1+jZqq11EZFwA10Kd4c+ZTz9TL+E+v1tvcUkUhhl78ahlDR0G
         TONHE9nztk5cXExcrglylVHkhUqEfyeCS2UT51sdtNpiZ2P8GJuCmrQD9Nd4pMBIH8Gt
         N83YK1M4msogDQ/riSWqh/gmdL/4737aSaKkTidQ1kiqLv8oe4Oz3RzQ+IO8vnMfQl+H
         ouZQC9n0gYKNlA9vxe4F9PyxnW2Zy+/59dm2TzjkAGMD5L4ZW+mcGnQ6zpxMDwBAft6L
         XxNA==
X-Gm-Message-State: AOAM5314ZVrT6vFVPU7b3UREynu+Y+JTkFYK1Y6yGVYuywOn+8krHGww
        aPxl3X6ZIlYBVCJIPw5vTA==
X-Google-Smtp-Source: ABdhPJwK9KXjR3mMzr/SSjUxxf88ISMPfN+JXchxOvxDFBDIh/SVFnow5jZBjl2dYKe8gE/S4s8Jzg==
X-Received: by 2002:a05:6830:805:b0:5c9:2cce:2644 with SMTP id r5-20020a056830080500b005c92cce2644mr956633ots.104.1649944841243;
        Thu, 14 Apr 2022 07:00:41 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id 14-20020aca0f0e000000b003222ac151eesm36939oip.1.2022.04.14.07.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 07:00:40 -0700 (PDT)
Received: (nullmailer pid 1908273 invoked by uid 1000);
        Thu, 14 Apr 2022 14:00:40 -0000
Date:   Thu, 14 Apr 2022 09:00:40 -0500
From:   Rob Herring <robh@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, lorenzo.bianconi@redhat.com,
        devicetree@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, john@phrozen.org
Subject: Re: [PATCH net-next] dt-bindings: net: mediatek,net: convert to the
 json-schema
Message-ID: <YlgpCN0hmCvGK6ey@robh.at.kernel.org>
References: <a01e3acda892ea0dd46edad024d91f213a9db27c.1649931322.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a01e3acda892ea0dd46edad024d91f213a9db27c.1649931322.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 12:19:28PM +0200, Lorenzo Bianconi wrote:
> This patch converts the existing mediatek-net.txt binding file
> in yaml format.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  .../devicetree/bindings/net/mediatek,net.yaml | 294 ++++++++++++++++++
>  .../devicetree/bindings/net/mediatek-net.txt  | 108 -------
>  2 files changed, 294 insertions(+), 108 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/mediatek,net.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/mediatek-net.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/mediatek,net.yaml b/Documentation/devicetree/bindings/net/mediatek,net.yaml
> new file mode 100644
> index 000000000000..6c7696a5b8e7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/mediatek,net.yaml
> @@ -0,0 +1,294 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/mediatek,net.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: MediaTek Frame Engine Ethernet controller
> +
> +maintainers:
> +  - Lorenzo Bianconi <lorenzo@kernel.org>
> +  - Felix Fietkau <nbd@nbd.name>
> +
> +description:
> +  The frame engine ethernet controller can be found on MediaTek SoCs. These SoCs
> +  have dual GMAC ports.
> +
> +properties:
> +  compatible:
> +    enum:
> +      - mediatek,mt2701-eth
> +      - mediatek,mt7623-eth
> +      - mediatek,mt7622-eth
> +      - mediatek,mt7629-eth
> +      - ralink,rt5350-eth
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    minItems: 3
> +    maxItems: 3
> +
> +  power-domains:
> +    maxItems: 1
> +
> +  resets:
> +    maxItems: 1

Is it 1 reset or...

> +
> +  reset-names:
> +    items:
> +      - const: fe
> +      - const: gmac
> +      - const: ppe

... 3 resets?

> +
> +  mediatek,ethsys:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      Phandle to the syscon node that handles the port setup.
> +
> +  cci-control-port: true
> +
> +  mediatek,hifsys:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      Phandle to the mediatek hifsys controller used to provide various clocks
> +      and reset to the system.
> +
> +  dma-coherent: true
> +
> +  mdio-bus:
> +    $ref: mdio.yaml#
> +    unevaluatedProperties: false
> +
> +  "#address-cells":
> +    const: 1
> +
> +  "#size-cells":
> +    const: 0
> +
> +allOf:
> +  - $ref: "ethernet-controller.yaml#"
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - mediatek,mt2701-eth
> +              - mediatek,mt7623-eth
> +    then:
> +      properties:
> +        clocks:
> +          minItems: 4
> +          maxItems: 4
> +
> +        clock-names:
> +          additionalItems: false
> +          items:
> +            - const: ethif
> +            - const: esw
> +            - const: gp1
> +            - const: gp2
> +
> +        mediatek,pctl:
> +          $ref: /schemas/types.yaml#/definitions/phandle
> +          description:
> +            Phandle to the syscon node that handles the ports slew rate and
> +            driver current.
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: mediatek,mt7622-eth
> +    then:
> +      properties:
> +        clocks:
> +          minItems: 11
> +          maxItems: 11
> +
> +        clock-names:
> +          additionalItems: false
> +          items:
> +            - const: ethif
> +            - const: esw
> +            - const: gp0
> +            - const: gp1
> +            - const: gp2
> +            - const: sgmii_tx250m
> +            - const: sgmii_rx250m
> +            - const: sgmii_cdr_ref
> +            - const: sgmii_cdr_fb
> +            - const: sgmii_ck
> +            - const: eth2pll
> +
> +        mediatek,sgmiisys:
> +          $ref: /schemas/types.yaml#/definitions/phandle-array
> +          maxItems: 1
> +          description:
> +            A list of phandle to the syscon node that handles the SGMII setup which is required for
> +            those SoCs equipped with SGMII.
> +
> +        mediatek,wed:
> +          $ref: /schemas/types.yaml#/definitions/phandle-array
> +          minItems: 2
> +          maxItems: 2
> +          description:
> +            List of phandles to wireless ethernet dispatch nodes.
> +
> +        mediatek,pcie-mirror:
> +          $ref: /schemas/types.yaml#/definitions/phandle
> +          description:
> +            Phandle to the mediatek pcie-mirror controller.
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: mediatek,mt7629-eth
> +    then:
> +      properties:
> +        clocks:
> +          minItems: 17
> +          maxItems: 17
> +
> +        clock-names:
> +          additionalItems: false
> +          items:
> +            - const: ethif
> +            - const: sgmiitop
> +            - const: esw
> +            - const: gp0
> +            - const: gp1
> +            - const: gp2
> +            - const: fe
> +            - const: sgmii_tx250m
> +            - const: sgmii_rx250m
> +            - const: sgmii_cdr_ref
> +            - const: sgmii_cdr_fb
> +            - const: sgmii2_tx250m
> +            - const: sgmii2_rx250m
> +            - const: sgmii2_cdr_ref
> +            - const: sgmii2_cdr_fb
> +            - const: sgmii_ck
> +            - const: eth2pll
> +
> +        mediatek,infracfg:
> +          $ref: /schemas/types.yaml#/definitions/phandle
> +          description:
> +            Phandle to the syscon node that handles the path from GMAC to
> +            PHY variants.
> +
> +        mediatek,sgmiisys:
> +          $ref: /schemas/types.yaml#/definitions/phandle-array
> +          maxItems: 2
> +          description:
> +            A list of phandle to the syscon node that handles the SGMII setup which is required for
> +            those SoCs equipped with SGMII.
> +
> +patternProperties:
> +  "^mac@[0-1]$":
> +    type: object
> +    additionalProperties: false
> +    allOf:
> +      - $ref: ethernet-controller.yaml#
> +    description:
> +      Ethernet MAC node
> +    properties:
> +      compatible:
> +        const: mediatek,eth-mac
> +
> +      reg:
> +        maxItems: 1
> +
> +      phy-handle: true
> +
> +      phy-mode: true
> +
> +    required:
> +      - reg
> +      - compatible
> +      - phy-handle
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +  - clock-names
> +  - power-domains
> +  - mediatek,ethsys
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    #include <dt-bindings/clock/mt7622-clk.h>
> +    #include <dt-bindings/power/mt7622-power.h>
> +
> +    soc {
> +      #address-cells = <2>;
> +      #size-cells = <2>;
> +
> +      ethernet: ethernet@1b100000 {
> +        compatible = "mediatek,mt7622-eth";
> +        reg = <0 0x1b100000 0 0x20000>;
> +        interrupts = <GIC_SPI 223 IRQ_TYPE_LEVEL_LOW>,
> +                     <GIC_SPI 224 IRQ_TYPE_LEVEL_LOW>,
> +                     <GIC_SPI 225 IRQ_TYPE_LEVEL_LOW>;
> +        clocks = <&topckgen CLK_TOP_ETH_SEL>,
> +                 <&ethsys CLK_ETH_ESW_EN>,
> +                 <&ethsys CLK_ETH_GP0_EN>,
> +                 <&ethsys CLK_ETH_GP1_EN>,
> +                 <&ethsys CLK_ETH_GP2_EN>,
> +                 <&sgmiisys CLK_SGMII_TX250M_EN>,
> +                 <&sgmiisys CLK_SGMII_RX250M_EN>,
> +                 <&sgmiisys CLK_SGMII_CDR_REF>,
> +                 <&sgmiisys CLK_SGMII_CDR_FB>,
> +                 <&topckgen CLK_TOP_SGMIIPLL>,
> +                 <&apmixedsys CLK_APMIXED_ETH2PLL>;
> +        clock-names = "ethif", "esw", "gp0", "gp1", "gp2",
> +                      "sgmii_tx250m", "sgmii_rx250m",
> +                      "sgmii_cdr_ref", "sgmii_cdr_fb", "sgmii_ck",
> +                      "eth2pll";
> +        power-domains = <&scpsys MT7622_POWER_DOMAIN_ETHSYS>;
> +        mediatek,ethsys = <&ethsys>;
> +        mediatek,sgmiisys = <&sgmiisys>;
> +        cci-control = <&cci_control2>;

Doesn't match the schema. Did you test this? I didn't because it doesn't 
apply to rc1.

> +        mediatek,pcie-mirror = <&pcie_mirror>;
> +        mediatek,hifsys = <&hifsys>;
> +        dma-coherent;
> +
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        mdio0: mdio-bus {
> +          #address-cells = <1>;
> +          #size-cells = <0>;
> +
> +          phy0: ethernet-phy@0 {
> +            reg = <0>;
> +          };
> +
> +          phy1: ethernet-phy@1 {
> +            reg = <1>;
> +          };
> +        };
> +
> +        gmac0: mac@0 {
> +          compatible = "mediatek,eth-mac";
> +          phy-mode = "rgmii";
> +          phy-handle = <&phy0>;
> +          reg = <0>;
> +        };
> +
> +        gmac1: mac@1 {
> +          compatible = "mediatek,eth-mac";
> +          phy-mode = "rgmii";
> +          phy-handle = <&phy1>;
> +          reg = <1>;
> +        };
> +      };
> +    };
> diff --git a/Documentation/devicetree/bindings/net/mediatek-net.txt b/Documentation/devicetree/bindings/net/mediatek-net.txt
> deleted file mode 100644
> index f18d70189375..000000000000
> --- a/Documentation/devicetree/bindings/net/mediatek-net.txt
> +++ /dev/null
> @@ -1,108 +0,0 @@
> -MediaTek Frame Engine Ethernet controller
> -=========================================
> -
> -The frame engine ethernet controller can be found on MediaTek SoCs. These SoCs
> -have dual GMAC each represented by a child node..
> -
> -* Ethernet controller node
> -
> -Required properties:
> -- compatible: Should be
> -		"mediatek,mt2701-eth": for MT2701 SoC
> -		"mediatek,mt7623-eth", "mediatek,mt2701-eth": for MT7623 SoC
> -		"mediatek,mt7622-eth": for MT7622 SoC
> -		"mediatek,mt7629-eth": for MT7629 SoC
> -		"ralink,rt5350-eth": for Ralink Rt5350F and MT7628/88 SoC
> -- reg: Address and length of the register set for the device
> -- interrupts: Should contain the three frame engines interrupts in numeric
> -	order. These are fe_int0, fe_int1 and fe_int2.
> -- clocks: the clock used by the core
> -- clock-names: the names of the clock listed in the clocks property. These are
> -	"ethif", "esw", "gp2", "gp1" : For MT2701 and MT7623 SoC
> -        "ethif", "esw", "gp0", "gp1", "gp2", "sgmii_tx250m", "sgmii_rx250m",
> -	"sgmii_cdr_ref", "sgmii_cdr_fb", "sgmii_ck", "eth2pll" : For MT7622 SoC
> -	"ethif", "sgmiitop", "esw", "gp0", "gp1", "gp2", "fe", "sgmii_tx250m",
> -	"sgmii_rx250m", "sgmii_cdr_ref", "sgmii_cdr_fb", "sgmii2_tx250m",
> -	"sgmii2_rx250m", "sgmii2_cdr_ref", "sgmii2_cdr_fb", "sgmii_ck",
> -	"eth2pll" : For MT7629 SoC.
> -- power-domains: phandle to the power domain that the ethernet is part of
> -- resets: Should contain phandles to the ethsys reset signals
> -- reset-names: Should contain the names of reset signal listed in the resets
> -		property
> -		These are "fe", "gmac" and "ppe"
> -- mediatek,ethsys: phandle to the syscon node that handles the port setup
> -- mediatek,infracfg: phandle to the syscon node that handles the path from
> -	GMAC to PHY variants, which is required for MT7629 SoC.
> -- mediatek,sgmiisys: a list of phandles to the syscon node that handles the
> -	SGMII setup which is required for those SoCs equipped with SGMII such
> -	as MT7622 and MT7629 SoC. And MT7622 have only one set of SGMII shared
> -	by GMAC1 and GMAC2; MT7629 have two independent sets of SGMII directed
> -	to GMAC1 and GMAC2, respectively.
> -- mediatek,pctl: phandle to the syscon node that handles the ports slew rate
> -	and driver current: only for MT2701 and MT7623 SoC
> -
> -Optional properties:
> -- dma-coherent: present if dma operations are coherent
> -- mediatek,cci-control: phandle to the cache coherent interconnect node
> -- mediatek,hifsys: phandle to the mediatek hifsys controller used to provide
> -	various clocks and reset to the system.
> -- mediatek,wed: a list of phandles to wireless ethernet dispatch nodes for
> -	MT7622 SoC.
> -- mediatek,pcie-mirror: phandle to the mediatek pcie-mirror controller for
> -	MT7622 SoC.
> -
> -* Ethernet MAC node
> -
> -Required properties:
> -- compatible: Should be "mediatek,eth-mac"
> -- reg: The number of the MAC
> -- phy-handle: see ethernet.txt file in the same directory and
> -	the phy-mode "trgmii" required being provided when reg
> -	is equal to 0 and the MAC uses fixed-link to connect
> -	with internal switch such as MT7530.
> -
> -Example:
> -
> -eth: ethernet@1b100000 {
> -	compatible = "mediatek,mt7623-eth";
> -	reg = <0 0x1b100000 0 0x20000>;
> -	clocks = <&topckgen CLK_TOP_ETHIF_SEL>,
> -		 <&ethsys CLK_ETHSYS_ESW>,
> -		 <&ethsys CLK_ETHSYS_GP2>,
> -		 <&ethsys CLK_ETHSYS_GP1>;
> -	clock-names = "ethif", "esw", "gp2", "gp1";
> -	interrupts = <GIC_SPI 200 IRQ_TYPE_LEVEL_LOW
> -		      GIC_SPI 199 IRQ_TYPE_LEVEL_LOW
> -		      GIC_SPI 198 IRQ_TYPE_LEVEL_LOW>;
> -	power-domains = <&scpsys MT2701_POWER_DOMAIN_ETH>;
> -	resets = <&ethsys MT2701_ETHSYS_ETH_RST>;
> -	reset-names = "eth";
> -	mediatek,ethsys = <&ethsys>;
> -	mediatek,pctl = <&syscfg_pctl_a>;
> -	#address-cells = <1>;
> -	#size-cells = <0>;
> -
> -	gmac1: mac@0 {
> -		compatible = "mediatek,eth-mac";
> -		reg = <0>;
> -		phy-handle = <&phy0>;
> -	};
> -
> -	gmac2: mac@1 {
> -		compatible = "mediatek,eth-mac";
> -		reg = <1>;
> -		phy-handle = <&phy1>;
> -	};
> -
> -	mdio-bus {
> -		phy0: ethernet-phy@0 {
> -			reg = <0>;
> -			phy-mode = "rgmii";
> -		};
> -
> -		phy1: ethernet-phy@1 {
> -			reg = <1>;
> -			phy-mode = "rgmii";
> -		};
> -	};
> -};
> -- 
> 2.35.1
> 
> 
