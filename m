Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9949A010D
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 13:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfH1Lwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 07:52:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37226 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbfH1Lwy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 07:52:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=F8HrYF7+iaGpDQXz0KzYjonwq6ggYt9Ccmfg4T9jHqY=; b=sgvlwYbcM37KjpL5vlWe27/CD9
        xJvE9JQLif+m3mpx3tSN8GY2U4WuaV0ATLxU4NLgjUxjwjOzQ0WaTCumlCON/NQBnHbCa/MKeI1TJ
        wuiujbBs1uzKO0SXrMvznZHWn/kDMy3Zru9+HI8IrH939/7sTZpMHqUN28utbYcIZSnI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2wVO-0002Lp-3k; Wed, 28 Aug 2019 13:52:50 +0200
Date:   Wed, 28 Aug 2019 13:52:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next v2 3/3] dpaa2-eth: Add pause frame support
Message-ID: <20190828115250.GA32178@lunn.ch>
References: <1566915351-32075-1-git-send-email-ruxandra.radulescu@nxp.com>
 <1566915351-32075-3-git-send-email-ruxandra.radulescu@nxp.com>
 <20190827232132.GD26248@lunn.ch>
 <AM0PR04MB499496AC09FD7BE58AE7B9C394A30@AM0PR04MB4994.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB499496AC09FD7BE58AE7B9C394A30@AM0PR04MB4994.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Clearing the ASYM_PAUSE flag only means we tell the firmware we want
> both Rx and Tx pause to be enabled in the beginning. User can still set
> an asymmetric config (i.e. only Rx pause or only Tx pause to be enabled)
> if needed.
> 
> The truth table is like this:
> 
> PAUSE | ASYM_PAUSE | Rx pause | Tx pause
> ----------------------------------------
>   0   |     0      | disabled | disabled
>   0   |     1      | disabled | enabled
>   1   |     0      | enabled  | enabled
>   1   |     1      | enabled  | disabled

Hi Ioana

Ah, that is not intuitive. Please add a comment, and maybe this table
to the commit message.

Thanks
	Andrew
