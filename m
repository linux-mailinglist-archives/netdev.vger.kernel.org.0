Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52616177962
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 15:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbgCCOnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 09:43:12 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36640 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729372AbgCCOnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 09:43:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nFlLXBgdKCf4xX5iZMI6+fwzmRceyPebi9IvZaTpD2M=; b=K/aJ0o79iSilCd5LeZoC7myqr
        6z3ejILapXHDc6KNO0KYkc0acp8/zXTriPAjZ09aJnbt9FTzGjm1FSV6D/GMBy/epW52BVf/4xwe2
        rhhP8KyNHnSjPWmOqBnRExhkwmW0LZKchyEMfoBvukyADnamcwZNY4dWqs6EvejIeM0V7HzCCaPzz
        tmYADANzbBiKYA+Lbh0sxvpCVHM9v7WDhbdG1OhDWjNpaIlDgPbc3AD9LEI/e87mo/Bx/7z0kMLOM
        bbLDS1tgozpgg8vJaF8OxXLEzlfiGIobgOEc/1wHaVpoCA1MBq3sr/CpTkIoPR07kv+OKESV9Ilrj
        Se5UHGZEg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:48200)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j98lB-00006D-3s; Tue, 03 Mar 2020 14:43:01 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j98l9-0005ya-FK; Tue, 03 Mar 2020 14:42:59 +0000
Date:   Tue, 3 Mar 2020 14:42:59 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/3] marvell10g tunable and power saving support
Message-ID: <20200303144259.GM25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch series adds support for:
- mdix configuration (auto, mdi, mdix)
- energy detect power down (edpd)
- placing in edpd mode at probe

for both the 88x3310 and 88x2110 PHYs.

Antione, could you test this for the 88x2110 PHY please?

 drivers/net/phy/marvell10g.c | 181 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 173 insertions(+), 8 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
