Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8941C61F1
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbgEEUZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726350AbgEEUZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:25:37 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24D0C061A0F;
        Tue,  5 May 2020 13:25:37 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id s9so3797949qkm.6;
        Tue, 05 May 2020 13:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=31quMcEe+xzAma9ThSUMOHC1dZ8mo7IqQp3gHntaaWE=;
        b=knFnGONGR9cy6HQzfwvysX837qMuCzYoUNoTkhR3UlkerBlgOL81mhisLn4ESXVROO
         yKys/zNRz8vm1WsfvY0gnKW0cFxHxfu/rV25EUYxuoEsB4sRox04ZlG0K4M2FJnzSSBd
         USeXfUeu0oXrYvhwrUQlT9DpziS5SyJvGKRZ9/H7MX+hT3QNTwGcxq68H3lrRabYMJo2
         hbngezUVVxqjpQWzpmu4zYjMAfizmoTx7C5mY9UrXFq8X/8ijrIflQYqIx0j9egE7HHP
         yN/8bjxhRe7GDuc0kl71z5S5CxGQ5iGk3JsHQPhRGReX8LCVZ+Bmm8aDjOsu58cY7Udx
         G6lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=31quMcEe+xzAma9ThSUMOHC1dZ8mo7IqQp3gHntaaWE=;
        b=M775OpJ8EPYUMmJeOzEUwyLcHDPO9BACrHSGmAifIgJEy4P/X2LvosVzah0A4LmH4O
         RCZT1m/0xzoeyrvhCKfY4Wj2QUv5eXl+cPY7hgDf910pU03dvUl5D9GkCIS+73c/Cmfj
         beAprhdAsYeRuPkLOYB/9VDk9IUhY+w25Hy4Cis2SSh2vCiBDVDu/7YU1kQNbZvsE5cv
         5xk1LFmi9rm0BAuZz7BzZJTDMzEMW6nFrc+p1+S7PdpBZzx0yPdxHQ54E1FFzM1snRUv
         rrY3/KnVcOOtuDNdqI2UcYAIIMILGIAp9+AcRALNxfQzzdC21NTEuATObtqT/YOTgbAS
         tscw==
X-Gm-Message-State: AGi0PuYfsiON01I62NIiOnHgMJrWy/XFhZmz2rnVVT5R8Y5WFkz3y1Z+
        zZsjas33ydasrj22i92SYgolGvNfEeNyyWSSPqrndA==
X-Google-Smtp-Source: APiQypK0K9lHXQaunJT8xUuY3/xAByv3/y+rPLG6IKETIukm8oiJg7MtOyLfwe8PrSyOwUH0A1NAHcq0xeE+RQugcYM=
X-Received: by 2002:ae9:e713:: with SMTP id m19mr5427278qka.39.1588710336853;
 Tue, 05 May 2020 13:25:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062555.2048028-1-yhs@fb.com>
In-Reply-To: <20200504062555.2048028-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 May 2020 13:25:25 -0700
Message-ID: <CAEf4BzZnzKrTX4sN+PJC8fhdv=+gXMTAan=OUfgRFtvusfnaWQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 08/20] bpf: implement common macros/helpers
 for target iterators
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 3, 2020 at 11:28 PM Yonghong Song <yhs@fb.com> wrote:
>
> Macro DEFINE_BPF_ITER_FUNC is implemented so target
> can define an init function to capture the BTF type
> which represents the target.
>
> The bpf_iter_meta is a structure holding meta data, common
> to all targets in the bpf program.
>
> Additional marker functions are called before/after
> bpf_seq_read() show() and stop() callback functions
> to help calculate precise seq_num and whether call bpf_prog
> inside stop().
>
> Two functions, bpf_iter_get_info() and bpf_iter_run_prog(),
> are implemented so target can get needed information from
> bpf_iter infrastructure and can run the program.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h   | 11 +++++
>  kernel/bpf/bpf_iter.c | 94 ++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 100 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 26daf85cba10..70c71c3cd9e8 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1129,6 +1129,9 @@ int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
>  int bpf_obj_get_user(const char __user *pathname, int flags);
>
>  #define BPF_ITER_FUNC_PREFIX "__bpf_iter__"
> +#define DEFINE_BPF_ITER_FUNC(target, args...)                  \
> +       extern int __bpf_iter__ ## target(args);                \
> +       int __init __bpf_iter__ ## target(args) { return 0; }

Why is extern declaration needed here? Doesn't the same macro define
global function itself? I'm probably missing some C semantics thingy,
sorry...

>
>  typedef int (*bpf_iter_init_seq_priv_t)(void *private_data);
>  typedef void (*bpf_iter_fini_seq_priv_t)(void *private_data);
> @@ -1141,11 +1144,19 @@ struct bpf_iter_reg {
>         u32 seq_priv_size;
>  };
>
> +struct bpf_iter_meta {
> +       __bpf_md_ptr(struct seq_file *, seq);
> +       u64 session_id;
> +       u64 seq_num;
> +};
> +

[...]

>  /* bpf_seq_read, a customized and simpler version for bpf iterator.
>   * no_llseek is assumed for this file.
>   * The following are differences from seq_read():
> @@ -83,12 +119,15 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
>         if (!p || IS_ERR(p))
>                 goto Stop;
>
> +       bpf_iter_inc_seq_num(seq);

so seq_num is one-based, not zero-based? So on first show() call it
will be set to 1, not 0, right?

>         err = seq->op->show(seq, p);
>         if (seq_has_overflowed(seq)) {
> +               bpf_iter_dec_seq_num(seq);
>                 err = -E2BIG;
>                 goto Error_show;
>         } else if (err) {
>                 /* < 0: go out, > 0: skip */
> +               bpf_iter_dec_seq_num(seq);
>                 if (likely(err < 0))
>                         goto Error_show;
>                 seq->count = 0;

[...]
