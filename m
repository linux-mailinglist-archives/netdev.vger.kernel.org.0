Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8E743AAD3
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 05:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhJZDsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 23:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232597AbhJZDsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 23:48:11 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7151CC061745;
        Mon, 25 Oct 2021 20:45:48 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id y80so13366035ybe.12;
        Mon, 25 Oct 2021 20:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8lNFW1Dtnj58pOz/PALMC73Rmhfh02j9dS73pS4W2Ok=;
        b=LsIF4Zk/hjnnPascKICyEGVPmPsudu1Y1XJF4BDSUtlUiT83APO1T+OAAFL+FkpT9H
         s1pCpN8Hfr9eMbcbLTkTUCeM5XjbZTf7T4KKwegfH+bpWELJpD351B44+hcMj2T82d0W
         rtN/XBQO3N7Xj6mx21kymeze/tjl8QGaLtWEsh9wMzCQmJPMjyEDr2eRhMv5OA84iE2i
         qlNTUvDDQzKN/2z+x4+XJ2ep5f3uXexXxp2WIXTfOPJVaXqnEuSP0IWmTxklNbBlHZGU
         7yafvpijBcv4obLn9b62G1Thz5DEZvL5ak784LQU7zpuUwn1W1CK1GSbGxeptOZUFHgE
         V8XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8lNFW1Dtnj58pOz/PALMC73Rmhfh02j9dS73pS4W2Ok=;
        b=vhL/nOwjhRETzsrJi1JAGVrW6ub8bfc5nxgatDNO2WCN6YZe/Q2c0SmoHhpTlr9j63
         Qq2E+p14wEldZWHDDkF3NMsbbcbaD302sy7ag7zUgNMHRovEcHr7PIFopXIYX4DskxeD
         r9B7fuYnOEkpUumnrOMF18nFdtRk5yrGVPyQLEubZh2Hh9yVgLWm4hPdJwB1LQyMO9ts
         bWbugyLZd7y7OGaXzYpeFiogPgSACmndmlCHIlSLZc2XD2JXmUIwluafZ198umOQNJIx
         U4zl7Tq0F9vl5hE1xzy+2r4oBz/ho9106DNGvA2QawFTf22YBWaUCbE+SsCasuHwaopq
         36rA==
X-Gm-Message-State: AOAM531HMyPSq+Eb2rC5jpiyjJstUe6ayFI2kiY0hwtIYxSERv4tsKvm
        vb/VGZYQU0guyXF7tn7t+MEjNQEfWndWX/5pt7Y=
X-Google-Smtp-Source: ABdhPJx35I6nxnl6Rt7p7j90z4i+6t2vZOV6y7h374myi+Ax/9Sdj8ipifjqqxJXQ2G5mcuFfhMkDPeHRXUJIbX+ZUs=
X-Received: by 2002:a25:8749:: with SMTP id e9mr20843792ybn.2.1635219947699;
 Mon, 25 Oct 2021 20:45:47 -0700 (PDT)
MIME-Version: 1.0
References: <20211026000733.477714-1-songliubraving@fb.com>
In-Reply-To: <20211026000733.477714-1-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 Oct 2021 20:45:36 -0700
Message-ID: <CAEf4BzajKH1gSo_MNoYb5GfnAy-o_P2viNuQSMUywrU4MPFbjg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Skip all serial_test_get_branch_snapshot
 in vm
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 5:07 PM Song Liu <songliubraving@fb.com> wrote:
>
> Skipping the second half of the test is not enough to silent the warning
> in dmesg. Skip the whole test before we can either properly silent the
> warning in kernel, or fix LBR snapshot for VM.
>
> Fixes: 025bd7c753aa ("selftests/bpf: Add test for bpf_get_branch_snapshot")
> Fixes: aa67fdb46436 ("selftests/bpf: Skip the second half of get_branch_snapshot in vm")
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---

Applied to bpf-next, thanks for the fix!

>  .../bpf/prog_tests/get_branch_snapshot.c         | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c b/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
> index d6d70a359aeb5..81402e4439844 100644
> --- a/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
> +++ b/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
> @@ -78,6 +78,12 @@ void serial_test_get_branch_snapshot(void)
>         struct get_branch_snapshot *skel = NULL;
>         int err;
>
> +       /* Skip the test before we fix LBR snapshot for hypervisor. */
> +       if (is_hypervisor()) {
> +               test__skip();
> +               return;
> +       }
> +
>         if (create_perf_events()) {
>                 test__skip();  /* system doesn't support LBR */
>                 goto cleanup;
> @@ -107,16 +113,6 @@ void serial_test_get_branch_snapshot(void)
>                 goto cleanup;
>         }
>
> -       if (is_hypervisor()) {
> -               /* As of today, LBR in hypervisor cannot be stopped before
> -                * too many entries are flushed. Skip the hit/waste test
> -                * for now in hypervisor until we optimize the LBR in
> -                * hypervisor.
> -                */
> -               test__skip();
> -               goto cleanup;
> -       }
> -
>         ASSERT_GT(skel->bss->test1_hits, 6, "find_looptest_in_lbr");
>
>         /* Given we stop LBR in software, we will waste a few entries.
> --
> 2.30.2
>
