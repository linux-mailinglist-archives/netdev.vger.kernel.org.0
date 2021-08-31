Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620A33FBFD7
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 02:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239197AbhHaAEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 20:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233270AbhHaAEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 20:04:14 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CE4C061575;
        Mon, 30 Aug 2021 17:03:19 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id k78so28323188ybf.10;
        Mon, 30 Aug 2021 17:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lglQ3JxOUp4IZye4xSji78qLqmdUdPj3wxm8G2VOvkE=;
        b=UiqKSheXumgrI5tnQNS+k+ty5ojnYBNKjOYwOsOf7ND4TQwx4l/JKiafYvKIp4/0iw
         tRt8AC1de7wX+oRi5feG2cXXnCKl92tWRUYdHiEMIdvCIGsm2E/DdXNNAEl8RIzAuPN+
         eLtuGOxsJHA4UOi3OH4+Fggxeb6AXQYU9Z4KnIvXInqOQiOnraBu6zGQx1rHUsEkB0ph
         8DFT4SMC4J4N/bWVCGLpWdYJcfbqyZBiDnj9q7ZHCUWRbLHecXJeb9096ZeaL4aJp2jo
         5he+x7k0XqWMfZi8MQWx94zxcrarci+MtbhBgaIboT5a7ecIG4YAvcNCdAFox/7t1Sp2
         Rb/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lglQ3JxOUp4IZye4xSji78qLqmdUdPj3wxm8G2VOvkE=;
        b=nxX5As65UezaI95sMAhpPszS33bwcVuCesce08DAXdU4RtbzNRVwi3EgHsdhyZpnTZ
         A6qXq7nFVkxx5uMYsbV2vHgD5lXRXYi5Ht7QRLaxO27yih/XKugy5yVd1N8Iuwnoa20w
         4QxaxPI59Srs9vQwFlxe27HyQgYxJRgCY8vXcnk7qQW2Upssrmk5j77AW7uH243na6sp
         PlP8maQVg+BlsW+a0wMnaQONz7shwUaqbt/Y4NVYSbWIgkxzAElIwjq7OSREmnJAkotH
         WqtohdfSIQtgVVixxjBEdLqxgqYTFd2kh2EIdsvfTBirwwRrgI70kRV+AqlzJuSu6S5V
         vRBw==
X-Gm-Message-State: AOAM530IcvPC1vW05UouapsALN2wGu/WK1D+9F1Ui102p/0e+FdkL4Tx
        GYq07v4wkdIEK2Fys/kI4OZs2HVKT9YcGVtSbLMXjmG48AQ=
X-Google-Smtp-Source: ABdhPJznp92dCOB3vB2YFaUTt0/v/C6oe41rbnqR1SwbcKI3n4IfOnGeaFH6wmd674khXQPd4iw7F8oT3i9W1CSYtmA=
X-Received: by 2002:a25:bb13:: with SMTP id z19mr28067365ybg.347.1630368199063;
 Mon, 30 Aug 2021 17:03:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210828052006.1313788-1-davemarchevsky@fb.com> <20210828052006.1313788-7-davemarchevsky@fb.com>
In-Reply-To: <20210828052006.1313788-7-davemarchevsky@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Aug 2021 17:03:08 -0700
Message-ID: <CAEf4BzbNh-dXYjkxKPq576w3YeqpKfufWToPAR_bq8+hnbzOzA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 6/7] selftests/bpf: Migrate
 prog_tests/trace_printk CHECKs to ASSERTs
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 10:20 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> Guidance for new tests is to use ASSERT macros instead of CHECK. Since
> trace_vprintk test will borrow heavily from trace_printk's, migrate its
> CHECKs so it remains obvious that the two are closely related.
>
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> ---

Great, thanks!

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  .../selftests/bpf/prog_tests/trace_printk.c   | 24 +++++++------------
>  1 file changed, 9 insertions(+), 15 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/trace_printk.c b/tools/testing/selftests/bpf/prog_tests/trace_printk.c
> index d39bc00feb45..e47835f0a674 100644
> --- a/tools/testing/selftests/bpf/prog_tests/trace_printk.c
> +++ b/tools/testing/selftests/bpf/prog_tests/trace_printk.c
> @@ -10,7 +10,7 @@
>
>  void test_trace_printk(void)
>  {
> -       int err, iter = 0, duration = 0, found = 0;
> +       int err = 0, iter = 0, found = 0;
>         struct trace_printk__bss *bss;
>         struct trace_printk *skel;
>         char *buf = NULL;
> @@ -18,25 +18,24 @@ void test_trace_printk(void)
>         size_t buflen;
>
>         skel = trace_printk__open();
> -       if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> +       if (!ASSERT_OK_PTR(skel, "trace_printk__open"))
>                 return;
>
> -       ASSERT_EQ(skel->rodata->fmt[0], 'T', "invalid printk fmt string");
> +       ASSERT_EQ(skel->rodata->fmt[0], 'T', "skel->rodata->fmt[0]");
>         skel->rodata->fmt[0] = 't';
>
>         err = trace_printk__load(skel);
> -       if (CHECK(err, "skel_load", "failed to load skeleton: %d\n", err))
> +       if (!ASSERT_OK(err, "trace_printk__load"))
>                 goto cleanup;
>
>         bss = skel->bss;
>
>         err = trace_printk__attach(skel);
> -       if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
> +       if (!ASSERT_OK(err, "trace_printk__attach"))
>                 goto cleanup;
>
>         fp = fopen(TRACEBUF, "r");
> -       if (CHECK(fp == NULL, "could not open trace buffer",
> -                 "error %d opening %s", errno, TRACEBUF))
> +       if (!ASSERT_OK_PTR(fp, "fopen(TRACEBUF)"))
>                 goto cleanup;
>
>         /* We do not want to wait forever if this test fails... */
> @@ -46,14 +45,10 @@ void test_trace_printk(void)
>         usleep(1);
>         trace_printk__detach(skel);
>
> -       if (CHECK(bss->trace_printk_ran == 0,
> -                 "bpf_trace_printk never ran",
> -                 "ran == %d", bss->trace_printk_ran))
> +       if (!ASSERT_GT(bss->trace_printk_ran, 0, "bss->trace_printk_ran"))
>                 goto cleanup;
>
> -       if (CHECK(bss->trace_printk_ret <= 0,
> -                 "bpf_trace_printk returned <= 0 value",
> -                 "got %d", bss->trace_printk_ret))
> +       if (!ASSERT_GT(bss->trace_printk_ret, 0, "bss->trace_printk_ret"))
>                 goto cleanup;
>
>         /* verify our search string is in the trace buffer */
> @@ -66,8 +61,7 @@ void test_trace_printk(void)
>                         break;
>         }
>
> -       if (CHECK(!found, "message from bpf_trace_printk not found",
> -                 "no instance of %s in %s", SEARCHMSG, TRACEBUF))
> +       if (!ASSERT_EQ(found, bss->trace_printk_ran, "found"))
>                 goto cleanup;
>
>  cleanup:
> --
> 2.30.2
>
