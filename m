Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99957282119
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 06:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbgJCEW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 00:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCEW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 00:22:26 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F822C0613D0;
        Fri,  2 Oct 2020 21:22:24 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id h9so2665696ybm.4;
        Fri, 02 Oct 2020 21:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LC//9RNBwY2v7Qpy8XK3c8PrpheS5Pjkp4UMfthkQAg=;
        b=OlkdmPsiZ8jMVyoGx08blnI1QoId0iJcb+bcGs0VfGvCTVCqc7vDKVj+CWN6G9aBqw
         ebpBcIbg3E4ddDXHoA73TDl2IWQXGTVZhIcpkUxxAnP+qwLiSzmBxXmzNvJYffy/v0F+
         pO3HeR4kz1xg3Ggbg3vO+uuFb02Nh0tNK1/kcNUWmf8PCHYDCn+QFYzD3Nk+J2uiw6pE
         HmdY0nvqZt84KxmjCcykURddJ28QZRhIbhQmu1jO6s1iL7ej0QC0KEDHMXZYND5gSDMB
         +JOXVm7gV43nOj0GXvMlzcqtt/ZxRmTli4RN2ohdoeJekUrw1doo5fh56k6F5eOdsbSH
         DvgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LC//9RNBwY2v7Qpy8XK3c8PrpheS5Pjkp4UMfthkQAg=;
        b=YWfAalkmJ88WrD9zihLwJjCBQND7j9RaEWAS8Q2Kcvllc6L6sxACfIMMYfZX4S9301
         deK2TrLD5bgIOjCMunhSkhftggEGpdWLg0cZrUv3SRf9VfpIgg6P7r7142OSjHPcWPFx
         MFsVmrsf1mSuTrETi9hP5Yrm/OWVovsizJGz5Fhtx6ZNIwJ1yPhUWHKZXkBu0nfWtM29
         darpV2e2sy9S9TcQiG3FJMgIcSb1An8SDy0BlsBFBOFHcJFq9DeJ8Ypy5Cp7T/7Xd/rd
         doLr08Mejy/3qwHYv2BVPemGN1Iv7N3BZE0fjbLR96VgKaHsglRIQVPqEKyBPswn3XfC
         rK+Q==
X-Gm-Message-State: AOAM531ykG08qs9B+oEmXZD8H6vulq0btCON29id4DAMs3Y8/TNa9vq2
        ENjkiS2V3wF+aZhPYVy4voCds4Rwfc0v+5oK/lNf+uhFGQI=
X-Google-Smtp-Source: ABdhPJwpfxsf3Fxo4iUXR5NAnsQUAszlei8I8g7H2T8GRyZ1nwfsXP/DK/vLrF4n3YWq/N/sSntmg/PCD48x0NYbjkY=
X-Received: by 2002:a25:2596:: with SMTP id l144mr6639116ybl.510.1601698942665;
 Fri, 02 Oct 2020 21:22:22 -0700 (PDT)
MIME-Version: 1.0
References: <20201003021904.1468678-1-yhs@fb.com>
In-Reply-To: <20201003021904.1468678-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 2 Oct 2020 21:22:11 -0700
Message-ID: <CAEf4BzZSg9TWF=kGVmiZ7HUbpyXwYUEqrvFMeZgYo0h7EC8b3w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] samples/bpf: change Makefile to cope with
 latest llvm
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 2, 2020 at 7:19 PM Yonghong Song <yhs@fb.com> wrote:
>
> With latest llvm trunk, bpf programs under samples/bpf
> directory, if using CORE, may experience the following
> errors:
>
> LLVM ERROR: Cannot select: intrinsic %llvm.preserve.struct.access.index
> PLEASE submit a bug report to https://bugs.llvm.org/ and include the crash backtrace.
> Stack dump:
> 0.      Program arguments: llc -march=bpf -filetype=obj -o samples/bpf/test_probe_write_user_kern.o
> 1.      Running pass 'Function Pass Manager' on module '<stdin>'.
> 2.      Running pass 'BPF DAG->DAG Pattern Instruction Selection' on function '@bpf_prog1'
>  #0 0x000000000183c26c llvm::sys::PrintStackTrace(llvm::raw_ostream&, int)
>     (/data/users/yhs/work/llvm-project/llvm/build.cur/install/bin/llc+0x183c26c)
> ...
>  #7 0x00000000017c375e (/data/users/yhs/work/llvm-project/llvm/build.cur/install/bin/llc+0x17c375e)
>  #8 0x00000000016a75c5 llvm::SelectionDAGISel::CannotYetSelect(llvm::SDNode*)
>     (/data/users/yhs/work/llvm-project/llvm/build.cur/install/bin/llc+0x16a75c5)
>  #9 0x00000000016ab4f8 llvm::SelectionDAGISel::SelectCodeCommon(llvm::SDNode*, unsigned char const*,
>     unsigned int) (/data/users/yhs/work/llvm-project/llvm/build.cur/install/bin/llc+0x16ab4f8)
> ...
> Aborted (core dumped) | llc -march=bpf -filetype=obj -o samples/bpf/test_probe_write_user_kern.o
>
> The reason is due to llvm change https://reviews.llvm.org/D87153
> where the CORE relocation global generation is moved from the beginning
> of target dependent optimization (llc) to the beginning
> of target independent optimization (opt).
>
> Since samples/bpf programs did not use vmlinux.h and its clang compilation
> uses native architecture, we need to adjust arch triple at opt level
> to do CORE relocation global generation properly. Otherwise, the above
> error will appear.
>
> This patch fixed the issue by introduce opt and llvm-dis to compilation chain,
> which will do proper CORE relocation global generation as well as O2 level
> optimization. Tested with llvm10, llvm11 and trunk/llvm12.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  samples/bpf/Makefile | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 4f1ed0e3cf9f..79c5fdea63d2 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -211,6 +211,8 @@ TPROGLDLIBS_xsk_fwd         += -pthread
>  #  make M=samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
>  LLC ?= llc
>  CLANG ?= clang
> +OPT ?= opt
> +LLVM_DIS ?= llvm-dis
>  LLVM_OBJCOPY ?= llvm-objcopy
>  BTF_PAHOLE ?= pahole
>
> @@ -314,7 +316,9 @@ $(obj)/%.o: $(src)/%.c
>                 -Wno-address-of-packed-member -Wno-tautological-compare \
>                 -Wno-unknown-warning-option $(CLANG_ARCH_ARGS) \
>                 -I$(srctree)/samples/bpf/ -include asm_goto_workaround.h \
> -               -O2 -emit-llvm -c $< -o -| $(LLC) -march=bpf $(LLC_FLAGS) -filetype=obj -o $@
> +               -O2 -emit-llvm -Xclang -disable-llvm-passes -c $< -o - | \
> +               $(OPT) -O2 -mtriple=bpf-pc-linux | $(LLVM_DIS) | \
> +               $(LLC) -march=bpf $(LLC_FLAGS) -filetype=obj -o $@

I keep forgetting exact details of why we do this native clang + llc
pipeline instead of just doing `clang -target bpf`? Is it still
relevant and necessary, or we can just simplify it now?

>  ifeq ($(DWARF2BTF),y)
>         $(BTF_PAHOLE) -J $@
>  endif
> --
> 2.24.1
>
