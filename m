Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE9C4EEEB8
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346630AbiDAOBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242987AbiDAOBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:01:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BF052B34;
        Fri,  1 Apr 2022 07:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=co65ZWBKBEpVb/JZUyvmTOVLiqIJkjXOz+FJoKbVHAw=; b=uHaLW2QFVeu3KNPr3p7uoEs7lv
        UYG72BCbFruHtqJAh8YsIKwPMKboPaMFohvV10qffImed2PGJhtbqMlaNRwGUboTBH/CCCO3BCoIS
        4L6kb3RHpuoZMdJ9L9JNfKdJ/rCHJBhTNEyFs9rYDhKIJR52qfU9JuJk3tyroyg+iZL4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1naHon-00DgNg-RB; Fri, 01 Apr 2022 16:00:01 +0200
Date:   Fri, 1 Apr 2022 16:00:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, Divya.Koppera@microchip.com,
        davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net 2/3] net: phy: micrel: Remove latency from driver
Message-ID: <YkcFYb1SInTCDjIh@lunn.ch>
References: <20220401094805.3343464-1-horatiu.vultur@microchip.com>
 <20220401094805.3343464-3-horatiu.vultur@microchip.com>
 <Ykb0RgM+fnzOUTNx@lunn.ch>
 <20220401133454.ic6jxnripuxjhp5g@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401133454.ic6jxnripuxjhp5g@soft-dev3-1.localhost>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 01, 2022 at 03:34:54PM +0200, Horatiu Vultur wrote:
> The 04/01/2022 14:47, Andrew Lunn wrote:
> > 
> > On Fri, Apr 01, 2022 at 11:48:04AM +0200, Horatiu Vultur wrote:
> > > Based on the discussions here[1], the PHY driver is the wrong place
> > > to set the latencies, therefore remove them.
> > >
> > > [1] https://lkml.org/lkml/2022/3/4/325
> > >
> > > Fixes: ece19502834d84 ("net: phy: micrel: 1588 support for LAN8814 phy")
> > > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > 
> > Thanks for the revert.
> > 
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > 
> > > -static struct kszphy_latencies lan8814_latencies = {
> > > -     .rx_10          = 0x22AA,
> > > -     .tx_10          = 0x2E4A,
> > > -     .rx_100         = 0x092A,
> > > -     .tx_100         = 0x02C1,
> > > -     .rx_1000        = 0x01AD,
> > > -     .tx_1000        = 0x00C9,
> > > -};
> > 
> > What are the reset defaults of these? 
> 
> Those are actually the reset values.

Does the driver do a reset, so we can assume the hardware is actually
using these?

      Andrew

