Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EEC1F6115
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 06:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgFKEvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 00:51:33 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:53089 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725799AbgFKEvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 00:51:32 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailnew.nyi.internal (Postfix) with ESMTP id 261C35800FC;
        Thu, 11 Jun 2020 00:51:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Thu, 11 Jun 2020 00:51:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=who-t.net; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=CpC/Vp9dgBZG1Pbnp3psLX9AkPB
        qIwJPJOlUb8cL8Pw=; b=MZ+ct0BuROUXSTZGDvOvjE+bjnbg/ULaqQ8pC/c6c0J
        xLnnxdOtl9KDSIwV3AbmHyjEjvHI8rWclKqdvZnyxrMM43Gm0f/pqtcxKfpPrYBY
        W9Ccz3GGJCXcZFr+ZU4bpPhnzWDqtkhclS7QyzugMKvTR5FCiLs7RU53+JjdqJmX
        qxlx/O2ycWqGIOi7bvBe2P2u9k1KB5OcumBlFoPPOB2nra44uVOj/azGb992sFiv
        xGDj4cg4iE7CuBCpAr0ovgPOVGUVGTHaSc5Pkc/M1DJTAizle8G1Vg/5ri3CBpKI
        I+zvcUqUNRRtC6iQgq52l+8CEOiZPLD79bvTzzp8NgQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=CpC/Vp
        9dgBZG1Pbnp3psLX9AkPBqIwJPJOlUb8cL8Pw=; b=J8vGACGqc7JFQFrs2/r34L
        GGV9ODqa0ebbOWPDygKVO2j810G9SVwgoqHyHcr8tjtWCKPNFOYGWydyUjocBdcX
        KNAXHt9W1MlmYZnLvZUCj0VzaKinzNDaUIe2yTt9aX/ZFu//CnfDnLa2SCCl77bD
        3FrBio7FHGsAjLU4jAH7ss2JzAL/ozPNN6YpG0od2G9E33UzQ5CKNgpvdiHGs0ns
        a3QdAzqEhn+Ta1L5NdubmeuUEOgwgVv8rd0x8JAsvbSDa1pnWMkwHnd9B8Ejyhhq
        ncWo1EqWph8uh4YIgMTiBgiYhfB3vXJSUe4Ko7GWPHJQOqc+0b7glGODiRSfscLA
        ==
X-ME-Sender: <xms:ULjhXtxtAIB37BittLl569I7oXVro8HJwSt5WLcgKZW1qMdrMCwNzw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudehjedgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhushhpvggtthffohhmrghinhculdegledmnecujfgurhepfffhvffukfhfgggtuggj
    sehttdertddttddvnecuhfhrohhmpefrvghtvghrucfjuhhtthgvrhgvrhcuoehpvghtvg
    hrrdhhuhhtthgvrhgvrhesfihhohdqthdrnhgvtheqnecuggftrfgrthhtvghrnhepiefh
    geejiedvteetleduvdetfeetfeetgeetveeljedtgeekkeevueehkeejtdevnecuffhomh
    grihhnpegrphhpshhpohhtrdgtohhmpdhgihhthhhusgdrtghomhenucfkphepuddujedr
    vddtrdeikedrudefvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehpvghtvghrrdhhuhhtthgvrhgvrhesfihhohdqthdrnhgvth
X-ME-Proxy: <xmx:ULjhXtSKqDk5DhdngyUX-sqtoA3SbEYUIaoOVsRet1NrZWWIE_ihTg>
    <xmx:ULjhXnXsTcS8vi11KREeC9NKxSPTxXah8URu1tWEkIG0wOpstVpp_Q>
    <xmx:ULjhXvg3Xk6TUyV__VFPeVzCOyUOVBHzMVOEO5Cq4t7SUAs8MKCqIg>
    <xmx:UrjhXhSwrtvGk19vZsc3lQkrw-ErZ11c1Qc5GK7DRSL68pWMw8rODg>
Received: from jelly (117-20-68-132.751444.bne.nbn.aussiebb.net [117.20.68.132])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5DBD23061856;
        Thu, 11 Jun 2020 00:51:23 -0400 (EDT)
Date:   Thu, 11 Jun 2020 14:51:18 +1000
From:   Peter Hutterer <peter.hutterer@who-t.net>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Andrey Konovalov <andreyknvl@google.com>,
        syzbot <syzbot+6921abfb75d6fc79c0eb@syzkaller.appspotmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        amir73il@gmail.com, Felipe Balbi <balbi@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jan Kara <jack@suse.cz>, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, mptcp@lists.01.org,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: INFO: task hung in corrupted (2)
Message-ID: <20200611045118.GA306934@jelly>
References: <0000000000004afcae05a7041e98@google.com>
 <CAAeHK+ykPQ8Fmit_3cn17YKzrCWtX010HRKmBCJAQ__OMdwCDA@mail.gmail.com>
 <nycvar.YFH.7.76.2006041339220.13242@cbobk.fhfr.pm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.2006041339220.13242@cbobk.fhfr.pm>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 04, 2020 at 01:41:07PM +0200, Jiri Kosina wrote:
> On Tue, 2 Jun 2020, Andrey Konovalov wrote:
> 
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    b0c3ba31 Merge tag 'fsnotify_for_v5.7-rc8' of git://git.ke..
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=14089eee100000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=ce116858301bc2ea
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=6921abfb75d6fc79c0eb
> > > compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14947d26100000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=172726d2100000
> > >
> > > The bug was bisected to:
> > >
> > > commit f2c2e717642c66f7fe7e5dd69b2e8ff5849f4d10
> > > Author: Andrey Konovalov <andreyknvl@google.com>
> > > Date:   Mon Feb 24 16:13:03 2020 +0000
> > >
> > >     usb: gadget: add raw-gadget interface
> > >
> > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=119e4702100000
> > > final crash:    https://syzkaller.appspot.com/x/report.txt?x=139e4702100000
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=159e4702100000
> > >
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+6921abfb75d6fc79c0eb@syzkaller.appspotmail.com
> > > Fixes: f2c2e717642c ("usb: gadget: add raw-gadget interface")
> > >
> > > INFO: task syz-executor610:7072 blocked for more than 143 seconds.
> > >       Not tainted 5.7.0-rc7-syzkaller #0
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > syz-executor610 D24336  7072   7071 0x80004002
> > > Call Trace:
> > >  context_switch kernel/sched/core.c:3367 [inline]
> > >  __schedule+0x805/0xc90 kernel/sched/core.c:4083
> > >
> > > Showing all locks held in the system:
> > > 1 lock held by khungtaskd/1134:
> > >  #0: ffffffff892e85d0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire+0x0/0x30 net/mptcp/pm_netlink.c:860
> > > 1 lock held by in:imklog/6715:
> > >  #0: ffff8880a441e6b0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x25d/0x2f0 fs/file.c:826
> > > 6 locks held by kworker/1:0/7064:
> > > 1 lock held by syz-executor610/7072:
> > >  #0: ffffffff892eab20 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:290 [inline]
> > >  #0: ffffffff892eab20 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x1bd/0x5b0 kernel/rcu/tree_exp.h:856
> > > 4 locks held by systemd-udevd/7099:
> > >  #0: ffff8880a7fdcc70 (&p->lock){+.+.}-{3:3}, at: seq_read+0x60/0xce0 fs/seq_file.c:153
> > >  #1: ffff888096486888 (&of->mutex){+.+.}-{3:3}, at: kernfs_seq_start+0x50/0x3b0 fs/kernfs/file.c:111
> > >  #2: ffff88809fc0d660 (kn->count#78){.+.+}-{0:0}, at: kernfs_seq_start+0x6f/0x3b0 fs/kernfs/file.c:112
> > >  #3: ffff8880a1df7218 (&dev->mutex){....}-{3:3}, at: device_lock_interruptible include/linux/device.h:773 [inline]
> > >  #3: ffff8880a1df7218 (&dev->mutex){....}-{3:3}, at: serial_show+0x22/0xa0 drivers/usb/core/sysfs.c:142
> > >
> > > =============================================
> > >
> > > NMI backtrace for cpu 0
> > > CPU: 0 PID: 1134 Comm: khungtaskd Not tainted 5.7.0-rc7-syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > Call Trace:
> > >  __dump_stack lib/dump_stack.c:77 [inline]
> > >  dump_stack+0x1e9/0x30e lib/dump_stack.c:118
> > >  nmi_cpu_backtrace+0x9f/0x180 lib/nmi_backtrace.c:101
> > >  nmi_trigger_cpumask_backtrace+0x16a/0x280 lib/nmi_backtrace.c:62
> > >  check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
> > >  watchdog+0xd2a/0xd40 kernel/hung_task.c:289
> > >  kthread+0x353/0x380 kernel/kthread.c:268
> > >  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351
> > > Sending NMI from CPU 0 to CPUs 1:
> > > NMI backtrace for cpu 1
> > > CPU: 1 PID: 7064 Comm: kworker/1:0 Not tainted 5.7.0-rc7-syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > Workqueue: usb_hub_wq hub_event
> > > RIP: 0010:__sanitizer_cov_trace_const_cmp4+0x0/0x90 kernel/kcov.c:275
> > > Code: 4c f2 08 48 c1 e0 03 48 83 c8 18 49 89 14 02 4d 89 44 f2 18 49 ff c1 4d 89 0a c3 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 <4c> 8b 04 24 65 48 8b 04 25 40 1e 02 00 65 8b 0d 78 96 8e 7e f7 c1
> > > RSP: 0018:ffffc90001676cf0 EFLAGS: 00000246
> > > RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88809fb9e240
> > > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000ffffffff
> > > RBP: ffff888092d24a04 R08: ffffffff86034f3b R09: ffffc900016790cc
> > > R10: 0000000000000004 R11: 0000000000000000 R12: ffff888092d24a00
> > > R13: 0000000000000000 R14: dffffc0000000000 R15: ffff888092d24a00
> > > FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 00000000004c6e68 CR3: 0000000092d41000 CR4: 00000000001406e0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > Call Trace:
> > >  hid_apply_multiplier drivers/hid/hid-core.c:1106 [inline]
> > 
> > Looks like an issue in the HID subsystem, adding HID maintainers.
> 
> So this is hanging indefinitely in either of the loops in 
> hid_apply_multiplier(). We'll have to decipher the reproducer to 
> understand what made the loop (and which one) unbounded.
> 
> In parallel, CCing Peter, who wrote that code in the first place.

based on the line numbers it's the while loop in there which is also the one
that could be unbounded if the hid collection isn't set up correctly or if
we have some other corruption happening.

Need to page this back in to figure out what could be happening here.

Cheers,
   Peter

