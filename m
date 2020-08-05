Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E009423C5BD
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 08:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgHEG2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 02:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgHEG2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 02:28:09 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA36C06174A;
        Tue,  4 Aug 2020 23:28:08 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id q3so3778617ybp.7;
        Tue, 04 Aug 2020 23:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yo8mCG1Nlcny+kPn95imsrgp81eugSNVhBCD0NK02D0=;
        b=qYszr9AiqiinEUX4QDOfxArYyr8xgWlOlGXHRiymQ/Yp7pQqxY4emphTZHiO+Ti2nf
         6X0+TshMp6JKN2obVHtGKHBXHzRQt70bAycZ5huTv+y+KK57Se+QoV2N1auiTRdsrJAE
         /0E7j+gCwk59yPSPirlUuOAe2k4I5fyLh84YTwrW0UkXQ9HwVR/1ZCmafpCsm9EGVB1M
         UkFVmJLZUMz3rb/sqiBvOOMPKcndUHCdhpylk9/n2NzGP/IHl8glPxes9UveCU+7A+yN
         WOZ4HM2r1vY6ol47JnZM1r3kQP9GLfq1dq7q82uSIdGxMdxYxmXxonIq4wTB8v6+MavB
         qzSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yo8mCG1Nlcny+kPn95imsrgp81eugSNVhBCD0NK02D0=;
        b=hqqN6kkca0XpODm+BksBytkieOBSjlGtChF6b+461VGN4AbMsihiRysZDb5XkEO3mK
         +Fs2+j7vgunFNCCpOxsvcV6cb1Rx7I/299NcOkngnCrp+P9zlekTK+zmLWuR8S4o1Y3t
         lGFjXop6fT2h2AAQPE0CgyINpJOGJBt1gzpA9yv4KnljK7tka+V7qfs3zpLQdL/bRtRU
         tjJHzzUF3KD80wdnD4u2/PHWc0+3R2yf/bTcCjirUjz3QS+R/IdZZhmRaymoxD7d3QLd
         33wiwh1s4xcD8x6FMk0Vb46f1a+71G0oLS+Tu11YW5/zj3UwG9mmx7kM56HRdWS/1afF
         Gafw==
X-Gm-Message-State: AOAM533iuZjBTnMUOItWi9MTPmZGE9CQf+Du/52ql3CIInI0NrYo5PJP
        t18Xodm1AHUzocQ1BEgFxuV4TPFiqolzGoWgzlA=
X-Google-Smtp-Source: ABdhPJwg2ZuUYWwwHlXya7UVCXokS+yfrxXlQHxqW+AWkmK89C2N39yfA0vKnwhAm+zW03WPsMOofwa4c1Ff46gA+e8=
X-Received: by 2002:a25:ad5a:: with SMTP id l26mr2367402ybe.510.1596608888032;
 Tue, 04 Aug 2020 23:28:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200801170322.75218-1-jolsa@kernel.org> <20200801170322.75218-9-jolsa@kernel.org>
In-Reply-To: <20200801170322.75218-9-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Aug 2020 23:27:55 -0700
Message-ID: <CAEf4BzaWGZT-6h8axOupzQ6Z2UiCakgv+v284PuXDZ6_VF5M9Q@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 08/14] bpf: Add btf_struct_ids_match function
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 1, 2020 at 10:04 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding btf_struct_ids_match function to check if given address provided
> by BTF object + offset is also address of another nested BTF object.
>
> This allows to pass an argument to helper, which is defined via parent
> BTF object + offset, like for bpf_d_path (added in following changes):
>
>   SEC("fentry/filp_close")
>   int BPF_PROG(prog_close, struct file *file, void *id)
>   {
>     ...
>     ret = bpf_d_path(&file->f_path, ...
>
> The first bpf_d_path argument is hold by verifier as BTF file object
> plus offset of f_path member.
>
> The btf_struct_ids_match function will walk the struct file object and
> check if there's nested struct path object on the given offset.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/bpf.h   |  2 ++
>  kernel/bpf/btf.c      | 31 +++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c | 20 +++++++++++++-------
>  3 files changed, 46 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 40c5e206ecf2..8206d5e324be 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1337,6 +1337,8 @@ int btf_struct_access(struct bpf_verifier_log *log,
>                       const struct btf_type *t, int off, int size,
>                       enum bpf_access_type atype,
>                       u32 *next_btf_id);
> +bool btf_struct_ids_match(struct bpf_verifier_log *log,
> +                         int off, u32 id, u32 need_type_id);
>  int btf_resolve_helper_id(struct bpf_verifier_log *log,
>                           const struct bpf_func_proto *fn, int);
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 7bacc2f56061..ba05b15ad599 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -4160,6 +4160,37 @@ int btf_struct_access(struct bpf_verifier_log *log,
>         return -EINVAL;
>  }
>
> +bool btf_struct_ids_match(struct bpf_verifier_log *log,
> +                         int off, u32 id, u32 need_type_id)
> +{
> +       const struct btf_type *type;
> +       int err;
> +
> +       /* Are we already done? */
> +       if (need_type_id == id && off == 0)
> +               return true;
> +
> +again:
> +       type = btf_type_by_id(btf_vmlinux, id);
> +       if (!type)
> +               return false;
> +       err = btf_struct_walk(log, type, off, 1, &id);

nit: this size=1 looks a bit artificial, seems like btf_struct_walk()
will work with size==0 just as well, no?

> +       if (err != WALK_STRUCT)
> +               return false;
> +
> +       /* We found nested struct object. If it matches
> +        * the requested ID, we're done. Otherwise let's
> +        * continue the search with offset 0 in the new
> +        * type.
> +        */
> +       if (need_type_id != id) {
> +               off = 0;
> +               goto again;
> +       }
> +
> +       return true;
> +}
> +
>  int btf_resolve_helper_id(struct bpf_verifier_log *log,
>                           const struct bpf_func_proto *fn, int arg)
>  {
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index b6ccfce3bf4c..bb6ca19f282d 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3960,16 +3960,21 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>                                 goto err_type;
>                 }
>         } else if (arg_type == ARG_PTR_TO_BTF_ID) {
> +               bool ids_match = false;
> +
>                 expected_type = PTR_TO_BTF_ID;
>                 if (type != expected_type)
>                         goto err_type;
>                 if (!fn->check_btf_id) {
> -                       if (reg->btf_id != meta->btf_id) {
> -                               verbose(env, "Helper has type %s got %s in R%d\n",
> -                                       kernel_type_name(meta->btf_id),
> -                                       kernel_type_name(reg->btf_id), regno);
> -
> -                               return -EACCES;
> +                       if (reg->btf_id != meta->btf_id || reg->off) {

Will it ever succeed if reg->btf_id == meta->btf_id, but reg->off > 0?
That would require recursively nested type, which is not possible,
right? Or what am I missing? Is it just a simplification of the error
handling path?

> +                               ids_match = btf_struct_ids_match(&env->log, reg->off, reg->btf_id,
> +                                                                meta->btf_id);
> +                               if (!ids_match) {
> +                                       verbose(env, "Helper has type %s got %s in R%d\n",
> +                                               kernel_type_name(meta->btf_id),
> +                                               kernel_type_name(reg->btf_id), regno);
> +                                       return -EACCES;
> +                               }
>                         }
>                 } else if (!fn->check_btf_id(reg->btf_id, arg)) {
>                         verbose(env, "Helper does not support %s in R%d\n",
> @@ -3977,7 +3982,8 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>
>                         return -EACCES;
>                 }
> -               if (!tnum_is_const(reg->var_off) || reg->var_off.value || reg->off) {
> +               if (!ids_match &&
> +                   (!tnum_is_const(reg->var_off) || reg->var_off.value || reg->off)) {
>                         verbose(env, "R%d is a pointer to in-kernel struct with non-zero offset\n",
>                                 regno);
>                         return -EACCES;
> --
> 2.25.4
>
