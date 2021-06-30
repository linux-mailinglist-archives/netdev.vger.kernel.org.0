Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEB83B87EC
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 19:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbhF3Rta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 13:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbhF3Rt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 13:49:29 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC9DC061756
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 10:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BSJ/oyylNx47q9V+deg7W0bgds85kFWFfUbc1NnYqBw=; b=hMErke2tA1Mw9HVr5XqCZ6HpD
        CXDCV4xiH6h05tSGAWp5zeGOUXLa8clk4XXQbopMFKDvOeuSbTBOQ10N6o5EjyWueupbuk9KNc+Hp
        eQeBkqjA6TGhM/mnzEwNtaA1G34hxzGCF/mzOc9FZzIwuujK0kCQC78ojiOUMF8zjA0Pi8Frt+f9V
        5IxxCTa2ROGTPqKTtWx3hoslQpspAT8BgdFOSDYwloIQZZNSPGS37c0PTeFu5yHANH+Hy00Bk/kCl
        Yg0+io9xflcw5UD5qWIU9V13qLxq/FgY0JZ6YDBXunqBPr7QxejIUB6Ps8UORG3mFWTq7Fl++r9qX
        qSTiRSK3g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45548)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lyeIY-0000LA-8i; Wed, 30 Jun 2021 18:46:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lyeIV-0003J5-Cz; Wed, 30 Jun 2021 18:46:51 +0100
Date:   Wed, 30 Jun 2021 18:46:51 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: axienet: Allow phytool access to PCS/PMA
 PHY
Message-ID: <20210630174651.GF22278@shell.armlinux.org.uk>
References: <20210630174022.1016525-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630174022.1016525-1-robert.hancock@calian.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 11:40:22AM -0600, Robert Hancock wrote:
> Allow phytool ioctl access to read/write registers in the internal
> PCS/PMA PHY if it is enabled.

I wonder if this is something that should happen in phylink?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
