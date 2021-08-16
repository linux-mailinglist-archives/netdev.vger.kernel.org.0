Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1003ED022
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 10:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbhHPISv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 04:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234533AbhHPISu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 04:18:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B4DC061764;
        Mon, 16 Aug 2021 01:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZS4HYRmZ6I9SrpzhkEftm0rTfLPZ1J48SIaJjWklHso=; b=iSZ00zKYqc5OWW3MoKg8D8GKz
        D4OB1mNN2fl5VrrDQkKbi0Iyi9wh3Xpqiw5R0DzH4454izmeBVNipJ3YftWZEsM3KtNO8DyFeboh7
        3O/tPEwZjg8UAI/dwNH8MgAxppO2zvIPL8+NZcDjQfg4/11e2yZklyujYFbVB8dSq5N/b7JFewnTH
        Cu/UXJXN4AMMrcWf41x9VcSKDvAEjNaoUxTIELO7/J/E2g5n1kbhLiO1OFnwn0M4zANq6SNFbqYBp
        LIK8dZo78K37tRX1tomeM6AvB49uMI/7rHQJU6iiEqYahXzZrDBnqPKU87HEtjFc+YuIjp72D2ewu
        Q0V6V2mbg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47358)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mFXoz-0007Wn-O7; Mon, 16 Aug 2021 09:18:13 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mFXoy-0007po-HY; Mon, 16 Aug 2021 09:18:12 +0100
Date:   Mon, 16 Aug 2021 09:18:12 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "Song, Yoong Siang" <yoong.siang.song@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Message-ID: <20210816081812.GH22278@shell.armlinux.org.uk>
References: <20210813084536.182381-1-yoong.siang.song@intel.com>
 <20210814172656.GA22278@shell.armlinux.org.uk>
 <YRgFxzIB3v8wS4tF@lunn.ch>
 <20210814194916.GB22278@shell.armlinux.org.uk>
 <PH0PR11MB4950652B4D07C189508767F1D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
 <YRnmRp92j7Qpir7N@lunn.ch>
 <PH0PR11MB4950F854C789F610ECD88E6ED8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
 <20210816071419.GF22278@shell.armlinux.org.uk>
 <PH0PR11MB495065FCAFD90520684810F7D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB495065FCAFD90520684810F7D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 08:03:59AM +0000, Song, Yoong Siang wrote:
> Thanks for your explanation. I understand your concern better now.
> 
> In the case of WoL hasn't been enabled through a set_wol call, the PHY will
> be suspended, so we no need worry the link change interrupt will create
> an undesired WoL event. 
> 
> In the case of set_wol is called to disable WAKE_PHY event, we can keep
> the link change interrupt enable, so that it won't affect the interrupt
> support.

I think you're missing the point. In your get_wol method for this
PHY:

+       ret = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_INTR_ENABLE);
+       if (ret < 0)
+               return;
+
+       if (ret & MV_PCS_INTR_ENABLE_LSC)
+               wol->wolopts |= WAKE_PHY;

If the link change interrupt is enabled because we want to use
interrupt support, the above code has the effect of reporting to
userspace that WoL is enabled, even when nothing has requested WoL
to be enabled.

This also has the effect of preventing the PHY being suspended (see
phy_suspend()) and in effect means that WoL is enabled, even though
set_wol() was not called.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
