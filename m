Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D6A452E8D
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 10:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbhKPKBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 05:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbhKPKBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 05:01:32 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2266C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 01:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=opLkSiXoCWSiwLXz5uH12xUbNW419W6RWKkwC6RbBLU=; b=Oc5pDgKs9brmmItRIjTxxinemd
        8G6pFYxJS/YPx5utejUTYb/gHR1Dn3LHixxFH5BW6HLvvYjiHx1/lvQ293yIpCOyARRotUZJKyWVD
        ZL4qupSWPPcQDxkGKQHKQsMxUEWfppoazHcYJktpA3ZASutG7/bgXUKdO4PaE0fAG5ubOvNLgQuGA
        aZF6atFh4LVYjVG0Fyl4Pok4C1bDQByTwbwWFi6lDt50BdqeX+PiJRMNc/n53jBu7ddfPD+tbwdOA
        UfwKqM6xPx/BHfCEpXyVhoh6U7qYgnMcVYpsVShAardo2NLrcsMXx+KR6Xrv5KM4VIcWU/jx8S5VA
        Tw8YoD4A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55650)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mmvEV-0000JA-21; Tue, 16 Nov 2021 09:58:31 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mmvET-0001uE-Sm; Tue, 16 Nov 2021 09:58:29 +0000
Date:   Tue, 16 Nov 2021 09:58:29 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/3] net: enetc: phylink validate implementation
 updates
Message-ID: <YZOAxY8PjO38j+j6@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series converts enetc to fill in the supported_interfaces member
of phylink_config, cleans up the validate() implementation, and then
converts to phylink_generic_validate().

 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 53 ++++++-------------------
 1 file changed, 13 insertions(+), 40 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
