Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37F8627AF5
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 11:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236103AbiKNKti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 05:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236011AbiKNKtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 05:49:31 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0431005F
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 02:49:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pfLctTdNAAYAZg7Oxc8WkCK4f3W8hJfapittaMkMOPg=; b=hvoopgxhQVL7lnHeWmMppewOfG
        EUZi8mkVI2ULFT+u7qtPGHm/zTPHfGvoFmEmXSm0WgjfW9uYVbpKFseP+vmdySyat6eRmbsvFMH6R
        k3rHnzypwN+8PZWAd5rP2ovP7TV9ZctWEZza3Qv5gxhp6JHAe9BM218kObL2eRNCxxsTb375kOP4z
        9BoYuN6psDYCSs6rg56LCnHiL5RM8hWYcRyEvrqhdMMPA8KYrw3qq9b/mzI6ltsHtiSLCyltJaWgP
        G8W5PXpvnVtAtOsY54NlIK8oeGRy3PwWdiUXXnv28lwUUNNmc017NzJdfUtRWexI1YP8fLju8iAGO
        f4ILDs/w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35254)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ouX1e-0000dz-QZ; Mon, 14 Nov 2022 10:49:15 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ouX1a-0003kY-Uw; Mon, 14 Nov 2022 10:49:10 +0000
Date:   Mon, 14 Nov 2022 10:49:10 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Liu Jian <liujian56@huawei.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@rempel-privat.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: ag71xx: call phylink_disconnect_phy if
 ag71xx_hw_enable() fail in ag71xx_open()
Message-ID: <Y3IdJjCYb/L+ph9D@shell.armlinux.org.uk>
References: <20221114095549.40342-1-liujian56@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114095549.40342-1-liujian56@huawei.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 05:55:49PM +0800, Liu Jian wrote:
> If ag71xx_hw_enable() fails, call phylink_disconnect_phy() to clean up.
> And if phylink_of_phy_connect() fails, nothing needs to be done.
> Compile tested only.
> 
> Fixes: 892e09153fa3 ("net: ag71xx: port to phylink")
> Signed-off-by: Liu Jian <liujian56@huawei.com>

LGTM.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
