Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6AEF5B6966
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 10:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbiIMIVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 04:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbiIMIVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 04:21:11 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BC65B056
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 01:20:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663057212; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=aKmnmo4Olu9MWAcAT2MG18Z5BRqVo0rcAvLuuLpTX1OpirHF8MilMToScvcKZwBf431rVxSs30KWrdvviXWJRl8Y2XKkFgDxV7SOaE9/vt1Jzyajoz/FlBUN3/MEtn7fAPlPOJsJeZooVZnVKpc67JBHQREr/vBnVgPtw/yL4b8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663057212; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=l3Uz5ApxLpqDacPxjaTwky27X6aovDun2GVwHWsZDR4=; 
        b=ffzCcNYDVPernkp9cI4jPDQ/Nat/wzX31gbbkq7naS5IOXxci+mF5XjCS2E5NWfFVLN8ssSJpEcQwe1VmG+9Sl+oQmu9z0r3+kfNP65Oza4TI/fBfluL8EgucIHuRnOVGfXP0y8+FLSAQF0Arq979C79WdqklP2vWvNVIZxgnDc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663057212;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=l3Uz5ApxLpqDacPxjaTwky27X6aovDun2GVwHWsZDR4=;
        b=JcN70WqP4fzeC2Q4KMs4M5h1dzuD/rZjSEXtIBqc4xAH1mAv3f2K7lb5MuXxkPyY
        flyvBx2S5C/t/Ajgf2czVsHzdsOFwK1GntOUkj6YIPSYrNN0gTDiL+EMeo6kTua/1gq
        xygWtdEmlp4/AhfOGcsKU1Rqgv8bQ4T1s+W5qlxg=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663057211696211.31218869420593; Tue, 13 Sep 2022 01:20:11 -0700 (PDT)
Message-ID: <b11e86c6-ff35-2103-cebe-ebe5f737d9de@arinc9.com>
Date:   Tue, 13 Sep 2022 11:20:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 3/3] dt-bindings: net: dsa: remove label = "cpu"
 from examples
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        George McCollister <george.mccollister@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Marek Vasut <marex@denx.de>, John Crispin <john@phrozen.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org
References: <20220912175058.280386-1-vladimir.oltean@nxp.com>
 <20220912175058.280386-4-vladimir.oltean@nxp.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220912175058.280386-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.09.2022 20:50, Vladimir Oltean wrote:
> This is not used by the DSA dt-binding, so remove it from all examples.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Is there also a plan to remove this from every devicetree on mainline 
that has got this property on the CPU port?

I'd like to do the same on the DTs on OpenWrt.

Arınç

> ---
>   Documentation/devicetree/bindings/net/dsa/ar9331.txt       | 1 -
>   .../devicetree/bindings/net/dsa/arrow,xrs700x.yaml         | 1 -
>   Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml    | 2 --
>   .../devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml  | 1 -
>   Documentation/devicetree/bindings/net/dsa/lan9303.txt      | 2 --
>   Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt | 1 -
>   .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml       | 7 -------
>   .../devicetree/bindings/net/dsa/microchip,ksz.yaml         | 2 --
>   Documentation/devicetree/bindings/net/dsa/qca8k.yaml       | 3 ---
>   Documentation/devicetree/bindings/net/dsa/realtek.yaml     | 2 --
>   .../devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml    | 1 -
>   .../devicetree/bindings/net/dsa/vitesse,vsc73xx.txt        | 2 --
>   12 files changed, 25 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/ar9331.txt b/Documentation/devicetree/bindings/net/dsa/ar9331.txt
> index 320607cbbb17..f824fdae0da2 100644
> --- a/Documentation/devicetree/bindings/net/dsa/ar9331.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/ar9331.txt
> @@ -76,7 +76,6 @@ eth1: ethernet@1a000000 {
>   
>   				switch_port0: port@0 {
>   					reg = <0x0>;
> -					label = "cpu";
>   					ethernet = <&eth1>;
>   
>   					phy-mode = "gmii";
> diff --git a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> index eb01a8f37ce4..259a0c6547f3 100644
> --- a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> @@ -61,7 +61,6 @@ examples:
>                   };
>                   ethernet-port@3 {
>                       reg = <3>;
> -                    label = "cpu";
>                       ethernet = <&fec1>;
>                       phy-mode = "rgmii-id";
>   
> diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
> index 2e01371b8288..1219b830b1a4 100644
> --- a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
> @@ -169,7 +169,6 @@ examples:
>   
>                   port@8 {
>                       reg = <8>;
> -                    label = "cpu";
>                       phy-mode = "rgmii-txid";
>                       ethernet = <&eth0>;
>                       fixed-link {
> @@ -252,7 +251,6 @@ examples:
>   
>                   port@8 {
>                       ethernet = <&amac2>;
> -                    label = "cpu";
>                       reg = <8>;
>                       phy-mode = "internal";
>   
> diff --git a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
> index 1ff44dd68a61..73b774eadd0b 100644
> --- a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
> @@ -91,7 +91,6 @@ examples:
>   
>                   port@0 {
>                       reg = <0>;
> -                    label = "cpu";
>                       ethernet = <&gmac0>;
>                       phy-mode = "mii";
>   
> diff --git a/Documentation/devicetree/bindings/net/dsa/lan9303.txt b/Documentation/devicetree/bindings/net/dsa/lan9303.txt
> index 464d6bf87605..46a732087f5c 100644
> --- a/Documentation/devicetree/bindings/net/dsa/lan9303.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/lan9303.txt
> @@ -46,7 +46,6 @@ I2C managed mode:
>   
>   			port@0 { /* RMII fixed link to master */
>   				reg = <0>;
> -				label = "cpu";
>   				ethernet = <&master>;
>   			};
>   
> @@ -83,7 +82,6 @@ MDIO managed mode:
>   
>   					port@0 {
>   						reg = <0>;
> -						label = "cpu";
>   						ethernet = <&master>;
>   					};
>   
> diff --git a/Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt b/Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt
> index e3829d3e480e..8bb1eff21cb1 100644
> --- a/Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt
> @@ -96,7 +96,6 @@ switch@e108000 {
>   
>   		port@6 {
>   			reg = <0x6>;
> -			label = "cpu";
>   			ethernet = <&eth0>;
>   		};
>   	};
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index 84bb36cab518..bc6446e1f55a 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -325,7 +325,6 @@ examples:
>   
>                   port@6 {
>                       reg = <6>;
> -                    label = "cpu";
>                       ethernet = <&gmac0>;
>                       phy-mode = "rgmii";
>   
> @@ -389,7 +388,6 @@ examples:
>   
>                   port@6 {
>                       reg = <6>;
> -                    label = "cpu";
>                       ethernet = <&gmac0>;
>                       phy-mode = "trgmii";
>   
> @@ -454,7 +452,6 @@ examples:
>   
>                   port@6 {
>                       reg = <6>;
> -                    label = "cpu";
>                       ethernet = <&gmac0>;
>                       phy-mode = "2500base-x";
>   
> @@ -521,7 +518,6 @@ examples:
>   
>                   port@6 {
>                       reg = <6>;
> -                    label = "cpu";
>                       ethernet = <&gmac0>;
>                       phy-mode = "trgmii";
>   
> @@ -610,7 +606,6 @@ examples:
>   
>                       port@6 {
>                           reg = <6>;
> -                        label = "cpu";
>                           ethernet = <&gmac0>;
>                           phy-mode = "trgmii";
>   
> @@ -699,7 +694,6 @@ examples:
>   
>                       port@6 {
>                           reg = <6>;
> -                        label = "cpu";
>                           ethernet = <&gmac0>;
>                           phy-mode = "trgmii";
>   
> @@ -787,7 +781,6 @@ examples:
>   
>                       port@6 {
>                           reg = <6>;
> -                        label = "cpu";
>                           ethernet = <&gmac0>;
>                           phy-mode = "trgmii";
>   
> diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> index 456802affc9d..4da75b1f9533 100644
> --- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> @@ -107,7 +107,6 @@ examples:
>                   };
>                   port@5 {
>                       reg = <5>;
> -                    label = "cpu";
>                       ethernet = <&eth0>;
>                       phy-mode = "rgmii";
>   
> @@ -146,7 +145,6 @@ examples:
>                   };
>                   port@6 {
>                       reg = <6>;
> -                    label = "cpu";
>                       ethernet = <&eth0>;
>                       phy-mode = "rgmii";
>   
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> index f3c88371d76c..978162df51f7 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> @@ -159,7 +159,6 @@ examples:
>   
>                   port@0 {
>                       reg = <0>;
> -                    label = "cpu";
>                       ethernet = <&gmac1>;
>                       phy-mode = "rgmii";
>   
> @@ -221,7 +220,6 @@ examples:
>   
>                   port@0 {
>                       reg = <0>;
> -                    label = "cpu";
>                       ethernet = <&gmac1>;
>                       phy-mode = "rgmii";
>   
> @@ -268,7 +266,6 @@ examples:
>   
>                   port@6 {
>                       reg = <0>;
> -                    label = "cpu";
>                       ethernet = <&gmac1>;
>                       phy-mode = "sgmii";
>   
> diff --git a/Documentation/devicetree/bindings/net/dsa/realtek.yaml b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
> index 4f99aff029dc..1a7d45a8ad66 100644
> --- a/Documentation/devicetree/bindings/net/dsa/realtek.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
> @@ -189,7 +189,6 @@ examples:
>                               };
>                               port@5 {
>                                       reg = <5>;
> -                                    label = "cpu";
>                                       ethernet = <&gmac0>;
>                                       phy-mode = "rgmii";
>                                       fixed-link {
> @@ -277,7 +276,6 @@ examples:
>                               };
>                               port@6 {
>                                       reg = <6>;
> -                                    label = "cpu";
>                                       ethernet = <&fec1>;
>                                       phy-mode = "rgmii";
>                                       tx-internal-delay-ps = <2000>;
> diff --git a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> index 14a1f0b4c32b..7ca9c19a157c 100644
> --- a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> @@ -130,7 +130,6 @@ examples:
>               port@4 {
>                   reg = <4>;
>                   ethernet = <&gmac2>;
> -                label = "cpu";
>                   phy-mode = "internal";
>   
>                   fixed-link {
> diff --git a/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt b/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt
> index bbf4a13f6d75..258bef483673 100644
> --- a/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt
> @@ -75,7 +75,6 @@ switch@0 {
>   		};
>   		vsc: port@6 {
>   			reg = <6>;
> -			label = "cpu";
>   			ethernet = <&gmac1>;
>   			phy-mode = "rgmii";
>   			fixed-link {
> @@ -117,7 +116,6 @@ switch@2,0 {
>   		};
>   		vsc: port@6 {
>   			reg = <6>;
> -			label = "cpu";
>   			ethernet = <&enet0>;
>   			phy-mode = "rgmii";
>   			fixed-link {
