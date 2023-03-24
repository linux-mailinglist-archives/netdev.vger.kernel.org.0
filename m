Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8FB6C7B2F
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbjCXJWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbjCXJWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:22:43 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B7F233C9
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 02:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lDxnHFgmpWqMRfwat0G05tPq3Kat2xbm6gVP8SbZPsA=; b=z7Un6EMuX0Fo38jdWYIdG8CPIF
        rX0DfOCGh0GmQijiN3mNg1luNZm0FQXd15qitzlo1KMlFcOTNDm7g9p/qITQqs32NJv79nsNsq2AM
        33m6C0Cb/nq8AiE6nWGOu3tuHSj0oLWvoD0uB7k7Z7qI4Qb9nTvEMqlVTF/5Hhpyu5qultmbuXhfQ
        lmmGI35bFCxN30SpE9v9b3Je7ruhf6RsMPqNq2FzfhSk/Rmgi/CLW9lWopOoYcIaQ4BY8JIeEFrPh
        B/FGiY+jCvSb+vcPCJu2oxZKiIomKNiX6LiAgJ7RYhQmzpOT3abHEs0gqbdD5rEqETNoCQfMr61rQ
        xmhyM7yg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33120)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pfdcq-0006it-HD; Fri, 24 Mar 2023 09:22:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pfdcp-0002Jp-Ti; Fri, 24 Mar 2023 09:22:19 +0000
Date:   Fri, 24 Mar 2023 09:22:19 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 0/3] Constify a few sfp/phy fwnodes
Message-ID: <ZB1ry/VNosxWL/QK@shell.armlinux.org.uk>
References: <ZB1rNMAJ9oLr8myx@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZB1rNMAJ9oLr8myx@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oops, I typo'd one of the addresses when sending the series. I'll
re-send. Please ignore this posting.

On Fri, Mar 24, 2023 at 09:19:48AM +0000, Russell King (Oracle) wrote:
> Hi,
> 
> This series constifies a bunch of fwnode_handle pointers that are only
> used to refer to but not modify the contents of the fwnode structures.
> 
>  drivers/net/phy/phy_device.c | 2 +-
>  drivers/net/phy/sfp-bus.c    | 6 +++---
>  include/linux/phy.h          | 2 +-
>  include/linux/sfp.h          | 5 +++--
>  4 files changed, 8 insertions(+), 7 deletions(-)
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
