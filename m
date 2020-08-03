Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74E5239D50
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 03:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgHCBvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 21:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgHCBvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 21:51:44 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3748AC06174A;
        Sun,  2 Aug 2020 18:51:44 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id y134so14115896yby.2;
        Sun, 02 Aug 2020 18:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rSlvuBkhKI8ZfP2CG2gpFzW6Sro8x7VblhmK9hkVZx0=;
        b=cyOcAwQisRYt3bU2sWtyXgkBcHFLudWMY801kGb9j/mfVmEZ7+VtagXdSYpmDDIxef
         AWDcXoUjPF2vY44Mnh/ZmzViLICYpIKNPGawjr968PWZePsSsYbJnok/f4634SGoWtLJ
         WlfaptLiN2VBEHEhd412h3eBTCU6znetWu7/SWMxSaIyJjQkmIOAM3J+/FyjoWLTappk
         V9OaCMSD+6J/T5q2GEuQVVB1OHKECxV0pT6dzG1CwEVBRy2Qa7AColon08YeVepKGQwC
         KQyST25rihRWggpRqXnvN5lo7J+dy+yVTSzgS0dYTF+Vwi1Q8RAFTjCzC0ng5qzhiRdP
         d9Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rSlvuBkhKI8ZfP2CG2gpFzW6Sro8x7VblhmK9hkVZx0=;
        b=X1OiKD3Jelp/1JXUbCm4ZweajmZo1KJFK0ReQaff351Kr4Qdm+6qsZlDinbytMKH7n
         fYZ1+6CbMXRR1Cj6OsndRAyWiQv8np15MXbIyEH8kcAETVqDa2Rk9O1OXrGAWYP/QxxO
         SIQyW+UyCAEPA9G9flbjNkzs4CKcf/ywPae2VzCBhmUIIYpCJGvpRtxqIjsZXMBHuiA7
         vZfzn86gsOZ3G5mQWxxfPXiXFxV2P5MJ/b91aWAkifACQTwEurIT8pW09FWkQmtpQ/8T
         m29r+ZIRhHcajbzzAjNxWbBunlknAM6EFF9fPLKrrI6rdjfk8cn7QsO7W4Pn+g38TKBs
         Iieg==
X-Gm-Message-State: AOAM530c+dSApTdhF2QBcYipjZvlOm4rnxlH459nCweX2Imb33U+miMe
        k+xpj2xZyctVn0b9awGDcj0j1RD68fko+T6yt7hwsQ==
X-Google-Smtp-Source: ABdhPJxmcpHBrRB0qmeK4RJAteEptQ7Q2aQHx8taXNO++2+/eqBNhNOkuGYEDkQAUvQVz12JJHqGyo5+DhPRCXm3tGY=
X-Received: by 2002:a25:37c8:: with SMTP id e191mr20873804yba.230.1596419503535;
 Sun, 02 Aug 2020 18:51:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200801084721.1812607-1-songliubraving@fb.com> <20200801084721.1812607-6-songliubraving@fb.com>
In-Reply-To: <20200801084721.1812607-6-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 2 Aug 2020 18:51:32 -0700
Message-ID: <CAEf4BzaP4TGF7kcmZRAKsy=oWPpFA6sUGFkctpGz-fPp+YuSOQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/5] selftests/bpf: add benchmark for uprobe vs. user_prog
To:     Song Liu <songliubraving@fb.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Xu <dlxu@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 1, 2020 at 1:50 AM Song Liu <songliubraving@fb.com> wrote:
>
> Add a benchmark to compare performance of
>   1) uprobe;
>   2) user program w/o args;
>   3) user program w/ args;
>   4) user program w/ args on random cpu.
>

Can you please add it to the existing benchmark runner instead, e.g.,
along the other bench_trigger benchmarks? No need to re-implement
benchmark setup. And also that would also allow to compare existing
ways of cheaply triggering a program vs this new _USER program?

If the performance is not significantly better than other ways, do you
think it still makes sense to add a new BPF program type? I think
triggering KPROBE/TRACEPOINT from bpf_prog_test_run() would be very
nice, maybe it's possible to add that instead of a new program type?
Either way, let's see comparison with other program triggering
mechanisms first.


> Sample output:
>
> ./test_progs -t uprobe_vs_user_prog -v
> test_uprobe_vs_user_prog:PASS:uprobe_vs_user_prog__open_and_load 0 nsec
> test_uprobe_vs_user_prog:PASS:get_base_addr 0 nsec
> test_uprobe_vs_user_prog:PASS:attach_uprobe 0 nsec
> run_perf_test:PASS:uprobe 0 nsec
> Each uprobe uses 1419 nanoseconds
> run_perf_test:PASS:user_prog_no_args 0 nsec
> Each user_prog_no_args uses 313 nanoseconds
> run_perf_test:PASS:user_prog_with_args 0 nsec
> Each user_prog_with_args uses 335 nanoseconds
> run_perf_test:PASS:user_prog_with_args_on_cpu 0 nsec
> Each user_prog_with_args_on_cpu uses 2821 nanoseconds
> Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  .../bpf/prog_tests/uprobe_vs_user_prog.c      | 101 ++++++++++++++++++
>  .../selftests/bpf/progs/uprobe_vs_user_prog.c |  21 ++++
>  2 files changed, 122 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/uprobe_vs_user_prog.c
>  create mode 100644 tools/testing/selftests/bpf/progs/uprobe_vs_user_prog.c
>

[...]
