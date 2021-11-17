Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C268E454B83
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 18:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238215AbhKQRF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 12:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbhKQRF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 12:05:28 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24080C061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 09:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0ojhjukEX/Jo7dqtKOX0zqCK2Gxi/grOJtmqvIhgW5c=; b=hq/iC1mdFN7Izht2JbDAKpeShc
        jQJAC1PkfVyMJlUo2yXzaLB3fgV8mV2AhvHqeLBtL3szBioEaV+SJqz5dlAdw2G93sgcrTeEnJWE/
        LR/qMk+MdcYzJ2q1972Mg0Bw7g+TburjP6rrFuAKCNcUXdNL3sceut5G65QdvxsCDeuxMF/6Asbdu
        SxWJtrwf8AV+SV4NbSVMX84A7x3K6NgJCyhkELBnmdo2xdYbJ+UKSyWc9QgTl6T4d93HhPatMhW4N
        4UOAOVxT0fGWw+NJyrcNpZ6E7IPeOG1W/+AvaI8r2GvMvs6EBL78f/zSG25vj0p1vqPY4Zr+zU0aH
        w/WRNrqA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55690)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mnOKH-00028K-8d; Wed, 17 Nov 2021 17:02:26 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mnOKG-00036z-Bp; Wed, 17 Nov 2021 17:02:24 +0000
Date:   Wed, 17 Nov 2021 17:02:24 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] net: dpaa2: phylink validate implementation
 updates
Message-ID: <YZU1oGJuGBpQF+vi@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series converts dpaa2 to fill in the supported_interfaces member
of phylink_config, cleans up the validate() implementation, and then
converts to phylink_generic_validate(). Previous behaviour should be
preserved.

 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 109 ++++++-----------------
 1 file changed, 26 insertions(+), 83 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
