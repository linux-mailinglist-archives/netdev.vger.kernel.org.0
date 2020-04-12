Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 396D21A5D7A
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 10:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgDLIcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 04:32:14 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:41504 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725832AbgDLIcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 04:32:14 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jNY25-0004Cz-H0; Sun, 12 Apr 2020 10:32:01 +0200
Date:   Sun, 12 Apr 2020 10:32:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     syzbot <syzbot+ffec3741d41140477097@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.01.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: WARNING: bad unlock balance in mptcp_listen
Message-ID: <20200412083201.GB5795@breakpoint.cc>
References: <000000000000d754eb05a312bd8f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000d754eb05a312bd8f@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+ffec3741d41140477097@syzkaller.appspotmail.com> wrote:
> syzbot found the following crash on:
> 
> HEAD commit:    5b8b9d0c Merge branch 'akpm' (patches from Andrew)
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1712bdb3e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=23c5a352e32a1944
> dashboard link: https://syzkaller.appspot.com/bug?extid=ffec3741d41140477097
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+ffec3741d41140477097@syzkaller.appspotmail.com
> 
> =====================================
> WARNING: bad unlock balance detected!
> 5.6.0-syzkaller #0 Not tainted
> -------------------------------------
> syz-executor.0/25417 is trying to release lock (sk_lock-AF_INET6) at:
> [<ffffffff87c65063>] mptcp_listen+0x1c3/0x2e0 net/mptcp/protocol.c:1783
> but there are no more locks to release!

#syz dup: WARNING: bad unlock balance in mptcp_poll
