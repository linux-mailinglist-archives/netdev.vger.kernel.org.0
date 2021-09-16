Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CCE40EAAB
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 21:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbhIPTL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 15:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230515AbhIPTLZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 15:11:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D86C610D1;
        Thu, 16 Sep 2021 19:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631819404;
        bh=PruhD/CiX3pVkKMiYMDhzk1eXMTzNFcXO6jJzChzOq4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HeCTJVPbknudWhgxD/PgXaahVdhB4H+SdBJLdpDjiSfPcBqQj8L760vQkwj+S+bDd
         9iXViQ62hagzweBYQ7J2Dl7ljHWQooFCjk20ch6OrEGfsGRtO/4sp/boxWmdNgeJMv
         /M5BzLXcFUYmGe5r9okmF8cgCrVW57UiDK4CrNHIwb8+PAfR1W58u5w0j2C9t0g5QW
         S/+mih6Ev6V6duEC6HA9igEphYDPyRqDXWSNmqv8B+yiZK0YBPeHWWiiQaHX8aGl/6
         mwJyfhBswhF7FPjQIxE77vKzJU0fTztxHsLmEDgPJEm7Wuii+rZhBmqTyLCQ1NROU1
         ZwHqHPNKI8Q0A==
Date:   Thu, 16 Sep 2021 12:10:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS), linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH net-next] net: phy: broadcom: Enable 10BaseT DAC early
 wake
Message-ID: <20210916121003.40327b5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210916000904.193343-1-f.fainelli@gmail.com>
References: <20210916000904.193343-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Sep 2021 17:09:03 -0700 Florian Fainelli wrote:
> +	if (phydev->state != PHY_RUNNING)
> +	       return;

checkpatch strikes again, sorry:

WARNING: suspect code indent for conditional statements (8, 15)
#35: FILE: drivers/net/phy/broadcom.c:711:
+	if (phydev->state != PHY_RUNNING)
+	       return;

WARNING: Statements should start on a tabstop
#36: FILE: drivers/net/phy/broadcom.c:712:
+	       return;
