Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F98F24CE0D
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgHUGdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgHUGdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 02:33:43 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C4FC061385;
        Thu, 20 Aug 2020 23:33:42 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id e187so496774ybc.5;
        Thu, 20 Aug 2020 23:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IAYVE3QPe8PXQjrJHxwgZyYqj5CYnBXaayKgtYZFacc=;
        b=mZ2lr0LltFjBKm+VBnN4CnV9hvrK1DB8C8DfeUUNoclNNHG8LF4fBQJ0y8bDQ2Ddxs
         sMdPEfalHP+1xd/Aotx+d9Gy0os43VjBR1yOnkvHT5XXAcIVCfTdnyMnYGUEu2iOBtZc
         nG8bXiF2jhOiHbbtrie3V+SabxvshlfQ6pKjd2NmMGlcb/3vwOHSHWZNjWjsJGfkulKC
         PYPviVWjxNqTBr0w1gr3CU2YmYle/enE6n9d1sarCDZpgT2d972K9lEarF5tOSn0GCcE
         YLjNqnlLuolwMikNA3GlbqiG7MJmjJp1bGsoYIRZQo80PHmF2WJSlC16/0nc7irMFnBy
         7Vng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IAYVE3QPe8PXQjrJHxwgZyYqj5CYnBXaayKgtYZFacc=;
        b=sIvslGg5AzpRgALJL+57nTXSdTykASeMyrilfNbUOitBjIggoVYBmb0ESFHFDmV8hW
         XLx3I4fIkNQcP0+uk8+IUAw7ZsJq6UDPj89wJIOf889ipg/o9BmJwr8zC+jWtk7Q4g7u
         BfPpGRZwsC3wTBtOdIrKdVhUDEkpRPT5nz6NfM2uCKBTyI4m7hnfxL9hhtsUoHYDdDBw
         wnZDQ2bNdp+Le8yDZR3EoQuE8jwI1zGiPS3D4AJm1jZ2bSPQRlPUWa5TCbP8Oplpj2D+
         xtKV9f5oyC5hzfTcsxXVji4G021TERhzEDEg/5kqGQeyy4H/33eHQ7C5g/QhVHpHB5ux
         Vv9g==
X-Gm-Message-State: AOAM53051PLhbRCjWxK/yxTJfi38h00gdiaLP22Wb7DkvtL3wCc01bqP
        0ZpV+01VVkeTvdjcQUNcMZu6i25tzxusrXS09oimvc6c
X-Google-Smtp-Source: ABdhPJxhdpFXTziuvAgZwjEHWIZSf2H/tb1uk+hWaZr2G98z24EaNjDucmI59mBlbzh7JBe/D3f+QcI0F8UN0A2bROc=
X-Received: by 2002:a25:ad5a:: with SMTP id l26mr1706891ybe.510.1597991621908;
 Thu, 20 Aug 2020 23:33:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200820224917.483062-1-yhs@fb.com> <20200820224918.483254-1-yhs@fb.com>
In-Reply-To: <20200820224918.483254-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 Aug 2020 23:33:30 -0700
Message-ID: <CAEf4BzaqMO5YgDhSf2gmhbDsp8md5kfvyrUqOc_AyD_3jJBmeA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/3] bpf: implement link_query callbacks in
 map element iterators
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

On Thu, Aug 20, 2020 at 3:50 PM Yonghong Song <yhs@fb.com> wrote:
>
> For bpf_map_elem and bpf_sk_local_storage bpf iterators,
> additional map_id should be shown for fdinfo and
> userspace query. For example, the following is for
> a bpf_map_elem iterator.
>   $ cat /proc/1753/fdinfo/9
>   pos:    0
>   flags:  02000000
>   mnt_id: 14
>   link_type:      iter
>   link_id:        34
>   prog_tag:       104be6d3fe45e6aa
>   prog_id:        173
>   target_name:    bpf_map_elem
>   map_id:         127
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h       |  4 ++++
>  kernel/bpf/map_iter.c     | 15 +++++++++++++++
>  net/core/bpf_sk_storage.c |  2 ++
>  3 files changed, 21 insertions(+)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 529e9b183eeb..30c144af894a 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1256,6 +1256,10 @@ int bpf_iter_new_fd(struct bpf_link *link);
>  bool bpf_link_is_iter(struct bpf_link *link);
>  struct bpf_prog *bpf_iter_get_info(struct bpf_iter_meta *meta, bool in_stop);
>  int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx);
> +void bpf_iter_map_show_fdinfo(const struct bpf_iter_aux_info *aux,
> +                             struct seq_file *seq);
> +int bpf_iter_map_fill_link_info(const struct bpf_iter_aux_info *aux,
> +                               struct bpf_link_info *info);
>
>  int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
>  int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
> diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
> index af86048e5afd..714e74556aa2 100644
> --- a/kernel/bpf/map_iter.c
> +++ b/kernel/bpf/map_iter.c
> @@ -149,6 +149,19 @@ static void bpf_iter_detach_map(struct bpf_iter_aux_info *aux)
>         bpf_map_put_with_uref(aux->map);
>  }
>
> +void bpf_iter_map_show_fdinfo(const struct bpf_iter_aux_info *aux,
> +                             struct seq_file *seq)
> +{
> +       seq_printf(seq, "map_id:\t\t%u\n", aux->map->id);

nit: I think it's a bad idea to have two tabs here to align everything
visually, might make parsing unnecessarily harder

> +}
> +
> +int bpf_iter_map_fill_link_info(const struct bpf_iter_aux_info *aux,
> +                               struct bpf_link_info *info)
> +{
> +       info->iter.map.map_id = aux->map->id;
> +       return 0;
> +}
> +
>  DEFINE_BPF_ITER_FUNC(bpf_map_elem, struct bpf_iter_meta *meta,
>                      struct bpf_map *map, void *key, void *value)
>
> @@ -156,6 +169,8 @@ static const struct bpf_iter_reg bpf_map_elem_reg_info = {
>         .target                 = "bpf_map_elem",
>         .attach_target          = bpf_iter_attach_map,
>         .detach_target          = bpf_iter_detach_map,
> +       .show_fdinfo            = bpf_iter_map_show_fdinfo,
> +       .fill_link_info         = bpf_iter_map_fill_link_info,
>         .ctx_arg_info_size      = 2,
>         .ctx_arg_info           = {
>                 { offsetof(struct bpf_iter__bpf_map_elem, key),
> diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
> index b988f48153a4..281200dc0a01 100644
> --- a/net/core/bpf_sk_storage.c
> +++ b/net/core/bpf_sk_storage.c
> @@ -1437,6 +1437,8 @@ static struct bpf_iter_reg bpf_sk_storage_map_reg_info = {
>         .target                 = "bpf_sk_storage_map",
>         .attach_target          = bpf_iter_attach_map,
>         .detach_target          = bpf_iter_detach_map,
> +       .show_fdinfo            = bpf_iter_map_show_fdinfo,
> +       .fill_link_info         = bpf_iter_map_fill_link_info,
>         .ctx_arg_info_size      = 2,
>         .ctx_arg_info           = {
>                 { offsetof(struct bpf_iter__bpf_sk_storage_map, sk),
> --
> 2.24.1
>
