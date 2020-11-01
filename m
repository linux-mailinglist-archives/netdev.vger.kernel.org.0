Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18F42A1F6E
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 17:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgKAQIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 11:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbgKAQIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 11:08:42 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84231C0617A6
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 08:08:42 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 1001)
        id 841CAC01B; Sun,  1 Nov 2020 17:08:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1604246920; bh=NAh4yRVnmCinK7IGx2ZG2mZVUNTtb4YsMwVS+qEAn0Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OZFK98iMaWOnxh0jHh4eyyrYoGVPHBjyX9iJIFfhFINgalofOHgLQxxdt1Lafxz06
         c4d7aiZdkQhLs+iJvgHkisdlvDVfJE9goszkvjh0C27SxjHTMywcpYZa9yAvA7rpyy
         v38dn78+6iaVY5270O5Tye35uHa6fXTXs85FFtX26Hty7X3Wzz7/6B+Qhai1iXz4uU
         DM1yT0lc8NwEwFyy9mX4Bw1DT+EOSGKwdIyBpZa9lO97H2qifHNazxl3BynrHpKCj5
         pdELEyIZ/3IqYEvgXg3mFUiLjIC4jC4UBZafz5aJujmnqHXwNP8Vl+IvU5Ci+RqPp8
         OmThf7DISjpBA==
Date:   Sun, 1 Nov 2020 17:08:25 +0100
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH net-next] net: 9p: Fix kerneldoc warnings of missing
 parameters etc
Message-ID: <20201101160825.GB5153@nautica>
References: <20201031182655.1082065-1-andrew@lunn.ch>
 <20201031205813.GA624@nautica>
 <20201101155405.GA1109407@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201101155405.GA1109407@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn wrote on Sun, Nov 01, 2020:
> > > Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Acked-by: Dominique Martinet <asmadeus@codewreck.org>

> > 
> > Thanks, LGTM I'll take this for next cycle unless someone is grabbing
> > these
> 
> I hope to turn on W=1 by default soon in most of /net. That patch is
> likely to go to net-next.

That would be nice!

> What route do your patches normally take to Linus? Do you send a pull
> request to net-next? Or straight to Linus?

I normally send pull requests straight to Linus (because I also have
fs/9p which isn't part of net/) ; but since it's really low volume I
don't like bugging him everytime for such churn and am not really sure
what to do -- that's why I asked :)

> If this patch is not in net-next, i cannot enable it for 9p. So
> either:
> [...]
> 4) Jakub takes this patch into net-next, and i can then enable W=1 in
>    9p along with all the other sub-directories. We will get to know
>    about new warnings in net-next, and next, but not in your tree.

Developers should use next for development anyway; I think that's the
easiest way forward if you want to enable W=1 ASAP.

I mean, if I take the patch the fixes will get in next in the next few
days sure but it'll make enabling W=1 difficult for the net-next tree
without it.
I've added Jakub to direct recipients, could you take this one?


Thanks,
-- 
Dominique
