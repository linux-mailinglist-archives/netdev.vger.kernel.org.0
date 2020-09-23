Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA0A275ED7
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 19:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgIWRkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 13:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgIWRkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 13:40:15 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B3DC0613CE;
        Wed, 23 Sep 2020 10:40:15 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id a2so375785ybj.2;
        Wed, 23 Sep 2020 10:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PE8oC59I+omnrLmvy8a5LrNumqDXthYrSfqrC3yRXFs=;
        b=uIwy4++VlNLiJxYLpulP8oZ4eHG/oqi2exm/nhdPhPJfvx6D2q84wGa8bhjjJspIWu
         ALRgsqOSHf6gkT5EwuUTLLyaJM3a0R9/fGJxpZEdjPG/OLvGXobVhQgbCfj7dcFe8Tze
         OtGCIEaJviju7wSobFf55S5oH7D5HdGCxB0yP43c1oWTWpyJkagtQxwv2/WyPJRDKNih
         JXqHyMUNOitD9jFBAUbfBCqhxSZ7jtAQhZ7q0hdXajjavTLFQO5WHMu6093zrvP7uzlA
         Y9ttKxtaU/etAosAa3DFvLygYo1nlWz397DmP2Ils++foJUbOFEirIfEChHj0YiaucCY
         IAfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PE8oC59I+omnrLmvy8a5LrNumqDXthYrSfqrC3yRXFs=;
        b=dNIIRlal2Q5RA3uNy/gtmG681clkc3XQqJOKnptjS560tp6cYYSIq1MR0LHVoGVZOo
         SgutZTj+duj1JJD+PS31BzirlUTt7gLKBD1Tq5JKFvK17PUWsyLJUOIH6PIOEI+8X4Dm
         pAw1dDVpsB/QdEQ1n0bYT4DYVTXNQWRrkyCMODsDWy1EtL+dRJeQocI408j3yUbHkZIt
         UYSszPM+JM8SeMXFH0HSPzCizcU8EjsfSri9bvOuCEOlKq2nmO9Fq/h35qZ8LAqIchXk
         MCN69af9FYdoqGB/+xDvGKChADY9EigpAK5taO84DvSoXziUVcjH2Ow9jmr9wTZu4O4p
         isXg==
X-Gm-Message-State: AOAM533f6V+zSkDYNatH2BDh8OuegHDVGwgE0sLSZtGYtIRDn77yEEet
        GM7ndpIlc3BP0JPK/vT322i8uVh7/10VB0ofbtg=
X-Google-Smtp-Source: ABdhPJy9ljwOvf9UTAnurGZNQxy5N75aB3tVj/h2li27ttE+Ns2plCekMDFvL+lk5lusS0a0P1F/ca8FC9mKWYrEC0I=
X-Received: by 2002:a25:8541:: with SMTP id f1mr1533541ybn.230.1600882814845;
 Wed, 23 Sep 2020 10:40:14 -0700 (PDT)
MIME-Version: 1.0
References: <160079991372.8301.10648588027560707258.stgit@toke.dk> <160079992560.8301.11225602391403157558.stgit@toke.dk>
In-Reply-To: <160079992560.8301.11225602391403157558.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 23 Sep 2020 10:40:04 -0700
Message-ID: <CAEf4Bza8Omo6-f=ndMJiwxNma-G9EK6bnyHxTU0evCi=zSephg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 11/11] selftests: Remove fmod_ret from
 benchmarks and test_overhead
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 11:39 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> The benchmark code and the test_overhead prog_test included fmod_ret
> programs that attached to various functions in the kernel. However, these
> functions were never listed as allowed for return modification, so this
> only worked because of the verifier skipping tests when a trampoline
> already existed for the attach point. Now that the verifier checks have
> been fixed, remove fmod_ret from the affected tests so they all work agai=
n.
>
> Fixes: 4eaf0b5c5e04 ("selftest/bpf: Fmod_ret prog and implement test_over=
head as part of bench")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/bench.c                |    5 -----
>  tools/testing/selftests/bpf/benchs/bench_rename.c  |   17 --------------=
---
>  tools/testing/selftests/bpf/benchs/bench_trigger.c |   17 --------------=
---
>  .../selftests/bpf/prog_tests/test_overhead.c       |   14 +-------------
>  tools/testing/selftests/bpf/progs/test_overhead.c  |    6 ------
>  tools/testing/selftests/bpf/progs/trigger_bench.c  |    7 -------
>  6 files changed, 1 insertion(+), 65 deletions(-)
>

[...]
