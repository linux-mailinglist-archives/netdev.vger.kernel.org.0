Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0BAD4BEF6C
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238864AbiBVCBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:01:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiBVCBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:01:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C481EECA;
        Mon, 21 Feb 2022 18:01:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53A59B8184E;
        Tue, 22 Feb 2022 02:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4C9C340F0;
        Tue, 22 Feb 2022 02:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645495277;
        bh=82E44GVnMO3ZiuMUchoEAQGuozP+onbtfSj3aYx1p3k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dkUjOROGYgxoaIlIjcoJOBbMvpzAWf5eJq3HoFbDKAFnGMpOFr45Syat6S+hiZ8vS
         c/iHzeccFya/Coon/R673M43Lz7upMuKVjesq5XF9/cfx0toiptc/4850vTUSxaC4n
         RNb9yO3Rv0QTnxolO61MZdjIlWinrOAyeIdHsdKF/FIJaEhE+QG95C0vUUARrmtoCz
         kGB0qlsYrfd74MNkAnMQdS2OjFZXhdyPtTnr/VMOZpj38TRN/yO+qDm35YogScoAIf
         QZI0RfRelWoxpwqJVCRbxzWbhwwfjotoqw3g6zXl7ZIO1tf0SFxQrGWfLffm2cdKvt
         5A5srA7aTXjfw==
Received: by mail-yb1-f174.google.com with SMTP id w63so16704191ybe.10;
        Mon, 21 Feb 2022 18:01:16 -0800 (PST)
X-Gm-Message-State: AOAM530mExL97lKojVg8n0j+dB6OFDlsuQdyR0PsMskB8hQcmsMoeQLS
        e20B1sH2nxEU0uvtx+S0YN9hK94RQoNNGvC8UBg=
X-Google-Smtp-Source: ABdhPJzl/UPdOGfPXb1ow2MxZcuraEWgOUFss7Nj1XxOwAjWoZS9CmM/S0zJjGNZXMPXC+UYuNGhMjCSJcoBUdrAOWI=
X-Received: by 2002:a25:d60c:0:b0:610:dc8d:b3bd with SMTP id
 n12-20020a25d60c000000b00610dc8db3bdmr21529172ybg.561.1645495275984; Mon, 21
 Feb 2022 18:01:15 -0800 (PST)
MIME-Version: 1.0
References: <1645240502-13398-1-git-send-email-yangtiezhu@loongson.cn> <1645240502-13398-2-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1645240502-13398-2-git-send-email-yangtiezhu@loongson.cn>
From:   Song Liu <song@kernel.org>
Date:   Mon, 21 Feb 2022 18:01:05 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6bkhcDXb5k-46G_f4L+ot2QJwbY_-Urd+BEfrPWdmf+Q@mail.gmail.com>
Message-ID: <CAPhsuW6bkhcDXb5k-46G_f4L+ot2QJwbY_-Urd+BEfrPWdmf+Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] bpf: Add some description about
 BPF_JIT_ALWAYS_ON in Kconfig
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

On Fri, Feb 18, 2022 at 7:15 PM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
>
> When CONFIG_BPF_JIT_ALWAYS_ON is enabled, /proc/sys/net/core/bpf_jit_enable
> is permanently set to 1 and setting any other value than that will return
> in failure.
>
> Add the above description in the help text of config BPF_JIT_ALWAYS_ON, and
> then we can distinguish between BPF_JIT_ALWAYS_ON and BPF_JIT_DEFAULT_ON.
>
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>  kernel/bpf/Kconfig | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
> index d24d518..cbf3f65 100644
> --- a/kernel/bpf/Kconfig
> +++ b/kernel/bpf/Kconfig
> @@ -58,6 +58,10 @@ config BPF_JIT_ALWAYS_ON
>           Enables BPF JIT and removes BPF interpreter to avoid speculative
>           execution of BPF instructions by the interpreter.
>
> +         When CONFIG_BPF_JIT_ALWAYS_ON is enabled, /proc/sys/net/core/bpf_jit_enable
> +         is permanently set to 1 and setting any other value than that will return
> +         in failure.

nit: "return failure" (no "in").

Other than this,

Acked-by: Song Liu <songliubraving@fb.com>

> +
>  config BPF_JIT_DEFAULT_ON
>         def_bool ARCH_WANT_DEFAULT_BPF_JIT || BPF_JIT_ALWAYS_ON
>         depends on HAVE_EBPF_JIT && BPF_JIT
> --
> 2.1.0
>
