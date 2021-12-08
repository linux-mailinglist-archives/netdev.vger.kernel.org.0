Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9196246DDD6
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 22:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbhLHVvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 16:51:20 -0500
Received: from mail-ot1-f49.google.com ([209.85.210.49]:41656 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhLHVvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 16:51:19 -0500
Received: by mail-ot1-f49.google.com with SMTP id n17-20020a9d64d1000000b00579cf677301so4160123otl.8;
        Wed, 08 Dec 2021 13:47:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BoG9LHHzX19IOW2aC3SfzWQwIESZSwCovgBtrAsFWR4=;
        b=jencRoOkS35Sa9YiRTjXXKsQh4VN2ehv6tQMY43zmd08mc0HSzXRfv2HIqXqeuhyHv
         u4qJqw+SbGovEstY+VftX7HvG8Og6OGJ3U0IhmREN3XFW41rE+oOW+0/XiwMa9ZTIFH8
         AVfjTQz8145chs6bUj1Yd6cuqgE7/jkvpL5873mtalxOCLe5S2eocz/47cwy5gJ16aJc
         HIF7L7nRCv+UwEfN/JiyahmzrmejP0GKZzWYtadXfMaGZEwmkzW4pZHyNpoWk9clkJNC
         YCELq32vc5MI1jIFPXgbI0K0wjAXRCJrFO2yXcTWKNxDbmGtq7neEP8kghiLXUdDTUri
         b2TQ==
X-Gm-Message-State: AOAM531gadFmaGVDTd81krDL2OKrrQYNGOwaAkZ4KJgwxJha7N8sWf7+
        wpXRAGZg0FbvGwib3cxUWkh0Vb90EQ==
X-Google-Smtp-Source: ABdhPJxl/PIRR78Ikr7Wo8Np7SjzHdbdW4qN/WrlDZETNUYck/JwKDzlwJwxVinmN9vt+617QF55lQ==
X-Received: by 2002:a9d:f4a:: with SMTP id 68mr1855673ott.327.1639000066682;
        Wed, 08 Dec 2021 13:47:46 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id 186sm857725oig.28.2021.12.08.13.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 13:47:46 -0800 (PST)
Received: (nullmailer pid 460551 invoked by uid 1000);
        Wed, 08 Dec 2021 21:47:45 -0000
Date:   Wed, 8 Dec 2021 15:47:45 -0600
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "maintainer:BROADCOM IPROC GBIT ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] dt-bindings: net: Convert SYSTEMPORT to YAML
Message-ID: <YbEoATYATomZtpbF@robh.at.kernel.org>
References: <20211208202801.3706929-1-f.fainelli@gmail.com>
 <20211208202801.3706929-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208202801.3706929-3-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 12:28:01PM -0800, Florian Fainelli wrote:
> Convert the Broadcom SYSTEMPORT Ethernet controller Device Tree binding
> to YAML.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .../bindings/net/brcm,systemport.txt          | 38 --------
>  .../bindings/net/brcm,systemport.yaml         | 88 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  3 files changed, 89 insertions(+), 38 deletions(-)
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
> index 000000000000..53ecec8c864e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/brcm,systemport.yaml
> @@ -0,0 +1,88 @@
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
> +  systemport,num-tier2-arb:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description:
> +      Number of tier 2 arbiters
> +
> +  systemport,num-tier1-arb:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description:
> +      Number of tier 2 arbiters
> +
> +  systemport,num-txq:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    items:
> +      - minimum: 1
> +      - maximum: 32

This says you have an array of 2 entries. I'll fix up.

> +    description:
> +      Number of HW transmit queues
> +
> +  systemport,num-rxq:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    items:
> +      - minimum: 1
> +      - maximum: 32
> +    description:
> +      Number of HW receive queues
> +
> +required:
> +  - reg
> +  - interrupts
> +  - phy-mode
> +
> +allOf:
> +  - $ref: "ethernet-controller.yaml#"
> +
> +unevaluatedProperties: false
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
