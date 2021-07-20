Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7873CFBE3
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239337AbhGTNhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:37:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36334 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239462AbhGTNfj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:35:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=v4MPC0DvtNC+wtUXaDxtf8nxqjh/xOxbZW7lBIsCrBs=; b=rjbOl2SAsBaTFIUESi/wVGbF44
        F6cipStmD1r0h+KtHP3o6hH2hcsqsDF/AyP9Z4Lr7tifzOEhvnmKgsI8Hr0wUDuB+x6BnRCLvYulk
        qIOPRmnKyy/5+646R71uRmC1dd9VNXQJ1rP2C8TS9cPOHJvDsG68l3qsrCKIvVhxMmEA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m5qXf-00E40U-QX; Tue, 20 Jul 2021 16:16:15 +0200
Date:   Tue, 20 Jul 2021 16:16:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: at803x: simplify custom phy id
 matching
Message-ID: <YPbar746WVjp9emp@lunn.ch>
References: <E1m5psb-0003qh-VP@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1m5psb-0003qh-VP@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 02:33:49PM +0100, Russell King wrote:
> The at803x driver contains a function, at803x_match_phy_id(), which
> tests whether the PHY ID matches the value passed, comparing phy_id
> with phydev->phy_id and testing all bits that in the driver's mask.
> 
> This is the same test that is used to match the driver, with phy_id
> replaced with the driver specified ID, phydev->drv->phy_id.
> 
> Hence, we already know the value of the bits being tested if we look
> at phydev->drv->phy_id directly, and we do not require a complicated
> test to check them. Test directly against phydev->drv->phy_id instead.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
