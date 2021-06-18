Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34863AD460
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 23:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234446AbhFRVZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 17:25:21 -0400
Received: from mail-oo1-f51.google.com ([209.85.161.51]:38482 "EHLO
        mail-oo1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbhFRVZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 17:25:21 -0400
Received: by mail-oo1-f51.google.com with SMTP id 128-20020a4a11860000b029024b19a4d98eso2454577ooc.5;
        Fri, 18 Jun 2021 14:23:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kYoCBUO/qNSFVFgUTNAWzs4qPs6wB1qFv3sYx6H1ziI=;
        b=FxULBYxezd38EG5R1tb4Oii/nqOUQAsHiciVIMu3ql/y9rqOEtEhy5WLY+kSlcoMKO
         tjTjBfKluewnU1ePU0UJq9Z3KnCJKyjL8fY2yiZFSbBN/pccUbzkI9A8j6zSJ3I/Ue6t
         ubbM5fAnpyfQlhNfVIDo1XDNitNhPaLlc/B+/gn7CcJ4l8ME2jgVbsf93JuL9XBjq+DN
         GzvY/VT3bqO2FhHRBFOejwDQHTSoj7tj5JC7lDyHoY/LtvOcV/b+oZykldZlLgA59sAv
         oy3jkgL3xVe6fCDXEeu1/QkeDViiOLtjiRRt3mpzRvR+/limkWEZicaez1ByRrKxr+2t
         X7Fg==
X-Gm-Message-State: AOAM530P/FZZoB09mXu1MTwV69js+Xzjb7AB8Ulf3DyLQ4mERpLUGYFG
        m1tWKMj9NqnzRG9hlQUOJmuM9+h7Bw==
X-Google-Smtp-Source: ABdhPJxeFOklfhnq7gh7GeiKckVtnqu4iMl8LSexWvHP/MG1WDOviieQMO1RNP1DbjSX+HKxRFkCUw==
X-Received: by 2002:a4a:c287:: with SMTP id b7mr10738061ooq.8.1624051390156;
        Fri, 18 Jun 2021 14:23:10 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id k84sm2033251oia.8.2021.06.18.14.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 14:23:09 -0700 (PDT)
Received: (nullmailer pid 2939070 invoked by uid 1000);
        Fri, 18 Jun 2021 21:23:04 -0000
Date:   Fri, 18 Jun 2021 15:23:04 -0600
From:   Rob Herring <robh@kernel.org>
To:     Marek Vasut <marex@denx.de>
Cc:     devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        linux@dh-electronics.com, netdev@vger.kernel.org
Subject: Re: [PATCH V2] dt-bindings: net: ks8851: Convert to YAML schema
Message-ID: <20210618212304.GA2927502@robh.at.kernel.org>
References: <20210610145954.29719-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610145954.29719-1-marex@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 04:59:54PM +0200, Marek Vasut wrote:
> Convert the Micrel KSZ8851 DT bindings to YAML schema.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Petr Stetiar <ynezz@true.cz>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: linux@dh-electronics.com
> Cc: netdev@vger.kernel.org
> To: devicetree@vger.kernel.org
> ---
> V2: - Explicitly state the bindings are for both SPI and parallel bus options
>     - Switch the license to (GPL-2.0-only OR BSD-2-Clause)
> ---
>  .../bindings/net/micrel,ks8851.yaml           | 94 +++++++++++++++++++
>  .../devicetree/bindings/net/micrel-ks8851.txt | 18 ----
>  2 files changed, 94 insertions(+), 18 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/micrel,ks8851.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/micrel-ks8851.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/micrel,ks8851.yaml b/Documentation/devicetree/bindings/net/micrel,ks8851.yaml
> new file mode 100644
> index 000000000000..3a3fc61baac3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/micrel,ks8851.yaml
> @@ -0,0 +1,94 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/micrel,ks8851.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Micrel KS8851 Ethernet MAC (SPI and Parallel bus options)
> +
> +maintainers:
> +  - Marek Vasut <marex@denx.de>
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - const: "micrel,ks8851"      # SPI bus option
> +      - const: "micrel,ks8851-mll"  # Parallel bus option

Don't need quotes and use 'enum' rather than 'oneOf+const'.

> +
> +  interrupts:
> +    maxItems: 1
> +
> +  reg:
> +    minItems: 1
> +    maxItems: 2

Need to define what each entry is when more than 1.

> +
> +  reset-gpios:
> +    maxItems: 1
> +    description:
> +      The reset_n input pin
> +
> +  vdd-supply:
> +    description: |
> +      Analog 3.3V supply for Ethernet MAC (see regulator/regulator.yaml)

Drop (see regulator/regulator.yaml). (If we want that, we should 
generate the cross ref).

> +
> +  vdd-io-supply:
> +    description: |
> +      Digital 1.8V IO supply for Ethernet MAC (see regulator/regulator.yaml)
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +
> +allOf:
> +  - $ref: ethernet-controller.yaml#
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: "micrel,ks8851"

Drop quotes

> +    then:
> +      properties:
> +        reg:
> +          maxItems: 1
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: "micrel,ks8851-mll"
> +    then:
> +      properties:
> +        reg:
> +          minItems: 2
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    /* SPI bus option */
> +    spi {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        ethernet@0 {
> +            compatible = "micrel,ks8851";
> +            reg = <0>;
> +            interrupt-parent = <&msmgpio>;
> +            interrupts = <90 8>;
> +            vdd-supply = <&ext_l2>;
> +            vdd-io-supply = <&pm8921_lvs6>;
> +            reset-gpios = <&msmgpio 89 0>;
> +        };
> +    };
> +  - |
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    /* Parallel bus option */
> +    memory-controller {
> +        #address-cells = <2>;
> +        #size-cells = <1>;
> +        ethernet@1,0 {
> +            compatible = "micrel,ks8851-mll";
> +            reg = <1 0x0 0x2>, <1 0x2 0x20000>;
> +            interrupt-parent = <&gpioc>;
> +            interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
> +        };
> +    };
> diff --git a/Documentation/devicetree/bindings/net/micrel-ks8851.txt b/Documentation/devicetree/bindings/net/micrel-ks8851.txt
> deleted file mode 100644
> index bbdf9a7359a2..000000000000
> --- a/Documentation/devicetree/bindings/net/micrel-ks8851.txt
> +++ /dev/null
> @@ -1,18 +0,0 @@
> -Micrel KS8851 Ethernet mac (MLL)
> -
> -Required properties:
> -- compatible = "micrel,ks8851-mll" of parallel interface
> -- reg : 2 physical address and size of registers for data and command
> -- interrupts : interrupt connection
> -
> -Micrel KS8851 Ethernet mac (SPI)
> -
> -Required properties:
> -- compatible = "micrel,ks8851" or the deprecated "ks8851"
> -- reg : chip select number
> -- interrupts : interrupt connection
> -
> -Optional properties:
> -- vdd-supply: analog 3.3V supply for Ethernet mac
> -- vdd-io-supply: digital 1.8V IO supply for Ethernet mac
> -- reset-gpios: reset_n input pin
> -- 
> 2.30.2
> 
> 
