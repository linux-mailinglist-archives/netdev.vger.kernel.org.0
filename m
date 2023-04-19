Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421416E7DAC
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbjDSPKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbjDSPKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:10:22 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702A449E6
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PgwWl1fmAp1kZ5oQcY6d2H/8wPFYdVvabBvDCbIXeXk=; b=4+CFSWNZ8Z/B6YqYDsU9MgEOL0
        9T7KuEmdVxxgJ3BcqsjUKiugHgpTHbjYofTVw0qoHnVJ91PaZ6KvLyxF0Z8VKNurIjyZsezvSiwJR
        mzY5rPYRZb1tZ/aHRjB1p4HyJiLRedGtVk2PmC08/1yH27jn5LF0yeQnk0kx9qBkycMs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pp9Rf-00Ahvu-VL; Wed, 19 Apr 2023 17:10:07 +0200
Date:   Wed, 19 Apr 2023 17:10:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Parthiban.Veerasooran@microchip.com
Cc:     ramon.nordin.rodriguez@ferroamp.se, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        Jan.Huber@microchip.com, Horatiu.Vultur@microchip.com,
        Woojung.Huh@microchip.com
Subject: Re: [PATCH] drivers/net/phy: add driver for Microchip LAN867x
 10BASE-T1S PHY
Message-ID: <83ee7ed8-87a2-4581-99c2-5efd4011257a@lunn.ch>
References: <ZD7YzBhzlEBHrEPC@builder>
 <9e5da8b1-bd47-307c-da75-580df4d575f6@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e5da8b1-bd47-307c-da75-580df4d575f6@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 02:40:29PM +0000, Parthiban.Veerasooran@microchip.com wrote:
> Hi Ramon,
> 
> Good day...! This is Parthiban from Microchip.
> 
> Thanks for your patches for the Microchip LAN867x 10BASE-T1S PHY. We 
> really appreciate your effort on this.
> 
> For your kind information, we are already working for the driver which 
> supports all the 10BASE-T1S PHYs from Microchip and doing internal 
> review of those driver patches to mainline. These patches are going to 
> reach mainline in couple of days. It is very unfortunate that we two are 
> working on the same task at the same time without knowing each other.
> 
> The architecture of your patch is similar to our current implementation. 
> However to be able to support also the upcoming 10BASE-T1S products 
> e.g., the LAN865x 10BASE-T1S MAC-PHY, additional functionalities have to 
> be implemented. In order to avoid unnecessary/redundant work on both 
> sides, we would like to collaborate with you on this topic and have a 
> sync outside of this mailing list before going forward.

Hi Parthiban

Please review version 2 of the patch which was posted today.  Is there
anything in that patch which is actually wrong?

I don't like the idea of dropping a patch, because a vendor comes out
of, maybe unintentional, stealth mode, and asks for their version to
be used, not somebody else's. For me this is especially important for
a new contributor.

My preferred way forward is to merge Ramon's code, and then you can
build on it with additional features to support other family
members.

Please don't get me wrong, i find it great you are supporting your own
devices. Not many vendors do. But Linux is a community, we have to
respect each others work, other members of the community.

	Andrew

FYI: Do you have any other drivers in the pipeline you want to
announce, just to avoid this happening again.
