Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BF3243E85
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 19:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgHMRxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 13:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgHMRxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 13:53:23 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36392C061757
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 10:53:23 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id r21so5480506ota.10
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 10:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=0Y7ZZzFE4/GZsUZH4v5qVegGosVQgNjWarPTJp+oYeE=;
        b=Xy2SHnAi92W19wMljVNifnRrqkYgYhXGS+873QcgzCTrc6kDVQJ8bmmxtUzDY96n+N
         8oSrK4iFxAEtwdMtnaPPRva/o3QVgrH/quWq1vfRMrNFQb5r2KRY+OE24NYdkpH26Vxa
         T61edBTUd2E72TK3IGc0jHNble4ejOa8atJaqg9FRK/mfIuoKlPYi9cusDwYLi7I2/be
         3JEO/bQ6Yu2rPa81xpBfRgrqvwMNFRozAQ6ZYRrjQQFjBcMM8p3RnE5rqlkeqLfgx64R
         hT3Rfez732luwbA4QMYtNJ0SP/A+4VnsYEq2BT2LPTN80/0hOvdVMAz0Niaa6ysTUa9O
         SFmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=0Y7ZZzFE4/GZsUZH4v5qVegGosVQgNjWarPTJp+oYeE=;
        b=Uh6BwpRsQpeG+oO663Xe9bRR6rZ8rkaFL9w7+czZPL/Pbz+IEQYHdzt2KbMspK73xF
         HPIjY+Ne48lJxHIgIL3lpDTmBQ4nB7MNWmlNjMEXsFAUn9wau2Ro89CM1NPTMPLkmZtf
         TCaMuO/8/hxMBTuChJjJ/5g2HuzkuxvWyLsxikezVSggHCNNA7aBb8N+TwPQvYsXYyWn
         wJk3DrtpAG9UKTmOrWdrgNvgcVZPx2tURDZK5iOUzkBwAhD2CfFrkYK4GaQ/Ncyu9nxK
         6TAQFpgdgDAf4LHsIXcoX+Rt0ZZlAFCyGb0T4f4aRXll91QSfj8POhVzJPBtD+APjQS2
         jAeQ==
X-Gm-Message-State: AOAM532ZSN5NOAyR9gJRzuRFQ0nNzrHkcotbZk/cg+R1yzJ+qP7N31fk
        eKOCLjSN9GkOVjuMEyq7KBO1TPYSqov2Funf+co=
X-Google-Smtp-Source: ABdhPJwbtECB4HOu/steMNQ4KEXuggKLL8GPrW03HbUOLANjzs52EC9eYAEWkG64/efOES1/gra/AHE+7kpB3hcB0B0=
X-Received: by 2002:a9d:7997:: with SMTP id h23mr5703269otm.28.1597341202588;
 Thu, 13 Aug 2020 10:53:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200813170643.4031609-1-edumazet@google.com>
In-Reply-To: <20200813170643.4031609-1-edumazet@google.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 13 Aug 2020 19:53:11 +0200
Message-ID: <CA+icZUVXFFi8Cs=-=y08ZFryqhhXuBCc_pG1r6h8KzBvsZddnQ@mail.gmail.com>
Subject: Re: [PATCH net] random32: add a tracepoint for prandom_u32()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Willy Tarreau <w@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 7:06 PM Eric Dumazet <edumazet@google.com> wrote:
>
> There has been some heat around prandom_u32() lately, and some people
> were wondering if there was a simple way to determine how often
> it was used, before considering making it maybe 10 times more expensive.
>
> This tracepoint exports the generated pseudo random value.
>
> Tested:
>
> perf list | grep prandom_u32
>   random:prandom_u32                                 [Tracepoint event]
>
> perf record -a [-g] [-C1] -e random:prandom_u32 sleep 1
> [ perf record: Woken up 0 times to write data ]
> [ perf record: Captured and wrote 259.748 MB perf.data (924087 samples) ]
>
> perf report --nochildren
>     ...
>     97.67%  ksoftirqd/1     [kernel.vmlinux]  [k] prandom_u32
>             |
>             ---prandom_u32
>                prandom_u32
>                |
>                |--48.86%--tcp_v4_syn_recv_sock
>                |          tcp_check_req
>                |          tcp_v4_rcv
>                |          ...
>                 --48.81%--tcp_conn_request
>                           tcp_v4_conn_request
>                           tcp_rcv_state_process
>                           ...
> perf script
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Willy Tarreau <w@1wt.eu>
> Cc: Sedat Dilek <sedat.dilek@gmail.com>

Thanks for the patch and embedding a list of instructions with linux-perf.

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

- Sedat -

> ---
> According to MAINTAINERS, lib/random32.c is part of networking...
>
>  include/trace/events/random.h | 17 +++++++++++++++++
>  lib/random32.c                |  2 ++
>  2 files changed, 19 insertions(+)
>
> diff --git a/include/trace/events/random.h b/include/trace/events/random.h
> index 32c10a515e2d5438e8d620a0c2313aab5f849b2b..9570a10cb949b5792c4290ba8e82a077ac655069 100644
> --- a/include/trace/events/random.h
> +++ b/include/trace/events/random.h
> @@ -307,6 +307,23 @@ TRACE_EVENT(urandom_read,
>                   __entry->pool_left, __entry->input_left)
>  );
>
> +TRACE_EVENT(prandom_u32,
> +
> +       TP_PROTO(unsigned int ret),
> +
> +       TP_ARGS(ret),
> +
> +       TP_STRUCT__entry(
> +               __field(   unsigned int, ret)
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->ret = ret;
> +       ),
> +
> +       TP_printk("ret=%u" , __entry->ret)
> +);
> +
>  #endif /* _TRACE_RANDOM_H */
>
>  /* This part must be outside protection */
> diff --git a/lib/random32.c b/lib/random32.c
> index 3d749abb9e80d54d8e330e07fb8b773b7bec2b83..932345323af092a93fc2690b0ebbf4f7485ae4f3 100644
> --- a/lib/random32.c
> +++ b/lib/random32.c
> @@ -39,6 +39,7 @@
>  #include <linux/random.h>
>  #include <linux/sched.h>
>  #include <asm/unaligned.h>
> +#include <trace/events/random.h>
>
>  #ifdef CONFIG_RANDOM32_SELFTEST
>  static void __init prandom_state_selftest(void);
> @@ -82,6 +83,7 @@ u32 prandom_u32(void)
>         u32 res;
>
>         res = prandom_u32_state(state);
> +       trace_prandom_u32(res);
>         put_cpu_var(net_rand_state);
>
>         return res;
> --
> 2.28.0.220.ged08abb693-goog
>
