Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495752CAA66
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 19:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404231AbgLASCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 13:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404222AbgLASCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 13:02:16 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C09FC0613CF;
        Tue,  1 Dec 2020 10:01:36 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id 10so2656713ybx.9;
        Tue, 01 Dec 2020 10:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=immCNs4xDGr/yeWS3YmZEjkNg6wKQAW5VTX5f5Tpknc=;
        b=YKpqwZaUUhKeLfxngmK3DDiAn38uJZke2a803KK+v6vKIVSjsSVhXpi4O/tjklH9Bd
         jSD3es5jE2Q77uppB19U2/7n+gTL3gtgdwSZkyRiLtzOFUfAYwKA0Ao7ltRHVRKeDwHl
         v4eexAmQBEF7cmApzW0O4NMaDbgigs49wnpbK4QdUskwbToKbGoOws459yZQtuR+xS6m
         2RYNQ72NknLe5fMJSUIm4EjHfTQCdwuF19eZ8mAZRht1u4JBFGTL4td4mIiRaTnEp+/1
         D7jSZJeX85be+WATzHnFDCYhl6hZtPpDlnT7lNpzL8r1JGH8JmCUL3MAjTvCQaVA1Eod
         LABQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=immCNs4xDGr/yeWS3YmZEjkNg6wKQAW5VTX5f5Tpknc=;
        b=EryM84V5Fw3Js8EtlxofBEQzrZkcZdnkhzG2E0Fjc7bHzYXK4dEkDbq/dCF1gf6s6U
         AQzbyF/wZe5tN3VcCxixzWLxABDzTYJMZRPTm2EV89aGy5QqldX2fUf+ljjT0c5Lb4nY
         EbcMdQ9jmeMnRVRTl5zUgP/VwH2srPfRphj6jeX+fUQY/Pv2ODifiXpZpuRhZ58Q3nNo
         mm+ahUujDQgEefo+CraMxP2AqY/fxWoFRF5IWKNk6GDusYgdpALHGRZpevss3j3jKY7d
         sV6l5QNKXNFy/vwyieF/qvw2PafqD/coWQNKsoeB1xLmXXrPaiCY0HbKgtEMMMoDgArG
         /7PQ==
X-Gm-Message-State: AOAM531Z7kK5F01426EYBARTPBva5m0/k3jHhaYw5G68oqfgNsiZfr6I
        U2/UEir/Y636eiGLDWgWToBq8uJFlTBYabjivsE=
X-Google-Smtp-Source: ABdhPJwc45X9pd+003CCkmjMxs4UKYvW0IGxNyfMvmG2kpS7bZXC0j4ppJ6woxJmpl+P7N2EeLYLvBxYe2soF7yElgE=
X-Received: by 2002:a25:7717:: with SMTP id s23mr6890166ybc.459.1606845694868;
 Tue, 01 Dec 2020 10:01:34 -0800 (PST)
MIME-Version: 1.0
References: <20201201143700.719828-1-leon@kernel.org>
In-Reply-To: <20201201143700.719828-1-leon@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Dec 2020 10:01:23 -0800
Message-ID: <CAEf4BzaSL+rmVYNipsfczsF2v684KOhZgFPtUG9opvk7d6zruA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] kbuild: Restore ability to build out-of-tree modules
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Edward Srouji <edwards@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 1, 2020 at 6:37 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> From: Leon Romanovsky <leonro@nvidia.com>
>
> The out-of-tree modules are built without vmlinux target and request
> to recompile that target unconditionally causes to the following
> compilation error.
>
> [root@server kernel]# make
> <..>
> make -f ./scripts/Makefile.modpost
> make -f ./scripts/Makefile.modfinal
> make[3]: *** No rule to make target 'vmlinux', needed by '/my_temp/out-of-tree-module/kernel/test.ko'.  Stop.
> make[2]: *** [scripts/Makefile.modpost:117: __modpost] Error 2
> make[1]: *** [Makefile:1703: modules] Error 2
> make[1]: Leaving directory '/usr/src/kernels/5.10.0-rc5_for_upstream_base_2020_11_29_11_34'
> make: *** [Makefile:80: modules] Error 2
>
> As a solution separate between build paths that has vmlinux target and paths without.
>
> Fixes: 5f9ae91f7c0d ("kbuild: Build kernel module BTFs if BTF is enabled and pahole supports it")
> Reported-by: Edward Srouji <edwards@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---

e732b538f455 ("kbuild: Skip module BTF generation for out-of-tree
external modules") ([0]) was supposed to take care of this. Did you
try it?

  [0] https://patchwork.kernel.org/project/netdevbpf/patch/20201121070829.2612884-1-andrii@kernel.org/


> Not proficient enough in Makefile, but it fixes the issue.
> ---
>  scripts/Makefile.modfinal | 5 +++++
>  scripts/Makefile.modpost  | 4 ++++
>  2 files changed, 9 insertions(+)
>
> diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
> index 02b892421f7a..8a7d0604e7d0 100644
> --- a/scripts/Makefile.modfinal
> +++ b/scripts/Makefile.modfinal
> @@ -48,9 +48,14 @@ if_changed_except = $(if $(call newer_prereqs_except,$(2))$(cmd-check),      \
>         $(cmd);                                                              \
>         printf '%s\n' 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd, @:)
>
> +ifdef MODPOST_VMLINUX
>  # Re-generate module BTFs if either module's .ko or vmlinux changed
>  $(modules): %.ko: %.o %.mod.o scripts/module.lds vmlinux FORCE
>         +$(call if_changed_except,ld_ko_o,vmlinux)
> +else
> +$(modules): %.ko: %.o %.mod.o scripts/module.lds FORCE
> +       +$(call if_changed_except,ld_ko_o)
> +endif
>  ifdef CONFIG_DEBUG_INFO_BTF_MODULES
>         +$(if $(newer-prereqs),$(call cmd,btf_ko))
>  endif
> diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
> index f54b6ac37ac2..f5aa5b422ad7 100644
> --- a/scripts/Makefile.modpost
> +++ b/scripts/Makefile.modpost
> @@ -114,8 +114,12 @@ targets += $(output-symdump)
>
>  __modpost: $(output-symdump)
>  ifneq ($(KBUILD_MODPOST_NOFINAL),1)
> +ifdef MODPOST_VMLINUX
> +       $(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modfinal MODPOST_VMLINUX=1
> +else
>         $(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modfinal
>  endif
> +endif
>
>  PHONY += FORCE
>  FORCE:
> --
> 2.28.0
>
