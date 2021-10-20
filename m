Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7EE4355CC
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 00:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhJTWTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 18:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhJTWTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 18:19:46 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2EFC06161C;
        Wed, 20 Oct 2021 15:17:31 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id b9so3541365ybc.5;
        Wed, 20 Oct 2021 15:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6K5tIZnq4DifBP2WDaxuqhflt+qxiPeZ0JDyjN50Rg4=;
        b=Th+ZF3etxH2b8i2EsDG5UyyQntvoRRqJP94jXurrqBw4E0irFe1fr7f2s7/pF1yNaD
         LP5xzx23nz3fXmrwEfkVa46lqw7ENujkxTAsAuRYuDtAphkHMwZJuCeO+ETAUPMzN0r+
         N2VjQiowqFvzmUAK/onXnQ91HNAXlLViu91+qytvzQlDPzNKzGkMg/W9oiQ/6zOQW60Y
         lyncHtQB0LaBmqcBW9haV7Qb6rPNHVcqehpcWP1hlv0DUZqfVEFVN6JbGJonugT0wL7Q
         ZoEhBuVMJCWPRoC0iSl6HwQZMOgwYpgeOOJ8+YwnVgLN10aVR+qkABx962NS+XlSU5xP
         sLdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6K5tIZnq4DifBP2WDaxuqhflt+qxiPeZ0JDyjN50Rg4=;
        b=bnbv7M0/Sv3C1voJnaDfESrVS3hO6fYBdBypUTRRSWd5MpyoVJyS02Iio3Ehngxr4m
         yTXvftZRTiStwrv935awztVvDikqdHDKVZGQXE7EchkZ9KB9pPl8E1Og2dX3/7uDQGkB
         qQHwTH14j8CCvsE0qrY8tF5nnYV403gexSh2c60G2YZ4gkPeZxMFSGcOmcEBxIFWuzsv
         k5TEameLot1lu+7AB0YvgXVGFxOsABq2cWX5DgMvJnlhAvK1T+gm08lQ+A4UCQZIaYib
         cqYSHsXAIGPSiMR2aeMvY773ULY9BhdTB1Z52DwBobvaPqNGgccknaNuVuTir1jio6KS
         60+Q==
X-Gm-Message-State: AOAM532cS7YCtYhdmjspoRD8Q2MCpa6RQ8YvXalx6Fh0iwsHF9avss9Q
        1WgaFaNaHRJjYOEKOqVI/yAagZR2qQhUc9+RvO0=
X-Google-Smtp-Source: ABdhPJx0XlbY2geTrmQ7gcTd83zfa2GquMHf2U4e1Vmd7FWulNBIBB87jNP2U9YDYSc0tVMdV9bCfeTACAmyl+krEJ0=
X-Received: by 2002:a25:e7d7:: with SMTP id e206mr1690447ybh.267.1634768250608;
 Wed, 20 Oct 2021 15:17:30 -0700 (PDT)
MIME-Version: 1.0
References: <20211020191526.2306852-1-memxor@gmail.com> <20211020191526.2306852-7-memxor@gmail.com>
In-Reply-To: <20211020191526.2306852-7-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Oct 2021 15:17:19 -0700
Message-ID: <CAEf4BzajqpFv-pwt7vZ3+Ob8y7RnqcCMVRvWhF1Nfr_J-NFZ0A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 6/8] selftests/bpf: Add weak/typeless ksym
 test for light skeleton
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 12:15 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> Also, avoid using CO-RE features, as lskel doesn't support CO-RE, yet.
> Include both light and libbpf skeleton in same file to test both of them
> together.
>
> In c48e51c8b07a ("bpf: selftests: Add selftests for module kfunc support"),
> I added support for generating both lskel and libbpf skel for a BPF
> object, however the name parameter for bpftool caused collisions when
> included in same file together. This meant that every test needed a
> separate file for a libbpf/light skeleton separation instead of
> subtests.
>
> Change that by appending a "_light" suffix to the name for files listed
> in LSKELS_EXTRA, such that both light and libbpf skeleton can be used in
> the same file for subtests, leading to better code sharing.
>
> While at it, improve the build output by saying GEN-LSKEL instead of
> GEN-SKEL for light skeleton generation recipe.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  tools/testing/selftests/bpf/Makefile          |  7 ++--
>  .../selftests/bpf/prog_tests/ksyms_btf.c      | 35 +++++++++++++++-
>  .../selftests/bpf/prog_tests/ksyms_module.c   | 40 +++++++++++++++++--
>  .../bpf/prog_tests/ksyms_module_libbpf.c      | 28 -------------
>  .../selftests/bpf/progs/test_ksyms_weak.c     |  3 +-
>  5 files changed, 74 insertions(+), 39 deletions(-)
>  delete mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 498222543c37..1c3c8befc249 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -325,7 +325,7 @@ LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h               \
>  LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
>         test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c
>  # Generate both light skeleton and libbpf skeleton for these
> -LSKELS_EXTRA := test_ksyms_module.c
> +LSKELS_EXTRA := test_ksyms_module.c test_ksyms_weak.c
>  SKEL_BLACKLIST += $$(LSKELS)
>
>  test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
> @@ -399,12 +399,13 @@ $(TRUNNER_BPF_SKELS): %.skel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
>         $(Q)$$(BPFTOOL) gen skeleton $$(<:.o=.linked3.o) name $$(notdir $$(<:.o=)) > $$@
>
>  $(TRUNNER_BPF_LSKELS): %.lskel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
> -       $$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
> +       $$(call msg,GEN-LSKEL,$(TRUNNER_BINARY),$$@)

This breaks nice output alignment:

  GEN-SKEL [test_progs-no_alu32] bpf_iter_tcp4.skel.h
  GEN-LSKEL [test_progs-no_alu32] trace_vprintk.lskel.h

Isn't ".lskel.h" suffix enough to distinguish them?

>         $(Q)$$(BPFTOOL) gen object $$(<:.o=.linked1.o) $$<
>         $(Q)$$(BPFTOOL) gen object $$(<:.o=.linked2.o) $$(<:.o=.linked1.o)
>         $(Q)$$(BPFTOOL) gen object $$(<:.o=.linked3.o) $$(<:.o=.linked2.o)
>         $(Q)diff $$(<:.o=.linked2.o) $$(<:.o=.linked3.o)
> -       $(Q)$$(BPFTOOL) gen skeleton -L $$(<:.o=.linked3.o) name $$(notdir $$(<:.o=)) > $$@
> +       $$(eval LSKEL_NAME := $$(notdir $$(<:.o=$$(if $$(filter $$(notdir $$(<:.o=.c)),$(LSKELS_EXTRA)),_light,))))

eval inside eval?.. Wow, do we really need that? If you just want to
add _light (I suggest _lskel though, it will make for a more
meaningful and recognizable names in user-space code) suffix, do it
for all light skeletons unconditionally and keep it simple?

> +       $(Q)$$(BPFTOOL) gen skeleton -L $$(<:.o=.linked3.o) name $$(LSKEL_NAME) > $$@
>
>  $(TRUNNER_BPF_SKELS_LINKED): $(TRUNNER_BPF_OBJS) $(BPFTOOL) | $(TRUNNER_OUTPUT)
>         $$(call msg,LINK-BPF,$(TRUNNER_BINARY),$$(@:.skel.h=.o))

[...]
