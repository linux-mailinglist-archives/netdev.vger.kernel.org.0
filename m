Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1EA01FFF84
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 03:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbgFSBDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 21:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729302AbgFSBDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 21:03:00 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EDDC06174E;
        Thu, 18 Jun 2020 18:03:00 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id k22so6036386qtm.6;
        Thu, 18 Jun 2020 18:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jUeKDw9KwgKOpF7+xORxfjgCJi8TIoaW0or7bX5Oipo=;
        b=QwVGOIw2/cksqydTBxBr7zdlOeMvoeDZaPkr531dJC0Kow8dYNL1e+yJgq+E4tb/jx
         SKjOa89U1KoJrH9YuhRaLtXmAWRZDr7ufH9aG89PNf4wPOOZb43CZxCkv+Gg6ppB5Lpj
         rOtVjnUP/4tEfu17TCh13eL86tzDWWQiu4s5jDL2D2Bdi8k0D0QyTTqL/FqQR3XWwxT5
         HJN2TMaLneEJUsmypWfLgH+HSYcAchYO1tZnrPOkF73SYCisOQL+i3T+c81h1U6hMxS8
         JJu/4I//Jse0GeK4sSYDj8e9zzC0KJEu9s4cqfQX8lgknZdlbeVVWcSyHc0PDEtu0Rj/
         vvAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jUeKDw9KwgKOpF7+xORxfjgCJi8TIoaW0or7bX5Oipo=;
        b=fL5gRbdnFJ9bc0ua9ErxuLBEN0Kt7bpjTpLnQLHzVJg8j/+W9E2ma3GsI7VCQF88I8
         J4L6vg7j6PMqwUdhZtYcTlFZewCL8o03kx4vyXlCnJDgbrtsX19QOpiNG4o+S4GfWe/t
         s5m42DOx4AmzeadJT6avDU3zC5WMd+Oj+iot8iyviiq4MRcH9TwFWZdkE+kuCe8vGF9n
         LZelBKZQ/9OxOb3d9Dvgqy3NbNjwBEaYVzxlCGFakLd+iKXuR6ZgbA7zRJgeTYj5Ekwr
         +WCv8KeYoFOa60clN2Zc5Kti4F8XgVv1ergcy/mOYpZrXt2z8xkQKFpy4W1tFSeUHzYN
         GEdg==
X-Gm-Message-State: AOAM532OUPTUXVCeVDquHugjxVET1zMQFMCP9D3vkMcLE0oCIRiuB4A5
        NTM+m5DnWh/YcaDErVrXPwQR235ZU3c9NsoDdneaiPNf
X-Google-Smtp-Source: ABdhPJxDyoK5vrsmc4DNXmJKbQxA8rM6fHJ9JlzmQbTMJtuC9/PZx2xLd7IOJnYVhw7jc3lOsiRIs2xrmNA4bLWgIsg=
X-Received: by 2002:ac8:342b:: with SMTP id u40mr1030783qtb.59.1592528579415;
 Thu, 18 Jun 2020 18:02:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200616100512.2168860-1-jolsa@kernel.org> <20200616100512.2168860-4-jolsa@kernel.org>
In-Reply-To: <20200616100512.2168860-4-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jun 2020 18:02:48 -0700
Message-ID: <CAEf4BzZBKyP2uifNeH6pBm=wQk_WwhL8DjGdgsjgxmQUNqe_Lw@mail.gmail.com>
Subject: Re: [PATCH 03/11] bpf: Add btf_ids object
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 3:05 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding support to generate .BTF_ids section that would
> hold various BTF IDs list for verifier.
>
> Adding macros help to define lists of BTF IDs placed in
> .BTF_ids section. They are initially filled with zeros
> (during compilation) and resolved later during the
> linking phase by btfid tool.
>
> Following defines list of one BTF ID that is accessible
> within kernel code as bpf_skb_output_btf_ids array.
>
>   extern int bpf_skb_output_btf_ids[];
>
>   BTF_ID_LIST(bpf_skb_output_btf_ids)
>   BTF_ID(struct, sk_buff)
>
> Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/asm-generic/vmlinux.lds.h |  4 ++
>  kernel/bpf/Makefile               |  2 +-
>  kernel/bpf/btf_ids.c              |  3 ++
>  kernel/bpf/btf_ids.h              | 70 +++++++++++++++++++++++++++++++
>  4 files changed, 78 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/bpf/btf_ids.c
>  create mode 100644 kernel/bpf/btf_ids.h
>
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index db600ef218d7..0be2ee265931 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -641,6 +641,10 @@
>                 __start_BTF = .;                                        \
>                 *(.BTF)                                                 \
>                 __stop_BTF = .;                                         \
> +       }                                                               \
> +       . = ALIGN(4);                                                   \
> +       .BTF_ids : AT(ADDR(.BTF_ids) - LOAD_OFFSET) {                   \
> +               *(.BTF_ids)                                             \
>         }
>  #else
>  #define BTF
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index 1131a921e1a6..21e4fc7c25ab 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -7,7 +7,7 @@ obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list
>  obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
>  obj-$(CONFIG_BPF_SYSCALL) += disasm.o
>  obj-$(CONFIG_BPF_JIT) += trampoline.o
> -obj-$(CONFIG_BPF_SYSCALL) += btf.o
> +obj-$(CONFIG_BPF_SYSCALL) += btf.o btf_ids.o
>  obj-$(CONFIG_BPF_JIT) += dispatcher.o
>  ifeq ($(CONFIG_NET),y)
>  obj-$(CONFIG_BPF_SYSCALL) += devmap.o
> diff --git a/kernel/bpf/btf_ids.c b/kernel/bpf/btf_ids.c
> new file mode 100644
> index 000000000000..e7f9d94ad293
> --- /dev/null
> +++ b/kernel/bpf/btf_ids.c
> @@ -0,0 +1,3 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include "btf_ids.h"

hm... what's the purpose of this btf_ids.c file?

> diff --git a/kernel/bpf/btf_ids.h b/kernel/bpf/btf_ids.h
> new file mode 100644
> index 000000000000..68aa5c38a37f
> --- /dev/null
> +++ b/kernel/bpf/btf_ids.h

[...]
