Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39C5D5122FB
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 21:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbiD0Tof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 15:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234780AbiD0ToW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 15:44:22 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAA453A67;
        Wed, 27 Apr 2022 12:38:44 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id z26so4338714iot.8;
        Wed, 27 Apr 2022 12:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YxXEye4IU8j4v6PZooMH7wOdPbz6pXHC5cWSh3NnJeo=;
        b=UhC7ht2k+INKbYGtB6qvA1F6cFRj1MAuYVGrDcOhAEoMAqR8vgQ5i8ptewg8a4JHll
         28BzBf4y64AGv4QIcm3LvrQR9FE/TPsTTgy12oudzyMI8FCK32iHfBUvETR9nwDDoMVo
         ZcFwPnQT7jf4bDUgHdWEugYskGuPs62wxU0sV/laNADiFmaDDNDSHHffeRF7n/RwO9jq
         pFqwRw46jC5xN0azBs+vh6Aoyb85yrYD+U9felM2MSB9cqtnnvTycMLbeROTMCzgs2sf
         Bzac9O8mkDbVmT8UATUpz1e2ZgfHjX3zWJqws9JiugnxZSP9Tfe7h91arPqJNJtTissr
         fxKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YxXEye4IU8j4v6PZooMH7wOdPbz6pXHC5cWSh3NnJeo=;
        b=pVOgyBnW0cGWm487ZS++KhTDoY4m015hO0URlC7WO3E/TsT1EJItrxB0TKfrbE1l70
         E+uICU0LnLJCffBiqaD8DAnK/ViwsVBSb68gOAVl7raFAeTtrDwO4kyDhE5KpnNUvU6R
         PmOAtPXRF1dUghXLjxEhj8p0DLnI5X+QaMySkTbP33P/Onj+1Yyiy9OLmih4h+GPZMSk
         CdCkUBUhRKU1bR1bg0YMNjMbjP1sF6INCOr3QfVvr8ECVijebLuL634Z4qcPSNu8sAXG
         7rRF0/lXot4UdGKgzg0I9gPzAwVPSNUXeZXNzmjrEJT2CJxfhNOHLev24dlQ340DaP+u
         FlEA==
X-Gm-Message-State: AOAM531e0oliW4aY9I5S8XwNF85I8abOlms1WEeAxZRkjw/uN7JdtvKZ
        mjd8CF+BahrYMTqfduebbmPrRjIFIYnUj2FsJhQ=
X-Google-Smtp-Source: ABdhPJwrYhtqMNA/mmlGXK/zuN4kQSyJFEJLf6lcxTWQAIfBy3ibwsNLukys8hwQSHGYsx681njGmB3OrhD8BmzIY6A=
X-Received: by 2002:a05:6638:19c8:b0:328:6a22:8258 with SMTP id
 bi8-20020a05663819c800b003286a228258mr13060709jab.103.1651088323492; Wed, 27
 Apr 2022 12:38:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220423143007.423526-1-ytcoode@gmail.com>
In-Reply-To: <20220423143007.423526-1-ytcoode@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Apr 2022 12:38:32 -0700
Message-ID: <CAEf4BzbgaqWhFDQTZHDa6w7y02_f8JeoQoj30Zk2rzDe2UfZDg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix incorrect TRUNNER_BINARY name output
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
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

On Sat, Apr 23, 2022 at 7:30 AM Yuntao Wang <ytcoode@gmail.com> wrote:
>
> Currently, when we run 'make test_progs', the output is:
>
>   CLNG-BPF [test_maps] atomic_bounds.o
>   ...
>   GEN-SKEL [test_progs] atomic_bounds.skel.h
>   ...
>   TEST-OBJ [test_progs] align.test.o
>   ...
>   TEST-HDR [test_progs] tests.h
>   EXT-OBJ  [test_progs] test_progs.o
>   ...
>   BINARY   test_progs
>
> As you can see, the TRUNNER_BINARY name in the CLNG-BPF part is test_maps,
> which is incorrect.

It's not incorrect. test_maps and test_progs share the same set of BPF
object files under progs/ so whichever rule is picked first by make
gets to output it's [test_maps] or [test_progs] "badge". Is that a big
deal? Adding this $$(TRUNNER_BINARY) indirection and per-target
private TRUNNER_BINARY envvar is an unnecessary complication of
already complicated Makefile, IMO.

Did you run into any problems with the way Makefile is right now?

>
> Similarly, when we run 'make test_maps', the output is:
>
>   CLNG-BPF [test_maps] atomic_bounds.o
>   ...
>   GEN-SKEL [test_progs] atomic_bounds.skel.h
>   ...
>   TEST-OBJ [test_maps] array_map_batch_ops.test.o
>   ...
>   TEST-HDR [test_maps] tests.h
>   EXT-OBJ  [test_maps] test_maps.o
>   ...
>   BINARY   test_maps
>
> At this time, the TRUNNER_BINARY name in the GEN-SKEL part is wrong.
>
> Again, if we run 'make /full/path/to/selftests/bpf/test_vmlinux.skel.h',
> the output is:
>
>   CLNG-BPF [test_maps] test_vmlinux.o
>   GEN-SKEL [test_progs] test_vmlinux.skel.h
>
> Here, the TRUNNER_BINARY names are inappropriate and meaningless, they
> should be removed.
>
> This patch fixes these and all other similar issues.
>
> With the patch applied, the output becomes:
>
>   $ make test_progs
>
>   CLNG-BPF [test_progs] atomic_bounds.o
>   ...
>   GEN-SKEL [test_progs] atomic_bounds.skel.h
>   ...
>   TEST-OBJ [test_progs] align.test.o
>   ...
>   TEST-HDR [test_progs] tests.h
>   EXT-OBJ  [test_progs] test_progs.o
>   ...
>   BINARY   test_progs
>
>   $ make test_maps
>
>   CLNG-BPF [test_maps] atomic_bounds.o
>   ...
>   GEN-SKEL [test_maps] atomic_bounds.skel.h
>   ...
>   TEST-OBJ [test_maps] array_map_batch_ops.test.o
>   ...
>   TEST-HDR [test_maps] tests.h
>   EXT-OBJ  [test_maps] test_maps.o
>   ...
>   BINARY   test_maps
>
>   $ make /full/path/to/selftests/bpf/test_vmlinux.skel.h
>
>   CLNG-BPF test_vmlinux.o
>   GEN-SKEL test_vmlinux.skel.h
>
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
>  tools/testing/selftests/bpf/Makefile | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
>

[...]
