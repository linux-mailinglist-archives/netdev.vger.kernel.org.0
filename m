Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F89A2F08E8
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 18:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbhAJRzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 12:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbhAJRzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 12:55:46 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC428C061786;
        Sun, 10 Jan 2021 09:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tpKVS0EhYiFmJcF9wK3IHeZQn6yJspAVmUyNEvFs4T0=; b=VMUjiqXvaxlvSpZ+tcJQSLxhs
        tQNhcgWlOXRWvOdy4JVH3XwtLsB8TTCjZqNdb2cj36r4xmJOq/I+Dfok8LD0Df1dYER+s3KPtgPV9
        lY1nN0XH0qaEs+FYI69raWB15FsFW6QDHX+ieDL0HDv2CZssaU6VZCWjaqXwPCAdihCLTRr3srPJ4
        Qon0d/MJKKm95e8v+ce05dLr8u4J4D1wcni8z5lH1/fRvuv21km3DVCdvI5nfG+uP9xnnTle71zGw
        QOJ+W4u+JLwf2tYBzelbIwlqt5hKhqh2UkNI4Upc2J6EI/7dKOsTT+yrxXeeCYwANQJAfhN1Lm9fF
        QZnhyOHxQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46238)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kyevf-00063j-4p; Sun, 10 Jan 2021 17:55:03 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kyevc-0004Oa-Ji; Sun, 10 Jan 2021 17:55:00 +0000
Date:   Sun, 10 Jan 2021 17:55:00 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org
Subject: Re: [PATCH RFC net-next  03/19] net: mvpp2: add CM3 SRAM memory map
Message-ID: <20210110175500.GG1551@shell.armlinux.org.uk>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-4-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610292623-15564-4-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 05:30:07PM +0200, stefanc@marvell.com wrote:
> +	} else {
> +		priv->sram_pool = of_gen_pool_get(dn, "cm3-mem", 0);
> +		if (!priv->sram_pool) {
> +			dev_warn(&pdev->dev, "DT is too old, TX FC disabled\n");

I don't see anything in this patch that disables TX flow control, which
means this warning message is misleading.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
