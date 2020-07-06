Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B3B216066
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgGFUjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFUjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:39:32 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CF5C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 13:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LrP6uVFWNvqJO4cMKDNaDc7ym9efKZTO2nluyOaPrnM=; b=JgBAU0JIeU+v48RQ7K2K8qZQq
        ecyzYAkf+6+jCY8jV+8BCVeUbtbUAd22j2Rxou2mT9NxINBurfWzBv6eF73FryjDHjEGCIyVndpP/
        oWVvs7HuMrYaYIbaB4n9BlRXFakrHboihwDPpio+cFMDXh0Z9dp2nVAlw1qzLH892POwElnRKeiZF
        u4iBg+hW4dSyamnaBWh+C5TnsxlV88g2r+IdgvFf4JLMAnZ3Gag+GdslXqVTNPSEc1wT8l7YXVixb
        5S/0bT7PdvgvnmRIEi2KzOWCiVIWcfyiybRNjBR9oO78JE9Uxn6v8W6o4OSRjpAAPWxeNeb6UDHNp
        hsxeULRlg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36168)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jsXte-0006OO-0O; Mon, 06 Jul 2020 21:39:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jsXtc-0006Dx-TF; Mon, 06 Jul 2020 21:39:24 +0100
Date:   Mon, 6 Jul 2020 21:39:24 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     olteanv@gmail.com, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com
Subject: Re: [PATCH v2 net-next 0/6] PHYLINK integration improvements for
 Felix DSA driver
Message-ID: <20200706203924.GV1551@shell.armlinux.org.uk>
References: <20200704124507.3336497-1-olteanv@gmail.com>
 <20200705.152620.1918268774429284685.davem@davemloft.net>
 <20200706084503.GU1551@shell.armlinux.org.uk>
 <20200706.125454.557093783656648876.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706.125454.557093783656648876.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 12:54:54PM -0700, David Miller wrote:
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Date: Mon, 6 Jul 2020 09:45:04 +0100
> 
> > v3 was posted yesterday...
> 
> My tree is immutable, so you know what that means :-)

I was wondering whether there was a reason why you merged v2 when v3 had
already been posted.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
