Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDB9136FB0
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 15:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgAJOpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 09:45:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:42096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728002AbgAJOpH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 09:45:07 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E00372072E;
        Fri, 10 Jan 2020 14:45:04 +0000 (UTC)
Date:   Fri, 10 Jan 2020 09:45:02 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     syzbot <syzbot+704bfe2c7d156640ad7a@syzkaller.appspotmail.com>
Cc:     acme@kernel.org, acme@redhat.com,
        alexander.shishkin@linux.intel.com, arvid.brodin@alten.se,
        ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, jbacik@fb.com, jolsa@redhat.com, kafai@fb.com,
        kernel-team@fb.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
        peterz@infradead.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, xiyou.wangcong@gmail.com, yhs@fb.com
Subject: Re: WARNING in add_event_to_ctx
Message-ID: <20200110094502.2d6015ab@gandalf.local.home>
In-Reply-To: <000000000000ddae64059bc388dc@google.com>
References: <000000000000946842058bc1291d@google.com>
        <000000000000ddae64059bc388dc@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 09 Jan 2020 22:50:00 -0800
syzbot <syzbot+704bfe2c7d156640ad7a@syzkaller.appspotmail.com> wrote:

> syzbot suspects this bug was fixed by commit:

I think these reports need some more information. Like the sample crash
report, so we don't need to be clicking through links to find it.
Because I have no idea what bug was fixed.

-- Steve

> 
> commit 311633b604063a8a5d3fbc74d0565b42df721f68
> Author: Cong Wang <xiyou.wangcong@gmail.com>
> Date:   Wed Jul 10 06:24:54 2019 +0000
> 
>      hsr: switch ->dellink() to ->ndo_uninit()
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1005033ee00000
> start commit:   6fbc7275 Linux 5.2-rc7
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bff6583efcfaed3f
> dashboard link: https://syzkaller.appspot.com/bug?extid=704bfe2c7d156640ad7a
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1016165da00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12b27be5a00000
> 
> If the result looks correct, please mark the bug fixed by replying with:
> 
> #syz fix: hsr: switch ->dellink() to ->ndo_uninit()
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

