Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB5550926A
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 23:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382706AbiDTV7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 17:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236516AbiDTV7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 17:59:53 -0400
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFBC3BBC2;
        Wed, 20 Apr 2022 14:57:05 -0700 (PDT)
Received: by mail-vk1-xa2b.google.com with SMTP id o132so1438804vko.11;
        Wed, 20 Apr 2022 14:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XV35Uhu02nhpc/+S29bQrcl9X0sx9xBTyC1cMcdAS0s=;
        b=LEBmYdStR/8Bi3o9F1wTA7JXqWfejnTtHV7VFQdsVGTF7bYv9Dt3LOfHyoKU64TyfO
         d/aXaMmspy4+NEm7Aa8Ctz6WE8EmC5fe3H7vRBBP2jA75fAHZGPTP8eedjfUyAtEI7Kd
         oQZx+4vlwIP/Nt8ePNk4+y/3b3UsUh0h7HFEgIzEgiv9fzQQbJILWZavjiatsHL62CBy
         YovP3WmFBekWBd47GvLm5zJOMB1BooXf3UqLtFV9WjA87wRuP6OqmfBudJXbzENLRoPQ
         Huu8H2FvoRrffbOHbhB8fl8KdqSkvV9rAYOc6U4R7wg1XKZJH8PvXVbo3e2bl3SZojiC
         8MkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XV35Uhu02nhpc/+S29bQrcl9X0sx9xBTyC1cMcdAS0s=;
        b=eG4iOQwLJ/ax3EedKZYQDF1YonLzCTXO9ToMd4c3V2GuNL1OU6mvIX6gWeSJbael9t
         xWR760TSSqLmnrC+D9Zp6/B3zKNGY7LCJtRgHCmS8IksT4wlLfDqXunvkENxRLvhD3Gj
         1I382DBvIdYh9Q8+AXMEez71KBOcBIYorEU1OftBVCBBa4NAAjn3tIvmVmrYrNIJp6db
         ZcDTGClpHzh+4wogIos/RoNuDQn492HDbkrK503r6Xq8Xvl2CsHjXKlUIldwx9S9BSuB
         ricMfsa/b/Mvm7UPsn+Z4aEFy+addko+g6Rj/BReh9tOpPaVF1EZuLrXWZSH8h9gv0Ta
         NASg==
X-Gm-Message-State: AOAM533yZHRE5h7RoWdbn7rpcioqDXAVazsYUU/6nl6lWDQT6aPdn3o9
        unC4xP231mSNwx22uiynHcs5WAJrO4tCCOE5FaM=
X-Google-Smtp-Source: ABdhPJyQrA5iKhRxkhWVa13LFirIDjHKiG+P5vHxgIV322/EvSZCLYGcooTZswfDe58+Pp+eCyxbrpi2LGbJ0Jq6JCA=
X-Received: by 2002:ac5:cd88:0:b0:32c:5497:6995 with SMTP id
 i8-20020ac5cd88000000b0032c54976995mr6630525vka.33.1650491824683; Wed, 20 Apr
 2022 14:57:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220418124834.829064-1-jolsa@kernel.org> <20220418124834.829064-5-jolsa@kernel.org>
In-Reply-To: <20220418124834.829064-5-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Apr 2022 14:56:53 -0700
Message-ID: <CAEf4BzYuvLgVtxbtz7pjCmtSp0hEKJd0peCnbX0E_-Tqy5g4dw@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 4/4] selftests/bpf: Add attach bench test
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 18, 2022 at 5:49 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding test that reads all functions from ftrace available_filter_functions
> file and attach them all through kprobe_multi API.
>
> It also prints stats info with -v option, like on my setup:
>
>   test_bench_attach: found 48712 functions
>   test_bench_attach: attached in   1.069s
>   test_bench_attach: detached in   0.373s
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../bpf/prog_tests/kprobe_multi_test.c        | 136 ++++++++++++++++++
>  .../selftests/bpf/progs/kprobe_multi_empty.c  |  12 ++
>  2 files changed, 148 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi_empty.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> index b9876b55fc0c..05f0fab8af89 100644
> --- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> +++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> @@ -2,6 +2,9 @@
>  #include <test_progs.h>
>  #include "kprobe_multi.skel.h"
>  #include "trace_helpers.h"
> +#include "kprobe_multi_empty.skel.h"
> +#include "bpf/libbpf_internal.h"
> +#include "bpf/hashmap.h"
>
>  static void kprobe_multi_test_run(struct kprobe_multi *skel, bool test_return)
>  {
> @@ -301,6 +304,137 @@ static void test_attach_api_fails(void)
>         kprobe_multi__destroy(skel);
>  }
>
> +static inline __u64 get_time_ns(void)
> +{
> +       struct timespec t;
> +
> +       clock_gettime(CLOCK_MONOTONIC, &t);
> +       return (__u64) t.tv_sec * 1000000000 + t.tv_nsec;
> +}
> +
> +static size_t symbol_hash(const void *key, void *ctx __maybe_unused)
> +{
> +       return str_hash((const char *) key);
> +}
> +
> +static bool symbol_equal(const void *key1, const void *key2, void *ctx __maybe_unused)
> +{
> +       return strcmp((const char *) key1, (const char *) key2) == 0;
> +}
> +
> +#define DEBUGFS "/sys/kernel/debug/tracing/"
> +
> +static int get_syms(char ***symsp, size_t *cntp)
> +{
> +       size_t cap = 0, cnt = 0, i;
> +       char *name, **syms = NULL;
> +       struct hashmap *map;
> +       char buf[256];
> +       FILE *f;
> +       int err;
> +
> +       /*
> +        * The available_filter_functions contains many duplicates,
> +        * but other than that all symbols are usable in kprobe multi
> +        * interface.
> +        * Filtering out duplicates by using hashmap__add, which won't
> +        * add existing entry.
> +        */
> +       f = fopen(DEBUGFS "available_filter_functions", "r");

nit: DEBUGFS "constant" just makes it harder to follow the code and
doesn't add anything, please just use the full path here directly

> +       if (!f)
> +               return -EINVAL;
> +
> +       map = hashmap__new(symbol_hash, symbol_equal, NULL);
> +       err = libbpf_get_error(map);

hashmap__new() is an internal API, so please use IS_ERR() directly
here. libbpf_get_error() should be used for public libbpf APIs, and
preferably not in libbpf 1.0 mode

> +       if (err)
> +               goto error;
> +
> +       while (fgets(buf, sizeof(buf), f)) {
> +               /* skip modules */
> +               if (strchr(buf, '['))
> +                       continue;

[...]

> +       attach_delta = (attach_end_ns - attach_start_ns) / 1000000000.0;
> +       detach_delta = (detach_end_ns - detach_start_ns) / 1000000000.0;
> +
> +       fprintf(stderr, "%s: found %lu functions\n", __func__, cnt);
> +       fprintf(stderr, "%s: attached in %7.3lfs\n", __func__, attach_delta);
> +       fprintf(stderr, "%s: detached in %7.3lfs\n", __func__, detach_delta);


why stderr? just do printf() and let test_progs handle output


> +
> +cleanup:
> +       kprobe_multi_empty__destroy(skel);
> +       if (syms) {
> +               for (i = 0; i < cnt; i++)
> +                       free(syms[i]);
> +               free(syms);
> +       }
> +}
> +
>  void test_kprobe_multi_test(void)
>  {
>         if (!ASSERT_OK(load_kallsyms(), "load_kallsyms"))
> @@ -320,4 +454,6 @@ void test_kprobe_multi_test(void)
>                 test_attach_api_syms();
>         if (test__start_subtest("attach_api_fails"))
>                 test_attach_api_fails();
> +       if (test__start_subtest("bench_attach"))
> +               test_bench_attach();
>  }
> diff --git a/tools/testing/selftests/bpf/progs/kprobe_multi_empty.c b/tools/testing/selftests/bpf/progs/kprobe_multi_empty.c
> new file mode 100644
> index 000000000000..be9e3d891d46
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/kprobe_multi_empty.c
> @@ -0,0 +1,12 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +SEC("kprobe.multi/*")

use SEC("kprobe.multi") to make it clear that we are attaching it "manually"?

> +int test_kprobe_empty(struct pt_regs *ctx)
> +{
> +       return 0;
> +}
> --
> 2.35.1
>
