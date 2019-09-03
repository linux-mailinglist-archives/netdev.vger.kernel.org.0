Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69236A6913
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 14:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbfICMz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 08:55:58 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40012 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbfICMz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 08:55:58 -0400
Received: by mail-pl1-f193.google.com with SMTP id y10so1941889pll.7
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 05:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6pLoiudo/xgk9bkSvA4usGkxKo1ghq7/c8HtH8i8rxg=;
        b=Gv9+edN3mxqvI3Yjsy6IVcD61G6kGpBCw0w37YopdD3aVOxt3K1JLzOhTky0zv2Ym3
         45L9FxheyiE4PdZ/X3j+Tv3xfuZwF+QQlNTewZB0+aFD9TzujPLWKkaB61eAuLZsY/ij
         o7yvuQu/UTZGBygOzVkGvztQ9KKakzZUCItqwlkB+p3oluLPPhZe943Y9RU4l3DDhFYp
         EqUI8EicjtPSYxhD6yBcWsrysev6gqy8O8K3QG7rf27ge6NEMktyyk25avZYec3QZvVl
         RNr/+5m8DvVJkgTt76HEGezd2/BV41kzK88G5QVJSAy4C3Gjuco0m0yPhZL4xwd1/5Gb
         mjMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6pLoiudo/xgk9bkSvA4usGkxKo1ghq7/c8HtH8i8rxg=;
        b=YXcZf7i2PoAqbS4SiRi90FJwINWOjA+5lq6lYTX+oaS+PUqn4Zd1O/fsrHkBNtrxp/
         9VaNR6a86w1i8Jv6sss886cXVfk+jUjEz5UQd/EuCxCv/C4hA+sQIgAVskpldbV/1gbS
         JgLAOqxT6pK5eL4EksVVdOMZABfrj4PL4PjceUEWfOliuobLGe8qGOn7cZIqK69mFHOb
         luP6NhBHcoyt+uW/gD8FWyMc3vlUNLI14LaXEXRJvmvl2pUngNdphHSq04NKFLRBT7Ku
         WQRy1NXliHhPCfPvuc1DgYV0DUZL0FV3xCttn2YBfWuJNUOAsHow9FnOSc8COpJUwWYc
         yjUQ==
X-Gm-Message-State: APjAAAVQDV4Y2fyNHPenyv0JYhNYMrZaJPpEKWHQtOqHDfivZzwAyp91
        OJlVUjTwPwd2vTKXZ3aqgyjeLBcXFMg=
X-Google-Smtp-Source: APXvYqw7644YFjX6co0fMBtzG7SpTThSGdQz56xu1iDhpbefv2KH/pexq+4fmq+FVnfqWjzfQ7E48A==
X-Received: by 2002:a17:902:248:: with SMTP id 66mr35585492plc.19.1567515357989;
        Tue, 03 Sep 2019 05:55:57 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n19sm7940928pfa.67.2019.09.03.05.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 05:55:57 -0700 (PDT)
Date:   Tue, 3 Sep 2019 20:55:47 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, Phil Karn <karn@ka9q.net>,
        Sukumar Gopalakrishnan <sukumarg1973@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net] ipmr: remove cache_resolve_queue_len
Message-ID: <20190903125547.GH18865@dhcp-12-139.nay.redhat.com>
References: <20190903084359.13310-1-liuhangbin@gmail.com>
 <e0261582-78ce-038f-ed4c-c2694fb70250@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0261582-78ce-038f-ed4c-c2694fb70250@cumulusnetworks.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolay,

Thanks for the feedback, see comments below.

On Tue, Sep 03, 2019 at 12:15:34PM +0300, Nikolay Aleksandrov wrote:
> On 03/09/2019 11:43, Hangbin Liu wrote:
> > This is a re-post of previous patch wrote by David Miller[1].
> > 
> > Phil Karn reported[2] that on busy networks with lots of unresolved
> > multicast routing entries, the creation of new multicast group routes
> > can be extremely slow and unreliable.
> > 
> > The reason is we hard-coded multicast route entries with unresolved source
> > addresses(cache_resolve_queue_len) to 10. If some multicast route never
> > resolves and the unresolved source addresses increased, there will
> > be no ability to create new multicast route cache.
> > 
> > To resolve this issue, we need either add a sysctl entry to make the
> > cache_resolve_queue_len configurable, or just remove cache_resolve_queue_len
> > directly, as we already have the socket receive queue limits of mrouted
> > socket, pointed by David.
> > 
> > From my side, I'd perfer to remove the cache_resolve_queue_len instead
> > of creating two more(IPv4 and IPv6 version) sysctl entry.
> > 
> > [1] https://lkml.org/lkml/2018/7/22/11
> > [2] https://lkml.org/lkml/2018/7/21/343
> > 
> > Reported-by: Phil Karn <karn@ka9q.net>
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> >  include/linux/mroute_base.h |  2 --
> >  net/ipv4/ipmr.c             | 27 ++++++++++++++++++---------
> >  net/ipv6/ip6mr.c            | 10 +++-------
> >  3 files changed, 21 insertions(+), 18 deletions(-)
> > 
> 
> Hi,
> IMO this is definitely net-next material. A few more comments below.

I thoug this is a bug fix. But it looks more suitable to net-next as you said.
> 
> Note that hosts will automatically have this limit lifted to about 270
> entries with current defaults, some might be surprised if they have
> higher limits set and could be left with queues allowing for thousands
> of entries in a linked list.

I think this is just a cache list and should be expired soon. The cache
creation would also failed if there is no buffer.

But if you like, I can write a patch with sysctl parameter.
> 
> > +static int queue_count(struct mr_table *mrt)
> > +{
> > +	struct list_head *pos;
> > +	int count = 0;
> > +
> > +	list_for_each(pos, &mrt->mfc_unres_queue)
> > +		count++;
> > +	return count;
> > +}
> 
> I don't think we hold the mfc_unres_lock here while walking
> the unresolved list below in ipmr_fill_table().

ah, yes, I will fix this.

Thanks
Hangbin
