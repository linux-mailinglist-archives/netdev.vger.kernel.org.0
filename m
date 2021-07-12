Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56EC3C409C
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 02:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhGLAxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 20:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhGLAxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 20:53:22 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C879C0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 17:50:35 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id w14so13374606edc.8
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 17:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TGZyvYtPzx3751nxqpTMYt8p3E9sqxh9cCXYBgCGZrk=;
        b=uwth3/0qJsrJozYSA1PePJQdq7hcyEiZUgTsj29YNDtxGgv+k2Qyxv0Z4qP7wHRWQ6
         LPrDcM3w872HmMC9Gts5egjmmk5t4IavWkkLxCPjyoAeAeGkHMnRJBJVoYFbdxdG4GlG
         T6LN5OaX9gYZgOMe2wbdzPn8ZZQ6bOcM2vCz9Vsv6Y6m/SWHttcucqWWbze00KaQgi/n
         MVpUqX1pqawyJDWuaRqWLp7AqV2YvzeuY17qRTrym8T2wn5D6XORBoopXpOTFuh9Bof3
         DbWTGPY2czXQp4ThCUSfXbDZHpzI5rGWp76DIOugGgukMghQ+iXvFGJJGoKrEKFPKGA4
         i+0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TGZyvYtPzx3751nxqpTMYt8p3E9sqxh9cCXYBgCGZrk=;
        b=oYyKZnxeWF1l0kF0eo7SpNfmbyxm2NMEKGcwueDeJuEZ0zbQ+8O9uEiHmNpDyhTOMJ
         zPECk3OWyqSvf0sFElyAOgrcJrJzS+lOIgXc7JUHYDdw9cjw66VVG8o2HIRXDNr7gIbK
         RaKNWyEOG1oDff0iO8cQ6iCzeK581aKIKBpsHEES+4D+ywSFQFkj1KSezOcq4byhtANU
         c/DQQLig4mMpaBwTGHPH+9BZdr74xWjo9nVizCYsZd4jjMM552yi3adjyXDczW4FdyGb
         T0zI9pvA9el6JgZrpSguaqT4+ZH3NbPT2MzhyfmaKiQK8j+b1nIvXFxRbhWuxBA1JUtb
         toyQ==
X-Gm-Message-State: AOAM531g0A+P/kKSHictHTumVudC5EE14WBm6KsSXaBFaw8Fa4IjKUk2
        iuGCjSQV3eDhdDXvTMz4o1Tj5Bkldk6QhoG38Nw=
X-Google-Smtp-Source: ABdhPJypG9d6vlPoaScYIYNnxYkdrXfPtSJdlIK8t1DByqLuw48ODGroVVwROfLAPP1n5lHfyRJrb+LzvfaVkyfq4nE=
X-Received: by 2002:a05:6402:74c:: with SMTP id p12mr4685092edy.153.1626051033775;
 Sun, 11 Jul 2021 17:50:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210711190308.8476-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210711190308.8476-1-xiyou.wangcong@gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 12 Jul 2021 08:49:57 +0800
Message-ID: <CAMDZJNWWq2TGb6-nZRbBNfLevOyD2oSn941Nw_+7q0QzVep_GA@mail.gmail.com>
Subject: Re: [Patch net-next v2] net_sched: introduce tracepoint trace_qdisc_enqueue()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 3:03 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> From: Qitao Xu <qitao.xu@bytedance.com>
>
> Tracepoint trace_qdisc_enqueue() is introduced to trace skb at
> the entrance of TC layer on TX side. This is kinda symmetric to
> trace_qdisc_dequeue(), and together they can be used to calculate
> the packet queueing latency. It is more accurate than
> trace_net_dev_queue(), because we already successfully enqueue
> the packet at that point.
>
> Note, trace ring buffer is only accessible to privileged users,
> it is safe to use %px to print a real kernel address here.
>
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
> ---
>  include/trace/events/qdisc.h | 26 ++++++++++++++++++++++++++
>  net/core/dev.c               |  9 +++++++++
>  2 files changed, 35 insertions(+)
>
> diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
> index 58209557cb3a..c3006c6b4a87 100644
> --- a/include/trace/events/qdisc.h
> +++ b/include/trace/events/qdisc.h
> @@ -46,6 +46,32 @@ TRACE_EVENT(qdisc_dequeue,
>                   __entry->txq_state, __entry->packets, __entry->skbaddr )
>  );
>
> +TRACE_EVENT(qdisc_enqueue,
> +
> +       TP_PROTO(struct Qdisc *qdisc, const struct netdev_queue *txq, struct sk_buff *skb),
> +
> +       TP_ARGS(qdisc, txq, skb),
> +
> +       TP_STRUCT__entry(
> +               __field(struct Qdisc *, qdisc)
> +               __field(void *, skbaddr)
> +               __field(int, ifindex)
> +               __field(u32, handle)
> +               __field(u32, parent)
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->qdisc = qdisc;
> +               __entry->skbaddr = skb;
> +               __entry->ifindex = txq->dev ? txq->dev->ifindex : 0;
> +               __entry->handle  = qdisc->handle;
> +               __entry->parent  = qdisc->parent;
> +       ),
Hi qitao, cong
Why not support the txq, we get more info from txq.
and we should take care of the return value of q->enqueue, because we
can know what happens in the qdisc queue(not necessary to work with
qdisc:dequeue).
and we can use a tracepoint filter for the return value too.
we should introduce a new function to instead of now codes, that may
make the codes clean.  Please review my patch for more info.
https://patchwork.kernel.org/project/netdevbpf/patch/20210711050007.1200-1-xiangxia.m.yue@gmail.com/

> +       TP_printk("enqueue ifindex=%d qdisc handle=0x%X parent=0x%X skbaddr=%px",
> +                 __entry->ifindex, __entry->handle, __entry->parent, __entry->skbaddr)
> +);
> +
>  TRACE_EVENT(qdisc_reset,
>
>         TP_PROTO(struct Qdisc *q),
> diff --git a/net/core/dev.c b/net/core/dev.c
> index c253c2aafe97..20b9376de301 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -131,6 +131,7 @@
>  #include <trace/events/napi.h>
>  #include <trace/events/net.h>
>  #include <trace/events/skb.h>
> +#include <trace/events/qdisc.h>
>  #include <linux/inetdevice.h>
>  #include <linux/cpu_rmap.h>
>  #include <linux/static_key.h>
> @@ -3864,6 +3865,8 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
>                         if (unlikely(!nolock_qdisc_is_empty(q))) {
>                                 rc = q->enqueue(skb, q, &to_free) &
>                                         NET_XMIT_MASK;
> +                               if (rc == NET_XMIT_SUCCESS)
> +                                       trace_qdisc_enqueue(q, txq, skb);
>                                 __qdisc_run(q);
>                                 qdisc_run_end(q);
>
> @@ -3880,6 +3883,9 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
>                 }
>
>                 rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
> +               if (rc == NET_XMIT_SUCCESS)
> +                       trace_qdisc_enqueue(q, txq, skb);
> +
>                 qdisc_run(q);
>
>  no_lock_out:
> @@ -3924,6 +3930,9 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
>                 rc = NET_XMIT_SUCCESS;
>         } else {
>                 rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
> +               if (rc == NET_XMIT_SUCCESS)
> +                       trace_qdisc_enqueue(q, txq, skb);
> +
>                 if (qdisc_run_begin(q)) {
>                         if (unlikely(contended)) {
>                                 spin_unlock(&q->busylock);
> --
> 2.27.0
>


-- 
Best regards, Tonghao
