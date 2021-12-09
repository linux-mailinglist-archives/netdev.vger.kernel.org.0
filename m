Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA89546E302
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 08:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbhLIHRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 02:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbhLIHQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 02:16:58 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A4DC061746;
        Wed,  8 Dec 2021 23:13:25 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id y68so11607364ybe.1;
        Wed, 08 Dec 2021 23:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s1H5Fq8s1lkVMt8xAiimEnNIbdOCsM4+LYdUzaSA8KU=;
        b=eggSlNhtp++FcykP4WfNW2NV7ar72ZJj6lBOtcz83kWMo+v2XCDy72Ni3ACsBTCHjH
         F5NNrHYraJ9GbwkVRw3rQSUdi9b+ZlGblzVNhjNgO/ginvUQRt4/sAAAFAg0dtpoycDZ
         C64QFh4dEYljaKip0zUKaPSErSeLCdHYQGgA/q9xMmU8J11o7uxlLp55B/oBJzWbGa+M
         bd+FKiQyNAoUQGHIkp83j0iBjStI4YevtX1ruQZ1X3b4xPxv2gvOMbM1g1u7DYuvOwTg
         USYDmjHr6yJVZUhhxvZa7YPCwFJsJDapQW4TlRxE1rFu/KXUTWULzxV0aDvAem0o1Bs2
         M4TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s1H5Fq8s1lkVMt8xAiimEnNIbdOCsM4+LYdUzaSA8KU=;
        b=Njwk2bNvqWtaVOhQNTibh/MHfk3NOY125TdyycA5R3bXEE8jZfbNOzU6wLYrhKJuc3
         t8xFMqKiLT29XegG+Thm8P8cASjeGe1PzLlbC9IHX2YkoBjRMm1qESkDt7WtH/djmkBO
         HP00lVA28VFqaBVFEy35mWLqaj1VLeQeoB4tcykyD6/VLM+s2weGSREpioqDE4leW/BU
         whRLY59/fNGC4OeFTc2/WQtSHuVM2ag3EGj+0pQ2/16Wuit0r0FmsCBirN6hRc5a+bof
         uAZvJIghrVTM2Uwo/EI0hVVd8S3YZac72ll4ryP4zm4SXZsESNHnkZZWgCpMAFojt/Qb
         8NLg==
X-Gm-Message-State: AOAM5301/IUqnWefJvQ+oVTbugmIeX5OWAjNKbO8XqcIWNx7JO9Q6cCL
        hRj+YQSkgow+cD0xo0pZQVNuZ5m2y85vdSfeqrDF5Btq+RM=
X-Google-Smtp-Source: ABdhPJwcbWifF21Yw/QexCx51UJkPVNNDNCyGnA1GH6UoBMd/dLu7uSps3ab016BVoEe8bCoyjQ5/N3ppla5RB4lRnA=
X-Received: by 2002:a5b:1c2:: with SMTP id f2mr4628549ybp.150.1639034004538;
 Wed, 08 Dec 2021 23:13:24 -0800 (PST)
MIME-Version: 1.0
References: <20211209015505.409691-1-chi.minghao@zte.com.cn>
In-Reply-To: <20211209015505.409691-1-chi.minghao@zte.com.cn>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 8 Dec 2021 23:13:13 -0800
Message-ID: <CAEf4BzacuM8cR8Xuv5tdg7=KScVi26pZ3CjewAy=UuHouiRZdg@mail.gmail.com>
Subject: Re: [PATCH] samples:bpf:remove unneeded variable
To:     cgel.zte@gmail.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        chiminghao <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cm>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 8, 2021 at 5:55 PM <cgel.zte@gmail.com> wrote:
>
> From: chiminghao <chi.minghao@zte.com.cn>
>
> return value form directly instead of
> taking this in another redundant variable.
>
> Reported-by: Zeal Robot <zealci@zte.com.cm>
> Signed-off-by: chiminghao <chi.minghao@zte.com.cn>

Signed-off-by should contain properly capitalized full name, please update.

Also please use "samples/bpf: " patch prefix and use [PATCH bpf-next]
to designate the destination kernel tree. Thanks.

> ---
>  samples/bpf/xdp_redirect_cpu.bpf.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/samples/bpf/xdp_redirect_cpu.bpf.c b/samples/bpf/xdp_redirect_cpu.bpf.c
> index f10fe3cf25f6..25e3a405375f 100644
> --- a/samples/bpf/xdp_redirect_cpu.bpf.c
> +++ b/samples/bpf/xdp_redirect_cpu.bpf.c
> @@ -100,7 +100,6 @@ u16 get_dest_port_ipv4_udp(struct xdp_md *ctx, u64 nh_off)
>         void *data     = (void *)(long)ctx->data;
>         struct iphdr *iph = data + nh_off;
>         struct udphdr *udph;
> -       u16 dport;
>
>         if (iph + 1 > data_end)
>                 return 0;
> @@ -111,8 +110,7 @@ u16 get_dest_port_ipv4_udp(struct xdp_md *ctx, u64 nh_off)
>         if (udph + 1 > data_end)
>                 return 0;
>
> -       dport = bpf_ntohs(udph->dest);
> -       return dport;
> +       return bpf_ntohs(udph->dest);
>  }
>
>  static __always_inline
> --
> 2.25.1
>
