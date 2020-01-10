Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDCA137088
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgAJPBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:01:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:56794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728152AbgAJPBy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 10:01:54 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DDC02072E;
        Fri, 10 Jan 2020 15:01:51 +0000 (UTC)
Date:   Fri, 10 Jan 2020 10:01:49 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+704bfe2c7d156640ad7a@syzkaller.appspotmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        arvid.brodin@alten.se, Alexei Starovoitov <ast@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Josef Bacik <jbacik@fb.com>, jolsa@redhat.com,
        Martin KaFai Lau <kafai@fb.com>, kernel-team@fb.com,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Yonghong Song <yhs@fb.com>
Subject: Re: WARNING in add_event_to_ctx
Message-ID: <20200110100149.58ef4893@gandalf.local.home>
In-Reply-To: <CACT4Y+Z2M3p+26KROAAnGH-HuuWZdu8Cx1TrN7YhWTh9Exj+rQ@mail.gmail.com>
References: <000000000000946842058bc1291d@google.com>
        <000000000000ddae64059bc388dc@google.com>
        <20200110094502.2d6015ab@gandalf.local.home>
        <CACT4Y+Z2M3p+26KROAAnGH-HuuWZdu8Cx1TrN7YhWTh9Exj+rQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jan 2020 15:48:34 +0100
Dmitry Vyukov <dvyukov@google.com> wrote:

> On Fri, Jan 10, 2020 at 3:45 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Thu, 09 Jan 2020 22:50:00 -0800
> > syzbot <syzbot+704bfe2c7d156640ad7a@syzkaller.appspotmail.com> wrote:
> >  
> > > syzbot suspects this bug was fixed by commit:  
> >
> > I think these reports need some more information. Like the sample crash
> > report, so we don't need to be clicking through links to find it.
> > Because I have no idea what bug was fixed.  
> 
> Hi Steve,
> 
> Isn't it threaded to the original report in your client? The message
> has both matching subject and In-Reply-To header. At least that was
> the idea.
> 

Ah, if I go to lore.kernel.org, I see the original report. But that's
from back in June. I only keep up to two months of emails before I
archive them.

Perhaps add something like:

 Original report: https://lore.kernel.org/bpf/000000000000946842058bc1291d@google.com/

?

Thanks!

-- Steve
