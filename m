Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7CC4A6C0F
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 08:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244763AbiBBHF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 02:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239384AbiBBHFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 02:05:25 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3F4C061714;
        Tue,  1 Feb 2022 23:05:25 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id n17so24271589iod.4;
        Tue, 01 Feb 2022 23:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SpryQOT2uTRwsdibcfsESI84DVoBT/VezHdCUqIw1nM=;
        b=Yh8JER6t2u+rs0xm1gDMhpppjo8c55JDcz4lc1HhglDS5vddc25oWSMVv5dafoq2tL
         X0EqeQ14PSrUBuQkDiKHBefLoTCrIPMhBcMLC4RBUJhmE816dG1uZB9z3Sk6BbJklR3D
         Y6a17cBDceerLRMxU8JtWsbkJrqxlp3m1OZNOmBvDWxdv1i3Z4SOTXFxfqYAnKryxNoS
         Fhjl60AsaagVaNs1saZNbjsF9Vh7z04r7CWdRI6Fo4GCYvqXXp2ewZeDC79N66/yVUo6
         LsUtUpHgRc6Rdk5tsGhSvgH2C2oCIAVi7+2HyASUyd7UtuupMDN9XfJnLBhHxs3Doeed
         rmlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SpryQOT2uTRwsdibcfsESI84DVoBT/VezHdCUqIw1nM=;
        b=n7dBvnRJnjhyILduExkcn0unr80g4Bm7z3kXxCHYd+8CVwovS1gtEHbOP81Z/oGut4
         C0ILWy3Qfgk2b0v1XZp0fMkpoCOePkGZJgOr7q6t3iobs9UOlLXe9jsIBsd8qW3cH/op
         IZR3K13m6acyQAWhqTGcb9jkX4bMb8L+GKXSirnK6X/HXZP+k05zyHmlp4ZDONecz2+2
         fJVn2RiZETIfcA0GxOgnc3oGbStWMdIwzxr016JG9pxtyOjdzjTwffvN6+pdFaKYiKM4
         taQ/HjGxHDXTjsSR7DK+fV0U5uuhuc+ZP31MUMuYqb3zGkYR8krdzAbYjXRIA/rRuipb
         OE6w==
X-Gm-Message-State: AOAM533c5qjCKBr2AcCokzC8UJe3TSd5MDZsXIxgiV+uI1cxZS9edYtt
        JXpblPQjcfo9fZHM5Lu+d4x/pN9gs8Ho3XZuq+8=
X-Google-Smtp-Source: ABdhPJyR0STyeIw70QHeReGkVxZkBvrSHZI1p+33uA5B2bkuVWZRQTmlR4YBRQ37MslJVt1AuMhh4dGDaT+Tp8C9mTQ=
X-Received: by 2002:a02:2422:: with SMTP id f34mr14962916jaa.237.1643785524885;
 Tue, 01 Feb 2022 23:05:24 -0800 (PST)
MIME-Version: 1.0
References: <20220201205624.652313-1-nathan@kernel.org>
In-Reply-To: <20220201205624.652313-1-nathan@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Feb 2022 23:05:13 -0800
Message-ID: <CAEf4BzbLwMCHDncHW-hH2kgOWc9jQK7QVkcH9aOKm7n7YC2LgQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/5] Allow CONFIG_DEBUG_INFO_DWARF5=y + CONFIG_DEBUG_INFO_BTF=y
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 1, 2022 at 12:56 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Hi all,
>
> This series allows CONFIG_DEBUG_INFO_DWARF5 to be selected with
> CONFIG_DEBUG_INFO_BTF=y by checking the pahole version.
>
> The first four patches add CONFIG_PAHOLE_VERSION and
> scripts/pahole-version.sh to clean up all the places that pahole's
> version is transformed into a 3-digit form.
>
> The fourth patch adds a PAHOLE_VERSION dependency to DEBUG_INFO_DWARF5
> so that there are no build errors when it is selected with
> DEBUG_INFO_BTF.
>
> I build tested Fedora's aarch64 and x86_64 config with ToT clang 14.0.0
> and GCC 11 with CONFIG_DEBUG_INFO_DWARF5 enabled with both pahole 1.21
> and 1.23.
>
> Nathan Chancellor (5):
>   MAINTAINERS: Add scripts/pahole-flags.sh to BPF section
>   kbuild: Add CONFIG_PAHOLE_VERSION
>   scripts/pahole-flags.sh: Use pahole-version.sh
>   lib/Kconfig.debug: Use CONFIG_PAHOLE_VERSION
>   lib/Kconfig.debug: Allow BTF + DWARF5 with pahole 1.21+
>

LGTM. I'd probably combine patches 2 and 3, but it's minor. I really
like the CONFIG_PAHOLE_VERSION and how much cleaner it makes Kconfig
options.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  MAINTAINERS               |  2 ++
>  init/Kconfig              |  4 ++++
>  lib/Kconfig.debug         |  6 +++---
>  scripts/pahole-flags.sh   |  2 +-
>  scripts/pahole-version.sh | 13 +++++++++++++
>  5 files changed, 23 insertions(+), 4 deletions(-)
>  create mode 100755 scripts/pahole-version.sh
>
>
> base-commit: 533de4aea6a91eb670ff8ff2b082bb34f2c5d6ab
> --
> 2.35.1
>
