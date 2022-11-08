Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D81662166F
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 15:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbiKHO1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 09:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234468AbiKHO0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 09:26:53 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CC413E17
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 06:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ArmMfOIutKKcl5jKiRSJz49aXQQeoZr7AC8RYPMfBz8=; b=1z4+gEJp4m1jppYyKUvGAF+TjK
        hRnA4kJPbDtsHug6JoEYLzbzd5poK7uplTPmiwnCMVoEovpL4BfTanCKRlBRi9HXZNsYiDRj1u+Gj
        mEDxBtbb1/Ps6yUSWf98bTWyt6Gn0tlS9YYkCBwwlUusoKnKxz5+ofSkCdjxsFEpkGykCQPgiFz+C
        2hc3t3M/KeSFeEfBnKawhzNj9DbQxIVPkHgfh9W8kJo1dF7D1GhvbVtJcDVjPs6ASW/OI9dwH9lPL
        Ix96NRotgCW02QZQJLVSwV4h/zWgY/cBUNsHBM3LerzAvrcry1XdgjF6zuKW0Mz3+887YKix7Siq0
        +cUlJeDw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35170)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1osPXf-0003K1-Jx; Tue, 08 Nov 2022 14:25:31 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1osPXb-0004on-VA; Tue, 08 Nov 2022 14:25:27 +0000
Date:   Tue, 8 Nov 2022 14:25:27 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 0/2] Clean up pcs-xpcs accessors
Message-ID: <Y2pm13+SDg6N/IVx@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series cleans up the pcs-xpcs code to use mdiodev accessors for
read/write just like xpcs_modify_changed() does. In order to do this,
we need to introduce the mdiodev clause 45 accessors.

 drivers/net/pcs/pcs-xpcs.c | 10 ++--------
 include/linux/mdio.h       | 13 +++++++++++++
 2 files changed, 15 insertions(+), 8 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
