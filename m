Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABAB2A3515
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 21:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgKBU1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 15:27:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:53140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725833AbgKBU1X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 15:27:23 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A4D5206DC;
        Mon,  2 Nov 2020 20:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604348842;
        bh=7WV55XWF9jj/QZHr3cgnFSnvS0wVConZgFUkIt0wncU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uIOlam4H3d1Jmrgx+4Yt3J51Ybm8q7SUNn0cYpEppNGoD6eKBB8uHWpqAIT0SqkJD
         +Dcpwsr8Vu2usAKqEY9QxMneMLYO27LLRBumvOt/A+bVDruiBU57bq5CF8zEJPIlu/
         8gUHDZYA0AUBjulM3AGHiLmMUCKXgswiyoxOKuGs=
Date:   Mon, 2 Nov 2020 12:27:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH net-next] net: 9p: Fix kerneldoc warnings of missing
 parameters etc
Message-ID: <20201102122721.00f449a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201101160825.GB5153@nautica>
References: <20201031182655.1082065-1-andrew@lunn.ch>
        <20201031205813.GA624@nautica>
        <20201101155405.GA1109407@lunn.ch>
        <20201101160825.GB5153@nautica>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 1 Nov 2020 17:08:25 +0100 Dominique Martinet wrote:
> Andrew Lunn wrote on Sun, Nov 01, 2020:
> > > > Signed-off-by: Andrew Lunn <andrew@lunn.ch>  
> 
> Acked-by: Dominique Martinet <asmadeus@codewreck.org>
> 
> > > 
> > > Thanks, LGTM I'll take this for next cycle unless someone is grabbing
> > > these  
> > 
> > I hope to turn on W=1 by default soon in most of /net. That patch is
> > likely to go to net-next.  
> 
> That would be nice!
> 
> > What route do your patches normally take to Linus? Do you send a pull
> > request to net-next? Or straight to Linus?  
> 
> I normally send pull requests straight to Linus (because I also have
> fs/9p which isn't part of net/) ; but since it's really low volume I
> don't like bugging him everytime for such churn and am not really sure
> what to do -- that's why I asked :)
> 
> > If this patch is not in net-next, i cannot enable it for 9p. So
> > either:
> > [...]
> > 4) Jakub takes this patch into net-next, and i can then enable W=1 in
> >    9p along with all the other sub-directories. We will get to know
> >    about new warnings in net-next, and next, but not in your tree.  
> 
> Developers should use next for development anyway; I think that's the
> easiest way forward if you want to enable W=1 ASAP.
> 
> I mean, if I take the patch the fixes will get in next in the next few
> days sure but it'll make enabling W=1 difficult for the net-next tree
> without it.
> I've added Jakub to direct recipients, could you take this one?

Sure - to net-next it goes, thanks!
