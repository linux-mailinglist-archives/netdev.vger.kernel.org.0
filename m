Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3E41C047D
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 20:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgD3SQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 14:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725844AbgD3SQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 14:16:14 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0817DC035494;
        Thu, 30 Apr 2020 11:16:13 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id s30so5865656qth.2;
        Thu, 30 Apr 2020 11:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bmiryqmNsMzqCrzqAFyjAS+CdD2hpANbynwf8cFNSWY=;
        b=JValaWbuw3XkJirkJzU8Ghjs8H+tBfdwOFLoC9EuhgdI/bPKv5phMwNROvR7aybWME
         Q6x8LnAfwylhJ9SkD3NMXB+EyMfcp62OvrCnaKu7sHkCE1g2Ks7092JUOjvaaRDcpdE+
         CwS1YToT7Xo3zseZYtlj1/4azqH5OtO8MV7gX5nYel/OQGzqKsZQJLVUvRHYLEJ3hwKA
         294Veb/HCgA0h5fODa2Gakj7XXQ/g/8ZZpayPgVk0h+vSmK8VobAJuUSTNpl5/QUJWDy
         zAkrKZEPENFzSdIFBiQU6wN2Qg4/7K1OHWy1c8mafiKO+p70SClV95JPwVHx9T5lC0cJ
         Ut2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bmiryqmNsMzqCrzqAFyjAS+CdD2hpANbynwf8cFNSWY=;
        b=UZ8SkIiEBOJZoYFGyu+OzKrSS51ealcCwxQvz0n6fbcvVpEeVTPMT2qCz04/odn2v+
         S5a7a7Lh3msz3FSkE9aI7tyubFP9aZl8ZQ0EgDe4jrtLt+3b027VSVeXiQmzizQ5rhcS
         sg/h53HsN/6+5wpr+hR12RzveVXrRdZUHUouhth0/KA7asAdV9p3OBhApzDRI00gukOu
         dH6D5+Z2/ioYPGb4CTTBruMPXTb0650wUGC6QzteBSyvBxGy2InLJZL36ReEEoCdEVEJ
         16PfCLJ1UUfuwAn9pTUxiktyLI40nmuZbM3F5OcEbwqEd6leZ+59MUeWr8GCf5CePNnZ
         me8w==
X-Gm-Message-State: AGi0PuYtCikfuTGcbC5QEvfGyLAzNhdZGvp4z5p7ubqd9MRs+45d2hae
        ep/BkVocqaqnTd1pANnGpGVGdNhpmz58ZTdOEW9oRzOH
X-Google-Smtp-Source: APiQypLCMhZfHmzKtuBVjnSIkr/dfC+B6ff3hBwBpqpGbD12AsIeVQHRfVwC00TBncI4+CD/lYKZy9vcgj861kGH13o=
X-Received: by 2002:aed:2e24:: with SMTP id j33mr5027180qtd.117.1588270573067;
 Thu, 30 Apr 2020 11:16:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200430071506.1408910-1-songliubraving@fb.com> <20200430071506.1408910-4-songliubraving@fb.com>
In-Reply-To: <20200430071506.1408910-4-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 30 Apr 2020 11:16:01 -0700
Message-ID: <CAEf4Bza7upE6HTowsOa1qioLqCOCHy1t4SWd5X1ickKwbf9vng@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 3/3] bpf: add selftest for BPF_ENABLE_STATS
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 12:16 AM Song Liu <songliubraving@fb.com> wrote:
>
> Add test for BPF_ENABLE_STATS, which should enable run_time_ns stats.
>
> ~/selftests/bpf# ./test_progs -t enable_stats  -v
> test_enable_stats:PASS:skel_open_and_load 0 nsec
> test_enable_stats:PASS:get_stats_fd 0 nsec
> test_enable_stats:PASS:attach_raw_tp 0 nsec
> test_enable_stats:PASS:get_prog_info 0 nsec
> test_enable_stats:PASS:check_stats_enabled 0 nsec
> test_enable_stats:PASS:check_run_cnt_valid 0 nsec
> Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../selftests/bpf/prog_tests/enable_stats.c   | 45 +++++++++++++++++++
>  .../selftests/bpf/progs/test_enable_stats.c   | 18 ++++++++
>  2 files changed, 63 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/enable_stats.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_enable_stats.c
>

[...]

> +       stats_fd = bpf_enable_stats(BPF_STATS_RUN_TIME);
> +       if (CHECK(stats_fd < 0, "get_stats_fd", "failed %d\n", errno)) {
> +               test_enable_stats__destroy(skel);
> +               return;
> +       }
> +
> +       err = test_enable_stats__attach(skel);
> +       if (CHECK(err, "attach_raw_tp", "err %d\n", err))
> +               goto cleanup;
> +
> +       test_enable_stats__detach(skel);

It's a bit subtle that we rely on detach (which does close()) to
trigger attached program :) But it works!

> +
> +       prog_fd = bpf_program__fd(skel->progs.test_enable_stats);
> +       memset(&info, 0, info_len);
> +       err = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
> +       if (CHECK(err, "get_prog_info",
> +                 "failed to get bpf_prog_info for fd %d\n", prog_fd))
> +               goto cleanup;
> +       if (CHECK(info.run_time_ns == 0, "check_stats_enabled",
> +                 "failed to enable run_time_ns stats\n"))
> +               goto cleanup;
> +
> +       CHECK(info.run_cnt != skel->bss->count, "check_run_cnt_valid",
> +             "invalid run_cnt stats\n");
> +

[...]
