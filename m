Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A457596551
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 00:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237569AbiHPWQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 18:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237976AbiHPWQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 18:16:18 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1946678BCE;
        Tue, 16 Aug 2022 15:16:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660688137; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=bPMcKkRyVZfUCCU335HWN3m6zTrsaHlK3Btl7KbRFeYjBT3CNQxVK+IZhowIVhi5NKsxEvyKxR7fUGhzGbjZvY9gwbkQWGOxSSJsi7RB6UXThgDtGs0FayAilNjdCnyNhUih1SSDZX8rJcJexsL5aEsJ5fkGN4Z1MVCOHbi28l0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1660688137; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=SxBVhVumfgFXAdQqW2kPOpPPhvJtnmmOvTBSGY8R4R8=; 
        b=L8JpVq9FoaMKGbicq99QYbsitH2gBv6Ibi0xo3ohhJosM+GLbRtNBVP0lOAn3DZPJllsf+BqLYmkjEkMj54WLoYUIbjspNq3jMZRvXuR5TAe/sBjviKXfFVpZzJg3/4besBpSW9fEbkj6G2RvaZccKrIJikvHnbnfHheX/6fIac=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660688137;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:From:From:Subject:Subject:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=SxBVhVumfgFXAdQqW2kPOpPPhvJtnmmOvTBSGY8R4R8=;
        b=DmlpJKR3MvTM0N0qcTqT15C4TRmCQy6JO34GQgyjW9ua1VCRx/LlWQXuv431kc08
        cn8fT4hYxyO9jcyDbdW1l5XYbgT1Ek/UTcgvSrEWhp2SmH2LZiaqq+GaK2MQKQ4anYw
        He0lWbDSj9IgtZuI5uHzE8LoN6LbCanwXcpGbm30=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1660688134449648.2828314113265; Tue, 16 Aug 2022 15:15:34 -0700 (PDT)
Message-ID: <53672ace-ad26-efdf-b3e5-bc8e4163c567@arinc9.com>
Date:   Wed, 17 Aug 2022 01:15:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH v2 3/7] dt-bindings: net: dsa: mediatek,mt7530: update
 examples
To:     Rob Herring <robh@kernel.org>
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
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220813154415.349091-1-arinc.unal@arinc9.com>
 <20220813154415.349091-4-arinc.unal@arinc9.com>
 <20220816210223.GA2714004-robh@kernel.org>
Content-Language: en-US
In-Reply-To: <20220816210223.GA2714004-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.08.2022 00:02, Rob Herring wrote:
> On Sat, Aug 13, 2022 at 06:44:11PM +0300, Arınç ÜNAL wrote:
>> Update the examples on the binding.
>>
>> - Add examples which include a wide variation of configurations.
>> - Make example comments YAML comment instead of DT binding comment.
>> - Define examples from platform to make the bindings clearer.
>> - Add interrupt controller to the examples. Include header file for
>> interrupt.
>> - Change reset line for MT7621 examples.
>> - Pretty formatting for the examples.
>> - Change switch reg to 0.
>> - Change port labels to fit the example, change port 4 label to wan.
>> - Change ethernet-ports to ports.
> 
> Again, why?

For wrong reasons as it seems. Will revert that one.

> 
>>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
>>   .../bindings/net/dsa/mediatek,mt7530.yaml     | 663 +++++++++++++-----
>>   1 file changed, 502 insertions(+), 161 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> index 4c99266ce82a..cc87f48d4d07 100644
>> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> @@ -210,144 +210,374 @@ allOf:
>>   unevaluatedProperties: false
>>   
>>   examples:
>> +  # Example 1: Standalone MT7530
>>     - |
>>       #include <dt-bindings/gpio/gpio.h>
>> -    mdio {
>> -        #address-cells = <1>;
>> -        #size-cells = <0>;
>> -        switch@0 {
>> -            compatible = "mediatek,mt7530";
>> -            reg = <0>;
>> -
>> -            core-supply = <&mt6323_vpa_reg>;
>> -            io-supply = <&mt6323_vemc3v3_reg>;
>> -            reset-gpios = <&pio 33 GPIO_ACTIVE_HIGH>;
>> -
>> -            ethernet-ports {
>> +
>> +    platform {
>> +        ethernet {
> 
> Don't need these nodes.

Will remove.

> 
>> +            mdio {
>>                   #address-cells = <1>;
>>                   #size-cells = <0>;
>> -                port@0 {
>> +
>> +                switch@0 {
>> +                    compatible = "mediatek,mt7530";
>>                       reg = <0>;
>> -                    label = "lan0";
>> -                };
>>   
>> -                port@1 {
>> -                    reg = <1>;
>> -                    label = "lan1";
>> -                };
>> +                    reset-gpios = <&pio 33 0>;
>>   
>> -                port@2 {
>> -                    reg = <2>;
>> -                    label = "lan2";
>> -                };
>> +                    core-supply = <&mt6323_vpa_reg>;
>> +                    io-supply = <&mt6323_vemc3v3_reg>;
>> +
>> +                    ports {
> 
> 'ports' is for the DT graph binding. 'ethernet-ports' is for DSA
> binding. The former is allowed due to existing users. Don't add more.

Will fix.

> 
>> +                        #address-cells = <1>;
>> +                        #size-cells = <0>;
>>   
>> -                port@3 {
>> -                    reg = <3>;
>> -                    label = "lan3";
>> +                        port@0 {
>> +                            reg = <0>;
>> +                            label = "lan1";
>> +                        };
>> +
>> +                        port@1 {
>> +                            reg = <1>;
>> +                            label = "lan2";
>> +                        };
>> +
>> +                        port@2 {
>> +                            reg = <2>;
>> +                            label = "lan3";
>> +                        };
>> +
>> +                        port@3 {
>> +                            reg = <3>;
>> +                            label = "lan4";
>> +                        };
>> +
>> +                        port@4 {
>> +                            reg = <4>;
>> +                            label = "wan";
>> +                        };
>> +
>> +                        port@6 {
>> +                            reg = <6>;
>> +                            label = "cpu";
>> +                            ethernet = <&gmac0>;
>> +                            phy-mode = "rgmii";
>> +
>> +                            fixed-link {
>> +                                speed = <1000>;
>> +                                full-duplex;
>> +                                pause;
>> +                            };
>> +                        };
>> +                    };
>>                   };
>> +            };
>> +        };
>> +    };
>>   
>> -                port@4 {
>> -                    reg = <4>;
>> -                    label = "wan";
>> +  # Example 2: MT7530 in MT7623AI SoC
> 
> Looks almost the same as example 1. Examples are not an enumeration of
> every possible DT. Limit them to cases which are significantly
> different.

It seemed to me it would be useful to reference the reset line for the 
MT7623AI SoC. Using mediatek,mcm and especially MT2701_ETHSYS_MCM_RST in 
dt-bindings/reset/mt2701-resets.h.

Should I remove anyway?

> 
>> +  - |
>> +    #include <dt-bindings/reset/mt2701-resets.h>
>> +
>> +    platform {
>> +        ethernet {
>> +            mdio {
>> +                #address-cells = <1>;
>> +                #size-cells = <0>;
>> +
>> +                switch@0 {
>> +                    compatible = "mediatek,mt7530";
>> +                    reg = <0>;
>> +
>> +                    mediatek,mcm;
>> +                    resets = <&ethsys MT2701_ETHSYS_MCM_RST>;
>> +                    reset-names = "mcm";
>> +
>> +                    core-supply = <&mt6323_vpa_reg>;
>> +                    io-supply = <&mt6323_vemc3v3_reg>;
>> +
>> +                    ports {
>> +                        #address-cells = <1>;
>> +                        #size-cells = <0>;
>> +
>> +                        port@0 {
>> +                            reg = <0>;
>> +                            label = "lan1";
>> +                        };
>> +
>> +                        port@1 {
>> +                            reg = <1>;
>> +                            label = "lan2";
>> +                        };
>> +
>> +                        port@2 {
>> +                            reg = <2>;
>> +                            label = "lan3";
>> +                        };
>> +
>> +                        port@3 {
>> +                            reg = <3>;
>> +                            label = "lan4";
>> +                        };
>> +
>> +                        port@4 {
>> +                            reg = <4>;
>> +                            label = "wan";
>> +                        };
>> +
>> +                        port@6 {
>> +                            reg = <6>;
>> +                            label = "cpu";
>> +                            ethernet = <&gmac0>;
>> +                            phy-mode = "trgmii";
>> +
>> +                            fixed-link {
>> +                                speed = <1000>;
>> +                                full-duplex;
>> +                                pause;
>> +                            };
>> +                        };
>> +                    };
>>                   };
>> +            };
>> +        };
>> +    };
>> +
>> +  # Example 3: Standalone MT7531
>> +  - |
>> +    #include <dt-bindings/gpio/gpio.h>
>> +    #include <dt-bindings/interrupt-controller/irq.h>
>> +
>> +    platform {
>> +        ethernet {
>> +            mdio {
>> +                #address-cells = <1>;
>> +                #size-cells = <0>;
>> +
>> +                switch@0 {
>> +                    compatible = "mediatek,mt7531";
>> +                    reg = <0>;
>> +
>> +                    reset-gpios = <&pio 54 0>;
>> +
>> +                    interrupt-controller;
>> +                    #interrupt-cells = <1>;
>> +                    interrupt-parent = <&pio>;
>> +                    interrupts = <53 IRQ_TYPE_LEVEL_HIGH>;
>> +
>> +                    ports {
>> +                        #address-cells = <1>;
>> +                        #size-cells = <0>;
>> +
>> +                        port@0 {
>> +                            reg = <0>;
>> +                            label = "lan1";
>> +                        };
>> +
>> +                        port@1 {
>> +                            reg = <1>;
>> +                            label = "lan2";
>> +                        };
>> +
>> +                        port@2 {
>> +                            reg = <2>;
>> +                            label = "lan3";
>> +                        };
>> +
>> +                        port@3 {
>> +                            reg = <3>;
>> +                            label = "lan4";
>> +                        };
>>   
>> -                port@6 {
>> -                    reg = <6>;
>> -                    label = "cpu";
>> -                    ethernet = <&gmac0>;
>> -                    phy-mode = "trgmii";
>> -                    fixed-link {
>> -                        speed = <1000>;
>> -                        full-duplex;
>> +                        port@4 {
>> +                            reg = <4>;
>> +                            label = "wan";
>> +                        };
>> +
>> +                        port@6 {
>> +                            reg = <6>;
>> +                            label = "cpu";
>> +                            ethernet = <&gmac0>;
>> +                            phy-mode = "2500base-x";
>> +
>> +                            fixed-link {
>> +                                speed = <2500>;
>> +                                full-duplex;
>> +                                pause;
>> +                            };
>> +                        };
>>                       };
>>                   };
>>               };
>>           };
>>       };
>>   
>> +  # Example 4: MT7530 in MT7621AT, MT7621DAT and MT7621ST SoCs
>>     - |
>> -    //Example 2: MT7621: Port 4 is WAN port: 2nd GMAC -> Port 5 -> PHY port 4.
>> -
>> -    ethernet {
>> -        #address-cells = <1>;
>> -        #size-cells = <0>;
>> -        gmac0: mac@0 {
>> -            compatible = "mediatek,eth-mac";
>> -            reg = <0>;
>> -            phy-mode = "rgmii";
>> -
>> -            fixed-link {
>> -                speed = <1000>;
>> -                full-duplex;
>> -                pause;
>> +    #include <dt-bindings/interrupt-controller/mips-gic.h>
>> +    #include <dt-bindings/reset/mt7621-reset.h>
>> +
>> +    platform {
>> +        ethernet {
>> +            mdio {
>> +                #address-cells = <1>;
>> +                #size-cells = <0>;
>> +
>> +                switch@0 {
>> +                    compatible = "mediatek,mt7621";
>> +                    reg = <0>;
>> +
>> +                    mediatek,mcm;
>> +                    resets = <&sysc MT7621_RST_MCM>;
>> +                    reset-names = "mcm";
>> +
>> +                    interrupt-controller;
>> +                    #interrupt-cells = <1>;
>> +                    interrupt-parent = <&gic>;
>> +                    interrupts = <GIC_SHARED 23 IRQ_TYPE_LEVEL_HIGH>;
>> +
>> +                    ports {
>> +                        #address-cells = <1>;
>> +                        #size-cells = <0>;
>> +
>> +                        port@0 {
>> +                            reg = <0>;
>> +                            label = "lan1";
>> +                        };
>> +
>> +                        port@1 {
>> +                            reg = <1>;
>> +                            label = "lan2";
>> +                        };
>> +
>> +                        port@2 {
>> +                            reg = <2>;
>> +                            label = "lan3";
>> +                        };
>> +
>> +                        port@3 {
>> +                            reg = <3>;
>> +                            label = "lan4";
>> +                        };
>> +
>> +                        port@4 {
>> +                            reg = <4>;
>> +                            label = "wan";
>> +                        };
>> +
>> +                        port@6 {
>> +                            reg = <6>;
>> +                            label = "cpu";
>> +                            ethernet = <&gmac0>;
>> +                            phy-mode = "trgmii";
>> +
>> +                            fixed-link {
>> +                                speed = <1000>;
>> +                                full-duplex;
>> +                                pause;
>> +                            };
>> +                        };
>> +                    };
>> +                };
>>               };
>>           };
>> +    };
>>   
>> -        gmac1: mac@1 {
>> -            compatible = "mediatek,eth-mac";
>> -            reg = <1>;
>> -            phy-mode = "rgmii-txid";
>> -            phy-handle = <&phy4>;
>> +  # Example 5: MT7621: mux MT7530's phy4 to SoC's gmac1
>> +  - |
>> +    #include <dt-bindings/interrupt-controller/mips-gic.h>
>> +    #include <dt-bindings/reset/mt7621-reset.h>
>> +
>> +    platform {
>> +        pinctrl {
>> +            example5_rgmii2_pins: rgmii2-pins {
>> +                pinmux {
>> +                    groups = "rgmii2";
>> +                    function = "rgmii2";
>> +                };
>> +            };
> 
> No need to put this in the example. We don't put provide nodes in
> the examples of the consumers. It's also incomplete and can't be
> validated.

Will remove.

> 
>>           };
>>   
>> -        mdio: mdio-bus {
>> +        ethernet {
>>               #address-cells = <1>;
>>               #size-cells = <0>;
