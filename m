Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55BB60CFCF
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 17:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbiJYPBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 11:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbiJYPBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 11:01:34 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED27619E922;
        Tue, 25 Oct 2022 08:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Bz6ULN8tp1K4+/IWgirL1lGFhItLERathS4mmOhY8xM=; b=lKd1s/E81eIwpBs5oBzPoqZoaa
        pKVnOUf5h4iemMkc1RWYkqQBkR7o06jHWjoS5ICZrDpVCknDpQLYwz5w4w+m1TbR89lAJjUel+JoC
        tbZlv+uauE9Oddqg8iPq8g1HfX5Z1fLOWPfaHW8DzTgIiTlqq6ctZp0G/q2BuCf3bclw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1onLQU-000Xf0-5l; Tue, 25 Oct 2022 17:01:10 +0200
Date:   Tue, 25 Oct 2022 17:01:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Camel Guo <camel.guo@axis.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rob Herring <robh@kernel.org>,
        kernel@axis.com
Subject: Re: [RFC net-next 1/2] dt-bindings: net: dsa: add bindings for GSW
 Series switches
Message-ID: <Y1f6NmjrXh77DNxs@lunn.ch>
References: <20221025135243.4038706-1-camel.guo@axis.com>
 <20221025135243.4038706-2-camel.guo@axis.com>
 <16aac887-232a-7141-cc65-eab19c532592@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16aac887-232a-7141-cc65-eab19c532592@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +      - enum:
> > +          - mxl,gsw145-mdio
> 
> Why "mdio" suffix?

I wondered about that as well. At some point in the future, there
could be an SPI version of this driver, and a UART version. Would they
all use the same compatible, and then context it used to determine the
correct binding? I think the kernel would be happy to do that, but i
don't know if the YAML tools can support that?

> > +examples:
> > +  - |
> > +    #include <dt-bindings/gpio/gpio.h>
> > +
> > +    mdio {
> 
> Hmmm... switch with MDIO is part of MDIO?

Happens a lot. Nothing wrong with this.

	Andrew
