Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B7F1D8F04
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 07:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgESFIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 01:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbgESFIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 01:08:50 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412D6C061A0C;
        Mon, 18 May 2020 22:08:50 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id 4so10179964qtb.4;
        Mon, 18 May 2020 22:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RDfq9l9lX/frOOmjzcfTO2w1eTArEVqNuGmARXoVgsw=;
        b=d5P++yQ9eBnr3XIav049Ty64PKAH3oNmrS1NwENa6RloFGq14tu4m7CBVtXIogRBfO
         uOvwA/vCCAcExVF2T06z4shdDVfgQqiKnx/kDjV6DnTA3/3oNbl7WWttCGprX3CsxWE+
         qYUkMduJ86iw5zB/9uEDyufxi1BBeGAzs1cJ78Rek/LQ8aXNHWyqrMfwaY7g4PB9ympz
         r1B3wFvFmom75qU8TjkJSv46uEOaY5lfk2G1utteJpxj8ofYY/wvqQC3j/Q5utg0UmsR
         Dn+eijR7wgPsEGzI1l61MPFGxhwIAo2yuAkLqlhIZ7fUh894Z5Zs8uzGP2It63AJld8s
         dK6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RDfq9l9lX/frOOmjzcfTO2w1eTArEVqNuGmARXoVgsw=;
        b=k0a0XoxRbcfCotpW4nz7PA9dV/MW7NYExlodNjKqc9F7V7sz+sDfeIY2rfP0bjPFlt
         8xVK6Jr65k+h1u7SD4Qqj5UN5buQfI3BgxlqrdCooijSkQCcoIJ7+ev8pmyMdne6nu5b
         4XB73FC84WQIen4URajkSnpnOE3sEQR9Buz/sdtY6OqSMmU6faSk/5jxbfAs5+JsBmIl
         xWxwvyc0JwZWdGq2R1Xj/cnlGZqsVaBLiliROLFVniyjlIVrikyu6jBr4XMRe+X/cxb8
         RCCotk9FFXn6aC/6a0WooYwopEJbmL/kTrBE0kEKbIKn/4NPTZ5itxoi5PSiPKtLZ63h
         dwvQ==
X-Gm-Message-State: AOAM533lJgc1z1XrKw1PsTOVpyaMWcEzKgHIv/BW8+WwGiKIyZZ1fpfa
        mrUp58CPJi4OrasfgnZpBhhYoJnnKkYXoYLTtIE=
X-Google-Smtp-Source: ABdhPJyOGGbkDUx91oMWp5UFt81Jx4o9eUHMMaw/+tQ8yT6gicjZOVv84DGTznkeRKAzwQ5tmm/O0kd8VZsm4baNE24=
X-Received: by 2002:aed:2f02:: with SMTP id l2mr20001467qtd.117.1589864929509;
 Mon, 18 May 2020 22:08:49 -0700 (PDT)
MIME-Version: 1.0
References: <158983199930.6512.18408887419883363781.stgit@john-Precision-5820-Tower>
 <158983219168.6512.11784750707821433806.stgit@john-Precision-5820-Tower>
In-Reply-To: <158983219168.6512.11784750707821433806.stgit@john-Precision-5820-Tower>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 May 2020 22:08:38 -0700
Message-ID: <CAEf4BzaERO0HrPH_R4HKTHd+yX5WKZLo0UEDaJFnw5OV1JBEaA@mail.gmail.com>
Subject: Re: [bpf-next PATCH 3/4] bpf: selftests, verifier case for non null
 pointer map value branch
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 1:07 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> When we have pointer type that is known to be non-null we only follow
> the non-null branch. This adds tests to cover the map_value pointer
> returned from a map lookup. To force an error if both branches are
> followed we do an ALU op on R10.
>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

LGTM. Here likelihood of someone comparing map value pointer against
non-zero scalar is much less likely, so I won't bother you to add test
for that.

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  .../testing/selftests/bpf/verifier/value_or_null.c |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/verifier/value_or_null.c b/tools/testing/selftests/bpf/verifier/value_or_null.c
> index 860d4a7..3ecb70a 100644
> --- a/tools/testing/selftests/bpf/verifier/value_or_null.c
> +++ b/tools/testing/selftests/bpf/verifier/value_or_null.c
> @@ -150,3 +150,22 @@
>         .result_unpriv = REJECT,
>         .flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
>  },
> +{
> +       "map lookup and null branch prediction",
> +       .insns = {
> +       BPF_MOV64_IMM(BPF_REG_1, 10),
> +       BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_1, -8),
> +       BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
> +       BPF_LD_MAP_FD(BPF_REG_1, 0),
> +       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
> +       BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
> +       BPF_JMP_IMM(BPF_JEQ, BPF_REG_6, 0, 2),
> +       BPF_JMP_IMM(BPF_JNE, BPF_REG_6, 0, 1),
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_10, 10),
> +       BPF_EXIT_INSN(),
> +       },
> +       .fixup_map_hash_8b = { 4 },
> +       .prog_type = BPF_PROG_TYPE_SCHED_CLS,
> +       .result = ACCEPT,
> +},
>
