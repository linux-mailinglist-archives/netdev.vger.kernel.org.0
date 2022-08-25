Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4D65A1A23
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242989AbiHYUQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242525AbiHYUQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:16:36 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F879BFEA2;
        Thu, 25 Aug 2022 13:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5SXUIhrjauVS9CJyRq7oSmWzAiCW3NIz2CQaiUbjGBA=; b=l+MrObVcs6pWde33MQC6/Ghw5u
        xeG22J5XSpZI7PQovIJOs/vMXIFIXR5ND7f3YZbt1NJ76E4xzEa/sIksJUrKZSlgWdtv2WhinNZjo
        kTsPNCPrv+yXNE8HD0hUKYEhONNS4O17PP3SFPnF719qOt0zNzTYK3FTCvEUWZ13augo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oRJHD-00EbSr-6f; Thu, 25 Aug 2022 22:16:31 +0200
Date:   Thu, 25 Aug 2022 22:16:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michael@walle.cc, UNGLinuxDriver@microchip.com,
        maxime.chevallier@bootlin.com
Subject: Re: [PATCH net-next v2] net: phy: micrel: Make the GPIO to be
 non-exclusive
Message-ID: <YwfYnwzQsDruVi5y@lunn.ch>
References: <20220825201447.1444396-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825201447.1444396-1-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 10:14:47PM +0200, Horatiu Vultur wrote:
> The same GPIO line can be shared by multiple phys for the coma mode pin.
> If that is the case then, all the other phys that share the same line
> will failed to be probed because the access to the gpio line is not
> non-exclusive.
> Fix this by making access to the gpio line to be nonexclusive using flag
> GPIOD_FLAGS_BIT_NONEXCLUSIVE. This allows all the other PHYs to be
> probed.
> 
> Fixes: 738871b09250ee ("net: phy: micrel: add coma mode GPIO")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
