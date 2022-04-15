Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C13502DAA
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 18:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355802AbiDOQWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 12:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234081AbiDOQW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 12:22:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51C197B9B;
        Fri, 15 Apr 2022 09:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AD7y6t2FutZNo1iQOFDe7kMGydOzNTbvIMGGb73fJwc=; b=IsUPJRGn6OPxvSAfo8oh365+38
        KRuGWw3/46cDX/h4srLR9RLzY0wFgH9PGJhHtQG9VTHIujzL3S7c3Hl1nBUU7CB3gw0miFUjmKomR
        koW3L8q1IGnkC3A4uPFEaRO3f/4SrQDFeNGbCWb7uEZJZCOa97p/4WID+kJeECjYtTBM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nfOfi-00FziH-F0; Fri, 15 Apr 2022 18:19:46 +0200
Date:   Fri, 15 Apr 2022 18:19:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 09/12] ARM: dts: r9a06g032: describe MII
 converter
Message-ID: <YlmbIjoIZ8Xb4Kh/@lunn.ch>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-10-clement.leger@bootlin.com>
 <YlismVi8y3Vf6PZ0@lunn.ch>
 <20220415102453.1b5b3f77@fixe.home>
 <Yll+Tpnwo5410B9H@lunn.ch>
 <20220415163853.683c0b6d@fixe.home>
 <YlmLWv4Hsm2uk8pa@lunn.ch>
 <20220415172954.64e53086@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415172954.64e53086@fixe.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I think it would be good to modify it like this:
> 
> eth-miic@44030000 {
>     ...
>   converters {
>     mii_conv0: mii-conv@0 {
>       // Even if useless, maybe keeping it for the sake of coherency
>       renesas,miic-input = <MIIC_GMAC1>;
>       reg = <0>;
>     };

This is not a 'bus', so using reg, and @0, etc is i think wrong.  You
just have a collection of properties.

>     mii_conv1: mii-conv@1 {
>       renesas,miic-input = <SWITCH_PORTA>;
>       reg = <1>;
>     };
>     mii_conv2: mii-conv@2 {
>       renesas,miic-input = <SWITCH_PORTB>;
>       reg = <2>;
>     };
>     mii_conv3: mii-conv@3 {
>       renesas,miic-input = <SWITCH_PORTC>;
>       reg = <3>;
>     };
>     mii_conv4: mii-conv@4 {
>       renesas,miic-input = <SWITCH_PORTD>;
>       reg = <4>;
>     };
>   };
> 
> This way, it remains tied to the MII converter output port definition. I
> guess that the yaml definitions would still allow to restrict the values
> available per nodes. Validation for the final combination is probably
> more difficult to do using yaml.

I doubt you can do full validation in YAML. But you can at least limit
some of the errors. You need to do full validation in the driver
anyway.

	Andrew
