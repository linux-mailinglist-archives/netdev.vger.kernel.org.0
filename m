Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078F7276113
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 21:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgIWTcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 15:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgIWTcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 15:32:02 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27334C0613CE;
        Wed, 23 Sep 2020 12:32:02 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id j76so594218ybg.3;
        Wed, 23 Sep 2020 12:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qvrywX009Zrhg1Nr4phrUNsg3bVBoco0YGtGDLFAUo4=;
        b=ocqyLFjwQ9gjIu4tHIJF/JaXdG10fiOuvbbS4aKFESpHiEBE3K/qHV3bzw1D181jVb
         NCpfDlIB/wKUoT9rV3pb8xXkEYcYK3jP13sWnMtk/9qJxEqjSJF8cAK5IxYdv/uBaeTm
         aog/iekGqfTLoLub50nIA/SVdfVfNec497IhN8FXeAhG0X0vAoy8l1LdzzJWMRaI4Jb9
         93b6QEGHgvVYFOaCeRqXwLMGt+g0JYdgDdqs55nl1VQ2hrZTVXajBlFH+3NcbpwkvSro
         w58stcA2UxcnUNuMedmOVn59Pr88AuKONpFSFma8P0oQ+AlE64stbm0BotcdpMlsgX40
         rEHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qvrywX009Zrhg1Nr4phrUNsg3bVBoco0YGtGDLFAUo4=;
        b=oESKNYqC0wxnWk8RBcMP6pGIAIi91gWV7WnfrnJ6UwkKF1s+yUK9CH2jU6R+DoKeLB
         dM2Uo72GXmndo2kXTdZ1atEBZ2hHToyi5VEmUvRHWlBMlMZw9ciusFnJ2myWNLyxgvK5
         Xdb+bqSQlYaEPnDaNyzdTzS0/8NZzdrbo+JM49NPClLzSAOnaRQbBcCjrjTIeVaEIGN5
         MrGNfHXf5uXvlIjw4nWUxGsbMMGVQVVSiu8LXe5Krk50Y918uSybgewK8dqM6EAa1R8R
         xDvRoQjfGtXokModMzBTZkKkbVk7vOpbZFIFogfxG41Yf/88EgBuRlfD0yd4Jtd9toCb
         PeHg==
X-Gm-Message-State: AOAM530LTYNBDzMDK1xPuS9gzNY2ZZbl5e3C3/1Xy9BKDq/iSrCojkfC
        uN+RID836sZ6MiK1l8goAg4kb/mAJr6UKO6un60=
X-Google-Smtp-Source: ABdhPJzc0VjcP8e6RN+G5m7UdQqry9I0fkF/9hWxwPfI4KONW1Nef3hZegJLMQeVqDtPNedZFu7NBwy4CNQ5b5S4CIU=
X-Received: by 2002:a25:33c4:: with SMTP id z187mr2193926ybz.27.1600889521377;
 Wed, 23 Sep 2020 12:32:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200923165401.2284447-1-songliubraving@fb.com> <20200923165401.2284447-3-songliubraving@fb.com>
In-Reply-To: <20200923165401.2284447-3-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 23 Sep 2020 12:31:50 -0700
Message-ID: <CAEf4BzZ-qPNjDEvviJKHfLD7t7YJ97PdGixGQ_f70AJEg5oVEg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/3] libbpf: introduce bpf_prog_test_run_xattr_opts
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

On Wed, Sep 23, 2020 at 9:55 AM Song Liu <songliubraving@fb.com> wrote:
>
> This API supports new field cpu_plus in bpf_attr.test.
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  tools/lib/bpf/bpf.c      | 13 ++++++++++++-
>  tools/lib/bpf/bpf.h      | 11 +++++++++++
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 24 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 2baa1308737c8..3228dd60fa32f 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -684,7 +684,8 @@ int bpf_prog_test_run(int prog_fd, int repeat, void *data, __u32 size,
>         return ret;
>  }
>
> -int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr)
> +int bpf_prog_test_run_xattr_opts(struct bpf_prog_test_run_attr *test_attr,
> +                                const struct bpf_prog_test_run_opts *opts)

opts are replacement for test_attr, not an addition to it. We chose to
use _xattr suffix for low-level APIs previously, but it's already
"taken". So I'd suggest to go with just  bpf_prog_test_run_ops and
have prog_fd as a first argument and then put all the rest of
test_run_attr into opts.

BTW, it's also probably overdue to have a higher-level
bpf_program__test_run(), which can re-use the same
bpf_prog_test_run_opts options struct. It would be more convenient to
use it with libbpf bpf_object/bpf_program APIs.

>  {
>         union bpf_attr attr;
>         int ret;
> @@ -693,6 +694,11 @@ int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr)
>                 return -EINVAL;
>
>         memset(&attr, 0, sizeof(attr));
> +       if (opts) {

you don't need to check opts for being not NULL, OPTS_VALID handle that already.

> +               if (!OPTS_VALID(opts, bpf_prog_test_run_opts))
> +                       return -EINVAL;
> +               attr.test.cpu_plus = opts->cpu_plus;

And here you should use OPTS_GET(), please see other examples in
libbpf for proper usage.


> +       }
>         attr.test.prog_fd = test_attr->prog_fd;
>         attr.test.data_in = ptr_to_u64(test_attr->data_in);
>         attr.test.data_out = ptr_to_u64(test_attr->data_out);
> @@ -712,6 +718,11 @@ int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr)
>         return ret;
>  }
>

[...]
