Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 330D5CE3F6
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 15:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbfJGNnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 09:43:18 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46688 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfJGNnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 09:43:18 -0400
Received: by mail-qk1-f194.google.com with SMTP id 201so12533998qkd.13;
        Mon, 07 Oct 2019 06:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=K+pUcPJyrjpykRGiVUmjMJ7TY7IW5jQUk/l6oR2E1B0=;
        b=s0GM7LFfaODTdIhZWC89C1CPoetULRxViO0Az9sqdXnZPXl3O7+95Zkb0kmwgK960g
         91PY5MaCMf4t37IOI18+3q4VIm5HP3ozKZfPj2SvuURkzSx6Ri/FPFLU8LDlLOgPdotp
         wAKT+dUbQJy5rMZK/diqSbQWZPlSV4UutApDtiZcvFhKqqEAIRlvSTmHb5HlOk3te4sY
         LGOSW4lJyEx7RJoN+2QIBAxfwkkGoZiMP71n9vw2ateZW5OKagn2E6rwZ2BI1IGASk3r
         VrxI8IpcdsD8f4kB5bAzYSKu1NP9A4sRIgy3JpuWllkFS6xqSEHS2n5mpXzpFQFDDlVh
         S6WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=K+pUcPJyrjpykRGiVUmjMJ7TY7IW5jQUk/l6oR2E1B0=;
        b=JdzXGS7xd5P6I3RGH/bfxH3qcFjUrzrW+q/kNkK7kb/aDqxKiLm6fD3O/2fWZj74SF
         Gv8/HCSTYkjrM6hUf9+Wm31i0ren1yb71XBWqtgJV1IV0aIp2747rhqCZDGgPXa9uR1k
         A5KKObGYzdC8dS/k8sQsU6h6DbGfPh3N+LCJJLlKm4WCBXoikGWHy2DOI5nxxloPm8OK
         9B5C2jLvhkw5JPjamGs7fNXI/qwui64n/Haehe25zOe9WMzloXDkyrgNNCeUG1uykfLz
         ZzXUznWBkQ3LvpOkgaLHRXzclgzhttiBeaIBuLOBw9RsiVoe90OPNlSSAsIXZG5u6yN7
         8OZg==
X-Gm-Message-State: APjAAAVXBqMUS4yu7ipayIbX9bY42pxd0LZRbVp5ZTq/fomWFClA6DQB
        FY6cdmdAXgVHFyZ1c4soy68=
X-Google-Smtp-Source: APXvYqz2IvWx23o8jPkH3TIyab6bT4aOX0CvhBh+wnSFZqcwcJJcUi/gbyIFYE7CDVBxowqsvt9FHg==
X-Received: by 2002:a37:4f94:: with SMTP id d142mr22624161qkb.421.1570455796980;
        Mon, 07 Oct 2019 06:43:16 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id v7sm7330540qte.29.2019.10.07.06.43.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 06:43:16 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 4492820F25;
        Mon,  7 Oct 2019 09:43:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 07 Oct 2019 09:43:15 -0400
X-ME-Sender: <xms:8kCbXWyfbl1NeLa42HwVcCs0QAcHWQyFdlcgxjGgjQ95azxVNKEf2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheejgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    fuuhhsphgvtghtffhomhgrihhnucdlgeelmdenucfjughrpeffhffvuffkfhggtggugfgj
    fgesthhqredttdervdenucfhrhhomhepuehoqhhunhcuhfgvnhhguceosghoqhhunhdrfh
    gvnhhgsehgmhgrihhlrdgtohhmqeenucffohhmrghinhepghhithhhuhgsrdgtohhmpdgr
    phhpshhpohhtrdgtohhmnecukfhppedukedtrdduheekrddukeefrddukeeinecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgr
    lhhithihqdeiledvgeehtdeigedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppe
    hgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghmvgenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:8kCbXfb-WdUp-L7JdKmeOOlX0lupnzfHMIvHYdtiYbvz5sLS8qm7Yg>
    <xmx:8kCbXYx6m698Snepmw_4R2uzkj6_RB7fpz_DELGFjOav0v-Y6ALkAg>
    <xmx:8kCbXdh2NnKDMPOa5oI2hJJtAQ-VJxwdnsZ6QgfSKY2CiRqWxcDINw>
    <xmx:80CbXRRFC2-VeFPqt6_sinehiP--NeBVaPt8ll8bnqWAEALUc_HuftexAl0>
Received: from localhost (unknown [180.158.183.186])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3044E8005C;
        Mon,  7 Oct 2019 09:43:11 -0400 (EDT)
Date:   Mon, 7 Oct 2019 21:43:04 +0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     Marco Elver <elver@google.com>
Cc:     syzbot <syzbot+134336b86f728d6e55a0@syzkaller.appspotmail.com>,
        paulmck@kernel.org, josh@joshtriplett.org, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
        Joel Fernandes <joel@joelfernandes.org>, rcu@vger.kernel.org,
        a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, LKML <linux-kernel@vger.kernel.org>,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
Subject: Re: KCSAN: data-race in find_next_bit / rcu_report_exp_cpu_mult
Message-ID: <20191007134304.GA2609633@tardis>
References: <000000000000604e8905944f211f@google.com>
 <CANpmjNNmSOagbTpffHr4=Yedckx9Rm2NuGqC9UqE+AOz5f1-ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CANpmjNNmSOagbTpffHr4=Yedckx9Rm2NuGqC9UqE+AOz5f1-ZQ@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marco,

On Mon, Oct 07, 2019 at 12:04:16PM +0200, Marco Elver wrote:
> +RCU maintainers
> This might be a data-race in RCU itself.
>=20
> On Mon, 7 Oct 2019 at 12:01, syzbot
> <syzbot+134336b86f728d6e55a0@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    b4bd9343 x86, kcsan: Enable KCSAN for x86
> > git tree:       https://github.com/google/ktsan.git kcsan
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D11edb20d600=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dc0906aa6207=
13d80
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D134336b86f728=
d6e55a0
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >
> > Unfortunately, I don't have any reproducer for this crash yet.
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the comm=
it:
> > Reported-by: syzbot+134336b86f728d6e55a0@syzkaller.appspotmail.com
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > BUG: KCSAN: data-race in find_next_bit / rcu_report_exp_cpu_mult
> >
> > write to 0xffffffff85a7f140 of 8 bytes by task 7 on cpu 0:
> >   rcu_report_exp_cpu_mult+0x4f/0xa0 kernel/rcu/tree_exp.h:244
> >   rcu_report_exp_rdp+0x6c/0x90 kernel/rcu/tree_exp.h:254
> >   rcu_preempt_deferred_qs_irqrestore+0x3bb/0x580 kernel/rcu/tree_plugin=
=2Eh:475
> >   rcu_read_unlock_special+0xec/0x370 kernel/rcu/tree_plugin.h:659
> >   __rcu_read_unlock+0xcf/0xe0 kernel/rcu/tree_plugin.h:394
> >   rcu_read_unlock include/linux/rcupdate.h:645 [inline]
> >   batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:411 [inline]
> >   batadv_nc_worker+0x13a/0x390 net/batman-adv/network-coding.c:718
> >   process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
> >   worker_thread+0xa0/0x800 kernel/workqueue.c:2415
> >   kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
> >   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352
> >
> > read to 0xffffffff85a7f140 of 8 bytes by task 7251 on cpu 1:
> >   _find_next_bit lib/find_bit.c:39 [inline]
> >   find_next_bit+0x57/0xe0 lib/find_bit.c:70
> >   sync_rcu_exp_select_node_cpus+0x28e/0x510 kernel/rcu/tree_exp.h:375

This is the second for_each_leaf_node_cpu_mask() loop in
sync_rcu_exp_select_node_cpus(), the first loop is for collecting which
CPU blocks current grace period (IOW, which CPU need to be sent an IPI
to), and the second loop does the real work of sending IPI. The first
loop is protected by proper lock (rcu node lock), so there is no race
there. But the second one can't hold rcu node lock, because the IPI
handler (rcu_exp_handler) needs to acquire the same lock, so rcu node
lock has to be dropped before the second loop to avoid deadlock.

Now for the racy find_next_bit() on rnp->expmask:

1) if an extra bit appears: it's OK since there is checking on whether
the bit exists in mask_ofl_ipi (the result of the first loop).

2) if a bit is missing: it will be problematic, because the second loop
will skip the CPU, and the rest of the code will treat the CPU as
offline but hasn't reported a quesient state, and the
rcu_report_exp_cpu_mult() will report the qs for it, even though the CPU
may currenlty run inside a RCU read-side critical section.

Note both "appears" and "missing" means some intermediate state of a
plain unset for expmask contributed by compiler magic.

Please see below for a compile-test-only patch:

> >   sync_rcu_exp_select_cpus+0x30c/0x590 kernel/rcu/tree_exp.h:439
> >   rcu_exp_sel_wait_wake kernel/rcu/tree_exp.h:575 [inline]
> >   wait_rcu_exp_gp+0x25/0x40 kernel/rcu/tree_exp.h:589
> >   process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
> >   worker_thread+0xa0/0x800 kernel/workqueue.c:2415
> >   kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
> >   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352
> >
> > Reported by Kernel Concurrency Sanitizer on:
> > CPU: 1 PID: 7251 Comm: kworker/1:4 Not tainted 5.3.0+ #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > Workqueue: rcu_gp wait_rcu_exp_gp
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >

Regards,
Boqun

------------------->8
Subject: [PATCH] rcu: exp: Avoid race on lockless rcu_node::expmask loop

KCSAN reported an issue:

| BUG: KCSAN: data-race in find_next_bit / rcu_report_exp_cpu_mult
|
| write to 0xffffffff85a7f140 of 8 bytes by task 7 on cpu 0:
|   rcu_report_exp_cpu_mult+0x4f/0xa0 kernel/rcu/tree_exp.h:244
|   rcu_report_exp_rdp+0x6c/0x90 kernel/rcu/tree_exp.h:254
|   rcu_preempt_deferred_qs_irqrestore+0x3bb/0x580 kernel/rcu/tree_plugin.h=
:475
|   rcu_read_unlock_special+0xec/0x370 kernel/rcu/tree_plugin.h:659
|   __rcu_read_unlock+0xcf/0xe0 kernel/rcu/tree_plugin.h:394
|   rcu_read_unlock include/linux/rcupdate.h:645 [inline]
|   batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:411 [inline]
|   batadv_nc_worker+0x13a/0x390 net/batman-adv/network-coding.c:718
|   process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
|   worker_thread+0xa0/0x800 kernel/workqueue.c:2415
|   kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
|   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352
|
| read to 0xffffffff85a7f140 of 8 bytes by task 7251 on cpu 1:
|   _find_next_bit lib/find_bit.c:39 [inline]
|   find_next_bit+0x57/0xe0 lib/find_bit.c:70
|   sync_rcu_exp_select_node_cpus+0x28e/0x510 kernel/rcu/tree_exp.h:375
|   sync_rcu_exp_select_cpus+0x30c/0x590 kernel/rcu/tree_exp.h:439
|   rcu_exp_sel_wait_wake kernel/rcu/tree_exp.h:575 [inline]
|   wait_rcu_exp_gp+0x25/0x40 kernel/rcu/tree_exp.h:589
|   process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
|   worker_thread+0xa0/0x800 kernel/workqueue.c:2415
|   kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
|   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

The root cause of this is the second for_each_leaf_node_cpu_mask() loop
in sync_rcu_exp_select_node_cpus() accesses the rcu_node::expmask
without holding rcu_node's lock. This is by design, because the second
loop may issue IPIs to other CPUs, and the IPI handler (rcu_exp_handler)
may acquire the same rcu_node's lock. So the rcu_node's lock has to be
dropped before the second loop.

The problem will occur when the normal unsetting of rcu_node::expmask
results into some intermediate state (because it's a plain access),
where an extra bit gets zeroed. The second loop will skip the
corrensponding CPU, but treat it as offline and in quesient state. This
will cause trouble because that CPU may be in a RCU read-side critical
section.

To fix this, take a snapshot of mask_ofl_ipi, and make the second loop
iterate on the snapshot's bits, as a result, the find_next_bit() of the
second loop doesn't access any variables that may get changed in
parallel, so the race is avoided.

Reported-by: syzbot+134336b86f728d6e55a0@syzkaller.appspotmail.com
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 kernel/rcu/tree_exp.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree_exp.h b/kernel/rcu/tree_exp.h
index af7e7b9c86af..7f3e19d0275e 100644
--- a/kernel/rcu/tree_exp.h
+++ b/kernel/rcu/tree_exp.h
@@ -335,6 +335,7 @@ static void sync_rcu_exp_select_node_cpus(struct work_s=
truct *wp)
 	unsigned long flags;
 	unsigned long mask_ofl_test;
 	unsigned long mask_ofl_ipi;
+	unsigned long mask_ofl_ipi_snap;
 	int ret;
 	struct rcu_exp_work *rewp =3D
 		container_of(wp, struct rcu_exp_work, rew_work);
@@ -371,13 +372,12 @@ static void sync_rcu_exp_select_node_cpus(struct work=
_struct *wp)
 		rnp->exp_tasks =3D rnp->blkd_tasks.next;
 	raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
=20
+	mask_ofl_ipi_snap =3D mask_ofl_ipi;
 	/* IPI the remaining CPUs for expedited quiescent state. */
-	for_each_leaf_node_cpu_mask(rnp, cpu, rnp->expmask) {
+	for_each_leaf_node_cpu_mask(rnp, cpu, mask_ofl_ipi_snap) {
 		unsigned long mask =3D leaf_node_cpu_bit(rnp, cpu);
 		struct rcu_data *rdp =3D per_cpu_ptr(&rcu_data, cpu);
=20
-		if (!(mask_ofl_ipi & mask))
-			continue;
 retry_ipi:
 		if (rcu_dynticks_in_eqs_since(rdp, rdp->exp_dynticks_snap)) {
 			mask_ofl_test |=3D mask;
--=20
2.23.0

