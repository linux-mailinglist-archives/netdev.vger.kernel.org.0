Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBF012FDDF
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgACUZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:25:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47012 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728490AbgACUZK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 15:25:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9mxXhdbtgN94d+uB0sJfQe/q2KayN2aAHVTKpNWCx6k=; b=Z3vMqoJvM9r53K1Dq/uexXxWwU
        jsaxIMsOOH8gK/gmoSnSp5dGjECGLPbWdIK96x1ROs4Ab35f2A3QB9C2xku5kJVhVXI3WhvtonBeO
        l5no/SL5S94DyFBeZQ0Z87L1+He4EuaEE20+ueca4tPUqmxuBezEY9Lgiai5foupmXl4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1inTVI-0002pw-OO; Fri, 03 Jan 2020 21:25:04 +0100
Date:   Fri, 3 Jan 2020 21:25:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: switch to using
 PHY_INTERFACE_MODE_10GBASER rather than 10GKR
Message-ID: <20200103202504.GQ1397@lunn.ch>
References: <20200103115125.GC25745@shell.armlinux.org.uk>
 <E1inLVE-0006gO-0S@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1inLVE-0006gO-0S@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> For Marvell mvpp2, we detect 10GBASE-KR, and rewrite it to 10GBASE-R
> for compatibility with existing DT - this is the only network driver
> at present that makes use of PHY_INTERFACE_MODE_10GKR.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> @@ -5247,6 +5247,9 @@ static int mvpp2_port_probe(struct platform_device *pdev,
>  		goto err_free_netdev;
>  	}
>  
> +	if (phy_mode == PHY_INTERFACE_MODE_10GKR)
> +		phy_mode = PHY_INTERFACE_MODE_10GBASER;

Hi Russell

Maybe consider adding a comment here, or suggest readers to read the
commit message of the patch that added these two lines to get the full
story.

Apart from that:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
