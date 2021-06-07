Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23CC639E903
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 23:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbhFGVVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 17:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhFGVVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 17:21:14 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B3AC061574;
        Mon,  7 Jun 2021 14:19:22 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id b11so22101441edy.4;
        Mon, 07 Jun 2021 14:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JAMZcwgcxUhGZWX1pdhnPjQm6GMAQ7kguPdII+CC32s=;
        b=NtTR2H5QjmJl1yABqp3f0BAzt5VdJ7RNX8ViOmrYAUEs8JhnJGi6WJSzCLYhndYDbq
         8LNnw2LYKXpNh13mZtDZzZUTRDAeFOYr86t6+7QUAZda0Eal4wHMNuXKXbhWEopox0jn
         lPCg/Yk4Fh3sHdpp9Zo1fZI8RZOyTmyyio3BtTcSA0inm5BKDWSZ8WLBMcDJe8lJB2GZ
         5BhmGJRITsCVEhtKC0oMIotoZ9n5O+2uY2Lr1v0OUWz9QD7XyMGIoZVuDL5GdDzCdn0m
         uo+siMD49XZo1FHNpUHRBB6n5dcICNMgGGSYatm2MYFIyWRHOo295J4Ybnw0EdQkGEKk
         TkBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JAMZcwgcxUhGZWX1pdhnPjQm6GMAQ7kguPdII+CC32s=;
        b=coemqlUmiFOEd3sw7ZzQGlOv4uFGjlU3wx3HnOZVg7gBVG16oSaHs1tBloZ7o94xhe
         d94JlEz9QCzWoVChMI9uV4riBxdz5X6wYC61EuEvhWKv+JzmsFdvhDF8HRAI+zazTBXW
         2myBIktZ5F39Ka8Mm8zbOLrJ5WbJSnqlCYBvMDHerO2NI9MONqLvy4uxaH/2lR+W/ZWW
         u26t7RB3I99mwwAuuF5xmQVK3wRIJvCtVwX3xX4mve5vBjof4HVZxSHa9dUy2JvZ/RP4
         u8Y2eIU4hnZSqmGVtpeNbYD92Y96y+XDyR5tKo1/73JGs6U1Q7qsBTdasjA63Jx6vLGD
         E57w==
X-Gm-Message-State: AOAM530IPFnm4d/NaJPQgeddPW611pEIqPiNwid96rV8o0epGvU+d4eu
        7oGOh7z9o58ck0XJuJTiuVIPE81x7a6uHoTlkOA=
X-Google-Smtp-Source: ABdhPJzj/VisJ5mYCQyHvb1bUFpD/0dF1i4RY00A2FlNHqGbqUyWW/8fpy8yF7wbFOvFl3puJ7m6rsuO6MQIuDFImjI=
X-Received: by 2002:aa7:ca1a:: with SMTP id y26mr21834084eds.314.1623100760763;
 Mon, 07 Jun 2021 14:19:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210607031537.12366-1-thunder.leizhen@huawei.com>
In-Reply-To: <20210607031537.12366-1-thunder.leizhen@huawei.com>
From:   Andrey Konovalov <andreyknvl@gmail.com>
Date:   Tue, 8 Jun 2021 00:19:02 +0300
Message-ID: <CA+fCnZcR5VfhfM-z3rjj3nKHny=upnPLxh_OBu5JqaGSAqZQiQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] lib/test: Fix spelling mistakes
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 7, 2021 at 6:18 AM Zhen Lei <thunder.leizhen@huawei.com> wrote:
>
> Fix some spelling mistakes in comments:
> thats ==> that's
> unitialized ==> uninitialized
> panicing ==> panicking
> sucess ==> success
> possitive ==> positive
> intepreted ==> interpreted
>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  lib/test_bitops.c | 2 +-
>  lib/test_bpf.c    | 2 +-
>  lib/test_kasan.c  | 2 +-
>  lib/test_kmod.c   | 6 +++---
>  lib/test_scanf.c  | 2 +-
>  5 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/lib/test_bitops.c b/lib/test_bitops.c
> index 471141ddd691..3b7bcbee84db 100644
> --- a/lib/test_bitops.c
> +++ b/lib/test_bitops.c
> @@ -15,7 +15,7 @@
>   *   get_count_order/long
>   */
>
> -/* use an enum because thats the most common BITMAP usage */
> +/* use an enum because that's the most common BITMAP usage */
>  enum bitops_fun {
>         BITOPS_4 = 4,
>         BITOPS_7 = 7,
> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
> index 4dc4dcbecd12..d500320778c7 100644
> --- a/lib/test_bpf.c
> +++ b/lib/test_bpf.c
> @@ -1095,7 +1095,7 @@ static struct bpf_test tests[] = {
>         {
>                 "RET_A",
>                 .u.insns = {
> -                       /* check that unitialized X and A contain zeros */
> +                       /* check that uninitialized X and A contain zeros */
>                         BPF_STMT(BPF_MISC | BPF_TXA, 0),
>                         BPF_STMT(BPF_RET | BPF_A, 0)
>                 },
> diff --git a/lib/test_kasan.c b/lib/test_kasan.c
> index cacbbbdef768..72b8e808c39c 100644
> --- a/lib/test_kasan.c
> +++ b/lib/test_kasan.c
> @@ -656,7 +656,7 @@ static void kasan_global_oob(struct kunit *test)
>  {
>         /*
>          * Deliberate out-of-bounds access. To prevent CONFIG_UBSAN_LOCAL_BOUNDS
> -        * from failing here and panicing the kernel, access the array via a
> +        * from failing here and panicking the kernel, access the array via a
>          * volatile pointer, which will prevent the compiler from being able to
>          * determine the array bounds.
>          *
> diff --git a/lib/test_kmod.c b/lib/test_kmod.c
> index 38c250fbace3..ce1589391413 100644
> --- a/lib/test_kmod.c
> +++ b/lib/test_kmod.c
> @@ -286,7 +286,7 @@ static int tally_work_test(struct kmod_test_device_info *info)
>   * If this ran it means *all* tasks were created fine and we
>   * are now just collecting results.
>   *
> - * Only propagate errors, do not override with a subsequent sucess case.
> + * Only propagate errors, do not override with a subsequent success case.
>   */
>  static void tally_up_work(struct kmod_test_device *test_dev)
>  {
> @@ -543,7 +543,7 @@ static int trigger_config_run(struct kmod_test_device *test_dev)
>          * wrong with the setup of the test. If the test setup went fine
>          * then userspace must just check the result of config->test_result.
>          * One issue with relying on the return from a call in the kernel
> -        * is if the kernel returns a possitive value using this trigger
> +        * is if the kernel returns a positive value using this trigger
>          * will not return the value to userspace, it would be lost.
>          *
>          * By not relying on capturing the return value of tests we are using
> @@ -585,7 +585,7 @@ trigger_config_store(struct device *dev,
>          * Note: any return > 0 will be treated as success
>          * and the error value will not be available to userspace.
>          * Do not rely on trying to send to userspace a test value
> -        * return value as possitive return errors will be lost.
> +        * return value as positive return errors will be lost.
>          */
>         if (WARN_ON(ret > 0))
>                 return -EINVAL;
> diff --git a/lib/test_scanf.c b/lib/test_scanf.c
> index 48ff5747a4da..84fe09eaf55e 100644
> --- a/lib/test_scanf.c
> +++ b/lib/test_scanf.c
> @@ -600,7 +600,7 @@ static void __init numbers_prefix_overflow(void)
>         /*
>          * 0x prefix in a field of width 2 using %i conversion: first field
>          * converts to 0. Next field scan starts at the character after "0x",
> -        * which will convert if can be intepreted as decimal but will fail
> +        * which will convert if can be interpreted as decimal but will fail
>          * if it contains any hex digits (since no 0x prefix).
>          */
>         test_number_prefix(long long,   "0x67", "%2lli%lli", 0, 67, 2, check_ll);
> --
> 2.25.1

For lib/test_kasan.c:

Acked-by: Andrey Konovalov <andreyknvl@gmail.com>
