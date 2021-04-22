Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC1636861D
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 19:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236882AbhDVRj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 13:39:26 -0400
Received: from mail-oo1-f41.google.com ([209.85.161.41]:33456 "EHLO
        mail-oo1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236754AbhDVRjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 13:39:22 -0400
Received: by mail-oo1-f41.google.com with SMTP id i25-20020a4aa1190000b02901bbd9429832so10135347ool.0;
        Thu, 22 Apr 2021 10:38:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tMVnVypmvdM6x0K9pdf9C+ZDup5EGo+8ylMsMxOJ0dM=;
        b=jUVgvYDgYY7/6lBdZB7v17Y4UXOhNeHgAp2SNjivYk6i0UsJw7yzxGiABecnL5RIUF
         muiHrJGHVmrsCiK3We5ZYuQRLh+WAi29bJcPQQfsgotRNHAF7eDqDQ80OBYqFTA8hY7z
         5t7l+A5HGxMyBvSz5+SKcKjOi4ORekr7nvQEKwiGVzaOwCrRHZYBs/MisaNfYNQQslfY
         W6Y+37DDYevkTi3PVKXtZPBuqWYTV+gWuAtvtVn8j7wHEaqhu8fZgEE5Qk94uYo/k8rJ
         G1afdT+zNG3uHbPn1GeFMJ+cPyVZsGu1mFkJelrwjD7rOkezDBcygrB+iJkqw30aS/BV
         HyRw==
X-Gm-Message-State: AOAM531BKL00Dj/Mpkt+42P+vW2RQYfeSEZ6w+zF/FjRqDiIvlzEfvBJ
        Lk1KPYdqibL5Y7GpXgkSkA==
X-Google-Smtp-Source: ABdhPJwcgWM0XLWrK7WEs8CdBSkklMghctKgwcSHGZbx3s62U5GMyPjoEZD7BN22/aQxOKo2Wojj3w==
X-Received: by 2002:a4a:96e3:: with SMTP id t32mr3235742ooi.14.1619113127295;
        Thu, 22 Apr 2021 10:38:47 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id r9sm688532ool.3.2021.04.22.10.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 10:38:46 -0700 (PDT)
Received: (nullmailer pid 3297132 invoked by uid 1000);
        Thu, 22 Apr 2021 17:38:44 -0000
Date:   Thu, 22 Apr 2021 12:38:44 -0500
From:   Rob Herring <robh@kernel.org>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/9] dt-bindings: net: dsa: dt bindings for
 microchip lan937x
Message-ID: <20210422173844.GA3227277@robh.at.kernel.org>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
 <20210422094257.1641396-2-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422094257.1641396-2-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 03:12:49PM +0530, Prasanna Vengateshan wrote:
> Documentation in .yaml format and updates to the MAINTAINERS
> Also 'make dt_binding_check' is passed
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> ---
>  .../bindings/net/dsa/microchip,lan937x.yaml   | 142 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  2 files changed, 143 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> new file mode 100644
> index 000000000000..22128a52d699
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> @@ -0,0 +1,142 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/microchip,lan937x.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: LAN937x Ethernet Switch Series Tree Bindings
> +
> +maintainers:
> +  - UNGLinuxDriver@microchip.com
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
> +    //Ethernet switch connected via spi to the host

If this is on SPI, why is it not under the spi bus node?

> +    ethernet {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +
> +      fixed-link {
> +        speed = <1000>;
> +        full-duplex;
> +      };
> +    };
> +
> +    spi {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
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
> +            phy-handle = <&t1phy0>;
> +          };
> +          port@1 {
> +            reg = <1>;
> +            label = "lan2";
> +            phy-handle = <&t1phy1>;
> +          };
> +          port@2 {
> +            reg = <2>;
> +            label = "lan4";
> +            phy-handle = <&t1phy2>;
> +          };
> +          port@3 {
> +            reg = <3>;
> +            label = "lan6";
> +            phy-handle = <&t1phy3>;
> +          };
> +          port@4 {
> +            reg = <4>;
> +            phy-mode = "rgmii";
> +            ethernet = <&ethernet>;

You are missing 'ethernet' label.

> +            fixed-link {
> +              speed = <1000>;
> +              full-duplex;
> +            };
> +          };
> +          port@5 {
> +            reg = <5>;
> +            label = "lan7";
> +            fixed-link {
> +              speed = <1000>;
> +              full-duplex;
> +            };
> +          };
> +          port@6 {
> +            reg = <6>;
> +            label = "lan5";
> +            phy-handle = <&t1phy4>;
> +          };
> +          port@7 {
> +            reg = <7>;
> +            label = "lan3";
> +            phy-handle = <&t1phy5>;
> +          };
> +        };
> +
> +        mdio {
> +          compatible = "microchip,lan937x-mdio";

You can just drop this to make the example pass. Or convert that binding 
to schema.

> +          #address-cells = <1>;
> +          #size-cells = <0>;
> +
> +          t1phy0: ethernet-phy@0{
> +            reg = <0x0>;
> +          };
> +          t1phy1: ethernet-phy@1{
> +            reg = <0x1>;
> +          };
> +          t1phy2: ethernet-phy@2{
> +            reg = <0x2>;
> +          };
> +          t1phy3: ethernet-phy@3{
> +            reg = <0x3>;
> +          };
> +          t1phy4: ethernet-phy@6{
> +            reg = <0x6>;
> +          };
> +          t1phy5: ethernet-phy@7{
> +            reg = <0x7>;
> +          };
> +        };
> +      };
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c3c8fa572580..a0fdfef8802a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11752,6 +11752,7 @@ M:	UNGLinuxDriver@microchip.com
>  L:	netdev@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> +F:	Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
>  F:	drivers/net/dsa/microchip/*
>  F:	include/linux/platform_data/microchip-ksz.h
>  F:	net/dsa/tag_ksz.c
> -- 
> 2.27.0
> 
