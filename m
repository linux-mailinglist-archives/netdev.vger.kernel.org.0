Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15DDE2FBB56
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbhASPho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389232AbhASPgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 10:36:31 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98C3C061757
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 07:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MkCXlNKOYOIE/bbANgzmHTODyDUzNa9kYxLZl2IwdHc=; b=2CCaHJu8Es0vV7mU5n1NtzTa2
        zo9prE3qL43NPEyDvEps1qd2Q8S4hx6bQ3EJSePaZWYCaNYFca3lhZQt/SDfkc4kz2pCwOMCDYVm9
        RKZVZwNOwcJ0q2QHrC/D7RPqm5lx5uYTIna4vEMkvEHFuFnFzgt1BClx5rBMZGqhLzzjxMzPKlI/R
        4Inq3h5rFBWuKXKU/Dkf2nsFgB4eWfylezBQGEAgRBwn6MXgWWuvsxjPJSpfnWqD6ddNV/mRtbh+Y
        E1awiwukNPezN0Dhp0Fdg8NmUto8H/hXPG/ZXh97/TH/JFG2ZnQWE7I2KaL8Yh5AQk3JNiho99YpT
        cmjrI+cXA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50018)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l1t2o-0007c6-FB; Tue, 19 Jan 2021 15:35:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l1t2n-00057l-7n; Tue, 19 Jan 2021 15:35:45 +0000
Date:   Tue, 19 Jan 2021 15:35:45 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/3] dpaa2: add 1000base-X support
Message-ID: <20210119153545.GK1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch series adds 1000base-X support to pcs-lynx and DPAA2,
allowing runtime switching between SGMII and 1000base-X. This is
a pre-requisit for SFP module support on the SolidRun ComExpress 7.

 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 25 ++++++++++++----
 drivers/net/pcs/pcs-lynx.c                       | 36 ++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 5 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
