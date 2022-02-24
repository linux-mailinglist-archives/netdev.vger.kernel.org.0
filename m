Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A474C3360
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 18:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiBXRTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 12:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiBXRTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 12:19:02 -0500
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA125B894;
        Thu, 24 Feb 2022 09:18:32 -0800 (PST)
Received: by mail-oi1-f175.google.com with SMTP id y7so3596669oih.5;
        Thu, 24 Feb 2022 09:18:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7slgzKqOG5WOC/WsENczH0GLZVRx1odPiIFNJSTj50w=;
        b=rDa2m5fEWXhmO8g+wDRXQWzeUcq5AL4qkzoJnHKMB82jpYb9VP3P0uU+qBTBlADMc5
         UwtkxZtwYaaFWTOWz03KgZqjC43doG7cQa84MO4vcRKbjIvC+dc79ArGgsuNZzXDfufC
         JHlJMLWOmp6IQ61gAKARMfBmdfo251MuKU9IzQW+LBgJgRNnE3tbgAvascO8Wxg5Z6Rj
         DRJ6NMr3Kb0n8CgebZBAkaNU5I0/DLExm7hESu764MmPbhFZzLAyelp/tsr2SClPbYfp
         rR1ZLAMWoteEr06QgmpEG1EhjGidK4RILJWDKJmP2dpM4Aa6cs/GkxvvIovVfjd1w9sX
         lIBw==
X-Gm-Message-State: AOAM531g5VT3yokV7oALZ5me/uVxbByvzanUfnR2UkxF2pUq96ugQxTb
        oRhaDAV7KvvWMvUyzqTeug==
X-Google-Smtp-Source: ABdhPJy7WQuDbUVEbzTIos+FK5YUQdNoBAGXEivNXy6JWYVM6FV6rNsboC4U1JBu0ZFrlMKW5PA40g==
X-Received: by 2002:a05:6808:202a:b0:2d4:df36:68a4 with SMTP id q42-20020a056808202a00b002d4df3668a4mr7750425oiw.16.1645723111948;
        Thu, 24 Feb 2022 09:18:31 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id t40-20020a05680815a800b002d48ffad94bsm11498oiw.2.2022.02.24.09.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 09:18:31 -0800 (PST)
Received: (nullmailer pid 3263579 invoked by uid 1000);
        Thu, 24 Feb 2022 17:18:30 -0000
Date:   Thu, 24 Feb 2022 11:18:30 -0600
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Ray Jui <rjui@broadcom.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Scott Branden <sbranden@broadcom.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Tony Lindgren <tony@atomide.com>, kernel@pengutronix.de,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v5 2/9] dt-bindings: net: add schema for Microchip/SMSC
 LAN95xx USB Ethernet controllers
Message-ID: <Yhe95rXZc7RzgO5o@robh.at.kernel.org>
References: <20220216074927.3619425-1-o.rempel@pengutronix.de>
 <20220216074927.3619425-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216074927.3619425-3-o.rempel@pengutronix.de>
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

On Wed, Feb 16, 2022 at 08:49:20AM +0100, Oleksij Rempel wrote:
> Create initial schema for Microchip/SMSC LAN95xx USB Ethernet controllers and
> import some of currently supported USB IDs form drivers/net/usb/smsc95xx.c
> 
> These devices are already used in some of DTs. So, this schema makes it official.
> NOTE: there was no previously documented txt based DT binding for this
> controllers.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../bindings/net/microchip,lan95xx.yaml       | 80 +++++++++++++++++++
>  1 file changed, 80 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
> new file mode 100644
> index 000000000000..8521c65366b4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
> @@ -0,0 +1,80 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/microchip,lan95xx.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: The device tree bindings for the USB Ethernet controllers
> +
> +maintainers:
> +  - Oleksij Rempel <o.rempel@pengutronix.de>
> +
> +description: |
> +  Device tree properties for hard wired SMSC95xx compatible USB Ethernet
> +  controller.
> +
> +allOf:
> +  - $ref: ethernet-controller.yaml#
> +
> +properties:
> +  compatible:
> +    items:
> +      - enum:
> +          - usb424,9500   # SMSC9500 USB Ethernet Device
> +          - usb424,9505   # SMSC9505 USB Ethernet Device
> +          - usb424,9530   # SMSC LAN9530 USB Ethernet Device
> +          - usb424,9730   # SMSC LAN9730 USB Ethernet Device
> +          - usb424,9900   # SMSC9500 USB Ethernet Device (SAL10)
> +          - usb424,9901   # SMSC9505 USB Ethernet Device (SAL10)
> +          - usb424,9902   # SMSC9500A USB Ethernet Device (SAL10)
> +          - usb424,9903   # SMSC9505A USB Ethernet Device (SAL10)
> +          - usb424,9904   # SMSC9512/9514 USB Hub & Ethernet Device (SAL10)
> +          - usb424,9905   # SMSC9500A USB Ethernet Device (HAL)
> +          - usb424,9906   # SMSC9505A USB Ethernet Device (HAL)
> +          - usb424,9907   # SMSC9500 USB Ethernet Device (Alternate ID)
> +          - usb424,9908   # SMSC9500A USB Ethernet Device (Alternate ID)
> +          - usb424,9909   # SMSC9512/9514 USB Hub & Ethernet Devic.  ID)
> +          - usb424,9e00   # SMSC9500A USB Ethernet Device
> +          - usb424,9e01   # SMSC9505A USB Ethernet Device
> +          - usb424,9e08   # SMSC LAN89530 USB Ethernet Device
> +          - usb424,ec00   # SMSC9512/9514 USB Hub & Ethernet Device
> +
> +  reg: true
> +  local-mac-address: true
> +  mac-address: true
> +
> +required:
> +  - compatible
> +  - reg
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    usb {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        ethernet@1 {
> +            compatible = "usb424,ec00";

If this is a hub/ethernet combo device, how is it valid to be standalone 
without the hub?

> +            reg = <1>;
> +            local-mac-address = [00 00 00 00 00 00];
> +        };
> +    };
> +  - |
> +    usb {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        usb1@1 {
> +            compatible = "usb424,9514";

Not documented.

> +            reg = <1>;
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +            ethernet@1 {
> +               compatible = "usb424,ec00";
> +               reg = <1>;
> +            };
> +        };
> +    };
> -- 
> 2.30.2
> 
> 
