Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BA3230262
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 08:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgG1GIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 02:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbgG1GIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 02:08:44 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CCBC061794;
        Mon, 27 Jul 2020 23:08:44 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id j187so17627848qke.11;
        Mon, 27 Jul 2020 23:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NBkYNLK/UsU+H/NI4eZY+7e5iBngk/v8pGC3lNVjOpc=;
        b=M42esjLI82UA6Y99wBsskZzJOPHQ9lgJOQgkSVEwTakQwBqm/KtT6UHl+sgOVwiMgJ
         4vbEEdwKHwYeCu0QlvbijXMW20PwS8xJ7xuIfNISci+te1/99aNz7clMJXG7tSJfmTIu
         /sj+tgDSC+/oet97egbTsS2xRZwlzH8nhy0/odSwURO7VZ7lrf6lJZuxU3sLYr7We9xM
         qsWHlNSgwE803Q06t/0PqW9Z5WlrAP5ZqCX91x2p5VY0RvAlUdGojpOEEZBKY8KbWhO8
         VJ2TKjiX0SuuHEjqirw3g5QYqik5r4NgqaLWACQlduSNe+QzLAXoo0ANQRqpYBnDgwjq
         huuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NBkYNLK/UsU+H/NI4eZY+7e5iBngk/v8pGC3lNVjOpc=;
        b=R0xDo/mm4z179fjkY+sO5DgPurroCN4GBy21Hhu/EzFJL4bflLmgDHLduiMZg9rj9o
         k4PcNfmK4QDGOzRkccr73TkQigntWHpcrQzLE0FHwRGJsRQUfBEv7Dr6ZcB8BC2qPfMU
         WXL5IiRNBAj3Sah4W+0N1pS/2rcQxYdf3EEhsyMNsGHs3Gn3S+06RD8asQ3f6B0VdaL2
         1np5ErDOJeFUhog2rwLbscWq+foF4vH5QJlV/f22BCVXTTO39NudWy4crHWE9A8uKGaz
         VF01NYLt6SuASgVNOClz8GsqPJQFqhhQgrJitMdOVUjrXCwe4oNb6Mtf0WwQxNF2OG0q
         nh2A==
X-Gm-Message-State: AOAM531FLReEwt8i66bzQ1x76hbWP2ER9qU4kuFvvjwhtUmy2hEVBNVd
        yk93Y69ydstAWR59TmjNmg/EugMTVP8iaHgZHMs=
X-Google-Smtp-Source: ABdhPJxokalrbaUzwpFZWvQPpacH5i8/pkU+Rxm819+B22P/hzsBkezw9FEKEz50N6BvgQ+bbHzMQi5X8WS2QuMziwg=
X-Received: by 2002:a37:a655:: with SMTP id p82mr25994500qke.92.1595916523518;
 Mon, 27 Jul 2020 23:08:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-34-guro@fb.com>
In-Reply-To: <20200727184506.2279656-34-guro@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Jul 2020 23:08:32 -0700
Message-ID: <CAEf4BzYoxGqU=qnXz68F+vasgdr9Xj1CPtjMVDkwNbxnymGDZA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 33/35] bpf: selftests: don't touch RLIMIT_MEMLOCK
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 12:21 PM Roman Gushchin <guro@fb.com> wrote:
>
> Since bpf is not using memlock rlimit for memory accounting,
> there are no more reasons to bump the limit.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>
> ---

Similarly for bench, it's a tool that's not coupled with the latest
kernel version, it will be a big step down if the tool doesn't bump
rlimit on its own on slightly older kernels. Let's just keep it for
now.

>  tools/testing/selftests/bpf/bench.c           | 16 ---------------
>  .../selftests/bpf/progs/bpf_iter_bpf_map.c    |  5 ++---
>  tools/testing/selftests/bpf/xdping.c          |  6 ------
>  tools/testing/selftests/net/reuseport_bpf.c   | 20 -------------------
>  4 files changed, 2 insertions(+), 45 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftests/bpf/bench.c
> index 944ad4721c83..f66610541c8a 100644
> --- a/tools/testing/selftests/bpf/bench.c
> +++ b/tools/testing/selftests/bpf/bench.c
> @@ -29,25 +29,9 @@ static int libbpf_print_fn(enum libbpf_print_level level,
>         return vfprintf(stderr, format, args);
>  }
>
> -static int bump_memlock_rlimit(void)
> -{
> -       struct rlimit rlim_new = {
> -               .rlim_cur       = RLIM_INFINITY,
> -               .rlim_max       = RLIM_INFINITY,
> -       };
> -
> -       return setrlimit(RLIMIT_MEMLOCK, &rlim_new);
> -}
> -
>  void setup_libbpf()
>  {
> -       int err;
> -
>         libbpf_set_print(libbpf_print_fn);
> -
> -       err = bump_memlock_rlimit();
> -       if (err)
> -               fprintf(stderr, "failed to increase RLIMIT_MEMLOCK: %d", err);
>  }
>

[...]
