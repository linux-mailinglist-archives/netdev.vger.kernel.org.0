Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11823BA333
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 18:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388059AbfIVQpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 12:45:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59178 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387634AbfIVQpc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Sep 2019 12:45:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1m73hiKgDlbgXkWMZgeWL8NAAMGVSlnpLoJM6IyuyCI=; b=29AgFZfqHl7qToIW5JZpAf6IP2
        k1FvEnNN75otJq0QcE9uXVA3lkLxZ1WLX+6uuspDSknQR45zKvdjS6dJYsoGJwSQQWJhsLyb2pJ9J
        4oWjR+SW1crdQsaiCDJrkALmEwBH0iS4vrjjr2iFfCtoAZeViUOA5Gk0geFR2fLQ8OBk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iC4zI-0007NT-4R; Sun, 22 Sep 2019 18:45:28 +0200
Date:   Sun, 22 Sep 2019 18:45:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        tinywrkb <tinywrkb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] net: phy: at803x: use operating parameters from
 PHY-specific status
Message-ID: <20190922164528.GD27014@lunn.ch>
References: <20190922105932.GP25745@shell.armlinux.org.uk>
 <E1iBzbN-00007N-U4@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iBzbN-00007N-U4@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 22, 2019 at 12:00:25PM +0100, Russell King wrote:
> Read the PHY-specific status register for the current operating mode
> (speed and duplex) of the PHY.  This register reflects the actual
> mode that the PHY has resolved depending on either the advertisements
> of autoneg is enabled, or the forced mode if autoneg is disabled.
> 
> This ensures that phylib's software state always tracks the hardware
> state.
> 
> It seems both AR8033 (which uses the AR8031 ID) and AR8035 support
> this status register.  AR8030 is not known at the present time.
> 
> Reported-by: tinywrkb <tinywrkb@gmail.com>
> Fixes: 5502b218e001 ("net: phy: use phy_resolve_aneg_linkmode in genphy_read_status")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
