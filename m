Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283705BEA7A
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbiITPpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiITPpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:45:11 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE10D1EEC3;
        Tue, 20 Sep 2022 08:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=t7c9L8PH8yyeuHV6ztLbyYD3Hs5tKOUbHkXDFpmhZUI=; b=OP1bAo3ZoewTQRsmB/rwKhK35d
        bmVm1a34Obtbi6qs6Tt+nub+wFT6cwSco0pkACIhkIhcwGQU8GCdKb47VCqrKeQXlS+vxlK+TZAaw
        lDHgJ0uhh594IS+XJDRWa7kuaLBC+Rf/o0N+8PZA5NB8wYj8iBz/DniQzZlyyq3hTklw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oafQe-00HHnR-72; Tue, 20 Sep 2022 17:44:56 +0200
Date:   Tue, 20 Sep 2022 17:44:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net] net: phy: micrel: fix shared interrupt on LAN8814
Message-ID: <Yynf+PjruR2UxwDE@lunn.ch>
References: <20220920141619.808117-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920141619.808117-1-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 04:16:19PM +0200, Michael Walle wrote:
> Since commit ece19502834d ("net: phy: micrel: 1588 support for LAN8814
> phy") the handler always returns IRQ_HANDLED, except in an error case.
> Before that commit, the interrupt status register was checked and if
> it was empty, IRQ_NONE was returned. Restore that behavior to play nice
> with the interrupt line being shared with others.
> 
> Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
