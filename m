Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD1D41942C4
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 16:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgCZPON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 11:14:13 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46916 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbgCZPOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 11:14:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=v4IaUeg+pKhvBnvQfkCCunvzxm3tcM/XUUe2SYwdsos=; b=b4WFKfXUPbesKCR2bhUsfPTCG
        HrXDMfNJ2OUyVrkxPgoI87B5ttks7uc5NnBDx64KLGhRj5EyuuSZEK4/MZ0znG4U1r/+nv96cKNZ7
        VtEI7JK/3o6ANH/f06naxbTfu7ge0/Lp0csj6SpK/GT4zRm94czE9hGClai++b/zYprbNj7Wh0ywO
        vG44wuUMNfRKsdcX34AX9ELrO4xE5OEvkbsuXGe2yp1QsWQVbidy/rhC57JqntZqGEo5Jdpqt8IR3
        mK0s9XbBUsOCzVY2rEkPhfQV2uXd2ROUlcP10xn0UupGSPvchG7PTdEH3pk5FvEaBUhUybFBNqZJJ
        bgVxJx7xw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41654)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jHUCs-00045f-0U; Thu, 26 Mar 2020 15:14:06 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jHUCq-0003Jr-CU; Thu, 26 Mar 2020 15:14:04 +0000
Date:   Thu, 26 Mar 2020 15:14:04 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] split phylink PCS operations and add PCS
 support for dpaa2
Message-ID: <20200326151404.GB25745@shell.armlinux.org.uk>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317144944.GP25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series splits the phylink_mac_ops structure so that PCS can be
supported separately with their own PCS operations, separating them
from the MAC layer.  This may need adaption later as more users come
along.

 drivers/net/phy/phylink.c | 102 ++++++++++++++++++++++++++++++----------------
 include/linux/phylink.h   |  11 +++++
 2 files changed, 78 insertions(+), 35 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
