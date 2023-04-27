Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68726F0AA1
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 19:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244455AbjD0RRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 13:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244337AbjD0RQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 13:16:45 -0400
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB48555AD;
        Thu, 27 Apr 2023 10:16:27 -0700 (PDT)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-187ba2311b7so7054041fac.1;
        Thu, 27 Apr 2023 10:16:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682615787; x=1685207787;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EU2imsOOlLlZrjIN9juePbtOcgAYjelVwfmwyTnDSd0=;
        b=JcyJy8Pp7Aep0VsjJaRnOiUl0Vlc+Q3TsnLJ47uCqIyP8ceNk+gaOkVOnaHjGqpAxC
         JsKD8omiDuAyrZetnaFdP8N/pI2T9aEv9G6t7YANOzpsgZffbJPY/Ptvj3FULhQVh045
         0h2ZiZg4ghgeSl4q50ak+w0zTpbGjryj2Zkq58sl0A9ziZju02PoMoMr/PWC9u5Me87q
         jXrOus/uyJynki8c9raUlVV5+6dr9CWmNAA2LxMUIflOJvu+BUx8JCHhlroENfL33PF2
         XYCUAKARPWCVMDltUOeY46QfygNKBNt2vLtFslnko3sZ8Zzt4AXPUDYNTvU1bG63QvRr
         uCyQ==
X-Gm-Message-State: AC+VfDzD3ZUyWpv7hxpZ73hBJW34ga2m3D5ZUJoKaNy4AsNBKWCEQoWg
        +5cxzLeXEv9aSp4bOulLww==
X-Google-Smtp-Source: ACHHUZ62jIB7/4HoIDgm9vH/cSn1n7x8c4dz+fdSLMdOTBaQWdDp0VNFyfLCi152XnNtbQPU3Ox3rA==
X-Received: by 2002:a05:6870:822a:b0:180:3b6:82bd with SMTP id n42-20020a056870822a00b0018003b682bdmr1002246oae.33.1682615786901;
        Thu, 27 Apr 2023 10:16:26 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id v12-20020a4aad8c000000b0054542d3219asm8453503oom.11.2023.04.27.10.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 10:16:26 -0700 (PDT)
Received: (nullmailer pid 3185188 invoked by uid 1000);
        Thu, 27 Apr 2023 17:16:25 -0000
Date:   Thu, 27 Apr 2023 12:16:25 -0500
From:   Rob Herring <robh@kernel.org>
To:     Justin Chen <justinpopo6@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        bcm-kernel-feedback-list@broadcom.com, justin.chen@broadcom.com,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com
Subject: Re: [PATCH v2 net-next 2/6] dt-bindings: net: Brcm ASP 2.0 Ethernet
 controller
Message-ID: <20230427171625.GA3172205-robh@kernel.org>
References: <1682535272-32249-1-git-send-email-justinpopo6@gmail.com>
 <1682535272-32249-3-git-send-email-justinpopo6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1682535272-32249-3-git-send-email-justinpopo6@gmail.com>
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

On Wed, Apr 26, 2023 at 11:54:28AM -0700, Justin Chen wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> 
> Add a binding document for the Broadcom ASP 2.0 Ethernet
> controller.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Justin Chen <justinpopo6@gmail.com>
> ---
>  .../devicetree/bindings/net/brcm,asp-v2.0.yaml     | 145 +++++++++++++++++++++
>  1 file changed, 145 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml b/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
> new file mode 100644
> index 000000000000..818d91692e6e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
> @@ -0,0 +1,145 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/brcm,asp-v2.0.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Broadcom ASP 2.0 Ethernet controller
> +
> +maintainers:
> +  - Justin Chen <justinpopo6@gmail.com>
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +
> +description: Broadcom Ethernet controller first introduced with 72165
> +
> +properties:
> +  '#address-cells':
> +    const: 1
> +  '#size-cells':
> +    const: 1
> +
> +  compatible:
> +    enum:
> +      - brcm,asp-v2.0
> +      - brcm,bcm72165-asp-v2.0
> +      - brcm,asp-v2.1
> +      - brcm,bcm74165-asp-v2.1

You have 1 SoC per version, so what's the point of versions? If you have 
more coming, then fine, but I'd expect it to be something like this:

compatible = "brcm,bcm74165-asp-v2.1", "brcm,asp-v2.1";

Also, the version in the SoC specific compatible is redundant. Just 
"brcm,bcm74165-asp" is enough.

v2.1 is not compatible with v2.0? What that means is would a client/OS 
that only understands what v2.0 is work with v2.1 h/w? If so, you should 
have fallback compatible.

> +
> +  reg:
> +    maxItems: 1
> +
> +  ranges: true
> +
> +  interrupts:
> +    minItems: 1
> +    items:
> +      - description: RX/TX interrupt
> +      - description: Port 0 Wake-on-LAN
> +      - description: Port 1 Wake-on-LAN
> +
> +  clocks:
> +    maxItems: 1
> +
> +  ethernet-ports:

The ethernet-switch.yaml schema doesn't work for you?

> +    type: object
> +    properties:
> +      '#address-cells':
> +        const: 1
> +      '#size-cells':
> +        const: 0
> +
> +    patternProperties:
> +      "^port@[0-9]+$":
> +        type: object
> +
> +        $ref: ethernet-controller.yaml#
> +
> +        properties:
> +          reg:
> +            maxItems: 1
> +            description: Port number
> +
> +          channel:
> +            maxItems: 1
> +            description: ASP channel number

Not a standard property, so it needs a type and vendor prefix. However, 
what's the difference between channel and port? Can the port numbers 
correspond to the channels?

> +
> +        required:
> +          - reg
> +          - channel
> +
> +    additionalProperties: false
> +
> +patternProperties:
> +  "^mdio@[0-9a-f]+$":
> +    type: object
> +    $ref: "brcm,unimac-mdio.yaml"

Drop quotes.

> +
> +    description:
> +      ASP internal UniMAC MDIO bus
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +  - ranges
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    ethernet@9c00000 {
> +        compatible = "brcm,asp-v2.0";
> +        reg = <0x9c00000 0x1fff14>;
> +        interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>;
> +        ranges;
> +        clocks = <&scmi 14>;
> +        #address-cells = <1>;
> +        #size-cells = <1>;
> +
> +        mdio@c614 {
> +            compatible = "brcm,asp-v2.0-mdio";
> +            reg = <0xc614 0x8>;

You have 1:1 ranges, is that really what you want? That means 0xc614 is 
an absolute address.

> +            reg-names = "mdio";
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +            phy0: ethernet-phy@1 {
> +                reg = <1>;
> +            };
> +       };
> +
> +        mdio@ce14 {
> +            compatible = "brcm,asp-v2.0-mdio";
> +            reg = <0xce14 0x8>;
> +            reg-names = "mdio";
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +            phy1: ethernet-phy@1 {
> +                reg = <1>;
> +            };
> +        };
> +
> +        ethernet-ports {
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +            port@0 {
> +                reg = <0>;
> +                channel = <8>;
> +                phy-mode = "rgmii";
> +                phy-handle = <&phy0>;
> +            };
> +
> +            port@1 {
> +                reg = <1>;
> +                channel = <9>;
> +                phy-mode = "rgmii";
> +                phy-handle = <&phy1>;
> +            };
> +        };
> +    };
> -- 
> 2.7.4
> 
