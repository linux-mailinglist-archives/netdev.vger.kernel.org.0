Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA521204A08
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 08:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730781AbgFWGjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 02:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730635AbgFWGjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 02:39:47 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31548C061573;
        Mon, 22 Jun 2020 23:39:47 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id q198so10028679qka.2;
        Mon, 22 Jun 2020 23:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K5cMJqVzN3arjYaQ/Zr4QTPhysLQIha62w09csW+kTw=;
        b=BQxdyx07A+7SZVrFtiGIA0PBAnP1kUNxyPucyjNLa70LIdgNH437+cGTT5tTy2Wro1
         0NF3KrsIeWR8KFwgs9Je9pSbVOqC0VPPdweH2npu+YugfnSfcFL2Gm7RYX3fWoi+zkw9
         ZUIJtCwy/wnqiYztq6yrHIRTtKQk4qv1SWpuTQux6bKuAkZK8+EzyjHjzCc0QFpPAANT
         6dXotGD8FQOAqwPoUdVGtaJdPgs1WPmDbp2rr+/a5ipzmh0/IJk250q60XucP2drLzEP
         UrrahrWg+Z9HbrgKjY/kaNyv24qaaCFUIPlujV2pmWfww8WR1stugNwvsq4T95ZwnrBN
         x/vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K5cMJqVzN3arjYaQ/Zr4QTPhysLQIha62w09csW+kTw=;
        b=b+lxxsEIBFajMp2S0e7JGTwe5E1kjVQBbkGfZja1bRp3UlZnKRZylHBvWNrwKjjh1h
         1kh0S9Iw+nllHjoeA50evg2rMjqI2whAcJLW5Tb5bUriYpapEQFopkllSpON2tm+CiZ+
         mHcsuzQZc5zjBy4kOMoTzpnOKJAWGjNEkpDs73XM6rwF3MdgqU1OXgwo8WABpWItjM86
         37OQ8YTOJKHfa4xJz2bU45s06s5B5JCYJBFCc7Asz0/hNm7lAuh3LKysk3Y7dJGC6V8O
         RlmdFFOuvdlBkXCzGHs26RGJRN3boWkV3s1aQNf70afDB3S+Tsa+s0xBtWj4R2CGWo1r
         nM1Q==
X-Gm-Message-State: AOAM532LWFAXX9X6NuvdamV9OM52zTTyyzALCbShHmzuVbSdEKiILPAr
        85g0LowqaSQId1TmR/QbO53wQj4/NvXWGOgCuzg=
X-Google-Smtp-Source: ABdhPJx5qiV1SBO3WclwBGRWSoZDoHo8VGSeYh9FVaV12LMN1KqUfMEy3FboNgezCR8+B5EPCa4Q5ZgBccBEWbarUSI=
X-Received: by 2002:a05:620a:2409:: with SMTP id d9mr13039299qkn.36.1592894386003;
 Mon, 22 Jun 2020 23:39:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200623003626.3072825-1-yhs@fb.com> <20200623003631.3073864-1-yhs@fb.com>
In-Reply-To: <20200623003631.3073864-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Jun 2020 23:39:35 -0700
Message-ID: <CAEf4BzaGWuAYzN2-+Gy9X8N2YPb341ZGugKzk78qiPURMgv7rw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 05/15] bpf: add bpf_skc_to_tcp6_sock() helper
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 5:38 PM Yonghong Song <yhs@fb.com> wrote:
>
> The helper is used in tracing programs to cast a socket
> pointer to a tcp6_sock pointer.
> The return value could be NULL if the casting is illegal.
>
> A new helper return type RET_PTR_TO_BTF_ID_OR_NULL is added
> so the verifier is able to deduce proper return types for the helper.
>
> Different from the previous BTF_ID based helpers,
> the bpf_skc_to_tcp6_sock() argument can be several possible
> btf_ids. More specifically, all possible socket data structures
> with sock_common appearing in the first in the memory layout.
> This patch only added socket types related to tcp and udp.
>
> All possible argument btf_id and return value btf_id
> for helper bpf_skc_to_tcp6_sock() are pre-calculcated and
> cached. In the future, it is even possible to precompute
> these btf_id's at kernel build time.
>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Looks good to me as is, but see a few suggestions, they will probably
save me time at some point as well :)

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  include/linux/bpf.h            | 12 +++++
>  include/uapi/linux/bpf.h       |  9 +++-
>  kernel/bpf/btf.c               |  1 +
>  kernel/bpf/verifier.c          | 43 +++++++++++++-----
>  kernel/trace/bpf_trace.c       |  2 +
>  net/core/filter.c              | 80 ++++++++++++++++++++++++++++++++++
>  scripts/bpf_helpers_doc.py     |  2 +
>  tools/include/uapi/linux/bpf.h |  9 +++-
>  8 files changed, 146 insertions(+), 12 deletions(-)
>

[...]

> @@ -4815,6 +4826,18 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
>                 regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
>                 regs[BPF_REG_0].id = ++env->id_gen;
>                 regs[BPF_REG_0].mem_size = meta.mem_size;
> +       } else if (fn->ret_type == RET_PTR_TO_BTF_ID_OR_NULL) {
> +               int ret_btf_id;
> +
> +               mark_reg_known_zero(env, regs, BPF_REG_0);
> +               regs[BPF_REG_0].type = PTR_TO_BTF_ID_OR_NULL;
> +               ret_btf_id = *fn->ret_btf_id;

might be a good idea to check fb->ret_btf_id for NULL and print a
warning + return -EFAULT. It's not supposed to happen on properly
configured kernel, but during development this will save a bunch of
time and frustration for next person trying to add something with
RET_PTR_TO_BTF_ID_OR_NULL.

> +               if (ret_btf_id == 0) {

This also has to be struct/union (after typedef/mods stripping, of
course). Or are there other cases?

> +                       verbose(env, "invalid return type %d of func %s#%d\n",
> +                               fn->ret_type, func_id_name(func_id), func_id);
> +                       return -EINVAL;
> +               }
> +               regs[BPF_REG_0].btf_id = ret_btf_id;
>         } else {
>                 verbose(env, "unknown return type %d of func %s#%d\n",
>                         fn->ret_type, func_id_name(func_id), func_id);

[...]

> +void init_btf_sock_ids(struct btf *btf)
> +{
> +       int i, btf_id;
> +
> +       for (i = 0; i < MAX_BTF_SOCK_TYPE; i++) {
> +               btf_id = btf_find_by_name_kind(btf, bpf_sock_types[i],
> +                                              BTF_KIND_STRUCT);
> +               if (btf_id > 0)
> +                       btf_sock_ids[i] = btf_id;
> +       }
> +}

This will hopefully go away with Jiri's work on static BTF IDs, right?
So looking forward to that :)

> +
> +static bool check_arg_btf_id(u32 btf_id, u32 arg)
> +{
> +       int i;
> +
> +       /* only one argument, no need to check arg */
> +       for (i = 0; i < MAX_BTF_SOCK_TYPE; i++)
> +               if (btf_sock_ids[i] == btf_id)
> +                       return true;
> +       return false;
> +}
> +

[...]
