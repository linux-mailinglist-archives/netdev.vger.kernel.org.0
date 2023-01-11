Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB760666598
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 22:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235449AbjAKVZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 16:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235518AbjAKVZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 16:25:10 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2788C431A0;
        Wed, 11 Jan 2023 13:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=n9lPSUe/MWHralA1qvhL+QIgsVGrrE7VjDTztL3sRGc=; b=rjPRASotRzpuje0OmF1s2p84vT
        3bt0irRqZt4IerKMNtIOCCP+auihb8VlfiEvqbslXl7pGOCJ59HT+8UVZFZKmZzsoWAJ0w9lgsqnJ
        lBZlBA7yYx0wDTT36zfA0uWa7Rvow52SdBwTfm2g1sYRDQvc4UCVJ/AdJ8/wVS9mPtwo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pFiaW-001oQo-95; Wed, 11 Jan 2023 22:24:48 +0100
Date:   Wed, 11 Jan 2023 22:24:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rob Herring <robh@kernel.org>
Cc:     Michael Walle <michael@walle.cc>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Xu Liang <lxu@maxlinear.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/4] dt-bindings: net: phy: add MaxLinear
 GPY2xx bindings
Message-ID: <Y78pIMDwN7TeL3Ek@lunn.ch>
References: <20230109123013.3094144-1-michael@walle.cc>
 <20230109123013.3094144-3-michael@walle.cc>
 <20230111202639.GA1236027-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111202639.GA1236027-robh@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The real answer here is add a compatible. But I'm tired of pointing this 
> out to the networking maintainers every damn time. Ethernet PHYs are not 
> special.

I agree, they are the same as USB and PCI, and other enumerable
busses. The enumeration data tells you what the device is. That is how
the kernel finds the correct driver for the device, nothing special at
all for PHYs.

	Andrew
