Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C8E5AF6DB
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 23:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiIFVaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 17:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiIFVaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 17:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F2F8E98B;
        Tue,  6 Sep 2022 14:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FFDE616C3;
        Tue,  6 Sep 2022 21:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4222C433D7;
        Tue,  6 Sep 2022 21:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662499820;
        bh=0rqwqNXaNTcG/wk1HfpgV/BB4p8BnMNUe5bhTD5rs8o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ixm1IhxmEF1jgZZJaf+DQgp6beyJ+m1DjvBCLI2LTdX2lIyx+V+Y1jCQVqHEG3n/v
         1na6LgsiezBO89wTTUj5X8jcViu7/pOA3n5uSBiCEpc99rvTCL++p4v3N9P8QeU2oz
         r4uZ8Va1KOWsbe+vZ9hV457DhseqO/2hLffwZaftPdbaKI6HlA5T8yD4hyb3zNcVuo
         Pkk42cseMrGclbs5vMjJwnUyarvmM2KB2AeLd3hWXKbDWWQXKM6Tf2bPBVCl07UHyF
         c9Ro01qr5A6S45JPa0FmqGZ08iHiBc6j0gwGnNwGRVQsc87F7zNtoTui/GaWfi45f/
         +NSuAqpLgYRMg==
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-11e9a7135easo31424751fac.6;
        Tue, 06 Sep 2022 14:30:20 -0700 (PDT)
X-Gm-Message-State: ACgBeo3jlkXBibG0lKOHty1WXYrSP9B6d+wQ/3c4hUaOfzrnAWhZdtIs
        DbixdAYa6biDY04ODSR8LM2vWgZbbeQ5NxtVN/4=
X-Google-Smtp-Source: AA6agR5UHmOhAzZGMuMBsOYQ8SPDA8cj3HF2rIpe4ps4SZ9vZXeOOvmpgnGhMEksr/IMdoZg2jzKXOY5L/uT/M69I3c=
X-Received: by 2002:a05:6870:32d2:b0:127:f0b4:418f with SMTP id
 r18-20020a05687032d200b00127f0b4418fmr174690oac.22.1662499819860; Tue, 06 Sep
 2022 14:30:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1662383493.git.lorenzo@kernel.org> <1bea1050068d7ad50baa2f6b6c09c9eb1ae5b4dd.1662383493.git.lorenzo@kernel.org>
In-Reply-To: <1bea1050068d7ad50baa2f6b6c09c9eb1ae5b4dd.1662383493.git.lorenzo@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Tue, 6 Sep 2022 14:30:09 -0700
X-Gmail-Original-Message-ID: <CAPhsuW49ZU+ak=uned=AfBbGNVboLguKVXjfsOy7hZLbUSkyag@mail.gmail.com>
Message-ID: <CAPhsuW49ZU+ak=uned=AfBbGNVboLguKVXjfsOy7hZLbUSkyag@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/4] selftests/bpf: Extend KF_TRUSTED_ARGS
 test for __ref annotation
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 5, 2022 at 6:15 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>
> Extend the existing test for KF_TRUSTED_ARGS by also checking whether
> the same happens when a __ref suffix is present in argument name of a
> kfunc.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Song Liu <song@kernel.org>

> ---
>  tools/testing/selftests/bpf/verifier/calls.c | 38 +++++++++++++++-----
>  1 file changed, 30 insertions(+), 8 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/verifier/calls.c b/tools/testing/selftests/bpf/verifier/calls.c
> index 3fb4f69b1962..891fcda50d9d 100644
> --- a/tools/testing/selftests/bpf/verifier/calls.c
> +++ b/tools/testing/selftests/bpf/verifier/calls.c
> @@ -219,7 +219,7 @@
>         .errstr = "variable ptr_ access var_off=(0x0; 0x7) disallowed",
>  },
>  {
> -       "calls: invalid kfunc call: referenced arg needs refcounted PTR_TO_BTF_ID",
> +       "calls: invalid kfunc call: referenced arg needs refcounted PTR_TO_BTF_ID (KF_TRUSTED_ARGS)",
>         .insns = {
>         BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
>         BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),
> @@ -227,10 +227,30 @@
>         BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
>         BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
>         BPF_EXIT_INSN(),
> -       BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
> -       BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
> +       BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 16),
>         BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
> -       BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_6, 16),
> +       BPF_MOV64_IMM(BPF_REG_0, 0),
> +       BPF_EXIT_INSN(),
> +       },
> +       .prog_type = BPF_PROG_TYPE_SCHED_CLS,
> +       .fixup_kfunc_btf_id = {
> +               { "bpf_kfunc_call_test_acquire", 3 },
> +               { "bpf_kfunc_call_test_trusted", 7 },
> +       },
> +       .result_unpriv = REJECT,
> +       .result = REJECT,
> +       .errstr = "R1 must be referenced",
> +},
> +{
> +       "calls: invalid kfunc call: referenced arg needs refcounted PTR_TO_BTF_ID (__ref)",
> +       .insns = {
> +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),
> +       BPF_ST_MEM(BPF_DW, BPF_REG_1, 0, 0),
> +       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
> +       BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
> +       BPF_EXIT_INSN(),
> +       BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 16),
>         BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
>         BPF_MOV64_IMM(BPF_REG_0, 0),
>         BPF_EXIT_INSN(),
> @@ -238,8 +258,7 @@
>         .prog_type = BPF_PROG_TYPE_SCHED_CLS,
>         .fixup_kfunc_btf_id = {
>                 { "bpf_kfunc_call_test_acquire", 3 },
> -               { "bpf_kfunc_call_test_ref", 8 },
> -               { "bpf_kfunc_call_test_ref", 10 },
> +               { "bpf_kfunc_call_test_ref", 7 },
>         },
>         .result_unpriv = REJECT,
>         .result = REJECT,
> @@ -259,14 +278,17 @@
>         BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
>         BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
>         BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
> +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
> +       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
>         BPF_MOV64_IMM(BPF_REG_0, 0),
>         BPF_EXIT_INSN(),
>         },
>         .prog_type = BPF_PROG_TYPE_SCHED_CLS,
>         .fixup_kfunc_btf_id = {
>                 { "bpf_kfunc_call_test_acquire", 3 },
> -               { "bpf_kfunc_call_test_ref", 8 },
> -               { "bpf_kfunc_call_test_release", 10 },
> +               { "bpf_kfunc_call_test_trusted", 8 },
> +               { "bpf_kfunc_call_test_ref", 10 },
> +               { "bpf_kfunc_call_test_release", 12 },
>         },
>         .result_unpriv = REJECT,
>         .result = ACCEPT,
> --
> 2.37.3
>
