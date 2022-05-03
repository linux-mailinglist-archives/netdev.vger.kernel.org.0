Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F422E5183EC
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 14:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235077AbiECMJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235108AbiECMIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:08:53 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D951836D
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 05:05:17 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id j6so32983348ejc.13
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 05:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LoTzOhcLLyaeikFNfu1k4ItSA3teX///n/LvWB6h734=;
        b=nIm1iLvs6ZeMffAmJ2tUSrNMMNftyUwBjvAXvb1QKQWdXJhbRb0zvvHcHat7wSc4mK
         vY2J25Z1K4QQpTadmYr6qw2wCv9a5bHi084tPaKhAbWlO9CSCvmux7p96sCJaxj1HdtU
         Udiu5cZ5/XuaGLYHoV1WHZY25dEOPlmCUperX4xLmF6gDqc6meZGLnbADXf7NZCXeCgU
         KpZn3BrxPWXDN7JgzegX0OqMIZ3mmzxZF6+u90964yaPBKnyCIhWBfsO1UDCPkX0P+Os
         NNxrjq7LLxn4rZnQ4bMrItMQCTLp/KY05m6kay+7z8fDMFmPnOpcRnyM63kZVVHA3E0r
         5Cug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LoTzOhcLLyaeikFNfu1k4ItSA3teX///n/LvWB6h734=;
        b=SvAI9JV/NizBCwkWEh4mxitH3v7C1QNouW2xnehWYuJDzGCpYhaiCWWOF4pjmL72n1
         Rbd8LAdQD3q/Vz0ZWJk0zkxWWFK7iC8ZEZA76i5W/7p0G6S711hgC+fAk+Pv4kS5n8tT
         WNyLEH28tievcEQQP4ffVTHLNfXgtbJWqJjhk4IJdYh5QeIMEmBlg4K8xSVfY1emiVA+
         b4+7h8KchHK3A4nq6N0vgXW5GQCLImEm1xQs+2Iw8Z3G9uBVNwSs7s4R8GUcroR8KSHy
         AZ/6bUBMTxDMIRbfnmUKhcmYkClJBNl1xuujvwATBAgPsXK3IGu+BmfAyIG47BEoQEFr
         L5Vg==
X-Gm-Message-State: AOAM533L7+07XOdpcPcM4gNqX53ekqiu0vDA7wMVT8TDCDbRZwqr7na7
        Eupxgdr0LCjJRqmzy4Ip0FW9oA==
X-Google-Smtp-Source: ABdhPJz4dqaOJ7tVlEDf2hHKffoFY/nbMWJIMF4bj24bO9sm7O2wot/9H3IMtuUAx+lUxyvzGdnsEQ==
X-Received: by 2002:a17:907:3da2:b0:6f4:78d8:7c23 with SMTP id he34-20020a1709073da200b006f478d87c23mr4569586ejc.233.1651579515831;
        Tue, 03 May 2022 05:05:15 -0700 (PDT)
Received: from [192.168.0.202] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id gx21-20020a1709068a5500b006f3ef214dabsm4531141ejc.17.2022.05.03.05.05.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 05:05:15 -0700 (PDT)
Message-ID: <d29637f8-87ff-b5f0-9604-89b51a2ba7c1@linaro.org>
Date:   Tue, 3 May 2022 14:05:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC v1] dt-bindings: net: dsa: convert binding for mediatek
 switches
Content-Language: en-US
To:     Frank Wunderlich <linux@fw-web.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>
References: <20220502153238.85090-1-linux@fw-web.de>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220502153238.85090-1-linux@fw-web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/05/2022 17:32, Frank Wunderlich wrote:
> From: Frank Wunderlich <frank-w@public-files.de>
> 
> Convert txt binding to yaml binding for Mediatek switches.
> 
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> ---
>  .../devicetree/bindings/net/dsa/mediatek.yaml | 435 ++++++++++++++++++
>  .../devicetree/bindings/net/dsa/mt7530.txt    | 327 -------------
>  2 files changed, 435 insertions(+), 327 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/mediatek.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/dsa/mt7530.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek.yaml
> new file mode 100644
> index 000000000000..c1724809d34e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek.yaml

Specific name please, so previous (with vendor prefix) was better:
mediatek,mt7530.yaml

> @@ -0,0 +1,435 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)

You should CC previous contributors and get their acks on this. You
copied here a lot of description.

> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/mediatek.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Mediatek MT7530 Ethernet switch
> +
> +maintainers:
> +  - Sean Wang <sean.wang@mediatek.com>
> +  - Landen Chao <Landen.Chao@mediatek.com>
> +  - DENG Qingfang <dqfext@gmail.com>
> +
> +description: |
> +  Port 5 of mt7530 and mt7621 switch is muxed between:
> +  1. GMAC5: GMAC5 can interface with another external MAC or PHY.
> +  2. PHY of port 0 or port 4: PHY interfaces with an external MAC like 2nd GMAC
> +     of the SOC. Used in many setups where port 0/4 becomes the WAN port.
> +     Note: On a MT7621 SOC with integrated switch: 2nd GMAC can only connected to
> +       GMAC5 when the gpios for RGMII2 (GPIO 22-33) are not used and not
> +       connected to external component!
> +
> +  Port 5 modes/configurations:
> +  1. Port 5 is disabled and isolated: An external phy can interface to the 2nd
> +     GMAC of the SOC.
> +     In the case of a build-in MT7530 switch, port 5 shares the RGMII bus with 2nd
> +     GMAC and an optional external phy. Mind the GPIO/pinctl settings of the SOC!
> +  2. Port 5 is muxed to PHY of port 0/4: Port 0/4 interfaces with 2nd GMAC.
> +     It is a simple MAC to PHY interface, port 5 needs to be setup for xMII mode
> +     and RGMII delay.
> +  3. Port 5 is muxed to GMAC5 and can interface to an external phy.
> +     Port 5 becomes an extra switch port.
> +     Only works on platform where external phy TX<->RX lines are swapped.
> +     Like in the Ubiquiti ER-X-SFP.
> +  4. Port 5 is muxed to GMAC5 and interfaces with the 2nd GAMC as 2nd CPU port.
> +     Currently a 2nd CPU port is not supported by DSA code.
> +
> +  Depending on how the external PHY is wired:
> +  1. normal: The PHY can only connect to 2nd GMAC but not to the switch
> +  2. swapped: RGMII TX, RX are swapped; external phy interface with the switch as
> +     a ethernet port. But can't interface to the 2nd GMAC.
> +
> +    Based on the DT the port 5 mode is configured.
> +
> +  Driver tries to lookup the phy-handle of the 2nd GMAC of the master device.
> +  When phy-handle matches PHY of port 0 or 4 then port 5 set-up as mode 2.
> +  phy-mode must be set, see also example 2 below!
> +  * mt7621: phy-mode = "rgmii-txid";
> +  * mt7623: phy-mode = "rgmii";
> +
> +  CPU-Ports need a phy-mode property:
> +    Allowed values on mt7530 and mt7621:
> +      - "rgmii"
> +      - "trgmii"
> +    On mt7531:
> +      - "1000base-x"
> +      - "2500base-x"
> +      - "sgmii"
> +
> +
> +properties:
> +  compatible:
> +    enum:
> +      - mediatek,mt7530
> +      - mediatek,mt7531
> +      - mediatek,mt7621
> +
> +  "#address-cells":
> +    const: 1
> +
> +  "#size-cells":
> +    const: 0
> +
> +  core-supply:
> +    description: |
> +      Phandle to the regulator node necessary for the core power.
> +
> +  "#gpio-cells":
> +    description: |
> +      Must be 2 if gpio-controller is defined.
> +    const: 2
> +
> +  gpio-controller:
> +    type: boolean
> +    description: |
> +      Boolean; if defined, MT7530's LED controller will run on

No need to repeat Boolean.

> +      GPIO mode.
> +
> +  "#interrupt-cells":
> +    const: 1
> +
> +  interrupt-controller:
> +    type: boolean
> +    description: |
> +      Boolean; Enables the internal interrupt controller.

Skip description.

> +
> +  interrupts:
> +    description: |
> +      Parent interrupt for the interrupt controller.

Skip description.

> +    maxItems: 1
> +
> +  io-supply:
> +    description: |
> +      Phandle to the regulator node necessary for the I/O power.
> +      See Documentation/devicetree/bindings/regulator/mt6323-regulator.txt
> +      for details for the regulator setup on these boards.
> +
> +  mediatek,mcm:
> +    type: boolean
> +    description: |
> +      Boolean; 

No need to repeat Boolean.

> if defined, indicates that either MT7530 is the part
> +      on multi-chip module belong to MT7623A has or the remotely standalone
> +      chip as the function MT7623N reference board provided for.
> +
> +  reset-gpios:
> +    description: |
> +      Should be a gpio specifier for a reset line.
> +    maxItems: 1
> +
> +  reset-names:
> +    description: |
> +      Should be set to "mcm".
> +    const: mcm
> +
> +  resets:
> +    description: |
> +      Phandle pointing to the system reset controller with
> +      line index for the ethsys.
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg

What about address/size cells?

> +
> +allOf:
> +  - $ref: "dsa.yaml#"
> +  - if:
> +      required:
> +        - mediatek,mcm

Original bindings had this reversed.

> +    then:
> +      required:
> +        - resets
> +        - reset-names
> +    else:
> +      required:
> +        - reset-gpios
> +
> +  - if:
> +      required:
> +        - interrupt-controller
> +    then:
> +      required:
> +        - "#interrupt-cells"

This should come from dt schema already...

> +        - interrupts
> +
> +  - if:
> +      properties:
> +        compatible:
> +          items:
> +            - const: mediatek,mt7530
> +    then:
> +      required:
> +        - core-supply
> +        - io-supply
> +
> +
> +patternProperties:
> +  "^ports$":

It''s not a pattern, so put it under properties, like regular property.

> +    type: object
> +
> +    patternProperties:
> +      "^port@[0-9]+$":
> +        type: object
> +        description: Ethernet switch ports
> +
> +        $ref: dsa-port.yaml#

This should go to allOf below.

> +
> +        properties:
> +          reg:
> +            description: |
> +              Port address described must be 6 for CPU port and from 0 to 5 for user ports.
> +
> +        unevaluatedProperties: false
> +
> +        allOf:
> +          - if:
> +              properties:
> +                label:
> +                  items:
> +                    - const: cpu
> +            then:
> +              required:
> +                - reg
> +                - phy-mode
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    mdio0 {

Just mdio

> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        switch@0 {
> +            compatible = "mediatek,mt7530";
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +            reg = <0>;
> +
> +            core-supply = <&mt6323_vpa_reg>;
> +            io-supply = <&mt6323_vemc3v3_reg>;
> +            reset-gpios = <&pio 33 0>;

Use GPIO flag define/constant.

> +
> +            ports {
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +                port@0 {
> +                    reg = <0>;
> +                    label = "lan0";
> +                };
> +
> +                port@1 {
> +                    reg = <1>;
> +                    label = "lan1";
> +                };
> +
> +                port@2 {
> +                    reg = <2>;
> +                    label = "lan2";
> +                };
> +
> +                port@3 {
> +                    reg = <3>;
> +                    label = "lan3";
> +                };
> +
> +                port@4 {
> +                    reg = <4>;
> +                    label = "wan";
> +                };
> +
> +                port@6 {
> +                    reg = <6>;
> +                    label = "cpu";
> +                    ethernet = <&gmac0>;
> +                    phy-mode = "trgmii";
> +                    fixed-link {
> +                        speed = <1000>;
> +                        full-duplex;
> +                    };
> +                };
> +            };
> +        };
> +    };
> +
> +  - |
> +    //Example 2: MT7621: Port 4 is WAN port: 2nd GMAC -> Port 5 -> PHY port 4.
> +
> +    eth {

s/eth/ethernet/

> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        gmac0: mac@0 {
> +            compatible = "mediatek,eth-mac";
> +            reg = <0>;
> +            phy-mode = "rgmii";
> +
> +            fixed-link {
> +                speed = <1000>;
> +                full-duplex;
> +                pause;
> +            };
> +        };
> +
> +        gmac1: mac@1 {
> +            compatible = "mediatek,eth-mac";
> +            reg = <1>;
> +            phy-mode = "rgmii-txid";
> +            phy-handle = <&phy4>;
> +        };
> +
> +        mdio: mdio-bus {
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +            /* Internal phy */
> +            phy4: ethernet-phy@4 {
> +                reg = <4>;
> +            };
> +
> +            mt7530: switch@1f {
> +                compatible = "mediatek,mt7621";
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +                reg = <0x1f>;
> +                mediatek,mcm;
> +
> +                resets = <&rstctrl 2>;
> +                reset-names = "mcm";
> +
> +                ports {
> +                    #address-cells = <1>;
> +                    #size-cells = <0>;
> +
> +                    port@0 {
> +                        reg = <0>;
> +                        label = "lan0";
> +                    };
> +
> +                    port@1 {
> +                        reg = <1>;
> +                        label = "lan1";
> +                    };
> +
> +                    port@2 {
> +                        reg = <2>;
> +                        label = "lan2";
> +                    };
> +
> +                    port@3 {
> +                        reg = <3>;
> +                        label = "lan3";
> +                    };
> +
> +        /* Commented out. Port 4 is handled by 2nd GMAC.
> +                    port@4 {
> +                        reg = <4>;
> +                        label = "lan4";
> +                    };
> +        */

Messed up indentation
> +
> +                    port@6 {
> +                        reg = <6>;
> +                        label = "cpu";
> +                        ethernet = <&gmac0>;
> +                        phy-mode = "rgmii";
> +
> +                        fixed-link {
> +                            speed = <1000>;
> +                            full-duplex;
> +                            pause;
> +                        };
> +                    };
> +                };
> +            };
> +        };
> +    };
> +
> +  - |
> +    //Example 3: MT7621: Port 5 is connected to external PHY: Port 5 -> external PHY.
> +
> +    eth {

Also ethernet?



Best regards,
Krzysztof
