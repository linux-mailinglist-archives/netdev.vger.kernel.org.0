Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E07443CE3
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 06:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhKCFzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 01:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhKCFzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 01:55:12 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052EEC061714;
        Tue,  2 Nov 2021 22:52:37 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id n36-20020a17090a5aa700b0019fa884ab85so633700pji.5;
        Tue, 02 Nov 2021 22:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V23b+TjsFkoXHxyVNTTnYv9pOKhL3GNxVTtHYPNeyC0=;
        b=H8HpcYDsiKxUAlvyigL0NvlV/6ZyWSm+IMzgAY2iHJTkBcKUTNBGH6DpbFRpUESj2U
         xb/wdNHVlvJeS1DUnfyUSrpo6+9LaqYonREj4kZ//O+Ef1sJfG5nPLkgTZYjHcIPC26u
         7qTng6ZJx3BlxEQnGvb7FGcG3VL4LRmTl2QO1Waw245qPx/4bBKa+Ub1V2SiP7n11I6M
         A7Qyo/qP7E4KThO8lzoLwjHnx2VoYAjXSmD+tjo3/ncEAQIpGOmRX6T+oOs/Yp6c/VzB
         QXeSA8YKwzbrrQ5XY4HeAcWLiUEYGE1VXqZ4YywLsVourMtxbxkKkO1SHb7v8um7pmbM
         c5EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V23b+TjsFkoXHxyVNTTnYv9pOKhL3GNxVTtHYPNeyC0=;
        b=KW6mgUjFrO1OzrzJzvFfEAPrkYfZlZl3CBEQn+rbL7k+OR8wP/Fx5X5kH545fILT/s
         RTADah3flzEBYxGMqa0xaPLvyNKqqOXwypp/45QAqaOwLPCwTW6xCEfFMCmpuhAuUhe/
         c4t95VwTRjx4X9ljht5CMUhcx1kctuhlnH0+eQYBj9TNmByqvYJcmTAJiTm1BMitFWkq
         6eY6hgdkWBgedanQjhfS5b9GxZABK10TJNWEKcbtwzk28O7/XPpV7W48e6Wo3B2a8ZMm
         FaYjlBTY+xnJLE4VMebtmy128zsZGqFLqHYUx36AkUHDJbPssJk3n1CAFKezHw/88S6u
         P2mw==
X-Gm-Message-State: AOAM533HcDPV8t46ck/UOqqu8miMK1UMfdlpbDLDXGEgyKTgz9Oaba0s
        RN9MBXDmI3p21z/N/w2GHTeJ/ppswmYV9SbhkqA=
X-Google-Smtp-Source: ABdhPJxeMWlqiS4ZVPxN0cUNMLSKNa+LuDc99DCo5//to+1597Jyqwv+mpy+X7SfiwZuodktSRjXkg27t1P616ygaSE=
X-Received: by 2002:a17:90a:17a5:: with SMTP id q34mr12210406pja.122.1635918756539;
 Tue, 02 Nov 2021 22:52:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211103054722.25285-1-zhang.mingyu@zte.com.cn>
In-Reply-To: <20211103054722.25285-1-zhang.mingyu@zte.com.cn>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 2 Nov 2021 22:52:25 -0700
Message-ID: <CAADnVQL4a8ceotRpsOH--2fPz_f2tTHedoj6uYm9RC4J=KgiMg@mail.gmail.com>
Subject: Re: [PATCH] bpf, x86:remove unneeded variable
To:     cgel.zte@gmail.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Wang YanQing <udknight@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Zhang Mingyu <zhang.mingyu@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 2, 2021 at 10:47 PM <cgel.zte@gmail.com> wrote:
>
> From: Zhang Mingyu <zhang.mingyu@zte.com.cn>
>
> Fix the following coccinelle REVIEW:
> ./arch/x86/net/bpf_jit_comp32.c:1274:5-8

trash that checker and please send patches after you tested them.

> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Zhang Mingyu <zhang.mingyu@zte.com.cn>
> ---
>  arch/x86/net/bpf_jit_comp32.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
> index da9b7cfa4632..bce7b9b5a653 100644
> --- a/arch/x86/net/bpf_jit_comp32.c
> +++ b/arch/x86/net/bpf_jit_comp32.c
> @@ -1271,7 +1271,6 @@ static void emit_epilogue(u8 **pprog, u32 stack_depth)
>  static int emit_jmp_edx(u8 **pprog, u8 *ip)
>  {
>         u8 *prog = *pprog;
> -       int cnt = 0;
>
>  #ifdef CONFIG_RETPOLINE
>         EMIT1_off32(0xE9, (u8 *)__x86_indirect_thunk_edx - (ip + 5));
> @@ -1280,7 +1279,7 @@ static int emit_jmp_edx(u8 **pprog, u8 *ip)
>  #endif
>         *pprog = prog;
>
> -       return cnt;
> +       return 0;
>  }
>
>  /*
> --
> 2.25.1
>
