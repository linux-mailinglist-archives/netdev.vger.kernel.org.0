Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510A6391FD7
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 20:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbhEZTA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 15:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235031AbhEZTAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 15:00:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CCFC06175F;
        Wed, 26 May 2021 11:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+E69/ugbWA4Z9Cbs8FiLIYx5jXAcnWErNGupCfKxWVI=; b=c7ba9s2YMLVN24xm9Paybruat
        skzFz58k489c9zRzfH3xA9hFSr1+Uv9/vjgwwJo85MrRRLczuLT9Z2CPuDIdOC5SwWx0hXXL/yq1y
        Dgj740Pbmi5CtEN0zbVIs+bC4sXakzxB5cR7gPpc4sAK6oyMZJZ9RZyuRQVXM+e/KVT/cJDR+xWuX
        Wwws70xs+7GW8NgREM7mQR0Ns+4Npz+03/HKGwN8EF8Jv0xxkSvYtDmqr7okMeswTyj1oDPxxt/4F
        WH+HUI1TYoaRneEMg2fVlxfOks6bmb2C5m2FFGv5Wjb7QaBgaDYZMT4NAdoMAWBPOUWhBMHK5184i
        RiIsVgAlQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44392)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1llykQ-00068c-V6; Wed, 26 May 2021 19:59:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1llykQ-00033d-IC; Wed, 26 May 2021 19:59:18 +0100
Date:   Wed, 26 May 2021 19:59:18 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: phy: Document phydev::dev_flags bits allocation
Message-ID: <20210526185918.GL30436@shell.armlinux.org.uk>
References: <20210526184617.3105012-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526184617.3105012-1-f.fainelli@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 11:46:17AM -0700, Florian Fainelli wrote:
> Document the phydev::dev_flags bit allocation to allow bits 15:0 to
> define PHY driver specific behavior, bits 23:16 to be reserved for now,
> and bits 31:24 to hold generic PHY driver flags.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Yay!

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
