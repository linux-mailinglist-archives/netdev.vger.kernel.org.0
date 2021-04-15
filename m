Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966AF361621
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237685AbhDOXZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235045AbhDOXZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 19:25:26 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD50C061574;
        Thu, 15 Apr 2021 16:25:01 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id k73so21755507ybf.3;
        Thu, 15 Apr 2021 16:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tPjAFbaR02gR7T2FSdFoUeYsPQ/c9XI0aL2RMY3Jv3I=;
        b=guND6eSpfJIZq/fXVujObCTSc7aAf2EN1m/+vVQAXSwrs39AaN8eobn+tv3ySGgxq3
         cycjYWdKLxv2j6u3+FzaxqERQZTS2KOGdwhZKVX43oFNXiXBLqBVRDbmyaKwdZd+oQ+5
         pNK3CoSrGmYGgZ9g4kwJklPMl0BWB22QlNxjMM7yDlmdceFMeWzKxbeAX/kFX2CjAqYW
         8WWchTOB3k17Wl0Jt4XYCukmiicKWsR8tbd+rg33gu4dZF5F6D///JLZ66WPDAK5dUHy
         w7bzGc8DgQMO/Uj2dokfQdNE/keH6HDX8R9/ZqRDEfIBUVEanfi3+Vdr/YAGCuRSi3Fv
         AdkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tPjAFbaR02gR7T2FSdFoUeYsPQ/c9XI0aL2RMY3Jv3I=;
        b=l8CmQaFDGmEAKyYdXDVjGxQWzIK36f5IpVAn7MetH5OCA9IBf/K9D0R/c+WPVjCIjy
         kB68oV7FUl9wlZgekapLrErHOHbrLrRLBv7q3M1YHXJMeOJwyRjyJlqihbxSCvTyYya7
         DcsEsOYWsBRrjxTjnqYmHcb4KKybkt2qieASTJ/QtFnLYeY0Jxi2/A9I7ZnacyjMHxTy
         KTGCekAoZAsOZQGHH9nP80yKhig1sUvwKOJsk3zYUoOboF7Hf5HHU2tqdT7Bqce6R2kC
         8CBy3Q1P/benLJlxHKjAJru9wdHLYLVp9LFQySqlgdQ0eCZam3vk6hoWLlLIVuaRZG0A
         nczw==
X-Gm-Message-State: AOAM531R6CwKAa4JyFLPmURfl2mY9U7Wsicco4W621iXWfJuw7oi8Pjx
        f2GfAWOA/+YLwn91OxI+gkBH0ydzFSxNZ3CN544=
X-Google-Smtp-Source: ABdhPJwS7ty2JBCadp8ddbN6rtonw+KTRy52GNaBoKmhOdJL/BZZsQTKf1nVU1WbB5HJkC4jEn0jmU26eZ6bndLrlls=
X-Received: by 2002:a25:d70f:: with SMTP id o15mr7439503ybg.403.1618529101142;
 Thu, 15 Apr 2021 16:25:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210414195147.1624932-1-jolsa@kernel.org> <20210414195147.1624932-8-jolsa@kernel.org>
In-Reply-To: <20210414195147.1624932-8-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Apr 2021 16:24:50 -0700
Message-ID: <CAEf4BzYgwPNrGAzsZgmLhNnJ9eVpr4qTe-NbsFcyfrZ3xZmq5A@mail.gmail.com>
Subject: Re: [PATCHv5 bpf-next 7/7] selftests/bpf: Use ASSERT macros in lsm test
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Julia Lawall <julia.lawall@inria.fr>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 12:52 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Replacing CHECK with ASSERT macros.
>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

thanks!

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  .../selftests/bpf/prog_tests/test_lsm.c       | 27 +++++++------------
>  1 file changed, 10 insertions(+), 17 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/test_lsm.c b/tools/testing/selftests/bpf/prog_tests/test_lsm.c
> index d492e76e01cf..244c01125126 100644
> --- a/tools/testing/selftests/bpf/prog_tests/test_lsm.c
> +++ b/tools/testing/selftests/bpf/prog_tests/test_lsm.c
> @@ -18,8 +18,6 @@ char *CMD_ARGS[] = {"true", NULL};
>  #define GET_PAGE_ADDR(ADDR, PAGE_SIZE)                                 \
>         (char *)(((unsigned long) (ADDR + PAGE_SIZE)) & ~(PAGE_SIZE-1))
>

[...]
