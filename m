Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080076C7B35
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbjCXJXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbjCXJXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:23:22 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C75A126DF
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 02:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Prgo4NDdx4nlCOa+QUywNeT7cuz4uqB8izK1lycHlLg=; b=ToOyduwh6SOLulAkRFKR3/rv8b
        iGO5bDwDdP/5LfmYY/1Uttpr3ZxEX45uW8r9KP9djD9o8fvUPeBqadvii7kKSvGqczqqggSFXuOc9
        KpDv6ZHrb3/1Ao6MGD2qvSP81Tjnq9dNIOZEQYhsDWA41oYQJ24sGwJEsEnliHqYU9JvcpBS0aACT
        kjP4+xbG8mWopRTcuY6XEU5qhGGxLiytNxZkh2NHjiVxQBivp+3p7NM3rnxx9NjAVFccIcbrC/lY2
        uyWry3ZGyTpWxBIE1RiPYUaDSUzL5iTM+3s4u1JxakyqENkMy+ENDyUsGzPnLWDDmzh/78wQmOyfJ
        Jk8d39kQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46822)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pfddm-0006jR-If; Fri, 24 Mar 2023 09:23:18 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pfddl-0002Jw-Sz; Fri, 24 Mar 2023 09:23:17 +0000
Date:   Fri, 24 Mar 2023 09:23:17 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH RESEND net-next 0/3] Constify a few sfp/phy fwnodes
Message-ID: <ZB1sBYQnqWbGoasq@shell.armlinux.org.uk>
References: <ZB1rNMAJ9oLr8myx@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZB1rNMAJ9oLr8myx@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series constifies a bunch of fwnode_handle pointers that are only
used to refer to but not modify the contents of the fwnode structures.

 drivers/net/phy/phy_device.c | 2 +-
 drivers/net/phy/sfp-bus.c    | 6 +++---
 include/linux/phy.h          | 2 +-
 include/linux/sfp.h          | 5 +++--
 4 files changed, 8 insertions(+), 7 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
