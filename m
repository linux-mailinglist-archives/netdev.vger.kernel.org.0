Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B441942CB
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 16:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbgCZPPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 11:15:06 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46934 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbgCZPPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 11:15:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=v4IaUeg+pKhvBnvQfkCCunvzxm3tcM/XUUe2SYwdsos=; b=nX9M5QjKsSLKgVbo556xKzfFo
        VPaVtRY5W7Diyrqqp0HeRPqzzOqnuXG7IgQoXGMj8xnGNBJ5myGwvgIeTUZaffQXSJm+duWSKiIFq
        wkUJKtQaJ+WiXXmTJIVWbLiqRz4BwwPMV3pkDjKr9yBsrJel+7flQfUq6X+9SNEb4b/5q9bdXS2JB
        Ze/xGM8+GMjJ6ptJ+eJOSZWsGOahpR3CvLjE0nA+5C6cVLSpriXZ1NRLziwfS4WZF6O4AhF4QAoXi
        TlF8jr6qry9JpIFun7DK7pbvAPxtiS4N/b4Yl+9tf08dm6fDxscnGBAH2ziGlA772AvXH4ocz13GM
        WZyRb94cQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:58234)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jHUDj-00045w-AM; Thu, 26 Mar 2020 15:14:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jHUDi-0003K1-Qz; Thu, 26 Mar 2020 15:14:58 +0000
Date:   Thu, 26 Mar 2020 15:14:58 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] split phylink PCS operations and add PCS
 support for dpaa2
Message-ID: <20200326151458.GC25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
