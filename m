Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B382B93E7
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 14:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgKSNsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 08:48:06 -0500
Received: from mail-oo1-f68.google.com ([209.85.161.68]:40531 "EHLO
        mail-oo1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726644AbgKSNsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 08:48:05 -0500
Received: by mail-oo1-f68.google.com with SMTP id t142so1351104oot.7;
        Thu, 19 Nov 2020 05:48:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t9+s1ApXC1taKZdVie+MQcAAj+ApC6em5/9UfA0Cqa4=;
        b=YWxv4g/0B8QijLSD1tABVNCIRoQ8RHvHfepsRsxEkvPD6m9Px8DzT5/DA/qCfy9/S0
         9+NyCaL8YHnDSaA30GRTtEIKyh+1/XOYSslHsBDuWO5Bu4BDSrlWvvIFySW62a/bYBPN
         TzBwhyGP+nTXOSCMdcrtzUOF9JQ/tLep8V44KMD9e5/ooJnaDDrUXKS6ftTfiyv9oTJc
         vScfqTzPI7pcGEDzBS+UaW9lmudtV35L20LFXPKsIaGIcrE0xId8cwec6g5IP/R29fAv
         qcq68w0GUmsVzMPU3NiD1nDxW/NdRZr7je7ksMoi4iv//AAqxe2hHLBpcUfSR95tpUG/
         R9kA==
X-Gm-Message-State: AOAM532JZ+vYVNcKUH6o+WrqX7D/H8O6rn4GCRVm/j1LmnZBREFzxFPT
        FhcVxto6+L00QoEDfrOh9w==
X-Google-Smtp-Source: ABdhPJxio6D8tQt9OxKmeGLgNbbJpbzhZDaoVQX6XiRtZ3HghBgRL/sNUbG5IbGsw00PCxLUoQHuhw==
X-Received: by 2002:a4a:8742:: with SMTP id a2mr10109788ooi.23.1605793683419;
        Thu, 19 Nov 2020 05:48:03 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id l19sm8896459otp.65.2020.11.19.05.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 05:48:02 -0800 (PST)
Received: (nullmailer pid 3157673 invoked by uid 1000);
        Thu, 19 Nov 2020 13:48:01 -0000
Date:   Thu, 19 Nov 2020 07:48:01 -0600
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
Subject: Re: [PATCH net-next v3 01/12] dt-bindings: net: dsa: convert ksz
 bindings document to yaml
Message-ID: <20201119134801.GB3149565@bogus>
References: <20201118203013.5077-1-ceggers@arri.de>
 <20201118203013.5077-2-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118203013.5077-2-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 09:30:02PM +0100, Christian Eggers wrote:
> Convert the bindings document for Microchip KSZ Series Ethernet switches
> from txt to yaml.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---
>  .../devicetree/bindings/net/dsa/ksz.txt       | 125 --------------
>  .../bindings/net/dsa/microchip,ksz.yaml       | 152 ++++++++++++++++++
>  MAINTAINERS                                   |   2 +-
>  3 files changed, 153 insertions(+), 126 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/dsa/ksz.txt
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/ksz.txt b/Documentation/devicetree/bindings/net/dsa/ksz.txt
> deleted file mode 100644
> index 95e91e84151c..000000000000
> --- a/Documentation/devicetree/bindings/net/dsa/ksz.txt
> +++ /dev/null
> @@ -1,125 +0,0 @@
> -Microchip KSZ Series Ethernet switches
> -==================================
> -
> -Required properties:
> -
> -- compatible: For external switch chips, compatible string must be exactly one
> -  of the following:
> -  - "microchip,ksz8765"
> -  - "microchip,ksz8794"
> -  - "microchip,ksz8795"
> -  - "microchip,ksz9477"
> -  - "microchip,ksz9897"
> -  - "microchip,ksz9896"
> -  - "microchip,ksz9567"
> -  - "microchip,ksz8565"
> -  - "microchip,ksz9893"
> -  - "microchip,ksz9563"
> -  - "microchip,ksz8563"
> -
> -Optional properties:
> -
> -- reset-gpios		: Should be a gpio specifier for a reset line
> -- microchip,synclko-125 : Set if the output SYNCLKO frequency should be set to
> -			  125MHz instead of 25MHz.
> -
> -See Documentation/devicetree/bindings/net/dsa/dsa.txt for a list of additional
> -required and optional properties.
> -
> -Examples:
> -
> -Ethernet switch connected via SPI to the host, CPU port wired to eth0:
> -
> -	eth0: ethernet@10001000 {
> -		fixed-link {
> -			speed = <1000>;
> -			full-duplex;
> -		};
> -	};
> -
> -	spi1: spi@f8008000 {
> -		pinctrl-0 = <&pinctrl_spi_ksz>;
> -		cs-gpios = <&pioC 25 0>;
> -		id = <1>;
> -
> -		ksz9477: ksz9477@0 {
> -			compatible = "microchip,ksz9477";
> -			reg = <0>;
> -
> -			spi-max-frequency = <44000000>;
> -			spi-cpha;
> -			spi-cpol;
> -
> -			ports {
> -				#address-cells = <1>;
> -				#size-cells = <0>;
> -				port@0 {
> -					reg = <0>;
> -					label = "lan1";
> -				};
> -				port@1 {
> -					reg = <1>;
> -					label = "lan2";
> -				};
> -				port@2 {
> -					reg = <2>;
> -					label = "lan3";
> -				};
> -				port@3 {
> -					reg = <3>;
> -					label = "lan4";
> -				};
> -				port@4 {
> -					reg = <4>;
> -					label = "lan5";
> -				};
> -				port@5 {
> -					reg = <5>;
> -					label = "cpu";
> -					ethernet = <&eth0>;
> -					fixed-link {
> -						speed = <1000>;
> -						full-duplex;
> -					};
> -				};
> -			};
> -		};
> -		ksz8565: ksz8565@0 {
> -			compatible = "microchip,ksz8565";
> -			reg = <0>;
> -
> -			spi-max-frequency = <44000000>;
> -			spi-cpha;
> -			spi-cpol;
> -
> -			ports {
> -				#address-cells = <1>;
> -				#size-cells = <0>;
> -				port@0 {
> -					reg = <0>;
> -					label = "lan1";
> -				};
> -				port@1 {
> -					reg = <1>;
> -					label = "lan2";
> -				};
> -				port@2 {
> -					reg = <2>;
> -					label = "lan3";
> -				};
> -				port@3 {
> -					reg = <3>;
> -					label = "lan4";
> -				};
> -				port@6 {
> -					reg = <6>;
> -					label = "cpu";
> -					ethernet = <&eth0>;
> -					fixed-link {
> -						speed = <1000>;
> -						full-duplex;
> -					};
> -				};
> -			};
> -		};
> -	};
> diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> new file mode 100644
> index 000000000000..010adb09a68f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> @@ -0,0 +1,152 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/microchip,ksz.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Microchip KSZ Series Ethernet switches
> +
> +allOf:
> +  - $ref: dsa.yaml#

Move this after 'maintainers'.

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
> +      - microchip,ksz8765
> +      - microchip,ksz8794
> +      - microchip,ksz8795
> +      - microchip,ksz9477
> +      - microchip,ksz9897
> +      - microchip,ksz9896
> +      - microchip,ksz9567
> +      - microchip,ksz8565
> +      - microchip,ksz9893
> +      - microchip,ksz9563
> +      - microchip,ksz8563
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
> +additionalProperties: false

You need to use unevaluatedProperties instead.

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

Are these 2 optional or required? Being optional is rare as most 
devices support 1 mode, but not unheard of. In general, you shouldn't 
need them as the driver should know how to configure the mode if the h/w 
is fixed.

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
> index 18b5b7896af8..d1003033412f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11508,7 +11508,7 @@ M:	Woojung Huh <woojung.huh@microchip.com>
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
