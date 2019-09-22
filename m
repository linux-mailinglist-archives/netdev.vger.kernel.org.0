Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B448BA32D
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 18:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387768AbfIVQdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 12:33:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59140 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387745AbfIVQda (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Sep 2019 12:33:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oooDtL17oyfOp0RmGKu6/0RvtR7tESI34Tfl7UsU2k0=; b=dDRBFk1OBZU9NHRcr7Aw1aK6uf
        eRClBBKEv9BV45BT/f8TuImGYucIVxAIuBGiyQyhyRjaA5sMVyEKpFXMQ/uojX/gTacLXwkucWBpg
        LLo/SJBOaUql73oO3MfQT8TfwHQz5Rae+2h3pFHXqax+zuK/fFyo2IQQBIMZcnmHMYWg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iC4nZ-0007Bl-0t; Sun, 22 Sep 2019 18:33:21 +0200
Date:   Sun, 22 Sep 2019 18:33:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        tinywrkb <tinywrkb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] net: phy: fix write to mii-ctrl1000 register
Message-ID: <20190922163321.GA27014@lunn.ch>
References: <20190922105932.GP25745@shell.armlinux.org.uk>
 <E1iBzb8-00006n-4B@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iBzb8-00006n-4B@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 22, 2019 at 12:00:10PM +0100, Russell King wrote:
> When userspace writes to the MII_ADVERTISE register, we update phylib's
> advertising mask and trigger a renegotiation.  However, writing to the
> MII_CTRL1000 register, which contains the gigabit advertisement, does
> neither.  This can lead to phylib's copy of the advertisement becoming
> de-synced with the values in the PHY register set, which can result in
> incorrect negotiation resolution.
> 
> Fixes: 5502b218e001 ("net: phy: use phy_resolve_aneg_linkmode in genphy_read_status")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
