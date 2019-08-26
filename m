Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C08769C89A
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 07:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbfHZFJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 01:09:39 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35579 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfHZFJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 01:09:38 -0400
Received: by mail-qk1-f194.google.com with SMTP id r21so13154068qke.2;
        Sun, 25 Aug 2019 22:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TBEOvdoLNe1qfiVMds/VbTtIZXLa2zKzed0sDJqRzB4=;
        b=O8pZWJ07jCOdR/fC0rgdNBps/m/jT2jh8B8PXh8ksZly5pwKLWfZ8idtCa34jcqLae
         28XHiEF5+YgGPAuyn0wAPfZJ36Jtpx46/jYzJEP7+fQvconpC2CIf9y1mTyxWk924zMQ
         VuOSt4Y7e2T0pEUC387gOlCCCYnTZU9dyrXfWMQZZ8+K2Lbhj57uGHLdeHhQoSGHqgKr
         uXv9DRZ4krMxubZUxQd/GtdsssfypnP1FdpM7SIrhSItxPl5QBK28YlWC6gAwxwpzq3e
         BchlTTLcts6vkcf0al1mUK/7KjU4dxoMlN1Icn4eVzx4ZfTrWpTcszNOzG3XdwYQkJpH
         JVTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TBEOvdoLNe1qfiVMds/VbTtIZXLa2zKzed0sDJqRzB4=;
        b=X/Ltg6mlU2OGgNw5bxO1lbPpz8NcemnCgzwhpZ4OI7IUMtzXj4c5HvoPeHtxBss0qF
         HQXwPw16Ic45INy+S0V2tNNOlGEdmUuxrkjTSrJ1v3uxoCwl+01eLhL28ExjdeSgxx+T
         WxIxKfNk4LJHzZgSwSAOd/Zn8Y9QrsGAz2CVPRMTQG8H9T5CUAkywhqYp0yfBblZdFa4
         2oQA7sGUL3LkUMbBkHqgVUlTssduxJFkY530zXvNccBDu6/jOhuvzDCcz/37OSstOvvR
         azUjZiF0LlnAfdg6utNZ/GsMFtSlkdJq9XJ0yFrbSngh9ygD/TM5JH/UEeoOTTfjZ1Vg
         TzcQ==
X-Gm-Message-State: APjAAAX8Jzxxk4tD5j8ow9y1WDCqo8EWLVT2cS7ovspO1Rp/dmXmMMMS
        G9dXoKG6abCQl1gYaZ/BnNTwPAGGE7LsLpQ+sc4=
X-Google-Smtp-Source: APXvYqwsWpwpqf5Vxa5Xi/4NgnWtexFtqs7Sl8llUrVPPe2b68u5nr+zSPect+8Ro8WwXOvd1mGQIAQpj5j8Z77vEMs=
X-Received: by 2002:ae9:e8d6:: with SMTP id a205mr13764789qkg.241.1566796177705;
 Sun, 25 Aug 2019 22:09:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190823055215.2658669-1-ast@kernel.org> <20190823055215.2658669-2-ast@kernel.org>
In-Reply-To: <20190823055215.2658669-2-ast@kernel.org>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Sun, 25 Aug 2019 22:09:26 -0700
Message-ID: <CAPhsuW6qXqY9u488xVLBis0JMybyfp6kubmN8GEMPH6oVcOX0A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: introduce verifier internal test flag
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 23, 2019 at 2:59 AM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Introduce BPF_F_TEST_STATE_FREQ flag to stress test parentage chain
> and state pruning.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  include/linux/bpf_verifier.h | 1 +
>  include/uapi/linux/bpf.h     | 3 +++
>  kernel/bpf/syscall.c         | 1 +
>  kernel/bpf/verifier.c        | 5 ++++-
>  4 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index 5fe99f322b1c..26a6d58ca78c 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -355,6 +355,7 @@ struct bpf_verifier_env {
>         struct bpf_verifier_stack_elem *head; /* stack of verifier states to be processed */
>         int stack_size;                 /* number of states to be processed */
>         bool strict_alignment;          /* perform strict pointer alignment checks */
> +       bool test_state_freq;           /* test verifier with different pruning frequency */
>         struct bpf_verifier_state *cur_state; /* current verifier state */
>         struct bpf_verifier_state_list **explored_states; /* search pruning optimization */
>         struct bpf_verifier_state_list *free_list;
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index b5889257cc33..5d2fb183ee2d 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -285,6 +285,9 @@ enum bpf_attach_type {
>   */
>  #define BPF_F_TEST_RND_HI32    (1U << 2)
>
> +/* The verifier internal test flag. Behavior is undefined */
> +#define BPF_F_TEST_STATE_FREQ  (1U << 3)
> +
>  /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
>   * two extensions:
>   *
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index c0f62fd67c6b..ca60eafa6922 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1629,6 +1629,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
>
>         if (attr->prog_flags & ~(BPF_F_STRICT_ALIGNMENT |
>                                  BPF_F_ANY_ALIGNMENT |
> +                                BPF_F_TEST_STATE_FREQ |
>                                  BPF_F_TEST_RND_HI32))
>                 return -EINVAL;
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 16d66bd7af09..3fb50757e812 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7223,7 +7223,7 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
>         struct bpf_verifier_state_list *sl, **pprev;
>         struct bpf_verifier_state *cur = env->cur_state, *new;
>         int i, j, err, states_cnt = 0;
> -       bool add_new_state = false;
> +       bool add_new_state = env->test_state_freq ? true : false;
>
>         cur->last_insn_idx = env->prev_insn_idx;
>         if (!env->insn_aux_data[insn_idx].prune_point)
> @@ -9263,6 +9263,9 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
>
>         env->allow_ptr_leaks = is_priv;
>
> +       if (is_priv)
> +               env->test_state_freq = attr->prog_flags & BPF_F_TEST_STATE_FREQ;
> +
>         ret = replace_map_fd_with_map_ptr(env);
>         if (ret < 0)
>                 goto skip_full_check;
> --
> 2.20.0
>
