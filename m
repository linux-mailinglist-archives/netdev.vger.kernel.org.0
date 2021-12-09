Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BAE46EB54
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 16:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbhLIPgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 10:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239771AbhLIPgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 10:36:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7944C0617A1
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 07:32:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86821B8251E
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 15:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5DDC004DD;
        Thu,  9 Dec 2021 15:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639063950;
        bh=la12TSxubwsMjMW6B0h+IfDSevd6t2JnN5OS4hUx7zA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eFIKx8E4r2aTBbOj7eDD2Fk3I4FGm/eIITsojcrdFS0SsKOjT7kHFiFXbhwcUN/Wm
         /uAJLQDNwiESqDqcRSAhcEvzhcsjVEBkpMcLJYE388bch+jC75lNQYw6uuEr2mIxqK
         zzZsmT4u+FqspCV3ILuim/uCvAmcqX6LKlkjzkVP/aF1Bzcl1SftGlzuNg4X/kRP3C
         Y6oebIy2v6/tF4Bcif4iSKSBE9vNKxwMrPeji7DbtXMZlhvey5u+23nMAKWx17BqSI
         yWzMsrw2Ogw3J6a0R5e6dw9lePIsznXLy9IRKDTbCqrL0Pn+ehrNC7viaJNA6ei+cU
         8doWdAERD3YmA==
Date:   Thu, 9 Dec 2021 07:32:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
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
Message-ID: <20211209073228.06171d9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YbIhOikjMwZ8aQlS@shell.armlinux.org.uk>
References: <DGaGmGgWrlVkW@shell.armlinux.org.uk>
        <E1mucmf-00EyCl-KA@rmk-PC.armlinux.org.uk>
        <YbIBT7/6b0evemPB@shell.armlinux.org.uk>
        <20211209072018.6f0413ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YbIhOikjMwZ8aQlS@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Dec 2021 15:31:06 +0000 Russell King (Oracle) wrote:
> On Thu, Dec 09, 2021 at 07:20:18AM -0800, Jakub Kicinski wrote:
> > On Thu, 9 Dec 2021 13:14:55 +0000 Russell King (Oracle) wrote:  
> > > This series was incorrectly threaded to its cover letter; the patches
> > > have now been re-sent with the correct message-ID for their cover
> > > letter. Sadly, this mistake was not obvious until I looked at patchwork
> > > to work out why they haven't been applied yet.  
> > 
> > Hm, I think they were showing up fine in patchwork, I just didn't 
> > get to them, yet. I'll apply as soon as I'm done with the weekly PR.  
> 
> Yes, they're in patchwork, but patchwork is saying "no cover letter" for
> them, which is what alerted me to the problem. E.g.
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/E1mucmu-00EyD4-Vy@rmk-PC.armlinux.org.uk/
> 
>               Context              Check              Description
> ...
>    netdev/cover_letter            warning Series does not have a cover letter

Oh, that, you're right.
