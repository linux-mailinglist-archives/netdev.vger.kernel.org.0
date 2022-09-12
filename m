Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB2E5B63BA
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 00:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiILWck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 18:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiILWcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 18:32:39 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737BD2657E;
        Mon, 12 Sep 2022 15:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ZX8kTjNb1OOunWDYNDXXUuOsP3Gq9/veJvgsWSAbe/o=; b=V4Pg6SmK+2QhTLA9izOfS9Y1J3
        5tIcMVrIL5POqtSNX4Ot1mZ9H6mv44fGvSB6F7N5hfdaV4h+l9SiXTe3A8AtT3a5jMaKAQKXAa3+G
        ODE052ngza0oeNVwy3ZkY22xXcoTUGmsPLVXy6viB6ilZ8iI/Lvx1uGBge4M8RPFv3/M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oXryc-00GWzd-Jx; Tue, 13 Sep 2022 00:32:26 +0200
Date:   Tue, 13 Sep 2022 00:32:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, geert+renesas@glider.be,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 2/5] dt-bindings: net: renesas: Document Renesas Ethernet
 Switch
Message-ID: <Yx+zehiPfhEjkw1y@lunn.ch>
References: <20220909132614.1967276-1-yoshihiro.shimoda.uh@renesas.com>
 <20220909132614.1967276-3-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909132614.1967276-3-yoshihiro.shimoda.uh@renesas.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +  '#address-cells':
> +    description: Number of address cells for the MDIO bus.
> +    const: 1

Please could you explain this a bit more.

> +
> +  '#size-cells':
> +    description: Number of size cells on the MDIO bus.
> +    const: 0
> +
> +  ports:
> +    type: object

I think ethernet-ports is the preferred name.

> +
> +required:
> +  - compatible
> +  - reg
> +  - reg-names
> +  - interrupts
> +  - interrupt-names
> +  - clocks
> +  - clock-names
> +  - resets
> +  - power-domains
> +  - '#address-cells'
> +  - '#size-cells'

So ports are not required? You can have a 0 port switch?

   Andrew
