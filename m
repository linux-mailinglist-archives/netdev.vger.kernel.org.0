Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33119159970
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 20:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731496AbgBKTMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 14:12:22 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42908 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730438AbgBKTMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 14:12:22 -0500
Received: by mail-qk1-f194.google.com with SMTP id q15so11215008qke.9;
        Tue, 11 Feb 2020 11:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OkdVz6fGH6pCPGelsMO9o5gr+Wm+OlxlgEUIcxl58Co=;
        b=kQ2+yJQIRJZg95YFB8IAvZswoBEdjV+IZbKbKKh5mGZO+YaWgPmp5ZnekV5ETCnpMy
         RK4OVfDPjKJzKfOSy7mNIjz/do33hO8IqE4TaY327lyJzRDWHFrvSK/71MtvvT14jalH
         wtqRrDTkQsKUg0xGcqUyX9FYEk/1dTkZFeCl0gwQACPCsd6O8kQpnU/wADggj036PoGE
         TgpdPklFoLYbimrIIaOcaFwdcyue6mQOU8aOtl22g//o9C0hli9qsBrQIbLVPBitPIR0
         zpkWYwJhO9OBHZ0ESHDfy3bs6cttzMw0LzVGliOZBb7pOXPQ1MSUijAa4mCCXPNg/DHP
         taxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OkdVz6fGH6pCPGelsMO9o5gr+Wm+OlxlgEUIcxl58Co=;
        b=UeEhlJH8lYnT1AmIEm6FDE8Ra8pReEKQhY1ft8Zvs9XmhSDdCr0wBzZuecMMHUvYAH
         NaEvj8x5oGBajC9kooTVTL90TjwmKH2C/2qZl5CvbC894w4E1SaJcAMPDhl0g+wN4JsM
         Wm4CyvOJkQhUYPqDTD2ByTIm4sGM5UAs+OMafz20O5rDYw0i8nVXu96BMN52ct0UsNDw
         ZBFoyEBG18j2ZQjk/rh0tI5La29/PfPwLdhv6PjMsA5nlpz34q7ulfaJzAFJyx+29PLh
         EhMl4eFGQG7CtFrxdeWf4u7RiExKfsN5EYg7APqnNyqz4k5myhq0+tWVOSSgNyaSJf+I
         IWmA==
X-Gm-Message-State: APjAAAVOk620dg87/LUy6gU28zO8xUTEL1Lr2HLwHUjenAjT1C2NoW93
        H9jSjXMJ1xLcXeqIqFWGvxb5jqxcrswhwUQZOM8=
X-Google-Smtp-Source: APXvYqy+JgFM7MtJ25oKg8PPKPWIvcJ4nCH3r3iga19Iu6U0daagkQO7kPUjNhoGelfQ36i8LTUfifPRdPBMbQlUrfU=
X-Received: by 2002:ae9:eb48:: with SMTP id b69mr7633506qkg.39.1581448340092;
 Tue, 11 Feb 2020 11:12:20 -0800 (PST)
MIME-Version: 1.0
References: <20200208154209.1797988-1-jolsa@kernel.org> <20200208154209.1797988-15-jolsa@kernel.org>
In-Reply-To: <20200208154209.1797988-15-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 11 Feb 2020 11:12:09 -0800
Message-ID: <CAEf4BzYfSDc1PEBgFVAApN=8qVLjoE_fXV1x3e_p+7vwpQ_bag@mail.gmail.com>
Subject: Re: [PATCH 14/14] bpf: Sort bpf kallsyms symbols
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 8, 2020 at 7:43 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Currently we don't sort bpf_kallsyms and display symbols
> in proc/kallsyms as they come in via __bpf_ksym_add.
>
> Using the latch tree to get the next bpf_ksym object
> and insert the new symbol ahead of it.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/core.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 50af5dcf7ff9..c63ff34b2128 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -651,9 +651,30 @@ static struct latch_tree_root bpf_progs_tree __cacheline_aligned;
>
>  static void __bpf_ksym_add(struct bpf_ksym *ksym)
>  {
> +       struct list_head *head = &bpf_kallsyms;
> +
>         WARN_ON_ONCE(!list_empty(&ksym->lnode));
> -       list_add_tail_rcu(&ksym->lnode, &bpf_kallsyms);
>         latch_tree_insert(&ksym->tnode, &bpf_kallsyms_tree, &bpf_kallsyms_tree_ops);
> +
> +       /*
> +        * Add ksym into bpf_kallsyms in ordered position,
> +        * which is prepared for us by latch tree addition.
> +        *
> +        * Find out the next symbol and insert ksym right
> +        * ahead of it. If ksym is the last one, just tail
> +        * add to the bpf_kallsyms.
> +        */
> +       if (!list_empty(&bpf_kallsyms)) {

nit: this is a bit redundant check (and unlikely to be false)

> +               struct rb_node *next = rb_next(&ksym->tnode.node[0]);
> +
> +               if (next) {
> +                       struct bpf_ksym *ptr;
> +
> +                       ptr = container_of(next, struct bpf_ksym, tnode.node[0]);
> +                       head = &ptr->lnode;
> +               }
> +       }
> +       list_add_tail_rcu(&ksym->lnode, head);
>  }
>
>  void bpf_ksym_add(struct bpf_ksym *ksym)
> --
> 2.24.1
>
