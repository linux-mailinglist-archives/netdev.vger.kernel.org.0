Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F53452E9A
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 11:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbhKPKE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 05:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbhKPKEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 05:04:52 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0BFC061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 02:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7ujD0FiN4hZA88xrEFHuCwZBcHwVfRxRuXVOEf6KvoI=; b=or+DfpWbbk6rhqgJ5xuHZHQ1/b
        xufYAHIKmCl3Zw1U3HUeAkh5ZDetXqk3bz9gWAp23ZWMOPllAKKKeVl0nw4ndh8rGhN0NRIF+v0dO
        uZPnOxIcsiiN4j4DXc6Antc+HUatf6t7sQdiF3YGWREW3RvBK5rcD3r/UWCzV47W+9IpEKvEsiH50
        AvqNkuUz9YCS9Iojd3RnRG+gqTurboQcFX/ORfxI4HiwLzlr0h7Iy6so0FNEnUZZf2BiQcSb7WQ0F
        0rEvMAH9fmV+1l4wD3MZZw7jOA4tYf+BcmPWmVkB5COOnDO+igmqjwbHXRuSxNf4kAhxn8y34uVzt
        rEo2hHFg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55652)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mmvHd-0000K2-Ky; Tue, 16 Nov 2021 10:01:45 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mmvHc-0001uU-Ou; Tue, 16 Nov 2021 10:01:44 +0000
Date:   Tue, 16 Nov 2021 10:01:44 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 0/3] net: sparx5: phylink validate implementation
 updates
Message-ID: <YZOBiFK8DkYUSRml@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series converts sparx5 to fill in the supported_interfaces member
of phylink_config, cleans up the validate() implementation, and then
converts to phylink_generic_validate().

 .../net/ethernet/microchip/sparx5/sparx5_main.c    | 27 ++++++++
 .../net/ethernet/microchip/sparx5/sparx5_phylink.c | 75 +---------------------
 2 files changed, 28 insertions(+), 74 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
