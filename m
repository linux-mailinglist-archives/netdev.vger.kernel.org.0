Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679A22219C9
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 04:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgGPCTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 22:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgGPCTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 22:19:50 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DD2C061755;
        Wed, 15 Jul 2020 19:19:50 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id b4so4101121qkn.11;
        Wed, 15 Jul 2020 19:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=529eT/i/WJuLhFmUkFuyxkO48c99UyjFqkTt/oa7tJg=;
        b=N10qrTj3n2eNBsRJZ/ARMifpBeg4AEtSXSGkijPXsZ8aV7nwiyRpVAp1ZiVrIp3iSW
         94WBh3lzqOQUPKtqJkiJocrJ7atY/Zhe0k0LvzPNocj72A1mfOFy/onmXUrlEtWHV5su
         ZecG931BFzHqnXCpgr2J5RKHAc9w5s0tbJSNW+gXZT5VhMnJeVuGoyLxuPrcTub/W+rb
         k66HbsCAB9m6wGmc2MH9hNV8Dhy3wM8SQ3jxToo2zL2aBkpySpxm6blvT3yr4WkA0yxy
         G283C6T9ntmzmBxAmhkO0FmXxpOdPa9ebNe+I1+UBUCmJIRCVAix97yHH0kyA0IM8w7Q
         YoSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=529eT/i/WJuLhFmUkFuyxkO48c99UyjFqkTt/oa7tJg=;
        b=VUlZl/iKKRVuHS/kWqlK4OmvMrLHIEaj4a0UPqiWxAqtonGPVE2tpH0gBVURGYVJ8z
         ycLjwgUrFoXSW08tH4NWolK7/9wTOYw4nUqbgEPkOx6hMA44YrXIdd7awNdjxLRh8hga
         M4GtmXbloF7NbC52W2Cmijv0vt6YHJJqG+hGwja5FujgMOoeLyrF2TE9jFt9jlS2kZrM
         cfIk2vKcgZwqLjFT39XZG3MBhTD0v6fdkVZifkvIKcUGshZvhz46qIyR1T+hDADpESEp
         8eDsKUcjVbB5jUUvw5wDFwyjNRRnbZpyoOSOVXFZoxwFDE8Gt3PeFQZHjAR+llojpVsg
         bS8w==
X-Gm-Message-State: AOAM533Dn1+08jb/5YqK710UlljwRys+Z5H0zL9glAnv9M13UzSmYMtr
        CPRDna0lL9ltOgOT5LoSfWBPvJAnZPrUFiebEbHe1sJ6
X-Google-Smtp-Source: ABdhPJy5voGj/Qe4PfXrmen0FZXKM38fE5qw95dBb6AC0Mxf4ur6dtBUaXUxqFtpt3Op9DiSRnUmJOaT575GilcqmKc=
X-Received: by 2002:a05:620a:2409:: with SMTP id d9mr2029658qkn.36.1594865989876;
 Wed, 15 Jul 2020 19:19:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200713174654.642628-1-jakub@cloudflare.com> <20200713174654.642628-17-jakub@cloudflare.com>
In-Reply-To: <20200713174654.642628-17-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jul 2020 19:19:39 -0700
Message-ID: <CAEf4BzYPk5kNJb61ceWG-22hu47MBuAcMt=itU+xX0mju22NmA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 16/16] selftests/bpf: Tests for BPF_SK_LOOKUP
 attach point
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 10:48 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Add tests to test_progs that exercise:
>
>  - attaching/detaching/querying programs to BPF_SK_LOOKUP hook,
>  - redirecting socket lookup to a socket selected by BPF program,
>  - failing a socket lookup on BPF program's request,
>  - error scenarios for selecting a socket from BPF program,
>  - accessing BPF program context,
>  - attaching and running multiple BPF programs.
>
> Run log:
>
>   # ./test_progs -n 69
>   #69/1 query lookup prog:OK
>   #69/2 TCP IPv4 redir port:OK

[...]

>   #69/42 multi prog - drop, redir:OK
>   #69/43 multi prog - redir, drop:OK
>   #69/44 multi prog - redir, redir:OK
>   #69 sk_lookup:OK
>   Summary: 1/44 PASSED, 0 SKIPPED, 0 FAILED
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>

nit: It's not universal, unfortunately, but the typical naming pattern
for selftest are: progs/test_<something>.c for BPF part, and
prog_tests/<something>.c for user-space part. Just FYI for the future.

But looks good to me either way.

Acked-by: Andrii Nakryiko <andriin@fb.com>

> Notes:
>     v4:
>     - Remove system("bpftool ...") call left over from debugging. (Lorenz)
>     - Dedup BPF code that selects a socket. (Lorenz)
>     - Switch from CHECK_FAIL to CHECK macro. (Andrii)
>     - Extract a network_helper that wraps inet_pton.
>     - Don't restore netns now that test_progs does it.
>     - Cover bpf_sk_assign(ctx, NULL) in tests.
>     - Cover narrow loads in tests.
>     - Cover NULL ctx->sk access attempts in tests.
>     - Cover accessing IPv6 ctx fields on IPv4 lookup.
>
>     v3:
>     - Extend tests to cover new functionality in v3:
>       - multi-prog attachments (query, running, verdict precedence)
>       - socket selecting for the second time with bpf_sk_assign
>       - skipping over reuseport load-balancing
>
>     v2:
>      - Adjust for fields renames in struct bpf_sk_lookup.
>
>  tools/testing/selftests/bpf/network_helpers.c |   58 +-
>  tools/testing/selftests/bpf/network_helpers.h |    2 +
>  .../selftests/bpf/prog_tests/sk_lookup.c      | 1282 +++++++++++++++++
>  .../selftests/bpf/progs/test_sk_lookup_kern.c |  639 ++++++++
>  4 files changed, 1958 insertions(+), 23 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_lookup.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
>

[...]
