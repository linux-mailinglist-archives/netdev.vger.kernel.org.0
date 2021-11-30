Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF0D463A93
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240545AbhK3Pyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:54:50 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59662 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239850AbhK3Pwm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 10:52:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=d7S20CEghZBi/z987bRi5FRLh905dQRCUWqjPh8HRAA=; b=oHJxE1cvREu6aRC4Pb/YADj4ji
        svwh1oioGyRJGOlNoyefKbmzbpDseS5q7mcjMUl5Fmwz7R3woyPWhBjZSN+LlXH4mEYadQUQ84Nz8
        OrU29kI7nh174+EZ+KcW9X36OfLSfSeVv1Heu1j+M9FNdB7J8lr3Y4/c7HBjvA27ExJc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ms5Ng-00F7IL-10; Tue, 30 Nov 2021 16:49:20 +0100
Date:   Tue, 30 Nov 2021 16:49:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 3/5] net: dsa: support use of
 phylink_generic_validate()
Message-ID: <YaZIAAPKJsbfKpff@lunn.ch>
References: <YaYiiU9nvmVugqnJ@shell.armlinux.org.uk>
 <E1ms2ta-00ECJH-6c@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ms2ta-00ECJH-6c@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 01:10:06PM +0000, Russell King (Oracle) wrote:
> Support the use of phylink_generic_validate() when there is no
> phylink_validate method given in the DSA switch operations and
> mac_capabilities have been set in the phylink_config structure by the
> DSA switch driver.
> 
> This gives DSA switch drivers the option to use this if they provide
> the supported_interfaces and mac_capabilities, while still giving them
> an option to override the default implementation if necessary.
> 
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
