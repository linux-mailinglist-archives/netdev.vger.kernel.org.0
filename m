Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E966B31572D
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 20:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbhBITs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 14:48:58 -0500
Received: from mail-oi1-f178.google.com ([209.85.167.178]:42180 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233605AbhBITmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 14:42:33 -0500
Received: by mail-oi1-f178.google.com with SMTP id u66so18762835oig.9;
        Tue, 09 Feb 2021 11:42:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IBorz2otqQJxo0SaT5C7A5IkE1Wk8d8NppL9llXu7UE=;
        b=KB9pfrx+KOs0ix4D1VaGn7ph9H/7Q/4EnVw0xJPB01BylW5wt2U1mjTOrnbsTiSw8M
         OYiynq/G01en0r3slbMdXq12qrXmZonIQi4FSpm7mTS/E4oedJvrX7al6AB2SrzuOoyU
         oxeYXO6tFbxYwukQzNdWqXxbsheSmZhYVRS3nSHB0Z7DfSYyJXGREQ15354+U20BLbWX
         V4qUBSHNr7kQQte9yghvmSvfARkRHiyJIEgCVALlaFkcH9uYRo1hdQ3Rs/ElSq4caZj1
         ShaRjxGSJEGnozlNsw7e14WkOaBC00yJoq2pmsbugq2Go+BHlxhqwjMgcJxqPg4NlI//
         XfYQ==
X-Gm-Message-State: AOAM530qv5fkzJnV91IutCWSLJzjMpNkch6BRYYu9p/xx0ExNh+xKWoA
        0jvtuP5mgGSYdmLZZbi0LqyNI56feQ==
X-Google-Smtp-Source: ABdhPJz2JJIMXsH2KMeqHdo/5sxOJZRjKo7SFHnjZ0/HwqRTrOI7WqRCWYjXyDqU7L3VAU3h4B+6fQ==
X-Received: by 2002:aca:eb91:: with SMTP id j139mr110967oih.101.1612899311796;
        Tue, 09 Feb 2021 11:35:11 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id a28sm4368979ook.24.2021.02.09.11.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 11:35:10 -0800 (PST)
Received: (nullmailer pid 21987 invoked by uid 1000);
        Tue, 09 Feb 2021 19:35:09 -0000
Date:   Tue, 9 Feb 2021 13:35:09 -0600
From:   Rob Herring <robh@kernel.org>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, olteanv@gmail.com, netdev@vger.kernel.org,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, UNGLinuxDriver@microchip.com,
        Woojung.Huh@microchip.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 1/8] dt-bindings: net: dsa: dt bindings for
 microchip lan937x
Message-ID: <20210209193509.GA16232@robh.at.kernel.org>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
 <20210128064112.372883-2-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128064112.372883-2-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 12:11:05PM +0530, Prasanna Vengateshan wrote:
> Documentation in .yaml format and updates to the MAINTAINERS
> Also 'make dt_binding_check' is passed
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> ---
>  .../bindings/net/dsa/microchip,lan937x.yaml   | 115 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  2 files changed, 116 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> new file mode 100644
> index 000000000000..8531ca603f13
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> @@ -0,0 +1,115 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/microchip,lan937x.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: LAN937x Ethernet Switch Series Tree Bindings
> +
> +maintainers:
> +  - woojung.huh@microchip.com
> +  - prasanna.vengateshan@microchip.com
> +
> +allOf:
> +  - $ref: dsa.yaml#
> +
> +properties:
> +  compatible:
> +    enum:
> +      - microchip,lan9370
> +      - microchip,lan9371
> +      - microchip,lan9372
> +      - microchip,lan9373
> +      - microchip,lan9374
> +
> +  reg:
> +    maxItems: 1
> +
> +  spi-max-frequency:
> +    maximum: 50000000
> +
> +  reset-gpios:
> +    description: Optional gpio specifier for a reset line
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +
> +    //Ethernet switch connected via spi to the host, CPU port wired to eth1
> +    eth1 {

ethernet {

> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +
> +      fixed-link {
> +        speed = <1000>;
> +        full-duplex;
> +      };
> +    };
> +
> +    spi1 {

spi {

> +      #address-cells = <1>;
> +      #size-cells = <0>;

> +      pinctrl-0 = <&pinctrl_spi_ksz>;
> +      cs-gpios = <0>, <0>, <0>, <&pioC 28 0>;
> +      id = <1>;

These 3 are relevant to the example, drop

> +
> +      lan9374: switch@0 {
> +        compatible = "microchip,lan9374";
> +        reg = <0>;
> +
> +        spi-max-frequency = <44000000>;
> +
> +        ethernet-ports {
> +          #address-cells = <1>;
> +          #size-cells = <0>;
> +          port@0 {
> +            reg = <0>;
> +            label = "lan1";
> +          };
> +          port@1 {
> +            reg = <1>;
> +            label = "lan2";
> +          };
> +          port@2 {
> +            reg = <7>;
> +            label = "lan3";
> +          };
> +          port@3 {
> +            reg = <2>;
> +            label = "lan4";
> +          };
> +          port@4 {
> +            reg = <6>;
> +            label = "lan5";
> +          };
> +          port@5 {
> +            reg = <3>;
> +            label = "lan6";
> +          };
> +          port@6 {
> +            reg = <4>;
> +            label = "cpu";
> +            ethernet = <&eth1>;
> +            fixed-link {
> +              speed = <1000>;
> +              full-duplex;
> +            };
> +          };
> +          port@7 {
> +            reg = <5>;
> +            label = "lan7";
> +            fixed-link {
> +              speed = <1000>;
> +              full-duplex;
> +            };
> +          };
> +        };
> +      };
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 650deb973913..455670f37231 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11688,6 +11688,7 @@ M:	UNGLinuxDriver@microchip.com
>  L:	netdev@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> +F:	Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
>  F:	drivers/net/dsa/microchip/*
>  F:	include/linux/platform_data/microchip-ksz.h
>  F:	net/dsa/tag_ksz.c
> -- 
> 2.25.1
> 
