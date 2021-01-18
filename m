Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A5F2F9D5C
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 12:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389822AbhARK7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 05:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389794AbhARK6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 05:58:52 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB80AC061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 02:58:11 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id d81so16788607iof.3
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 02:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=N0XJonBpSyKApClVc8rxeObW+thdWbkeBXzIT5gyi4Y=;
        b=uJEJBtOg7muoVHlHZdfnotlFA28g1omo+d9pcxHfeH/+kjkkzvPoIUoPnIthuXA62d
         WVKnFssY1I4ANlSASkBTGyWUwanQkIXc1D9razDzY7YD9tAHkqdIbH5thtuDn27RAkWa
         7RRts3PMw+nOIPI6vPRZh6MDc6hhHi1g9XcLJYSLlb3WywC9hlNcRlX7boJTUS5kMfAs
         EG2xriyIvhFREXgljKtxYGBv6jf9tz7nt/bR5IXq5lQl3rB7reupiPM+ygtkhPraUVly
         m2+K54ISg9Y+l2QfltmXXfKUVweT9y9jinTMIQy0ohx8ioW7WLdUr1yqr/ywakZ6DDIa
         Pt+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N0XJonBpSyKApClVc8rxeObW+thdWbkeBXzIT5gyi4Y=;
        b=fKzwxuOLrqpZMUp9C591Z0NKBqYCG5tWUYZLT6RJPVZ9DuXcdIks2aOe3eNgUkfuu1
         ZWyh3exUoU2fBFeU73ig24fqiOM47+jopg056/z/JHoBwpdD8gXqwkSDr6mw9AZw1M5v
         BvlG7ijcj593eKZifUM0MX87zdZOga33mRbVMUwwSYRnayv9ZCgLcmV9xcLqzdRPsv44
         YRbbhq/94VdixYyIvPhXozAXVQqE/ySl7MR6zvS7mvlz1xVcvxM0igcasd73m5wIoR0R
         +OD/OfP+qw8qjY2t2qlWGBICQY0mzsAqhrk36Np9eJeP+MF1R5jywK02gmbrdA9bJJmY
         X+YQ==
X-Gm-Message-State: AOAM530nsw0n1FN1/nZCBIX3Bpn1Di8aAi4q+LEqHR/6BBuZ0nv8IQO/
        uxQTs7iMQmB2ZVNk9Z8AOgnPgQKpYxgYNhGBH/CfjfaI6szbWA==
X-Google-Smtp-Source: ABdhPJym0NYTNBaKPq7roem+KfAKnoL7dJJJH20c9N5Z5QxImNW6J0z00eX3PWCrspM1ObNnQmk2OGkGdN2fkNFGENY=
X-Received: by 2002:a05:6e02:194a:: with SMTP id x10mr20363981ilu.165.1610967491105;
 Mon, 18 Jan 2021 02:58:11 -0800 (PST)
MIME-Version: 1.0
References: <20210118091753.107572-1-bjorn.topel@gmail.com>
In-Reply-To: <20210118091753.107572-1-bjorn.topel@gmail.com>
From:   Brendan Jackman <jackmanb@google.com>
Date:   Mon, 18 Jan 2021 11:57:59 +0100
Message-ID: <CA+i-1C1A6wdv3vh4=qLsc6GoOSiD=Wc_oe=PhWKE6tHZ_NQnsg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples/bpf: add BPF_ATOMIC_OP macro for BPF samples
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I actually deliberately skipped this file, thinking that people were
unlikely to want to add assembly-based atomics code under samples/

I guess it's nice for people to be able to e.g. move/copy code from
the selftests.

On Mon, 18 Jan 2021 at 10:18, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>=
 wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Brendan Jackman added extend atomic operations to the BPF instruction
> set in commit 7064a7341a0d ("Merge branch 'Atomics for eBPF'"), which
> introduces the BPF_ATOMIC_OP macro. However, that macro was missing
> for the BPF samples. Fix that by adding it into bpf_insn.h.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Reviewed-by: Brendan Jackman <jackmanb@google.com>

> ---
>  samples/bpf/bpf_insn.h | 24 ++++++++++++++++++++----
>  1 file changed, 20 insertions(+), 4 deletions(-)
>
> diff --git a/samples/bpf/bpf_insn.h b/samples/bpf/bpf_insn.h
> index db67a2847395..aee04534483a 100644
> --- a/samples/bpf/bpf_insn.h
> +++ b/samples/bpf/bpf_insn.h
> @@ -134,15 +134,31 @@ struct bpf_insn;
>                 .off   =3D OFF,                                   \
>                 .imm   =3D 0 })
>
> -/* Atomic memory add, *(uint *)(dst_reg + off16) +=3D src_reg */
> -
> -#define BPF_STX_XADD(SIZE, DST, SRC, OFF)                      \
> +/*
> + * Atomic operations:
> + *
> + *   BPF_ADD                  *(uint *) (dst_reg + off16) +=3D src_reg
> + *   BPF_AND                  *(uint *) (dst_reg + off16) &=3D src_reg
> + *   BPF_OR                   *(uint *) (dst_reg + off16) |=3D src_reg
> + *   BPF_XOR                  *(uint *) (dst_reg + off16) ^=3D src_reg
> + *   BPF_ADD | BPF_FETCH      src_reg =3D atomic_fetch_add(dst_reg + off=
16, src_reg);
> + *   BPF_AND | BPF_FETCH      src_reg =3D atomic_fetch_and(dst_reg + off=
16, src_reg);
> + *   BPF_OR | BPF_FETCH       src_reg =3D atomic_fetch_or(dst_reg + off1=
6, src_reg);
> + *   BPF_XOR | BPF_FETCH      src_reg =3D atomic_fetch_xor(dst_reg + off=
16, src_reg);
> + *   BPF_XCHG                 src_reg =3D atomic_xchg(dst_reg + off16, s=
rc_reg)
> + *   BPF_CMPXCHG              r0 =3D atomic_cmpxchg(dst_reg + off16, r0,=
 src_reg)
> + */
> +
> +#define BPF_ATOMIC_OP(SIZE, OP, DST, SRC, OFF)                 \
>         ((struct bpf_insn) {                                    \
>                 .code  =3D BPF_STX | BPF_SIZE(SIZE) | BPF_ATOMIC, \
>                 .dst_reg =3D DST,                                 \
>                 .src_reg =3D SRC,                                 \
>                 .off   =3D OFF,                                   \
> -               .imm   =3D BPF_ADD })
> +               .imm   =3D OP })
> +
> +/* Legacy alias */
> +#define BPF_STX_XADD(SIZE, DST, SRC, OFF) BPF_ATOMIC_OP(SIZE, BPF_ADD, D=
ST, SRC, OFF)
>
>  /* Memory store, *(uint *) (dst_reg + off16) =3D imm32 */
>
>
> base-commit: 232164e041e925a920bfd28e63d5233cfad90b73
> --
> 2.27.0
>
