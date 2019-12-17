Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B10D11230A9
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfLQPlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:41:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57668 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727415AbfLQPlG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 10:41:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=j/YCxTas2QVmIEFoY/xiza5qzghZ2y6EtNc7VHyRBnU=; b=jSVX57REB5u79f1bz321z5IexB
        dY/ySVOvdz0iIl+1wqBdSSrYMCeolsOFNBeQHvXir8rBdDjxjzJuMYm0TCv61C2Adyf6tBbY+xZqL
        egTiNJayH3ARM1vdsQ3goGb5YaxEwntqiyCHRvKEWcFFy942B8bTuKD2Yk75hAqlfuvs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ihEy6-0002fa-3h; Tue, 17 Dec 2019 16:41:02 +0100
Date:   Tue, 17 Dec 2019 16:41:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 03/11] net: phy: add
 genphy_check_and_restart_aneg()
Message-ID: <20191217154102.GK17965@lunn.ch>
References: <20191217133827.GQ25745@shell.armlinux.org.uk>
 <E1ihD4B-0001yY-7I@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ihD4B-0001yY-7I@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 01:39:11PM +0000, Russell King wrote:
> Add a helper for restarting autonegotiation(), similar to the clause 45
> variant.  Use it in __genphy_config_aneg()
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
