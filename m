Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDF63223DA
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 02:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhBWBuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 20:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhBWBtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 20:49:45 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6C8C06178B;
        Mon, 22 Feb 2021 17:49:30 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id m188so14873100yba.13;
        Mon, 22 Feb 2021 17:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=19ACJ1fic9mV42uUnpDAFR0NZ9Dw4Na6mJs9CQ+BSWg=;
        b=LypvH1qwGsVnZ8ZohpQWT3wOTzQUY3BqElmAqgaZr4BPNIaeI1kBcCx6SfsJqXnwoh
         TcCi0mVLgVq1rgNmk4lgqzuJYTQkr4wmzjOeFxq6RWgkRV6KEpqtdeBaj+txAaILT6D4
         7x5BAnF5r0HwLXrIjiELyGzGBhRvCtBx5Dtlt5vOzhtuNzbmixXdhjQohFtBqSnx/iFz
         BNsloVWAXfPcFfrC1JwPuSpjNyqZ84h+7rRDmB7uqj+eai2L+KKhUGN10myNtx8U02qz
         OBxifP1GBB50yLN84rVh/+GKeBsex07iI4Sn4tdTSyR/Eea2hcCq5B9KKnZkC7XLqIA4
         8m0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=19ACJ1fic9mV42uUnpDAFR0NZ9Dw4Na6mJs9CQ+BSWg=;
        b=R8N7IZJC8+KLEBsK2kLcySZlQaP9vGnh5ctiPTuXkRMErVcGvTiTqP0raWryhtPa5x
         HsFCWP3TZnz5fPu/g/WJUnjbu44U0PVF6lGKyfT9YuqhodxgeAQyCxfRPg73BI+mN2C2
         kQtG97N2RESuaW1hFn6qvmLIdkx/nQ/E35LcGF84R8D/DmMnyiUxCu0JjkoeiaSTOUfi
         R2u/M1sChJz4BjUML+6+405SwP0LTwYFAR+4MAMMmz2/B2d0Hdo7rfAlG9VmjpEkFUGp
         AoNMifc7qtMHnvn+0SRKyG0VfxoJhuxpE42TgslhdUMulVYom1h73TvrL6NUlwZr92d5
         JIHA==
X-Gm-Message-State: AOAM532Ybr1IpLmtudkwL/BPmGXwS87eujbl7IM7YtigNn7TWcwOQS0T
        MHi/1a6+c2uy+hcfkV4Fm8QMbvnhSPSgMiVJ4QY=
X-Google-Smtp-Source: ABdhPJxHTS4veMmCO+YwBwO5wCQlc7azPHJKmPse8N4xGOxspLGx1U3QlklOpHhoaiKCDPOmRgncCd9mQlj9wCCsuA0=
X-Received: by 2002:a25:abb2:: with SMTP id v47mr36212197ybi.425.1614044969515;
 Mon, 22 Feb 2021 17:49:29 -0800 (PST)
MIME-Version: 1.0
References: <1613812247-17924-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1613812247-17924-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Feb 2021 17:49:18 -0800
Message-ID: <CAEf4BzYgLf5g3oztbA-CJR4gQ7AVKQAGrsHWCOgTtUMUM-Mxfg@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Remove unnecessary conversion to bool
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 20, 2021 at 1:11 AM Jiapeng Chong
<jiapeng.chong@linux.alibaba.com> wrote:
>
> Fix the following coccicheck warnings:
>
> ./tools/lib/bpf/libbpf.c:1487:43-48: WARNING: conversion to bool not
> needed here.
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---

I think this came up before already. I did this on purpose and I'd
like to keep it that way in the code.


>  tools/lib/bpf/libbpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 6ae748f..5dfdbf3 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1484,7 +1484,7 @@ static int set_kcfg_value_tri(struct extern_desc *ext, void *ext_val,
>                                 ext->name, value);
>                         return -EINVAL;
>                 }
> -               *(bool *)ext_val = value == 'y' ? true : false;
> +               *(bool *)ext_val = value == 'y';
>                 break;
>         case KCFG_TRISTATE:
>                 if (value == 'y')
> --
> 1.8.3.1
>
