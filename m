Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A75B55EECB
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiF1UFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 16:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234477AbiF1UDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 16:03:42 -0400
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29993DA77;
        Tue, 28 Jun 2022 12:55:37 -0700 (PDT)
Received: by mail-il1-f170.google.com with SMTP id f15so8413996ilj.11;
        Tue, 28 Jun 2022 12:55:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LX7czNIIECaWcTmLUpIGX+lZtnHxfK8JNdAd9YjZVdg=;
        b=Ha6O5LMWso2Nmyrrw3D40bEhU5eMF3/4oO9YPp67yLPIGEJ2Ht9BFjvDC/9xascrqT
         4wHv/dVEhB1IxPdk3guyuuIthNOXBgeHzHrDTwBmjbaJ6h3Pv2ITAUPy2i1BxfyNh9hW
         k57WZjhhx1NFd3bQ9zpEWnms7D0OLMXXXWOKU9Z51HjUhiAWMcziPcyFdSJ6m5VCfJo+
         xIxc8umi2tioAbcbLLDtewjxpavz9hI9y3LO7VIUxLhlFG95WcMSNOv37tc13gfWFxOJ
         +B5wDkU+c5QEa1EhmfFcKsToy9gySAhtc4JcOgPallxzNTHjrOjsIp2/YS9loOSIFhVg
         wdqw==
X-Gm-Message-State: AJIora+uxGPTl8GxtrkFxAPoEkpAnTVCKn0Bsvh3aKsZ3nlCHGirTcch
        FdhX8SsdHjLkpHmZUj+o0A==
X-Google-Smtp-Source: AGRyM1ulObrciZ3EEVmkYx33s1pxZUaVWGOp+9HAVczVUBhN85O/CsOo4LXlBucDqzHRnXUE2QwiFg==
X-Received: by 2002:a05:6e02:1be1:b0:2da:70ee:dde8 with SMTP id y1-20020a056e021be100b002da70eedde8mr11493265ilv.7.1656446136793;
        Tue, 28 Jun 2022 12:55:36 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id t15-20020a92b10f000000b002d3ad9791dcsm6017212ilh.27.2022.06.28.12.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:55:36 -0700 (PDT)
Received: (nullmailer pid 878199 invoked by uid 1000);
        Tue, 28 Jun 2022 19:55:34 -0000
Date:   Tue, 28 Jun 2022 13:55:34 -0600
From:   Rob Herring <robh@kernel.org>
To:     Bhadram Varka <vbhadram@nvidia.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, krzysztof.kozlowski+dt@linaro.org,
        thierry.reding@gmail.com, jonathanh@nvidia.com, kuba@kernel.org,
        catalin.marinas@arm.com, will@kernel.org
Subject: Re: [PATCH net-next v1 5/9] dt-bindings: net: Add Tegra234 MGBE
Message-ID: <20220628195534.GA868640-robh@kernel.org>
References: <20220623074615.56418-1-vbhadram@nvidia.com>
 <20220623074615.56418-5-vbhadram@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623074615.56418-5-vbhadram@nvidia.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 01:16:11PM +0530, Bhadram Varka wrote:
> Add device-tree binding documentation for the Tegra234 MGBE ethernet
> controller.
> 
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
> ---
>  .../bindings/net/nvidia,tegra234-mgbe.yaml    | 163 ++++++++++++++++++
>  1 file changed, 163 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml b/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
> new file mode 100644
> index 000000000000..d6db43e60ab8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
> @@ -0,0 +1,163 @@
> +# SPDX-License-Identifier: GPL-2.0

Dual license. checkpatch.pl will tell you this.

> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Tegra234 MGBE Device Tree Bindings

s/Device Tree Bindings/???bit Ethernet Controller/

> +
> +maintainers:
> +  - Thierry Reding <treding@nvidia.com>
> +  - Jon Hunter <jonathanh@nvidia.com>
> +
> +properties:
> +
> +  compatible:
> +    const: nvidia,tegra234-mgbe
> +
> +  reg:
> +    minItems: 3
> +    maxItems: 3
> +
> +  reg-names:
> +    items:
> +      - const: hypervisor
> +      - const: mac
> +      - const: xpcs

Is this really part of the same block? You don't have a PHY (the one in 
front of the ethernet PHY) and PCS is sometimes part of the PHY.

> +
> +  interrupts:
> +    minItems: 1
> +
> +  interrupt-names:
> +    items:
> +      - const: common

Just drop interrupt-names. Not a useful name really.

> +
> +  clocks:
> +    minItems: 12
> +    maxItems: 12
> +
> +  clock-names:
> +    minItems: 12
> +    maxItems: 12
> +    contains:
> +      enum:
> +        - mgbe
> +        - mac
> +        - mac-divider
> +        - ptp-ref
> +        - rx-input-m
> +        - rx-input
> +        - tx
> +        - eee-pcs
> +        - rx-pcs-input
> +        - rx-pcs-m
> +        - rx-pcs
> +        - tx-pcs
> +
> +  resets:
> +    minItems: 2
> +    maxItems: 2
> +
> +  reset-names:
> +    contains:
> +      enum:
> +        - mac
> +        - pcs
> +
> +  interconnects:
> +    items:
> +      - description: memory read client
> +      - description: memory write client
> +
> +  interconnect-names:
> +    items:
> +      - const: dma-mem # read
> +      - const: write
> +
> +  iommus:
> +    maxItems: 1
> +
> +  power-domains:
> +    items:
> +      - description: MGBE power-domain

What else would it be? Just 'maxItems: 1'.

> +
> +  phy-handle: true
> +
> +  phy-mode: true

All possible modes are supported by this h/w? Not likely.

> +
> +  mdio:
> +    $ref: mdio.yaml#
> +    unevaluatedProperties: false
> +    description:
> +      Creates and registers an MDIO bus.

That's OS behavior...

> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - interrupt-names
> +  - clocks
> +  - clock-names
> +  - resets
> +  - reset-names
> +  - power-domains
> +  - phy-handle
> +  - phy-mode
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/tegra234-clock.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/memory/tegra234-mc.h>
> +    #include <dt-bindings/power/tegra234-powergate.h>
> +    #include <dt-bindings/reset/tegra234-reset.h>
> +
> +    ethernet@6800000 {
> +        compatible = "nvidia,tegra234-mgbe";
> +        reg = <0x06800000 0x10000>,
> +              <0x06810000 0x10000>,
> +              <0x068a0000 0x10000>;
> +        reg-names = "hypervisor", "mac", "xpcs";
> +        interrupts = <GIC_SPI 384 IRQ_TYPE_LEVEL_HIGH>;
> +        interrupt-names = "common";
> +        clocks = <&bpmp TEGRA234_CLK_MGBE0_APP>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_MAC>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_MAC_DIVIDER>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_PTP_REF>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_RX_INPUT_M>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_RX_INPUT>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_TX>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_EEE_PCS>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_RX_PCS_INPUT>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_RX_PCS_M>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_RX_PCS>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_TX_PCS>;
> +        clock-names = "mgbe", "mac", "mac-divider", "ptp-ref", "rx-input-m",
> +                      "rx-input", "tx", "eee-pcs", "rx-pcs-input", "rx-pcs-m",
> +                      "rx-pcs", "tx-pcs";
> +        resets = <&bpmp TEGRA234_RESET_MGBE0_MAC>,
> +                 <&bpmp TEGRA234_RESET_MGBE0_PCS>;
> +        reset-names = "mac", "pcs";
> +        interconnects = <&mc TEGRA234_MEMORY_CLIENT_MGBEARD &emc>,
> +                        <&mc TEGRA234_MEMORY_CLIENT_MGBEAWR &emc>;
> +        interconnect-names = "dma-mem", "write";
> +        iommus = <&smmu_niso0 TEGRA234_SID_MGBE>;
> +        power-domains = <&bpmp TEGRA234_POWER_DOMAIN_MGBEA>;
> +
> +        phy-handle = <&mgbe0_phy>;
> +        phy-mode = "usxgmii";
> +
> +        mdio {
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +            mgbe0_phy: phy@0 {
> +                compatible = "ethernet-phy-ieee802.3-c45";
> +                reg = <0x0>;
> +
> +                #phy-cells = <0>;
> +            };
> +        };
> +    };
> -- 
> 2.17.1
> 
> 
