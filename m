Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB6A23C61C
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 08:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgHEGkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 02:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726459AbgHEGkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 02:40:17 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBAAC06174A;
        Tue,  4 Aug 2020 23:40:17 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id c18so15837393ybr.1;
        Tue, 04 Aug 2020 23:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=90J3WmEeP2r8voHUBIy+vmtw35a76blrgUC+SrC7Fl8=;
        b=inYPdWvLeojRKTJP9OvTBseHY0XrusSBDhEKHzV9PYwYgP0kMHuDByZhsbX43/wbD1
         ZnbSM5TonEtjCmGzrysIdBkClD6B+WH98uZj85BslNq3SgjDAkhdq6jTks7YZXLUbQsV
         OMqnvk5ZHO3Gg7MtG5c/DvoTfatk49WJkmaae7HH341kZWpVdmjSI28BiRDnCECAXhqP
         mgWmTdZWEskWzrjhLSqjZ3HRJeJuDAxZnpwZP0GMAZrEw06SnCRdUHtqsBbdCvI2TdcJ
         jq4orXp2SCc5gxubb3UZ//PeoOUYI3SEgO375nB5689RxMMQNr0e4Vb0TZEWmzZ6+2s5
         VuCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=90J3WmEeP2r8voHUBIy+vmtw35a76blrgUC+SrC7Fl8=;
        b=Vy8n62CSo0c7QUIjEeFVbLwNs0vmOvGd4PbrwTHIeKstWUUnww+Tp74i8YjW5qq82v
         xTlBcWkz8sLTeX3/zwL+UmRvoXA+Bhy5pDtV4yh+OyhUH9syAMX5HY/e1V+mU880q1YI
         lGW3qNX7WB2imX42qRRVIqUKOyCA4RoE0Zr+6rRWX0+e5fviZV46ZK0VxMpWrfNhsBti
         408fi6YauFKNjXVyhluwkfNUegBRYrsCYZ0jXU4AJMvGHxYMoCjtnwlEXAYiTADb7kxR
         PPK+u0J2om9z44XWAmWGliVIjfDoH4WDM3TPdpwOP9zF6E1Eb/XWCYEFgnBH3WHJR4p5
         w8yQ==
X-Gm-Message-State: AOAM530sx7daIMMe3OBQCN/wN4VbcMFpUOrP7dnZX2cE0oAPf06A32kG
        pKE2oVuen6CnDX8I7hSguv05+B1FPrTlYGTsWXg=
X-Google-Smtp-Source: ABdhPJxZG1PKFpyYRFI/KWtLgbmiZCekhBuOtBUONIaZ5QPCSUBDkNIa/bprApLv9D2XQdppmu3lw4A3KoWmYF2s29s=
X-Received: by 2002:a25:ba0f:: with SMTP id t15mr2591275ybg.459.1596609616516;
 Tue, 04 Aug 2020 23:40:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200801170322.75218-1-jolsa@kernel.org> <20200801170322.75218-14-jolsa@kernel.org>
In-Reply-To: <20200801170322.75218-14-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Aug 2020 23:40:05 -0700
Message-ID: <CAEf4BzYq5jhTPZRiRzDmi_92qg+0vwobmkyLEqB50mrG_39BeQ@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 13/14] selftests/bpf: Add test for d_path helper
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 1, 2020 at 10:05 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding test for d_path helper which is pretty much
> copied from Wenbo Zhang's test for bpf_get_fd_path,
> which never made it in.
>
> The test is doing fstat/close on several fd types,
> and verifies we got the d_path helper working on
> kernel probes for vfs_getattr/filp_close functions.
>
> Original-patch-by: Wenbo Zhang <ethercflow@gmail.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Nothing wrong with this BPF implementation, but seem one suggestion below.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../testing/selftests/bpf/prog_tests/d_path.c | 147 ++++++++++++++++++
>  .../testing/selftests/bpf/progs/test_d_path.c |  64 ++++++++
>  2 files changed, 211 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/d_path.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_d_path.c
>

[...]

> diff --git a/tools/testing/selftests/bpf/progs/test_d_path.c b/tools/testing/selftests/bpf/progs/test_d_path.c
> new file mode 100644
> index 000000000000..9d342d7a1de6
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_d_path.c
> @@ -0,0 +1,64 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +#define MAX_PATH_LEN           128
> +#define MAX_FILES              7
> +
> +pid_t my_pid = 0;
> +__u32 cnt_stat = 0;
> +__u32 cnt_close = 0;
> +char paths_stat[MAX_FILES][MAX_PATH_LEN] = {};
> +char paths_close[MAX_FILES][MAX_PATH_LEN] = {};
> +int rets_stat[MAX_FILES] = {};
> +int rets_close[MAX_FILES] = {};
> +
> +SEC("fentry/vfs_getattr")
> +int BPF_PROG(prog_stat, struct path *path, struct kstat *stat,
> +            __u32 request_mask, unsigned int query_flags)
> +{
> +       pid_t pid = bpf_get_current_pid_tgid() >> 32;
> +       int ret;
> +
> +       if (pid != my_pid)
> +               return 0;
> +
> +       if (cnt_stat >= MAX_FILES)
> +               return 0;
> +       ret = bpf_d_path(path, paths_stat[cnt_stat], MAX_PATH_LEN);
> +
> +       /* We need to recheck cnt_stat for verifier. */
> +       if (cnt_stat >= MAX_FILES)
> +               return 0;
> +       rets_stat[cnt_stat] = ret;
> +
> +       cnt_stat++;
> +       return 0;
> +}
> +
> +SEC("fentry/filp_close")
> +int BPF_PROG(prog_close, struct file *file, void *id)
> +{
> +       pid_t pid = bpf_get_current_pid_tgid() >> 32;
> +       int ret;
> +
> +       if (pid != my_pid)
> +               return 0;
> +
> +       if (cnt_close >= MAX_FILES)
> +               return 0;
> +       ret = bpf_d_path(&file->f_path,
> +                        paths_close[cnt_close], MAX_PATH_LEN);
> +
> +       /* We need to recheck cnt_stat for verifier. */

you need to do it because you are re-reading a global variable; if you
stored cnt_close in a local variable, then did >= MAX_FILES check
once, you probably could have avoided this duplication. Same for
another instance above.

> +       if (cnt_close >= MAX_FILES)
> +               return 0;
> +       rets_close[cnt_close] = ret;
> +
> +       cnt_close++;
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> --
> 2.25.4
>
