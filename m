Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B8F621887
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 16:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbiKHPka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 10:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233615AbiKHPk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 10:40:29 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4ED58BED
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 07:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=z6YzrDNXsL/IMVHWXyoZxq/P1dZwP1Q7Dg8KkKaxWEY=; b=SrkuIHJIlc16xZJ2r6dd0tAHkN
        lrGyNH26IgFauCxNUDy+D2CyyZv1Zvl3UDb1IiAijAyjAMZbpvxnd5C+8on/BFBjrwOsNEa9Z8jye
        qKFjZGKLwq6PSZ7XnkZ6LbE7R3LqqN3/Jh8ucO9/Yb7yvLJdZ1MrSOOPLA5L+FwLTBII=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osQi3-001pnL-E2; Tue, 08 Nov 2022 16:40:19 +0100
Date:   Tue, 8 Nov 2022 16:40:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 2/2] net: pcs: xpcs: use mdiodev accessors
Message-ID: <Y2p4Y4GVYed2j1l4@lunn.ch>
References: <Y2pm13+SDg6N/IVx@shell.armlinux.org.uk>
 <E1osPY9-002SMq-3e@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1osPY9-002SMq-3e@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 02:26:01PM +0000, Russell King (Oracle) wrote:
> Use mdiodev accessors rather than accessing the bus and address in
> the mdio_device structure and using the mdiobus accessors.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
