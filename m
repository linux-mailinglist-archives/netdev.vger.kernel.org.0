Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A7820BB9F
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 23:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgFZVdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 17:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgFZVdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 17:33:00 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A46C03E979;
        Fri, 26 Jun 2020 14:33:00 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id o38so8590390qtf.6;
        Fri, 26 Jun 2020 14:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YGOn4OHMzKMUBD2Ka3ClzBwELUAGANd/QNEPI3e6ipA=;
        b=cMpQEhjAeArSQL8NL1hdjCfFT73zPKzDcjMK7YGhEDX1qSYCOtmF2oMubzKe/3ROGE
         HdaCPaW1K7IUGOTxDVISrOddQmpGMOuUKf7PvUtLMAUs6kMzJdY8AALczpCrG0MW1Oys
         EnZ8KUywkOjMkMSNUb53Sxk3IxKPRk9OOa2aVmcFFullcAWgJmS/z+Ot11kcaJMtjs6a
         wNenRVxlo2F60R2kux7TrbzfC/ivBimGZRpAO/KbSAOG4eBOEh9fEuqETZT2RYGLwipQ
         7OvlrAmAKXByICXKp/UyqgoZNPmyNeB1Xqpc+VuY/xcp7qFeDmkI1TTrZRw8qtv+jEyP
         hPXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YGOn4OHMzKMUBD2Ka3ClzBwELUAGANd/QNEPI3e6ipA=;
        b=HfoP/agl3IiWQlCxcV7eizGsCteT00cvjkMhyQ91MEGima1wtwt3+ELn/bhrbTTuiN
         SqyLEkiWzhDZ6N5GflR+WyZstEE5tlWK+o5jvB3qQ7H0y8CozVSPZ4FXqZ1nJN/83JKS
         1FgCbe7mg834jQc1ABXAg3E6I01IA0ADanAPm8Z29FAWQrHTHjU0RdRpt5C6aP97UePj
         wbEeun3oGMTnEuFA6dreViWZODlO8Mrj/HVbyredNGjw4tBr+44ItrswMcp5CrXFGgQL
         HfJE0Ia4/hJ/x36Sxilwh5iJ7w8MJanrry55f8iAjfrYFBvo6Iplp84D0BcAZT45CLWP
         Mwug==
X-Gm-Message-State: AOAM53004ctjUyy+KQE4a4HotES14fIBwas8KK8DupaylvT4gWhFr6Xa
        KkpfPL92TVFP646VckwHRZujUr9OyMHdch6Scoo=
X-Google-Smtp-Source: ABdhPJxcihi/OvVwmt0+6PdkzjXjSYqzJ0rqP30TPE75nOS5bDfFEufLF3VuI5IxqhrGzdg6RKfBc7zYphcN6nOwl2A=
X-Received: by 2002:ac8:2bba:: with SMTP id m55mr4872782qtm.171.1593207179708;
 Fri, 26 Jun 2020 14:32:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200625221304.2817194-1-jolsa@kernel.org> <20200625221304.2817194-4-jolsa@kernel.org>
In-Reply-To: <20200625221304.2817194-4-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 14:32:48 -0700
Message-ID: <CAEf4BzbceMFA60=7Jp7oC9x-gMvhKQtWmuhV3ncVKUhHHDzugA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 03/14] bpf: Add BTF_ID_LIST/BTF_ID macros
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

On Thu, Jun 25, 2020 at 3:13 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding support to generate .BTF_ids section that will hold BTF
> ID lists for verifier.
>
> Adding macros that will help to define lists of BTF ID values
> placed in .BTF_ids section. They are initially filled with zeros
> (during compilation) and resolved later during the linking phase
> by resolve_btfids tool.
>
> Following defines list of one BTF ID value:
>
>   BTF_ID_LIST(bpf_skb_output_btf_ids)
>   BTF_ID(struct, sk_buff)
>
> It also defines following variable to access the list:
>
>   extern int bpf_skb_output_btf_ids[];
>
> Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Looks good, with few nits below.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/asm-generic/vmlinux.lds.h |  4 ++
>  include/linux/btf_ids.h           | 69 +++++++++++++++++++++++++++++++
>  2 files changed, 73 insertions(+)
>  create mode 100644 include/linux/btf_ids.h
>

[...]

> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
> new file mode 100644
> index 000000000000..f7f9dc4d9a9f
> --- /dev/null
> +++ b/include/linux/btf_ids.h
> @@ -0,0 +1,69 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _LINUX_BTF_IDS_H
> +#define _LINUX_BTF_IDS_H 1

this "1", is it necessary? I think it's always just `#define HEADER_GUARD`?

> +
> +#include <linux/compiler.h> /* for __PASTE */
> +

[...]

> +#define __BTF_ID_LIST(name)                            \
> +asm(                                                   \
> +".pushsection " BTF_IDS_SECTION ",\"a\";       \n"     \
> +".local " #name ";                             \n"     \
> +#name ":;                                      \n"     \
> +".popsection;                                  \n");   \
> +
> +#define BTF_ID_LIST(name)                              \
> +__BTF_ID_LIST(name)                                    \
> +extern int name[];

nit: extern u32 (or __u32) perhaps?

> +
> +#endif
> --
> 2.25.4
>
