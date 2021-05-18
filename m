Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6EE3876C1
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 12:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348584AbhERKmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 06:42:04 -0400
Received: from foss.arm.com ([217.140.110.172]:48730 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242814AbhERKlz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 06:41:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D03F6106F;
        Tue, 18 May 2021 03:40:36 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.6.226])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CFFB53F719;
        Tue, 18 May 2021 03:40:32 -0700 (PDT)
Date:   Tue, 18 May 2021 11:40:29 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     syzbot <syzbot+0fb24f56fa707081e4f2@syzkaller.appspotmail.com>,
        acme@kernel.org, alexander.shishkin@linux.intel.com,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, jolsa@redhat.com,
        kafai@fb.com, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: [syzbot] WARNING in __perf_install_in_context
Message-ID: <20210518104029.GE82842@C02TD0UTHF1T.local>
References: <000000000000b3d89a05c284718f@google.com>
 <YKJTNcpqVN6gNIHV@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKJTNcpqVN6gNIHV@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 01:27:49PM +0200, Peter Zijlstra wrote:
> On Mon, May 17, 2021 at 03:56:22AM -0700, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    18a3c5f7 Merge tag 'for_linus' of git://git.kernel.org/pub..
> > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1662c153d00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=b8ac1fe5995f69d7
> > dashboard link: https://syzkaller.appspot.com/bug?extid=0fb24f56fa707081e4f2
> > userspace arch: riscv64
> > 
> > Unfortunately, I don't have any reproducer for this issue yet.
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+0fb24f56fa707081e4f2@syzkaller.appspotmail.com
> > 
> > ------------[ cut here ]------------
> > WARNING: CPU: 1 PID: 8643 at kernel/events/core.c:2781 __perf_install_in_context+0x1c0/0x47c kernel/events/core.c:2781
> > Modules linked in:
> > CPU: 1 PID: 8643 Comm: syz-executor.0 Not tainted 5.12.0-rc8-syzkaller-00011-g18a3c5f7abfd #0
> > Hardware name: riscv-virtio,qemu (DT)
> 
> How serious should I take this thing? ARM64 and x86_64 don't show these
> errors.

I think I've seen this in the past on arm64, but very rarely, and never
with a consistent reproducer.

I'm currently fuyzzing v5.13-rc1, and haven't hit anything like this
after ~5 days.

Thanks,
Mark.
