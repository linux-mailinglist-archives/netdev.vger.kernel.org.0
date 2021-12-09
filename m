Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A3046EB41
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 16:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239649AbhLIPev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 10:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239653AbhLIPeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 10:34:50 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2FEC061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 07:31:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=alBfIVkxb3HaXT6+zn6Qt1eKhIvAbRqBP6R32kDmr7g=; b=lNzn819v+ueV40HKyKUC5iDKQP
        Yaior53eB81yNanCB76nHcgRjQWEbCExNboL7Xx8E3eCmBxt0wfttNF7pECZ+s+UnoduKzuyA4D9x
        wiZAC0BdnwV52Qrgri02g1qKNvd0s8OiHvAxiDGtbSXXq2D4HGTwEHYgiO5ZjRBHvoCWezeSbtMxq
        wOdga3kJG+F7AqX1QeYNmZhJOH3Wcq0V6kjK5yJo4qwHOL1tYaI84xmbl5ixHsSC+ygUO3fBwgRbl
        jjDt7euU/qZkr5rMghyLdWDB4STCckhekrq76p0xh2Do6NvNbp6DYGOjwazQr/6slrpUUmwRUrpdG
        Cnq5YB3g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56202)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mvLO0-0000B2-4J; Thu, 09 Dec 2021 15:31:08 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mvLNy-0007JV-6Z; Thu, 09 Dec 2021 15:31:06 +0000
Date:   Thu, 9 Dec 2021 15:31:06 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Chris Snook <chris.snook@gmail.com>, Felix Fietkau <nbd@nbd.name>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: phylink: add legacy_pre_march2020
 indicator
Message-ID: <YbIhOikjMwZ8aQlS@shell.armlinux.org.uk>
References: <DGaGmGgWrlVkW@shell.armlinux.org.uk>
 <E1mucmf-00EyCl-KA@rmk-PC.armlinux.org.uk>
 <YbIBT7/6b0evemPB@shell.armlinux.org.uk>
 <20211209072018.6f0413ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209072018.6f0413ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 07:20:18AM -0800, Jakub Kicinski wrote:
> On Thu, 9 Dec 2021 13:14:55 +0000 Russell King (Oracle) wrote:
> > This series was incorrectly threaded to its cover letter; the patches
> > have now been re-sent with the correct message-ID for their cover
> > letter. Sadly, this mistake was not obvious until I looked at patchwork
> > to work out why they haven't been applied yet.
> 
> Hm, I think they were showing up fine in patchwork, I just didn't 
> get to them, yet. I'll apply as soon as I'm done with the weekly PR.

Yes, they're in patchwork, but patchwork is saying "no cover letter" for
them, which is what alerted me to the problem. E.g.

https://patchwork.kernel.org/project/netdevbpf/patch/E1mucmu-00EyD4-Vy@rmk-PC.armlinux.org.uk/

              Context              Check              Description
...
   netdev/cover_letter            warning Series does not have a cover letter

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
