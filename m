Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965093D0D98
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 13:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240427AbhGUKqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 06:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238895AbhGUJpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 05:45:31 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7135AC061574
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 03:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nUrJEJnMnjUs6xKxJwcVqsx5TqG3GEn7Xt+3HnkMl+w=; b=CQ8Q2Ll8n9de1rJl/dkkSlx4s
        QYp1n0WSULOPiGCk3HnjqnosclPCanRkHwxiB5UZaSVkrPl59bMQ5IoKvMo3pBH/PLacQDdUpVJf0
        lRWAkJ16dRDjZDL8jstImFLRO0YjKz1kUlknyT1gsdM5PnMQR6Qs0vqZaWVxFFl0dURCw4oiqA4+L
        TeUnL2sGqLqAcmU9RrH45XA4igLVNbjooliQM7H4UDE+gscvKc+kpG/63AXTf+7sP4Q53uyKphgz1
        ank/i0LCD3rYlvHEZMmYnZ6410eX2F1C1ilVdcip9GNCrHusJvy7nP2dccXLBhshbJ9Zbw+vS0DfM
        006xuxiQQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46410)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m69QP-0007Ue-Aw; Wed, 21 Jul 2021 11:26:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m69QO-00089c-18; Wed, 21 Jul 2021 11:26:00 +0100
Date:   Wed, 21 Jul 2021 11:25:59 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: at803x: simplify custom phy id
 matching
Message-ID: <20210721102559.GZ22278@shell.armlinux.org.uk>
References: <E1m5psb-0003qh-VP@rmk-PC.armlinux.org.uk>
 <20210721102239.saflmexhqhqtibxt@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210721102239.saflmexhqhqtibxt@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 12:22:39PM +0200, Marc Kleine-Budde wrote:
> Seems you've missed a conversion:
> 
> | net/phy/at803x.c: In function ‘at803x_get_features’:                     
> | net/phy/at803x.c:706:7: error: implicit declaration of function ‘at803x_match_phy_id’ [-Werror=implicit-function-declaration]                                                                            
> |   706 |  if (!at803x_match_phy_id(phydev, ATH8031_PHY_ID))
> |       |       ^~~~~~~~~~~~~~~~~~~

Sorry, yes, sadly.

net-next very quickly picked this patch despite it being the first
visibility on the mailing lists. Vladimir quickly noticed this and
sent a patch that we're waiting to be picked up.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
