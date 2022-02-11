Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B9D4B2B42
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 18:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351896AbiBKRFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 12:05:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233562AbiBKRFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 12:05:15 -0500
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE042E8;
        Fri, 11 Feb 2022 09:05:14 -0800 (PST)
Received: by mail-qk1-f174.google.com with SMTP id w8so8796927qkw.8;
        Fri, 11 Feb 2022 09:05:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A0rsxyCKiEPTG/yOoCpeNt/bjbfTqQzLZ284uO4r9hw=;
        b=Bz/puL50spzk9UNrbQG6bSfsP9pknmd15C9aRtUNmp0TiNN0CJx+VQJU3YvznrHCh0
         MiNcdGSkVLE/N3MKIYBxuRpG7Udvv+fgSyu/0AFJxjbc+NICAr0g4dJiyRt2qKZGspEn
         UL2nHYTHw9mOGGs1YhG+ptTDmRM+6BLrZCEtOUwpylD5aWZpTFMaCSARQp3PnCn8l3qc
         h38mxTpl/RBYJTH28zdc5jdlMIP1vInoHNrLKPo3nm6oTVXp9zi0enCHuhfRJxmFNRht
         WIGNdv+U2M5WfONrjo0mmFnNows/dyLTwoWEwCa+VjtwxHlrMuBFwIMrSKFNJ8R8kMnF
         Ys/w==
X-Gm-Message-State: AOAM531PygbC+WkZU4JHoETLDfSGm/+CHEwjLJGQCvOD2kys5cQLT8VC
        61lRktPRo/k+c8S/xPmWnQ==
X-Google-Smtp-Source: ABdhPJyL0niGFbJu1UNkqwv2jHojuHZH8sLOcu5Sjz8Cagoxul79VxkeT7NryBFMG7nqlregF4M2Qg==
X-Received: by 2002:a37:9443:: with SMTP id w64mr1246729qkd.545.1644599113088;
        Fri, 11 Feb 2022 09:05:13 -0800 (PST)
Received: from robh.at.kernel.org ([2607:fb90:5fee:dfce:b6df:c3e1:b1e5:d6d8])
        by smtp.gmail.com with ESMTPSA id h1sm12171190qkn.71.2022.02.11.09.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 09:05:12 -0800 (PST)
Received: (nullmailer pid 526578 invoked by uid 1000);
        Fri, 11 Feb 2022 17:05:09 -0000
Date:   Fri, 11 Feb 2022 11:05:09 -0600
From:   Rob Herring <robh@kernel.org>
To:     Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
Cc:     appana.durga.rao@xilinx.com, naga.sureshkumar.relli@xilinx.com,
        wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, git@xilinx.com, michal.simek@xilinx.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: can: xilinx_can: Convert Xilinx CAN
 binding to YAML
Message-ID: <YgaXReRxU/uAhEP7@robh.at.kernel.org>
References: <20220209174850.32360-1-amit.kumar-mahapatra@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209174850.32360-1-amit.kumar-mahapatra@xilinx.com>
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

On Wed, Feb 09, 2022 at 11:18:50PM +0530, Amit Kumar Mahapatra wrote:
> Convert Xilinx CAN binding documentation to YAML.
> 
> Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
> ---
> BRANCH: yaml
> 
> Changes in v2:
>  - Added reference to can-controller.yaml
>  - Added example node for canfd-2.0
> ---
>  .../bindings/net/can/xilinx_can.txt           |  61 -------
>  .../bindings/net/can/xilinx_can.yaml          | 160 ++++++++++++++++++
>  2 files changed, 160 insertions(+), 61 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.txt
>  create mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/can/xilinx_can.txt b/Documentation/devicetree/bindings/net/can/xilinx_can.txt
> deleted file mode 100644
> index 100cc40b8510..000000000000
> --- a/Documentation/devicetree/bindings/net/can/xilinx_can.txt
> +++ /dev/null
> @@ -1,61 +0,0 @@
> -Xilinx Axi CAN/Zynq CANPS controller Device Tree Bindings
> ----------------------------------------------------------
> -
> -Required properties:
> -- compatible		: Should be:
> -			  - "xlnx,zynq-can-1.0" for Zynq CAN controllers
> -			  - "xlnx,axi-can-1.00.a" for Axi CAN controllers
> -			  - "xlnx,canfd-1.0" for CAN FD controllers
> -			  - "xlnx,canfd-2.0" for CAN FD 2.0 controllers
> -- reg			: Physical base address and size of the controller
> -			  registers map.
> -- interrupts		: Property with a value describing the interrupt
> -			  number.
> -- clock-names		: List of input clock names
> -			  - "can_clk", "pclk" (For CANPS),
> -			  - "can_clk", "s_axi_aclk" (For AXI CAN and CAN FD).
> -			  (See clock bindings for details).
> -- clocks		: Clock phandles (see clock bindings for details).
> -- tx-fifo-depth		: Can Tx fifo depth (Zynq, Axi CAN).
> -- rx-fifo-depth		: Can Rx fifo depth (Zynq, Axi CAN, CAN FD in
> -                          sequential Rx mode).
> -- tx-mailbox-count	: Can Tx mailbox buffer count (CAN FD).
> -- rx-mailbox-count	: Can Rx mailbox buffer count (CAN FD in mailbox Rx
> -			  mode).
> -
> -
> -Example:
> -
> -For Zynq CANPS Dts file:
> -	zynq_can_0: can@e0008000 {
> -			compatible = "xlnx,zynq-can-1.0";
> -			clocks = <&clkc 19>, <&clkc 36>;
> -			clock-names = "can_clk", "pclk";
> -			reg = <0xe0008000 0x1000>;
> -			interrupts = <0 28 4>;
> -			interrupt-parent = <&intc>;
> -			tx-fifo-depth = <0x40>;
> -			rx-fifo-depth = <0x40>;
> -		};
> -For Axi CAN Dts file:
> -	axi_can_0: axi-can@40000000 {
> -			compatible = "xlnx,axi-can-1.00.a";
> -			clocks = <&clkc 0>, <&clkc 1>;
> -			clock-names = "can_clk","s_axi_aclk" ;
> -			reg = <0x40000000 0x10000>;
> -			interrupt-parent = <&intc>;
> -			interrupts = <0 59 1>;
> -			tx-fifo-depth = <0x40>;
> -			rx-fifo-depth = <0x40>;
> -		};
> -For CAN FD Dts file:
> -	canfd_0: canfd@40000000 {
> -			compatible = "xlnx,canfd-1.0";
> -			clocks = <&clkc 0>, <&clkc 1>;
> -			clock-names = "can_clk", "s_axi_aclk";
> -			reg = <0x40000000 0x2000>;
> -			interrupt-parent = <&intc>;
> -			interrupts = <0 59 1>;
> -			tx-mailbox-count = <0x20>;
> -			rx-fifo-depth = <0x20>;
> -		};
> diff --git a/Documentation/devicetree/bindings/net/can/xilinx_can.yaml b/Documentation/devicetree/bindings/net/can/xilinx_can.yaml
> new file mode 100644
> index 000000000000..50ff9b40fe87
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/xilinx_can.yaml
> @@ -0,0 +1,160 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/can/xilinx_can.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title:
> +  Xilinx Axi CAN/Zynq CANPS controller Binding
> +
> +maintainers:
> +  - Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - const: xlnx,zynq-can-1.0
> +        description: For Zynq CAN controller
> +      - const: xlnx,axi-can-1.00.a
> +        description: For Axi CAN controller
> +      - const: xlnx,canfd-1.0
> +        description: For CAN FD controller
> +      - const: xlnx,canfd-2.0
> +        description: For CAN FD 2.0 controller
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  clocks:
> +    description: |
> +      CAN functional clock phandle

Drop.

> +    maxItems: 2

> +
> +  tx-fifo-depth:
> +    description: |
> +      CAN Tx fifo depth (Zynq, Axi CAN).
> +
> +  rx-fifo-depth:
> +    description: |
> +      CAN Rx fifo depth (Zynq, Axi CAN, CAN FD in sequential Rx mode)
> +
> +  tx-mailbox-count:
> +    description: |
> +      CAN Tx mailbox buffer count (CAN FD)
> +
> +  rx-mailbox-count:
> +    description: |
> +      CAN Rx mailbox buffer count (CAN FD in mailbox Rx  mode)

All these need a type $ref.

> +
> +  clock-names:
> +    maxItems: 2

Group with 'clocks'.

> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +  - clock-names
> +
> +additionalProperties: false
> +
> +allOf:
> +  - $ref: can-controller.yaml#
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: xlnx,zynq-can-1.0
> +
> +    then:
> +      properties:
> +        clock-names:
> +          items:
> +            - const: can_clk
> +            - const: pclk
> +      required:
> +        - tx-fifo-depth
> +        - rx-fifo-depth
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: xlnx,axi-can-1.00.a
> +
> +    then:
> +      properties:
> +        clock-names:
> +          items:
> +            - const: can_clk
> +            - const: s_axi_aclk
> +      required:
> +        - tx-fifo-depth
> +        - rx-fifo-depth
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            anyOf:
> +              - const: xlnx,canfd-1.0
> +              - const: xlnx,canfd-2.0
> +
> +    then:
> +      properties:
> +        clock-names:
> +          items:
> +            - const: can_clk
> +            - const: s_axi_aclk
> +      required:
> +        - tx-mailbox-count
> +        - rx-fifo-depth
> +
> +examples:
> +  - |
> +    zynq_can_0: can@e0008000 {

Drop unused labels.

> +        compatible = "xlnx,zynq-can-1.0";
> +        clocks = <&clkc 19>, <&clkc 36>;
> +        clock-names = "can_clk", "pclk";
> +        reg = <0xe0008000 0x1000>;
> +        interrupts = <0 28 4>;
> +        interrupt-parent = <&intc>;
> +        tx-fifo-depth = <0x40>;
> +        rx-fifo-depth = <0x40>;
> +    };
> +  - |
> +    axi_can_0: can@40000000 {
> +        compatible = "xlnx,axi-can-1.00.a";
> +        clocks = <&clkc 0>, <&clkc 1>;
> +        clock-names = "can_clk","s_axi_aclk" ;
> +        reg = <0x40000000 0x10000>;
> +        interrupt-parent = <&intc>;
> +        interrupts = <0 59 1>;
> +        tx-fifo-depth = <0x40>;
> +        rx-fifo-depth = <0x40>;
> +    };
> +  - |
> +    canfd_0: can@40000000 {
> +        compatible = "xlnx,canfd-1.0";
> +        clocks = <&clkc 0>, <&clkc 1>;
> +        clock-names = "can_clk", "s_axi_aclk";
> +        reg = <0x40000000 0x2000>;
> +        interrupt-parent = <&intc>;
> +        interrupts = <0 59 1>;
> +        tx-mailbox-count = <0x20>;
> +        rx-fifo-depth = <0x20>;
> +    };
> +  - |
> +    canfd_1: can@ff060000 {
> +        compatible = "xlnx,canfd-2.0";
> +        clocks = <&clkc 0>, <&clkc 1>;
> +        clock-names = "can_clk", "s_axi_aclk";
> +        reg = <0xff060000 0x6000>;
> +        interrupt-parent = <&intc>;
> +        interrupts = <0 59 1>;
> +        tx-mailbox-count = <0x20>;
> +        rx-fifo-depth = <0x40>;
> +    };
> -- 
> 2.17.1
> 
> 
