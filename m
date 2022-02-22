Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8590C4BEF6B
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbiBVCPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:15:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbiBVCO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:14:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5121C12D;
        Mon, 21 Feb 2022 18:14:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AB4AB817F8;
        Tue, 22 Feb 2022 02:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC38EC340E9;
        Tue, 22 Feb 2022 02:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645496072;
        bh=KqibIir4n8GGBG4Zyj0JQPp8upAMZezOjVYAX7/7D/0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aQ8vgFKTbc8fEzvCZvW4uEzI3uiFEVYJzqfbp2rdnhCvilW9QZM0/TeArOPfXbXcJ
         /cIaFHbE/s0Hthwoau49V7tNl0TjULHzQfZv8XR7lVf2lIENFi2+vI9qqhUr20I/LL
         cAiSHTgEPlKY/2U3WGeR2+wRpUPUyCdJh9Q00m/usPFsj4peijOXYpW/sRwagRAqJu
         NQsca5467UPgWyE3CJ0UlIZbLcs1shzIqcGFTyxJYYTkzKTaMdu/OR24wOIfeLhp/A
         jCitbecM9ejEuENjCjLc6ENKiwBYbKnNHr2PTIQHRwpnASt2BsGMEKZoW2wzos02/D
         Ml6z70n6nNcWQ==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-2d6d0cb5da4so102904367b3.10;
        Mon, 21 Feb 2022 18:14:32 -0800 (PST)
X-Gm-Message-State: AOAM531iVbQ9a6+NH5JSwH3QzSKwcJEAYE8D+vGTrb4HagcZ5Zz7KdzD
        YjChbEapVI1IlWfvPHCVVMEdRkJ9sdDRMVP4RF8=
X-Google-Smtp-Source: ABdhPJyAbe26v/2n6fVKLChZbz15YoE+ivjn//HNPARGdjBarXJdCsgXDG93/l5ndvOw0bHFCvNRfyu5nXfkwuAf3Qc=
X-Received: by 2002:a81:9895:0:b0:2d7:7e75:9ba8 with SMTP id
 p143-20020a819895000000b002d77e759ba8mr3783733ywg.130.1645496071854; Mon, 21
 Feb 2022 18:14:31 -0800 (PST)
MIME-Version: 1.0
References: <1645240502-13398-1-git-send-email-yangtiezhu@loongson.cn> <1645240502-13398-3-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1645240502-13398-3-git-send-email-yangtiezhu@loongson.cn>
From:   Song Liu <song@kernel.org>
Date:   Mon, 21 Feb 2022 18:14:20 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5gbFXspvfFBmourDmkdVVhLN-iU-N=zLbm++GeNfM3Xw@mail.gmail.com>
Message-ID: <CAPhsuW5gbFXspvfFBmourDmkdVVhLN-iU-N=zLbm++GeNfM3Xw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/2] bpf: Make BPF_JIT_DEFAULT_ON selectable
 in Kconfig
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
> Currently, only x86, arm64 and s390 select ARCH_WANT_DEFAULT_BPF_JIT,
> the other archs do not select ARCH_WANT_DEFAULT_BPF_JIT. On the archs
> without ARCH_WANT_DEFAULT_BPF_JIT, if we want to set bpf_jit_enable to
> 1 by default, the only way is to enable CONFIG_BPF_JIT_ALWAYS_ON, then
> the users can not change it to 0 or 2, it seems bad for some users. We
> can select ARCH_WANT_DEFAULT_BPF_JIT for those archs if it is proper,
> but at least for now, make BPF_JIT_DEFAULT_ON selectable can give them
> a chance.
>
> Additionally, with this patch, under !BPF_JIT_ALWAYS_ON, we can disable
> BPF_JIT_DEFAULT_ON on the archs with ARCH_WANT_DEFAULT_BPF_JIT when make
> menuconfig, it seems flexible for some developers.
>
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>  kernel/bpf/Kconfig | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
> index cbf3f65..461ac60 100644
> --- a/kernel/bpf/Kconfig
> +++ b/kernel/bpf/Kconfig
> @@ -54,6 +54,7 @@ config BPF_JIT
>  config BPF_JIT_ALWAYS_ON
>         bool "Permanently enable BPF JIT and remove BPF interpreter"
>         depends on BPF_SYSCALL && HAVE_EBPF_JIT && BPF_JIT
> +       select BPF_JIT_DEFAULT_ON
>         help
>           Enables BPF JIT and removes BPF interpreter to avoid speculative
>           execution of BPF instructions by the interpreter.
> @@ -63,8 +64,16 @@ config BPF_JIT_ALWAYS_ON
>           in failure.
>
>  config BPF_JIT_DEFAULT_ON
> -       def_bool ARCH_WANT_DEFAULT_BPF_JIT || BPF_JIT_ALWAYS_ON
> -       depends on HAVE_EBPF_JIT && BPF_JIT
> +       bool "Defaultly enable BPF JIT and remove BPF interpreter"

I think "remove BPF interpreter" is not accurate. I guess we can just say
"Enable BPF JIT by default". (also "defaultly" sounds weird to me).

> +       default y if ARCH_WANT_DEFAULT_BPF_JIT
> +       depends on BPF_SYSCALL && HAVE_EBPF_JIT && BPF_JIT
> +       help
> +         Enables BPF JIT and removes BPF interpreter to avoid speculative
> +         execution of BPF instructions by the interpreter.
> +
> +         When CONFIG_BPF_JIT_DEFAULT_ON is enabled but CONFIG_BPF_JIT_ALWAYS_ON
> +         is disabled, /proc/sys/net/core/bpf_jit_enable is set to 1 by default
> +         and can be changed to 0 or 2.
>
>  config BPF_UNPRIV_DEFAULT_OFF
>         bool "Disable unprivileged BPF by default"
> --
> 2.1.0
>
