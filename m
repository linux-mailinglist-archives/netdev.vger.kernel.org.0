Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFB560CFAC
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbiJYO4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiJYO4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:56:38 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4114818A034;
        Tue, 25 Oct 2022 07:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9KVXF2dISX3pY65jB8OyxCsjmXAhcXjHeJSKytlZuPM=; b=Owofaetynqm03uumkMa7jEjadZ
        uCw+iHCEsi2tJJfvqYWtXq4eoTHRKUQ3O7aAEvAjnFZZfGJx63Hdon5YGHwrYzK5WtAC4vw2mv1Jb
        atO2d1OMqmy3kdqz0wrKvLsCgtXK8dpI2uYvY8TatJuYNquS7zT5dh4IiecooJbghc4g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1onLLx-000Xdt-M5; Tue, 25 Oct 2022 16:56:29 +0200
Date:   Tue, 25 Oct 2022 16:56:29 +0200
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
Subject: Re: [RFC net-next 2/2] net: dsa: Add driver for Maxlinear GSW1XX
 switch
Message-ID: <Y1f5HU9crkPGX3SB@lunn.ch>
References: <20221025135243.4038706-1-camel.guo@axis.com>
 <20221025135243.4038706-3-camel.guo@axis.com>
 <d942c724-4520-4a7b-8c36-704032c68a36@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d942c724-4520-4a7b-8c36-704032c68a36@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +EXPORT_SYMBOL(gsw1xx_shutdown);
> 
> 1. EXPORT_SYMBOL_GPL
> 2. Why do you do it in the first place? It's one driver, no need for
> building two modules. Same applies to other places.

At some point, there is likely to be SPI and UART support. The
communication with the chip and the core driver will then be in
separate modules. But i agree this is not needed at the moment when it
is all linked into one.

   Andrew
