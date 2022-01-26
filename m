Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04A949C830
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 12:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240405AbiAZLAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 06:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbiAZLAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 06:00:40 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5219CC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 03:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zvM4Cokb7QbDejEXKWGeWrHxZsUZeiHRVU6ghhhYVKY=; b=Ou+FI1IgJYDXizF2UIkKHOXfdG
        ud9IhWw12rjsvqC0xdh1LcNQErc7XRtQQjCK/MdlvfeSHFdUrTA/+XTjjuZDUub3aFMZibJkHWFv4
        WlNnYJlsfmLZEW0PtlXxRhzR6I3h4XMJ7TePP9iiKIJU6GPK/5mL/omXZIIK2n5rVGox90fFyoxvs
        F3iL+8YKG/gx9ejUL4JGCIsGyxo5tzOkpUQp13OXeTdedG61sUabMXaPa9LbUhb5Sq5MFiZAkqtXL
        RUk5nVMwzS3hxzYWSA8jgzX6EdO8YeXSC+FgVBLlVMyXx3GMBM5wgn8/XD0Yv7ZWetxvctWrJZaMZ
        ftTK+Afw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56876)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nCg2W-0003Br-Pm; Wed, 26 Jan 2022 11:00:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nCg2T-0004PF-TN; Wed, 26 Jan 2022 11:00:33 +0000
Date:   Wed, 26 Jan 2022 11:00:33 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, dave@thedillows.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net v2 4/6] ethernet: i825xx: don't write directly to
 netdev->dev_addr
Message-ID: <YfEp0bFb7MKwhmg+@shell.armlinux.org.uk>
References: <20220126003801.1736586-1-kuba@kernel.org>
 <20220126003801.1736586-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126003801.1736586-5-kuba@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 04:37:59PM -0800, Jakub Kicinski wrote:
> netdev->dev_addr is const now.
> 
> Compile tested rpc_defconfig w/ GCC 8.5.
> 
> Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
