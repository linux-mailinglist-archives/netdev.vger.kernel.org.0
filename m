Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E976169CF0D
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 15:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbjBTOKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 09:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbjBTOK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 09:10:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB17199D7;
        Mon, 20 Feb 2023 06:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5KekfB1r6Lgv60iMHcFPZLzkIcHp2z5QZ0eHnD+cMB4=; b=AR8zWq822tGLzNxV1mpjSKD1mt
        1OpF3uKnAaCTrOHkRhqryp94VUwqCVzpndrrPX5iPIm2jTSesvovX8BSka8KJtv5ZFhva1UjhcpS6
        BWlj1xEu7oUwNez7WLnYECcp0cy7zPJMD02q4/JJyfcKXOVTL5fFdBq4zazPSuLN/BDFmbCEPLRx/
        DaQv36hkJvDcDiMubKHViME5busR0j0z/99+jE91pG5oQrIWPTSlbfK8DkN0NEgjlbwhSj+cmI2QF
        WXKx9Y9l4taAggbEe+/0M8u8BQ4sZ/EIO4uRzdHCP+/VmAVBLkpxxE8gDLJ5FM8e8w3JGui770Dme
        YBwZ4uhA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53696)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pU6rT-0004Zz-Sh; Mon, 20 Feb 2023 14:09:47 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pU6rR-0001H4-KY; Mon, 20 Feb 2023 14:09:45 +0000
Date:   Mon, 20 Feb 2023 14:09:45 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/4] net: phy: c45: use "supported_eee"
 instead of supported for access validation
Message-ID: <Y/N/Kb5qm6ZBFhGo@shell.armlinux.org.uk>
References: <20230220135605.1136137-1-o.rempel@pengutronix.de>
 <20230220135605.1136137-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220135605.1136137-2-o.rempel@pengutronix.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 02:56:02PM +0100, Oleksij Rempel wrote:
> Make use we use proper variable to validate access to potentially not
> supported registers. Otherwise we will get false read/write errors.
> 
> Fixes: 022c3f87f88e ("net: phy: add genphy_c45_ethtool_get/set_eee() support")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Looks good to me.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
