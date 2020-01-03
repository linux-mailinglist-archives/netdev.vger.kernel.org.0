Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C41A912FE23
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbgACUvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:51:45 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47094 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728481AbgACUvp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 15:51:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JXaQP/3zytWpIBG1NBfK12fmZRwUZV2vQnBbwbHF50k=; b=UZUthdjMI9YiMYvThYild0M1zZ
        EJ4hezRssdr1H23IxKRIjDPO8cIWnnYv1pimsKAp3QyD1/7gY2XQiVzDZ/6G/4PWSbIbAZgSlxvyD
        av38FU40Zs3njxjyi17X1ySfEc0a0PDdE//xUOT2y0C06IzKa6v7uHtXz9Rie7f0qHj4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1inTuy-0003Dj-8i; Fri, 03 Jan 2020 21:51:36 +0100
Date:   Fri, 3 Jan 2020 21:51:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: switch to using
 PHY_INTERFACE_MODE_10GBASER rather than 10GKR
Message-ID: <20200103205136.GT1397@lunn.ch>
References: <20200103204241.GB18808@shell.armlinux.org.uk>
 <E1inTn1-0001TI-4W@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1inTn1-0001TI-4W@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/*
> +	 * Rewrite 10GBASE-KR to 10GBASE-R for compatibility with existing DT.
> +	 * Existing usage of 10GBASE-KR is not correct; no backplane
> +	 * negotiation is done, and this driver does not actually support
> +	 * 10GBASE-KR.
> +	 */
> +	if (phy_mode == PHY_INTERFACE_MODE_10GKR)
> +		phy_mode = PHY_INTERFACE_MODE_10GBASER;
> +

Thanks

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
