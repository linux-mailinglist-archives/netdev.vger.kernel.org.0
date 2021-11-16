Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A21452E7E
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 10:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbhKPJ6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 04:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbhKPJ6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 04:58:09 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A007C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 01:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cID8dkvpyIxUX6s8xSVgnhowTYkMxu6GYir3/B+mSLI=; b=ytD13suVp56QaJFFYybbDh3MXR
        BG16K5S0r3e+x6ip1hZ7aOwIeJ1YaPj0ctT6w2f4gWniSfCZrTJypyPLjYEpK6SmPaL2ZEiZ2z2DZ
        magbGDpjiwWUikgtxEciyEDSTjAWonNdsObqIGc+FSG9z+agTZGv4ajrzvs+tdJwXN379SXsV7ypz
        SDrpLkiKp/fqLTldAgWAK2DQt0e4oZvOODKSnoy+ZR+Ilvq8YronDX8jN943fW3YaC5ZTBEwccisE
        b5qnFRzxbBkLNelCL5ae3lHW/Jwh/AGnPcSJyPqaVyeToDKTW0xg9LvmTF28xbny9RpSD/lugNz2L
        R5ceqB2Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55648)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mmvB8-0000HZ-F7; Tue, 16 Nov 2021 09:55:02 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mmvB5-0001tx-3F; Tue, 16 Nov 2021 09:54:59 +0000
Date:   Tue, 16 Nov 2021 09:54:59 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/3] net: xilinx: phylink validate implementation
 updates
Message-ID: <YZN/86huhkUGzZuV@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series converts axienet to fill in the supported_interfaces member
of phylink_config, cleans up the validate() implementation, and then
converts to phylink_generic_validate().

 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 71 ++++-------------------
 1 file changed, 11 insertions(+), 60 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
