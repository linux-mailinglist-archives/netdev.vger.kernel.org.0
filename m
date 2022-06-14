Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F81654BC06
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 22:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiFNUpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 16:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357385AbiFNUnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 16:43:50 -0400
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB7519014;
        Tue, 14 Jun 2022 13:43:49 -0700 (PDT)
Received: by mail-io1-f50.google.com with SMTP id a10so10668605ioe.9;
        Tue, 14 Jun 2022 13:43:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EWCrP2gVR6iEKu6wld+fLLcPN5tCwcbqGWbRuRjzj3E=;
        b=OLFMIalh9qPeLI5fmJNnH2JtEGCs+Y8XcCSMNa1jJxJCT1YFNc4MYs7ywx8afdc0ga
         ihSlAG8d2ljbWRAub3Sk/EOMZ7MBza8X8/grdwshQg+u8PA8O1s31TXno/JhwOyrO3df
         ANWDynI/mYIN2rcgDkcn41xZkDtjpQfevlTt9SnIKrgnc6fB7t5W3wJGNAOZWe4FPHdT
         XxZGfEC6mXLsgGU2chCX+AUcD5EAcE9uY3fUXH7YGLgq07v2mjOvXZIKpPavTu3VIc3H
         yisVFu9KcxHD5qy9bocWx7y/lKRb8XyPTY9NOF+zVbIVitC067mgX9V8fWBV/qURVqPK
         p+vQ==
X-Gm-Message-State: AOAM533SykWBwCk1m0Dcx+a+RimGwegO/jqaIPn4GaNvVeHcmKpG2oaG
        N1quFebJws8E4cDJD1PryQ==
X-Google-Smtp-Source: ABdhPJyquQnI3HE8yYQ+8Libvzpe4msNa30paW2QwWTY1sk6eZSq9sHUV4oG33HdAbAGa6d2P4Bo5Q==
X-Received: by 2002:a05:6638:1c19:b0:331:d0b7:4cfe with SMTP id ca25-20020a0566381c1900b00331d0b74cfemr3983850jab.311.1655239428886;
        Tue, 14 Jun 2022 13:43:48 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id n42-20020a02716a000000b0033197f42be0sm5230647jaf.157.2022.06.14.13.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 13:43:48 -0700 (PDT)
Received: (nullmailer pid 2487460 invoked by uid 1000);
        Tue, 14 Jun 2022 20:43:45 -0000
Date:   Tue, 14 Jun 2022 14:43:45 -0600
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v10 net-next 6/7] dt-bindings: mfd: ocelot: add bindings
 for VSC7512
Message-ID: <20220614204345.GA2419690-robh@kernel.org>
References: <20220610202330.799510-1-colin.foster@in-advantage.com>
 <20220610202330.799510-7-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610202330.799510-7-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 01:23:29PM -0700, Colin Foster wrote:
> Add devicetree bindings for SPI-controlled Ocelot chips, specifically the
> VSC7512.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  .../devicetree/bindings/mfd/mscc,ocelot.yaml  | 160 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  2 files changed, 161 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
> 
> diff --git a/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml b/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
> new file mode 100644
> index 000000000000..e298ca8d616d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
> @@ -0,0 +1,160 @@
> +# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/mfd/mscc,ocelot.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Ocelot Externally-Controlled Ethernet Switch
> +
> +maintainers:
> +  - Colin Foster <colin.foster@in-advantage.com>
> +
> +description: |
> +  The Ocelot ethernet switch family contains chips that have an internal CPU
> +  (VSC7513, VSC7514) and chips that don't (VSC7511, VSC7512). All switches have
> +  the option to be controlled externally, which is the purpose of this driver.
> +
> +  The switch family is a multi-port networking switch that supports many
> +  interfaces. Additionally, the device can perform pin control, MDIO buses, and
> +  external GPIO expanders.
> +
> +properties:
> +  compatible:
> +    enum:
> +      - mscc,vsc7512-spi

'-spi' is redundant as we know what bus this is on looking at the 
parent.

> +
> +  reg:
> +    maxItems: 1
> +
> +  "#address-cells":
> +    const: 1
> +
> +  "#size-cells":
> +    const: 0

No size? That's odd given the child nodes are the same as memory mapped 
peripherals which expect a size.

> +
> +  spi-max-frequency:
> +    maxItems: 1
> +
> +patternProperties:
> +  "^pinctrl@[0-9a-f]+$":
> +    type: object
> +    $ref: /schemas/pinctrl/mscc,ocelot-pinctrl.yaml
> +
> +  "^gpio@[0-9a-f]+$":
> +    type: object
> +    $ref: /schemas/pinctrl/microchip,sparx5-sgpio.yaml
> +    properties:
> +      compatible:
> +        enum:
> +          - mscc,ocelot-sgpio
> +
> +  "^mdio@[0-9a-f]+$":
> +    type: object
> +    $ref: /schemas/net/mscc,miim.yaml
> +    properties:
> +      compatible:
> +        enum:
> +          - mscc,ocelot-miim
> +
> +required:
> +  - compatible
> +  - reg
> +  - '#address-cells'
> +  - '#size-cells'
> +  - spi-max-frequency
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    ocelot_clock: ocelot-clock {
> +          compatible = "fixed-clock";
> +          #clock-cells = <0>;
> +          clock-frequency = <125000000>;
> +      };
> +
> +    spi0 {

spi {

> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        ocelot-chip@0 {

Node names should be generic. I don't think we have a formal definition, 
but 'switch' seems to be most common.

> +            compatible = "mscc,vsc7512-spi";
> +            spi-max-frequency = <2500000>;
> +            reg = <0>;
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +            mdio0: mdio@7107009c {

Drop unused labels.

> +                compatible = "mscc,ocelot-miim";
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +                reg = <0x7107009c>;
> +
> +                sw_phy0: ethernet-phy@0 {
> +                    reg = <0x0>;
> +                };
> +            };
> +
> +            mdio1: mdio@710700c0 {
> +                compatible = "mscc,ocelot-miim";
> +                pinctrl-names = "default";
> +                pinctrl-0 = <&miim1_pins>;
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +                reg = <0x710700c0>;
> +
> +                sw_phy4: ethernet-phy@4 {
> +                    reg = <0x4>;
> +                };
> +            };
> +
> +            gpio: pinctrl@71070034 {
> +                compatible = "mscc,ocelot-pinctrl";
> +                gpio-controller;
> +                #gpio-cells = <2>;
> +                gpio-ranges = <&gpio 0 0 22>;
> +                reg = <0x71070034>;
> +
> +                sgpio_pins: sgpio-pins {
> +                    pins = "GPIO_0", "GPIO_1", "GPIO_2", "GPIO_3";
> +                    function = "sg0";
> +                };
> +
> +                miim1_pins: miim1-pins {
> +                    pins = "GPIO_14", "GPIO_15";
> +                    function = "miim";
> +                };
> +            };
> +
> +            sgpio: gpio@710700f8 {
> +                compatible = "mscc,ocelot-sgpio";
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +                bus-frequency = <12500000>;
> +                clocks = <&ocelot_clock>;
> +                microchip,sgpio-port-ranges = <0 15>;
> +                pinctrl-names = "default";
> +                pinctrl-0 = <&sgpio_pins>;
> +                reg = <0x710700f8>;
> +
> +                sgpio_in0: gpio@0 {
> +                    compatible = "microchip,sparx5-sgpio-bank";
> +                    reg = <0>;
> +                    gpio-controller;
> +                    #gpio-cells = <3>;
> +                    ngpios = <64>;
> +                };
> +
> +                sgpio_out1: gpio@1 {
> +                    compatible = "microchip,sparx5-sgpio-bank";
> +                    reg = <1>;
> +                    gpio-controller;
> +                    #gpio-cells = <3>;
> +                    ngpios = <64>;
> +                };
> +            };
> +        };
> +    };
> +
> +...
> +
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 91b4151c5ad1..119fb4207ba3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14355,6 +14355,7 @@ F:	tools/testing/selftests/drivers/net/ocelot/*
>  OCELOT EXTERNAL SWITCH CONTROL
>  M:	Colin Foster <colin.foster@in-advantage.com>
>  S:	Supported
> +F:	Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
>  F:	include/linux/mfd/ocelot.h
>  
>  OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
> -- 
> 2.25.1
> 
> 
