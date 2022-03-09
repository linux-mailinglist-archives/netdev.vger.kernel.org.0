Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2592D4D257A
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 02:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiCIBGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 20:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiCIBF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 20:05:56 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E79D555E;
        Tue,  8 Mar 2022 16:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=L9e08i3DItUQuyDe2VxAmhXOyMvqb9ieclWvN98wlFQ=; b=odNoSo01fjvZjs9AFVZGAoVrEf
        HXN4gT8/e7RFLfP/gLG/DVJGuGd2hVuMrox0/RYoEKyP0oJmax9cE2YwiBg2wC09Td/eyIvNoJxTx
        we7+5oFFwBLi0g05GbYZElSTyW+5ItWg0dLxlQBj3DnFZD+EaYwpVzwDRSJEk+g56xXUJIMHiF9Ks
        JGK1OA/HAYAHuTkHb0ZSI7vfEDwKVyduCDAAiwd84xDgdlAl0HNchPNHBn46RyNehrmJsgSsADRMb
        0vVV0q/4Z4K0kZjEPMW86ksBxjzkufXHgPCQgbEObFJ9BxVik18r37FV/0fI9v8PzcIVvViuJzGji
        CWm1D7fg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57728)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nRjxD-00018V-QB; Wed, 09 Mar 2022 00:13:23 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nRjxB-0007Mi-PF; Wed, 09 Mar 2022 00:13:21 +0000
Date:   Wed, 9 Mar 2022 00:13:21 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] net: phy: correct spelling error of media in
 documentation
Message-ID: <YifxIeVdQzJ3lqEI@shell.armlinux.org.uk>
References: <20220309062544.3073-1-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309062544.3073-1-colin.foster@in-advantage.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 10:25:44PM -0800, Colin Foster wrote:
> The header file incorrectly referenced "median-independant interface"
> instead of media. Correct this typo.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Fixes: 4069a572d423 ("net: phy: Document core PHY structures")

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
