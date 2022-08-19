Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0041F59A7CF
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 23:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352681AbiHSVcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 17:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352674AbiHSVcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 17:32:12 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160AE1141B1;
        Fri, 19 Aug 2022 14:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BiQ7RzJ+laBK1rDc/5jy1mgdjrlJp+mu2ACcxdGd1VM=; b=A6mK4g+fzEPq25VNZVJWrJ0cXK
        bgieyZVw/kN+PURuUFnk807mfRyTOj3O2jEdajTRWk6aQiWzxBQM7dzzqjqphzatdLUo1nyvUiwMK
        G0ruGUqPaOewsLWbU4roSRiF9UCkAfrP+b/8P1ioMgesZm8cudTqb5NSzf55H3aTSgh8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oP9ay-00DxK3-ML; Fri, 19 Aug 2022 23:32:00 +0200
Date:   Fri, 19 Aug 2022 23:32:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: Re: [PATCH net-next v1 4/7] net: pse-pd: add generic PSE driver
Message-ID: <YwABUCYRRiCns3bO@lunn.ch>
References: <20220819120109.3857571-1-o.rempel@pengutronix.de>
 <20220819120109.3857571-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819120109.3857571-5-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 02:01:06PM +0200, Oleksij Rempel wrote:
> Add generic driver to support simple Power Sourcing Equipment without
> automatic classification support.
> 
> This driver was tested on 10Bast-T1L switch with regulator based PoDL PSE.

Do you have access to a PHY which implements clause 45.2.9? That seems
like a better reference implementation?

I don't know the market, what is more likely, a simple regulator, or
something more capable with an interface like 45.2.9?

netlink does allow us to keep adding more attributes, so we don't need
to be perfect first time, but it seems like 45.2.9 is what IEEE expect
vendors to provide, so at some point Linux should implement it.

	  Andrew
