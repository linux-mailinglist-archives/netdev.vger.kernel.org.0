Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B4746DC6E
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 20:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239746AbhLHTuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 14:50:18 -0500
Received: from mail-oo1-f44.google.com ([209.85.161.44]:46687 "EHLO
        mail-oo1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbhLHTuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 14:50:18 -0500
Received: by mail-oo1-f44.google.com with SMTP id p2-20020a4adfc2000000b002c2676904fdso1148349ood.13;
        Wed, 08 Dec 2021 11:46:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=0mIPL/+jUI9AdMmYMLz/l/bjBsOiazs5hLLhbsFkikU=;
        b=reDLv6f8IVreq9j2N5bxLiKhD6zsV/h2GutBNYgieziZoFLWzuoTaABBYXiCcZXzz+
         zWNd7A2yHjZeXAvI3ckQg4CFETSIuQUtgZcpshXOwQFW+8rrZC9mfi361Grp+XdcruPt
         73U1mGS7b4Ic9qnhVIfd+IwegHw0dfThdCswDyPfq89tC9pWXqxE9Wa7HdPyvC3Omtp7
         LCGuqXwJv1BtKfPQFQpIS5cwNI1xZ+fVdF2V000mt/ThXr47fYhwjvBi1bUSnEOkMmy4
         hp/JZvJn8ujAIMih7U8iyMCDpT92SXu4khZT6J8Au3tcf4bVtHJAH3+2u0L6TDwXa8ZO
         GNeA==
X-Gm-Message-State: AOAM532wwEh7ErwIcTEvH1ZAv3BsndE5NiAalS9WgAVVePVrZiGpzRRh
        CPdWI/gXX823BJ78ENFw5w==
X-Google-Smtp-Source: ABdhPJzteVYfoBLxE3bMuh9WmQQ2c9OPUSwkjEWjuIuhBxHa0QCNvx80ga7y5eiFEbhKeKD0K5P8AA==
X-Received: by 2002:a4a:ae0a:: with SMTP id z10mr1002444oom.34.1638992804224;
        Wed, 08 Dec 2021 11:46:44 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id j20sm598095ota.76.2021.12.08.11.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 11:46:43 -0800 (PST)
Received: (nullmailer pid 252850 invoked by uid 1000);
        Wed, 08 Dec 2021 19:46:42 -0000
Date:   Wed, 8 Dec 2021 13:46:42 -0600
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
Subject: Re: [PATCH v3 5/8] dt-bindings: net: Convert AMAC to YAML
Message-ID: <YbELog9TiauuK3fE@robh.at.kernel.org>
References: <20211206180049.2086907-1-f.fainelli@gmail.com>
 <20211206180049.2086907-6-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211206180049.2086907-6-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 10:00:46AM -0800, Florian Fainelli wrote:
> Convert the Broadcom AMAC Device Tree binding to YAML to help with
> schema and dtbs checking.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .../devicetree/bindings/net/brcm,amac.txt     | 30 -------
>  .../devicetree/bindings/net/brcm,amac.yaml    | 88 +++++++++++++++++++
>  MAINTAINERS                                   |  2 +-
>  3 files changed, 89 insertions(+), 31 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/brcm,amac.txt
>  create mode 100644 Documentation/devicetree/bindings/net/brcm,amac.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/brcm,amac.txt b/Documentation/devicetree/bindings/net/brcm,amac.txt
> deleted file mode 100644
> index 0120ebe93262..000000000000
> --- a/Documentation/devicetree/bindings/net/brcm,amac.txt
> +++ /dev/null
> @@ -1,30 +0,0 @@
> -Broadcom AMAC Ethernet Controller Device Tree Bindings
> --------------------------------------------------------------
> -
> -Required properties:
> - - compatible:	"brcm,amac"
> -		"brcm,nsp-amac"
> -		"brcm,ns2-amac"
> - - reg:		Address and length of the register set for the device. It
> -		contains the information of registers in the same order as
> -		described by reg-names
> - - reg-names:	Names of the registers.
> -		"amac_base":	Address and length of the GMAC registers
> -		"idm_base":	Address and length of the GMAC IDM registers
> -				(required for NSP and Northstar2)
> -		"nicpm_base":	Address and length of the NIC Port Manager
> -				registers (required for Northstar2)
> - - interrupts:	Interrupt number
> -
> -The MAC address will be determined using the optional properties
> -defined in ethernet.txt.
> -
> -Examples:
> -
> -amac0: ethernet@18022000 {
> -	compatible = "brcm,nsp-amac";
> -	reg = <0x18022000 0x1000>,
> -	      <0x18110000 0x1000>;
> -	reg-names = "amac_base", "idm_base";
> -	interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
> -};
> diff --git a/Documentation/devicetree/bindings/net/brcm,amac.yaml b/Documentation/devicetree/bindings/net/brcm,amac.yaml
> new file mode 100644
> index 000000000000..d9de68aba7d3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/brcm,amac.yaml
> @@ -0,0 +1,88 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/brcm,amac.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Broadcom AMAC Ethernet Controller Device Tree Bindings
> +
> +maintainers:
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +
> +allOf:
> +  - $ref: "ethernet-controller.yaml#"
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - brcm,amac
> +    then:
> +      properties:
> +        reg:
> +          minItems: 1
> +          maxItems: 2
> +        reg-names:
> +          minItems: 1
> +          maxItems: 2
> +          items:
> +            - const: amac_base
> +            - const: idm_base
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - brcm,nsp-amac
> +    then:
> +      properties:
> +        reg:
> +          minItems: 2
> +          maxItems: 2
> +        reg-names:
> +          items:
> +            - const: amac_base
> +            - const: idm_base
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - brcm,ns2-amac
> +    then:
> +      properties:

> +        reg:
> +          minItems: 3
> +          maxItems: 3
> +        reg-names:
> +          items:
> +            - const: amac_base
> +            - const: idm_base
> +            - const: nicpm_base

Move this to the main section so that the names are only defined once. 
Then here you can just set the number of items.

> +
> +properties:
> +  compatible:
> +    enum:
> +      - brcm,amac
> +      - brcm,nsp-amac
> +      - brcm,ns2-amac
> +
> +  interrupts:
> +    maxItems: 1
> +
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +   #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +   amac0: ethernet@18022000 {
> +      compatible = "brcm,nsp-amac";
> +      reg = <0x18022000 0x1000>,
> +            <0x18110000 0x1000>;
> +      reg-names = "amac_base", "idm_base";
> +      interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
> +   };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5e1064c23f41..404e76d625f1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3861,7 +3861,7 @@ M:	Rafał Miłecki <rafal@milecki.pl>
>  M:	bcm-kernel-feedback-list@broadcom.com
>  L:	netdev@vger.kernel.org
>  S:	Maintained
> -F:	Documentation/devicetree/bindings/net/brcm,amac.txt
> +F:	Documentation/devicetree/bindings/net/brcm,amac.yaml
>  F:	drivers/net/ethernet/broadcom/bgmac*
>  F:	drivers/net/ethernet/broadcom/unimac.h
>  
> -- 
> 2.25.1
> 
> 
