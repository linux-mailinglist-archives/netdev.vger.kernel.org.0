Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCB6239D3E
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 03:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgHCBfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 21:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgHCBfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 21:35:42 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6073C06174A;
        Sun,  2 Aug 2020 18:35:41 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id p191so3145679ybg.0;
        Sun, 02 Aug 2020 18:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TFJX5aqRLdRlM8Bylx3w4z6e/d/G1PAJ6qc3UxZLqu8=;
        b=bLlOT6eqjD2aNsv+GW/hMxQuGGBIBLJfFuMZ+HKQby4NnThk/30/4lM05scS2EFYlC
         U/zaGZKXpnLB35MK/AmK7OsgcmFzZ3ZvhcPkGxJYGWgPD6+j7xcyLuVzYgQI8X64T7om
         Q49jbNsRHQY7LQkNRnqKypGFv43DOdQLVv/SQSA+6np8eJFPK2b0scGlX/CyCLjyUSre
         FkRQUrXt0k/5Rum3emeoJCMMNSHKZOejIkW4YksTe4n5ybrTOMit9xdLdcRY71C1IwGB
         klXqQPRiXXZ2gbjRqu7eSyE/311gd2zdpMOkPG9lVC51hXeFkTacW8t5Q38pk2pchbU8
         75Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TFJX5aqRLdRlM8Bylx3w4z6e/d/G1PAJ6qc3UxZLqu8=;
        b=SSW0K/dte9krKZLWC0GOF9uKc1lioWyKAc0QmkmiiLCwWhp2ctqL6h7tL1niWM43FP
         K6EF/UX8yaxaxlscLkRZINXxjA6qWdEwcdoAtiHYK1DmFOu7rlJusqSiuNGwoTrZPCOm
         G6SCEtiC3zPqchXxU19I9MoVEi2CCyT+q89aqgdks2Mjl0ZtwG7RLs4v6gTYihB6oMzH
         SCBE6YhrAA3stmNABvCoQuzeIUurj9uPnNvi1QqB8787lEztHfd7AZaG1x5vag2O8GDe
         gLf+e0qRK0LevetCviEpBsmMLhIB5lnDKx1BkOrhb+MYHvZ++ROxd3vZB7h8b47EgDp4
         269w==
X-Gm-Message-State: AOAM533AzLzHYhAF3eaghSY2cenHavH/6VB/SrXk08OwG6/hvgrVc43y
        jDzlO/jiCLEf5BcQTbedskLE3r90BD0khqPecJI=
X-Google-Smtp-Source: ABdhPJzHYQ0IpV16NmaGb8q/5QzBJs+1x4wZiWgBhvCOx2WvJ8SZ7YesXJ2IH+Dn/28jMewcRLBwXvyRI8MS32Leqwc=
X-Received: by 2002:a25:ba0f:: with SMTP id t15mr22362497ybg.459.1596418541228;
 Sun, 02 Aug 2020 18:35:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200802042126.2119783-1-yhs@fb.com> <20200802042127.2119901-1-yhs@fb.com>
In-Reply-To: <20200802042127.2119901-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 2 Aug 2020 18:35:30 -0700
Message-ID: <CAEf4BzaeT1HULBE0dQULSF62Wm6=t49Dc8jjHVJ9Nt1noxeCtQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] libbpf: support new uapi for map element bpf iterator
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 1, 2020 at 9:22 PM Yonghong Song <yhs@fb.com> wrote:
>
> Previous commit adjusted kernel uapi for map
> element bpf iterator. This patch adjusted libbpf API
> due to uapi change.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  tools/lib/bpf/bpf.c    | 4 +++-
>  tools/lib/bpf/bpf.h    | 5 +++--
>  tools/lib/bpf/libbpf.c | 7 +++++--
>  3 files changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index eab14c97c15d..c75a84398d51 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -598,7 +598,9 @@ int bpf_link_create(int prog_fd, int target_fd,
>         attr.link_create.prog_fd = prog_fd;
>         attr.link_create.target_fd = target_fd;
>         attr.link_create.attach_type = attach_type;
> -       attr.link_create.flags = OPTS_GET(opts, flags, 0);
> +       attr.link_create.iter_info =
> +               ptr_to_u64(OPTS_GET(opts, iter_info, (void *)0));
> +       attr.link_create.iter_info_len = OPTS_GET(opts, iter_info_len, 0);
>
>         return sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
>  }
> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> index 28855fd5b5f4..c9895f191305 100644
> --- a/tools/lib/bpf/bpf.h
> +++ b/tools/lib/bpf/bpf.h
> @@ -170,9 +170,10 @@ LIBBPF_API int bpf_prog_detach2(int prog_fd, int attachable_fd,
>
>  struct bpf_link_create_opts {
>         size_t sz; /* size of this struct for forward/backward compatibility */
> -       __u32 flags;

I'd actually keep flags in link_create_ops, as it's part of the kernel
UAPI anyways, we won't have to add it later. Just pass it through into
bpf_attr.

> +       union bpf_iter_link_info *iter_info;
> +       __u32 iter_info_len;
>  };
> -#define bpf_link_create_opts__last_field flags
> +#define bpf_link_create_opts__last_field iter_info_len
>
>  LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
>                                enum bpf_attach_type attach_type,
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 7be04e45d29c..dc8fabf9d30d 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -8298,6 +8298,7 @@ bpf_program__attach_iter(struct bpf_program *prog,
>                          const struct bpf_iter_attach_opts *opts)
>  {
>         DECLARE_LIBBPF_OPTS(bpf_link_create_opts, link_create_opts);
> +       union bpf_iter_link_info linfo;
>         char errmsg[STRERR_BUFSIZE];
>         struct bpf_link *link;
>         int prog_fd, link_fd;
> @@ -8307,8 +8308,10 @@ bpf_program__attach_iter(struct bpf_program *prog,
>                 return ERR_PTR(-EINVAL);
>
>         if (OPTS_HAS(opts, map_fd)) {
> -               target_fd = opts->map_fd;
> -               link_create_opts.flags = BPF_ITER_LINK_MAP_FD;
> +               memset(&linfo, 0, sizeof(linfo));
> +               linfo.map.map_fd = opts->map_fd;
> +               link_create_opts.iter_info = &linfo;
> +               link_create_opts.iter_info_len = sizeof(linfo);

Maybe instead of having map_fd directly in bpf_iter_attach_opts, let's
just accept bpf_iter_link_info and its len directly from the user?
Right now kernel UAPI and libbpf API for customizing iterator
attachment differ. It would be simpler to keep them in sync and we
won't have to discuss how to evolve bpf_iter_attach_opts as we add
more customization for different types of iterators. Thoughts?

>         }
>
>         prog_fd = bpf_program__fd(prog);
> --
> 2.24.1
>
