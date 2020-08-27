Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2295E253D25
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 07:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgH0FOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 01:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbgH0FOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 01:14:46 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3C6C061240;
        Wed, 26 Aug 2020 22:14:46 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id e14so2276015ybf.4;
        Wed, 26 Aug 2020 22:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NocizVJUD+YFco37ICb8qmDXPwpASDT9gwLmmzt9Ew4=;
        b=aXpwXXtU56fZEEzC7jLmhAmE0VITlXowAjCxTbLJ3TQ2HvEF6xiN9Mk/Ndx88PaAFn
         naio/7QFkec4UGP7WUP21kkbgy86zE3RpkqVB7JCitYMy1jK0p8h1pEfd28irtrhOKpc
         CWEZEZZUogU8uVzNk1dkvgKb14KDiu4KkvzAenabbOJYJJ6Di/PpAEp5C8SpOYptvosG
         nGRUxh43IW1d0NP2i25KFgXV1z438qySnTM2HVw+ZfhEIFpvdMo0BM20xeKFKbFDeABR
         GA22YpLtPTyMkM2TpUUrehXfizVdPYetklLc+xr9PM1tYNM7aCS1ABbVwIHUUU2a1z0n
         p/ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NocizVJUD+YFco37ICb8qmDXPwpASDT9gwLmmzt9Ew4=;
        b=Xxl89qjJVG/TYKqR23ubmtfvj1y5Kdq6LpougqmDQdymBf4jJvA0zd19jAPGThGz0T
         0H3ney92chtWZzt6DQXa/XB21o3IuTTRO3G6NdDyBaLgiZTZ8CSrDYAki/oFRMIdubOQ
         /6FMX1nAGAZuv+IFzqY5FQUtVAo5OB2B2NbwcvsBseoLKGFNAt5G2AWfxTiTrbF0Bg1a
         chssSHeNOLs2hsQUYT+gtMo1BcnMaIiAlYHn7NV7B1G91A/VjfMnLI9eK1CcEMqvBl6P
         1HgtkF194WvDnOuNe2cPioSAkaEYOZX9vtvNEBW+iuk1DubFhKAlkYIPS79a/AjA2wv+
         k/OA==
X-Gm-Message-State: AOAM530A+X4GHbUa0BAdO5dDCSp2Rk3yS9kAFNk0pgfJRHEDwYCrDKUl
        dN7XevOpyvzhdqpoLD3Prdwuf7KBxfANI7B9pf6a2zOL
X-Google-Smtp-Source: ABdhPJyuSKdhu6toAw/UruuAPD552qwhud3RBOA9QB5S8iM7BQSfNG2p/tT1B9YW2gwdQjxVaAMskyRD3025lgvcf8c=
X-Received: by 2002:a25:2ad3:: with SMTP id q202mr24980230ybq.27.1598505284544;
 Wed, 26 Aug 2020 22:14:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200827000618.2711826-1-yhs@fb.com> <20200827000621.2712111-1-yhs@fb.com>
In-Reply-To: <20200827000621.2712111-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 26 Aug 2020 22:14:33 -0700
Message-ID: <CAEf4BzYZex7SRhOSv6R6Fy0HWq+F2ud5QKrw1X4t8Oh-XTDjwQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/5] bpf: add link_query support for newly added
 main_thread_only info
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

On Wed, Aug 26, 2020 at 5:07 PM Yonghong Song <yhs@fb.com> wrote:
>
> Added support for link_query for main_thread_only information
> with task/task_file iterators.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/uapi/linux/bpf.h       |  5 +++++
>  kernel/bpf/task_iter.c         | 17 +++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  5 +++++
>  3 files changed, 27 insertions(+)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index af5c600bf673..595bdc4c9431 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4259,6 +4259,11 @@ struct bpf_link_info {
>                                 struct {
>                                         __u32 map_id;
>                                 } map;
> +
> +                               struct {
> +                                       __u32 main_thread_only:1;
> +                                       __u32 :31;
> +                               } task;
>                         };
>                 } iter;
>                 struct  {
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> index 362bf2dda63a..7636abe05f27 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -329,6 +329,19 @@ static int bpf_iter_attach_task(struct bpf_prog *prog,
>         return 0;
>  }
>
> +static void bpf_iter_task_show_fdinfo(const struct bpf_iter_aux_info *aux,
> +                                     struct seq_file *seq)
> +{
> +       seq_printf(seq, "main_thread_only:\t%u\n", aux->main_thread_only);
> +}
> +
> +static int bpf_iter_task_fill_link_info(const struct bpf_iter_aux_info *aux,
> +                                       struct bpf_link_info *info)
> +{
> +       info->iter.task.main_thread_only = aux->main_thread_only;
> +       return 0;
> +}
> +
>  BTF_ID_LIST(btf_task_file_ids)
>  BTF_ID(struct, task_struct)
>  BTF_ID(struct, file)
> @@ -343,6 +356,8 @@ static const struct bpf_iter_seq_info task_seq_info = {
>  static struct bpf_iter_reg task_reg_info = {
>         .target                 = "task",
>         .attach_target          = bpf_iter_attach_task,
> +       .show_fdinfo            = bpf_iter_task_show_fdinfo,
> +       .fill_link_info         = bpf_iter_task_fill_link_info,
>         .ctx_arg_info_size      = 1,
>         .ctx_arg_info           = {
>                 { offsetof(struct bpf_iter__task, task),
> @@ -361,6 +376,8 @@ static const struct bpf_iter_seq_info task_file_seq_info = {
>  static struct bpf_iter_reg task_file_reg_info = {
>         .target                 = "task_file",
>         .attach_target          = bpf_iter_attach_task,
> +       .show_fdinfo            = bpf_iter_task_show_fdinfo,
> +       .fill_link_info         = bpf_iter_task_fill_link_info,
>         .ctx_arg_info_size      = 2,
>         .ctx_arg_info           = {
>                 { offsetof(struct bpf_iter__task_file, task),
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index af5c600bf673..595bdc4c9431 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -4259,6 +4259,11 @@ struct bpf_link_info {
>                                 struct {
>                                         __u32 map_id;
>                                 } map;
> +
> +                               struct {
> +                                       __u32 main_thread_only:1;
> +                                       __u32 :31;

nit: unless we want to always re-calculate how many bits we have left
(and specify that in UAPI header), using `__u32: 0` would work here,
won't require updating it with every new flag, and won't accidentally
add an extra 32 bits to the task struct, if we forget to update the
size.

But nothing wrong with :31,  if explicitness was a goal here.

> +                               } task;
>                         };
>                 } iter;
>                 struct  {
> --
> 2.24.1
>
