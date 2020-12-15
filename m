Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8FE2DA5B4
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 02:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730518AbgLOBlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 20:41:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:52360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727840AbgLOBlD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 20:41:03 -0500
Date:   Mon, 14 Dec 2020 17:40:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607996422;
        bh=wb4IiQqgJ45a0jmUH8Z42M5Hp7DjtmWOILI4NxglpTQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=pphH+YNYXahEjjCsCNrIXSmorPlWjuMMRtCJ9uqsBdFgZ107Lh8nEbt9iEdYaEdhK
         XJT5nfjx1etunSATcIxdmFJzPeaZr9qTokhWfnO/IClDXBoX7MTD+GUhz3jvWGb0JP
         V30FZOZrpEjJ709THYu1xI44buHQExH1VgBLmIT0=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Roman Gushchin <guro@fb.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the
 bpf-next tree
Message-Id: <20201214174021.2dfc2fbd99ca3e72b3e4eb02@linux-foundation.org>
In-Reply-To: <20201215012943.GA3079589@carbon.DHCP.thefacebook.com>
References: <20201204202005.3fb1304f@canb.auug.org.au>
        <20201215072156.1988fabe@canb.auug.org.au>
        <20201215012943.GA3079589@carbon.DHCP.thefacebook.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 17:29:43 -0800 Roman Gushchin <guro@fb.com> wrote:

> On Tue, Dec 15, 2020 at 07:21:56AM +1100, Stephen Rothwell wrote:
> > Hi all,
> > 
> > On Fri, 4 Dec 2020 20:20:05 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > >
> > > Today's linux-next merge of the akpm-current tree got conflicts in:
> > > 
> > >   include/linux/memcontrol.h
> > >   mm/memcontrol.c
> > > 
> > > between commit:
> > > 
> > >   bcfe06bf2622 ("mm: memcontrol: Use helpers to read page's memcg data")
> > > 
> > > from the bpf-next tree and commits:
> > > 
> > >   6771a349b8c3 ("mm/memcg: remove incorrect comment")
> > >   c3970fcb1f21 ("mm: move lruvec stats update functions to vmstat.h")
> > > 
> > > from the akpm-current tree.
> > > 
> ...
> > 
> > Just a reminder that this conflict still exists.  Commit bcfe06bf2622
> > is now in the net-next tree.
> 
> Thanks, Stephen!
> 
> I wonder if it's better to update these 2 commits in the mm tree to avoid
> conflicts?
> 
> Basically split your fix into two and merge it into mm commits.
> The last chunk in the patch should be merged into "mm/memcg: remove incorrect comment".
> And the rest into "mm: move lruvec stats update functions to vmstat.h".
> 
> Andrew, what do you think?

I have "mm/memcg: remove incorrect comment" and "mm: move lruvec stats
update functions to vmstat.h" staged against Linus's tree and plan to
send them to him later today.  So I trust the BPF tree maintainers will
be able to resolve these minor things when those patches turn up in
mainline.



