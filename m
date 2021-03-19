Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F9534136A
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 04:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbhCSDPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 23:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbhCSDPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 23:15:14 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A9EC06174A;
        Thu, 18 Mar 2021 20:15:13 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id u75so4757380ybi.10;
        Thu, 18 Mar 2021 20:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N6465kkMWUrOizyq2xRDiHKkV90SGSeSs8m69P8Gkng=;
        b=U8slcFLSEU+621i/cOsEAKFu0FfO6Nz4qgECWrFWmGHXK8MkEt08cM96FeNqNfI2wl
         ALv/atVEvQtRla6hNkMZJIqaDiIUC0TF6BjG+aaACluqpZ6/xXhrxbwaZNLe1VW/ywO5
         X09HqlLB9f/uka2FDR6CNshXHqoJC/yRadfbPrYSnM0hrzBlVktOBpWXstoa+42nRsaz
         kmcuOiNFkYtmAdwZ7xyywPyCYPEMPfEoHuRQ2C7S6lECTohMaR5I+5WPULxHkmEY/xdI
         k9N/2KHFKgd9VdUSi7e8FbX3a8BhNxd+a+UIfPxpdZ9JqmyjdlzaW7C+yhFZs8z0xQ4R
         L7EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N6465kkMWUrOizyq2xRDiHKkV90SGSeSs8m69P8Gkng=;
        b=JWcPZbD4S9qjUCSVp3al+RwRbpNrhP3zecSAVIdAVDXUdnXsEAOdQGkOnCtENJUcv7
         4+0Vgvil54aNCE6YqJWjL2A9D4BcZzK7IQNa47oXstOgG1gL4jHTfl4k80rvG9rH1OxD
         4j3dH3uUtMEM5+0fWC1JA2xzHx/ODxXcAB/z75RSYBhjjm5HgryzPkVpIYgppxg2uIvm
         pD1tdMsDO1N4ixKH0+vVWfLT4QNE85SDNS9vrdGRFxiGUmLGSfFy/vYm7+sA0f+/MYJG
         LaDsv+e/DDfcmtLNEUPWmwJMce51lBHYaO6SW53cqPx5g0kfGRWyjjuGIVlncKCpewbV
         GY/A==
X-Gm-Message-State: AOAM530xUCv9MHMrNR98wIyXnEzUc6ZDnqTZ09raKQFTv8NI5f1PUyQB
        UQw4o5fQ1vL9DmEJ+igxGgQyvTea5W+PypvjmOc=
X-Google-Smtp-Source: ABdhPJyEw7TrV/K4ii580juSwgqMHqiZBpXMjaQZA0HKt1GheDoutxeJUzTgIJU6uTkeRpj7IzlJ9k+/G39RtSZ1NUU=
X-Received: by 2002:a25:9942:: with SMTP id n2mr3416274ybo.230.1616123713249;
 Thu, 18 Mar 2021 20:15:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210316011336.4173585-1-kafai@fb.com> <20210316011438.4179031-1-kafai@fb.com>
In-Reply-To: <20210316011438.4179031-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Mar 2021 20:15:02 -0700
Message-ID: <CAEf4BzaB4sKTPZ42wbtAWaTrcuRN7UpM9tSm5m7d+d7OONgnqg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 10/15] libbpf: Rename RELO_EXTERN to RELO_EXTERN_VAR
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 12:02 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch renames RELO_EXTERN to RELO_EXTERN_VAR.
> It is to avoid the confusion with a later patch adding
> RELO_EXTERN_FUNC.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/lib/bpf/libbpf.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 8355b786b3db..8f924aece736 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -189,7 +189,7 @@ enum reloc_type {
>         RELO_LD64,
>         RELO_CALL,
>         RELO_DATA,
> -       RELO_EXTERN,
> +       RELO_EXTERN_VAR,
>         RELO_SUBPROG_ADDR,
>  };
>
> @@ -3463,7 +3463,7 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
>                 }
>                 pr_debug("prog '%s': found extern #%d '%s' (sym %d) for insn #%u\n",
>                          prog->name, i, ext->name, ext->sym_idx, insn_idx);
> -               reloc_desc->type = RELO_EXTERN;
> +               reloc_desc->type = RELO_EXTERN_VAR;
>                 reloc_desc->insn_idx = insn_idx;
>                 reloc_desc->sym_off = i; /* sym_off stores extern index */
>                 return 0;
> @@ -6226,7 +6226,7 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
>                         insn[0].imm = obj->maps[relo->map_idx].fd;
>                         relo->processed = true;
>                         break;
> -               case RELO_EXTERN:
> +               case RELO_EXTERN_VAR:
>                         ext = &obj->externs[relo->sym_off];
>                         if (ext->type == EXT_KCFG) {
>                                 insn[0].src_reg = BPF_PSEUDO_MAP_VALUE;
> --
> 2.30.2
>
