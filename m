Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33592A8E39
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 05:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgKFEQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 23:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgKFEQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 23:16:58 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A30C0613CF;
        Thu,  5 Nov 2020 20:16:57 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id k25so3899513lji.9;
        Thu, 05 Nov 2020 20:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AoocLBBvUJrI0bLOOZTh8xYoi/tHgAN+ua/bhX68FM8=;
        b=sINzjgHvy6ulBGqRGUPhFTT730zcVjTJ63oLbOTnwWTF1dtv+m7Xh8tx18yvhbigwv
         K+jpB1Z7Me38xpsNnnWGAGqo5I6Dhy4ODfsmaqxXVigyKn13DnoNhggKaoB6OeiRqkte
         DADDhjdrXimmBRbhVBMJcpH6nwvlDP02GCB2IOy0ZIXbGRKZ9wBI0apeC/YziAXK7Kaw
         bHXhtm62DVkgDKYrIYHrDummNvSi15N+6xODSxRcU28nxu6fqSWHOA8g103z/NY+foYI
         oY1XXbuISgUEM9+DR05gTrcTC44RQlwPKqOQFrP6nVHQ2ZeSYGVL/BPwYJ89YWhBzrQe
         kKuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AoocLBBvUJrI0bLOOZTh8xYoi/tHgAN+ua/bhX68FM8=;
        b=mIOdPr8M3EcLfLEqdH1ebV/mp3BqPDDEQvhCBCHvaFlqtL+9dwCQaQmL1eR0YriU3H
         yvufzT4LOwx85w7ExS9+CXKOCnWDsFQhZvdD8D/nuCORJ7k6wlOVkTrvRdggWGdXbhGU
         IluiFUH61KRMx6xv3FOFhemfPNMM17pG4ZK3jLsR1N3zv79DIXnjilNVc4GkVr9162Gb
         VYFlIDIj7NelOExffCqhuOITMfZvK0gmtuZOYJkCgrO3iB1SpPz2n0MdNi3UI3VfTpy0
         qElijBLtkh4APUDj2682QNYs7ZgPQn7Oq64L9482VRLJ4DQZQYip4TuZd8NEyxHfKI/Q
         mEHw==
X-Gm-Message-State: AOAM533vnB27p3f/5ayK11SqjYIHSY8kMccaA5DTWDyjhr+5Nig5U73n
        oPEtbOUnUguVcIaBLZ7yd/dlJ7a0cYT0GubnoYM=
X-Google-Smtp-Source: ABdhPJzT9gjrVO2QBAMOuWU6fZsr/CDjFypLslG8r4nvEDWzi5MHV9UIGjTVCPYTBekisHpRdbi6Mo2jTxCnzgVzqnE=
X-Received: by 2002:a2e:9094:: with SMTP id l20mr35819ljg.290.1604636216488;
 Thu, 05 Nov 2020 20:16:56 -0800 (PST)
MIME-Version: 1.0
References: <20201104191052.390657-1-ndesaulniers@google.com>
In-Reply-To: <20201104191052.390657-1-ndesaulniers@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 5 Nov 2020 20:16:44 -0800
Message-ID: <CAADnVQL_mP7HNz1n+=S7Tjk8f7efm3_w5+VQVptD2y7Wts_Mig@mail.gmail.com>
Subject: Re: [PATCH] compiler-clang: remove version check for BPF Tracing
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Chen Yu <yu.chen.surf@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 4, 2020 at 11:11 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> bpftrace parses the kernel headers and uses Clang under the hood. Remove
> the version check when __BPF_TRACING__ is defined (as bpftrace does) so
> that this tool can continue to parse kernel headers, even with older
> clang sources.
>
> Cc: <stable@vger.kernel.org>
> Fixes: commit 1f7a44f63e6c ("compiler-clang: add build check for clang 10.0.1")
> Reported-by: Chen Yu <yu.chen.surf@gmail.com>
> Reported-by: Jarkko Sakkinen <jarkko@kernel.org>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  include/linux/compiler-clang.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
> index dd7233c48bf3..98cff1b4b088 100644
> --- a/include/linux/compiler-clang.h
> +++ b/include/linux/compiler-clang.h
> @@ -8,8 +8,10 @@
>                      + __clang_patchlevel__)
>
>  #if CLANG_VERSION < 100001
> +#ifndef __BPF_TRACING__
>  # error Sorry, your version of Clang is too old - please use 10.0.1 or newer.
>  #endif
> +#endif

I can take it through the bpf tree if no one objects.
