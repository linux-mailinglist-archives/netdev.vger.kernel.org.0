Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4733451E798
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 15:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442223AbiEGOB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 10:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbiEGOB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 10:01:56 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B0E29CA8;
        Sat,  7 May 2022 06:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jD8TyMuu+bcxOTqwym8lZasuV6dU31UITBMEYcnRFAI=; b=1/ZYjMcXmaJSnoaN1HeHcCGzx7
        djzOpbh1ZM+SyjG7CzhJFP7Tzpzc79UWgRfimTck00mJJXEtbkKtj9adeb0hbetowturcbZ6dvpju
        kRr7UQ+Y/thbkyhvcB1Gv8mUk0dZRzsub15oBBEelgRDXCiuz5fsrrb/L2zOh7wVxGfg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nnKwT-001fFK-18; Sat, 07 May 2022 15:57:53 +0200
Date:   Sat, 7 May 2022 15:57:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH net v2] net: phy: Fix race condition on link status change
Message-ID: <YnZ64cXE0ZRdHEbX@lunn.ch>
References: <20220506060815.327382-1-francesco.dolcini@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506060815.327382-1-francesco.dolcini@toradex.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 08:08:15AM +0200, Francesco Dolcini wrote:
> This fixes the following error caused by a race condition between
> phydev->adjust_link() and a MDIO transaction in the phy interrupt
> handler. The issue was reproduced with the ethernet FEC driver and a
> micrel KSZ9031 phy.
> 
> Link: https://lore.kernel.org/all/20220422152612.GA510015@francesco-nb.int.toradex.com/
> Fixes: c974bdbc3e77 ("net: phy: Use threaded IRQ, to allow IRQ from sleeping devices")
> cc: <stable@vger.kernel.org>
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
