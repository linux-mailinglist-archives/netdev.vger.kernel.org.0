Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285CD3D30F2
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 02:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbhGVX7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 19:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbhGVX7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 19:59:22 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1EDFC061575;
        Thu, 22 Jul 2021 17:39:55 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id v189so7202979ybg.3;
        Thu, 22 Jul 2021 17:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fTBaj8we3DhRuZzKNvVMYvt1vpaER0LSA5TNJzdiVdw=;
        b=HEFsXg/E1mCW5thn3M/b+7ObRbAhODqV7c9WXoyv1CprTf1WDrJWPpMYPHDaFjqmNv
         xwAwaObQbFSCXAf914sUo92wIiYKmkIHJRubX3KAp+13IbUbwgGLr75k1sMzT5qjFs7H
         /2lAuWSapuCDTL8YFBCDSWMuXviJt/TNfZEOEd3ptbFtQ+/5rhDIt9h5YGJ5DmFJP6Ey
         N6zze8fuqL5555iuFkVHR1ydLft7lyGoJ50yqlUyUeyB5p6Bog3s7x4MowuXRnbYfE3y
         63X223JGlQcgs1RHovu3BWssifqTYXJPQmzzHw4pXRavBgU7W5YOn+uOomDncsF5bS1P
         jb2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fTBaj8we3DhRuZzKNvVMYvt1vpaER0LSA5TNJzdiVdw=;
        b=ukU9hgD74Jb/5Lur+0rK6MsQDeGvrb8pdbmvQi5tf1zwgJt0AaGTcG2QJS67k4ducg
         ENpGhkPtCTSLCHVKVmISsITcX0lP2rctaqr82c3kg8erazTvPK58o/03sqsrDjWztrpO
         TKtVxiHJha+Kcf0d5W21a8oDgoNbeLGjc65z7PaCW5xhZHU8nplXv1yPgFteevi1jH59
         O30pjb8ZbsPY9KdBonNKga+Ybvmdfhme2I4r8fgk7Vt74wpmnU2ADwJS3SeSJ8jup6Y4
         lzTdfTYxHjola0BcftSf+biEaBo9oLks46y0VcvVGTX49gNRzlkKyaAdTEnE1Bi91+8k
         iMQw==
X-Gm-Message-State: AOAM531P0iHE4LjDrPorrQ+ySJ2AOEPLP1R5et/NcCjAo2ToFjYcOlZg
        17Vn1ak49C7qVkcK4lVOjMZ3mnc1wbyMY5BLh2Y=
X-Google-Smtp-Source: ABdhPJze6KRCc5Jn6NaIo3XWRg8w1GdQFBdunbAY+4AuDe8tfPkHvv+BHoXmLq8Y4Q/oEk1XF6IksaEUkTxzsKAiEok=
X-Received: by 2002:a25:1455:: with SMTP id 82mr2972813ybu.403.1627000795069;
 Thu, 22 Jul 2021 17:39:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210721153808.6902-1-quentin@isovalent.com> <20210721153808.6902-3-quentin@isovalent.com>
In-Reply-To: <20210721153808.6902-3-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Jul 2021 17:39:43 -0700
Message-ID: <CAEf4BzZqEZLt0_qgmniY-hqgEg7q0ur0Z5U0r8KFTwSz=2StSg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/5] libbpf: rename btf__get_from_id() as btf__load_from_kernel_by_id()
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 8:38 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Rename function btf__get_from_id() as btf__load_from_kernel_by_id() to
> better indicate what the function does. Change the new function so that,
> instead of requiring a pointer to the pointer to update and returning
> with an error code, it takes a single argument (the id of the BTF
> object) and returns the corresponding pointer. This is more in line with
> the existing constructors.
>
> The other tools calling the deprecated btf__get_from_id() function will
> be updated in a future commit.
>
> References:
>
> - https://github.com/libbpf/libbpf/issues/278
> - https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#btfh-apis
>
> v2:
> - Instead of a simple renaming, change the new function to make it
>   return the pointer to the btf struct.
> - API v0.5.0 instead of v0.6.0.

We generally keep such version changes to cover letters. It keeps each
individual commit clean and collects full history in the cover letter
which becomes a body of merge commit when the whole patch set is
applied. For next revision please consolidate the history in the cover
letter. Thanks!

>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  tools/lib/bpf/btf.c      | 25 +++++++++++++++++--------
>  tools/lib/bpf/btf.h      |  1 +
>  tools/lib/bpf/libbpf.c   |  5 +++--
>  tools/lib/bpf/libbpf.map |  1 +
>  4 files changed, 22 insertions(+), 10 deletions(-)
>
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 7e0de560490e..6654bdee7ad7 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -1383,21 +1383,30 @@ struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf)
>         return btf;
>  }
>
> +struct btf *btf__load_from_kernel_by_id(__u32 id)
> +{
> +       struct btf *btf;
> +       int btf_fd;
> +
> +       btf_fd = bpf_btf_get_fd_by_id(id);
> +       if (btf_fd < 0)
> +               return ERR_PTR(-errno);

please use libbpf_err_ptr() for consistency, see
bpf_object__open_mem() for an example

> +
> +       btf = btf_get_from_fd(btf_fd, NULL);
> +       close(btf_fd);
> +
> +       return libbpf_ptr(btf);
> +}
> +
>  int btf__get_from_id(__u32 id, struct btf **btf)
>  {
>         struct btf *res;
> -       int err, btf_fd;
> +       int err;
>
>         *btf = NULL;
> -       btf_fd = bpf_btf_get_fd_by_id(id);
> -       if (btf_fd < 0)
> -               return libbpf_err(-errno);
> -
> -       res = btf_get_from_fd(btf_fd, NULL);
> +       res = btf__load_from_kernel_by_id(id);
>         err = libbpf_get_error(res);
>
> -       close(btf_fd);
> -
>         if (err)
>                 return libbpf_err(err);
>
> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> index fd8a21d936ef..3db9446bc133 100644
> --- a/tools/lib/bpf/btf.h
> +++ b/tools/lib/bpf/btf.h
> @@ -68,6 +68,7 @@ LIBBPF_API const void *btf__get_raw_data(const struct btf *btf, __u32 *size);
>  LIBBPF_API const char *btf__name_by_offset(const struct btf *btf, __u32 offset);
>  LIBBPF_API const char *btf__str_by_offset(const struct btf *btf, __u32 offset);
>  LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
> +LIBBPF_API struct btf *btf__load_from_kernel_by_id(__u32 id);

let's move this definition to after btf__parse() to keep all
"constructors" together (we can move btf__get_from_id() there for
completeness as well, I suppose).

>  LIBBPF_API int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
>                                     __u32 expected_key_size,
>                                     __u32 expected_value_size,
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 242e97892043..eff005b1eba1 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -9576,8 +9576,8 @@ static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
>  {
>         struct bpf_prog_info_linear *info_linear;
>         struct bpf_prog_info *info;
> -       struct btf *btf = NULL;
>         int err = -EINVAL;
> +       struct btf *btf;
>
>         info_linear = bpf_program__get_prog_info_linear(attach_prog_fd, 0);
>         err = libbpf_get_error(info_linear);
> @@ -9591,7 +9591,8 @@ static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
>                 pr_warn("The target program doesn't have BTF\n");
>                 goto out;
>         }
> -       if (btf__get_from_id(info->btf_id, &btf)) {
> +       btf = btf__load_from_kernel_by_id(info->btf_id);
> +       if (libbpf_get_error(btf)) {

there seems to be a bug in existing code and you are keeping it. On
error err will be 0. Let's fix it. Same for above if (!info->btf_id),
please fix that as well while you are at it.

>                 pr_warn("Failed to get BTF of the program\n");
>                 goto out;
>         }
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index f7d52d76ca3a..ca8cc7a7faad 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -373,6 +373,7 @@ LIBBPF_0.5.0 {
>                 bpf_map__initial_value;
>                 bpf_map_lookup_and_delete_elem_flags;
>                 bpf_object__gen_loader;
> +               btf__load_from_kernel_by_id;
>                 btf__load_into_kernel;
>                 btf_dump__dump_type_data;
>                 libbpf_set_strict_mode;
> --
> 2.30.2
>
