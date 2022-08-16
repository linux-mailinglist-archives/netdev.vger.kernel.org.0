Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1045B59641A
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 23:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbiHPVCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 17:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbiHPVCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 17:02:30 -0400
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8EB754A2;
        Tue, 16 Aug 2022 14:02:27 -0700 (PDT)
Received: by mail-io1-f48.google.com with SMTP id p184so5862880iod.6;
        Tue, 16 Aug 2022 14:02:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=l4egLvTsPGkFbTjp++Gcne3a5KH6iCWzI7mVj0VbmgI=;
        b=OWSedXF4AOIGYO4YRW1ELMFaUvoY9gz/C6A8OM8DK8DP0RY5JlsGHv/lfU+Zp67dvv
         LpEv7EVkJaUj7sVYzAvbd8EG7YLZWKueXsj9UvPgXtFZcwvYY4Oql48VlNYMRtColfBN
         ZWuyzn2eb994K/Z9CLo0IHuuKA+523wEeq8I7LlaLkqL5AksGlNqbJhwR/TNsRyMOCOI
         vs8rcVVLftnmlJJzB7Hk/u8eoNDbgUTCGEagwoTC49v8crw1UWbrzjpz3BM2EK9FyBCS
         Yd72xtqgLN0NX/lscAe8rZf43W6ycdDTd114vA1mztmrxAPRKF2XJd1WSWG8XjkS6zUN
         ZfyQ==
X-Gm-Message-State: ACgBeo1crPgaZ7hR5fExzNz+JnfXAddusTtRs9MNE9pQO/T1c3PXQbOf
        S+J3X2b47I0MGxOEdY4cDQ==
X-Google-Smtp-Source: AA6agR4QVx4f7/PzkKYp7FkfrjXZT1iNJ6NCK9UlU9Kl3LCt/4FJGHK0mmR0kRChYXNr76/pRm4dfQ==
X-Received: by 2002:a05:6638:25d6:b0:342:916c:d59a with SMTP id u22-20020a05663825d600b00342916cd59amr10135723jat.51.1660683746559;
        Tue, 16 Aug 2022 14:02:26 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id v30-20020a02b09e000000b00339dbd4c8d7sm4788423jah.45.2022.08.16.14.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 14:02:25 -0700 (PDT)
Received: (nullmailer pid 2727395 invoked by uid 1000);
        Tue, 16 Aug 2022 21:02:23 -0000
Date:   Tue, 16 Aug 2022 15:02:23 -0600
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/7] dt-bindings: net: dsa: mediatek,mt7530: update
 examples
Message-ID: <20220816210223.GA2714004-robh@kernel.org>
References: <20220813154415.349091-1-arinc.unal@arinc9.com>
 <20220813154415.349091-4-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220813154415.349091-4-arinc.unal@arinc9.com>
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

On Sat, Aug 13, 2022 at 06:44:11PM +0300, Arınç ÜNAL wrote:
> Update the examples on the binding.
> 
> - Add examples which include a wide variation of configurations.
> - Make example comments YAML comment instead of DT binding comment.
> - Define examples from platform to make the bindings clearer.
> - Add interrupt controller to the examples. Include header file for
> interrupt.
> - Change reset line for MT7621 examples.
> - Pretty formatting for the examples.
> - Change switch reg to 0.
> - Change port labels to fit the example, change port 4 label to wan.
> - Change ethernet-ports to ports.

Again, why?

> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  .../bindings/net/dsa/mediatek,mt7530.yaml     | 663 +++++++++++++-----
>  1 file changed, 502 insertions(+), 161 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index 4c99266ce82a..cc87f48d4d07 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -210,144 +210,374 @@ allOf:
>  unevaluatedProperties: false
>  
>  examples:
> +  # Example 1: Standalone MT7530
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> -    mdio {
> -        #address-cells = <1>;
> -        #size-cells = <0>;
> -        switch@0 {
> -            compatible = "mediatek,mt7530";
> -            reg = <0>;
> -
> -            core-supply = <&mt6323_vpa_reg>;
> -            io-supply = <&mt6323_vemc3v3_reg>;
> -            reset-gpios = <&pio 33 GPIO_ACTIVE_HIGH>;
> -
> -            ethernet-ports {
> +
> +    platform {
> +        ethernet {

Don't need these nodes.

> +            mdio {
>                  #address-cells = <1>;
>                  #size-cells = <0>;
> -                port@0 {
> +
> +                switch@0 {
> +                    compatible = "mediatek,mt7530";
>                      reg = <0>;
> -                    label = "lan0";
> -                };
>  
> -                port@1 {
> -                    reg = <1>;
> -                    label = "lan1";
> -                };
> +                    reset-gpios = <&pio 33 0>;
>  
> -                port@2 {
> -                    reg = <2>;
> -                    label = "lan2";
> -                };
> +                    core-supply = <&mt6323_vpa_reg>;
> +                    io-supply = <&mt6323_vemc3v3_reg>;
> +
> +                    ports {

'ports' is for the DT graph binding. 'ethernet-ports' is for DSA 
binding. The former is allowed due to existing users. Don't add more.

> +                        #address-cells = <1>;
> +                        #size-cells = <0>;
>  
> -                port@3 {
> -                    reg = <3>;
> -                    label = "lan3";
> +                        port@0 {
> +                            reg = <0>;
> +                            label = "lan1";
> +                        };
> +
> +                        port@1 {
> +                            reg = <1>;
> +                            label = "lan2";
> +                        };
> +
> +                        port@2 {
> +                            reg = <2>;
> +                            label = "lan3";
> +                        };
> +
> +                        port@3 {
> +                            reg = <3>;
> +                            label = "lan4";
> +                        };
> +
> +                        port@4 {
> +                            reg = <4>;
> +                            label = "wan";
> +                        };
> +
> +                        port@6 {
> +                            reg = <6>;
> +                            label = "cpu";
> +                            ethernet = <&gmac0>;
> +                            phy-mode = "rgmii";
> +
> +                            fixed-link {
> +                                speed = <1000>;
> +                                full-duplex;
> +                                pause;
> +                            };
> +                        };
> +                    };
>                  };
> +            };
> +        };
> +    };
>  
> -                port@4 {
> -                    reg = <4>;
> -                    label = "wan";
> +  # Example 2: MT7530 in MT7623AI SoC

Looks almost the same as example 1. Examples are not an enumeration of 
every possible DT. Limit them to cases which are significantly 
different.

> +  - |
> +    #include <dt-bindings/reset/mt2701-resets.h>
> +
> +    platform {
> +        ethernet {
> +            mdio {
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +
> +                switch@0 {
> +                    compatible = "mediatek,mt7530";
> +                    reg = <0>;
> +
> +                    mediatek,mcm;
> +                    resets = <&ethsys MT2701_ETHSYS_MCM_RST>;
> +                    reset-names = "mcm";
> +
> +                    core-supply = <&mt6323_vpa_reg>;
> +                    io-supply = <&mt6323_vemc3v3_reg>;
> +
> +                    ports {
> +                        #address-cells = <1>;
> +                        #size-cells = <0>;
> +
> +                        port@0 {
> +                            reg = <0>;
> +                            label = "lan1";
> +                        };
> +
> +                        port@1 {
> +                            reg = <1>;
> +                            label = "lan2";
> +                        };
> +
> +                        port@2 {
> +                            reg = <2>;
> +                            label = "lan3";
> +                        };
> +
> +                        port@3 {
> +                            reg = <3>;
> +                            label = "lan4";
> +                        };
> +
> +                        port@4 {
> +                            reg = <4>;
> +                            label = "wan";
> +                        };
> +
> +                        port@6 {
> +                            reg = <6>;
> +                            label = "cpu";
> +                            ethernet = <&gmac0>;
> +                            phy-mode = "trgmii";
> +
> +                            fixed-link {
> +                                speed = <1000>;
> +                                full-duplex;
> +                                pause;
> +                            };
> +                        };
> +                    };
>                  };
> +            };
> +        };
> +    };
> +
> +  # Example 3: Standalone MT7531
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +
> +    platform {
> +        ethernet {
> +            mdio {
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +
> +                switch@0 {
> +                    compatible = "mediatek,mt7531";
> +                    reg = <0>;
> +
> +                    reset-gpios = <&pio 54 0>;
> +
> +                    interrupt-controller;
> +                    #interrupt-cells = <1>;
> +                    interrupt-parent = <&pio>;
> +                    interrupts = <53 IRQ_TYPE_LEVEL_HIGH>;
> +
> +                    ports {
> +                        #address-cells = <1>;
> +                        #size-cells = <0>;
> +
> +                        port@0 {
> +                            reg = <0>;
> +                            label = "lan1";
> +                        };
> +
> +                        port@1 {
> +                            reg = <1>;
> +                            label = "lan2";
> +                        };
> +
> +                        port@2 {
> +                            reg = <2>;
> +                            label = "lan3";
> +                        };
> +
> +                        port@3 {
> +                            reg = <3>;
> +                            label = "lan4";
> +                        };
>  
> -                port@6 {
> -                    reg = <6>;
> -                    label = "cpu";
> -                    ethernet = <&gmac0>;
> -                    phy-mode = "trgmii";
> -                    fixed-link {
> -                        speed = <1000>;
> -                        full-duplex;
> +                        port@4 {
> +                            reg = <4>;
> +                            label = "wan";
> +                        };
> +
> +                        port@6 {
> +                            reg = <6>;
> +                            label = "cpu";
> +                            ethernet = <&gmac0>;
> +                            phy-mode = "2500base-x";
> +
> +                            fixed-link {
> +                                speed = <2500>;
> +                                full-duplex;
> +                                pause;
> +                            };
> +                        };
>                      };
>                  };
>              };
>          };
>      };
>  
> +  # Example 4: MT7530 in MT7621AT, MT7621DAT and MT7621ST SoCs
>    - |
> -    //Example 2: MT7621: Port 4 is WAN port: 2nd GMAC -> Port 5 -> PHY port 4.
> -
> -    ethernet {
> -        #address-cells = <1>;
> -        #size-cells = <0>;
> -        gmac0: mac@0 {
> -            compatible = "mediatek,eth-mac";
> -            reg = <0>;
> -            phy-mode = "rgmii";
> -
> -            fixed-link {
> -                speed = <1000>;
> -                full-duplex;
> -                pause;
> +    #include <dt-bindings/interrupt-controller/mips-gic.h>
> +    #include <dt-bindings/reset/mt7621-reset.h>
> +
> +    platform {
> +        ethernet {
> +            mdio {
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +
> +                switch@0 {
> +                    compatible = "mediatek,mt7621";
> +                    reg = <0>;
> +
> +                    mediatek,mcm;
> +                    resets = <&sysc MT7621_RST_MCM>;
> +                    reset-names = "mcm";
> +
> +                    interrupt-controller;
> +                    #interrupt-cells = <1>;
> +                    interrupt-parent = <&gic>;
> +                    interrupts = <GIC_SHARED 23 IRQ_TYPE_LEVEL_HIGH>;
> +
> +                    ports {
> +                        #address-cells = <1>;
> +                        #size-cells = <0>;
> +
> +                        port@0 {
> +                            reg = <0>;
> +                            label = "lan1";
> +                        };
> +
> +                        port@1 {
> +                            reg = <1>;
> +                            label = "lan2";
> +                        };
> +
> +                        port@2 {
> +                            reg = <2>;
> +                            label = "lan3";
> +                        };
> +
> +                        port@3 {
> +                            reg = <3>;
> +                            label = "lan4";
> +                        };
> +
> +                        port@4 {
> +                            reg = <4>;
> +                            label = "wan";
> +                        };
> +
> +                        port@6 {
> +                            reg = <6>;
> +                            label = "cpu";
> +                            ethernet = <&gmac0>;
> +                            phy-mode = "trgmii";
> +
> +                            fixed-link {
> +                                speed = <1000>;
> +                                full-duplex;
> +                                pause;
> +                            };
> +                        };
> +                    };
> +                };
>              };
>          };
> +    };
>  
> -        gmac1: mac@1 {
> -            compatible = "mediatek,eth-mac";
> -            reg = <1>;
> -            phy-mode = "rgmii-txid";
> -            phy-handle = <&phy4>;
> +  # Example 5: MT7621: mux MT7530's phy4 to SoC's gmac1
> +  - |
> +    #include <dt-bindings/interrupt-controller/mips-gic.h>
> +    #include <dt-bindings/reset/mt7621-reset.h>
> +
> +    platform {
> +        pinctrl {
> +            example5_rgmii2_pins: rgmii2-pins {
> +                pinmux {
> +                    groups = "rgmii2";
> +                    function = "rgmii2";
> +                };
> +            };

No need to put this in the example. We don't put provide nodes in 
the examples of the consumers. It's also incomplete and can't be 
validated. 

>          };
>  
> -        mdio: mdio-bus {
> +        ethernet {
>              #address-cells = <1>;
>              #size-cells = <0>;
