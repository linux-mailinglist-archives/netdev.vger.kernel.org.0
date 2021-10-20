Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40944351E8
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhJTRuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhJTRuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 13:50:50 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23D4C06161C;
        Wed, 20 Oct 2021 10:48:35 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id i84so12914976ybc.12;
        Wed, 20 Oct 2021 10:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AjXuA6zpEZxGmCDSVsThew5NU8hvOTbeXCUU4mAkZVQ=;
        b=D0uWk24Amgsg8xHib+/ZqIeOIaSYlHzBptMXb1h2C3tGDaivhwcgtZOqaMavTrT2fX
         l0hic4Z4MTjL2wHW+QvD6zq0MiELuiFgw51X033ED4dXRLjAGPGEiBNPsbBHEYRf5IEE
         P6TMFfqezg6NpjfnJYk/r9q487FL92Zmg5Qzz9UutXLHw9ebGyymFteQnxQrSPcUd9zF
         LKB/DybmtYUPCBVBrTwD/V3E6LiiXzaXtdAhnFHeWDoRfIF4KZbXBPNBA8xjCBfcf7Zi
         D+FbhDztQBavUb5bkhyIf8a+NeEMd4298zMvRLMrhhGMNQsixBLmLm0FP3SwMW8MsR0P
         PkoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AjXuA6zpEZxGmCDSVsThew5NU8hvOTbeXCUU4mAkZVQ=;
        b=565QEThaa9i0ZPUGYjsfmbqkVOuI9qZjH+2f78BqmYcQru/5z2NmKs3drZrqq2+PGn
         ZqSq/8KYPw9IrVZtOK6+H68OZYO6ytFnDfBvVZ9T0Lf6NC8qAZcFVT2qR3GEMzRwVxIx
         MOr1qZHo12/epUBf0M2WvyoeycWzHB/IDjmfL7wL67W7gsP5XprVNbcddaOMYfKH1Wnt
         LBaioVMY+AOQ7QGqGrC9aK16yWeqS6UA1BDwnCwzK7xLoARZh3xwOA1XeSwnvEvN68iK
         21WnwM4gFTxa1676u+wLHFbglD+OLFzRxdz1VPGAALCtBcqeozbXoBCjLaqhMX4fZC8L
         LQpQ==
X-Gm-Message-State: AOAM5310eXEMellSLPMJfRsnAEG0G3/a0sITA9vvsTIFKtv4Firl1hUn
        deoRazt5Lov/T3hPugVOvEJR0h7F+pHKDRDPHa4=
X-Google-Smtp-Source: ABdhPJw40k0wjS1/1+RGA+Cq5IjxAuBdWsdgisMxvUdGFJN14IZ6jTylj0XykIzcPqre16yrdyF6ifF/ovnQk35ooJI=
X-Received: by 2002:a25:e7d7:: with SMTP id e206mr427213ybh.267.1634752115211;
 Wed, 20 Oct 2021 10:48:35 -0700 (PDT)
MIME-Version: 1.0
References: <20211020094647.15564-1-quentin@isovalent.com>
In-Reply-To: <20211020094647.15564-1-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Oct 2021 10:48:24 -0700
Message-ID: <CAEf4BzZ3pD4Bynbe=QVZW5Vnk-NmGsQrH5h7xXDeA9OXX1x5Aw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpf/preload: Clean up .gitignore and
 "clean-files" target
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 2:46 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> kernel/bpf/preload/Makefile was recently updated to have it install
> libbpf's headers locally instead of pulling them from tools/lib/bpf. But
> two items still need to be addressed.
>
> First, the local .gitignore file was not adjusted to ignore the files
> generated in the new kernel/bpf/preload/libbpf output directory.
>
> Second, the "clean-files" target is now incorrect. The old artefacts
> names were not removed from the target, while the new ones were added
> incorrectly. This is because "clean-files" expects names relative to
> $(obj), but we passed the absolute path instead. This results in the
> output and header-destination directories for libbpf (and their
> contents) not being removed from kernel/bpf/preload on "make clean" from
> the root of the repository.
>
> This commit fixes both issues. Note that $(userprogs) needs not be added
> to "clean-files", because the cleaning infrastructure already accounts
> for it.
>
> Cleaning the files properly also prevents make from printing the
> following message, for builds coming after a "make clean":
> "make[4]: Nothing to be done for 'install_headers'."
>
> v2: Simplify the "clean-files" target.
>
> Fixes: bf60791741d4 ("bpf: preload: Install libbpf headers when building")
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> ---

Applied to bpf-next, thanks.

>  kernel/bpf/preload/.gitignore | 4 +---
>  kernel/bpf/preload/Makefile   | 3 +--
>  2 files changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/bpf/preload/.gitignore b/kernel/bpf/preload/.gitignore
> index 856a4c5ad0dd..9452322902a5 100644
> --- a/kernel/bpf/preload/.gitignore
> +++ b/kernel/bpf/preload/.gitignore
> @@ -1,4 +1,2 @@
> -/FEATURE-DUMP.libbpf
> -/bpf_helper_defs.h
> -/feature
> +/libbpf
>  /bpf_preload_umd
> diff --git a/kernel/bpf/preload/Makefile b/kernel/bpf/preload/Makefile
> index 469d35e890eb..1400ac58178e 100644
> --- a/kernel/bpf/preload/Makefile
> +++ b/kernel/bpf/preload/Makefile
> @@ -27,8 +27,7 @@ userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi \
>
>  userprogs := bpf_preload_umd
>
> -clean-files := $(userprogs) bpf_helper_defs.h FEATURE-DUMP.libbpf staticobjs/ feature/
> -clean-files += $(LIBBPF_OUT) $(LIBBPF_DESTDIR)
> +clean-files := libbpf/
>
>  $(obj)/iterators/iterators.o: | libbpf_hdrs
>
> --
> 2.30.2
>
