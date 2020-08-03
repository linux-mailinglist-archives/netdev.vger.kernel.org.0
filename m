Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA9B239D35
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 03:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgHCBZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 21:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgHCBZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 21:25:37 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20267C06174A;
        Sun,  2 Aug 2020 18:25:37 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id a34so14314912ybj.9;
        Sun, 02 Aug 2020 18:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j0L86Yd+9MAimRcawUift8DxPuaeuh+GmPB1Nv5raYU=;
        b=M+H/dAiI4MIKRjR03nEHk4qMz9Bdn3oYS9t9/0xHnzqSEequBb9pwYqn2wY8W+FaLs
         yKAj7Cg8aze6Y8Q2ypzMSWkDsCU4ir4Mt3CRASxMX6bxDn0rDBe+rsjGjJ6ru8oFLUGn
         Ptb3G25F0R3C0UaXKEuSQm5WoSh5gBPqq+ZRHKKJSvhaHB4Ay5eo24FR9excm+cRgI5H
         rN+EbYBLvekVRj37Hiz36y7Naa6qTcbq/PgEPsI5MT6bT1GSf3ksav2Y7QZGpHyhsESa
         8cB/2Gn5VqYmsTU4QeYpEv6IXOdnal8lpHZoGtdZZBK8cuPZ1sxkmtWy2axmY6RKStu1
         fW5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j0L86Yd+9MAimRcawUift8DxPuaeuh+GmPB1Nv5raYU=;
        b=eHMWwCXajm+ZWcFwMICZHllPrdikR25bXWUHl1w2NNPLtQfW0f/Gjn0X6MK0H3blCK
         PBwC2slYJ+/dfcOW/yJQGwcFFL03NZNeBzwq6i1FnGFdx4pUZ5DEtblaEPU7aRk/1EtG
         UWvdQuKdhhwCA2AD6DiDrn4wa/sXS5Ba1BduvFSWBE7wipyHjdd4YLXt7N77GZR1GAnS
         ptqPc0UdtWV5JS/V9EJ3lDV0s2h6SQ3CHYOM02vrmYKlIQaBlzT0tUlIcYxwvw2napZF
         fe21ltQmV86Bn28q2XPnHAdjZq3cA2Fr22UpqyhOecF28DkgUTfG1zwqZuzBY7N6vYUG
         hclw==
X-Gm-Message-State: AOAM533PlmpzPz+THkN73/GIf3Ixaskq4uv/RdVIiyD84M9eewwfrMBO
        CNZhDYM4l1V3AveNVIaPaco/FP/v43tbxdqQbK4=
X-Google-Smtp-Source: ABdhPJxdZ8ljaw/WHgbRQV+yefM+u7CzKmKlWik7vSvMWgFOBvKkzMq23mpk/W25QUtQXvroS+AqTb+nr5Mt/4cJWUI=
X-Received: by 2002:a25:d84a:: with SMTP id p71mr23829591ybg.347.1596417936307;
 Sun, 02 Aug 2020 18:25:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200802042126.2119783-1-yhs@fb.com> <20200802042126.2119843-1-yhs@fb.com>
In-Reply-To: <20200802042126.2119843-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 2 Aug 2020 18:25:25 -0700
Message-ID: <CAEf4BzbaRXHpZ5b_6rojnk2dQxLFCOEwtGjNExdg5FEWadF+9g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: change uapi for bpf iterator map elements
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
> Commit a5cbe05a6673 ("bpf: Implement bpf iterator for
> map elements") added bpf iterator support for
> map elements. The map element bpf iterator requires
> info to identify a particular map. In the above
> commit, the attr->link_create.target_fd is used
> to carry map_fd and an enum bpf_iter_link_info
> is added to uapi to specify the target_fd actually
> representing a map_fd:
>     enum bpf_iter_link_info {
>         BPF_ITER_LINK_UNSPEC = 0,
>         BPF_ITER_LINK_MAP_FD = 1,
>
>         MAX_BPF_ITER_LINK_INFO,
>     };
>
> This is an extensible approach as we can grow
> enumerator for pid, cgroup_id, etc. and we can
> unionize target_fd for pid, cgroup_id, etc.
> But in the future, there are chances that
> more complex customization may happen, e.g.,
> for tasks, it could be filtered based on
> both cgroup_id and user_id.
>
> This patch changed the uapi to have fields
>         __aligned_u64   iter_info;
>         __u32           iter_info_len;
> for additional iter_info for link_create.
> The iter_info is defined as
>         union bpf_iter_link_info {
>                 struct {
>                         __u32   map_fd;
>                 } map;
>         };
>
> So future extension for additional customization
> will be easier. The bpf_iter_link_info will be
> passed to target callback to validate and generic
> bpf_iter framework does not need to deal it any
> more.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h            | 10 ++++---
>  include/uapi/linux/bpf.h       | 15 +++++-----
>  kernel/bpf/bpf_iter.c          | 52 +++++++++++++++-------------------
>  kernel/bpf/map_iter.c          | 37 ++++++++++++++++++------
>  kernel/bpf/syscall.c           |  2 +-
>  net/core/bpf_sk_storage.c      | 37 ++++++++++++++++++------
>  tools/include/uapi/linux/bpf.h | 15 +++++-----
>  7 files changed, 104 insertions(+), 64 deletions(-)
>

[...]

>  int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>  {
> +       union bpf_iter_link_info __user *ulinfo;
>         struct bpf_link_primer link_primer;
>         struct bpf_iter_target_info *tinfo;
> -       struct bpf_iter_aux_info aux = {};
> +       union bpf_iter_link_info linfo;
>         struct bpf_iter_link *link;
> -       u32 prog_btf_id, target_fd;
> +       u32 prog_btf_id, linfo_len;
>         bool existed = false;
> -       struct bpf_map *map;
>         int err;
>
> +       memset(&linfo, 0, sizeof(union bpf_iter_link_info));
> +
> +       ulinfo = u64_to_user_ptr(attr->link_create.iter_info);
> +       linfo_len = attr->link_create.iter_info_len;
> +       if (ulinfo && linfo_len) {

We probably want to be more strict here: if either pointer or len is
non-zero, both should be present and valid. Otherwise we can have
garbage in iter_info, as long as iter_info_len is zero.

> +               err = bpf_check_uarg_tail_zero(ulinfo, sizeof(linfo),
> +                                              linfo_len);
> +               if (err)
> +                       return err;
> +               linfo_len = min_t(u32, linfo_len, sizeof(linfo));
> +               if (copy_from_user(&linfo, ulinfo, linfo_len))
> +                       return -EFAULT;
> +       }
> +
>         prog_btf_id = prog->aux->attach_btf_id;
>         mutex_lock(&targets_mutex);
>         list_for_each_entry(tinfo, &targets, list) {
> @@ -411,13 +425,6 @@ int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>         if (!existed)
>                 return -ENOENT;
>
> -       /* Make sure user supplied flags are target expected. */
> -       target_fd = attr->link_create.target_fd;
> -       if (attr->link_create.flags != tinfo->reg_info->req_linfo)
> -               return -EINVAL;
> -       if (!attr->link_create.flags && target_fd)
> -               return -EINVAL;
> -

Please still ensure that no flags are specified.


>         link = kzalloc(sizeof(*link), GFP_USER | __GFP_NOWARN);
>         if (!link)
>                 return -ENOMEM;
> @@ -431,28 +438,15 @@ int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>                 return err;
>         }
>

[...]

> -static int bpf_iter_check_map(struct bpf_prog *prog,
> -                             struct bpf_iter_aux_info *aux)
> +static int bpf_iter_attach_map(struct bpf_prog *prog,
> +                              union bpf_iter_link_info *linfo,
> +                              struct bpf_iter_aux_info *aux)
>  {
> -       struct bpf_map *map = aux->map;
> +       struct bpf_map *map;
> +       int err = -EINVAL;
>
> -       if (map->map_type != BPF_MAP_TYPE_SK_STORAGE)
> +       if (!linfo->map.map_fd)
>                 return -EINVAL;

This could be -EBADF?

>
> -       if (prog->aux->max_rdonly_access > map->value_size)
> -               return -EACCES;
> +       map = bpf_map_get_with_uref(linfo->map.map_fd);
> +       if (IS_ERR(map))
> +               return PTR_ERR(map);
> +
> +       if (map->map_type != BPF_MAP_TYPE_SK_STORAGE)
> +               goto put_map;
> +
> +       if (prog->aux->max_rdonly_access > map->value_size) {
> +               err = -EACCES;
> +               goto put_map;
> +       }

[...]
