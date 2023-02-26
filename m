Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAAC96A3367
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 19:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjBZSVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 13:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjBZSVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 13:21:04 -0500
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B1AEC42;
        Sun, 26 Feb 2023 10:21:03 -0800 (PST)
Received: by mail-qt1-f169.google.com with SMTP id d7so4493779qtr.12;
        Sun, 26 Feb 2023 10:21:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jWb7q6a1sjSV59Lcz+2CiIFUSCE7SfdoeaOuYsGveyU=;
        b=GvkUsQq2FDXukScYPSpxWhP/2VajK3bAhZAMaaJis4UQ7qq9YkA6vaHxot74Nn+UzG
         J+ap2GuEMDKHXUEE+KVRP50NB9Qf3FyHTKWVXgdoensXr15TWoVWlGM09dDbAju9eKK6
         X0Kn5BRAaAasq/jSRp+EEowHH5bbpWk1P/DIry3i71/b6oh7jogyIZjNu3dQRumfxYiW
         ISOzxMb0WjKO/pJMXI/cn0lurm9Ct906d1a6llh7Cotp7QG+JTATwhW4YcDa54pVASQ2
         EGaG3CaLv3XGfUB/VGQbHU/kniA3Y0nH63zu1MSnx7hoZ/9SGqORe5J4521jqSxlQLhm
         GDpg==
X-Gm-Message-State: AO0yUKVpRBfTwl+07xd/s1LG7DF/lssZ6J0tTAwdEbZ82Wjba27zf7l8
        5jGU8Sf2QHGrC4HyjeYeAw==
X-Google-Smtp-Source: AK7set/8RjhCS8uCEoAy2xabB8INjsVI7tWDO1zL4yi2RCkP+y0VVyQsRNeK/ts3oz3nVdnhGmvCXg==
X-Received: by 2002:a05:622a:10b:b0:3bf:d4c3:3659 with SMTP id u11-20020a05622a010b00b003bfd4c33659mr2820971qtw.66.1677435662247;
        Sun, 26 Feb 2023 10:21:02 -0800 (PST)
Received: from robh_at_kernel.org ([2605:ef80:8069:8ddf:ff6b:c94c:94fd:4442])
        by smtp.gmail.com with ESMTPSA id i25-20020ac84899000000b003b9a6d54b6csm3251099qtq.59.2023.02.26.10.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 10:21:01 -0800 (PST)
Received: (nullmailer pid 126949 invoked by uid 1000);
        Sun, 26 Feb 2023 18:20:58 -0000
Date:   Sun, 26 Feb 2023 12:20:58 -0600
From:   Rob Herring <robh@kernel.org>
To:     Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        anirudha.sarangi@amd.com, harini.katakam@amd.com, git@amd.com
Subject: Re: [PATCH net-next V6] dt-bindings: net: xlnx,axi-ethernet: convert
 bindings document to yaml
Message-ID: <20230226182058.GA108914-robh@kernel.org>
References: <20230220122252.3575380-1-sarath.babu.naidu.gaddam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220122252.3575380-1-sarath.babu.naidu.gaddam@amd.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 05:52:52PM +0530, Sarath Babu Naidu Gaddam wrote:
> From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> 
> Convert the bindings document for Xilinx AXI Ethernet Subsystem
> from txt to yaml. No changes to existing binding description.
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
> ---
> Changes in V6:
> 1) Addressed below review comments.
> 	a)add a $ref to ethernet-controller.yaml for pcs-handle.
> 	b)Drop unused labels(axi_ethernetlite_0_mdio).
> 	c)Not relevant to the binding(interrupt-parent).
> 
> Changes in V5:
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
>  .../bindings/net/xlnx,axi-ethernet.yaml       | 165 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  3 files changed, 166 insertions(+), 101 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/xilinx_axienet.txt
>  create mode 100644 Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml

[...]

> +++ b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
> @@ -0,0 +1,165 @@
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

I'd assume only a subset of modes are supported by this h/w. If so, list 
them.

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

Reference? Meaning a phandle? Or this is a node because that's what 
'type: object' says.

> +      for the AXI DMA controller used by this device. If this is specified,
> +      the DMA-related resources from that device (DMA registers and DMA
> +      TX/RX interrupts) rather than this one will be used.
> +
> +  mdio: true

type: object

> +
> +  pcs-handle:
> +    description: Phandle to the internal PCS/PMA PHY in SGMII or 1000Base-X
> +      modes, where "pcs-handle" should be used to point to the PCS/PMA PHY,
> +      and "phy-handle" should point to an external PHY if exists.
> +    $ref: /schemas/net/ethernet-controller.yaml#

The reference applies to nodes, but 'pcs-handle' is a property. It needs 
to be at the top-level:

allOf:
  - $ref: /schemas/net/ethernet-controller.yaml#

Rob
