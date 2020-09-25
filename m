Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75CFD278FA6
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 19:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729653AbgIYRbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 13:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727874AbgIYRbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 13:31:41 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F3CC0613CE;
        Fri, 25 Sep 2020 10:31:41 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id 133so2518581ybg.11;
        Fri, 25 Sep 2020 10:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9BF9IaCRzF+a8Ky7jiNjge8FSBEnSh9KnlDUKfIQqSM=;
        b=iKHrW42qfZv+heuF6VckGgwUT79hud37OUjqRyckYWvlR7YN8tMNTdXqHXEwpSDGkK
         stfc7IyIaSz5qASiE43edbqYitT7CZQoW6aNRUDY0F/aYyxtFrIA63GFu6Bxxq6UnEej
         cIz1uvn93NpVIYNh0BlUPRPNOCyqtDbLIircDyWLnjELzqUCrZ2zxik6GqC5pV0YFN9X
         WNvD5f/zjpE6fKqrSmiTMSGCaamWvxvboCj8g+60pxNxORyTlMGDYSxqSkahaPuHxXHZ
         S8YEn8JvoWfldjqzdXA4XIAatKD6AVMhE+7W3c21UnPSmf0KElbhP6TR6DOHSYigwp9I
         YxTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9BF9IaCRzF+a8Ky7jiNjge8FSBEnSh9KnlDUKfIQqSM=;
        b=apceDQKJBC+Nth7dd+yY31yxtRpmPeY6TlpmyAkLCaKoOHBZ08c45t5VVHnMUXOnB0
         KvHK82S4jhihTPiZiMctdy5Gl48VUz3uZfdXDWB/PoDgjBZx+GzyeFSNXCmP7UReOtwN
         PO7KVGgosG8YLX6Yup+o11KkvKej2GaJN88HBgCsdAQhX3xIR7bOYIqg3GqB3FSuY38J
         jwb+tGIn2p3T6bAgVuigIb6GqJWJ3STd7MTPtDXBKhe4J0oTfQ87m9MiCn5haMPEJnAo
         TZr5VRARrCBkuDCrZdYLAT5uE1xJ+jx8/BBiI/1hxtfNg9l91J1M/zHBHChY/p7m8kMv
         m4vw==
X-Gm-Message-State: AOAM530jy6ACsJx3Qu2SNU7hzO7KEGDAtefp8RQahudq9M5KTzoecEyy
        2ZpYD4gx+utsgWXV0ydvFgKoQ0iMwnD66wULZCU=
X-Google-Smtp-Source: ABdhPJyMzzctyJUWCnEBtYTcFKpjdomjIcmLrmlHoOScGdO2QdFWItCSXSeeOjPbLN5k07BsIUq9f9ukykM+v8laxoo=
X-Received: by 2002:a25:2687:: with SMTP id m129mr332170ybm.425.1601055100643;
 Fri, 25 Sep 2020 10:31:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200924230209.2561658-1-songliubraving@fb.com> <20200924230209.2561658-4-songliubraving@fb.com>
In-Reply-To: <20200924230209.2561658-4-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 25 Sep 2020 10:31:29 -0700
Message-ID: <CAEf4BzaD9=+paLnFnnCzyyFsrknyBZPfAZiF=9t6s56RL6Dhsg@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 3/3] selftests/bpf: add raw_tp_test_run
To:     Song Liu <songliubraving@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 4:03 PM Song Liu <songliubraving@fb.com> wrote:
>
> This test runs test_run for raw_tracepoint program. The test covers ctx
> input, retval output, and running on correct cpu.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---

Few suggestions below, but overall looks good to me:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../bpf/prog_tests/raw_tp_test_run.c          | 98 +++++++++++++++++++
>  .../bpf/progs/test_raw_tp_test_run.c          | 24 +++++
>  2 files changed, 122 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/raw_tp_test_run.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_raw_tp_test_run.c
>

[...]

> +
> +       err = bpf_prog_test_run_xattr(&test_attr);
> +       CHECK(err == 0, "test_run", "should fail for too small ctx\n");
> +
> +       test_attr.ctx_size_in = sizeof(args);
> +       err = bpf_prog_test_run_xattr(&test_attr);
> +       CHECK(err < 0, "test_run", "err %d\n", errno);
> +       CHECK(test_attr.retval != expected_retval, "check_retval",
> +             "expect 0x%x, got 0x%x\n", expected_retval, test_attr.retval);
> +
> +       for (i = 0; i < nr_online; i++) {
> +               if (online[i]) {

if (!online[i])
    continue;

That will reduce nestedness by one level

> +                       DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
> +                               .ctx_in = args,
> +                               .ctx_size_in = sizeof(args),
> +                               .flags = BPF_F_TEST_RUN_ON_CPU,
> +                               .retval = 0,
> +                               .cpu = i,
> +                       );

this declares variable, so should be at the top of the lexical scope


> +
> +                       err = bpf_prog_test_run_opts(prog_fd, &opts);
> +                       CHECK(err < 0, "test_run_opts", "err %d\n", errno);
> +                       CHECK(skel->data->on_cpu != i, "check_on_cpu",
> +                             "expect %d got %d\n", i, skel->data->on_cpu);
> +                       CHECK(opts.retval != expected_retval,
> +                             "check_retval", "expect 0x%x, got 0x%x\n",
> +                             expected_retval, opts.retval);
> +
> +                       if (i == 0) {

I agree that this looks a bit obscure. You can still re-use
DECLARE_LIBBPF_OPTS, just move it outside the loop. And then you can
just modify it in place to adjust to a particular case. And in log
output, we'll see 30+ similar success messages for the else branch,
which is indeed unnecessary.

> +                               /* invalid cpu ID should fail with ENXIO */
> +                               opts.cpu = 0xffffffff;
> +                               err = bpf_prog_test_run_opts(prog_fd, &opts);
> +                               CHECK(err != -1 || errno != ENXIO,
> +                                     "test_run_opts_fail",
> +                                     "should failed with ENXIO\n");
> +                       } else {
> +                               /* non-zero cpu w/o BPF_F_TEST_RUN_ON_CPU
> +                                * should fail with EINVAL
> +                                */
> +                               opts.flags = 0;
> +                               err = bpf_prog_test_run_opts(prog_fd, &opts);
> +                               CHECK(err != -1 || errno != EINVAL,
> +                                     "test_run_opts_fail",
> +                                     "should failed with EINVAL\n");
> +                       }
> +               }
> +       }

[...]
