Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D29C466AC6
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 21:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344908AbhLBUPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 15:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240256AbhLBUPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 15:15:20 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37078C06174A;
        Thu,  2 Dec 2021 12:11:57 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id v203so2826730ybe.6;
        Thu, 02 Dec 2021 12:11:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C5odNkgpOlK+IQa5X8eMyWufJ18QJE502yOHCZfZwcw=;
        b=RuoQiwm9MWYiuyQIglIltB2ZhThs/K/EJsYDbhAQ7rYexEme3Trip1IbTsCTFrnswa
         U3X1SRJUyJYw2w4K8UqkMj4WhRT1+9dVZ7kCSWK60zj8gfUuh//9UwwFk8CiGZhv14y4
         vVPKVbWeIprbApC0O3Qa9up7DtqgmdhizabDfOWJ2XreRvKNZIvsBK/vzlkkpyq4dPAS
         czyD60esNaXt+s+6Y7hTrU9UnCj0RpsODlhpgifbEDnGRt0V/Huw50X6GyD/y/PthnZt
         Mpf7OSkz1ueTuDKxmt4tx7cdixizbK4HKQguhB5Fsd06oWff1Tm5yINzKYGZAfDwk5TM
         99Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C5odNkgpOlK+IQa5X8eMyWufJ18QJE502yOHCZfZwcw=;
        b=UcCIaLgFR55N/j/KOK0AH6O7K2jpvODawkHZ2e2BsmxYwVVTrZKInPtw33CoICMIae
         ujuMWwKKFm0Q2miUj6bH2n7B+KmlNo7GQbnHqg5Nfbi+sE0mP9w0EYVvSyRtslSeumrn
         Oy2XSWxic5nW62SS6n1n7ijNvL87xixxt9QbWdDnL2KIKCP5d/SfTZLU+0xA5i7ktT2V
         W4pGjBXnZAn7usSa7u08D6Qi3vUvkakhmz0JQKcXVgipa+M+iyg70lfpKtoG3HMdZjLd
         4Sz0BqA+b2OegwIUkYrFnnjdxt60C+9ErRsL0LrDtfVHo137vPu9NyhxHfbVLL3re/S7
         pV1A==
X-Gm-Message-State: AOAM533phqnvvqH+6B4WR47OfqJsXAJBeqIzkUycmAH6PeTqUwUG3/sP
        gy2DQU+lmnWYZkRSLw2kwEBi0KQ9HjNlevgJItk=
X-Google-Smtp-Source: ABdhPJyZMXPeV1RaU+pUJsdEw4wBM+kG9jQBJvOltUbWj6jrW0KqRKIFwiHO8VHLkLS2HQDse7tuJNINl72X/q7i+Uk=
X-Received: by 2002:a25:abaa:: with SMTP id v39mr17865681ybi.367.1638475916510;
 Thu, 02 Dec 2021 12:11:56 -0800 (PST)
MIME-Version: 1.0
References: <20211201005030.GA3071525@paulmck-ThinkPad-P17-Gen-1>
In-Reply-To: <20211201005030.GA3071525@paulmck-ThinkPad-P17-Gen-1>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 2 Dec 2021 12:11:45 -0800
Message-ID: <CAEf4BzYHycMkdkYdNWjd+XOaHUfJnmbAAKOh_Gu1WpN=MJZ-wA@mail.gmail.com>
Subject: Re: [PATCH] testing/bpf: Update test names for xchg and cmpxchg
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 4:50 PM Paul E. McKenney <paulmck@kernel.org> wrote:
>
> The test_cmpxchg() and test_xchg() functions say "test_run add".
> Therefore, make them say "test_run cmpxchg" and "test_run xchg",
> respectively.
>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: KP Singh <kpsingh@kernel.org>
> Cc: <linux-kselftest@vger.kernel.org>
> Cc: <netdev@vger.kernel.org>
> Cc: <bpf@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
>

fixed up "testing/bpf" to more commonly used "selftests/bpf" and
pushed to bpf-next, thanks.


> diff --git a/tools/testing/selftests/bpf/prog_tests/atomics.c b/tools/testing/selftests/bpf/prog_tests/atomics.c
> index 0f9525293881b..86b7d5d84eec4 100644
> --- a/tools/testing/selftests/bpf/prog_tests/atomics.c
> +++ b/tools/testing/selftests/bpf/prog_tests/atomics.c
> @@ -167,7 +167,7 @@ static void test_cmpxchg(struct atomics_lskel *skel)
>         prog_fd = skel->progs.cmpxchg.prog_fd;
>         err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
>                                 NULL, NULL, &retval, &duration);
> -       if (CHECK(err || retval, "test_run add",
> +       if (CHECK(err || retval, "test_run cmpxchg",
>                   "err %d errno %d retval %d duration %d\n", err, errno, retval, duration))
>                 goto cleanup;
>
> @@ -196,7 +196,7 @@ static void test_xchg(struct atomics_lskel *skel)
>         prog_fd = skel->progs.xchg.prog_fd;
>         err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
>                                 NULL, NULL, &retval, &duration);
> -       if (CHECK(err || retval, "test_run add",
> +       if (CHECK(err || retval, "test_run xchg",
>                   "err %d errno %d retval %d duration %d\n", err, errno, retval, duration))
>                 goto cleanup;
>
