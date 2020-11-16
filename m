Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42722B4624
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 15:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730337AbgKPOpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 09:45:38 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:33950 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbgKPOpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 09:45:38 -0500
Received: by mail-oi1-f196.google.com with SMTP id w188so19043868oib.1;
        Mon, 16 Nov 2020 06:45:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6FKs5LWi3CfnqMqEIY0TTQAgbNfsS+k9MsKXgT+oPpU=;
        b=r7lgm21Bx/4HF5xWxAu/FEdT0N4bh6wiAVylsF948CU2MBcr1k7wyPvjNQGNhR69uc
         +z5QQKK8b7V/HTEqeqUC9vfh8G2IHcRllIxbjEQYF885QWr9HOy7B1mVaxxTA+Pj9Hhe
         vLvOEuxaNq2hgm1lsRxUgqrN5/v7cQeLoScYB2Z9TVNND3uwcDnlSYJn7XUlCW1WBTWB
         eezzbBSXC9bIsJ88TVIfavVZp4SQio6jgX4TClh2Q6wS+G+P2cIgN1X3GLmeewIfn3+S
         5MhwbIfC6z1D6SOWdrM5pktEBwSfNtd7FIyh+kXKLH07y7WN6PPnDLL0GaoOQX4RF8tr
         dtKQ==
X-Gm-Message-State: AOAM533PoDZb8FW3Zkq11QvMK7kCpkWF86snLz2sKIiiEYw4j0f5Kajo
        wz373qW9IBDZWXC0MDBetw==
X-Google-Smtp-Source: ABdhPJx6UhBacGINT7vC6uIaZtfpqLXz/VA5MzH1mLXbngxiFuMK5M09R3YzAPUpZdPXpPX0pzlt5w==
X-Received: by 2002:aca:492:: with SMTP id 140mr9463058oie.108.1605537936587;
        Mon, 16 Nov 2020 06:45:36 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 12sm4927532oiq.9.2020.11.16.06.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 06:45:35 -0800 (PST)
Received: (nullmailer pid 1623228 invoked by uid 1000);
        Mon, 16 Nov 2020 14:45:34 -0000
Date:   Mon, 16 Nov 2020 08:45:34 -0600
From:   Rob Herring <robh@kernel.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 01/11] dt-bindings: net: dsa: convert ksz
 bindings document to yaml
Message-ID: <20201116144534.GB1611573@bogus>
References: <20201112153537.22383-1-ceggers@arri.de>
 <20201112153537.22383-2-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112153537.22383-2-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 04:35:27PM +0100, Christian Eggers wrote:
> Convert the bindings document for Microchip KSZ Series Ethernet switches
> from txt to yaml.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---
>  .../devicetree/bindings/net/dsa/ksz.txt       | 125 ---------------
>  .../bindings/net/dsa/microchip,ksz.yaml       | 150 ++++++++++++++++++
>  MAINTAINERS                                   |   2 +-
>  3 files changed, 151 insertions(+), 126 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/dsa/ksz.txt
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml

[...]

> diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> new file mode 100644
> index 000000000000..431ca5c498a8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> @@ -0,0 +1,150 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/microchip,ksz.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Microchip KSZ Series Ethernet switches
> +
> +allOf:
> +  - $ref: dsa.yaml#
> +
> +maintainers:
> +  - Marek Vasut <marex@denx.de>
> +  - Woojung Huh <Woojung.Huh@microchip.com>
> +
> +properties:
> +  # See Documentation/devicetree/bindings/net/dsa/dsa.yaml for a list of additional
> +  # required and optional properties.
> +  compatible:
> +    enum:
> +      - "microchip,ksz8765"
> +      - "microchip,ksz8794"
> +      - "microchip,ksz8795"
> +      - "microchip,ksz9477"
> +      - "microchip,ksz9897"
> +      - "microchip,ksz9896"
> +      - "microchip,ksz9567"
> +      - "microchip,ksz8565"
> +      - "microchip,ksz9893"
> +      - "microchip,ksz9563"
> +      - "microchip,ksz8563"

Don't need quotes.

> +
> +  reset-gpios:
> +    description:
> +      Should be a gpio specifier for a reset line.
> +    maxItems: 1
> +
> +  microchip,synclko-125:
> +    $ref: /schemas/types.yaml#/definitions/flag
> +    description:
> +      Set if the output SYNCLKO frequency should be set to 125MHz instead of 25MHz.
> +
> +required:
> +  - compatible
> +  - reg
> +
> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +
> +    // Ethernet switch connected via SPI to the host, CPU port wired to eth0:
> +    eth0 {
> +        fixed-link {
> +            speed = <1000>;
> +            full-duplex;
> +        };
> +    };
> +
> +    spi0 {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        pinctrl-0 = <&pinctrl_spi_ksz>;
> +        cs-gpios = <&pioC 25 0>;
> +        id = <1>;
> +
> +        ksz9477: switch@0 {
> +            compatible = "microchip,ksz9477";
> +            reg = <0>;
> +            reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
> +
> +            spi-max-frequency = <44000000>;
> +            spi-cpha;
> +            spi-cpol;
> +
> +            ethernet-ports {
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +                port@0 {
> +                    reg = <0>;
> +                    label = "lan1";
> +                };
> +                port@1 {
> +                    reg = <1>;
> +                    label = "lan2";
> +                };
> +                port@2 {
> +                    reg = <2>;
> +                    label = "lan3";
> +                };
> +                port@3 {
> +                    reg = <3>;
> +                    label = "lan4";
> +                };
> +                port@4 {
> +                    reg = <4>;
> +                    label = "lan5";
> +                };
> +                port@5 {
> +                    reg = <5>;
> +                    label = "cpu";
> +                    ethernet = <&eth0>;
> +                    fixed-link {
> +                        speed = <1000>;
> +                        full-duplex;
> +                    };
> +                };
> +            };
> +        };
> +
> +        ksz8565: switch@1 {
> +            compatible = "microchip,ksz8565";
> +            reg = <1>;
> +
> +            spi-max-frequency = <44000000>;
> +            spi-cpha;
> +            spi-cpol;
> +
> +            ethernet-ports {
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +                port@0 {
> +                    reg = <0>;
> +                    label = "lan1";
> +                };
> +                port@1 {
> +                    reg = <1>;
> +                    label = "lan2";
> +                };
> +                port@2 {
> +                    reg = <2>;
> +                    label = "lan3";
> +                };
> +                port@3 {
> +                    reg = <3>;
> +                    label = "lan4";
> +                };
> +                port@6 {
> +                    reg = <6>;
> +                    label = "cpu";
> +                    ethernet = <&eth0>;
> +                    fixed-link {
> +                        speed = <1000>;
> +                        full-duplex;
> +                    };
> +                };
> +            };
> +        };
> +    };
> +...
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1e7d1d71c125..3d173fcbf119 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11518,7 +11518,7 @@ M:	Woojung Huh <woojung.huh@microchip.com>
>  M:	Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
>  L:	netdev@vger.kernel.org
>  S:	Maintained
> -F:	Documentation/devicetree/bindings/net/dsa/ksz.txt
> +F:	Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
>  F:	drivers/net/dsa/microchip/*
>  F:	include/linux/platform_data/microchip-ksz.h
>  F:	net/dsa/tag_ksz.c
> -- 
> Christian Eggers
> Embedded software developer
> 
> Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
> Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
> Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
> Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
> Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler
> 
