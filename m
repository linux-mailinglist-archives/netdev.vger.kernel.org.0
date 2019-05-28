Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 766D12CAAA
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 17:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfE1Pvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 11:51:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35752 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbfE1Pvz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 11:51:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Z4MDT40EsHcm8b+ycm198dT0iRaqvU0mBuHTdoszoT8=; b=khcNokEBUokXnSssiCbqM1AbG0
        FV6upidhOa1Z6cYOJbcBsYAUa98ThxwEy53x2ao2k6d2qgmZu4Un2EGG4zmDSrTG50Q2ovMyvjFFk
        FQXJ1GFMvqtHnzBbUA/VkNjIdFTYzi374OhevorOnnnpStQpXG8q5RYgISbTMmuunn6g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hVeOD-0008AM-Vz; Tue, 28 May 2019 17:51:49 +0200
Date:   Tue, 28 May 2019 17:51:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     linux@armlinux.org.uk, f.fainelli@gmail.com, hkallweit1@gmail.com,
        maxime.chevallier@bootlin.com, olteanv@gmail.com,
        thomas.petazzoni@bootlin.com, davem@davemloft.net,
        vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH 03/11] net: phy: Check against net_device being NULL
Message-ID: <20190528155149.GP18059@lunn.ch>
References: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
 <1558992127-26008-4-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558992127-26008-4-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 12:21:59AM +0300, Ioana Ciornei wrote:
> In general, we don't want MAC drivers calling phy_attach_direct with the
> net_device being NULL. Add checks against this in all the functions
> calling it: phy_attach() and phy_connect_direct().
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Suggested-by: Andrew Lunn <andrew@lunn.ch>

I should actually say, once you fix the sparse warnings, you can add:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
