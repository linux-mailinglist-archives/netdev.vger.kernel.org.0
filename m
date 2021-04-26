Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDEA36B622
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 17:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbhDZPvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 11:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbhDZPvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 11:51:03 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42ACC061574;
        Mon, 26 Apr 2021 08:50:20 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id z1so65413646ybf.6;
        Mon, 26 Apr 2021 08:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+0I4S6PEfUIEKAa1QAUf56hnvXIAyZaXrUT2fpTE6VQ=;
        b=io15D/uMTpRdiYHDjCK4CyoMoPxHTSSY6QTLceTBn7+isWftEKnjKC8JqQOuFz4frC
         WpxgZoib+8o+UN+KoskrZ0p3OQByPbh+FVOTj1/47xbAlBe+zvEt02teb0iFx2c3Uoif
         XuSZ2SSjU1/5j481VdQbVTud8m03oJrKknrJD7p/BZ3rEHHCwbsIZFmv4Rfs/lbZ11n7
         b0OY0j8+f6fIxwMtUWLGCwx4IfnOIKJk2fPuOCiZ/2aSC3obNT8jx+lPlsULpZPLgHmA
         S+WgNomYgo+aOlqhGFgVwgWjbZHg4kQ5gBG4Aj+xzBWB3mx0nN6CK1fq7y6CG92jGEih
         kkGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+0I4S6PEfUIEKAa1QAUf56hnvXIAyZaXrUT2fpTE6VQ=;
        b=SfgdwMODHjIZn8mYw9IBvILIcrcKv2bAKAhz6ZZWBNZ+y0hwmlo9a9LKII8iqgRGFh
         mjV7MHFPp+1waWnZrSkXanQXEtnTcz6Ypt8lGLxLacvAXaSpKvzD3yddPGimYh7e/9/0
         EGLO42Qyh1L4OyVCx6un2asD6a+ssnOxLuXkd/JVq6F944n8Rx4N1bl8otFkOQQ1bkV0
         zVzlgOtnoOnZYgtxszhUgLdi7LyhCM4xuAYeePqEAPrsuVZxBjUy2l7XGFgjBIBRjwIU
         O0OYvOUD6snVOfEg2LdJRiBO9uA45j6BReLyAkMxtv6FSmH38DZgwHrnRBqai2tyLmBK
         GRJg==
X-Gm-Message-State: AOAM532voVM4RS0QCfIwBrR1eXLFTYU1uwohBr4NgS5hkaaO1qimY78j
        jos0y8vzmVP7bVKZiCDh7Y4x2d10P/mgdBqtTsA=
X-Google-Smtp-Source: ABdhPJwEAn2IT6xpyO59r/OF/y7W5W2wJzgzjRfptKS0ngh6Q0P+Dqk+dGA/v2Wc5eS9bjeL8SUft3OVihmmgLKEBx8=
X-Received: by 2002:a25:c4c5:: with SMTP id u188mr26053196ybf.425.1619452220039;
 Mon, 26 Apr 2021 08:50:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210423233058.3386115-1-andrii@kernel.org> <20210423233058.3386115-2-andrii@kernel.org>
 <CACAyw985JaDmA6n3c_sLDn3Ltwndc_zkNWu84b-cMh2NqjVeNA@mail.gmail.com>
In-Reply-To: <CACAyw985JaDmA6n3c_sLDn3Ltwndc_zkNWu84b-cMh2NqjVeNA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Apr 2021 08:50:08 -0700
Message-ID: <CAEf4BzYQZCYZ7aXeSW2xJKLeQTvObiO5eabA5XvX34wF1NTBhw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/5] selftests/bpf: add remaining ASSERT_xxx() variants
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 1:06 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Sat, 24 Apr 2021 at 00:36, Andrii Nakryiko <andrii@kernel.org> wrote:
> >
> > Add ASSERT_TRUE/ASSERT_FALSE for conditions calculated with custom logic to
> > true/false. Also add remaining arithmetical assertions:
> >   - ASSERT_LE -- less than or equal;
> >   - ASSERT_GT -- greater than;
> >   - ASSERT_GE -- greater than or equal.
> > This should cover most scenarios where people fall back to error-prone
> > CHECK()s.
> >
> > Also extend ASSERT_ERR() to print out errno, in addition to direct error.
> >
> > Also convert few CHECK() instances to ensure new ASSERT_xxx() variants work as
> > expected. Subsequent patch will also use ASSERT_TRUE/ASSERT_FALSE more
> > extensively.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >  .../selftests/bpf/prog_tests/btf_dump.c       |  2 +-
> >  .../selftests/bpf/prog_tests/btf_endian.c     |  4 +-
> >  .../selftests/bpf/prog_tests/cgroup_link.c    |  2 +-
> >  .../selftests/bpf/prog_tests/kfree_skb.c      |  2 +-
> >  .../selftests/bpf/prog_tests/resolve_btfids.c |  7 +--
> >  .../selftests/bpf/prog_tests/snprintf_btf.c   |  4 +-
> >  tools/testing/selftests/bpf/test_progs.h      | 50 ++++++++++++++++++-
> >  7 files changed, 56 insertions(+), 15 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
> > index c60091ee8a21..5e129dc2073c 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
> > @@ -77,7 +77,7 @@ static int test_btf_dump_case(int n, struct btf_dump_test_case *t)
> >
> >         snprintf(out_file, sizeof(out_file), "/tmp/%s.output.XXXXXX", t->file);
> >         fd = mkstemp(out_file);
> > -       if (CHECK(fd < 0, "create_tmp", "failed to create file: %d\n", fd)) {
> > +       if (!ASSERT_GE(fd, 0, "create_tmp")) {
>
> Nit: I would find ASSERT_LE easier to read here. Inverting boolean
> conditions is easy to get wrong.

You mean if (ASSERT_LE(fd, -1, "create_tmp")) { err = fd; goto done; } ?

That will mark the test failing if fd >= 0, which is exactly opposite
to what we wan't. It's confusing because CHECK() checks invalid
conditions and returns "true" if it holds. But ASSERT_xxx() checks
*valid* condition and returns whether valid condition holds. So the
pattern is always

if (CHECK(expr)) --> if (!ASSERT_xxx(!expr))

And it might feel awkward only when converting original inverted condition.

>
> >                 err = fd;
> >                 goto done;
> >         }
> > diff --git a/tools/testing/selftests/bpf/prog_tests/btf_endian.c b/tools/testing/selftests/bpf/prog_tests/btf_endian.c
> > index 8c52d72c876e..8ab5d3e358dd 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/btf_endian.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/btf_endian.c
> > @@ -6,8 +6,6 @@
> >  #include <test_progs.h>
> >  #include <bpf/btf.h>
> >
> > -static int duration = 0;
>
> Good to see this go.
>
> Acked-by: Lorenz Bauer <lmb@cloudflare.com>
>
> --
> Lorenz Bauer  |  Systems Engineer
> 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
>
> www.cloudflare.com
