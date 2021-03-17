Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6042433F732
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 18:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhCQRgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 13:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbhCQRgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 13:36:35 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B746C06174A;
        Wed, 17 Mar 2021 10:36:35 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id h82so41298530ybc.13;
        Wed, 17 Mar 2021 10:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=618WALjJIxnoRX71TO5tqh7tWD2SrUCrHrmIONBIR6A=;
        b=BHN+kaQuAN9ajyZ769MLaLcKPXblFO0EprGhpHEhhqPfs4lUT+d1dUK1ZY5MHwjaqb
         4+HKLeZnuvMk4w4A/Q7c1wmLc+OgagWdI7JfTVihERaB5OnFsKJ+MweEwzVi2n9EO7NF
         ynEpF37K0lgpn/tQcoVG4W5vF1UCHK47/GmymCPXMhukVs7rz/XycLLQQ117zdMq2HTn
         VJKlVzy58KVWZ5CwwAEmFd1+o2AskkUdAT1n19E4mhQ4qFqWpgfwpLI/JSkJVO4li/9R
         XB2nd07jOnzYIuVC/uQ5hVd/08IH9UlMPOdWIC/bAKtLfM7hI3N4cjAJQT2rcjHutt84
         sHDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=618WALjJIxnoRX71TO5tqh7tWD2SrUCrHrmIONBIR6A=;
        b=lQ79TeatlqwIrP+VbU1vTGqA5pe1wWdx5Xsx/thHYZszp/JP0Ta1PBUqU19h4zwB/A
         NeoHo3up9HjdOYOHGRNAZIzbYq9c2CPuCF91y2kkk0Xduf4q0c5SjnB/ucTLdUH0p8OO
         3AkYTOjoh/yPlGgSw7IqhB30EXWiie3Zpo037W4hXOfwO6gjraQZwzSNRZEeEu95EfIg
         /SmhvoMKVwR0EMWbY3K/vgeO6c5pcLFTuYWlX+C7DYthsA/Oh8WA6JksYtbVLafYa3bu
         YFFmnVCeakA1qHaCCIbrrdL8pEoJwm7OnVZUjVtR/o49dXI4ynbLdxr+wR4rLMLmizha
         qmTQ==
X-Gm-Message-State: AOAM530aN8R3P46gAx0/LH5HmQYb9UqIJZlBD6LqKrsE1effKUZ15FUj
        fpVTUA29LZ4+WoJRRs8L6hbOAIDecxqZxlP8rm4unDJqGbE=
X-Google-Smtp-Source: ABdhPJzVZVgcggY4QVZ3ulcxry2lt13g1VmRv2tEWzWF5Ux39C2q6lkGFC4osu9qwFcamnhcDg0fGCQWqHyVRwhVjdE=
X-Received: by 2002:a25:40d8:: with SMTP id n207mr5772526yba.459.1616002594619;
 Wed, 17 Mar 2021 10:36:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210317031257.846314-1-andrii@kernel.org> <20210317031257.846314-2-andrii@kernel.org>
In-Reply-To: <20210317031257.846314-2-andrii@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 17 Mar 2021 10:36:23 -0700
Message-ID: <CAEf4BzYYkJqdvamkgoCqGF23Av44n322FMz+-HWO9YxXBNLqVw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpftool: generate NULL definition in vmlinux.h
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 8:13 PM Andrii Nakryiko <andrii@kernel.org> wrote:
>
> Given that vmlinux.h is not compatible with headers like stdint.h, NULL poses
> an annoying problem: it is defined as #define, so is not captured in BTF, so
> is not emitted into vmlinux.h. This leads to users either sticking to explicit
> 0, or defining their own NULL (as progs/skb_pkt_end.c does).
>
> It's pretty trivial for bpftool to generate NULL definition, though, so let's
> just do that. This might cause compilation warning for existing BPF
> applications:
>
>   progs/skb_pkt_end.c:7:9: warning: 'NULL' macro redefined [-Wmacro-redefined]
>   #define NULL 0
>           ^
>   /tmp/linux/tools/testing/selftests/bpf/tools/include/vmlinux.h:4:9: note: previous definition is here
>   #define NULL ((void *)0)
>           ^
>
> It is trivial to fix, though, so long-term benefits outweight temporary
> inconveniences.
>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  tools/bpf/bpftool/btf.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
> index 62953bbf68b4..ff6a76632873 100644
> --- a/tools/bpf/bpftool/btf.c
> +++ b/tools/bpf/bpftool/btf.c
> @@ -405,6 +405,8 @@ static int dump_btf_c(const struct btf *btf,
>         printf("#ifndef __VMLINUX_H__\n");
>         printf("#define __VMLINUX_H__\n");
>         printf("\n");
> +       printf("#define NULL ((void *)0)\n");


On second thought, this could also be done in bpf_helpers.h, which is
pretty much always included in BPF programs. I think that's a bit more
maintainable and less magical to users, so I'll go with that in v3.

> +       printf("\n");
>         printf("#ifndef BPF_NO_PRESERVE_ACCESS_INDEX\n");
>         printf("#pragma clang attribute push (__attribute__((preserve_access_index)), apply_to = record)\n");
>         printf("#endif\n\n");
> --
> 2.30.2
>
