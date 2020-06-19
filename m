Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03801FFF7C
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 02:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgFSA4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 20:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbgFSA4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 20:56:50 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4800C06174E;
        Thu, 18 Jun 2020 17:56:49 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id n11so7516582qkn.8;
        Thu, 18 Jun 2020 17:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9pMA7AOTnfX3wDS/xjVwuvowIlPFxQt7GM2930O06qA=;
        b=iyNRzillYpql+FBKQ1TULX+tzGNUdk/os1cxAjlqOINlEs6A3u2hRN+VOw+LlMH1Rs
         zTZG+XzJrmoX5PyrXh4a7Sxq4H3IKrvWBKgVTHuu/063fBImCdu7xMnKCvrfs6NJicSn
         p+WlnTEC/VRXxZF0FNatnTrDqKnY0CzWcO0aMb2bOlCYOSgE+ajwFercQae4FREpsXwf
         rTZNSMx1zEAtfTv5UMafKEIW75snErnDleEEsJ2GMhtZklX0YhyU7Avw3cTalr84AHNg
         NUG00mGRi1SR2vwelD4OoLthiy1WCquhr6aUpCLC3vvMiaBWopqF7qoUGhyL4Te+qikE
         rg5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9pMA7AOTnfX3wDS/xjVwuvowIlPFxQt7GM2930O06qA=;
        b=I0O7D/AWUfZZ8DHwb+iWlEIQjoLNXTNZGOYnZD0iD9JEYs52ZwP9yHfmQ3Va69izUU
         onhQe2IU+UvjyEPxwksv0U254/42NxjHuudOmYxP4gOwIB0ZsNGRoMi4Id3O1TXGN9s1
         6rRE6R8G5mdMY/96eBEAPTxzf6P0/TFlm0V5W8X92/Tg7r+fHN8ewMfSGRsdddb7nxEH
         WlDt2mgllgGpht3FCWZWdPsyZ5/dX7vDvw/IPuuXleg0OXs46RoBQr607QUQQkUz4QEX
         HBL4Kcrw8KncT+4rkfgAsbz/POVTmHltONdpPW7ABlsoZfGCbUtI91L6/kidKB3Z4qsa
         gjog==
X-Gm-Message-State: AOAM532mXGLzaKkZgJtTfRFZlpVH/cyLuisSKolAsxB6u+VtxzpdMBOs
        T9XfjdWB/AQRZ1TKpO75LYPSsTzm+Rvpc7iI4T8=
X-Google-Smtp-Source: ABdhPJx4PWdvP70EnLwAXDlg/E61cjvYjW+ho/RGJLuoj+zIdYFq0ORSy8qhlsbHn7Ref1z5QLjJL8wcgxsKkS1smbI=
X-Received: by 2002:a37:6712:: with SMTP id b18mr1248128qkc.36.1592528208896;
 Thu, 18 Jun 2020 17:56:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200616100512.2168860-1-jolsa@kernel.org> <20200616100512.2168860-4-jolsa@kernel.org>
In-Reply-To: <20200616100512.2168860-4-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jun 2020 17:56:38 -0700
Message-ID: <CAEf4BzZ=BN7zDU_8xMEEoF7khjC4bwGitU+iYf+6uFXPZ_=u-g@mail.gmail.com>
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

[...]

> +/*
> + * Following macros help to define lists of BTF IDs placed
> + * in .BTF_ids section. They are initially filled with zeros
> + * (during compilation) and resolved later during the
> + * linking phase by btfid tool.
> + *
> + * Any change in list layout must be reflected in btfid
> + * tool logic.
> + */
> +
> +#define SECTION ".BTF_ids"

nit: SECTION is super generic and non-greppable. BTF_IDS_SECTION?

> +
> +#define ____BTF_ID(symbol)                             \
> +asm(                                                   \
> +".pushsection " SECTION ",\"a\";               \n"     \

section should be also read-only? Either immediately here, of btfid
tool should mark it? Unless I missed that it's already doing it :)

> +".local " #symbol " ;                          \n"     \
> +".type  " #symbol ", @object;                  \n"     \
> +".size  " #symbol ", 4;                        \n"     \
> +#symbol ":                                     \n"     \
> +".zero 4                                       \n"     \
> +".popsection;                                  \n");
> +
> +#define __BTF_ID(...) \
> +       ____BTF_ID(__VA_ARGS__)

why varargs, if it's always a single argument? Or it's one of those
macro black magic things were it works only in this particular case,
but not others?


> +
> +#define __ID(prefix) \
> +       __PASTE(prefix, __COUNTER__)
> +
> +
> +/*
> + * The BTF_ID defines unique symbol for each ID pointing
> + * to 4 zero bytes.
> + */
> +#define BTF_ID(prefix, name) \
> +       __BTF_ID(__ID(__BTF_ID__##prefix##__##name##__))
> +
> +
> +/*
> + * The BTF_ID_LIST macro defines pure (unsorted) list
> + * of BTF IDs, with following layout:
> + *
> + * BTF_ID_LIST(list1)
> + * BTF_ID(type1, name1)
> + * BTF_ID(type2, name2)
> + *
> + * list1:
> + * __BTF_ID__type1__name1__1:
> + * .zero 4
> + * __BTF_ID__type2__name2__2:
> + * .zero 4
> + *
> + */
> +#define BTF_ID_LIST(name)                              \

nit: btw, you call it a list here, but btfids tool talks about
"sorts". Maybe stick to consistent naming. Either "list" or "set"
seems to be appropriate. Set implies a sorted aspect a bit more, IMO.

> +asm(                                                   \
> +".pushsection " SECTION ",\"a\";               \n"     \
> +".global " #name ";                            \n"     \

I was expecting to see reserved 4 bytes for list size? I also couldn't
find where btfids tool prepends it. From what I could understand, it
just assumed the first 4 bytes are the length prefix? Sorry if I'm
slow...


> +#name ":;                                      \n"     \
> +".popsection;                                  \n");
> +
> +#endif
> --
> 2.25.4
>
