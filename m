Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CFA33E775
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 04:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhCQDIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 23:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhCQDIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 23:08:22 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B09BC06174A;
        Tue, 16 Mar 2021 20:08:22 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id y133so585670ybe.12;
        Tue, 16 Mar 2021 20:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PEPZ394cidbqYDnUkwG46rTPDl5CRtpu54quZQwlhPs=;
        b=RaZnqoqWvd4ZxPnwWjAhl12hMgFb++XrL4xNpWWZ52ALQOFJFuoYUm6TcmWKrzUxAe
         iWvHLCNt3c2N9AcUMwRJNDd6+A7LYNvrATuDYUSu86X7uux2Tbxuw9SJtmzavrUkdoGQ
         ACP87VuXxMjdjhZbFO82Zc490ZPVcK0OgS1lWbhNAumdLx3qFVhjp58Ul9RFUVKlg7y3
         5DxrmBADq4a8bdCzJQ61Sr8PXDqLqRsD0uYslld5fcblBln1zRV2XUACFjJb5Kvk3PoT
         99zjqDzrBuoLmYFP5vrtWKTfN5JLd0Upg3IcnRP1GloMfwm+O1JxLuKcP9ECyyf9hVBF
         Rr6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PEPZ394cidbqYDnUkwG46rTPDl5CRtpu54quZQwlhPs=;
        b=W3viH+L8FMLu3XufrxmbRtGgFqlKqWiJRkmXwQbk12rOKO3rMIn/ceqlIaS+ynD/RW
         oBKxaiIi5F9jMf+MAz+EkUfgmp9vDuVGdOfTp7NrEkZxzsXQmqOnRfM4sUPUrX7dgZyS
         ftZ0ygkz5wm/TTXk6jG9Be/M2rbo5hX/+TbDmKQiTTlEhqjpqeYbCJhmevu2HsmwCIuX
         PKcOqAOfMVEyQUCy3BmNJlQxBD9WctT2GXPKIASkFJtxwRT/bnfXWK+a9PJ4p56aZlct
         FszEKtE6w98duqP5km7saK7ptrv9eIhIzBXIccvydPOBNFrcIzBVti7oewIVl2O7u4PY
         nBkg==
X-Gm-Message-State: AOAM533jw+qJLPnxZ34YZFCFzy+UI/isHacYllJKNJ3E8dn+sD7IuFFb
        9P9XjcEBRfZ+tMByTP6QaVCV+eOrkqA7efhsUyA=
X-Google-Smtp-Source: ABdhPJzdyKV1honoteIZ9WhfG98djNycTbFpVEZmUzALN3axIR+qzZqd2UFoWkL0n6EnX5I4/PswcpLQRnwVQHeE//I=
X-Received: by 2002:a25:40d8:: with SMTP id n207mr2215999yba.459.1615950501307;
 Tue, 16 Mar 2021 20:08:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210317030312.802233-1-andrii@kernel.org> <20210317030312.802233-2-andrii@kernel.org>
In-Reply-To: <20210317030312.802233-2-andrii@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 16 Mar 2021 20:08:10 -0700
Message-ID: <CAEf4BzYLMNX0PKtM5OPNUK8+Hbd42V6xtbPLxyfOeVgYVX6Riw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] bpftool: generate NULL definition in vmlinux.h
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 8:03 PM Andrii Nakryiko <andrii@kernel.org> wrote:
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
> progs/skb_pkt_end.c:7:9: warning: 'NULL' macro redefined [-Wmacro-redefined]
>   progs/skb_pkt_end.c:7:9: error: 'NULL' macro redefined [-Werror,-Wmacro-redefined]

oops, this shouldn't have been copy/pasted. This is how the line above
looks like if -Werror is specified in Makefile.

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
> +       printf("\n");
>         printf("#ifndef BPF_NO_PRESERVE_ACCESS_INDEX\n");
>         printf("#pragma clang attribute push (__attribute__((preserve_access_index)), apply_to = record)\n");
>         printf("#endif\n\n");
> --
> 2.30.2
>
