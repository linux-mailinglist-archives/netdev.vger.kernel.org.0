Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2701F311B6B
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 06:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhBFFO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 00:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbhBFFMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 00:12:33 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC75C06174A;
        Fri,  5 Feb 2021 21:11:53 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id e5so2228063otb.11;
        Fri, 05 Feb 2021 21:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7iP4TTvS6xWxkLmwciM3mX/ZUY17XhLv5dbW1hu+xrQ=;
        b=tgRM7j2Nnu8sc59Y7YSzzj7R8HPgZ03rA0jpdbza9svoMG5D292E/Ewc0kM3kphdt5
         XjrG6KwU1UpbfYjg/g/Gm0Az7YMmCdt+8mgBDjrtpk7WDKIEskRw4tFee+iJ4AznRsqq
         G12eInjJ78F20T8EcSKltfFIKsy2qU9+70cBEQeQ8TyBuXEHJBLAV6J9IIwe2baNshvV
         dvJan4RHBnKhEZvDUuALHzLMX1OZh1FWgjGK6Qk9IjxoEigBwqNzrJFDQeyERjcD2+Dy
         aJ+RBKujRg0jbnflNIxFAkHg+LHL9wACCUueIfmggEJF6yfT/Bxuwhap8A2iuD7vwP8K
         iRBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7iP4TTvS6xWxkLmwciM3mX/ZUY17XhLv5dbW1hu+xrQ=;
        b=Fs3DbvD8nl9EEPKdCOkaz4QGVfD3OgyLen5TAho7wHzx5iyOWxF7t55ikGJYMhFcl3
         m0GDtMJnNuGYEhJ1T0rysm2KsYc5d3oU0z1vV3lg+x0fqjhju6nJwfqTWylDhXnUr6qT
         nNt3K4jauHbILGOiG3f8JzxVk1CM1x8AHEwSrYNXUUAb4W6lUwgv0bnB9gJ3cfEO7d4c
         P7BN9gc4+XerQZBSmFfNcHf0VtI3rkfYhJWzql7LoepDsUUY7tU/2/1fr9SwiAK4fnfx
         mJZCl5l+AX6JeKjFzheqgq4+uRSI/IHKIqrsj3knLNBHWjRrX0sWhNLY1HsFA31Nkyw5
         6Xqg==
X-Gm-Message-State: AOAM533I6J9T63eCWhFHbC2+wCAFL4ZIsLeb6ZYazvzh1F1xpksulEdU
        hiUy8xtHPsC9ffbb6j+0OSs6uJpsZaDWEo45hSM=
X-Google-Smtp-Source: ABdhPJzQ6LgVrLezBFi+KHoVqbG2STjmqu3qYRs+0fI780UWOcPtt91Ameb6BnZ3+zLWzZMEZJLZBdFy3ag5uNtD1+g=
X-Received: by 2002:a9d:3ea4:: with SMTP id b33mr626804otc.185.1612588312868;
 Fri, 05 Feb 2021 21:11:52 -0800 (PST)
MIME-Version: 1.0
References: <20210205124020.683286-1-jolsa@kernel.org> <20210205124020.683286-5-jolsa@kernel.org>
In-Reply-To: <20210205124020.683286-5-jolsa@kernel.org>
From:   Amy Parker <enbyamy@gmail.com>
Date:   Fri, 5 Feb 2021 21:11:42 -0800
Message-ID: <CAE1WUT7d-ebxk8rCEcQs9fP_fDZqUaNASM++5La_mGstVa7srA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/4] kbuild: Add resolve_btfids clean to root
 clean target
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 5, 2021 at 4:46 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The resolve_btfids tool is used during the kernel build,
> so we should clean it on kernel's make clean.
>
> Invoking the the resolve_btfids clean as part of root
> 'make clean'.
>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  Makefile | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index b0e4767735dc..159d9592b587 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1086,6 +1086,11 @@ ifdef CONFIG_STACK_VALIDATION
>    endif
>  endif
>
> +PHONY += resolve_btfids_clean
> +
> +resolve_btfids_clean:
> +       $(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(abspath $(objtree))/tools/bpf/resolve_btfids clean
> +
>  ifdef CONFIG_BPF
>  ifdef CONFIG_DEBUG_INFO_BTF
>    ifeq ($(has_libelf),1)
> @@ -1495,7 +1500,7 @@ vmlinuxclean:
>         $(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
>         $(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
>
> -clean: archclean vmlinuxclean
> +clean: archclean vmlinuxclean resolve_btfids_clean
>
>  # mrproper - Delete all generated files, including .config
>  #
> --
> 2.26.2
>

It compiles, looks good to me.

Reviewed by: Amy Parker <enbyamy@gmail.com>

Have a great day, and thank you for this patch!

   -Amy IP
