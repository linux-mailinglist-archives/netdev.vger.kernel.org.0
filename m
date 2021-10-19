Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E81F434025
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 23:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbhJSVH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 17:07:29 -0400
Received: from mail-oo1-f44.google.com ([209.85.161.44]:36475 "EHLO
        mail-oo1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbhJSVH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 17:07:28 -0400
Received: by mail-oo1-f44.google.com with SMTP id r1-20020a4a9641000000b002b6b55007bfso1394175ooi.3;
        Tue, 19 Oct 2021 14:05:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Uovi01bpGrOsxAesgYaedpo5qleHPu+gqmazQ2PqE9k=;
        b=JPdrbqrTEym/rHI3awRnPbGD2ADPQFToPy+EpDmjOV2s94MzbEQ4TFS94lfCCIR5mg
         HiolR1PhdW2LFC7GbO10gIoetZ2gH7L2wkUkas9tF6CwzVV/kkhalMwEeGsjhp+PQBhg
         qWFH5vTCyNI3Q7x2Lh7k6nNWNtEI40kJzo4L706AqtamzOqPDBux7sBgC5dZv45MpDwg
         7Lk+RLGa6dMgZHEG2AeDuM1uyK8o02uvPeblIG0WxkpQiMDTWheah7hYk2tloQvtf4Yj
         oSTmQHXu20zRZ0dxmOy9PX6W/RI056+DlCEV11QZVPAaBONz5spTR0Q8m4UPAW9erQ4h
         rSNg==
X-Gm-Message-State: AOAM532XwCIwrAMPRu56BFs0XKGoXay+C11Ub9JnwDN3oOfoiPnotelI
        4HA8JnozOZ+/GOQ6QMMRvQ==
X-Google-Smtp-Source: ABdhPJyhyPQNMuR+qw1Jvcgnm5CRqVy/8fHEBr0brrssYczt14ecIiGtUQ/haQB3wGcqQ92i3Puoyw==
X-Received: by 2002:a4a:b90d:: with SMTP id x13mr6602641ooo.25.1634677514932;
        Tue, 19 Oct 2021 14:05:14 -0700 (PDT)
Received: from robh.at.kernel.org (rrcs-67-78-118-34.sw.biz.rr.com. [67.78.118.34])
        by smtp.gmail.com with ESMTPSA id u21sm33948oiv.25.2021.10.19.14.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 14:05:13 -0700 (PDT)
Received: (nullmailer pid 836872 invoked by uid 1000);
        Tue, 19 Oct 2021 21:05:05 -0000
Date:   Tue, 19 Oct 2021 16:05:05 -0500
From:   Rob Herring <robh@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@armlinux.org.uk>,
        David Lechner <david@lechnology.com>,
        Sebastian Reichel <sre@kernel.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 2/3] dt-bindings: net: wireless: ti,wlcore: Convert to
 json-schema
Message-ID: <YW8zAR0aeSduLRoD@robh.at.kernel.org>
References: <cover.1634646975.git.geert+renesas@glider.be>
 <23a2fbc46255a988e5d36f6c14abb7130480d200.1634646975.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23a2fbc46255a988e5d36f6c14abb7130480d200.1634646975.git.geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 02:43:12PM +0200, Geert Uytterhoeven wrote:
> The Texas Instruments Wilink 6/7/8 (wl12xx/wl18xx) Wireless LAN
> Controllers can be connected via SPI or via SDIO.
> Convert the two Device Tree binding documents to json-schema, and merge
> them into a single document.
> 
> Add missing ti,wl1285 compatible value.
> Add missing interrupt-names property.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>   - The wlcore driver is marked orphan in MAINTAINERS.  Both Tony and
>     Russell made recent bugfixes, and my not-so-random coin picked Tony
>     as a suitable maintainer.  Please scream if not appropriate.
>   - How to express if a property is required when connected to a
>     specific bus type?

There isn't a (simple) way within this schema, but IIRC the spi bus 
schema already requires 'reg' in child nodes.

Otherwise, looks good and I'll queue.

> ---
>  .../devicetree/bindings/net/ti-bluetooth.txt  |   2 +-
>  .../bindings/net/wireless/ti,wlcore,spi.txt   |  57 --------
>  .../bindings/net/wireless/ti,wlcore.txt       |  45 ------
>  .../bindings/net/wireless/ti,wlcore.yaml      | 134 ++++++++++++++++++
>  arch/arm/boot/dts/omap3-gta04a5.dts           |   2 +-
>  5 files changed, 136 insertions(+), 104 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt
>  delete mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore.txt
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/ti-bluetooth.txt b/Documentation/devicetree/bindings/net/ti-bluetooth.txt
> index f48c17b38f5851de..3c01cfc1e12dc132 100644
> --- a/Documentation/devicetree/bindings/net/ti-bluetooth.txt
> +++ b/Documentation/devicetree/bindings/net/ti-bluetooth.txt
> @@ -13,7 +13,7 @@ and GPS over what's called "shared transport". The shared transport is
>  standard BT HCI protocol with additional channels for the other functions.
>  
>  TI WiLink devices also have a separate WiFi interface as described in
> -wireless/ti,wlcore.txt.
> +wireless/ti,wlcore.yaml.
>  
>  This bindings follows the UART slave device binding in ../serial/serial.yaml.
>  
> diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt b/Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt
> deleted file mode 100644
> index cb5c9e1569ca5300..0000000000000000
> --- a/Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt
> +++ /dev/null
> @@ -1,57 +0,0 @@
> -* Texas Instruments wl12xx/wl18xx wireless lan controller
> -
> -The wl12xx/wl18xx chips can be connected via SPI or via SDIO. This
> -document describes the binding for the SPI connected chip.
> -
> -Required properties:
> -- compatible :          Should be one of the following:
> -    * "ti,wl1271"
> -    * "ti,wl1273"
> -    * "ti,wl1281"
> -    * "ti,wl1283"
> -    * "ti,wl1801"
> -    * "ti,wl1805"
> -    * "ti,wl1807"
> -    * "ti,wl1831"
> -    * "ti,wl1835"
> -    * "ti,wl1837"
> -- reg :                 Chip select address of device
> -- spi-max-frequency :   Maximum SPI clocking speed of device in Hz
> -- interrupts :          Should contain parameters for 1 interrupt line.
> -- vwlan-supply :        Point the node of the regulator that powers/enable the
> -                        wl12xx/wl18xx chip
> -
> -Optional properties:
> -- ref-clock-frequency : Reference clock frequency (should be set for wl12xx)
> -- clock-xtal :          boolean, clock is generated from XTAL
> -
> -- Please consult Documentation/devicetree/bindings/spi/spi-bus.txt
> -  for optional SPI connection related properties,
> -
> -Examples:
> -
> -For wl12xx family:
> -&spi1 {
> -	wlcore: wlcore@1 {
> -		compatible = "ti,wl1271";
> -		reg = <1>;
> -		spi-max-frequency = <48000000>;
> -		interrupt-parent = <&gpio3>;
> -		interrupts = <8 IRQ_TYPE_LEVEL_HIGH>;
> -		vwlan-supply = <&vwlan_fixed>;
> -		clock-xtal;
> -		ref-clock-frequency = <38400000>;
> -	};
> -};
> -
> -For wl18xx family:
> -&spi0 {
> -	wlcore: wlcore@0 {
> -		compatible = "ti,wl1835";
> -		reg = <0>;
> -		spi-max-frequency = <48000000>;
> -		interrupt-parent = <&gpio0>;
> -		interrupts = <27 IRQ_TYPE_EDGE_RISING>;
> -		vwlan-supply = <&vwlan_fixed>;
> -	};
> -};
> diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wlcore.txt b/Documentation/devicetree/bindings/net/wireless/ti,wlcore.txt
> deleted file mode 100644
> index 9306c4dadd46aea7..0000000000000000
> --- a/Documentation/devicetree/bindings/net/wireless/ti,wlcore.txt
> +++ /dev/null
> @@ -1,45 +0,0 @@
> -TI Wilink 6/7/8 (wl12xx/wl18xx) SDIO devices
> -
> -This node provides properties for controlling the wilink wireless device. The
> -node is expected to be specified as a child node to the SDIO controller that
> -connects the device to the system.
> -
> -Required properties:
> - - compatible: should be one of the following:
> -    * "ti,wl1271"
> -    * "ti,wl1273"
> -    * "ti,wl1281"
> -    * "ti,wl1283"
> -    * "ti,wl1285"
> -    * "ti,wl1801"
> -    * "ti,wl1805"
> -    * "ti,wl1807"
> -    * "ti,wl1831"
> -    * "ti,wl1835"
> -    * "ti,wl1837"
> - - interrupts : specifies attributes for the out-of-band interrupt.
> -
> -Optional properties:
> - - ref-clock-frequency : ref clock frequency in Hz
> - - tcxo-clock-frequency : tcxo clock frequency in Hz
> -
> -Note: the *-clock-frequency properties assume internal clocks. In case of external
> -clock, new bindings (for parsing the clock nodes) have to be added.
> -
> -Example:
> -
> -&mmc3 {
> -	vmmc-supply = <&wlan_en_reg>;
> -	bus-width = <4>;
> -	cap-power-off-card;
> -	keep-power-in-suspend;
> -
> -	#address-cells = <1>;
> -	#size-cells = <0>;
> -	wlcore: wlcore@2 {
> -		compatible = "ti,wl1835";
> -		reg = <2>;
> -		interrupt-parent = <&gpio0>;
> -		interrupts = <19 IRQ_TYPE_LEVEL_HIGH>;
> -	};
> -};
> diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml b/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
> new file mode 100644
> index 0000000000000000..8dd164d10290082a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
> @@ -0,0 +1,134 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/wireless/ti,wlcore.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Texas Instruments Wilink 6/7/8 (wl12xx/wl18xx) Wireless LAN Controller
> +
> +maintainers:
> +  - Tony Lindgren <tony@atomide.com>
> +
> +description:
> +  The wl12xx/wl18xx chips can be connected via SPI or via SDIO.
> +  Note that the *-clock-frequency properties assume internal clocks.  In case
> +  of external clocks, new bindings (for parsing the clock nodes) have to be
> +  added.
> +
> +properties:
> +  compatible:
> +    enum:
> +      - ti,wl1271
> +      - ti,wl1273
> +      - ti,wl1281
> +      - ti,wl1283
> +      - ti,wl1285
> +      - ti,wl1801
> +      - ti,wl1805
> +      - ti,wl1807
> +      - ti,wl1831
> +      - ti,wl1835
> +      - ti,wl1837
> +
> +  reg:
> +    maxItems: 1
> +    description:
> +      This is required when connected via SPI, and optional when connected via
> +      SDIO.
> +
> +  spi-max-frequency: true
> +
> +  interrupts:
> +    minItems: 1
> +    maxItems: 2
> +
> +  interrupt-names:
> +    items:
> +      - const: irq
> +      - const: wakeup
> +
> +  vwlan-supply:
> +    description:
> +      Points to the node of the regulator that powers/enable the wl12xx/wl18xx
> +      chip.  This is required when connected via SPI.
> +
> +
> +  ref-clock-frequency:
> +    description: Reference clock frequency.
> +
> +  tcxo-clock-frequency:
> +    description: TCXO clock frequency.
> +
> +  clock-xtal:
> +    $ref: /schemas/types.yaml#/definitions/flag
> +    description: Indicates that the clock is generated from XTAL.
> +
> +required:
> +  - compatible
> +  - interrupts
> +
> +if:
> +  properties:
> +    compatible:
> +      contains:
> +        enum:
> +          - ti,wl1271
> +          - ti,wl1273
> +          - ti,wl1281
> +          - ti,wl1283
> +then:
> +  required:
> +    - ref-clock-frequency
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +
> +    // For wl12xx family:
> +    spi1 {
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +            wlcore1: wlcore@1 {
> +                    compatible = "ti,wl1271";
> +                    reg = <1>;
> +                    spi-max-frequency = <48000000>;
> +                    interrupts = <8 IRQ_TYPE_LEVEL_HIGH>;
> +                    vwlan-supply = <&vwlan_fixed>;
> +                    clock-xtal;
> +                    ref-clock-frequency = <38400000>;
> +            };
> +    };
> +
> +    // For wl18xx family:
> +    spi2 {
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +            wlcore2: wlcore@0 {
> +                    compatible = "ti,wl1835";
> +                    reg = <0>;
> +                    spi-max-frequency = <48000000>;
> +                    interrupts = <27 IRQ_TYPE_EDGE_RISING>;
> +                    vwlan-supply = <&vwlan_fixed>;
> +            };
> +    };
> +
> +    // SDIO example:
> +    mmc3 {
> +            vmmc-supply = <&wlan_en_reg>;
> +            bus-width = <4>;
> +            cap-power-off-card;
> +            keep-power-in-suspend;
> +
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +            wlcore3: wlcore@2 {
> +                    compatible = "ti,wl1835";
> +                    reg = <2>;
> +                    interrupts = <19 IRQ_TYPE_LEVEL_HIGH>;
> +            };
> +    };
> diff --git a/arch/arm/boot/dts/omap3-gta04a5.dts b/arch/arm/boot/dts/omap3-gta04a5.dts
> index a2ba4030cf279683..0b5bd73888771438 100644
> --- a/arch/arm/boot/dts/omap3-gta04a5.dts
> +++ b/arch/arm/boot/dts/omap3-gta04a5.dts
> @@ -79,7 +79,7 @@ OMAP3_CORE1_IOPAD(0x2138, PIN_INPUT | MUX_MODE4) /* gpin114 */
>  
>  /*
>   * for WL183x module see
> - * Documentation/devicetree/bindings/net/wireless/ti,wlcore.txt
> + * Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
>   */
>  
>  &wifi_pwrseq {
> -- 
> 2.25.1
> 
> 
