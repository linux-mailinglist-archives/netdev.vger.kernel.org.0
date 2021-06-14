Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E863A671E
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbhFNMxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbhFNMxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 08:53:24 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5153DC06124A
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 05:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jJHQnMopesoro5jl8icgxY4BHRWOXCYDaKDIK4qKZWQ=; b=F+UEFZTuZdRqqBSDxliDelUsR
        98NcW2Ep21/cqHAb81I/flRKSWur07N17YvIR+fg65jy+x0UWU6QuI0NrOvnhRWo0+zIHEZN9Kh+R
        z361JmQQ9PhLlTbFJUhuI4wAXH2E8nH3iejUON+hYrQ0DtUk9yXZ1q7vEbzqv16Kpb0IvdeYOFs/z
        KdZYY284pFl3hnI8qyJwZebK8ULVFRf1v2mW9I5Lmxve61uZjonIG/dKTn08w1cBC82XdYWDvzs6m
        E4H2PTBIXuFifhIHoIxtOrFK933Pvh7c7Fkjd0Ql6bauWrqTh+dNlDioMXKKza3ZQGEvD2SlKO/I0
        5za+O7Kdw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45004)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lsm3Z-0004HO-Az; Mon, 14 Jun 2021 13:51:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lsm3Z-00048Q-1F; Mon, 14 Jun 2021 13:51:09 +0100
Date:   Mon, 14 Jun 2021 13:51:09 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net-next 3/3] net: phy: nxp-c45-tja11xx: enable MDIO
 write access to the master/slave registers
Message-ID: <20210614125108.GT22278@shell.armlinux.org.uk>
References: <20210614123815.443467-1-olteanv@gmail.com>
 <20210614123815.443467-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614123815.443467-4-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 03:38:15PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The SJA1110 switch integrates TJA1103 PHYs, but in SJA1110 switch rev B
> silicon, there is a bug in that the registers for selecting the 100base-T1
> autoneg master/slave roles are not writable.
> 
> To enable write access to the master/slave registers, these additional
> PHY writes are necessary during initialization.
> 
> The issue has been corrected in later SJA1110 silicon versions and is
> not present in the standalone PHY variants, but applying the workaround
> unconditionally in the driver should not do any harm.
> 
> Suggested-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
