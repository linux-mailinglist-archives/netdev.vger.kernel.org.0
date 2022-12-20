Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D7B6529D4
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 00:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbiLTXYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 18:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiLTXYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 18:24:02 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8367DD2;
        Tue, 20 Dec 2022 15:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XOP4wK+mEn7F2t6GIDkEELbXIkHpNStzq9dDTEsVFLA=; b=jDc/DLDpUDTD6Ht930S6kXrnS/
        PFIG3LZeSkSKd5zukwM01tlqHai/fDHff4DnPkhUebmibRAl6pLBCzhUIhmjGf7AhKqejbKTgGB7i
        VkGQhJ4T3wN/CcsXTECcPGqhleLlcvcGTRJgtCbexnAY3ZUA2SvNTANw4lrJGmxh/uDI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p7lxe-0008Ce-4D; Wed, 21 Dec 2022 00:23:50 +0100
Date:   Wed, 21 Dec 2022 00:23:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH v7 11/11] dt-bindings: net: dsa: qca8k: add LEDs
 definition example
Message-ID: <Y6JEBvgs8Fp3FBI/@lunn.ch>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-12-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214235438.30271-12-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 12:54:38AM +0100, Christian Marangi wrote:
> Add LEDs definition example for qca8k using the offload trigger as the
> default trigger and add all the supported offload triggers by the
> switch.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  .../devicetree/bindings/net/dsa/qca8k.yaml    | 24 +++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> index 978162df51f7..4090cf65c41c 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> @@ -65,6 +65,8 @@ properties:
>                   internal mdio access is used.
>                   With the legacy mapping the reg corresponding to the internal
>                   mdio is the switch reg with an offset of -1.
> +                 Each phy have at least 3 LEDs connected and can be declared
> +                 using the standard LEDs structure.
>  
>  patternProperties:
>    "^(ethernet-)?ports$":
> @@ -202,6 +204,7 @@ examples:
>      };
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> +    #include <dt-bindings/leds/common.h>
>  
>      mdio {
>          #address-cells = <1>;
> @@ -284,6 +287,27 @@ examples:
>  
>                  internal_phy_port1: ethernet-phy@0 {
>                      reg = <0>;
> +
> +                    leds {
> +                        #address-cells = <1>;
> +                        #size-cells = <0>;
> +
> +                        led@0 {
> +                            reg = <0>;
> +                            color = <LED_COLOR_ID_WHITE>;
> +                            function = LED_FUNCTION_LAN;
> +                            function-enumerator = <1>;
> +                            linux,default-trigger = "netdev";
> +                        };
> +
> +                        led@1 {
> +                            reg = <1>;
> +                            color = <LED_COLOR_ID_AMBER>;
> +                            function = LED_FUNCTION_LAN;
> +                            function-enumerator = <1>;
> +                            linux,default-trigger = "netdev";
> +                        };
> +                    };
>                  };

I don't see anything here which is specific to the QCA8K. I really
hope the same binding should work for any PHY which has LEDs. So
please move this into ethernet-phy.yaml.

       Andrew
