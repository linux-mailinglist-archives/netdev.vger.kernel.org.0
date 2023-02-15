Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2A0698707
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 22:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjBOVJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 16:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjBOVJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 16:09:03 -0500
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1DB4C27;
        Wed, 15 Feb 2023 13:07:48 -0800 (PST)
Received: by mail-ot1-f51.google.com with SMTP id e12-20020a0568301e4c00b0068bc93e7e34so46152otj.4;
        Wed, 15 Feb 2023 13:07:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ACXVCP2Nz0t94MyXD0VgkPCtOTirt4h7S8UZxA7gzko=;
        b=7+YHF2hp7WXgScA5PnjUcRh6DKfWoHCclbnVyeGLvGCWqQlIjBJSR9kPby/j5mjRvi
         nvzQPrCUjcq1Z6LilOYBz40lOIPEP9xHvmqCFZ9NOMRPmgvbzsjkflLyWrVBDRoYEVZR
         xx/IZbx6sA0qRWMokrlRrVEA68GjAibThDoavgpKrZUiptqRNWxZ0mDK+Y1NWFzh5YMB
         zfRRytnl/nQDyHV+8nvBHSJUIZi5bjCblB7Wz0tTO5kj/iNqIfv0Tk4cb6ex6rt13FKs
         xbaveon3+Eb3rH4e7RmtiWmLOui/+OZSORIdTW0DbGl5NnOp/VnZC2rWZkXGneFSAhGN
         pz8w==
X-Gm-Message-State: AO0yUKU+wqEGej1rsE0VmBOumb+PuCMp23WBn4UCxEi/dVyUTnKnUlKH
        gOZjq/udd9xan8OdW4wExm3iDxfzCw==
X-Google-Smtp-Source: AK7set8nu4Bd81ga9Ubuve+TR7XEKtYN0Cik76DAf/5sGr49KQGfEY9nwfU1J3WBilDHRSo3ZTlLEQ==
X-Received: by 2002:a05:6830:113:b0:690:bf1e:9eef with SMTP id i19-20020a056830011300b00690bf1e9eefmr1852422otp.21.1676495230458;
        Wed, 15 Feb 2023 13:07:10 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id d21-20020a056830005500b0068664355604sm8038251otp.22.2023.02.15.13.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 13:07:10 -0800 (PST)
Received: (nullmailer pid 582985 invoked by uid 1000);
        Wed, 15 Feb 2023 21:07:09 -0000
Date:   Wed, 15 Feb 2023 15:07:09 -0600
From:   Rob Herring <robh@kernel.org>
To:     Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        anirudha.sarangi@amd.com, harini.katakam@amd.com, git@amd.com
Subject: Re: [PATCH net-next V5] dt-bindings: net: xlnx,axi-ethernet: convert
 bindings document to yaml
Message-ID: <20230215210709.GA544482-robh@kernel.org>
References: <20230214112259.4076450-1-sarath.babu.naidu.gaddam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214112259.4076450-1-sarath.babu.naidu.gaddam@amd.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 04:52:59PM +0530, Sarath Babu Naidu Gaddam wrote:
> From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> 
> Convert the bindings document for Xilinx AXI Ethernet Subsystem
> from txt to yaml. No changes to existing binding description.
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
> ---
> Chanages in V5:
> 1) Removed .txt file which was missed in V4
> 
> Changes in V4:
> 1)Changed the interrupts property and add allOf:if:then for it.
> 
> Changes in V3:
> 1) Moved RFC to PATCH.
> 2) Addressed below review comments
> 	a) Indentation.
> 	b) maxItems:3 does not match your description.
> 	c) Filename matching compatibles.
> 
> Changes in V2:
> 1) remove .txt and change the name of file to xlnx,axiethernet.yaml.
> 2) Fix DT check warning('device_type' does not match any of the regexes:
>    'pinctrl-[0-9]+' From schema: Documentation/devicetree/bindings/net
>     /xilinx_axienet.yaml).
> ---
>  .../bindings/net/xilinx_axienet.txt           | 101 -----------
>  .../bindings/net/xlnx,axi-ethernet.yaml       | 166 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  3 files changed, 167 insertions(+), 101 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/xilinx_axienet.txt
>  create mode 100644 Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml


> diff --git a/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
> new file mode 100644
> index 000000000000..d2d276d4858f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
> @@ -0,0 +1,166 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/xlnx,axi-ethernet.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: AXI 1G/2.5G Ethernet Subsystem
> +
> +description: |
> +  Also called  AXI 1G/2.5G Ethernet Subsystem, the xilinx axi ethernet IP core
> +  provides connectivity to an external ethernet PHY supporting different
> +  interfaces: MII, GMII, RGMII, SGMII, 1000BaseX. It also includes two
> +  segments of memory for buffering TX and RX, as well as the capability of
> +  offloading TX/RX checksum calculation off the processor.
> +
> +  Management configuration is done through the AXI interface, while payload is
> +  sent and received through means of an AXI DMA controller. This driver
> +  includes the DMA driver code, so this driver is incompatible with AXI DMA
> +  driver.
> +
> +maintainers:
> +  - Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - xlnx,axi-ethernet-1.00.a
> +      - xlnx,axi-ethernet-1.01.a
> +      - xlnx,axi-ethernet-2.01.a
> +
> +  reg:
> +    description:
> +      Address and length of the IO space, as well as the address
> +      and length of the AXI DMA controller IO space, unless
> +      axistream-connected is specified, in which case the reg
> +      attribute of the node referenced by it is used.
> +    maxItems: 2
> +
> +  interrupts:
> +    items:
> +      - description: Ethernet core interrupt
> +      - description: Tx DMA interrupt
> +      - description: Rx DMA interrupt
> +    description:
> +      Ethernet core interrupt is optional. If axistream-connected property is
> +      present DMA node should contains TX/RX DMA interrupts else DMA interrupt
> +      resources are mentioned on ethernet node.
> +    minItems: 1
> +
> +  phy-handle: true
> +
> +  xlnx,rxmem:
> +    description:
> +      Set to allocated memory buffer for Rx/Tx in the hardware.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +
> +  phy-mode: true
> +
> +  xlnx,phy-type:
> +    description:
> +      Do not use, but still accepted in preference to phy-mode.
> +    deprecated: true
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +
> +  xlnx,txcsum:
> +    description:
> +      TX checksum offload. 0 or empty for disabling TX checksum offload,
> +      1 to enable partial TX checksum offload and 2 to enable full TX
> +      checksum offload.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1, 2]
> +
> +  xlnx,rxcsum:
> +    description:
> +      RX checksum offload. 0 or empty for disabling RX checksum offload,
> +      1 to enable partial RX checksum offload and 2 to enable full RX
> +      checksum offload.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1, 2]
> +
> +  xlnx,switch-x-sgmii:
> +    type: boolean
> +    description:
> +      Indicate the Ethernet core is configured to support both 1000BaseX and
> +      SGMII modes. If set, the phy-mode should be set to match the mode
> +      selected on core reset (i.e. by the basex_or_sgmii core input line).
> +
> +  clocks:
> +    items:
> +      - description: Clock for AXI register slave interface.
> +      - description: AXI4-Stream clock for TXD RXD TXC and RXS interfaces.
> +      - description: Ethernet reference clock, used by signal delay primitives
> +                     and transceivers.
> +      - description: MGT reference clock (used by optional internal PCS/PMA PHY)
> +
> +  clock-names:
> +    items:
> +      - const: s_axi_lite_clk
> +      - const: axis_clk
> +      - const: ref_clk
> +      - const: mgt_clk
> +
> +  axistream-connected:
> +    type: object
> +    description: Reference to another node which contains the resources
> +      for the AXI DMA controller used by this device. If this is specified,
> +      the DMA-related resources from that device (DMA registers and DMA
> +      TX/RX interrupts) rather than this one will be used.
> +
> +  mdio: true
> +
> +  pcs-handle:
> +    description: Phandle to the internal PCS/PMA PHY in SGMII or 1000Base-X
> +      modes, where "pcs-handle" should be used to point to the PCS/PMA PHY,
> +      and "phy-handle" should point to an external PHY if exists.
> +    $ref: /schemas/types.yaml#/definitions/phandle

Drop this and add a $ref to ethernet-controller.yaml

> +
> +required:
> +  - compatible
> +  - interrupts
> +  - reg
> +  - xlnx,rxmem
> +  - phy-handle
> +
> +allOf:
> +  - if:
> +      required:
> +        - axistream-connected
> +
> +    then:
> +      properties:
> +        interrupts:
> +          minItems: 2
> +          maxItems: 3
> +
> +    else:
> +      properties:
> +        interrupts:
> +          maxItems: 1
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    axi_ethernet_eth: ethernet@40c00000 {
> +        compatible = "xlnx,axi-ethernet-1.00.a";
> +        interrupt-parent = <&microblaze_0_axi_intc>;

Not relevant to the binding.

> +        interrupts = <2 0 1>;
> +        clock-names = "s_axi_lite_clk", "axis_clk", "ref_clk", "mgt_clk";
> +        clocks = <&axi_clk>, <&axi_clk>, <&pl_enet_ref_clk>, <&mgt_clk>;
> +        phy-mode = "mii";
> +        reg = <0x40c00000 0x40000>,<0x50c00000 0x40000>;
> +        xlnx,rxcsum = <0x2>;
> +        xlnx,rxmem = <0x800>;
> +        xlnx,txcsum = <0x2>;
> +        phy-handle = <&phy0>;
> +
> +        axi_ethernetlite_0_mdio: mdio {

Drop unused labels.

> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +            phy0: ethernet-phy@1 {
> +                device_type = "ethernet-phy";
> +                reg = <1>;
> +            };
> +        };
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2cf9eb43ed8f..0bf527552dc9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22895,6 +22895,7 @@ F:	drivers/iio/adc/xilinx-ams.c
>  XILINX AXI ETHERNET DRIVER
>  M:	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
>  S:	Maintained
> +F:	Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
>  F:	drivers/net/ethernet/xilinx/xilinx_axienet*
>  
>  XILINX CAN DRIVER
> -- 
> 2.25.1
> 
