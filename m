Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D77E128662
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 02:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfLUBiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 20:38:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:50140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbfLUBiv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 20:38:51 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69EEF20716;
        Sat, 21 Dec 2019 01:38:49 +0000 (UTC)
Date:   Fri, 20 Dec 2019 20:38:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     syzbot <syzbot+2990ca6e76c080858a9c@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, glider@google.com, hpa@zytor.com,
        jpoimboe@redhat.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, mbenes@suse.cz, mhiramat@kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org, rppt@linux.ibm.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Subject: Re: KASAN: stack-out-of-bounds Read in update_stack_state
Message-ID: <20191220203847.08267447@rorschach.local.home>
In-Reply-To: <000000000000a3c3ef059a1e4260@google.com>
References: <001a1143e62e6f71d20565bf329f@google.com>
        <000000000000a3c3ef059a1e4260@google.com>
X-Mailer: Claws Mail 3.17.4git76 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


What's the actual bug? "stack-out-of-bounds" is rather useless without
any actual output dump. But that's besides the point, this commit is
*extremely* unlikely to be the culprit.

-- Steve


On Fri, 20 Dec 2019 00:14:01 -0800
syzbot <syzbot+2990ca6e76c080858a9c@syzkaller.appspotmail.com> wrote:

> syzbot suspects this bug was fixed by commit:
> 
> commit 4ee7c60de83ac01fa4c33c55937357601631e8ad
> Author: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Date:   Fri Mar 23 14:18:03 2018 +0000
> 
>      init, tracing: Add initcall trace events
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11ebd0aee00000
> start commit:   0b6b8a3d Merge branch 'bpf-misc-selftest-improvements'
> git tree:       bpf-next
> kernel config:  https://syzkaller.appspot.com/x/.config?x=82a189bf69e089b5
> dashboard link: https://syzkaller.appspot.com/bug?extid=2990ca6e76c080858a9c
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11dde5b3800000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1347b65d800000
> 
> If the result looks correct, please mark the bug fixed by replying with:
> 
> #syz fix: init, tracing: Add initcall trace events
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

