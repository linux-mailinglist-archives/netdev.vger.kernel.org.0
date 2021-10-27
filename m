Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2842043C619
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241113AbhJ0JIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 05:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241169AbhJ0JId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 05:08:33 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794AAC0613B9;
        Wed, 27 Oct 2021 02:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kRf1Or618GeeWJVpuy0WSn6vEisI4WInWtok/e/T7zU=; b=hOOKi3W+UKXuH3EKrOxoV/8Pzn
        vQNYH4wXJD00ONUkPZyjHYJ2pqAf4AUGCncM+d9RXWetYAMTU0Ii79n3VAwHs6TqsjSSu1nPXwXIY
        vgW1S0eUsqrzJu85uGWOhjcIcM+EpT5XiVvAyQKw8eSMn5JxvHS+sLC0UpvdDdMZepYm+oZdxYpC/
        BLWMoEJ4XCUqc+vYBahHRPfbgZoQsSy2fmL1M0qkYGv9eTLbP/HwNQ4J3DefJ6In0angA47PAiXrt
        QELUu56VvNOM6ia/BqAuK4SotZ1BtaOeFJikpwPyIGuc2fIdF6/U4VhPL2bB9w5z6KN6OtyPNmmkN
        1brVH6Gw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55334)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mfesl-0006DM-CK; Wed, 27 Oct 2021 10:06:03 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mfesk-0007bZ-6c; Wed, 27 Oct 2021 10:06:02 +0100
Date:   Wed, 27 Oct 2021 10:06:02 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, lgirdwood@gmail.com, broonie@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: Fix unsigned comparison with less than zero
Message-ID: <YXkWepmP9rC3fQfj@shell.armlinux.org.uk>
References: <1635325191-101815-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1635325191-101815-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 04:59:51PM +0800, Jiapeng Chong wrote:
> Fix the following coccicheck warning:
> 
> ./drivers/net/phy/at803x.c:493:5-10: WARNING: Unsigned expression
> compared with zero: value < 0.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Fixes: ea13c9ee855c ("drivers: net: phy: at803x: separate wol specific code to wol standard apis")
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
