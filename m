Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75EC435E899
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 23:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhDMVyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 17:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbhDMVym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 17:54:42 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C5DC061574;
        Tue, 13 Apr 2021 14:54:22 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id l9so19891206ybm.0;
        Tue, 13 Apr 2021 14:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N/0emf9Qx5elopjGCJXPU0s9jmMACfNBS8pO0rZzUlI=;
        b=iSR3E9+iIjOnKmN8qBY5qhqrDkaaJuWKSSH1T2gYufE+FChGjUnoZ+Fl5IQK+7B211
         rPj1Ecu03/vmr8TRZzmfo2QSZQvOCggEmgJTDrWytgBnf5YLtcYHfwsN/AZJAxixRmT7
         LkqVpkiBEVFNO11pYc9FIzE/2/p40FPnVdJZ0wFaFrrXLqj4EoYIRktC/Fr7yyQ80Rm4
         h+ozlvc9cAiGoY47OA5Y9KO7SRlB47Td6Pt4NcPpOyR0ZI5XfB1lKaNOfzV5eGpQhlGS
         /2GKR1FDGGPmp5HL86bMbmHXZQtytir8ffDvRjemFbYQ5ca4WvCokH8l5QsaRuDH7N6C
         TEkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N/0emf9Qx5elopjGCJXPU0s9jmMACfNBS8pO0rZzUlI=;
        b=TbtThtZljkRHn1KLw7X6Tr5J7/zbpwe9cPPze4F9k/llvBFv38LYyAbnaTwgNjgg/K
         /Z+r1jZDC9WBuLeyJg1tZwzf+SO6VopSZQjJsXbcdtTJ+EO/iT+0zEkQR0Z8aOTZR3oL
         NBhFihGrT75hDJeecDwLFMAZZ4g51m11pYi8ytzO5dsyKpGzFgHT2lyMlKpbaSREAJPC
         A+99YLswrLpF14xtNiqsRA/AepknFYDsZLbgd84iYWLI2mJ0cdNhtYDrYsYcCwQuLbTV
         tRPlk+1MGrUYsc+sJHGtyz9uozMZaGhKG7kOADk2YZIpW9Q5PRZOG6RpHKwdduczbz1v
         pDRg==
X-Gm-Message-State: AOAM532Up1jyZjTojp/Tz3VzMoc3Z6rrTODmnFPsXYFWiKtB8xYylrkU
        S6NJdycxlO9lD3qQ8n0JhkuI8RToBadBiHgw1FA=
X-Google-Smtp-Source: ABdhPJz3vs0Z+ZMygYn+xPVuVrbbJYN5xNyoerrrhA/PrB/vMVPPhThbxyjKlJIjEXQpSPoXy7OoEILriNAKgb5M21w=
X-Received: by 2002:a25:3357:: with SMTP id z84mr38985872ybz.260.1618350861455;
 Tue, 13 Apr 2021 14:54:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210412162502.1417018-1-jolsa@kernel.org> <20210412162502.1417018-3-jolsa@kernel.org>
In-Reply-To: <20210412162502.1417018-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 13 Apr 2021 14:54:10 -0700
Message-ID: <CAEf4Bza6OXC4aVuxVGnn-DOANuFbnuJ++=q8fFpD-f48kb7_pw@mail.gmail.com>
Subject: Re: [PATCHv4 bpf-next 2/5] selftests/bpf: Add re-attach test to fentry_test
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
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

On Mon, Apr 12, 2021 at 9:29 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding the test to re-attach (detach/attach again) tracing
> fentry programs, plus check that already linked program can't
> be attached again.
>
> Also switching to ASSERT* macros and adding missing ';' in
> ASSERT_ERR_PTR macro.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../selftests/bpf/prog_tests/fentry_test.c    | 51 +++++++++++++------
>  tools/testing/selftests/bpf/test_progs.h      |  2 +-
>  2 files changed, 37 insertions(+), 16 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_test.c b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
> index 04ebbf1cb390..f440c74f5367 100644
> --- a/tools/testing/selftests/bpf/prog_tests/fentry_test.c
> +++ b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
> @@ -3,35 +3,56 @@
>  #include <test_progs.h>
>  #include "fentry_test.skel.h"
>
> -void test_fentry_test(void)
> +static int fentry_test(struct fentry_test *fentry_skel)
>  {
> -       struct fentry_test *fentry_skel = NULL;
>         int err, prog_fd, i;
>         __u32 duration = 0, retval;
> +       struct bpf_link *link;
>         __u64 *result;
>
> -       fentry_skel = fentry_test__open_and_load();
> -       if (CHECK(!fentry_skel, "fentry_skel_load", "fentry skeleton failed\n"))
> -               goto cleanup;
> -
>         err = fentry_test__attach(fentry_skel);
> -       if (CHECK(err, "fentry_attach", "fentry attach failed: %d\n", err))
> -               goto cleanup;
> +       if (!ASSERT_OK(err, "fentry_attach"))
> +               return err;
> +
> +       /* Check that already linked program can't be attached again. */
> +       link = bpf_program__attach(fentry_skel->progs.test1);
> +       if (!ASSERT_ERR_PTR(link, "fentry_attach_link"))
> +               return -1;
>
>         prog_fd = bpf_program__fd(fentry_skel->progs.test1);
>         err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
>                                 NULL, NULL, &retval, &duration);
> -       CHECK(err || retval, "test_run",
> -             "err %d errno %d retval %d duration %d\n",
> -             err, errno, retval, duration);
> +       ASSERT_OK(err || retval, "test_run");

this is quite misleading, even if will result in a correct check. Toke
did this in his patch set:

ASSERT_OK(err, ...);
ASSERT_EQ(retval, 0, ...);

It is a better and more straightforward way to validate the checks
instead of relying on (err || retval) -> bool (true) -> int (1) -> !=
0 chain.


>
>         result = (__u64 *)fentry_skel->bss;
> -       for (i = 0; i < 6; i++) {
> -               if (CHECK(result[i] != 1, "result",
> -                         "fentry_test%d failed err %lld\n", i + 1, result[i]))
> -                       goto cleanup;
> +       for (i = 0; i < sizeof(*fentry_skel->bss) / sizeof(__u64); i++) {
> +               if (!ASSERT_EQ(result[i], 1, "fentry_result"))
> +                       return -1;
>         }
>
> +       fentry_test__detach(fentry_skel);
> +
> +       /* zero results for re-attach test */
> +       memset(fentry_skel->bss, 0, sizeof(*fentry_skel->bss));
> +       return 0;
> +}
> +
> +void test_fentry_test(void)
> +{
> +       struct fentry_test *fentry_skel = NULL;
> +       int err;
> +
> +       fentry_skel = fentry_test__open_and_load();
> +       if (!ASSERT_OK_PTR(fentry_skel, "fentry_skel_load"))
> +               goto cleanup;
> +
> +       err = fentry_test(fentry_skel);
> +       if (!ASSERT_OK(err, "fentry_first_attach"))
> +               goto cleanup;
> +
> +       err = fentry_test(fentry_skel);
> +       ASSERT_OK(err, "fentry_second_attach");
> +
>  cleanup:
>         fentry_test__destroy(fentry_skel);
>  }
> diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
> index e87c8546230e..ee7e3b45182a 100644
> --- a/tools/testing/selftests/bpf/test_progs.h
> +++ b/tools/testing/selftests/bpf/test_progs.h
> @@ -210,7 +210,7 @@ extern int test__join_cgroup(const char *path);
>  #define ASSERT_ERR_PTR(ptr, name) ({                                   \
>         static int duration = 0;                                        \
>         const void *___res = (ptr);                                     \
> -       bool ___ok = IS_ERR(___res)                                     \
> +       bool ___ok = IS_ERR(___res);                                    \

heh, it probably deserves a separate patch with Fixes tag...

>         CHECK(!___ok, (name), "unexpected pointer: %p\n", ___res);      \
>         ___ok;                                                          \
>  })
> --
> 2.30.2
>
