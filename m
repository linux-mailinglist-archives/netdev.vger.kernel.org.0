Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326F92DA5F9
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 03:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgLOCHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 21:07:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbgLOCHL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 21:07:11 -0500
Date:   Mon, 14 Dec 2020 18:06:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607997991;
        bh=7Z0uvfzuE2/75u7jMIVulYDfojBWvFah+Kwo9MiCBgI=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sgkf+cL0VMvYkPn3LaoaMfrwrAEC6+VxCdjuT//Nld0mB9477d30usxtQBFIdtox8
         1ZMa+QnWHD0AW0RZ5GOegKlT9iGQXypjFOOaEXXfrcsbXGzIF4O+ft+hoychs8HuHM
         51LbMxvywkxvV3OqrOb+nCLUEJpKz+oO57t96NQlTinKRjV/Nj433Z5xEJKB61GoKX
         QSqsfHKtvIiS2ODC3/YuhPpcu9Vd+pIzDy0o1GT9qKaHPL1aNqJwsku5MjSoJvocaw
         EpFSgsMbBTJrabiWUwxeGqbiuGGsXWmUnRHlKtGYW5SYfbubrScSWyMSKlnbc/lcGJ
         FQyzRgx7b2Okg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Roman Gushchin <guro@fb.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the
 bpf-next tree
Message-ID: <20201214180629.4fee48ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201214174021.2dfc2fbd99ca3e72b3e4eb02@linux-foundation.org>
References: <20201204202005.3fb1304f@canb.auug.org.au>
        <20201215072156.1988fabe@canb.auug.org.au>
        <20201215012943.GA3079589@carbon.DHCP.thefacebook.com>
        <20201214174021.2dfc2fbd99ca3e72b3e4eb02@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 17:40:21 -0800 Andrew Morton wrote:
> On Mon, 14 Dec 2020 17:29:43 -0800 Roman Gushchin <guro@fb.com> wrote:
> > On Tue, Dec 15, 2020 at 07:21:56AM +1100, Stephen Rothwell wrote:  
> > > On Fri, 4 Dec 2020 20:20:05 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:  
> > > > Today's linux-next merge of the akpm-current tree got conflicts in:
> > > > 
> > > >   include/linux/memcontrol.h
> > > >   mm/memcontrol.c
> > > > 
> > > > between commit:
> > > > 
> > > >   bcfe06bf2622 ("mm: memcontrol: Use helpers to read page's memcg data")
> > > > 
> > > > from the bpf-next tree and commits:
> > > > 
> > > >   6771a349b8c3 ("mm/memcg: remove incorrect comment")
> > > >   c3970fcb1f21 ("mm: move lruvec stats update functions to vmstat.h")
> > > > 
> > > > from the akpm-current tree.
> > > >   
> > ...  
> > > 
> > > Just a reminder that this conflict still exists.  Commit bcfe06bf2622
> > > is now in the net-next tree.  
> > 
> > Thanks, Stephen!
> > 
> > I wonder if it's better to update these 2 commits in the mm tree to avoid
> > conflicts?
> > 
> > Basically split your fix into two and merge it into mm commits.
> > The last chunk in the patch should be merged into "mm/memcg: remove incorrect comment".
> > And the rest into "mm: move lruvec stats update functions to vmstat.h".
> > 
> > Andrew, what do you think?  
> 
> I have "mm/memcg: remove incorrect comment" and "mm: move lruvec stats
> update functions to vmstat.h" staged against Linus's tree and plan to
> send them to him later today.  So I trust the BPF tree maintainers will
> be able to resolve these minor things when those patches turn up in
> mainline.

Hm. The code is in net-next by now. I was thinking of sending the
Networking PR later today (tonight?) as well. I'm happy to hold off 
or do whatever you require, but I'd appreciate more explicit / noob
friendly instructions.

AFAIU all we can do is tell Linus about the merge issue, and point 
at Stephen's resolution.
