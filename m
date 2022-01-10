Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C5348954B
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 10:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243014AbiAJJfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 04:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242952AbiAJJfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 04:35:45 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AF3C06173F;
        Mon, 10 Jan 2022 01:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2CtmUxcCtEyOdOBPgTgblAoLGc/cFCShnekvqCa4NQU=; b=h0Yt1EimuRnubNI8A1wTQTX++N
        xGXaflDpMJvBhdEn2E+LXRMQLD1VGYTouz4DPNPDuZY+d75ANTgbQM6l2q5ywCZMhfgWlIQgRcFdF
        xaFe5+ohUT67Gn+ngKkson46QTR+m+I74+ZX6BK3os4LNSKWPFuOUtqCaXo1kVI7L3ca0qrdObzY3
        p9YRSHzFbDsPRgKfsahIRbWtFRC3r12larvpUgaP6fSYAc3ynyU8Aoo4KyDXfCCt+qq7+NcZFwAuY
        qiow/BLQbOcHNJfdbTJS+/agq159aq75uSdU3B31e+YauFYZ5RhG7oye0LN43gV3SxgKF6s1gE7vF
        IBU6LmVg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56648)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n6r5S-0003Zf-G9; Mon, 10 Jan 2022 09:35:34 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n6r5P-0004pa-2d; Mon, 10 Jan 2022 09:35:31 +0000
Date:   Mon, 10 Jan 2022 09:35:31 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net 0/1] net: phy: marvell: add Marvell specific PHY
 loopback
Message-ID: <Ydv94whrTNPiqX4p@shell.armlinux.org.uk>
References: <20220110062117.17540-1-mohammad.athari.ismail@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110062117.17540-1-mohammad.athari.ismail@intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 02:21:16PM +0800, Mohammad Athari Bin Ismail wrote:
> This patch to implement Marvell PHY specific loopback callback function.
> Verified working on Marvell 88E1510 at 1Gbps speed only. For 100Mbps and
> 10Mbps, found that the PHY loopback not able to function properly.
> Possible due to limitation in Marvell 88E1510 PHY.

This is valuable information that should be in the commit message for
the patch.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
