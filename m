Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2873484622
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 17:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235468AbiADQpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 11:45:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51228 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233988AbiADQpB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 11:45:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xoeJJJ9v1xTYr+fC/0dr8CSd+1tM5gXPzFoXJwgnNVc=; b=U03xk05oMBTCekV6R2y2cwi+Mw
        QXnkpC2FdjLwRwfS4dyYocYF+/MXDMs4vfbx5VjvhA1wvZvXSSjSFTkrbYjN4PFMWb9GxqC+7p7DS
        5ZNbD2v3ZX/poWDHxOWmbOdJyNjsrRuatw8LZZ6CVqNG+lFrCZluogpMhE8Jq52LQZJE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n4mvf-000U8g-Iv; Tue, 04 Jan 2022 17:44:55 +0100
Date:   Tue, 4 Jan 2022 17:44:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: phy: marvell: use phy_write_paged() to
 set MSCR
Message-ID: <YdR5h6yzZTXT5LhF@lunn.ch>
References: <YdR3wYFkm4eJApwb@shell.armlinux.org.uk>
 <E1n4mpB-002PKE-UM@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1n4mpB-002PKE-UM@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 04:38:13PM +0000, Russell King (Oracle) wrote:
> Use phy_write_paged() in m88e1118_config_init() to set the MSCR value.
> We leave the other paged write for the LEDs in case the DT register
> parsing is relying on this page.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
