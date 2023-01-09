Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1254D66275D
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbjAINlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237007AbjAINk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:40:29 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36A415F18;
        Mon,  9 Jan 2023 05:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xF9hrGoU55eyFaij9No2tkH7fVWWNifwfNMjji+BpAU=; b=fz17Q0Y8dEsMfW3WZKegfEmQtF
        H09Pq87cGB1rcaoMrW9cNC/IOCu4f30AIVhGGmObPrEyISMdF3Icy8vuMf5+t895Q1psbQg9icxpN
        D/jnvcRnKaUcv0MYy4MT/3RRMOvEdpWqHOXAcT2Rv+8QQ59giBYUkGwV+OTK6G5xMlFQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pEsMz-001ZSi-2O; Mon, 09 Jan 2023 14:39:21 +0100
Date:   Mon, 9 Jan 2023 14:39:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Xu Liang <lxu@maxlinear.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/4] dt-bindings: net: phy: add MaxLinear
 GPY2xx bindings
Message-ID: <Y7wZCfOursl208bv@lunn.ch>
References: <20230109123013.3094144-1-michael@walle.cc>
 <20230109123013.3094144-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109123013.3094144-3-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 01:30:11PM +0100, Michael Walle wrote:
> Add the device tree bindings for the MaxLinear GPY2xx PHYs, which
> essentially adds just one flag: maxlinear,use-broken-interrupts.
> 
> One might argue, that if interrupts are broken, just don't use
> the interrupt property in the first place. But it needs to be more
> nuanced. First, this interrupt line is also used to wake up systems by
> WoL, which has nothing to do with the (broken) PHY interrupt handling.
> 
> Second and more importantly, there are devicetrees which have this
> property set. Thus, within the driver we have to switch off interrupt
> handling by default as a workaround. But OTOH, a systems designer who
> knows the hardware and knows there are no shared interrupts for example,
> can use this new property as a hint to the driver that it can enable the
> interrupt nonetheless.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
