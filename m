Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C625B452EA8
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 11:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233697AbhKPKJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 05:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233671AbhKPKJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 05:09:33 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E8FC061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 02:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=v4EyiamS3qEDk/bFSW7Mh8VEL5uiE8CqhMTbRBvandw=; b=DCE3MBVNXDN2bbtu+KNiKwPC6+
        j7wg1tXrVwTRno05bIbEVjz2zXeMcZPVJw84746Qsjw6u+AsSeAmrTfr+3XTx3Y3k4rnwK1+JPGSV
        ZlGfxh/CUTtSI1mORZdI8Q8C49gc5cI7PyVieANZS1K2ePy3kO7sQF5PqLyX5TgtQqr9X78T4B+j+
        8eRtkuJMKEAfA0lkC3iLJEflSWJ4D5+ETAMyAR3HyRDW6YCjhZE4wSSwCBcmfMH3AP1b3HY6XIAM7
        ZajkwjXRkGqGb/RSv/NHLKgHhiW2AwuG8/wxU77s52ExrzBl9pcJdhbReX2qawBjggg68gI0aVqyb
        YLsHG+Hg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55654)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mmvMA-0000La-9V; Tue, 16 Nov 2021 10:06:26 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mmvM7-0001uh-1l; Tue, 16 Nov 2021 10:06:23 +0000
Date:   Tue, 16 Nov 2021 10:06:23 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/4] net: mtk_eth_soc: phylink validate
 implementation updates
Message-ID: <YZOCn1vMUAbhq3j0@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series converts mtk_eth_soc to fill in the supported_interfaces
member of phylink_config, cleans up the validate() implementation, and
then converts to phylink_generic_validate().

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 111 ++++++----------------------
 1 file changed, 24 insertions(+), 87 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
