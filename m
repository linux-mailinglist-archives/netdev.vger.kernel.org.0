Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45774549E0
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 16:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236104AbhKQPaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 10:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbhKQPaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 10:30:18 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5F2C061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 07:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NRMV0mXfKzywmoFTIim7Jx0fVNkZmd3iStVi+YWd7Vk=; b=fjbEao7TyLAotQGKlsTPCdFzZq
        uH+HfNKns8ntBFxUlh8lwIPV7iMmm367Hqcy++3byAboVkJvCk1qFQYAUbPRrz0VQU6XpY0xEcyEj
        i3YIcFdP12+b2nIZfdZ7hN6RIA1fPP87NR3TMCNwJZch/OuiRVkpbZTPxYfaTwjAWjRjy5O590hX2
        6HbfKozmLb/wca3U4o6HazoTNDU0in8ok9lJSiXvGg/Gc5inNZSE8OHjfpxW7pXAUbvJRJNjqD043
        aVqiAw67GMjdetjCQ8zMehnwOSTnF53N1gQoMlK8Hr5J/L8RxJtzPdbgZR6wR52x2EyAAApL/Jy9E
        nINGAAJg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55684)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mnMqD-0001yc-59; Wed, 17 Nov 2021 15:27:17 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mnMqB-000330-Js; Wed, 17 Nov 2021 15:27:15 +0000
Date:   Wed, 17 Nov 2021 15:27:15 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Chris Snook <chris.snook@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Cc:     netdev@vger.kernel.org
Subject: [PATCH RFC net-next 0/3] Atheros AG71xx phylink updates
Message-ID: <YZUfU8fot1puQoRj@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm sending this series as a RFC, not expecting it to be applied, as
there is a question over patch 3 that needs addressing. I've already
emailed Oleksij Rempel about this a couple of days ago, so I'm hoping
we can resolve this soon.

 drivers/net/ethernet/atheros/ag71xx.c | 81 +++++++++++++----------------------
 1 file changed, 29 insertions(+), 52 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
