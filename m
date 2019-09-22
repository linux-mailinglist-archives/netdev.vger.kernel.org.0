Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 395BEBA32F
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 18:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387803AbfIVQij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 12:38:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59166 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387797AbfIVQij (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Sep 2019 12:38:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=P6xyTRCVDD2tjXxDhK7sTXb1W0kTqTbMGpeCLW6EvqA=; b=DWZDeU5kffX1zD3c9HD5NhDMSs
        Jc8HM8NAl5xHWK/7wRsWk4eTaQlpXLYKh7unP+i4M/Z4vc4HJCGR1TDhfYq7JnYA9UGXHm9C9T41y
        oIJiYq8H9Zk2ILa2rTNns6FpFgYdCKiaBtYVwzKSQHOPNai23P+ExBzTyR2aDI48Ha6s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iC4sd-0007Ga-Ik; Sun, 22 Sep 2019 18:38:35 +0200
Date:   Sun, 22 Sep 2019 18:38:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        tinywrkb <tinywrkb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] net: phy: extract pause mode
Message-ID: <20190922163835.GC27014@lunn.ch>
References: <20190922105932.GP25745@shell.armlinux.org.uk>
 <E1iBzbI-000072-R4@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iBzbI-000072-R4@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 22, 2019 at 12:00:20PM +0100, Russell King wrote:
> Extract the update of phylib's software pause mode state from
> genphy_read_status(), so that we can re-use this functionality with
> PHYs that have alternative ways to read the negotiation results.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

 
