Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B3B3D14A1
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbhGUQM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 12:12:29 -0400
Received: from mail-il1-f181.google.com ([209.85.166.181]:39722 "EHLO
        mail-il1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbhGUQM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 12:12:28 -0400
Received: by mail-il1-f181.google.com with SMTP id a7so2870982iln.6;
        Wed, 21 Jul 2021 09:53:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2FlplugSms0lq9vlT6qVeAF/xOXlsmB/xXx4Xh3GmPg=;
        b=qEYugqIGuohbcrLlpQUA+XEvyBUaxaTs3jqG3qNgzY4O0ITwcTfGsCHNk9A6HkHNYR
         3XOxiPQAMszyz7Bt4AAvBb4yORX4GqyidwLSY+JJ4O2cIf/+rr0LTsELXLdch/At+wB/
         HeZoTak2BtNN5401lO7tE1bGD8Cet3L+8u+GrwyCC4oxarcy04EFNjOcqeWxI4ShAxlN
         4Nnn8kq935+cQ81WhLbLSzgQuis4b6XWFYSGlu3OZ8EZI7vOQ+ibM7RAz+day4QJWGuC
         /qjD23Q3Q1OOmoTPnONGSD1vhv4Z+JzXoP1G8yhMSNs+tX5NwHkcAlvZpA3Biqgab4Tl
         Qj2A==
X-Gm-Message-State: AOAM5324p6nGdDjnZXvjFOdjx+Hi5xkibt3SvyGmY1pKnJFj/wLxI2bS
        IplbwnCzI8xlI+TS+5uigA==
X-Google-Smtp-Source: ABdhPJyBGw8BgX6Ut+AjXB1gavWfI+GdQEOaA4ld3jRnJ/IyC+2yOdS5D+jM8xTQoVX/cB9CQhftLw==
X-Received: by 2002:a92:d112:: with SMTP id a18mr20234016ilb.67.1626886383904;
        Wed, 21 Jul 2021 09:53:03 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id b25sm14700743ios.36.2021.07.21.09.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 09:53:03 -0700 (PDT)
Received: (nullmailer pid 2433823 invoked by uid 1000);
        Wed, 21 Jul 2021 16:53:00 -0000
Date:   Wed, 21 Jul 2021 10:53:00 -0600
From:   Rob Herring <robh@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, festevam@gmail.com, kernel@pengutronix.de,
        linux-imx@nxp.com, peppe.cavallaro@st.com, joabreu@synopsys.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next V1 2/3] dt-bindings: net: imx-dwmac: convert
 imx-dwmac bindings to yaml
Message-ID: <20210721165300.GA2430128@robh.at.kernel.org>
References: <20210719071821.31583-1-qiangqing.zhang@nxp.com>
 <20210719071821.31583-3-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719071821.31583-3-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 03:18:20PM +0800, Joakim Zhang wrote:
> In order to automate the verification of DT nodes covert imx-dwmac to
> nxp,dwmac-imx.yaml, and pass below checking.
> 
> $ make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- dt_binding_check DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
> $ make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- dtbs_check DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
> 
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  .../devicetree/bindings/net/imx-dwmac.txt     | 56 -----------
>  .../bindings/net/nxp,dwmac-imx.yaml           | 93 +++++++++++++++++++
>  2 files changed, 93 insertions(+), 56 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/imx-dwmac.txt
>  create mode 100644 Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/imx-dwmac.txt b/Documentation/devicetree/bindings/net/imx-dwmac.txt
> deleted file mode 100644
> index 921d522fe8d7..000000000000
> --- a/Documentation/devicetree/bindings/net/imx-dwmac.txt
> +++ /dev/null
> @@ -1,56 +0,0 @@
> -IMX8 glue layer controller, NXP imx8 families support Synopsys MAC 5.10a IP.
> -
> -This file documents platform glue layer for IMX.
> -Please see stmmac.txt for the other unchanged properties.
> -
> -The device node has following properties.
> -
> -Required properties:
> -- compatible:  Should be "nxp,imx8mp-dwmac-eqos" to select glue layer
> -	       and "snps,dwmac-5.10a" to select IP version.
> -- clocks: Must contain a phandle for each entry in clock-names.
> -- clock-names: Should be "stmmaceth" for the host clock.
> -	       Should be "pclk" for the MAC apb clock.
> -	       Should be "ptp_ref" for the MAC timer clock.
> -	       Should be "tx" for the MAC RGMII TX clock:
> -	       Should be "mem" for EQOS MEM clock.
> -		- "mem" clock is required for imx8dxl platform.
> -		- "mem" clock is not required for imx8mp platform.
> -- interrupt-names: Should contain a list of interrupt names corresponding to
> -		   the interrupts in the interrupts property, if available.
> -		   Should be "macirq" for the main MAC IRQ
> -		   Should be "eth_wake_irq" for the IT which wake up system
> -- intf_mode: Should be phandle/offset pair. The phandle to the syscon node which
> -	     encompases the GPR register, and the offset of the GPR register.
> -		- required for imx8mp platform.
> -		- is optional for imx8dxl platform.
> -
> -Optional properties:
> -- intf_mode: is optional for imx8dxl platform.
> -- snps,rmii_refclk_ext: to select RMII reference clock from external.
> -
> -Example:
> -	eqos: ethernet@30bf0000 {
> -		compatible = "nxp,imx8mp-dwmac-eqos", "snps,dwmac-5.10a";
> -		reg = <0x30bf0000 0x10000>;
> -		interrupts = <GIC_SPI 134 IRQ_TYPE_LEVEL_HIGH>,
> -			     <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH>;
> -		interrupt-names = "eth_wake_irq", "macirq";
> -		clocks = <&clk IMX8MP_CLK_ENET_QOS_ROOT>,
> -			 <&clk IMX8MP_CLK_QOS_ENET_ROOT>,
> -			 <&clk IMX8MP_CLK_ENET_QOS_TIMER>,
> -			 <&clk IMX8MP_CLK_ENET_QOS>;
> -		clock-names = "stmmaceth", "pclk", "ptp_ref", "tx";
> -		assigned-clocks = <&clk IMX8MP_CLK_ENET_AXI>,
> -				  <&clk IMX8MP_CLK_ENET_QOS_TIMER>,
> -				  <&clk IMX8MP_CLK_ENET_QOS>;
> -		assigned-clock-parents = <&clk IMX8MP_SYS_PLL1_266M>,
> -					 <&clk IMX8MP_SYS_PLL2_100M>,
> -					 <&clk IMX8MP_SYS_PLL2_125M>;
> -		assigned-clock-rates = <0>, <100000000>, <125000000>;
> -		nvmem-cells = <&eth_mac0>;
> -		nvmem-cell-names = "mac-address";
> -		nvmem_macaddr_swap;
> -		intf_mode = <&gpr 0x4>;
> -		status = "disabled";
> -	};
> diff --git a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
> new file mode 100644
> index 000000000000..5629b2e4ccf8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
> @@ -0,0 +1,93 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/nxp,dwmac-imx.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: NXP i.MX8 DWMAC glue layer Device Tree Bindings
> +
> +maintainers:
> +  - Joakim Zhang <qiangqing.zhang@nxp.com>
> +
> +# We need a select here so we don't match all nodes with 'snps,dwmac'
> +select:
> +  properties:
> +    compatible:
> +      contains:
> +        enum:
> +          - nxp,imx8mp-dwmac-eqos
> +          - nxp,imx8dxl-dwmac-eqos
> +  required:
> +    - compatible
> +
> +allOf:
> +  - $ref: "snps,dwmac.yaml#"
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - items:

Don't need 'oneOf' as there is only one entry.

> +          - enum:
> +              - nxp,imx8mp-dwmac-eqos
> +              - nxp,imx8dxl-dwmac-eqos
> +          - const: snps,dwmac-5.10a
> +
> +  clocks:
> +    minItems: 3
> +    maxItems: 5
> +    items:
> +      - description: MAC host clock
> +      - description: MAC apb clock
> +      - description: MAC timer clock
> +      - description: MAC RGMII TX clock
> +      - description: EQOS MEM clock
> +
> +  clock-names:
> +    minItems: 3
> +    maxItems: 5
> +    contains:

s/contains/items/

But really, like the other one, can't you define the order?

> +      enum:
> +        - stmmaceth
> +        - pclk
> +        - ptp_ref
> +        - tx
> +        - mem
> +
> +  intf_mode:
> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> +    description:
> +      Should be phandle/offset pair. The phandle to the syscon node which
> +      encompases the GPR register, and the offset of the GPR register.

Sounds like 2 cells:

maxItems: 2

> +
> +  snps,rmii_refclk_ext:
> +    $ref: /schemas/types.yaml#/definitions/flag
> +    description:
> +      To select RMII reference clock from external.
> +
> +required:
> +  - compatible
> +  - clocks
> +  - clock-names
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    #include <dt-bindings/clock/imx8mp-clock.h>
> +
> +    eqos: ethernet@30bf0000 {
> +            compatible = "nxp,imx8mp-dwmac-eqos","snps,dwmac-5.10a";
> +            reg = <0x30bf0000 0x10000>;
> +            interrupts = <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 134 IRQ_TYPE_LEVEL_HIGH>;
> +            interrupt-names = "macirq", "eth_wake_irq";
> +            clocks = <&clk IMX8MP_CLK_ENET_QOS_ROOT>,
> +                     <&clk IMX8MP_CLK_QOS_ENET_ROOT>,
> +                     <&clk IMX8MP_CLK_ENET_QOS_TIMER>,
> +                     <&clk IMX8MP_CLK_ENET_QOS>;
> +            clock-names = "stmmaceth", "pclk", "ptp_ref", "tx";
> +            phy-mode = "rgmii";
> +            status = "disabled";

Why are you disabling your example? Drop.

> +    };
> -- 
> 2.17.1
> 
> 
