Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0431901B7
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 00:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgCWXPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 19:15:07 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:36261 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbgCWXPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 19:15:07 -0400
Received: by mail-oi1-f196.google.com with SMTP id k18so16698751oib.3;
        Mon, 23 Mar 2020 16:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6XMWmroL8l0RyumbjJQMXqqTUiBB/qlm/O2qNYaLqxs=;
        b=g8kc3zua4EN8yhOvo2P3ovQ9jQiLF1szvCtR0XEAsm2wMuvlYDYuPxGBRsqxzKJYAc
         4a8I/I1nB/5+ffpBCTbehxZMdRsEs5jDx8VXGxIpnr/pX1NWDroh7ehtXRMgebkoDF7v
         OF/gFgMQO+/FTOwAnTZFGFbdjxYcN36Vxa5uvKHsqmvOczR1Gr+g1CE0EkglFWDZu0ar
         w2H7QtmFhbbXIJxc03vwj/bJKZsYR9Yku5oeuUldltz66QFsel1OFFSyapHhEc1AZdCH
         BBRZCUvFw2sxxd+XzJfR0S3ROcjZQIG6dRQaQtNOJPXdBIYd9pSRQspP4PoetbNQFy8a
         zVbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6XMWmroL8l0RyumbjJQMXqqTUiBB/qlm/O2qNYaLqxs=;
        b=E6JFiZKmK7hDstkb0iwl7k6qzyZyfupsbHl4nIjfpcbC/tByR9q4cRrOdwg+YwdpyX
         DaKYLSCANevHcuJdOrqIVY5F+VU/3kZRNtwa/SSoXuNv1Au8yawTMtoIhoFoJq6Nz07L
         X8HcPXmUqn0IvCTvstVHOUQDu1uJd4zFTT2Tv/HVornwWL7YmHJYg9CVmzQunjObXnR0
         j9BCVG63n6M3UvmWz6nOTYWHUFbyYwISNfS7aLv0b5Ujirs9IzqAViBSPfz/QUK1Y4kd
         0Z6IvFxaZDh32LAygUE41EH99G4ba9F7D1BA3nfKgxPJ5hWS4KX0KPT3rSehRkihVhkQ
         DkNA==
X-Gm-Message-State: ANhLgQ3GnL11xzeooI0GvOCkh9toHnhPqQzL0rXmA1MrBcDkSZAoHx09
        qh1c92J/SALwukZl1PmBstWvWjHz+Nc9YgH4hehSWXipJRk=
X-Google-Smtp-Source: ADFU+vsCvY8CERQTDQlrKdJLytsSH5SaPe5yKhe7yF4Vu8cMX0/43dpVL+a9smxjTpswrL8zHcQe8jyN/jLIT0u9XcE=
X-Received: by 2002:a05:6808:648:: with SMTP id z8mr1417673oih.72.1585005306171;
 Mon, 23 Mar 2020 16:15:06 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000742e9e05a10170bc@google.com> <87a74arown.fsf@nanos.tec.linutronix.de>
 <CAM_iQpV3S0xv5xzSrA5COYa3uyy_TBGpDA9Wcj9Qt_vn1n3jBQ@mail.gmail.com> <87ftdypyec.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87ftdypyec.fsf@nanos.tec.linutronix.de>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 23 Mar 2020 16:14:55 -0700
Message-ID: <CAM_iQpVR8Ve3Jy8bb9VB6RcQ=p22ZTyTqjxJxL11RZmO7rkWeg@mail.gmail.com>
Subject: Re: WARNING: ODEBUG bug in tcindex_destroy_work (3)
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     syzbot <syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 2:14 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Cong Wang <xiyou.wangcong@gmail.com> writes:
> > On Sat, Mar 21, 2020 at 3:19 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> >> > ------------[ cut here ]------------
> >> > ODEBUG: free active (active state 0) object type: work_struct hint: tcindex_destroy_rexts_work+0x0/0x20 net/sched/cls_tcindex.c:143
> >> ...
> >> >  __debug_check_no_obj_freed lib/debugobjects.c:967 [inline]
> >> >  debug_check_no_obj_freed+0x2e1/0x445 lib/debugobjects.c:998
> >> >  kfree+0xf6/0x2b0 mm/slab.c:3756
> >> >  tcindex_destroy_work+0x2e/0x70 net/sched/cls_tcindex.c:231
> >>
> >> So this is:
> >>
> >>         kfree(p->perfect);
> >>
> >> Looking at the place which queues that work:
> >>
> >> tcindex_destroy()
> >>
> >>    if (p->perfect) {
> >>         if (tcf_exts_get_net(&r->exts))
> >>             tcf_queue_work(&r-rwork, tcindex_destroy_rexts_work);
> >>         else
> >>             __tcindex_destroy_rexts(r)
> >>    }
> >>
> >>    .....
> >>
> >>    tcf_queue_work(&p->rwork, tcindex_destroy_work);
> >>
> >> So obviously if tcindex_destroy_work() runs before
> >> tcindex_destroy_rexts_work() then the above happens.
> >
> > We use an ordered workqueue for tc filters, so these two
> > works are executed in the same order as they are queued.
>
> The workqueue is ordered, but look how the work is queued on the work
> queue:
>
> tcf_queue_work()
>   queue_rcu_work()
>     call_rcu(&rwork->rcu, rcu_work_rcufn);
>
> So after the grace period elapses rcu_work_rcufn() queues it in the
> actual work queue.
>
> Now tcindex_destroy() is invoked via tcf_proto_destroy() which can be
> invoked from preemtible context. Now assume the following:
>
> CPU0
>   tcf_queue_work()
>     tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);
>
> -> Migration
>
> CPU1
>    tcf_queue_work(&p->rwork, tcindex_destroy_work);
>
> So your RCU callbacks can be placed on different CPUs which obviously
> has no ordering guarantee at all. See also:

Good catch!

I thought about this when I added this ordered workqueue, but it
seems I misinterpret max_active, so despite we have max_active==1,
more than 1 work could still be queued on different CPU's here.

I don't know how to fix this properly, I think essentially RCU work
should be guaranteed the same ordering with regular work. But this
seems impossible unless RCU offers some API to achieve that.

Thanks.
