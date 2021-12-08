Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389A846DC41
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 20:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239587AbhLHTfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 14:35:52 -0500
Received: from mail-ot1-f44.google.com ([209.85.210.44]:38653 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbhLHTfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 14:35:51 -0500
Received: by mail-ot1-f44.google.com with SMTP id n104-20020a9d2071000000b005799790cf0bso3806771ota.5;
        Wed, 08 Dec 2021 11:32:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8nxUtG+5JYlvW5SguB6Kw4ZUS6/ARKAi5lTA7ymRi4U=;
        b=dtd5LadR8d9Vz0r9k4fnEEc4PCqx8TN0vb1IvLF+gcy406ZaLdu3oSiSs6SRdHyriU
         XSb7TZqPXOG7yhLdMU1bOPTLsje2IX/BGLOO+iE+4Gt+v86IviKdvsBojY1AOS7M1jrW
         GoxTI1Rf82C1oEzextO84NuKPGd18cfYS6P5hzrbjI1EyEdTZfjLrnyeo9nd3NN0PX86
         b6AvN5xawDl7ezpy+KxpGQtIjjWd/RfkI/I7HdyPPcFymN2X8EMvWomE/vl9c30YY656
         4ziH9KJiyaKjQqotmS9M62Kw+34Mj5AhzQ0EhSsrRrb7Ydi+9styaqMU2JUYW5XIxB1A
         qkrA==
X-Gm-Message-State: AOAM531MIfYa1z+GiUFd1LiIWv1yne15MPBFEiiBC1L1Iw8Rf6UpGjvU
        Y7tOT/dB6kVoOHiQ04VkTQ==
X-Google-Smtp-Source: ABdhPJyzyO/Bn97Z2SbyHrMUw2BYtmH+nBP1gAtBUQYhquxascjBes0YKkNNS7jVMf4cz9jkJPf5tQ==
X-Received: by 2002:a9d:24c3:: with SMTP id z61mr1369551ota.100.1638991938803;
        Wed, 08 Dec 2021 11:32:18 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id g7sm642073oon.27.2021.12.08.11.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 11:32:17 -0800 (PST)
Received: (nullmailer pid 198024 invoked by uid 1000);
        Wed, 08 Dec 2021 19:32:16 -0000
Date:   Wed, 8 Dec 2021 13:32:16 -0600
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
Subject: Re: [PATCH v3 4/8] dt-bindings: net: Convert GENET binding to YAML
Message-ID: <YbEIQNoSRR8II7fF@robh.at.kernel.org>
References: <20211206180049.2086907-1-f.fainelli@gmail.com>
 <20211206180049.2086907-5-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206180049.2086907-5-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 10:00:45AM -0800, Florian Fainelli wrote:
> Convert the GENET binding to YAML, leveraging brcm,unimac-mdio.yaml and
> the standard ethernet-controller.yaml files.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .../devicetree/bindings/net/brcm,bcmgenet.txt | 125 ---------------
>  .../bindings/net/brcm,bcmgenet.yaml           | 145 ++++++++++++++++++
>  MAINTAINERS                                   |   2 +-
>  3 files changed, 146 insertions(+), 126 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
>  create mode 100644 Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/brcm,bcmgenet.txt b/Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
> deleted file mode 100644
> index 0b5994fba35f..000000000000
> --- a/Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
> +++ /dev/null
> @@ -1,125 +0,0 @@
> -* Broadcom BCM7xxx Ethernet Controller (GENET)
> -
> -Required properties:
> -- compatible: should contain one of "brcm,genet-v1", "brcm,genet-v2",
> -  "brcm,genet-v3", "brcm,genet-v4", "brcm,genet-v5", "brcm,bcm2711-genet-v5" or
> -  "brcm,bcm7712-genet-v5".
> -- reg: address and length of the register set for the device
> -- interrupts and/or interrupts-extended: must be two cells, the first cell
> -  is the general purpose interrupt line, while the second cell is the
> -  interrupt for the ring RX and TX queues operating in ring mode.  An
> -  optional third interrupt cell for Wake-on-LAN can be specified.
> -  See Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> -  for information on the property specifics.
> -- phy-mode: see ethernet.txt file in the same directory
> -- #address-cells: should be 1
> -- #size-cells: should be 1
> -
> -Optional properties:
> -- clocks: When provided, must be two phandles to the functional clocks nodes
> -  of the GENET block. The first phandle is the main GENET clock used during
> -  normal operation, while the second phandle is the Wake-on-LAN clock.
> -- clock-names: When provided, names of the functional clock phandles, first
> -  name should be "enet" and second should be "enet-wol".
> -
> -- phy-handle: See ethernet.txt file in the same directory; used to describe
> -  configurations where a PHY (internal or external) is used.
> -
> -- fixed-link: When the GENET interface is connected to a MoCA hardware block or
> -  when operating in a RGMII to RGMII type of connection, or when the MDIO bus is
> -  voluntarily disabled, this property should be used to describe the "fixed link".
> -  See Documentation/devicetree/bindings/net/fixed-link.txt for information on
> -  the property specifics
> -
> -Required child nodes:
> -
> -- mdio bus node: this node should always be present regardless of the PHY
> -  configuration of the GENET instance
> -
> -MDIO bus node required properties:
> -
> -- compatible: should contain one of "brcm,genet-mdio-v1", "brcm,genet-mdio-v2"
> -  "brcm,genet-mdio-v3", "brcm,genet-mdio-v4", "brcm,genet-mdio-v5", the version
> -  has to match the parent node compatible property (e.g: brcm,genet-v4 pairs
> -  with brcm,genet-mdio-v4)
> -- reg: address and length relative to the parent node base register address
> -- #address-cells: address cell for MDIO bus addressing, should be 1
> -- #size-cells: size of the cells for MDIO bus addressing, should be 0
> -
> -Ethernet PHY node properties:
> -
> -See Documentation/devicetree/bindings/net/phy.txt for the list of required and
> -optional properties.
> -
> -Internal Gigabit PHY example:
> -
> -ethernet@f0b60000 {
> -	phy-mode = "internal";
> -	phy-handle = <&phy1>;
> -	mac-address = [ 00 10 18 36 23 1a ];
> -	compatible = "brcm,genet-v4";
> -	#address-cells = <0x1>;
> -	#size-cells = <0x1>;
> -	reg = <0xf0b60000 0xfc4c>;
> -	interrupts = <0x0 0x14 0x0>, <0x0 0x15 0x0>;
> -
> -	mdio@e14 {
> -		compatible = "brcm,genet-mdio-v4";
> -		#address-cells = <0x1>;
> -		#size-cells = <0x0>;
> -		reg = <0xe14 0x8>;
> -
> -		phy1: ethernet-phy@1 {
> -			max-speed = <1000>;
> -			reg = <0x1>;
> -			compatible = "ethernet-phy-ieee802.3-c22";
> -		};
> -	};
> -};
> -
> -MoCA interface / MAC to MAC example:
> -
> -ethernet@f0b80000 {
> -	phy-mode = "moca";
> -	fixed-link = <1 0 1000 0 0>;
> -	mac-address = [ 00 10 18 36 24 1a ];
> -	compatible = "brcm,genet-v4";
> -	#address-cells = <0x1>;
> -	#size-cells = <0x1>;
> -	reg = <0xf0b80000 0xfc4c>;
> -	interrupts = <0x0 0x16 0x0>, <0x0 0x17 0x0>;
> -
> -	mdio@e14 {
> -		compatible = "brcm,genet-mdio-v4";
> -		#address-cells = <0x1>;
> -		#size-cells = <0x0>;
> -		reg = <0xe14 0x8>;
> -	};
> -};
> -
> -
> -External MDIO-connected Gigabit PHY/switch:
> -
> -ethernet@f0ba0000 {
> -	phy-mode = "rgmii";
> -	phy-handle = <&phy0>;
> -	mac-address = [ 00 10 18 36 26 1a ];
> -	compatible = "brcm,genet-v4";
> -	#address-cells = <0x1>;
> -	#size-cells = <0x1>;
> -	reg = <0xf0ba0000 0xfc4c>;
> -	interrupts = <0x0 0x18 0x0>, <0x0 0x19 0x0>;
> -
> -	mdio@e14 {
> -		compatible = "brcm,genet-mdio-v4";
> -		#address-cells = <0x1>;
> -		#size-cells = <0x0>;
> -		reg = <0xe14 0x8>;
> -
> -		phy0: ethernet-phy@0 {
> -			max-speed = <1000>;
> -			reg = <0x0>;
> -			compatible = "ethernet-phy-ieee802.3-c22";
> -		};
> -	};
> -};
> diff --git a/Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml b/Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml
> new file mode 100644
> index 000000000000..ba9a6d156815
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml
> @@ -0,0 +1,145 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/brcm,bcmgenet.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Broadcom BCM7xxx Ethernet Controller (GENET) binding
> +
> +maintainers:
> +  - Doug Berger <opendmb@gmail.com>
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - brcm,genet-v1
> +      - brcm,genet-v2
> +      - brcm,genet-v3
> +      - brcm,genet-v4
> +      - brcm,genet-v5
> +      - brcm,bcm2711-genet-v5
> +      - brcm,bcm7712-genet-v5
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    minItems: 2
> +    items:
> +      - description: general purpose interrupt line
> +      - description: RX and TX rings interrupt line
> +      - description: Wake-on-LAN interrupt line
> +
> +
> +  clocks:
> +    minItems: 1
> +    items:
> +      - description: main clock
> +      - description: EEE clock
> +      - description: Wake-on-LAN clock
> +
> +  clock-names:
> +    minItems: 1
> +    items:
> +      - const: enet
> +      - const: enet-eee
> +      - const: enet-wol
> +
> +  "#address-cells":
> +    const: 1
> +
> +  "#size-cells":
> +    const: 1
> +
> +patternProperties:
> +  "^mdio@[0-9a-f]+$":
> +    type: object
> +    $ref: "brcm,unimac-mdio.yaml"
> +
> +    description:
> +      GENET internal UniMAC MDIO bus
> +
> +required:
> +  - reg
> +  - interrupts
> +  - phy-mode
> +  - "#address-cells"
> +  - "#size-cells"
> +
> +allOf:
> +  - $ref: ethernet-controller.yaml
> +
> +additionalProperties: true

This should be 'unevaluatedProperties: false'. I'll fixup while 
applying.

> +
> +examples:
> +  #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +  - |
> +    ethernet@f0b60000 {
> +        phy-mode = "internal";
> +        phy-handle = <&phy1>;
> +        mac-address = [ 00 10 18 36 23 1a ];
> +        compatible = "brcm,genet-v4";
> +        reg = <0xf0b60000 0xfc4c>;
> +        interrupts = <0x0 0x14 0x0>, <0x0 0x15 0x0>;
> +        #address-cells = <1>;
> +        #size-cells = <1>;
> +
> +        mdio0: mdio@e14 {
> +           compatible = "brcm,genet-mdio-v4";
> +           #address-cells = <1>;
> +           #size-cells = <0>;
> +           reg = <0xe14 0x8>;
> +
> +           phy1: ethernet-phy@1 {
> +                max-speed = <1000>;
> +                reg = <1>;
> +                compatible = "ethernet-phy-ieee802.3-c22";
> +           };
> +        };
> +    };
> +
> +  - |
> +    ethernet@f0b80000 {
> +        phy-mode = "moca";
> +        fixed-link = <1 0 1000 0 0>;
> +        mac-address = [ 00 10 18 36 24 1a ];
> +        compatible = "brcm,genet-v4";
> +        #address-cells = <1>;
> +        #size-cells = <1>;
> +        reg = <0xf0b80000 0xfc4c>;
> +        interrupts = <0x0 0x16 0x0>, <0x0 0x17 0x0>;
> +
> +        mdio1: mdio@e14 {
> +           compatible = "brcm,genet-mdio-v4";
> +           #address-cells = <1>;
> +           #size-cells = <0>;
> +           reg = <0xe14 0x8>;
> +        };
> +    };
> +
> +  - |
> +    ethernet@f0ba0000 {
> +        phy-mode = "rgmii";
> +        phy-handle = <&phy0>;
> +        mac-address = [ 00 10 18 36 26 1a ];
> +        compatible = "brcm,genet-v4";
> +        #address-cells = <1>;
> +        #size-cells = <1>;
> +        reg = <0xf0ba0000 0xfc4c>;
> +        interrupts = <0x0 0x18 0x0>, <0x0 0x19 0x0>;
> +
> +        mdio2: mdio@e14 {
> +           compatible = "brcm,genet-mdio-v4";
> +           #address-cells = <1>;
> +           #size-cells = <0>;
> +           reg = <0xe14 0x8>;
> +
> +           phy0: ethernet-phy@0 {
> +                max-speed = <1000>;
> +                reg = <0>;
> +                compatible = "ethernet-phy-ieee802.3-c22";
> +           };
> +        };
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7a2345ce8521..5e1064c23f41 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3819,7 +3819,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
>  L:	bcm-kernel-feedback-list@broadcom.com
>  L:	netdev@vger.kernel.org
>  S:	Supported
> -F:	Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
> +F:	Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml
>  F:	Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
>  F:	drivers/net/ethernet/broadcom/genet/
>  F:	drivers/net/ethernet/broadcom/unimac.h
> -- 
> 2.25.1
> 
> 
