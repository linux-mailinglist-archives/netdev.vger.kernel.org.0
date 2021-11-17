Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82327454B47
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 17:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239209AbhKQQtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 11:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237526AbhKQQtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 11:49:04 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDA1C061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 08:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=n/09/bk0w0vn+rITIaZswahgXXCjGqefUEeVZWjEITw=; b=HE9tifBF7NccHCkA5iVtVtCl65
        /v7bUTo007YVh7e5ANpqcfR3EdP6vb5FLkdlz+L6GlIesdcHNIMdCB6OfZ47Wlc8DC/Epw4mlD4yd
        5mnEptt51OjMFioKSzObPfzOfq7aCHDcbx4YjPA0tTvfm9MmvTKQ+/uwQedmZEaaI43wICfZOJ9Qd
        Y7ONXp5fR2kcTiCLlS/itXWRCOifqEy4/mZrK5t6lRJJEUhA8jZd75SkKmRIeQzwWYqgvkoqGnTnf
        +ws35cHegeTsCjAUhX4ElCMcs5E8krKR8y5ZQUxSznOj284YFBKzVe46D7i7OtmeqPnl8v478XUfi
        sHNp5jZA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55688)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mnO4N-00027I-EJ; Wed, 17 Nov 2021 16:45:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mnO4L-00036j-5f; Wed, 17 Nov 2021 16:45:57 +0000
Date:   Wed, 17 Nov 2021 16:45:57 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Chris Snook <chris.snook@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/3] net: ag71xx: phylink validate implementation
 updates
Message-ID: <YZUxxU30M4IgNNPi@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series converts ag71xx to fill in the supported_interfaces member
of phylink_config, cleans up the validate() implementation, and then
converts to phylink_generic_validate().

The question over the port linkmode restriction has been answered by
Oleksij - there is no reason for this restriction, so we can go the
whole hog with this conversion. Thanks!

 drivers/net/ethernet/atheros/ag71xx.c | 96 +++++++++++------------------------
 1 file changed, 29 insertions(+), 67 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
