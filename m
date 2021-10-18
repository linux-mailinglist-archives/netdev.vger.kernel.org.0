Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C928A432905
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhJRV0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhJRV0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 17:26:39 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80FBC06161C;
        Mon, 18 Oct 2021 14:24:27 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id s64so2424702yba.11;
        Mon, 18 Oct 2021 14:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rEZK6LzGD7yppVedlOxHHvb78FXR8pGlJOsrpFJW4Ck=;
        b=mgoq/cuYiOeawQ94F8qLvb+HUQOD1E4gGGFekh6R7p/YHMBP8HsWZckTFRGrIqQY9u
         MI0esSHwoCIC5MN6wISEWooEjC/+Jwqf2h3+Ce4qlXUYzGOBDoLEKf3bts2+k8A0xp8x
         /t3G5EgJYeU/X45VPBiKwlBPuDPxBz7WakrcTYYkqwW5juKrTNyZpU/+MkHUq+BKiyFb
         0nSBLgi503ty5remossaCF3t5qfP+DqvVV4EpVxFvw1hp0KHmIAsRTdc2Aw8+XzeLuU1
         W6fZi6iADnqCtFGOVqk+PAlsjiB1w5BcyFxomeEfqO1txwcbPAqChJUXdk0FNAubK3sK
         XeGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rEZK6LzGD7yppVedlOxHHvb78FXR8pGlJOsrpFJW4Ck=;
        b=2CICSPZEQ51UzH4ke+IlTpjSAK9WfqwEpZnfb4Bw+PTfQiVBBBwEdaeTqNFrNHfVUJ
         BECq+jdKWjlMJ6oAHcBwL+t3GyoQEutHlCdY+XvPmYGf2aoAt1m9Ye8tgM5Gf6WYoINz
         jgHFSTcDdCKw7dqNvma3+zIx3fugHtyT1z3W/4imvI8QIrXODbTfFNL/xc8I+YE1UCSm
         iuZoPWVoU8RpMfiD2utsbuoGrKZixL7f9Gs0Kslbm+0GS2c7h0Lpn0IOtU2pTrUEY6VU
         GJ5g/iq8bI5GRoUXYgFsS1VwWnuHwrF0VXiaHxyNTboTgV78Za8cJifrMc6zQowG2rz1
         yNlA==
X-Gm-Message-State: AOAM5321EfOXCGOzEyy6UIewRllQBOPCxai8X8xNA2KKCF6oDahjkPN3
        MC1djh9YxLwhqVdwnRbkz4tIbP0pqkVDUktTiiw=
X-Google-Smtp-Source: ABdhPJwmolShJ2CA1S3IEYNHW8Bba1EH1HactYgdPCapWKyjiFTKPHutHdgjPM+EBE7To/vjgWxUhsi8ILxH9Nt8akc=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr32198670ybj.504.1634592266820;
 Mon, 18 Oct 2021 14:24:26 -0700 (PDT)
MIME-Version: 1.0
References: <20211011205415.234479-1-davemarchevsky@fb.com> <20211011205415.234479-3-davemarchevsky@fb.com>
In-Reply-To: <20211011205415.234479-3-davemarchevsky@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 Oct 2021 14:24:16 -0700
Message-ID: <CAEf4BzZoiK1kijm_M233sL3dVu6KQLDS86RwUB4P8w+FgZapxg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/2] selftests/bpf: add verif_stats test
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 1:54 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> verified_insns field was added to response of bpf_obj_get_info_by_fd
> call on a prog. Confirm that it's being populated by loading a simple
> program and asking for its info.
>
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> ---

one nit below

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  .../selftests/bpf/prog_tests/verif_stats.c    | 31 +++++++++++++++++++
>  1 file changed, 31 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/verif_stats.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/verif_stats.c b/tools/testing/selftests/bpf/prog_tests/verif_stats.c
> new file mode 100644
> index 000000000000..42843db519e5
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/verif_stats.c
> @@ -0,0 +1,31 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +
> +#include <test_progs.h>
> +
> +#include "trace_vprintk.lskel.h"
> +
> +void test_verif_stats(void)
> +{
> +       __u32 len = sizeof(struct bpf_prog_info);
> +       struct bpf_prog_info info = {};
> +       struct trace_vprintk *skel;
> +       int err;
> +
> +       skel = trace_vprintk__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "trace_vprintk__open_and_load"))
> +               goto cleanup;
> +
> +       if (!ASSERT_GT(skel->progs.sys_enter.prog_fd, 0, "sys_enter_fd > 0"))
> +               goto cleanup;

This can't fail if open_and_load succeeded. If it does happen due to
some bug, then bpf_obj_get_info_by_fd() below will fail.

> +
> +       err = bpf_obj_get_info_by_fd(skel->progs.sys_enter.prog_fd, &info, &len);
> +       if (!ASSERT_OK(err, "bpf_obj_get_info_by_fd"))
> +               goto cleanup;
> +
> +       if (!ASSERT_GT((__u32)info.verified_insns, 0, "verified_insns"))
> +               goto cleanup;
> +
> +cleanup:
> +       trace_vprintk__destroy(skel);
> +}
> --
> 2.30.2
>
