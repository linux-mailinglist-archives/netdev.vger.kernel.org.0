Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C83A7337D
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 18:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbfGXQQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 12:16:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34744 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728648AbfGXQQq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 12:16:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=urEfdlEnQJsgARKkm/g2OfSzst3Vv0HhmCCdBoa7P5g=; b=Qr8kJGcVER6/NpgrgSpyVtTxg8
        NqZbdu6KrSGTJaRCiBoOfNoYa6jAcNIMcjJc7MdZOvBocsJitCytyT86oEatebRDrxgzRFBgaRXGJ
        9QxL6emAZ9WxsHwQE+ulqE1Z3ULsbK7KLZFKCk/9rmUyGXwgUu0fuI1Xid4fRzB2dE+U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hqJwZ-0000Sv-AZ; Wed, 24 Jul 2019 18:16:43 +0200
Date:   Wed, 24 Jul 2019 18:16:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andreas Schwab <schwab@suse.de>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: mscc: initialize stats array
Message-ID: <20190724161643.GS25635@lunn.ch>
References: <mvmh87bih1y.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mvmh87bih1y.fsf@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 05:32:57PM +0200, Andreas Schwab wrote:
> The memory allocated for the stats array may contain arbitrary data.
> 
> Signed-off-by: Andreas Schwab <schwab@suse.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Fixes: e4f9ba642f0b ("net: phy: mscc: add support for VSC8514 PHY.")
Fixes: 00d70d8e0e78 ("net: phy: mscc: add support for VSC8574 PHY")
Fixes: a5afc1678044 ("net: phy: mscc: add support for VSC8584 PHY")
Fixes: f76178dc5218 ("net: phy: mscc: add ethtool statistics counters")

    Andrew
