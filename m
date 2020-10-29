Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6149E29ED9B
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 14:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgJ2NvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 09:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgJ2Nu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 09:50:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43591C0613D2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 06:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Yv4GXKVusnu2Goi4iB2n9mjUqposZ4aJb9C49FDRvE0=; b=JdqKnoXXmLmw3DDIJjPQ6o8YY
        L9Qrc9k+Jx3kvvlVKbQyOxfUflf/gs4OpNhscdwE5rMmrfdL6H2hivyf4lsPoxJopTDZUzwjuBFhD
        Kj3Ub/JmH2/PvntvRVFobaEansaby2q0oXWPjAU0M1WAFYQvBhDRHQHZ7VTN90UfMXpZz+iKEZQ6E
        CYkqKBelnO6BYqfozETtxzSPM+vNHTNHhMSssO3SIbltkSdiYZwp7OlWpZEhDNHHjyxkuRfsZluO3
        GIVNAG6i/T+nVWfBiBTfoWXgC/XqeNksnrqHltLssNo+E8rjMT6LGMGLgn9iNFw+hPPIIC7dt50tj
        jn/wd92VQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52478)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kY8Au-0004QT-2F; Thu, 29 Oct 2020 13:41:08 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kY8At-0006AB-QY; Thu, 29 Oct 2020 13:41:07 +0000
Date:   Thu, 29 Oct 2020 13:41:07 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 1/5] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <20201029134107.GV1551@shell.armlinux.org.uk>
References: <20201028221427.22968-1-kabel@kernel.org>
 <20201028221427.22968-2-kabel@kernel.org>
 <20201029124141.GR1551@shell.armlinux.org.uk>
 <20201029125439.GK933237@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029125439.GK933237@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 01:54:39PM +0100, Andrew Lunn wrote:
> > It would be good to pass this through checkpatch - I notice some lines
> > seem to be over the 80 character limit now.
> 
> Hi Russell
> 
> The limit got raised to something higher. I personally prefer 80, and
> if a file is using 80, new code would be inconsistent with old code if
> it did not use 80. So your request is reasonable anyway.

Hi Andrew,

I do most of my kernel hacking on the Linux console, so 80x25 is the
limit of what I see - and depending on the editor I'm using, lines
longer than 80 characters are chopped to 80 characters unless I scroll
to the right (which then makes moving up and down problematical.) So,
the files I'm responsible for are likely to stay requiring an 80
character width.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
