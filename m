Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA251BEE41
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 04:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgD3CXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 22:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD3CXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 22:23:24 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A672C035494;
        Wed, 29 Apr 2020 19:23:24 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id k81so1576053qke.5;
        Wed, 29 Apr 2020 19:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Qe6NyAWMaFc/KLPU7vtZs+qFwL3NN3OiooG0sgjdiY=;
        b=EvhQPpMiVglPJRMEO9DbCZOPlcLRRB9TfL4MZ6ABnMHJuHW39mdhrUD9c9em5GDjYb
         HA03/Ymd5Y1hrTSFaVaxCgGizlR0k/LEhB72lVBwDeJLErA2fQQLxpRFmYNDOHLEJ13s
         XY/cbYEXBQdTgqym02SGOfOsDZ9rHsdYjRzoxTsCEfBXXWTiEN5y9M4S6uHxQ5lLPFZH
         3k2kQ11CfInqSPkr4zHgs0kyroHfrh/+I+eZ2DipW+qnZDhDOaT481GZkeG+sdHoHM8U
         kGgwU0vc3JYPGqB/vlm1CcsXcQ05KXOAkPl1ULCAvs4tl/fXE/9KIK1k4yEy39ADYvfo
         l3Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Qe6NyAWMaFc/KLPU7vtZs+qFwL3NN3OiooG0sgjdiY=;
        b=t3zyjujx+K1yuIV5H5hLkDYJl3/jUyUNRflnqftdnPvI9UQhvayt3vJ6e7LJZVZ5Q2
         /8Dy1mAStHHnIn5tb8As3M+1eBGRjEoxRelDRFp6Ge9+Ke2zl98LFeWGQeYY4ecj2Xc6
         d/lRnCUJd7/vFI+QvdzGfjIKd8IlElT+MCZesMj3MkVegIbznehwEUzT9E4HF0kGLGSc
         l3wexbUv/nCOuTXDrjFQIVd6eMKwHDVdy5w7TolEWSLX19CN5L8JehKeueOUPeKCsWyX
         QXxW6yP/kCAOCJVp+3+V8JONQtpc+mYR6OHg2Nvx44QAu54+Yqts0Wc8Euhwuq7R6ub+
         BLGw==
X-Gm-Message-State: AGi0Pua9EU5SXGIKVkDE7CSFUtpDvh1IwUd3fIrn3lY/OkGv3kV+oJcf
        RmEXdWDUIN5IV96/sCyTmuqJTUS0DMZfWAsz7rE=
X-Google-Smtp-Source: APiQypIw0dI3mwdrt/f+rN/i8NeWDE8DDcXdXcKY41+IKRkYqR3gcE6DFCRAPqYyrQyNSM65GVz9T5NqjmA8YuOW1aQ=
X-Received: by 2002:ae9:e854:: with SMTP id a81mr1526938qkg.36.1588213403472;
 Wed, 29 Apr 2020 19:23:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200429064543.634465-1-songliubraving@fb.com> <20200429064543.634465-4-songliubraving@fb.com>
In-Reply-To: <20200429064543.634465-4-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 29 Apr 2020 19:23:12 -0700
Message-ID: <CAEf4BzZNbBhfS0Hxmn6Fu5+-SzxObS0w9KhMSrLz23inWVSuYQ@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 3/3] bpf: add selftest for BPF_ENABLE_STATS
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

On Tue, Apr 28, 2020 at 11:47 PM Song Liu <songliubraving@fb.com> wrote:
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
>  .../selftests/bpf/prog_tests/enable_stats.c   | 46 +++++++++++++++++++
>  .../selftests/bpf/progs/test_enable_stats.c   | 18 ++++++++
>  2 files changed, 64 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/enable_stats.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_enable_stats.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/enable_stats.c b/tools/testing/selftests/bpf/prog_tests/enable_stats.c
> new file mode 100644
> index 000000000000..cb5e34dcfd42
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/enable_stats.c
> @@ -0,0 +1,46 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include <sys/mman.h>

is this header used for anything?

> +#include "test_enable_stats.skel.h"
> +
> +void test_enable_stats(void)
> +{

[...]

> +
> +char _license[] SEC("license") = "GPL";
> +
> +static __u64 count;

this is actually very unreliable, because compiler might decide to
just remove this variable. It should be either `static volatile`, or
better use zero-initialized global variable:

__u64 count = 0;

> +
> +SEC("raw_tracepoint/sys_enter")
> +int test_enable_stats(void *ctx)
> +{
> +       count += 1;
> +       return 0;
> +}
> --
> 2.24.1
>
