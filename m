Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7A537F0B2
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 02:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbhEMA5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 20:57:23 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60024 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbhEMA5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 20:57:21 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id EB03E64143;
        Thu, 13 May 2021 02:55:21 +0200 (CEST)
Date:   Thu, 13 May 2021 02:56:08 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: [syzbot] WARNING in __nf_unregister_net_hook (4)
Message-ID: <20210513005608.GA23780@salvia>
References: <0000000000008ce91e05bf9f62bc@google.com>
 <CACT4Y+a6L_x22XNJVX+VYY-XKmLQ0GaYndCVYnaFmoxk58GPgw@mail.gmail.com>
 <20210508144657.GC4038@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210508144657.GC4038@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 04:46:57PM +0200, Florian Westphal wrote:
> Dmitry Vyukov <dvyukov@google.com> wrote:
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com
> > 
> > Is this also fixed by "netfilter: arptables: use pernet ops struct
> > during unregister"?
> > The warning is the same, but the stack is different...
> 
> No, this is a different bug.
> 
> In both cases the caller attempts to unregister a hook that the core
> can't find, but in this case the caller is nftables, not arptables.

I see no reproducer for this bug. Maybe I broke the dormant flag handling?

Or maybe syzbot got here after the arptables bug has been hitted?
