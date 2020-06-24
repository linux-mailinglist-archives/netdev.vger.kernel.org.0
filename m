Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795F4206CF9
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 08:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389275AbgFXGrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 02:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388972AbgFXGru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 02:47:50 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B891C061573;
        Tue, 23 Jun 2020 23:47:50 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id c11so690534lfh.8;
        Tue, 23 Jun 2020 23:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/SrZsktoWf79Xv0VZmSBpxdBClJEH0BrLxsHWBTWdsc=;
        b=RuKLVYm8Uqh+j/XmiPLUs+UVfYEH0XMYL85I0oXUxv2SGv6TeNcTyodFg4siTSKsa9
         9Y+2LJud8368WWuytoD+N4SY1UTfc6zWw90rf33p8z1zhSM7GsPrJpL/zTkXNnFawA5i
         47S14Btvb+UdjdXR5s3iMq8k8py1ng9ph4xALDLjmbn1oS4oS7akgQkhPHuStsbsXcl0
         7lMHVBySfJ/Ur4huNPDyZaNrorfWSJ8vbQ+1rNSZSzD/8DIclNcz02bo7YBxnOIA253o
         3YML21u5hMca2krFY+QN+uvLC2nwPe/N80cGgOTpM3wMGs9TegY/N7TFhuq4Hc/NxvKO
         7Lpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/SrZsktoWf79Xv0VZmSBpxdBClJEH0BrLxsHWBTWdsc=;
        b=r1/fnkAA2olhOSDNQJe3b7rubWV9jglTK31ZOeEg1hWGfoFBUedtJe2mvubGzoFMAe
         vO96uEtq0So4RN4GZifmp7ej2xb/oVvZFY1NtQCfH+RkaSxC+Sk+2jUpzNUuvc/2WSbC
         WdH/ar0F6cuDF57CRttEszfq/VEMZX34ypCZ1QP7BcshYKgEyfDRycCAo2lmRHEkzNZr
         aXifvgAZvXxeeUgOmhvVLrPnLSGYl3Ux62i8lQdJuXE8Zwz5hVHxtbd+MESGrhJiMMvW
         5xoCBhteol65TCg3DFhx/dQEGUY1/TQ27EPO/FtvAeLBeff8cy7v2Q9x9LnhnQd2CHbX
         cwxA==
X-Gm-Message-State: AOAM533XpBnBdSlUQQnLQyrqfFGoykuOhE2q5e1ANQ9Enymw2HD3aeR9
        ebHae0BZXOEoF307qhSBSuIxpMjetoF84QjPOJJdsQ==
X-Google-Smtp-Source: ABdhPJz4eKuGUx/kPrtR5zA/EbxR1yWQINPztd7G+ckyI+AMD8ert/eAfyCiqN9LR9Bu5nl+lj2P1kv3rc+mL3QPeMI=
X-Received: by 2002:a19:815:: with SMTP id 21mr14175047lfi.119.1592981268500;
 Tue, 23 Jun 2020 23:47:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200624003340.802375-1-andriin@fb.com>
In-Reply-To: <20200624003340.802375-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 23 Jun 2020 23:47:36 -0700
Message-ID: <CAADnVQJ_4WhyK3UvtzodMrg+a-xQR7bFiCCi5nz_qq=AGX_FbQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: add debug message for each created program
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 5:34 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Similar message for map creation is extremely useful, so add similar for BPF
> programs.

'extremely useful' is quite subjective.
If we land this patch then everyone will be allowed to add pr_debug()
everywhere in libbpf with the same reasoning: "it's extremely useful pr_debug".

> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 18461deb1b19..f24a90c86c58 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -5379,8 +5379,9 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
>         }
>
>         ret = bpf_load_program_xattr(&load_attr, log_buf, log_buf_size);
> -
>         if (ret >= 0) {
> +               pr_debug("prog '%s' ('%s'): created successfully, fd=%d\n",
> +                        prog->name, prog->section_name, ret);
>                 if (log_buf && load_attr.log_level)
>                         pr_debug("verifier log:\n%s", log_buf);
>                 *pfd = ret;
> --
> 2.24.1
>
