Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA7A273117
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 19:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgIURq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 13:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgIURqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 13:46:55 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF21C061755;
        Mon, 21 Sep 2020 10:46:55 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id a2so10911519ybj.2;
        Mon, 21 Sep 2020 10:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HfNt5vWZDR1lPA9FbgPQ9vu/5UtFcllE18mjzZBY4VY=;
        b=XamGuM61FfYdCU5XYshINnAeV85OwYt7gJkZjZ9Wu0CJpNLUzEFsiPibEKZJYgmi9f
         a2UijcEpAAdeJkJnVXzEt4euFQ7tYbZ4TfBjBhmWr8+cOoyNNAo/CYzyE2eTfOXgXIoG
         opa32nuPaepbwiHeRXqc42xj0x6xMNj3FRjcKtqiDWq4sPQHdGEkqXq0XjbWjNyRcdkS
         OKBWm/mPNU1zkihytYgZXlNmQo34fCJpYUIRFUJ2MVv+rkc0GjBXvmfvDKUf3wmIw3HX
         7f8eUD4ZtxO9JyY66jv/bP71L8Pts977mL9eW6w/qQxlQtgI5LT+knmcC+/23zL7UcOo
         dOeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HfNt5vWZDR1lPA9FbgPQ9vu/5UtFcllE18mjzZBY4VY=;
        b=SFuDl8taPD4QcNWRzI5uBGvIlenQka0lBfD+Rj82Chz1cYmwcfSVzpDKL64ufh6+cx
         ECh/Tt8XooPaUzjNm4quKtivW5DWhyFtZ7YzPLeYhIqVslQjK246KHJrar49RkPspUzT
         nK4Tu5ua+WBUkrPprEz+tD4jfWllvxlYygduVFoVMxsahhmruZBTUoTBqLsxP2sb+6fW
         yg1ujlAQmD3uObi7T8PFWp+wKaIdPucaQkY/TOnuOUTqSXUu8mKe2i9+yU0PK//doN5v
         KITgEgnm04t7WTvRA1tNyeo0CEkuPIAf/Pg9/xq8Mcv8KjTSzQlJMxZ/H05HCnWfbI1X
         pO1g==
X-Gm-Message-State: AOAM531ckby8QihVlYu5Cga2Guvz51JyoY4cJ3qkoEZc/ENyLAQ7JYhz
        oHN2nN+QCsMXF1iYCJr1UeuaXVsk5t23baiKgLw=
X-Google-Smtp-Source: ABdhPJwFof1Jm1VlOQYcd/UAhg0TU3xozlDHOgPmLh5i5rouLBioL6SolvBnnApuIqZuL5UeNHmhMU35oODmhcIoyjI=
X-Received: by 2002:a25:730a:: with SMTP id o10mr1354044ybc.403.1600710413382;
 Mon, 21 Sep 2020 10:46:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200916223512.2885524-1-haoluo@google.com> <20200916223512.2885524-2-haoluo@google.com>
In-Reply-To: <20200916223512.2885524-2-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Sep 2020 10:46:42 -0700
Message-ID: <CAEf4BzayCya8R1PBisbDpZZmnKuiQkNgXQk1ZSpjDBHP2BSRiw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/6] bpf: Introduce pseudo_btf_id
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
> Pseudo_btf_id is a type of ld_imm insn that associates a btf_id to a
> ksym so that further dereferences on the ksym can use the BTF info
> to validate accesses. Internally, when seeing a pseudo_btf_id ld insn,
> the verifier reads the btf_id stored in the insn[0]'s imm field and
> marks the dst_reg as PTR_TO_BTF_ID. The btf_id points to a VAR_KIND,
> which is encoded in btf_vminux by pahole. If the VAR is not of a struct
> type, the dst reg will be marked as PTR_TO_MEM instead of PTR_TO_BTF_ID
> and the mem_size is resolved to the size of the VAR's type.
>
> From the VAR btf_id, the verifier can also read the address of the
> ksym's corresponding kernel var from kallsyms and use that to fill
> dst_reg.
>
> Therefore, the proper functionality of pseudo_btf_id depends on (1)
> kallsyms and (2) the encoding of kernel global VARs in pahole, which
> should be available since pahole v1.18.
>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---

Looks good, few minor nits if you are going to post another version
anyways. Assuming BPF offload change I mentioned is ok:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf_verifier.h   |   7 ++
>  include/linux/btf.h            |  15 ++++
>  include/uapi/linux/bpf.h       |  36 +++++++---
>  kernel/bpf/btf.c               |  15 ----
>  kernel/bpf/verifier.c          | 125 +++++++++++++++++++++++++++++----
>  tools/include/uapi/linux/bpf.h |  36 +++++++---
>  6 files changed, 188 insertions(+), 46 deletions(-)
>
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index 53c7bd568c5d..6a9dd0279ea4 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -308,6 +308,13 @@ struct bpf_insn_aux_data {
>                         u32 map_index;          /* index into used_maps[] */
>                         u32 map_off;            /* offset from value base address */
>                 };
> +               struct {
> +                       u32 reg_type;           /* type of pseudo_btf_id */

nit: there is an explicit enum for this: enum bpf_reg_type, which
matches struct bpf_reg_state's type field as well.

> +                       union {
> +                               u32 btf_id;     /* btf_id for struct typed var */
> +                               u32 mem_size;   /* mem_size for non-struct typed var */
> +                       };
> +               } btf_var;
>         };
>         u64 map_key_state; /* constant (32 bit) key tracking for maps */
>         int ctx_field_size; /* the ctx field size for load insn, maybe 0 */

[...]


> +/* replace pseudo btf_id with kernel symbol address */
> +static int check_pseudo_btf_id(struct bpf_verifier_env *env,
> +                              struct bpf_insn *insn,
> +                              struct bpf_insn_aux_data *aux)
> +{
> +       u32 type, id = insn->imm;
> +       const struct btf_type *t;
> +       const char *sym_name;
> +       u64 addr;
> +
> +       if (!btf_vmlinux) {
> +               verbose(env, "kernel is missing BTF, make sure CONFIG_DEBUG_INFO_BTF=y is specified in Kconfig.\n");
> +               return -EINVAL;
> +       }
> +
> +       t = btf_type_by_id(btf_vmlinux, id);
> +       if (!t) {
> +               verbose(env, "ldimm64 insn specifies invalid btf_id %d.\n", id);
> +               return -ENOENT;
> +       }
> +
> +       if (insn[1].imm != 0) {
> +               verbose(env, "reserved field (insn[1].imm) is used in pseudo_btf_id ldimm64 insn.\n");
> +               return -EINVAL;
> +       }

nit: I'd do this check first, before you look up type and check all
other type-related conditions

> +
> +       if (!btf_type_is_var(t)) {
> +               verbose(env, "pseudo btf_id %d in ldimm64 isn't KIND_VAR.\n",
> +                       id);
> +               return -EINVAL;
> +       }
> +
> +       sym_name = btf_name_by_offset(btf_vmlinux, t->name_off);
> +       addr = kallsyms_lookup_name(sym_name);
> +       if (!addr) {
> +               verbose(env, "ldimm64 failed to find the address for kernel symbol '%s'.\n",
> +                       sym_name);
> +               return -ENOENT;
> +       }
> +
> +       insn[0].imm = (u32)addr;
> +       insn[1].imm = addr >> 32;
> +

[...]

> @@ -9442,6 +9533,14 @@ static int replace_map_fd_with_map_ptr(struct bpf_verifier_env *env)
>                                 /* valid generic load 64-bit imm */
>                                 goto next_insn;
>
> +                       if (insn[0].src_reg == BPF_PSEUDO_BTF_ID) {
> +                               aux = &env->insn_aux_data[i];
> +                               err = check_pseudo_btf_id(env, insn, aux);
> +                               if (err)
> +                                       return err;
> +                               goto next_insn;
> +                       }
> +
>                         /* In final convert_pseudo_ld_imm64() step, this is
>                          * converted into regular 64-bit imm load insn.
>                          */
> @@ -11392,10 +11491,6 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
>         if (is_priv)
>                 env->test_state_freq = attr->prog_flags & BPF_F_TEST_STATE_FREQ;
>
> -       ret = replace_map_fd_with_map_ptr(env);
> -       if (ret < 0)
> -               goto skip_full_check;

I'm not familiar with BPF offload stuff, so just flagging a change
here: previously offloaded BPF programs, when passed to offload's
verifier prep routine would already have ldimm64 processes, now they
won't. This might not be an issue and not an expectation we want, but
it would be nice if someone who knows something about offload stuff
confirms that this is ok.

> -
>         if (bpf_prog_is_dev_bound(env->prog->aux)) {
>                 ret = bpf_prog_offload_verifier_prep(env->prog);
>                 if (ret)

[...]
