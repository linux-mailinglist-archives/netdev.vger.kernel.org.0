Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC0D10750B
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 16:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfKVPl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 10:41:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51836 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfKVPl4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 10:41:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=THFUwirn/uJnC7DI3jfFtAvR/UqZZDFawj8Dyx6URJc=; b=PV5pursFlMYrdGaMRpwCluiQYc
        qiJu304Y3kCUiu2APiD/uD+7aWSX5asvZCvhhQVzpTMbfjdZHxg1DuR1yvHvI8fmhnDAHxj4XlLfo
        13ptDVI3zZEzDFaYsn54XaBJmFrdxmNiDF2kCMdUgRXuPKjJ2rtBmAnTL+kBSs2Kb0iw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iYB46-00060w-V5; Fri, 22 Nov 2019 16:41:46 +0100
Date:   Fri, 22 Nov 2019 16:41:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: remove phy_ethtool_sset()
Message-ID: <20191122154146.GD6602@lunn.ch>
References: <E1iY8BQ-00066m-TG@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iY8BQ-00066m-TG@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 12:37:08PM +0000, Russell King wrote:
> There are no users of phy_ethtool_sset() in the kernel anymore, and
> as of 3c1bcc8614db ("net: ethernet: Convert phydev advertize and
> supported from u32 to link mode"), the implementation is slightly
> buggy - it doesn't correctly check the masked advertising mask as it
> used to.
> 
> Remove it, and update the phy documentation to refer to its replacement
> function.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
