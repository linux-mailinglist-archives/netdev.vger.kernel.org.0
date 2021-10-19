Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30913434252
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 01:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhJSXwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 19:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbhJSXwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 19:52:32 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3727C06161C;
        Tue, 19 Oct 2021 16:50:18 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id o134so6357845ybc.2;
        Tue, 19 Oct 2021 16:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t2vNudSQASyRE7VbaPbaE3v6zkj3cErYT2qjVJELzYQ=;
        b=cIlBbAe4Gv0BFmlqT8Pf66ZnCdI89qg7FY6YlCfyCQqarBRqC+lu4IgP3KOR7BqcWp
         lV7cxU1RpnEgWW9LsmzdCfzND8fbGk9aM1++ERzEUAlCtpXfDSOXYoE76MhJOhLyPlF3
         ea6AiXHdlp713GMeTuVVRL+MgmYuO3LBoMRJmyOnX5z9dMB2mjitByhaw2UF5qaiSiOL
         LSiq89/2kEZ3Xshl0FNTwwMJx5FerImXR1MnBEtj1VFyhyKtm6yjGd065ZqY7bvFXxup
         TB5INMgvrufoNRTBYjypm/++2Lhz6oW5nVY9Stf1hedAX3JeHAs2ju9GoC80VNZQjUt6
         RNhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t2vNudSQASyRE7VbaPbaE3v6zkj3cErYT2qjVJELzYQ=;
        b=BVx3iZaYFoqK3CjqYnwt2jh04Tq6uOQ2sca11wMkHghdfnma8j3VnTmAeYpkbUaOva
         RXe21l8OrxoMYfwGQinOdwKPg/vA0+ocvxY4aClDJwmMjCJDarn3LJZZldTQVgUM5Yyi
         sPMiYrmrzLIMlo27j/Mt+zyA6qsAxhj8TDF1/KlIjZ0KpDtl2XlvjHto/O94y/crXO5R
         ojArtUqI8j/LA0Uk4Wlun0LmaI1nx6OC+MP1mMpJaczBUMeNh9Y7JvmulZHmLyUv4bZE
         ge6pMpiu4VIvORhb3jeTBgvF0I4NAmQjabP0hBpqxNnbgWr9cYStnk6nFUKvaRYPfkdo
         8o0A==
X-Gm-Message-State: AOAM532SXjtWtlp+FiJcQXNv9sGqyJN2hDTdSJxHXGbSZRiWUqZ9l/DY
        M5gAxylgdPxApvJJ8XDkHO0GNcwsn+NlS+WhUNMsIplPhDQ=
X-Google-Smtp-Source: ABdhPJyEAcyVWRMMtDa1IpHDEZFOdouggqSMt65WeUr1ziqYZYSahfFOKnmhXa4QV+j1rxZ4EuNCT2jJr2+XCbBGhVI=
X-Received: by 2002:a25:24c1:: with SMTP id k184mr39015069ybk.2.1634687418030;
 Tue, 19 Oct 2021 16:50:18 -0700 (PDT)
MIME-Version: 1.0
References: <20211010002400.9339-1-quentin@isovalent.com>
In-Reply-To: <20211010002400.9339-1-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 19 Oct 2021 16:50:07 -0700
Message-ID: <CAEf4Bza1K2-ncAqmvri=4apP9Bzv9gX7e8YAu4GWgk_kM48Jgw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf/preload: Clean up .gitignore and
 "clean-files" target
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 9, 2021 at 5:24 PM Quentin Monnet <quentin@isovalent.com> wrote:
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
> Fixes: bf60791741d4 ("bpf: preload: Install libbpf headers when building")
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
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
> index 469d35e890eb..d8379af88161 100644
> --- a/kernel/bpf/preload/Makefile
> +++ b/kernel/bpf/preload/Makefile
> @@ -27,8 +27,7 @@ userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi \
>
>  userprogs := bpf_preload_umd
>
> -clean-files := $(userprogs) bpf_helper_defs.h FEATURE-DUMP.libbpf staticobjs/ feature/
> -clean-files += $(LIBBPF_OUT) $(LIBBPF_DESTDIR)
> +clean-files := $(subst $(abspath $(obj))/,,$(LIBBPF_OUT) $(LIBBPF_DESTDIR))

why so complicated? also isn't LIBBPF_OUT and LIBBPF_DESTDIR the same?
Wouldn't just this work and be super clear:

clean-files: libbpf/

?

>
>  $(obj)/iterators/iterators.o: | libbpf_hdrs
>
> --
> 2.30.2
>
