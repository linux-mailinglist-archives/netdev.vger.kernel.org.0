Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEC0465625
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 20:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243486AbhLATK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 14:10:28 -0500
Received: from mail-ot1-f51.google.com ([209.85.210.51]:37604 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239347AbhLATK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 14:10:26 -0500
Received: by mail-ot1-f51.google.com with SMTP id h19-20020a9d3e53000000b0056547b797b2so36611328otg.4;
        Wed, 01 Dec 2021 11:07:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ns1VGFmIcxV8dyTDHSaaXTsKQnH3/DvAnnTtMRYBS+Q=;
        b=ERHEm+eSieZOplMSofp1XjojM34V/fNPDhjBawGpNSfUez5ls4INXm3s4gaGwV6aIk
         Od0843fwnxmu3igurGD6OOoTXq6Rr3jNxmSJe//cnxDsUelIiLSgpXl5JE+RbdK8chBj
         5Wv5jKk+h2SuCLtJ+YbVcyh+vYnrSSD+Q1iA5HoUCqDOFEykjBEGHG09kaFlvfCnvPAW
         XYjWnk5PTQ9WhiPl7Twsk630A1N6yBv7TuQQZR+8bDYe9s7y+1CFEiIANKWd8aDrVixU
         SD7kv9PIP5K7Jx/yIPkyd7JcXRj7KGKwL8MLvRnY9Oj4rpXT6IXwaDmVjmMV0TaOSe1X
         06pQ==
X-Gm-Message-State: AOAM5304O65amjDcPA7i4OF1KJ+2pB/W7kh9QTxtiaxntnrUsadCnj9P
        pD36GE3Qj5spA5qEdUi65g==
X-Google-Smtp-Source: ABdhPJyuR82qEd6pOKlVcbGE8T/SQxfzOcBBPB6zaklRvnXx6zarsyFBDAGE0kbYD4LuWHhdyxwljg==
X-Received: by 2002:a05:6830:195:: with SMTP id q21mr7238076ota.355.1638385620493;
        Wed, 01 Dec 2021 11:07:00 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id n26sm201220ooq.36.2021.12.01.11.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 11:06:59 -0800 (PST)
Received: (nullmailer pid 2270663 invoked by uid 1000);
        Wed, 01 Dec 2021 19:06:58 -0000
Date:   Wed, 1 Dec 2021 13:06:58 -0600
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "maintainer:BROADCOM IPROC GBIT ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Doug Berger <opendmb@gmail.com>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:BROADCOM IPROC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next 7/7] dt-bindings: net: Convert iProc MDIO mux to
 YAML
Message-ID: <YafH0nADqO7DTU4A@robh.at.kernel.org>
References: <20211201041228.32444-1-f.fainelli@gmail.com>
 <20211201041228.32444-8-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201041228.32444-8-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 08:12:28PM -0800, Florian Fainelli wrote:
> Conver the Broadcom iProc MDIO mux Device Tree binding to YAML.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .../bindings/net/brcm,mdio-mux-iproc.txt      | 62 --------------
>  .../bindings/net/brcm,mdio-mux-iproc.yaml     | 80 +++++++++++++++++++
>  2 files changed, 80 insertions(+), 62 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.txt
>  create mode 100644 Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.txt b/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.txt
> deleted file mode 100644
> index deb9e852ea27..000000000000
> --- a/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.txt
> +++ /dev/null
> @@ -1,62 +0,0 @@
> -Properties for an MDIO bus multiplexer found in Broadcom iProc based SoCs.
> -
> -This MDIO bus multiplexer defines buses that could be internal as well as
> -external to SoCs and could accept MDIO transaction compatible to C-22 or
> -C-45 Clause. When child bus is selected, one needs to select these two
> -properties as well to generate desired MDIO transaction on appropriate bus.
> -
> -Required properties in addition to the generic multiplexer properties:
> -
> -MDIO multiplexer node:
> -- compatible: brcm,mdio-mux-iproc.
> -
> -Every non-ethernet PHY requires a compatible so that it could be probed based
> -on this compatible string.
> -
> -Optional properties:
> -- clocks: phandle of the core clock which drives the mdio block.
> -
> -Additional information regarding generic multiplexer properties can be found
> -at- Documentation/devicetree/bindings/net/mdio-mux.yaml
> -
> -
> -for example:
> -		mdio_mux_iproc: mdio-mux@66020000 {
> -			compatible = "brcm,mdio-mux-iproc";
> -			reg = <0x66020000 0x250>;
> -			#address-cells = <1>;
> -			#size-cells = <0>;
> -
> -			mdio@0 {
> -				reg = <0x0>;
> -				#address-cells = <1>;
> -				#size-cells = <0>;
> -
> -				pci_phy0: pci-phy@0 {
> -					compatible = "brcm,ns2-pcie-phy";
> -					reg = <0x0>;
> -					#phy-cells = <0>;
> -				};
> -			};
> -
> -			mdio@7 {
> -				reg = <0x7>;
> -				#address-cells = <1>;
> -				#size-cells = <0>;
> -
> -				pci_phy1: pci-phy@0 {
> -					compatible = "brcm,ns2-pcie-phy";
> -					reg = <0x0>;
> -					#phy-cells = <0>;
> -				};
> -			};
> -			mdio@10 {
> -				reg = <0x10>;
> -				#address-cells = <1>;
> -				#size-cells = <0>;
> -
> -				gphy0: eth-phy@10 {
> -					reg = <0x10>;
> -				};
> -			};
> -		};
> diff --git a/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.yaml b/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.yaml
> new file mode 100644
> index 000000000000..a576fb87bfc8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.yaml
> @@ -0,0 +1,80 @@
> +# SPDX-License-Identifier: GPL-2.0

All Broadcom authors on the original. Please add BSD-2-Clause.

> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/brcm,mdio-mux-iproc.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: MDIO bus multiplexer found in Broadcom iProc based SoCs.
> +
> +maintainers:
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +
> +description:
> +  This MDIO bus multiplexer defines buses that could be internal as well as
> +  external to SoCs and could accept MDIO transaction compatible to C-22 or
> +  C-45 Clause. When child bus is selected, one needs to select these two
> +  properties as well to generate desired MDIO transaction on appropriate bus.
> +
> +allOf:
> +  - $ref: /schemas/net/mdio-mux.yaml#
> +
> +properties:
> +  compatible:
> +    const: brcm,mdio-mux-iproc
> +
> +  reg:
> +    maxItems: 1
> +
> +  clocks:
> +    maxItems: 1
> +    description: core clock driving the MDIO block
> +
> +
> +required:
> +  - compatible
> +  - reg
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    mdio_mux_iproc: mdio-mux@66020000 {
> +        compatible = "brcm,mdio-mux-iproc";
> +        reg = <0x66020000 0x250>;
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        mdio@0 {
> +           reg = <0x0>;
> +           #address-cells = <1>;
> +           #size-cells = <0>;
> +
> +           pci_phy0: pci-phy@0 {
> +              compatible = "brcm,ns2-pcie-phy";
> +              reg = <0x0>;
> +              #phy-cells = <0>;
> +           };
> +        };
> +
> +        mdio@7 {
> +           reg = <0x7>;
> +           #address-cells = <1>;
> +           #size-cells = <0>;
> +
> +           pci_phy1: pci-phy@0 {
> +              compatible = "brcm,ns2-pcie-phy";
> +              reg = <0x0>;
> +              #phy-cells = <0>;
> +           };
> +        };
> +
> +        mdio@10 {
> +           reg = <0x10>;
> +           #address-cells = <1>;
> +           #size-cells = <0>;
> +
> +           gphy0: eth-phy@10 {
> +              reg = <0x10>;
> +           };
> +        };
> +    };
> -- 
> 2.25.1
> 
> 
