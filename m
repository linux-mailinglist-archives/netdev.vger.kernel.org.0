Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410BD46DC72
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 20:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239759AbhLHTwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 14:52:03 -0500
Received: from mail-oi1-f171.google.com ([209.85.167.171]:35537 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbhLHTwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 14:52:03 -0500
Received: by mail-oi1-f171.google.com with SMTP id m6so5574570oim.2;
        Wed, 08 Dec 2021 11:48:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Nfn9Bm+LZepNTex7K/9pLhuPzvoyMVzxxUgpPvMegPY=;
        b=pHBjDorw3b0endR1RXjlZIb39s0dLH1OFu4VL5H3xI7Fy8MiY3Q28W0GBjnj5yyeHn
         or8C5m8E7fxB8uw1ZOro6RaKfNFQmH1n0FaEXriFpjE561m/mS61u1rImvPhApI0CRH0
         tV/glQnYxG1ypcI+fEdyvhKJCNXzPq9nrqlNm/jQVtRhh1KFR+r3BaUF6dFkgOofO7lT
         Vi0Ibb0+JM9WZKojJTlw7XpU821298SbAKp6566LLGnd5j3PiiSUqN+EYJJGsWib9/gk
         dg/sE4UAe3vWgQy9D2M0rbaFwooFJgdSyCe49J/VwZQ4xdTP2VeyzlrCZ53ePHU+cLhH
         UQLQ==
X-Gm-Message-State: AOAM532bKESVl8eh3cYtZRbO8bMoryaY9asoj1kAcn6ZS6EZANU8cVay
        xAS7+9vLNSSmOVNuQViW+w==
X-Google-Smtp-Source: ABdhPJwsN0EDUdKKA5+iVLdkwdpccAxhZRZyjWfXJTeD6J+w0CfrOWZ0AWaF6l/tViI29y2gyucL7A==
X-Received: by 2002:a05:6808:23cb:: with SMTP id bq11mr1501873oib.2.1638992910659;
        Wed, 08 Dec 2021 11:48:30 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id z2sm609182oto.38.2021.12.08.11.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 11:48:30 -0800 (PST)
Received: (nullmailer pid 255448 invoked by uid 1000);
        Wed, 08 Dec 2021 19:48:28 -0000
Date:   Wed, 8 Dec 2021 13:48:28 -0600
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "maintainer:BROADCOM IPROC GBIT ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Doug Berger <opendmb@gmail.com>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:BROADCOM IPROC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:GENERIC PHY FRAMEWORK" <linux-phy@lists.infradead.org>
Subject: Re: [PATCH v3 6/8] dt-bindings: net: Convert SYSTEMPORT to YAML
Message-ID: <YbEMDIhKZEzpeKQR@robh.at.kernel.org>
References: <20211206180049.2086907-1-f.fainelli@gmail.com>
 <20211206180049.2086907-7-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206180049.2086907-7-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 10:00:47AM -0800, Florian Fainelli wrote:
> Convert the Broadcom SYSTEMPORT Ethernet controller Device Tree binding
> to YAML.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .../bindings/net/brcm,systemport.txt          | 38 ---------
>  .../bindings/net/brcm,systemport.yaml         | 82 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  3 files changed, 83 insertions(+), 38 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/brcm,systemport.txt
>  create mode 100644 Documentation/devicetree/bindings/net/brcm,systemport.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/brcm,systemport.txt b/Documentation/devicetree/bindings/net/brcm,systemport.txt
> deleted file mode 100644
> index 75736739bfdd..000000000000
> --- a/Documentation/devicetree/bindings/net/brcm,systemport.txt
> +++ /dev/null
> @@ -1,38 +0,0 @@
> -* Broadcom BCM7xxx Ethernet Systemport Controller (SYSTEMPORT)
> -
> -Required properties:
> -- compatible: should be one of:
> -	      "brcm,systemport-v1.00"
> -	      "brcm,systemportlite-v1.00" or
> -	      "brcm,systemport"
> -- reg: address and length of the register set for the device.
> -- interrupts: interrupts for the device, first cell must be for the rx
> -  interrupts, and the second cell should be for the transmit queues. An
> -  optional third interrupt cell for Wake-on-LAN can be specified
> -- local-mac-address: Ethernet MAC address (48 bits) of this adapter
> -- phy-mode: Should be a string describing the PHY interface to the
> -  Ethernet switch/PHY, see Documentation/devicetree/bindings/net/ethernet.txt
> -- fixed-link: see Documentation/devicetree/bindings/net/fixed-link.txt for
> -  the property specific details
> -
> -Optional properties:
> -- systemport,num-tier2-arb: number of tier 2 arbiters, an integer
> -- systemport,num-tier1-arb: number of tier 1 arbiters, an integer
> -- systemport,num-txq: number of HW transmit queues, an integer
> -- systemport,num-rxq: number of HW receive queues, an integer
> -- clocks: When provided, must be two phandles to the functional clocks nodes of
> -  the SYSTEMPORT block. The first phandle is the main SYSTEMPORT clock used
> -  during normal operation, while the second phandle is the Wake-on-LAN clock.
> -- clock-names: When provided, names of the functional clock phandles, first
> -  name should be "sw_sysport" and second should be "sw_sysportwol".
> -
> -Example:
> -ethernet@f04a0000 {
> -	compatible = "brcm,systemport-v1.00";
> -	reg = <0xf04a0000 0x4650>;
> -	local-mac-address = [ 00 11 22 33 44 55 ];
> -	fixed-link = <0 1 1000 0 0>;
> -	phy-mode = "gmii";
> -	interrupts = <0x0 0x16 0x0>,
> -		<0x0 0x17 0x0>;
> -};
> diff --git a/Documentation/devicetree/bindings/net/brcm,systemport.yaml b/Documentation/devicetree/bindings/net/brcm,systemport.yaml
> new file mode 100644
> index 000000000000..44781027ed37
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/brcm,systemport.yaml
> @@ -0,0 +1,82 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/brcm,systemport.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Broadcom BCM7xxx Ethernet Systemport Controller (SYSTEMPORT)
> +
> +maintainers:
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - brcm,systemport-v1.00
> +      - brcm,systemportlite-v1.00
> +      - brcm,systemport
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    minItems: 2
> +    items:
> +      - description: interrupt line for RX queues
> +      - description: interrupt line for TX queues
> +      - description: interrupt line for Wake-on-LAN
> +
> +  clocks:
> +    items:
> +      - description: main clock
> +      - description: Wake-on-LAN clock
> +
> +  clock-names:
> +    items:
> +      - const: sw_sysport
> +      - const: sw_sysportwol
> +
> +  "systemport,num-tier2-arb":

Don't need quotes.

> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description:
> +      Number of tier 2 arbiters
> +
> +  "systemport,num-tier1-arb":
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description:
> +      Number of tier 2 arbiters
> +
> +  "systemport,num-txq":
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description:
> +      Number of HW transmit queues
> +
> +  "systemport,num-rxq":
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description:
> +      Number of HW receive queues

No constraints for any of these?

> +
> +required:
> +  - reg
> +  - interrupts
> +  - phy-mode
> +
> +allOf:
> +  - $ref: "ethernet-controller.yaml#"
> +
> +additionalProperties: true

unevaluatedProperties: false

> +
> +examples:
> +  - |
> +    ethernet@f04a0000 {
> +        compatible = "brcm,systemport-v1.00";
> +        reg = <0xf04a0000 0x4650>;
> +        local-mac-address = [ 00 11 22 33 44 55 ];
> +        phy-mode = "gmii";
> +        interrupts = <0x0 0x16 0x0>,
> +                     <0x0 0x17 0x0>;
> +        fixed-link {
> +            speed = <1000>;
> +            full-duplex;
> +        };
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 404e76d625f1..ed8de605fe4b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3972,6 +3972,7 @@ L:	netdev@vger.kernel.org
>  S:	Supported
>  F:	drivers/net/ethernet/broadcom/bcmsysport.*
>  F:	drivers/net/ethernet/broadcom/unimac.h
> +F:	Documentation/devicetree/bindings/net/brcm,systemport.yaml
>  
>  BROADCOM TG3 GIGABIT ETHERNET DRIVER
>  M:	Siva Reddy Kallam <siva.kallam@broadcom.com>
> -- 
> 2.25.1
> 
> 
