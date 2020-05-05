Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F801C4CED
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 06:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgEEEEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 00:04:23 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:38880 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgEEEEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 00:04:23 -0400
Received: by mail-oi1-f194.google.com with SMTP id r66so866911oie.5;
        Mon, 04 May 2020 21:04:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iMdl5NHMDcGt22j2q8uZLDpjB1012t23d7yBsc8MVRI=;
        b=Hr7PRoa3G9Pt4FWWDnTg7rb7d8tAElb86yqexGp7HV5TNh7vNx6ZRly95SntoEQ2Zy
         +oplb1pBTE/Bm8pOjrDHVMJ5CnmvETyqi2lpdgUMz80ryHT5WIZu19xhTJweRkQOVima
         zncZ85c2paSQka3p70PayPJ2MR3xmhZXjwa9m2T3TGMzEz+hCtD0Tu82TBm42f2Snqvn
         LynNBHmrVmytWA2dmtUp8BXMsyXa7zfrNTBN3rB9K7IacRwyIF4K9+E5U10g5SFjoTsv
         fsRY8/AIgg3VOacJaGJrFz3sBajciPkHM9hxKfYYTb+fNGbpOw+LJr6VI+YcDdajdY/D
         gD8g==
X-Gm-Message-State: AGi0PuZ5P2//vCe7a/lqJh091KC45vZ+6s9avkGskWAeztHkZX/k5Z46
        adgH2N4napTiUkd/ANuYHg==
X-Google-Smtp-Source: APiQypJYRFCkAkyyFoIzHA4sjLBO2oP/dKzzry+jQeD8zdlE3vOHNjb6UUmvshmEPJtt+DR2KGBxdg==
X-Received: by 2002:aca:b6c2:: with SMTP id g185mr1230142oif.166.1588651461515;
        Mon, 04 May 2020 21:04:21 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id t10sm287022oou.38.2020.05.04.21.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 21:04:20 -0700 (PDT)
Received: (nullmailer pid 28389 invoked by uid 1000);
        Tue, 05 May 2020 04:04:19 -0000
Date:   Mon, 4 May 2020 23:04:19 -0500
From:   Rob Herring <robh@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tero Kristo <t-kristo@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, netdev@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH net-next 1/7] dt-binding: ti: am65x: document common
 platform time sync cpts module
Message-ID: <20200505040419.GA8509@bogus>
References: <20200501205011.14899-1-grygorii.strashko@ti.com>
 <20200501205011.14899-2-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501205011.14899-2-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 01, 2020 at 11:50:05PM +0300, Grygorii Strashko wrote:
> Document device tree bindings for TI AM654/J721E SoC The Common Platform
> Time Sync (CPTS) module. The CPTS module is used to facilitate host control
> of time sync operations. Main features of CPTS module are:
>   - selection of multiple external clock sources
>   - 64-bit timestamp mode in ns with ppm and nudge adjustment.
>   - control of time sync events via interrupt or polling
>   - hardware timestamp of ext. events (HWx_TS_PUSH)
>   - periodic generator function outputs (TS_GENFx)
>   - PPS in combination with timesync router
>   - Depending on integration it enables compliance with the IEEE 1588-2008
> standard for a precision clock synchronization protocol, Ethernet Enhanced
> Scheduled Traffic Operations (CPTS_ESTFn) and PCIe Subsystem Precision Time
> Measurement (PTM).
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   |   7 +
>  .../bindings/net/ti,k3-am654-cpts.yaml        | 152 ++++++++++++++++++
>  2 files changed, 159 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> index 78bf511e2892..0f3fde45e200 100644
> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> @@ -144,6 +144,13 @@ patternProperties:
>      description:
>        CPSW MDIO bus.
>  
> +  "^cpts$":

Fixed strings go under 'properties'.

> +    type: object
> +    allOf:
> +      - $ref: "ti,am654-cpts.yaml#"
> +    description:
> +      CPSW Common Platform Time Sync (CPTS) module.
> +
>  required:
>    - compatible
>    - reg
> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
> new file mode 100644
> index 000000000000..1b535d41e5c6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
> @@ -0,0 +1,152 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/ti,am654-cpts.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: The TI AM654x/J721E Common Platform Time Sync (CPTS) module Device Tree Bindings
> +
> +maintainers:
> +  - Grygorii Strashko <grygorii.strashko@ti.com>
> +  - Sekhar Nori <nsekhar@ti.com>
> +
> +description: |+
> +  The TI AM654x/J721E CPTS module is used to facilitate host control of time
> +  sync operations.
> +  Main features of CPTS module are
> +  - selection of multiple external clock sources
> +  - Software control of time sync events via interrupt or polling
> +  - 64-bit timestamp mode in ns with PPM and nudge adjustment.
> +  - hardware timestamp push inputs (HWx_TS_PUSH)
> +  - timestamp counter compare output (TS_COMP)
> +  - timestamp counter bit output (TS_SYNC)
> +  - periodic Generator function outputs (TS_GENFx)
> +  - Ethernet Enhanced Scheduled Traffic Operations (CPTS_ESTFn) (TSN)
> +  - external hardware timestamp push inputs (HWx_TS_PUSH) timestamping
> +
> +   Depending on integration it enables compliance with the IEEE 1588-2008
> +   standard for a precision clock synchronization protocol, Ethernet Enhanced
> +   Scheduled Traffic Operations (CPTS_ESTFn) and PCIe Subsystem Precision Time
> +   Measurement (PTM).
> +
> +  TI AM654x/J721E SoCs has several similar CPTS modules integrated into the
> +  different parts of the system which could be synchronized with each other
> +  - Main CPTS
> +  - MCU CPSW CPTS with IEEE 1588-2008 support
> +  - PCIe subsystem CPTS for PTM support
> +
> +  Depending on CPTS module integration and when CPTS is integral part of
> +  another module (MCU CPSW for example) "compatible" and "reg" can
> +  be omitted - parent module is fully responsible for CPTS enabling and
> +  configuration.

That's fine, but you should still have compatible and reg.

> +
> +properties:
> +  $nodename:
> +    pattern: "^cpts(@.*|-[0-9a-f])*$"
> +
> +  compatible:
> +    oneOf:
> +      - const: ti,am65-cpts
> +      - const: ti,j721e-cpts
> +
> +  reg:
> +    maxItems: 1
> +    description:
> +       The physical base address and size of CPTS IO range

Wrong indentation.

> +
> +  reg-names:
> +    items:
> +      - const: cpts

Don't really need *-names when there's only one and you haven't picked 
very meaningful names.

> +
> +  clocks:
> +    description: CPTS reference clock
> +
> +  clock-names:
> +    items:
> +      - const: cpts
> +
> +  interrupts-extended:

Use 'interrupts' here, the tooling will fixup things to allow both.

> +    items:
> +      - description: CPTS events interrupt
> +
> +  interrupt-names:
> +    items:
> +      - const: "cpts"

Don't need quotes.

> +
> +  ti,cpts-ext-ts-inputs:
> +    allOf:
> +      - $ref: /schemas/types.yaml#/definitions/uint32
> +    maximum: 8
> +    description:
> +        Number of hardware timestamp push inputs (HWx_TS_PUSH)

Wrong indentation.

> +
> +  ti,cpts-periodic-outputs:
> +    allOf:
> +      - $ref: /schemas/types.yaml#/definitions/uint32
> +    maximum: 8
> +    description:
> +         Number of timestamp Generator function outputs (TS_GENFx)

Wrong indentation.

> +
> +  refclk-mux:
> +    type: object
> +    description: CPTS reference clock multiplexer clock
> +    properties:
> +      '#clock-cells':
> +        const: 0
> +
> +      clocks:
> +        maxItems: 8
> +
> +      assigned-clocks:
> +        maxItems: 1
> +
> +      assigned-clocks-parents:
> +        maxItems: 1
> +
> +    required:
> +      - clocks
> +
> +required:
> +  - clocks
> +  - clock-names
> +  - interrupts-extended
> +  - interrupt-names
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    cpts@310d0000 {
> +         compatible = "ti,am65-cpts";
> +         reg = <0x0 0x310d0000 0x0 0x400>;
> +         reg-names = "cpts";
> +         clocks = <&main_cpts_mux>;
> +         clock-names = "cpts";
> +         interrupts-extended = <&k3_irq 163 0 IRQ_TYPE_LEVEL_HIGH>;
> +         interrupt-names = "cpts";
> +         ti,cpts-periodic-outputs = <6>;
> +         ti,cpts-ext-ts-inputs = <8>;
> +
> +         main_cpts_mux: refclk-mux {
> +               #clock-cells = <0>;
> +               clocks = <&k3_clks 118 5>, <&k3_clks 118 11>,
> +                        <&k3_clks 157 91>, <&k3_clks 157 77>,
> +                        <&k3_clks 157 102>, <&k3_clks 157 80>,
> +                        <&k3_clks 120 3>, <&k3_clks 121 3>;
> +               assigned-clocks = <&main_cpts_mux>;
> +               assigned-clock-parents = <&k3_clks 118 11>;
> +         };
> +    };
> +  - |
> +
> +    cpts {
> +             clocks = <&k3_clks 18 2>;
> +             clock-names = "cpts";
> +             interrupts-extended = <&gic500 GIC_SPI 858 IRQ_TYPE_LEVEL_HIGH>;
> +             interrupt-names = "cpts";
> +             ti,cpts-ext-ts-inputs = <4>;
> +             ti,cpts-periodic-outputs = <2>;

How is this example accessed?

> +    };
> -- 
> 2.17.1
> 
