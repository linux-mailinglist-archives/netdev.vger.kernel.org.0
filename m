Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F234BD325
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 02:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242993AbiBUB2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 20:28:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241608AbiBUB2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 20:28:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBA622506;
        Sun, 20 Feb 2022 17:28:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4EBD61012;
        Mon, 21 Feb 2022 01:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30EEAC340F0;
        Mon, 21 Feb 2022 01:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645406898;
        bh=7AR/ouLmEpdgcAQKivaD/RKdGjisVeQ3WHTB+ucfVyg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qi1/ijkzDDV3jD8IvE5sODDEO+GuwQw0SFA8b6Gzoj/V7YORxCI31HnL23kiyql5d
         yuzwqYff3fGsgPqKjS7SzJlVxVdaqIX2kb5I5Qa/vVPKIlAivunc08luplnTvmcroI
         eDfnLdoY58KkReohBFsWMu+pY0tbvmTxoJ6/Qn3c7zEjtUH05mTc9B3p37IdGJXzy/
         wHldnIEjK0aUhroAnAWMRQL7CkxpOARFXn+CLarP0PvngL+UvLbP88sfmPLMgtRzfp
         OmaQ6Usxkx/a7FZ73b8sOIqNUsknaGuMUdylVku9yFY+LLAd6l6A3hWhl8H0xRkVgb
         pEcNXiRUeJ9Ww==
Received: by mail-yb1-f179.google.com with SMTP id p19so31127527ybc.6;
        Sun, 20 Feb 2022 17:28:18 -0800 (PST)
X-Gm-Message-State: AOAM5308HfEsGI73Rp2qbTYDzaFMGaAhj43DJsCoLbF3jSjU8Un8vF3p
        1RVCRaUqRmbgzetvImqMA/WK3QvGeY9yHWtKZYE=
X-Google-Smtp-Source: ABdhPJyzLag8Q652HhIaO5buG/yJ7kKvpFufysTsUgNGWQe0RX15B2I3JHzhmlTG7c4Gu4s6cTVv8DzlpHkl0XhyseM=
X-Received: by 2002:a25:e911:0:b0:61e:128c:bf0d with SMTP id
 n17-20020a25e911000000b0061e128cbf0dmr16516965ybd.257.1645406897175; Sun, 20
 Feb 2022 17:28:17 -0800 (PST)
MIME-Version: 1.0
References: <20220220184055.3608317-1-trix@redhat.com>
In-Reply-To: <20220220184055.3608317-1-trix@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Sun, 20 Feb 2022 17:28:06 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7j9SK5OJxK-ZnDYgwVhoPJGP8K+1Q+pUJ8mGUA41ZvHQ@mail.gmail.com>
Message-ID: <CAPhsuW7j9SK5OJxK-ZnDYgwVhoPJGP8K+1Q+pUJ8mGUA41ZvHQ@mail.gmail.com>
Subject: Re: [PATCH] bpf: cleanup comments
To:     trix@redhat.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 20, 2022 at 10:41 AM <trix@redhat.com> wrote:
>
> From: Tom Rix <trix@redhat.com>
>
> Add leading space to spdx tag
> Use // for spdx c file comment
>
> Replacements
> resereved to reserved
> inbetween to in between
> everytime to every time

I think everytime could be a single word? Other than that,

Acked-by: Song Liu <songliubraving@fb.com>

> intutivie to intuitive
> currenct to current
> encontered to encountered
> referenceing to referencing
> upto to up to
> exectuted to executed
>
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  kernel/bpf/bpf_local_storage.c | 2 +-
>  kernel/bpf/btf.c               | 6 +++---
>  kernel/bpf/cgroup.c            | 8 ++++----
>  kernel/bpf/hashtab.c           | 2 +-
>  kernel/bpf/helpers.c           | 2 +-
>  kernel/bpf/local_storage.c     | 2 +-
>  kernel/bpf/reuseport_array.c   | 2 +-
>  kernel/bpf/syscall.c           | 2 +-
>  kernel/bpf/trampoline.c        | 2 +-
>  9 files changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
> index 71de2a89869c..092a1ac772d7 100644
> --- a/kernel/bpf/bpf_local_storage.c
> +++ b/kernel/bpf/bpf_local_storage.c
> @@ -136,7 +136,7 @@ bool bpf_selem_unlink_storage_nolock(struct bpf_local_storage *local_storage,
>                  * will be done by the caller.
>                  *
>                  * Although the unlock will be done under
> -                * rcu_read_lock(),  it is more intutivie to
> +                * rcu_read_lock(),  it is more intuitive to
>                  * read if the freeing of the storage is done
>                  * after the raw_spin_unlock_bh(&local_storage->lock).
>                  *
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 02d7014417a0..8b11d1a9bee1 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> +// SPDX-License-Identifier: GPL-2.0
>  /* Copyright (c) 2018 Facebook */
>
>  #include <uapi/linux/btf.h>
> @@ -2547,7 +2547,7 @@ static int btf_ptr_resolve(struct btf_verifier_env *env,
>          *
>          * We now need to continue from the last-resolved-ptr to
>          * ensure the last-resolved-ptr will not referring back to
> -        * the currenct ptr (t).
> +        * the current ptr (t).
>          */
>         if (btf_type_is_modifier(next_type)) {
>                 const struct btf_type *resolved_type;
> @@ -6148,7 +6148,7 @@ int btf_type_snprintf_show(const struct btf *btf, u32 type_id, void *obj,
>
>         btf_type_show(btf, type_id, obj, (struct btf_show *)&ssnprintf);
>
> -       /* If we encontered an error, return it. */
> +       /* If we encountered an error, return it. */
>         if (ssnprintf.show.state.status)
>                 return ssnprintf.show.state.status;
>
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 098632fdbc45..128028efda64 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -1031,7 +1031,7 @@ int cgroup_bpf_prog_query(const union bpf_attr *attr,
>   * __cgroup_bpf_run_filter_skb() - Run a program for packet filtering
>   * @sk: The socket sending or receiving traffic
>   * @skb: The skb that is being sent or received
> - * @type: The type of program to be exectuted
> + * @type: The type of program to be executed
>   *
>   * If no socket is passed, or the socket is not of type INET or INET6,
>   * this function does nothing and returns 0.
> @@ -1094,7 +1094,7 @@ EXPORT_SYMBOL(__cgroup_bpf_run_filter_skb);
>  /**
>   * __cgroup_bpf_run_filter_sk() - Run a program on a sock
>   * @sk: sock structure to manipulate
> - * @type: The type of program to be exectuted
> + * @type: The type of program to be executed
>   *
>   * socket is passed is expected to be of type INET or INET6.
>   *
> @@ -1119,7 +1119,7 @@ EXPORT_SYMBOL(__cgroup_bpf_run_filter_sk);
>   *                                       provided by user sockaddr
>   * @sk: sock struct that will use sockaddr
>   * @uaddr: sockaddr struct provided by user
> - * @type: The type of program to be exectuted
> + * @type: The type of program to be executed
>   * @t_ctx: Pointer to attach type specific context
>   * @flags: Pointer to u32 which contains higher bits of BPF program
>   *         return value (OR'ed together).
> @@ -1166,7 +1166,7 @@ EXPORT_SYMBOL(__cgroup_bpf_run_filter_sock_addr);
>   * @sock_ops: bpf_sock_ops_kern struct to pass to program. Contains
>   * sk with connection information (IP addresses, etc.) May not contain
>   * cgroup info if it is a req sock.
> - * @type: The type of program to be exectuted
> + * @type: The type of program to be executed
>   *
>   * socket passed is expected to be of type INET or INET6.
>   *
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index d29af9988f37..65877967f414 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -1636,7 +1636,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
>                 value_size = size * num_possible_cpus();
>         total = 0;
>         /* while experimenting with hash tables with sizes ranging from 10 to
> -        * 1000, it was observed that a bucket can have upto 5 entries.
> +        * 1000, it was observed that a bucket can have up to 5 entries.
>          */
>         bucket_size = 5;
>
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 49817755b8c3..ae64110a98b5 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -1093,7 +1093,7 @@ struct bpf_hrtimer {
>  struct bpf_timer_kern {
>         struct bpf_hrtimer *timer;
>         /* bpf_spin_lock is used here instead of spinlock_t to make
> -        * sure that it always fits into space resereved by struct bpf_timer
> +        * sure that it always fits into space reserved by struct bpf_timer
>          * regardless of LOCKDEP and spinlock debug flags.
>          */
>         struct bpf_spin_lock lock;
> diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
> index 23f7f9d08a62..497916060ac7 100644
> --- a/kernel/bpf/local_storage.c
> +++ b/kernel/bpf/local_storage.c
> @@ -1,4 +1,4 @@
> -//SPDX-License-Identifier: GPL-2.0
> +// SPDX-License-Identifier: GPL-2.0
>  #include <linux/bpf-cgroup.h>
>  #include <linux/bpf.h>
>  #include <linux/bpf_local_storage.h>
> diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
> index 556a769b5b80..962556917c4d 100644
> --- a/kernel/bpf/reuseport_array.c
> +++ b/kernel/bpf/reuseport_array.c
> @@ -143,7 +143,7 @@ static void reuseport_array_free(struct bpf_map *map)
>
>         /*
>          * Once reaching here, all sk->sk_user_data is not
> -        * referenceing this "array".  "array" can be freed now.
> +        * referencing this "array".  "array" can be freed now.
>          */
>         bpf_map_area_free(array);
>  }
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 35646db3d950..ce4657a00dae 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2562,7 +2562,7 @@ static int bpf_link_alloc_id(struct bpf_link *link)
>   * pre-allocated resources are to be freed with bpf_cleanup() call. All the
>   * transient state is passed around in struct bpf_link_primer.
>   * This is preferred way to create and initialize bpf_link, especially when
> - * there are complicated and expensive operations inbetween creating bpf_link
> + * there are complicated and expensive operations in between creating bpf_link
>   * itself and attaching it to BPF hook. By using bpf_link_prime() and
>   * bpf_link_settle() kernel code using bpf_link doesn't have to perform
>   * expensive (and potentially failing) roll back operations in a rare case
> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 7224691df2ec..0b41fa993825 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -45,7 +45,7 @@ void *bpf_jit_alloc_exec_page(void)
>
>         set_vm_flush_reset_perms(image);
>         /* Keep image as writeable. The alternative is to keep flipping ro/rw
> -        * everytime new program is attached or detached.
> +        * every time new program is attached or detached.
>          */
>         set_memory_x((long)image, 1);
>         return image;
> --
> 2.26.3
>
