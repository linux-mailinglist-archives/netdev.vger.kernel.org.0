Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495D54E1944
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 01:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244504AbiCTAu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 20:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbiCTAuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 20:50:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734A344A08;
        Sat, 19 Mar 2022 17:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=R74rAcqaVuvfZPB7esD7eUsUgJTBKlGg/gfRjHW+MHA=; b=ON7TSdsNo37Dbz2XQe5I62bBjg
        tFMCGxFadnLcsROzhOguMug99Umuj54DeDlKisGjBS1Zs5EUOB3dmo5nQQQZlmrXjfXrfygyFAVtB
        6zmEBSfLo9PP9suqd9iZYGyqiBigLo+WtscvRa7jkmZd/+2AJIImewuhG9eJ8Dg8r6yI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nVjlA-00BlWl-7X; Sun, 20 Mar 2022 01:49:28 +0100
Date:   Sun, 20 Mar 2022 01:49:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v9 net-next 03/11] dt-bindings: net: dsa: dt bindings for
 microchip lan937x
Message-ID: <YjZ6GIrGCMzBaftB@lunn.ch>
References: <20220318085540.281721-1-prasanna.vengateshan@microchip.com>
 <20220318085540.281721-4-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318085540.281721-4-prasanna.vengateshan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +examples:

> +          port@6 {
> +            reg = <6>;
> +            label = "lan5";
> +            phy-mode = "internal";
> +            phy-handle = <&t1phy4>;
> +          };
> +          port@7 {
> +            reg = <7>;
> +            label = "lan3";
> +            phy-mode = "internal";
> +            phy-handle = <&t1phy5>;
> +          };
> +        };
> +
> +        mdio {

..

> +          t1phy4: ethernet-phy@6{
> +            reg = <0x6>;
> +          };
> +          t1phy5: ethernet-phy@7{
> +            reg = <0x7>;
> +          };

I know it is only an example, but the numbering is a little odd here.

Port 6, which is named lan5 using t1phy4 at address 6?

I would be more likely to use t1phy6 instead of t1phy4. And t1phy7
instead of t1phy5.

	Andrew
