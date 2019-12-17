Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C22E11230AF
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbfLQPmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:42:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57678 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727370AbfLQPmi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 10:42:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fc+RH4hTT8M5tXJ4tzAjgqk+90pNd3Ra0lg3XzDsrFk=; b=mca2WvjkMLZj3fjHIVrFPjLjuQ
        usJn7YrOU8dBx58mMgioHadU1R0beRPdyyjYcK5I3aUpgiktCJjKd8RylEBdohuKMl47Vfu8EGtA2
        IdED1l+EFUuj49hm95ayCpjES9DSPeZ50ggdizKM+OyvHYu8fgf9sJDFcJm0tz2tK9SE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ihEzb-0002h6-A3; Tue, 17 Dec 2019 16:42:35 +0100
Date:   Tue, 17 Dec 2019 16:42:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 04/11] net: phy: provide and use
 genphy_read_status_fixed()
Message-ID: <20191217154235.GL17965@lunn.ch>
References: <20191217133827.GQ25745@shell.armlinux.org.uk>
 <E1ihD4G-0001yf-BK@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ihD4G-0001yf-BK@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 01:39:16PM +0000, Russell King wrote:
> There are two drivers and generic code which contain exactly the same
> code to read the status of a PHY operating without autonegotiation
> enabled. Rather than duplicate this code, provide a helper to read
> this information.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
