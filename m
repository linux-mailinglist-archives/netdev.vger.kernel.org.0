Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8293D81B6
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhG0VWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234850AbhG0VWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:22:23 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FF8C061199;
        Tue, 27 Jul 2021 14:20:55 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id d73so305663ybc.10;
        Tue, 27 Jul 2021 14:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iB3qgeViRpIjT93w0QydPOg+Ii5RDB3TR8rNyXNBTEQ=;
        b=fFcNEB8Lsvr2/BVLHn0JVzailtB5iHyYSl3beRfbb9I0jotBWWN88x1OEsOQ08GIvQ
         LAcPZeFufJHDai/v2cq0K1zWQ1b+7yd7Mu1AviyRZcOOevvrhJ9og5foGVzAOy1euA1u
         1KcF7pwxWXsCqdaMA3UdSLBEoceSKXcLBWSHynQbw9FmWQ9ZZnZCFvbcsSRGxo/1Ww3o
         cItyV8QPd4rmngHiiRPzBqyCRD7vZTISIRdlZeEuh3oAegNSc7ET89wiRdi3jwlJQt0R
         G1DtRtjSmOSMI+CHUEBSatuqe5W2QWv51WgzzMPXESgiGtlHWhA8VwBb9GO/1QJU6o5j
         qzVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iB3qgeViRpIjT93w0QydPOg+Ii5RDB3TR8rNyXNBTEQ=;
        b=hOvZULZMqoARvH0mGQHrfr6KhPIIpltM6tSM0VxesKbAOChg+DJ1g9H4csNqs4z30B
         CuLRTIP3EomxokjubA0n/7oRrq5JuHf2pLMeFh+U3D0QFK+4GEpRStN47e4zS0nMEG32
         mlR27p/h9JlxNrV+1jozyxeYurohWgkpaebJIT6goNQR4xZMiS7AqiVOx5o5J+w96cyG
         UzWAJ5Bs/m5wTJRWYBDSophCQcawfXy3awoTSmmIhgNedj69SRe5OGEV95m1jOrXGRjB
         SS2u/g5nCwAg7DMTqHHfVqSKX1Skw7H4FrsSurIxVCz12Hn4LFo6ipNtc62Gsv+IIFar
         CZdQ==
X-Gm-Message-State: AOAM530hlz03vMzZ3rS6lO7mP13vpsRm6x0ekZwaJnb7PB+N1/lmuRzi
        A5PcNHtV4gvGnF6O9KoYa/QkG7mBdpWtwj5mXVo=
X-Google-Smtp-Source: ABdhPJxK0LV5QRIbJQ8Tv+Z6Ie2DAFRChRfIe3L+mVhmtv+BsysxoSdr4WKzdbUvpPlzdBQxr1bsFUniM+dHtbHIPyw=
X-Received: by 2002:a25:b203:: with SMTP id i3mr34416195ybj.260.1627420854479;
 Tue, 27 Jul 2021 14:20:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210727115928.74600-1-wangborong@cdjrlc.com>
In-Reply-To: <20210727115928.74600-1-wangborong@cdjrlc.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 27 Jul 2021 14:20:43 -0700
Message-ID: <CAEf4Bza5UwEOPEo3Ww-TugJmT91dmfCggFAF6JQmeimCebYPVQ@mail.gmail.com>
Subject: Re: [PATCH] libbpf: fix commnet typo
To:     wangborong@cdjrlc.com
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 5:00 AM Jason Wang <wangborong@cdjrlc.com> wrote:
>
> Remove the repeated word 'the' in line 48.
>
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
> ---

Fixed the typo in the subject of a patch fixing a typo in libbpf
comment :) Applied to bpf-next.

>  tools/lib/bpf/libbpf.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 4c153c379989..d474816ecd70 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -7236,7 +7236,7 @@ static int bpf_object__collect_relos(struct bpf_object *obj)
>
>         for (i = 0; i < obj->nr_programs; i++) {
>                 struct bpf_program *p = &obj->programs[i];
> -
> +
>                 if (!p->nr_reloc)
>                         continue;
>
> @@ -9533,7 +9533,7 @@ static int find_btf_by_prefix_kind(const struct btf *btf, const char *prefix,
>         ret = snprintf(btf_type_name, sizeof(btf_type_name),
>                        "%s%s", prefix, name);
>         /* snprintf returns the number of characters written excluding the
> -        * the terminating null. So, if >= BTF_MAX_NAME_SIZE are written, it
> +        * terminating null. So, if >= BTF_MAX_NAME_SIZE are written, it
>          * indicates truncation.
>          */
>         if (ret < 0 || ret >= sizeof(btf_type_name))
> @@ -10075,7 +10075,7 @@ struct bpf_link {
>  int bpf_link__update_program(struct bpf_link *link, struct bpf_program *prog)
>  {
>         int ret;
> -
> +
>         ret = bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog), NULL);
>         return libbpf_err_errno(ret);
>  }
> --
> 2.32.0
>
