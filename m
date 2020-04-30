Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268811BEDCA
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 03:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgD3BmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 21:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgD3BmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 21:42:10 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0F7C035494;
        Wed, 29 Apr 2020 18:42:10 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id t8so2232968qvw.5;
        Wed, 29 Apr 2020 18:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9BZYpVkHv9cRhbOxuF1LMjnS8fl/Obb7RwBdEcfHAn0=;
        b=FW4VntXNovNR/GnwMlsg7w+cy3Iwk9klhj22OZ44/De9lk0l8Fn/6Zdhg2IM6ENoSU
         3GN7P5ZHz7v45ZBIbQtQbEfJ/m0ODuhpTU/Tm0eqLNc6QnM6yG6tBKu7QXJXHvMu9Xsw
         vuq/CDoFrv4l3WaMGxRNj8ozO2kl5u3xcC9tp5o4rs/8BLzME8jyv7M4fpB/X2t+ZR9r
         XrBa+mUt36YHvn9FOcwHbW9mS7bwkt+hfwQ3lxlsnOSOjIoQntScrtSSzZWq+wN1+kaQ
         0bd0EBbrNCsFCjDpFjU+F7zeZYxANe4hF9VPlcGA5eDDiE2xNOatuZD5ZN5k7cj42k5e
         sNvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9BZYpVkHv9cRhbOxuF1LMjnS8fl/Obb7RwBdEcfHAn0=;
        b=mr80Zg3XkQ8mYVLr8Xt+0q/Zz86IHKsYGpzXKqZXFuNVI2Qzhz1fojPc3tiPpsYE5p
         r6MdPzYlnMEY65lz47SVfNrcYuAIzTkxDrhXUrzJSXFIfaF7KTxHJ9IJsfdJF4ZbVhqt
         2RSNKXlS4U7bbqnYSog6I+QC6d7UDIyIy569e9DQMh1NNQdIr/B0G0ryI4pxym6SR3Gh
         0/62qIh04Mdb0hQ0Q3PNB1UJTivuW9XUKcGOa7bwKJAlIyZM3IkQAF3Ll66gsFqbbESO
         azRlC7N6NJnu/ZHMsA32yKKNSpCKu/2BV4DmOxdR7PDoy5rjRrrK0y8tHYrNZv558M6j
         wp/A==
X-Gm-Message-State: AGi0PuY9ZwDwchA70VdqWND6Jp0cMvhw/Bw5XWCfgpVKVWOwtFlXeZhO
        S/LZjTBemgy6HFiBZQ/Hj0gre5g03o8k0rhnYkg=
X-Google-Smtp-Source: APiQypLwclc4uMsptW8Rkyu9hIa1eMunhNHuH3IXlKjRXluCowDs/w/i8KccciZJa0IM+Kp3HVrwhdcu2Az3Z/Edk3o=
X-Received: by 2002:a0c:eb09:: with SMTP id j9mr773147qvp.196.1588210927751;
 Wed, 29 Apr 2020 18:42:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200427201235.2994549-1-yhs@fb.com> <20200427201252.2996037-1-yhs@fb.com>
In-Reply-To: <20200427201252.2996037-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 29 Apr 2020 18:41:56 -0700
Message-ID: <CAEf4BzZKaBpQfohsWcF5qJpMU96vxDVniaPie=54Gx6kK66KQw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 15/19] tools/libbpf: add bpf_iter support
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

On Mon, Apr 27, 2020 at 1:17 PM Yonghong Song <yhs@fb.com> wrote:
>
> Three new libbpf APIs are added to support bpf_iter:
>   - bpf_program__attach_iter
>     Given a bpf program and additional parameters, which is
>     none now, returns a bpf_link.
>   - bpf_link__create_iter
>     Given a bpf_link, create a bpf_iter and return a fd
>     so user can then do read() to get seq_file output data.
>   - bpf_iter_create
>     syscall level API to create a bpf iterator.
>
> Two macros, BPF_SEQ_PRINTF0 and BPF_SEQ_PRINTF, are also introduced.
> These two macros can help bpf program writers with
> nicer bpf_seq_printf syntax similar to the kernel one.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  tools/lib/bpf/bpf.c         | 11 +++++++
>  tools/lib/bpf/bpf.h         |  2 ++
>  tools/lib/bpf/bpf_tracing.h | 23 ++++++++++++++
>  tools/lib/bpf/libbpf.c      | 60 +++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h      | 11 +++++++
>  tools/lib/bpf/libbpf.map    |  7 +++++
>  6 files changed, 114 insertions(+)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 5cc1b0785d18..7ffd6c0ad95f 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -619,6 +619,17 @@ int bpf_link_update(int link_fd, int new_prog_fd,
>         return sys_bpf(BPF_LINK_UPDATE, &attr, sizeof(attr));
>  }
>
> +int bpf_iter_create(int link_fd, unsigned int flags)

Do you envision anything more than just flags being passed for
bpf_iter_create? I wonder if we should just go ahead with options
struct here?

> +{
> +       union bpf_attr attr;
> +
> +       memset(&attr, 0, sizeof(attr));
> +       attr.iter_create.link_fd = link_fd;
> +       attr.iter_create.flags = flags;
> +
> +       return sys_bpf(BPF_ITER_CREATE, &attr, sizeof(attr));
> +}
> +

[...]

> +/*
> + * BPF_SEQ_PRINTF to wrap bpf_seq_printf to-be-printed values
> + * in a structure. BPF_SEQ_PRINTF0 is a simple wrapper for
> + * bpf_seq_printf().
> + */
> +#define BPF_SEQ_PRINTF0(seq, fmt)                                      \
> +       ({                                                              \
> +               int ret = bpf_seq_printf(seq, fmt, sizeof(fmt),         \
> +                                        (void *)0, 0);                 \
> +               ret;                                                    \
> +       })
> +
> +#define BPF_SEQ_PRINTF(seq, fmt, args...)                              \

You can unify BPF_SEQ_PRINTF and BPF_SEQ_PRINTF0 by using
___bpf_empty() macro. See bpf_core_read.h for similar use case.
Specifically, look at ___empty (equivalent of ___bpf_empty) and
___core_read, ___core_read0, ___core_readN macro.

> +       ({                                                              \
> +               _Pragma("GCC diagnostic push")                          \
> +               _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")  \
> +               __u64 param[___bpf_narg(args)] = { args };              \

Do you need to provide the size of array here? If you omit
__bpf_narg(args), wouldn't compiler automatically calculate the right
size?

Also, can you please use "unsigned long long" to not have any implicit
dependency on __u64 being defined?

> +               _Pragma("GCC diagnostic pop")                           \
> +               int ret = bpf_seq_printf(seq, fmt, sizeof(fmt),         \
> +                                        param, sizeof(param));         \
> +               ret;                                                    \
> +       })
> +
>  #endif
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 8e1dc6980fac..ffdc4d8e0cc0 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -6366,6 +6366,9 @@ static const struct bpf_sec_def section_defs[] = {
>                 .is_attach_btf = true,
>                 .expected_attach_type = BPF_LSM_MAC,
>                 .attach_fn = attach_lsm),
> +       SEC_DEF("iter/", TRACING,
> +               .expected_attach_type = BPF_TRACE_ITER,
> +               .is_attach_btf = true),

It would be nice to implement auto-attach capabilities (similar to
fentry/fexit, lsm and raw_tracepoint). Section name should have enough
information for this, no?

>         BPF_PROG_SEC("xdp",                     BPF_PROG_TYPE_XDP),
>         BPF_PROG_SEC("perf_event",              BPF_PROG_TYPE_PERF_EVENT),
>         BPF_PROG_SEC("lwt_in",                  BPF_PROG_TYPE_LWT_IN),
> @@ -6629,6 +6632,7 @@ static int bpf_object__collect_struct_ops_map_reloc(struct bpf_object *obj,
>

[...]

> +
> +       link = calloc(1, sizeof(*link));
> +       if (!link)
> +               return ERR_PTR(-ENOMEM);
> +       link->detach = &bpf_link__detach_fd;
> +
> +       attach_type = bpf_program__get_expected_attach_type(prog);

Given you know it has to be BPF_TRACE_ITER, it's better to explicitly
specify that. If provided program wasn't loaded with correct
expected_attach_type, kernel will reject it. But if you don't do it,
then you can accidentally create some other type of bpf_link.

> +       link_fd = bpf_link_create(prog_fd, 0, attach_type, NULL);
> +       if (link_fd < 0) {
> +               link_fd = -errno;
> +               free(link);
> +               pr_warn("program '%s': failed to attach to iterator: %s\n",
> +                       bpf_program__title(prog, false),
> +                       libbpf_strerror_r(link_fd, errmsg, sizeof(errmsg)));
> +               return ERR_PTR(link_fd);
> +       }
> +       link->fd = link_fd;
> +       return link;
> +}
> +
> +int bpf_link__create_iter(struct bpf_link *link, unsigned int flags)
> +{

Same question as for low-level bpf_link_create(). If we expect the
need to extend optional things in the future, I'd add opts right now.

But I wonder if bpf_link__create_iter() provides any additional value
beyond bpf_iter_create(). Maybe let's not add it (yet)?

> +       char errmsg[STRERR_BUFSIZE];
> +       int iter_fd;
> +
> +       iter_fd = bpf_iter_create(bpf_link__fd(link), flags);
> +       if (iter_fd < 0) {
> +               iter_fd = -errno;
> +               pr_warn("failed to create an iterator: %s\n",
> +                       libbpf_strerror_r(iter_fd, errmsg, sizeof(errmsg)));
> +       }
> +
> +       return iter_fd;
> +}
> +

[...]
