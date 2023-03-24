Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB04D6C7B04
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbjCXJT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbjCXJT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:19:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814C95B90
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 02:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Prgo4NDdx4nlCOa+QUywNeT7cuz4uqB8izK1lycHlLg=; b=r954ZMTaP8I10AQrHuYSte/dod
        NeFQhKuI+aUfAs4NikfiYNaNSTzWLYBMKvz9/eUkU0umYfeewjsQq9H83Nh+homWu6NvDNu2r08nc
        KBDX5NZs1R3RGmhyDWW2nKXipO4TVdNU72uaCOHKAwJL16ciYKyccbrXA/wHKIOKyKA89mRbzm6Fr
        pEYvatwOHZ4kWbnXxkcmT+ZDobJh2n9373lixWsDa9xEOkNwIGhEc4ztXebjiABW1kc6THm9C/bkw
        GNzwfhfLKmlH71OyshD4VFxwabnmn9gUIZZimbufkssplcnqXcyv/2N8TO/tSrQq99xubku8AAPFU
        XcOazb6g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42548)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pfdaQ-0006hG-D3; Fri, 24 Mar 2023 09:19:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pfdaO-0002Jg-1c; Fri, 24 Mar 2023 09:19:48 +0000
Date:   Fri, 24 Mar 2023 09:19:48 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 0/3] Constify a few sfp/phy fwnodes
Message-ID: <ZB1rNMAJ9oLr8myx@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
