Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BE0211F0C
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgGBIlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727782AbgGBIlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:41:36 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361EAC08C5C1;
        Thu,  2 Jul 2020 01:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=akm8ROnV0pI+WVyllLrWm9BCF6GQuQwWAzJsuTZEqBU=; b=0zx/cMcCfOco0iKkTq60YJz+o
        G/MgOn+ARLws1t03J2A49+OM4y/5vi78CcaY1Z99BMnsGrpUumWooQaZVd7lGAOjGvrKF9grzP0ir
        UdWapHI6xfNQbzUqMU7dFHw5SPr9bsdZf1kR2npG1O1L4qJNgXOIqqfuBV3SCYKqUnqgoGiVHckeK
        nGFUq0CNcoTJWJqSMTbAQe3QiiiLl+jCquA9FNE6wn+V47pz+Sgfy34GMxsdL1Jxl4BOMZUI35CiG
        QLbqAATEHO6e08xqoOkpWDC0sVz6oDoQ7ejvljZ3YfTjCAmOvMyLCo5mx1S66R7V6zaj5hvH3/fK4
        Ev8hyvhxA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34316)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jqumh-0002cA-NB; Thu, 02 Jul 2020 09:41:31 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jqume-0001eF-Qf; Thu, 02 Jul 2020 09:41:28 +0100
Date:   Thu, 2 Jul 2020 09:41:28 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Michael Walle <michael@walle.cc>, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: Re: [PATCH RESEND net-next v3 0/3] net: enetc: remove bootloader
 dependency
Message-ID: <20200702084128.GM1551@shell.armlinux.org.uk>
References: <20200701213433.9217-1-michael@walle.cc>
 <20200701215310.GL1551@shell.armlinux.org.uk>
 <CA+h21hotHbN1xpZcnTMftXesgz7T6sEGCCPzFKdtG1NfMxguLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hotHbN1xpZcnTMftXesgz7T6sEGCCPzFKdtG1NfMxguLg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 01:04:02AM +0300, Vladimir Oltean wrote:
> On Thu, 2 Jul 2020 at 00:53, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > fixing up almost every driver the best I can with the exception of two -
> > felix DSA and Mediatek.
> >
> > I'm not going to wait for Felix or Mediatek.  As I say, I've given
> > plenty of warning, and it's only a _suspicion_ of breakage on my
> > side.
> >
> 
> What do you mean "I'm not going to wait for Felix"?
> https://patchwork.ozlabs.org/project/netdev/patch/20200625152331.3784018-5-olteanv@gmail.com/
> We left it at:
> 
> > I'm not going to review patch 7
> > tonight because of this fiasco.  To pissed off to do a decent job, so
> > you're just going to have to wait.
> 
> So, I was actively waiting for you to review it ever since, just like
> you said, so I could send a v2. Were you waiting for anything?

I stopped being interested in your series with the patch 5 commit
description issue; what happened there is really demotivating.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
