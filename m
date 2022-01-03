Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975014837F8
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 21:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiACURH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 15:17:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48912 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229796AbiACURG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 15:17:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Vf5wOj87nDDqoWf4K3ixKJIVmId5Nb/tYgNTZ1dD8/E=; b=pTPDqwZDOvTHS4/trs44+furnE
        MAOi1ITSevyj+GPQMi8mUsjFYB89BmF4oDd5aD9bEI3sp2SV5N2T54aMNd8BfUNgl3HDopeN4HXMm
        Fy2BmxYIoOe1U+H1w39biPd8vzG1mQiTZcrX2Oyc8XDLTfhyyh0wxH39gQ36EJr1yQNw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n4TlJ-000P99-6x; Mon, 03 Jan 2022 21:16:57 +0100
Date:   Mon, 3 Jan 2022 21:16:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Miaoqian Lin <linmq006@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] Revert "net: phy: fixed_phy: Fix NULL vs IS_ERR()
 checking in __fixed_phy_register"
Message-ID: <YdNZuUrCMj0KxL9H@lunn.ch>
References: <20220103193453.1214961-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103193453.1214961-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 03, 2022 at 11:34:52AM -0800, Florian Fainelli wrote:
> This reverts commit b45396afa4177f2b1ddfeff7185da733fade1dc3 ("net: phy:
> fixed_phy: Fix NULL vs IS_ERR() checking in __fixed_phy_register")
> since it prevents any system that uses a fixed PHY without a GPIO
> descriptor from properly working:
> 
> [    5.971952] brcm-systemport 9300000.ethernet: failed to register fixed PHY
> [    5.978854] brcm-systemport: probe of 9300000.ethernet failed with error -22
> [    5.986047] brcm-systemport 9400000.ethernet: failed to register fixed PHY
> [    5.992947] brcm-systemport: probe of 9400000.ethernet failed with error -22
> 
> Fixes: b45396afa417 ("net: phy: fixed_phy: Fix NULL vs IS_ERR() checking in __fixed_phy_register")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

I was hoping the original author would fixup the breakage, but it has
been a couple of days now....

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
