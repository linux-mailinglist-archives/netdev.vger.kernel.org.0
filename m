Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03918273184
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 20:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbgIUSJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 14:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgIUSJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 14:09:03 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F4DC061755;
        Mon, 21 Sep 2020 11:09:03 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id x20so10948136ybs.8;
        Mon, 21 Sep 2020 11:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QfbGCX6rqAMLLO8aYfzPvTkabfO3m4G1Ikaa+c1SMFA=;
        b=I63BIIi2ifvm4BeL/sZ8GMRz2Mp1eeAloeKVVTDIlh1Q+9PU7cHSZK+vBbsGPhxW9I
         y4/LIeiZQX59dqUIp/49lv6cimW1Trchwa3Fbm555mpL4NeXi2uOlDvil8hhbWq4igf0
         f8c4rL/VCX9AkJ0GaqPDYksTuVmA8Tt6x3hTLPyuFhwJ5m3glhEPd/aRl2DB/W4d5siL
         LAV52saBl52USloVnPWqKg0YUvYsiGW1tmurjYqtBZwDTfazr+oXkZdDOK7ssl/JdPOH
         XYD7GKiUgkuXtqG9kY11dC8eHoljKep5hebFYpd1OqIe4+w9ego42GSzaFiwcdfPrydT
         bOaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QfbGCX6rqAMLLO8aYfzPvTkabfO3m4G1Ikaa+c1SMFA=;
        b=HuiyKg8BTGHy/I0g4HPclZs1RgIDFzXmcuJ8dhxNKUyqgiCYJ8lFtBY2HDAyL5rLkA
         XQ8CDoS9Ufjbs4aX8kKz8xb8J6chdNnCJfzsvCNxjvgrgCi+CeECOhQeS+AhXxgrDYzP
         T+Y5bSN/92UEXU3PGX0drlKCJBHHNnyA8L4hAzvegU6c0pNt5eDbdDbOsgb9gIEedVEh
         krALhLRVOshgP80jk7/eNUQV7yIPhGHT30dOmjub+J6CNXZFAC3lsEmWPFWndr36uZ7C
         P7JeX2OmMHGfd034BhMXS6UpOIZ2OXNgtoDG+EIPQsNRlA7j37RuvPt+QOcVGpn1/+ej
         ucgg==
X-Gm-Message-State: AOAM530BkQL1R9j2+2rDdxmvX1y3Ms+GR/PjHXLx9xJxuXnVhsLj2JPb
        TfgTq3AYufDY04d9U6BIZ8NhhgHjG0XsAiSLofqpD6G9N9Q=
X-Google-Smtp-Source: ABdhPJy5hPMYFdwvUUs9y7HP9iFro0OtSXFlPovkff0E8NtjsKQAA1topvkUtqkO9JS6VvFYUEWJUpTz+o+7NOCG4Hc=
X-Received: by 2002:a25:4446:: with SMTP id r67mr1484677yba.459.1600711742376;
 Mon, 21 Sep 2020 11:09:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200916223512.2885524-1-haoluo@google.com> <20200916223512.2885524-5-haoluo@google.com>
In-Reply-To: <20200916223512.2885524-5-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Sep 2020 11:08:51 -0700
Message-ID: <CAEf4BzbJFE+Yxsy+VEwr-2_JcACh+jbn4WyiS+ECnVVNjC=bnA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 4/6] bpf: Introduce bpf_per_cpu_ptr()
To:     Hao Luo <haoluo@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 3:39 PM Hao Luo <haoluo@google.com> wrote:
>
> Add bpf_per_cpu_ptr() to help bpf programs access percpu vars.
> bpf_per_cpu_ptr() has the same semantic as per_cpu_ptr() in the kernel
> except that it may return NULL. This happens when the cpu parameter is
> out of range. So the caller must check the returned value.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>  include/linux/bpf.h            |  4 +++
>  include/linux/btf.h            | 11 ++++++
>  include/uapi/linux/bpf.h       | 18 ++++++++++
>  kernel/bpf/btf.c               | 10 ------
>  kernel/bpf/helpers.c           | 18 ++++++++++
>  kernel/bpf/verifier.c          | 64 ++++++++++++++++++++++++++++++++--
>  kernel/trace/bpf_trace.c       |  2 ++
>  tools/include/uapi/linux/bpf.h | 18 ++++++++++
>  8 files changed, 132 insertions(+), 13 deletions(-)
>

I already acked this, but see my concern about O(N) look up for
.data..percpu. Feel free to follow up on this with a separate patch.
Thanks!

[...]

> @@ -4003,6 +4008,15 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>                         if (type != expected_type)
>                                 goto err_type;
>                 }
> +       } else if (arg_type == ARG_PTR_TO_PERCPU_BTF_ID) {
> +               expected_type = PTR_TO_PERCPU_BTF_ID;
> +               if (type != expected_type)
> +                       goto err_type;
> +               if (!reg->btf_id) {
> +                       verbose(env, "Helper has invalid btf_id in R%d\n", regno);
> +                       return -EACCES;
> +               }
> +               meta->ret_btf_id = reg->btf_id;

FYI, this will conflict with Lorenz's refactoring, so you might need
to rebase and solve the conflicts if his patch set lands first.

>         } else if (arg_type == ARG_PTR_TO_BTF_ID) {
>                 bool ids_match = false;
>
> @@ -5002,6 +5016,30 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
>                 regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
>                 regs[BPF_REG_0].id = ++env->id_gen;
>                 regs[BPF_REG_0].mem_size = meta.mem_size;
> +       } else if (fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL) {
> +               const struct btf_type *t;
> +
> +               mark_reg_known_zero(env, regs, BPF_REG_0);
> +               t = btf_type_skip_modifiers(btf_vmlinux, meta.ret_btf_id, NULL);
> +               if (!btf_type_is_struct(t)) {
> +                       u32 tsize;
> +                       const struct btf_type *ret;
> +                       const char *tname;
> +
> +                       /* resolve the type size of ksym. */
> +                       ret = btf_resolve_size(btf_vmlinux, t, &tsize);
> +                       if (IS_ERR(ret)) {
> +                               tname = btf_name_by_offset(btf_vmlinux, t->name_off);
> +                               verbose(env, "unable to resolve the size of type '%s': %ld\n",
> +                                       tname, PTR_ERR(ret));
> +                               return -EINVAL;
> +                       }
> +                       regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
> +                       regs[BPF_REG_0].mem_size = tsize;
> +               } else {
> +                       regs[BPF_REG_0].type = PTR_TO_BTF_ID_OR_NULL;
> +                       regs[BPF_REG_0].btf_id = meta.ret_btf_id;
> +               }
>         } else if (fn->ret_type == RET_PTR_TO_BTF_ID_OR_NULL) {
>                 int ret_btf_id;
>
> @@ -7413,6 +7451,7 @@ static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
>                         dst_reg->mem_size = aux->btf_var.mem_size;
>                         break;
>                 case PTR_TO_BTF_ID:
> +               case PTR_TO_PERCPU_BTF_ID:
>                         dst_reg->btf_id = aux->btf_var.btf_id;
>                         break;
>                 default:
> @@ -9313,10 +9352,14 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
>                                struct bpf_insn *insn,
>                                struct bpf_insn_aux_data *aux)
>  {
> -       u32 type, id = insn->imm;
> +       u32 datasec_id, type, id = insn->imm;
> +       const struct btf_var_secinfo *vsi;
> +       const struct btf_type *datasec;
>         const struct btf_type *t;
>         const char *sym_name;
> +       bool percpu = false;
>         u64 addr;
> +       int i;
>
>         if (!btf_vmlinux) {
>                 verbose(env, "kernel is missing BTF, make sure CONFIG_DEBUG_INFO_BTF=y is specified in Kconfig.\n");
> @@ -9348,12 +9391,27 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
>                 return -ENOENT;
>         }
>
> +       datasec_id = btf_find_by_name_kind(btf_vmlinux, ".data..percpu",
> +                                          BTF_KIND_DATASEC);

this is a relatively expensive O(N) operation, it probably makes sense
to cache it (there are about 80'000 types now in BTF for my typical
kernel config, so iterating that much for every single ldimm64 for
ksym is kind of expensive.

> +       if (datasec_id > 0) {
> +               datasec = btf_type_by_id(btf_vmlinux, datasec_id);
> +               for_each_vsi(i, datasec, vsi) {
> +                       if (vsi->type == id) {
> +                               percpu = true;
> +                               break;
> +                       }
> +               }
> +       }
> +

[...]
