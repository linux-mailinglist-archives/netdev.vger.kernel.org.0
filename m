Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39FD7602948
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 12:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiJRKYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 06:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiJRKYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 06:24:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C7427B3A;
        Tue, 18 Oct 2022 03:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DshSkJs6j1g2qNN0Ljt9foy0RHxNcTT/yoMkXBCk6VM=; b=XRyCev8owxNX2OahbBXwNPlH8j
        NTyzHcr0KM7WW1Qx+xtiP8mtX7FGY+inXq9DzlwdvZOVq13q9ZJIZIXJ8NQJXAkybHYU1wZ8pKn9/
        CIE7PPNfKz6p4DopKPIGBWeJ5Yoa2Bast+3G8rsUsEGnrZ76MIcscw/xv4AhW1YnLBnM7PG4h4O0+
        q7bZcmbdm85v/UucEiVbUQO+G0H/89NCDXKTXLUS1rEdHRs6lUUeL1Ygl5ZIRENPrwROiLW6huFWw
        RxrJ//6Y+6p2KMT0/d9rZ9Funjiq7TJKY4UdpprjwmdJWJoj+D6xbXpu+p/uRWjJnymr8dua16fOT
        IPZaqhiA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34770)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1okjm5-0004KA-In; Tue, 18 Oct 2022 11:24:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1okjm3-00010w-Dk; Tue, 18 Oct 2022 11:24:39 +0100
Date:   Tue, 18 Oct 2022 11:24:39 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Pavel Machek <pavel@denx.de>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 21/34] net: sfp: move Alcatel Lucent
 3FE46541AA fixup
Message-ID: <Y05+51lztI5yi/A6@shell.armlinux.org.uk>
References: <20221009222129.1218277-1-sashal@kernel.org>
 <20221009222129.1218277-21-sashal@kernel.org>
 <20221018094332.GE1264@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018094332.GE1264@duo.ucw.cz>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 11:43:32AM +0200, Pavel Machek wrote:
> Hi!
> 
> > Add a new fixup mechanism to the SFP quirks, and use it for this
> > module.
> 
> There are two preparation patches for this, but this does not fix
> anything -- it just reimplement quirk in a different way.
> 
> We should not have patches 19-21 in stable.

They should be being dropped as, as a result of this ongoing madness,
I've requested stable to no longer consider *any* of my patches for
AUTOSEL treatment.

I'm afraid that the stable kernel is loosing its purpose, and is
becoming just another development tree as long as this autosel
process exists that picks up what are development patches - coupled
with the "if you don't respond we're adding it to stable anyway"
approach means that it's a hell of a lot of work for maintainers to
be watching what stable is doing 24 hours a day 365 days a year with
_no_ possibility of having a break from that.

As I understand it, the autosel stuff is using an AI to work out
whether the patch is suitable or not, and no one bothers to look at
the quality of its selection - that task is loaded on to each
maintainer and requires said maintainer to never take any time off
from that task.

It's madness.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
