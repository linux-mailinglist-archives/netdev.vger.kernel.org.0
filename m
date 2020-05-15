Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DFF1D5873
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgEOR4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:56:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34702 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgEOR4l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 13:56:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zxUINokAPC9kPIuOzHoB7i/SEfEe9IJzDuYWwRlt5Ws=; b=1uM3E8Lg6agXBeUW7lPRKwOqaa
        W2mji2V18Z60ESitLVZxywwZOaZ/pquVQRA1Rl06WJf7m4GMujapAtiRZpvrIlj0ZjqKIBlvO6kuv
        RKaoL75Pft1Mu+J1SZCNqVZ6qTV2Drb8Tpk7ikn5VPyVmaxQvT7CTygpPoP5BvRaaQaY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZeZW-002PKQ-SV; Fri, 15 May 2020 19:56:34 +0200
Date:   Fri, 15 May 2020 19:56:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>
Subject: Re: [PATCH net-next v1] net: phy: tja11xx: execute cable test on
 link up
Message-ID: <20200515175634.GD499265@lunn.ch>
References: <20200514194218.22011-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514194218.22011-1-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 09:42:18PM +0200, Oleksij Rempel wrote:
> A typical 100Base-T1 link should be always connected. If the link is in
> a shot or open state, it is a failure. In most cases, we won't be able
> to automatically handle this issue, but we need to log it or notify user
> (if possible).
> 
> With this patch, the cable will be tested on "ip l s dev .. up" attempt
> and send ethnl notification to the user space.
> 
> This patch was tested with TJA1102 PHY and "ethtool --monitor" command.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
