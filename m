Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003FA3BF20B
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 00:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhGGWZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 18:25:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229956AbhGGWZv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 18:25:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4800961CD6;
        Wed,  7 Jul 2021 22:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625696590;
        bh=5/l44xHkURCHAD9g66CEvnyXk/coUzDcY6uOjA89jO8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QGWKs08J3iEPfq66a6ZcCWCfINJw0ZCVJ2hPMW9SolR4r7uP1dVDosWaVyhc4nsPb
         UM+w/0nH5SnflXUqC1N0fX2O5jG0qhqKJgU7h4ZYttsHXNKXDJK1G7qNi9fbDlqd5t
         uIO81CBJwWvqou80xYV3/+ZyGeybcco/muhuDSjp6wU9OAr4qreqiqGtotzcbulkcB
         EGjQt91pwPReAaWKD+azxuXqI2MKd6hDlXbutbBfc4QcByuaPU66vnwxbEj0ulj4wC
         7Azv/wSuXfhkCfrRzjGRAOBAGtWnX2mDSaHGQT2DE59ZFFiCtdneHM+ZX8BHkjxDav
         r6brr6DHo1PrQ==
Received: by mail-wm1-f45.google.com with SMTP id k16-20020a05600c1c90b02901f4ed0fcfe7so2661196wms.5;
        Wed, 07 Jul 2021 15:23:10 -0700 (PDT)
X-Gm-Message-State: AOAM530oeRqZ56/YceGzo/rNLxpAOB8AIIVee3q7xmyu+dVSNmxWlZUm
        j1NaIDhimsjdeQharl/Kmyeg+cUk7bNF/QMjMwY=
X-Google-Smtp-Source: ABdhPJxgRCyfXiQSAefT7VEEQVGFWK+Lz/trrhDpP0pUaDiALysArs7L/YPhbEfyOxyNvpo5bnIWhOVKA0lzjvKtmKg=
X-Received: by 2002:a05:600c:4f53:: with SMTP id m19mr26994484wmq.176.1625696588806;
 Wed, 07 Jul 2021 15:23:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210707174022.517-1-royujjal@gmail.com>
In-Reply-To: <20210707174022.517-1-royujjal@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 7 Jul 2021 15:22:57 -0700
X-Gmail-Original-Message-ID: <CAPhsuW78LzzFL_=9LmfXWxfh9=mG1CP33+w_cko1=W8BSag+RA@mail.gmail.com>
Message-ID: <CAPhsuW78LzzFL_=9LmfXWxfh9=mG1CP33+w_cko1=W8BSag+RA@mail.gmail.com>
Subject: Re: [PATCH] docs: bpf: Added more extension example
To:     UjjaL Roy <royujjal@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-riscv@lists.infradead.org, clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 10:50 AM UjjaL Roy <royujjal@gmail.com> wrote:
>
> From: "Roy, UjjaL" <royujjal@gmail.com>
>
> After reading this document observed that for new users it is
> hard to find an example of "extension" easily.
>
> So, added a new heading for extensions for better readability.
> Now, the new readers can easily identify "extension" examples.
> Also, added one more example of filtering interface index.
>
> Signed-off-by: Roy, UjjaL <royujjal@gmail.com>

Please prefix the subject with the target tree. In this case, the subject should
say [PATCH bpf-next] xxx. Also, please revise the commit log as suggested in
Documentation/process/submitting-patches.rst:

Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
to do frotz", as if you are giving orders to the codebase to change
its behaviour.

Otherwise, this change looks good to me. You can add my Acked-by
tag in v2. (prefix v2 with [PATCH v2 bpf-next].

Thanks,
Song

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  Documentation/networking/filter.rst | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/networking/filter.rst b/Documentation/networking/filter.rst
> index 3e2221f4abe4..5f13905b12e0 100644
> --- a/Documentation/networking/filter.rst
> +++ b/Documentation/networking/filter.rst
> @@ -320,13 +320,6 @@ Examples for low-level BPF:
>    ret #-1
>    drop: ret #0
>
> -**(Accelerated) VLAN w/ id 10**::
> -
> -  ld vlan_tci
> -  jneq #10, drop
> -  ret #-1
> -  drop: ret #0
> -
>  **icmp random packet sampling, 1 in 4**::
>
>    ldh [12]
> @@ -358,6 +351,22 @@ Examples for low-level BPF:
>    bad: ret #0             /* SECCOMP_RET_KILL_THREAD */
>    good: ret #0x7fff0000   /* SECCOMP_RET_ALLOW */
>
> +Examples for low-level BPF extension:
> +
> +**Packet for interface index 13**::
> +
> +  ld ifidx
> +  jneq #13, drop
> +  ret #-1
> +  drop: ret #0
> +
> +**(Accelerated) VLAN w/ id 10**::
> +
> +  ld vlan_tci
> +  jneq #10, drop
> +  ret #-1
> +  drop: ret #0
> +
>  The above example code can be placed into a file (here called "foo"), and
>  then be passed to the bpf_asm tool for generating opcodes, output that xt_bpf
>  and cls_bpf understands and can directly be loaded with. Example with above
> --
> 2.17.1
>
