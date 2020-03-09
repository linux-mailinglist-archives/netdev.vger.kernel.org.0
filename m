Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDF3017E094
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 13:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgCIMvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 08:51:09 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48290 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgCIMvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 08:51:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=h4vO3Mf9ePEVLHvVyIo2856TMXeHB767JRNGluWoB4Q=; b=B+/1wIWmqVGk3HzGOGcnLhFAo
        KO1FcNHNx6bL7lktYGPVqowikNq0JfuvWGSqBeu1rRJnNNT7MzJATPTZhqF1GkJswqfFEJ1GJ8kyg
        6c9Y6CT7NGaL1dd40l1zJiaYS1bhx7oN5a1A7mQycXmtMRguQt6JqF12SJFLLewDss3RRJevfnZB+
        YRLYvjvX6xjzIkkstosM3cI1Rwc5Ylnpu3zvVpkL+nq12tcrtxbSHV5TXEXeMiKGBPkP8rRpP73es
        h0vbkkDiJK6+O6k3Fd2fNSVPJ3b7k8nPyxkrgGP+dApyk6T54XixXrUOK7nbUQQVbknQs9wvEXgks
        CJxnpAN9g==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:50714)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jBHs3-0006xf-MB; Mon, 09 Mar 2020 12:50:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jBHs1-0003OA-9i; Mon, 09 Mar 2020 12:50:57 +0000
Date:   Mon, 9 Mar 2020 12:50:57 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        vivien.didelot@gmail.com
Subject: Re: [PATCH net-next 0/10] net: dsa: improve serdes integration
Message-ID: <20200309125057.GK25745@shell.armlinux.org.uk>
References: <20200305124139.GB25745@shell.armlinux.org.uk>
 <20200308.220447.1610295462041711848.davem@davemloft.net>
 <20200309094828.GJ25745@shell.armlinux.org.uk>
 <20200309124018.GA8942@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309124018.GA8942@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 09, 2020 at 01:40:18PM +0100, Andrew Lunn wrote:
> > Yep - it comes from the poor integration of phylink into DSA for CPU
> > and inter-DSA ports which is already causing regressions in today's
> > kernels. That needs resolving somehow before this patch series can
> > be merged, but it isn't something that can be fixed from the phylink
> > side of things.
> 
> Hi Russell
> 
> What do you think about my proposal to solve it? Only instantiate
> phylink for CPU and DSA ports if there is a fixed-link or phy-handle
> in DT?

I think it gets us out of the problem, and is probably the best
solution for stable kernels that we have at the moment. It isn't
too elegant, but then my solution isn't either.  If we work out an
alternative approach later, then we can always switch to that.

So, in the interests of moving forward, as well as fixing the
regression we already know about, I think your solution should
be merged.

> So i will formally propose my solution.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
