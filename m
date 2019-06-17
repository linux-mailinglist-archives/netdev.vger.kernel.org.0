Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3FFD48AB0
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbfFQRmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:42:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34008 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbfFQRmu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 13:42:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nCH6BDC7J09reoJu/jQ/LAs4sV5ldXtOBNrWm5zFi3w=; b=r894H6YeNo8HsjgzjJq3zsze0B
        waw1m8XMh8ijMLylgCTlJqmozUbl/f4bG7B2AJCb1xjcEnLU7dK6OLAugo/c9F7oDWSPBMMk6VAhP
        DJLbZdlfYGaB75ghwdIeEphtjRTBXLQpBBIT40hYjF3KqmG2dvrEKfOrsBDbaIYYL5Z0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hcveV-0002M1-0J; Mon, 17 Jun 2019 19:42:43 +0200
Date:   Mon, 17 Jun 2019 19:42:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        f.fainelli@gmail.com, netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, rafalc@cadence.com,
        aniljoy@cadence.com, piotrs@cadence.com
Subject: Re: [PATCH 1/6] net: macb: add phylink support
Message-ID: <20190617174242.GL17551@lunn.ch>
References: <1560642311-25585-1-git-send-email-pthombar@cadence.com>
 <1560642367-26425-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560642367-26425-1-git-send-email-pthombar@cadence.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -4217,8 +4257,8 @@ static int macb_probe(struct platform_device *pdev)
>  
>  	tasklet_init(&bp->hresp_err_tasklet, macb_hresp_error_task,
>  		     (unsigned long)bp);
> -
> -	phy_attached_info(phydev);
> +	if (dev->phydev)
> +		phy_attached_info(dev->phydev);

When can this happen? I don't see anything assigning to dev->phydev.

     Andrew
