Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A893C415E
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 05:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhGLDKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 23:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbhGLDKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 23:10:09 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D081C0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 20:07:21 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id t3so25520933edt.12
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 20:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ssH8ptmoQhA6p/LFbdLTB163RMPw9fs6azOc/Eb1CIY=;
        b=pX4irEL10dpV9+x0ZWiTegz010TVLnUxgebI8Zu8NRCLn9GQYyVFIgeDRT5/SHKfJD
         5WP9JSDMhe4B4/6hocBv++2nhXpUxFOJgWmAxBIZ8kdS706wrB1s6QX8hyaQ2dxBcp2k
         guKqABZs29zyAv0Mnj0temA4LOMUigsXqjq4i+8A7tdji0CYtaT6li26iFv8GbjBcGXJ
         gdjqa/w1uP6xYw/QVBK1NyaO6jkP8Mlg8sgl3mod5LZrLRaGyjpuxtWmTpfMXTszTLDe
         K4RBjIHobNapIlIfJ9qOxR062ijFuefa8P+8PsMgZXPBoBwl9xjQXCVuRCORVjNtyGq0
         N6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ssH8ptmoQhA6p/LFbdLTB163RMPw9fs6azOc/Eb1CIY=;
        b=SLvnr9NPwcmc1N4HIB3R5aegG0EzvEOiEf8FX5CTARXLChH0yyHMEaMpdX45cF7fiH
         84LmmVT2+EswDLPD6xMkisNCGOCldPvPq/Q6M2GJoVLrSAbYYPEl/YjpKZSHd2KWq1hN
         sxszWEwIXJ1RAlKfwgsehfm9HzkhVSYrwmAImwvP7EKw3X4IC7T3IO6856RTDh6mFdvk
         EInXN5GUc4wuThpc6ag88uYjNCNstSK0P0MPViE4WxPC1vKfVBTXh5D+lc/39XK6J6pY
         osSwxGQBn5cneNytmQW0U8/b2OxzU8aU4igw3pC6mhAvVIB4gn1B3iF6N4gAsTFmjRda
         VJig==
X-Gm-Message-State: AOAM530f8TOD57fKu4tDMe/QPqBqsRElNoAJ/gnF8jR6zMh0NVfMjc7s
        zCrudjlTDaIpRwmDG9M4ca1GIlT25w2/Qw5eceE=
X-Google-Smtp-Source: ABdhPJzzqO+u0ZzJSRZmonCrAzIqACnndJ3IhLS6bmBEdpn0gw7zz6bCQfu+Fr4UmtMnAnWEgLxxj5zNTG3/VuzTQPo=
X-Received: by 2002:a05:6402:168f:: with SMTP id a15mr34207260edv.3.1626059239655;
 Sun, 11 Jul 2021 20:07:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210711190308.8476-1-xiyou.wangcong@gmail.com> <40afda00-0737-d4cc-e801-85a7544fb26b@huawei.com>
In-Reply-To: <40afda00-0737-d4cc-e801-85a7544fb26b@huawei.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 12 Jul 2021 11:06:43 +0800
Message-ID: <CAMDZJNUDZBdJChwDBqGKUmQ0XCsir=501ffh6Ohcp02ALgbmYg@mail.gmail.com>
Subject: Re: [Patch net-next v2] net_sched: introduce tracepoint trace_qdisc_enqueue()
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 11:01 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/7/12 3:03, Cong Wang wrote:
> > From: Qitao Xu <qitao.xu@bytedance.com>
> >
> > Tracepoint trace_qdisc_enqueue() is introduced to trace skb at
> > the entrance of TC layer on TX side. This is kinda symmetric to
> > trace_qdisc_dequeue(), and together they can be used to calculate
> > the packet queueing latency. It is more accurate than
> > trace_net_dev_queue(), because we already successfully enqueue
> > the packet at that point.
> >
> > Note, trace ring buffer is only accessible to privileged users,
> > it is safe to use %px to print a real kernel address here.
> >
> > Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> > Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> > Cc: Jiri Pirko <jiri@resnulli.us>
> > Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
> > ---
> >  include/trace/events/qdisc.h | 26 ++++++++++++++++++++++++++
> >  net/core/dev.c               |  9 +++++++++
> >  2 files changed, 35 insertions(+)
> >
> > diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
> > index 58209557cb3a..c3006c6b4a87 100644
> > --- a/include/trace/events/qdisc.h
> > +++ b/include/trace/events/qdisc.h
> > @@ -46,6 +46,32 @@ TRACE_EVENT(qdisc_dequeue,
> >                 __entry->txq_state, __entry->packets, __entry->skbaddr )
> >  );
> >
> > +TRACE_EVENT(qdisc_enqueue,
> > +
> > +     TP_PROTO(struct Qdisc *qdisc, const struct netdev_queue *txq, struct sk_buff *skb),
> > +
> > +     TP_ARGS(qdisc, txq, skb),
> > +
> > +     TP_STRUCT__entry(
> > +             __field(struct Qdisc *, qdisc)
> > +             __field(void *, skbaddr)
> > +             __field(int, ifindex)
> > +             __field(u32, handle)
> > +             __field(u32, parent)
> > +     ),
> > +
> > +     TP_fast_assign(
> > +             __entry->qdisc = qdisc;
> > +             __entry->skbaddr = skb;
> > +             __entry->ifindex = txq->dev ? txq->dev->ifindex : 0;
> > +             __entry->handle  = qdisc->handle;
> > +             __entry->parent  = qdisc->parent;
> > +     ),
> > +
> > +     TP_printk("enqueue ifindex=%d qdisc handle=0x%X parent=0x%X skbaddr=%px",
> > +               __entry->ifindex, __entry->handle, __entry->parent, __entry->skbaddr)
> > +);
> > +
> >  TRACE_EVENT(qdisc_reset,
> >
> >       TP_PROTO(struct Qdisc *q),
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index c253c2aafe97..20b9376de301 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -131,6 +131,7 @@
> >  #include <trace/events/napi.h>
> >  #include <trace/events/net.h>
> >  #include <trace/events/skb.h>
> > +#include <trace/events/qdisc.h>
> >  #include <linux/inetdevice.h>
> >  #include <linux/cpu_rmap.h>
> >  #include <linux/static_key.h>
> > @@ -3864,6 +3865,8 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
> >                       if (unlikely(!nolock_qdisc_is_empty(q))) {
> >                               rc = q->enqueue(skb, q, &to_free) &
> >                                       NET_XMIT_MASK;
> > +                             if (rc == NET_XMIT_SUCCESS)
>
> If NET_XMIT_CN is returned, the skb seems to be enqueued too?
>
> Also instead of checking the rc before calling the trace_*, maybe
> it make more sense to add the rc to the tracepoint, so that the checking
> is avoided, and we are able to tell the enqueuing result of a specific skb
> from that tracepoint too.
Yes, I will fix it.
> > +                                     trace_qdisc_enqueue(q, txq, skb);
>
> Does it make sense to wrap the about to something like:
>
> int sch_enqueue(....)
> {
>         rc = q->enqueue(skb, q, &to_free)..
>         ....
>         trace_qdisc_enqueue(q, txq, skb);
> }
Yes, I agree, my patch uses qdisc_enqueue_skb, because __dev_xmit_skb
invoke the qdisc_xxx api.

https://patchwork.kernel.org/project/netdevbpf/patch/20210711050007.1200-1-xiangxia.m.yue@gmail.com/
> So that the below code can reuse that wrapper too.
>
> >                               __qdisc_run(q);
> >                               qdisc_run_end(q);
> >
> > @@ -3880,6 +3883,9 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
> >               }
> >
> >               rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
> > +             if (rc == NET_XMIT_SUCCESS)
> > +                     trace_qdisc_enqueue(q, txq, skb);
> > +
> >               qdisc_run(q);
> >
> >  no_lock_out:
> > @@ -3924,6 +3930,9 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
> >               rc = NET_XMIT_SUCCESS;
> >       } else {
> >               rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
> > +             if (rc == NET_XMIT_SUCCESS)
> > +                     trace_qdisc_enqueue(q, txq, skb);
> > +
> >               if (qdisc_run_begin(q)) {
> >                       if (unlikely(contended)) {
> >                               spin_unlock(&q->busylock);
> >



-- 
Best regards, Tonghao
