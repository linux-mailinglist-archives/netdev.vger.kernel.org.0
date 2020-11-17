Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B616C2B6D79
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 19:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731334AbgKQSfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 13:35:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:38390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727245AbgKQSfH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 13:35:07 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCBCD223C7;
        Tue, 17 Nov 2020 18:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605638107;
        bh=z1Z51k24+WqgvexWgYt20GXSqLL7tSTHxx2+WDChyKE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZFWYeOyzOGVEM1xVSe7OBqgniKjWumOyXzbEDRkcUqFojFSO/R0f1kaa6RT332IRg
         tYeHFX6gUSlSsfKTd/S90wmTwNle6CTAeNbKu8Ygpx3oywr4AqJafDHGk8/DBLe5aS
         Pc9DaVEizmTIGGtg7VQgfpiPe3HE0JL9rANAFyYs=
Date:   Tue, 17 Nov 2020 10:35:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: don't duplicate driver name in
 phy_attached_print
Message-ID: <20201117103506.2cc5d015@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201117025354.GL1752213@lunn.ch>
References: <8ab72586-f079-41d8-84ee-9f6a5bd97b2a@gmail.com>
        <20201117025354.GL1752213@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 03:53:54 +0100 Andrew Lunn wrote:
> On Sun, Nov 15, 2020 at 04:03:10PM +0100, Heiner Kallweit wrote:
> > Currently we print the driver name twice in phy_attached_print():
> > - phy_dev_info() prints it as part of the device info
> > - and we print it as part of the info string
> > 
> > This is a little bit ugly, it makes the info harder to read,
> > especially if the driver name is a little bit longer.
> > Therefore omit the driver name (if set) in the info string.
> > 
> > Example from r8169 that uses phylib:
> > 
> > old: Generic FE-GE Realtek PHY r8169-300:00: attached PHY driver \
> >    [Generic FE-GE Realtek PHY] (mii_bus:phy_addr=r8169-300:00, irq=IGNORE)
> > new: Generic FE-GE Realtek PHY r8169-300:00: attached PHY driver \
> >    (mii_bus:phy_addr=r8169-300:00, irq=IGNORE)
> > 
> > Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
