Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A16B1856E0
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbgCOBa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:30:27 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55780 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbgCOBaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 21:30:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cgR907S9wLAHP6ybLzd4i2gXZ4kedTLH2MInh7JTOsQ=; b=wjvsfnsDs67p4H7GDgi/Q9Djc
        uArBb3vyt5Vrr5f3nHRxLc8Qmih3xzlL24wGgJOY/WpuQ7WG3IsbhyGztAS9UBcAgyO4NFp3iFBWa
        HLnmQkaZ2AEzg/GsNDIYw+3iB534tmfV9SqiK6Q/bfBljQPOsKYaUdbkiD7nMJ284JsfgNtbrtxlr
        Q8dl4IScUCfVshtRw5AHaiOVk70beOjkwko/HHJ1zd6CzpieBXATBbWLjMPyVf5KrJlYrdCi9tK/T
        M6V1/odMwGxQzu1ZUTTWtQov4LWu1iYUYNTLP3Fj7a+5lVSmNRHAXXtKKvkjz8hvU+R1bUZkOi5B0
        DhiH6PPDQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:52860)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jD3jM-000694-25; Sat, 14 Mar 2020 10:09:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jD3jI-0008Dj-NJ; Sat, 14 Mar 2020 10:09:16 +0000
Date:   Sat, 14 Mar 2020 10:09:16 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH REPOST net-next 0/2] net: mii clause 37 helpers
Message-ID: <20200314100916.GE25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a re-post of two patches that are common to two series that
I've sent in recent weeks; I'm re-posting them separately in the hope
that they can be merged.  No changes from either of the previous
postings.

These patches:

1. convert the existing (unused) mii_lpa_to_ethtool_lpa_x() function
   to a linkmode variant.

2. add a helper for clause 37 advertisements, supporting both the
   1000baseX and defacto 2500baseX variants. Note that ethtool does
   not support half duplex for either of these, and we make no effort
   to do so.

 include/linux/mii.h | 57 ++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 18 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
