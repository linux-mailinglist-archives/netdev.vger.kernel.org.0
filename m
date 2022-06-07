Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0736D5416E4
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 22:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358638AbiFGU4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 16:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377955AbiFGUvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 16:51:14 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3AC1FDE91;
        Tue,  7 Jun 2022 11:41:01 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id b8so7451054edj.11;
        Tue, 07 Jun 2022 11:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GXW2rL4NXVvRk2JDX2m18WOLhnXkn5o6+TY+7wVjtRE=;
        b=N1Vd8aWmM1ySk0mcW8trc9dPBtxtE5CftSphFS3k/DOJ5xs8NntlPTLMsbV9eB2G3s
         jDH1jzVIBP9rhvsgxrEvleACfClys8746/KX2ydKGjWjNHjtdF8iixR/BIXxGhEXscDZ
         RfZNydJIpQ6qHFpL/g/sKhupfs1rhEQJoqsECwgXUs7pH8Ks1HCpYqUr4YdgFnxEWJAn
         skSU7VYd+Vf+n/AxTsPxO5cAJ4zEvaE71/vFjeQe9cCDcYGJbKG9KV4hF4756Z9ZRtH1
         2t/SWs7guc+T8E6dUW+5Y2uy/A0DHimYVsTI3N9Wp1mAiFcX/S8c30nwBig5jyoQdwfi
         sLbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GXW2rL4NXVvRk2JDX2m18WOLhnXkn5o6+TY+7wVjtRE=;
        b=GqUjQ1vyi6Xs6EpgmHIPe8z6BbgBYzkpkT+gibD1HhwXC1VOuSKAd99PfOYTZwxgIK
         P4og1CSLQbpbB57KiQKMgUsvCnKkxy5yasyzZ1Nwr1uWJCY8+4XOppXudmxJfHT7nrOz
         Em3sUbAGM7rEbiPmccrQ1cmRTlXE1xf+eIxts8pvnIZBg6Gcxe7+qYJTFAKQwk+b3OXb
         k3kbpMyLOxl7ZoXN4163bP/OJovIshbMaIhSRR25aGYJRJhFqxgpzJTw6hdx5HVdeNhF
         gilUHmXVHBgG3n4Q3CehKWzOZubrXU3nEb0ZfO9BC3IL48NrA69nEt2jaKjavlC2Xrpc
         B9tA==
X-Gm-Message-State: AOAM530Fmi9VClKsNQLBYwrivZ1KcDy1VXeeksb6RrBVTNtyNGG3UtcL
        3cAdox2t9NMynTPH6MPHCJSB4b3hZgIGX1+JBME=
X-Google-Smtp-Source: ABdhPJzFV7POzzYaS/eYvT70ZbJnT5xC9j9FFMEaFh9GOlCQHbKJzeMiTOD9OCYSb+pr7kVIj1bdTOlQrPIVFly5PwE=
X-Received: by 2002:a05:6402:120b:b0:42f:aa44:4d85 with SMTP id
 c11-20020a056402120b00b0042faa444d85mr25727948edw.338.1654627259569; Tue, 07
 Jun 2022 11:40:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220606184731.437300-1-jolsa@kernel.org> <20220606184731.437300-4-jolsa@kernel.org>
In-Reply-To: <20220606184731.437300-4-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 7 Jun 2022 11:40:47 -0700
Message-ID: <CAADnVQJA54Ra8+tV0e0KwSXAg93JRoiefDXWR-Lqatya5YWKpg@mail.gmail.com>
Subject: Re: [PATCHv2 bpf 3/3] bpf: Force cookies array to follow symbols sorting
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 6, 2022 at 11:48 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> When user specifies symbols and cookies for kprobe_multi link
> interface it's very likely the cookies will be misplaced and
> returned to wrong functions (via get_attach_cookie helper).
>
> The reason is that to resolve the provided functions we sort
> them before passing them to ftrace_lookup_symbols, but we do
> not do the same sort on the cookie values.
>
> Fixing this by using sort_r function with custom swap callback
> that swaps cookie values as well.
>
> Fixes: 0236fec57a15 ("bpf: Resolve symbols with ftrace_lookup_symbols for kprobe multi link")
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

It looks good, but something in this patch is causing a regression:
./test_progs -t kprobe_multi
test_kprobe_multi_test:PASS:load_kallsyms 0 nsec
#80/1    kprobe_multi_test/skel_api:OK
#80/2    kprobe_multi_test/link_api_addrs:OK
#80/3    kprobe_multi_test/link_api_syms:OK
#80/4    kprobe_multi_test/attach_api_pattern:OK
#80/5    kprobe_multi_test/attach_api_addrs:OK
#80/6    kprobe_multi_test/attach_api_syms:OK
#80/7    kprobe_multi_test/attach_api_fails:OK
test_bench_attach:PASS:get_syms 0 nsec
test_bench_attach:PASS:kprobe_multi_empty__open_and_load 0 nsec
libbpf: prog 'test_kprobe_empty': failed to attach: No such process
test_bench_attach:FAIL:bpf_program__attach_kprobe_multi_opts
unexpected error: -3
#80/8    kprobe_multi_test/bench_attach:FAIL
#80      kprobe_multi_test:FAIL

CI is unfortunately green, because we don't run it there:
#80/1 kprobe_multi_test/skel_api:OK
#80/2 kprobe_multi_test/link_api_addrs:OK
#80/3 kprobe_multi_test/link_api_syms:OK
#80/4 kprobe_multi_test/attach_api_pattern:OK
#80/5 kprobe_multi_test/attach_api_addrs:OK
#80/6 kprobe_multi_test/attach_api_syms:OK
#80/7 kprobe_multi_test/attach_api_fails:OK
#80 kprobe_multi_test:OK
