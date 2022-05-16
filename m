Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43101528CB8
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 20:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344594AbiEPSQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 14:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238321AbiEPSQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 14:16:43 -0400
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14354BF59;
        Mon, 16 May 2022 11:16:41 -0700 (PDT)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-e5e433d66dso21231436fac.5;
        Mon, 16 May 2022 11:16:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FGHkkgEbDjj+fXG52zxoL3JWZp8rgjPY6oBCvpAql54=;
        b=SvCndQ13faXx2au9xFEDsIGMDbCgTvbBXb3Kf+Ze0Ya8Px9knYJ7+ixMd949qWA6/p
         gGhoQRk8jdKQjRdw2dQfRAxy/vPDczhylIJd1VTUAWE9pPnBknSL07lNlHVLjufLY5Tm
         wZLO4P70GLUA6fpn5SknVBuEBer/R5nvYreapaQnIXM0uDb+Ok0mX02VuxtLVNX5PUNq
         A1kSz4LaZXkSHUm8V78f0VPBQ9hlAzyNbnA37dyz8EM//kJFlscnqsRNuDA5uTq4zmhN
         Nj4ITy7Er8gkVTr8gQt9IU01UZmsCMBjAuN+vH6eUcxGfyNgnSREMZ1unKAt4jm8eN66
         /hJw==
X-Gm-Message-State: AOAM5332FIOPnBV0HmP+b3sCTzhJAgWvv6oou7+WcU0DAN5e1ED7P4iu
        YDYUXnBPGNyoO26G4ZH7oA==
X-Google-Smtp-Source: ABdhPJw4IHY+NUCXo63OkszT4TQqiBrdC9WhctGWxKWLRi+Ty9ycHOqRVTyJ3V6Rx10wavQ6PsxtvQ==
X-Received: by 2002:a05:6870:15c3:b0:ed:9d61:a56c with SMTP id k3-20020a05687015c300b000ed9d61a56cmr10315284oad.152.1652725000892;
        Mon, 16 May 2022 11:16:40 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id t129-20020aca5f87000000b00328a1be5c3asm4122689oib.25.2022.05.16.11.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 11:16:40 -0700 (PDT)
Received: (nullmailer pid 3014196 invoked by uid 1000);
        Mon, 16 May 2022 18:16:39 -0000
Date:   Mon, 16 May 2022 13:16:39 -0500
From:   Rob Herring <robh@kernel.org>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        andrew@lunn.ch, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: net: orion-mdio: Convert to JSON schema
Message-ID: <20220516181639.GB2997786-robh@kernel.org>
References: <20220505210621.3637268-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505210621.3637268-1-chris.packham@alliedtelesis.co.nz>
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

On Fri, May 06, 2022 at 09:06:20AM +1200, Chris Packham wrote:
> Convert the marvell,orion-mdio binding to JSON schema.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> ---
> 
> Notes:
>     This does throw up the following dtbs_check warnings for turris-mox:
>     
>     arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dtb: mdio@32004: switch0@10:reg: [[16], [0]] is too long
>             From schema: Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
>     arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dtb: mdio@32004: switch0@2:reg: [[2], [0]] is too long
>             From schema: Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
>     arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dtb: mdio@32004: switch1@11:reg: [[17], [0]] is too long
>             From schema: Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
>     arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dtb: mdio@32004: switch1@2:reg: [[2], [0]] is too long
>             From schema: Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
>     arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dtb: mdio@32004: switch2@12:reg: [[18], [0]] is too long
>             From schema: Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
>     arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dtb: mdio@32004: switch2@2:reg: [[2], [0]] is too long
>             From schema: Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
>     
>     I think they're all genuine but I'm hesitant to leap in and fix them
>     without being able to test them.
>     
>     I also need to set unevaluatedProperties: true to cater for the L2
>     switch on turris-mox (and probably others). That might be better tackled
>     in the core mdio.yaml schema but I wasn't planning on touching that.
>     
>     Changes in v2:
>     - Add Andrew as maintainer (thanks for volunteering)
> 
>  .../bindings/net/marvell,orion-mdio.yaml      | 60 +++++++++++++++++++
>  .../bindings/net/marvell-orion-mdio.txt       | 54 -----------------
>  2 files changed, 60 insertions(+), 54 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/marvell-orion-mdio.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml b/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
> new file mode 100644
> index 000000000000..fe3a3412f093
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
> @@ -0,0 +1,60 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/marvell,orion-mdio.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Marvell MDIO Ethernet Controller interface
> +
> +maintainers:
> +  - Andrew Lunn <andrew@lunn.ch>
> +
> +description: |
> +  The Ethernet controllers of the Marvel Kirkwood, Dove, Orion5x, MV78xx0,
> +  Armada 370, Armada XP, Armada 7k and Armada 8k have an identical unit that
> +  provides an interface with the MDIO bus. Additionally, Armada 7k and Armada
> +  8k has a second unit which provides an interface with the xMDIO bus. This
> +  driver handles these interfaces.
> +
> +allOf:
> +  - $ref: "mdio.yaml#"
> +
> +properties:
> +  compatible:
> +    enum:
> +      - marvell,orion-mdio
> +      - marvell,xmdio
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  clocks:
> +    minItems: 1
> +    maxItems: 4

Really this should be better defined, but the original was not.

> +
> +required:
> +  - compatible
> +  - reg
> +
> +unevaluatedProperties: true

This must be false.

> +
> +examples:
> +  - |
> +    mdio@d0072004 {
> +      compatible = "marvell,orion-mdio";
> +      reg = <0xd0072004 0x4>;
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +      interrupts = <30>;
> +
> +      phy0: ethernet-phy@0 {
> +        reg = <0>;
> +      };
> +
> +      phy1: ethernet-phy@1 {
> +        reg = <1>;
> +      };
> +    };
> diff --git a/Documentation/devicetree/bindings/net/marvell-orion-mdio.txt b/Documentation/devicetree/bindings/net/marvell-orion-mdio.txt
> deleted file mode 100644
> index 3f3cfc1d8d4d..000000000000
> --- a/Documentation/devicetree/bindings/net/marvell-orion-mdio.txt
> +++ /dev/null
> @@ -1,54 +0,0 @@
> -* Marvell MDIO Ethernet Controller interface
> -
> -The Ethernet controllers of the Marvel Kirkwood, Dove, Orion5x,
> -MV78xx0, Armada 370, Armada XP, Armada 7k and Armada 8k have an
> -identical unit that provides an interface with the MDIO bus.
> -Additionally, Armada 7k and Armada 8k has a second unit which
> -provides an interface with the xMDIO bus. This driver handles
> -these interfaces.
> -
> -Required properties:
> -- compatible: "marvell,orion-mdio" or "marvell,xmdio"
> -- reg: address and length of the MDIO registers.  When an interrupt is
> -  not present, the length is the size of the SMI register (4 bytes)
> -  otherwise it must be 0x84 bytes to cover the interrupt control
> -  registers.
> -
> -Optional properties:
> -- interrupts: interrupt line number for the SMI error/done interrupt
> -- clocks: phandle for up to four required clocks for the MDIO instance
> -
> -The child nodes of the MDIO driver are the individual PHY devices
> -connected to this MDIO bus. They must have a "reg" property given the
> -PHY address on the MDIO bus.
> -
> -Example at the SoC level without an interrupt property:
> -
> -mdio {
> -	#address-cells = <1>;
> -	#size-cells = <0>;
> -	compatible = "marvell,orion-mdio";
> -	reg = <0xd0072004 0x4>;
> -};
> -
> -Example with an interrupt property:
> -
> -mdio {
> -	#address-cells = <1>;
> -	#size-cells = <0>;
> -	compatible = "marvell,orion-mdio";
> -	reg = <0xd0072004 0x84>;
> -	interrupts = <30>;
> -};
> -
> -And at the board level:
> -
> -mdio {
> -	phy0: ethernet-phy@0 {
> -		reg = <0>;
> -	};
> -
> -	phy1: ethernet-phy@1 {
> -		reg = <1>;
> -	};
> -}
> -- 
> 2.36.0
> 
> 
