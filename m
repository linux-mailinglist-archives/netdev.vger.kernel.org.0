Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740794568C6
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 04:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbhKSDuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 22:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbhKSDuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 22:50:04 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD7BC061574;
        Thu, 18 Nov 2021 19:47:03 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id y13so36569480edd.13;
        Thu, 18 Nov 2021 19:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b+ih2j3KcLgWgyGJnTIxRJ/bMFMhbztmPc6a0cULIMQ=;
        b=bnsiieI1ChlXuh+YF42fe0kYvJPNDHG+R0IVCARurF7pEoVhTl1d4fXPFjCryYya4U
         2FXL4vP/Xb6eXsejZ7kweIwQTPOne0rP3HdCcH8uFzuKGTNtwC1KO4okG0b4Wk1H9ZZ+
         wyqL1wRz9zEMbPFPRLW9JHbEVGva1Oqe5Zx/+8s5P3ZF4Lyox8o5bIK7MKfxlWf4Cfnl
         1kIrv+z/Vol0P6rU4X3NdlI4uEb01AEmzwNjomwFBA1JZH3Ja5FpjIFG7JwX+nM9UvPY
         SI1s7iKrHj2i/psYvHB9luLwkAL68SS/H1JlY/UM61M8M8vsINKKV9ukv+rfIusvn5BH
         3npw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b+ih2j3KcLgWgyGJnTIxRJ/bMFMhbztmPc6a0cULIMQ=;
        b=cCQMoRict9bs8GPFBOB3v3vMozXhvYXK9GZZgUw+FykxlZLzk7owYPQZqRVn1adu1+
         FI4Fjho/CIEEa4gx4cRwTcUtPFcJfSoBgOcPCkJ/sfApKQOs9ushjqLMdhKXG6NPJJYc
         egGSJ7UhXtxopj8p8JjO7GpGuPObHF3rGNrJE41X7e2vnah8dN5xP1fgjsSvnkh6GwkP
         2tHUC7Prq6EzoWMV7Kp/rkk1CT+XDhl5ZSgMuCEK3JG6tIPWJk8catfvDXCvittyc9YV
         7O4zMKnUHOv/4Cm613yiB6Ipe9T2P766Co5UF6u+Y6e47U2fHApDZYSYj4a/+aTSeaLH
         u4kw==
X-Gm-Message-State: AOAM530BpWAwMm+A8r/kdqMWjxqgLMXuRrWdWBM+N3Trch5FLi0y40K+
        k4eekmN/PiDdGJn5MaxYR05VV5wVLawXrYmij24=
X-Google-Smtp-Source: ABdhPJzfpJlSlbvE0ljBsMRT13+GhE2cemlZcWWeqdFsety5UM1451jeoH4OuOgO5AEo8kmFEUXiGpNUSZwbhvhUqIE=
X-Received: by 2002:a17:906:58c9:: with SMTP id e9mr3371383ejs.181.1637293621664;
 Thu, 18 Nov 2021 19:47:01 -0800 (PST)
MIME-Version: 1.0
References: <20211118124812.106538-1-imagedong@tencent.com> <67b36bd8-2477-88ac-83a0-35a1eeaf40c9@gmail.com>
In-Reply-To: <67b36bd8-2477-88ac-83a0-35a1eeaf40c9@gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 19 Nov 2021 11:45:40 +0800
Message-ID: <CADxym3ZfBVAecK-oFdMVV2gkOV6iUrq5XGkRZx3yXCuXDOS=2A@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 0/2] net: snmp: tracepoint support for snmp
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>, mingo@redhat.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Menglong Dong <imagedong@tencent.com>,
        Yuchung Cheng <ycheng@google.com>, kuniyu@amazon.co.jp,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello~

On Thu, Nov 18, 2021 at 11:36 PM David Ahern <dsahern@gmail.com> wrote:
>
[...]
>
> there is already good infrastructure around kfree_skb - e.g., drop watch
> monitor. Why not extend that in a way that other drop points can benefit
> over time?
>

Thanks for your advice.

In fact, I don't think that this is a perfect idea. This way may have benefit
of reuse the existing kfree_skb event, but this will do plentiful modification
to the current code. For example, in tcp_v4_rcv(), you need to introduce the
new variate 'int free_reason' and record the drop reason in it, and pass
it to 'kfree_skb_with_reason()' in 'discard_it:'. Many places need this kind
modification. What's more, some statistics don't use 'kfree_skb()'.

However, with the tracepoint for snmp, we just need to pass 'skb' to
'UDP_INC_STATS()/TCP_INC_STATS()', the reason is already included.
This way, the modification is more simple and easier to maintain.

Thanks!
Menglong Dong

> e.g., something like this (uncompiled and not tested; and to which
> Steven is going to suggest strings for the reason):
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 0bd6520329f6..e66e634acad0 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1075,8 +1075,13 @@ static inline bool skb_unref(struct sk_buff *skb)
>         return true;
>  }
>
> +enum skb_drop_reason {
> +       SKB_DROP_REASON_NOT_SPECIFIED,
> +       SKB_DROP_REASON_CSUM,
> +}
>  void skb_release_head_state(struct sk_buff *skb);
>  void kfree_skb(struct sk_buff *skb);
> +void kfree_skb_with_reason(struct sk_buff *skb, enum skb_drop_reason);
>  void kfree_skb_list(struct sk_buff *segs);
>  void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt);
>  void skb_tx_error(struct sk_buff *skb);
> diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
> index 9e92f22eb086..2a2d263f9d46 100644
> --- a/include/trace/events/skb.h
> +++ b/include/trace/events/skb.h
> @@ -14,7 +14,7 @@
>   */
>  TRACE_EVENT(kfree_skb,
>
> -       TP_PROTO(struct sk_buff *skb, void *location),
> +       TP_PROTO(struct sk_buff *skb, void *location, enum
> skb_drop_reason reason),
>
>         TP_ARGS(skb, location),
>
> @@ -22,16 +22,18 @@ TRACE_EVENT(kfree_skb,
>                 __field(        void *,         skbaddr         )
>                 __field(        void *,         location        )
>                 __field(        unsigned short, protocol        )
> +               __field(        unsigned int,   reason          )
>         ),
>
>         TP_fast_assign(
>                 __entry->skbaddr = skb;
>                 __entry->location = location;
>                 __entry->protocol = ntohs(skb->protocol);
> +               __entry->reason = reason;
>         ),
>
> -       TP_printk("skbaddr=%p protocol=%u location=%p",
> -               __entry->skbaddr, __entry->protocol, __entry->location)
> +       TP_printk("skbaddr=%p protocol=%u location=%p reason %u",
> +               __entry->skbaddr, __entry->protocol, __entry->location,
> __entry->reason)
>  );
>
>  TRACE_EVENT(consume_skb,
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 67a9188d8a49..388059bda3d1 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -770,11 +770,29 @@ void kfree_skb(struct sk_buff *skb)
>         if (!skb_unref(skb))
>                 return;
>
> -       trace_kfree_skb(skb, __builtin_return_address(0));
> +       trace_kfree_skb(skb, __builtin_return_address(0),
> SKB_DROP_REASON_NOT_SPECIFIED);
>         __kfree_skb(skb);
>  }
>  EXPORT_SYMBOL(kfree_skb);
>
> +/**
> + *     kfree_skb_with_reason - free an sk_buff
> + *     @skb: buffer to free
> + *     @reason: enum describing why the skb is dropped
> + *
> + *     Drop a reference to the buffer and free it if the usage count has
> + *     hit zero.
> + */
> +void kfree_skb_with_reason(struct sk_buff *skb, enum skb_drop_reason
> reason);
> +{
> +       if (!skb_unref(skb))
> +               return;
> +
> +       trace_kfree_skb(skb, __builtin_return_address(0), reason);
> +       __kfree_skb(skb);
> +}
> +EXPORT_SYMBOL(kfree_skb_with_reason);
> +
>  void kfree_skb_list(struct sk_buff *segs)
>  {
>         while (segs) {
