Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE1B017E06B
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 13:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgCIMk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 08:40:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53184 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbgCIMk0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 08:40:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3nTYfiF7+gZ9vkOt05eVEOKFGfzbEQ1Zj6u5rgUmyB4=; b=ItewTtmIU7mNiwYIVpgyUH4cBh
        B4Qpeq/t07tF3Ml0Dcwf47/F6EsbL8dOKpbq4ypbW1EFXqT8EqvgBWPsnpvzk6g7BxPJntXmjkRCV
        OhFc922GjIdz9gtwOCymYs8leB57vAkwEZg5LTj8TjfTZrNqRZt5AfP6bHXtWEr/QFjw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jBHhi-0002Ry-HX; Mon, 09 Mar 2020 13:40:18 +0100
Date:   Mon, 9 Mar 2020 13:40:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     David Miller <davem@davemloft.net>, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        vivien.didelot@gmail.com
Subject: Re: [PATCH net-next 0/10] net: dsa: improve serdes integration
Message-ID: <20200309124018.GA8942@lunn.ch>
References: <20200305124139.GB25745@shell.armlinux.org.uk>
 <20200308.220447.1610295462041711848.davem@davemloft.net>
 <20200309094828.GJ25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309094828.GJ25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yep - it comes from the poor integration of phylink into DSA for CPU
> and inter-DSA ports which is already causing regressions in today's
> kernels. That needs resolving somehow before this patch series can
> be merged, but it isn't something that can be fixed from the phylink
> side of things.

Hi Russell

What do you think about my proposal to solve it? Only instantiate
phylink for CPU and DSA ports if there is a fixed-link or phy-handle
in DT?

I also looked at the code before this integration. I had the open
question of if it was possible to just have a phy-mode property,
without fixed link. And the answer is no.

So i will formally propose my solution.

   Andrew
