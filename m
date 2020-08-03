Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AC4239D4C
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 03:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgHCBqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 21:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgHCBqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 21:46:48 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E443C06174A;
        Sun,  2 Aug 2020 18:46:48 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id u43so6092877ybi.11;
        Sun, 02 Aug 2020 18:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qer4CX4K+qk3GBRMjwRPQATSWlfpwQSXhVzzAfNbeKA=;
        b=F1AHwahpFGW+JUEX+4SLncBP19BJ7rQqD8J/ngnfqCa/YZX09RhiPHn2Ku+wzd6glf
         dPn8hrVUf7sn/eo0dtMA3OMBKJssAx17BlgNNjiBEGkTI2bRPxRLkwBe9VR/BWDx03n0
         I70+ynZj8Il5jxs1+o0nAI0SDlgF0TLlEjpew20KgxDaYc1MTixpHvgdfxuyGBpNQEXI
         xeJ4P7vadbbfAsatA333HeFHJ7MYI/GCblU98qBRJlVsSuD4+8vSbY7PMfTxPwIkUMjV
         7LYrVQPZE7jC0OjgezMWeMQhNGXslVGHcgkX4xc3lPr+87AmLAAnc+bep845ptdQfGuW
         b+nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qer4CX4K+qk3GBRMjwRPQATSWlfpwQSXhVzzAfNbeKA=;
        b=HhwUWLr16B4AbS9VGCEKPhbBic17SF2cw2iI0EyS1kwyMUjPDWdKswC8ZIgPgdgC4B
         lW3QnGwSB+8nKFGvPZhUceKAm11BdWEENG9x2XboQoUlTJ3zBdo7YY6nxzEyrrXcp4Wo
         JX4TvFIuMAGVPBhAUDsxRcMx+1hh22tDkpbQb++CTAwifPTElU9vTeTj5t/K3XCH6YCC
         yQNz93sq8EMqCskzkLJpQ/RX/o3ZdTMDM8/QBom4I1mlG/jxusshpvEcQBNj9HKTlgPE
         zIQI9vtEQHq0eXVTxD/IH0SQc+93iexlaheYz3zetlqRK49u7g7Fc18l4SZxQDJm9LE6
         mALA==
X-Gm-Message-State: AOAM5304TyN4lZ2cZB6DR91HD766g4/670qG4M57HvUKleh45kWf9UZw
        5/S4qS01OoqLRlgOoYKexZU9wVGJfMO1TJCjc/Q=
X-Google-Smtp-Source: ABdhPJwR0a0vag7S3v7M/rvn0O03OIWe4Gys6A6P4rr6k53DHLVjiwECCOqr0qh+deq3GUOCSjLsXKu8F2J6tEYekyI=
X-Received: by 2002:a25:37c8:: with SMTP id e191mr20859632yba.230.1596419207784;
 Sun, 02 Aug 2020 18:46:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200801084721.1812607-1-songliubraving@fb.com> <20200801084721.1812607-5-songliubraving@fb.com>
In-Reply-To: <20200801084721.1812607-5-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 2 Aug 2020 18:46:37 -0700
Message-ID: <CAEf4BzY44oYFXRPeG1y3W96xrCR2muGpeKJ7XHQ-3EpaZ__Veg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/5] selftests/bpf: move two functions to test_progs.c
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
> Move time_get_ns() and get_base_addr() to test_progs.c, so they can be
> used in other tests.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  .../selftests/bpf/prog_tests/attach_probe.c   | 21 -------------
>  .../selftests/bpf/prog_tests/test_overhead.c  |  8 -----
>  tools/testing/selftests/bpf/test_progs.c      | 30 +++++++++++++++++++
>  tools/testing/selftests/bpf/test_progs.h      |  2 ++
>  4 files changed, 32 insertions(+), 29 deletions(-)
>

[...]

>  static int test_task_rename(const char *prog)
>  {
>         int i, fd, duration = 0, err;
> diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> index b1e4dadacd9b4..c9e6a5ad5b9a4 100644
> --- a/tools/testing/selftests/bpf/test_progs.c
> +++ b/tools/testing/selftests/bpf/test_progs.c
> @@ -622,6 +622,36 @@ int cd_flavor_subdir(const char *exec_name)
>         return chdir(flavor);
>  }
>
> +__u64 time_get_ns(void)
> +{

I'd try to avoid adding stuff to test_progs.c. There is generic
testing_helpers.c, maybe let's put this there?

> +       struct timespec ts;
> +
> +       clock_gettime(CLOCK_MONOTONIC, &ts);
> +       return ts.tv_sec * 1000000000ull + ts.tv_nsec;
> +}
> +
> +ssize_t get_base_addr(void)
> +{

This would definitely be better in trace_helpers.c, though.

> +       size_t start, offset;
> +       char buf[256];
> +       FILE *f;
> +

[...]
