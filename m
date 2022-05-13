Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4B6526CAC
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 23:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384789AbiEMV73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 17:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351134AbiEMV72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 17:59:28 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0022743EC8;
        Fri, 13 May 2022 14:59:26 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id e3so10147752ios.6;
        Fri, 13 May 2022 14:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gPMzGLjyd7K0kCpKAIDNBuDZ5gKdLeOkXqtKL7HB4ko=;
        b=YbSXIqCAovqRZzYYuNAbgCjTKV/BjSG7FTwfsN8Lk3h+1yGrPD+zDgyEQqL4sjNTWn
         99Id87H7khtb8iyr/Rl1/2Aknpg2792/UOJtpk5uu77YiCY21PZklimERbYBgJBnw86c
         T8c4ZaKxfgScym74Q5R2mNfLbLZEOlCe+BCAtT/voRXE0wTg6AsLn0rDiki2tTIkPmQ0
         f9KKo16HNS1sCOdoRQC6ysD2D8gWIRA4LwVl7k5QqhLq37vJ9Wxm1ILg3PK15422OZPI
         AAsCHTntGC4iwBwpNw+uQa79EK/a8OtNhP7XpA007/YeKmAsolFNACd1IJAS5HgGj/er
         0+dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gPMzGLjyd7K0kCpKAIDNBuDZ5gKdLeOkXqtKL7HB4ko=;
        b=M3TWKoi4cnw1XKvtlstfPzUIFbZNefUs3+6b+rzMd/155z7/+az5UYvyx1/Lop/MxP
         KnWf99S/StuwOQvOY3yKJBbk91U6835arstDZWE3X0mJaPOEypwXbQwA/ZJNB8r8q7af
         tNGWrONxkPhVG3rehgZ+igpOvZxS6fn79IkFzybwwEyNfoUOP8C88HkqI26EdAEh88GG
         ByVze5BRbv1sBBOlLJzls334XGUwYr7zIZNi5NDIIeIt9hyi1vgF7A+zsgWMJhxozggc
         b96tU6H9tQPgbeDGxKgDLCUINBy8uxE+rWY9rMAvTkxqK9ZSbb5eIBUC+E6Q0wEQTja8
         27PQ==
X-Gm-Message-State: AOAM5302jRw11r725kuypXfRL5Oy+cGjq+BqCeEdF9YwGupAG/+LOSJm
        +OKZe2IqHwDpKzpWCv4IY9YvkK1xTINvl1cKlUw=
X-Google-Smtp-Source: ABdhPJwojNP9CnESXa6DIb7DevLANLoe2IIPikIvrUYN07BlDuijD88t8PMO7aPxHLqb50qQCcSMjeXHfxSionFnm/Y=
X-Received: by 2002:a05:6638:33a1:b0:32b:8e2b:f9ba with SMTP id
 h33-20020a05663833a100b0032b8e2bf9bamr3654388jav.93.1652479166422; Fri, 13
 May 2022 14:59:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220513010110.319061-1-liuhangbin@gmail.com> <20220513010110.319061-2-liuhangbin@gmail.com>
In-Reply-To: <20220513010110.319061-2-liuhangbin@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 May 2022 14:59:15 -0700
Message-ID: <CAEf4BzZYaNEyaxZzoFuk_CN6Qe+w9pdCR3YXzM=fv4d=vEpwDg@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 1/2] selftests/bpf: Fix build error with ima_setup.sh
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Thu, May 12, 2022 at 6:01 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> KP fixed ima_setup.sh missing issue when build test_progs separately with
> commit 854055c0cf30 ("selftests/bpf: Fix flavored variants of
> test_ima"). But the fix is incorrect because the build will failed with
> error:
>
>   $ OUTPUT="/tmp/bpf" make test_progs
>     [...]
>   make: *** No rule to make target '/tmp/bpf/ima_setup.sh', needed by 'ima_setup.sh'.  Stop.
>
> Fix it by adding a new variable TRUNNER_EXTRA_BUILD to build extra binaries.
> Left TRUNNER_EXTRA_FILES only for copying files
>
> Fixes: 854055c0cf30 ("selftests/bpf: Fix flavored variants of test_ima")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---

Oops, replied on older version of patch, but my comments still stand.
Not sure how this is actually fixing anything, tbh.

>  tools/testing/selftests/bpf/Makefile | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 3820608faf57..5944d3a8fff6 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -466,10 +466,10 @@ $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:                             \
>
>  # non-flavored in-srctree builds receive special treatment, in particular, we
>  # do not need to copy extra resources (see e.g. test_btf_dump_case())
> -$(TRUNNER_BINARY)-extras: $(TRUNNER_EXTRA_FILES) | $(TRUNNER_OUTPUT)
> +$(TRUNNER_BINARY)-extras: $(TRUNNER_EXTRA_BUILD) | $(TRUNNER_OUTPUT)
>  ifneq ($2:$(OUTPUT),:$(shell pwd))
>         $$(call msg,EXT-COPY,$(TRUNNER_BINARY),$(TRUNNER_EXTRA_FILES))
> -       $(Q)rsync -aq $$^ $(TRUNNER_OUTPUT)/
> +       $(Q)rsync -aq $(TRUNNER_EXTRA_FILES) $(TRUNNER_OUTPUT)/
>  endif
>
>  $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)                      \
> @@ -490,9 +490,9 @@ TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c      \
>                          network_helpers.c testing_helpers.c            \
>                          btf_helpers.c flow_dissector_load.h            \
>                          cap_helpers.c
> -TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read $(OUTPUT)/bpf_testmod.ko \
> -                      ima_setup.sh                                     \
> +TRUNNER_EXTRA_BUILD := $(OUTPUT)/urandom_read $(OUTPUT)/bpf_testmod.ko \
>                        $(wildcard progs/btf_dump_test_case_*.c)
> +TRUNNER_EXTRA_FILES := $(TRUNNER_EXTRA_BUILD) ima_setup.sh
>  TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
>  TRUNNER_BPF_CFLAGS := $(BPF_CFLAGS) $(CLANG_CFLAGS) -DENABLE_ATOMICS_TESTS
>  $(eval $(call DEFINE_TEST_RUNNER,test_progs))
> @@ -513,6 +513,7 @@ endif
>  TRUNNER_TESTS_DIR := map_tests
>  TRUNNER_BPF_PROGS_DIR := progs
>  TRUNNER_EXTRA_SOURCES := test_maps.c
> +TRUNNER_EXTRA_BUILD :=
>  TRUNNER_EXTRA_FILES :=
>  TRUNNER_BPF_BUILD_RULE := $$(error no BPF objects should be built)
>  TRUNNER_BPF_CFLAGS :=
> --
> 2.35.1
>
