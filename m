Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E13526CA8
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 23:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384787AbiEMV6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 17:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359385AbiEMV6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 17:58:18 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E818AE58;
        Fri, 13 May 2022 14:58:17 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id s12so4042621iln.11;
        Fri, 13 May 2022 14:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/g4X8dMOGR02D0Dhp9783zdhT0HlLns9M8X2Oitrueg=;
        b=mxeZcdbjVVQ8DTsYW4qwUbmMwcr1XucBA+TjZIPlFB8/LaRfi+Y79xfu/UkIKI3b/n
         gu4iNsOTBKnqW0XWFAP9rRW2iDru0KaKlwmC/LZYYtr2RqB1se5pqBnQ9R+C9h5F1HlA
         1oYxP3x4snzMkZd/l36R2JBXKLER449AmBfolkJBzyffWSAvuUe8jh76Ceuv8yp24Qes
         ymCbc0Eb3DuJZFYtghNoIKf5yLDDz5I0DF6geD1zecuf9JMlKyzKF6ezwLiGb2eZ/l59
         nL09RVMcV9WsCaMyyYiWrTp/Ez25lm2noiw9BvF/JqpY4ezUX3pnn8r3Dr44E+Y5jI1T
         +/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/g4X8dMOGR02D0Dhp9783zdhT0HlLns9M8X2Oitrueg=;
        b=fcMeZ9fEUq1eo2JW5m6sr95T/kWEQHAToFzY2lv8devtja0j12DoEB2BZgPS6q8BoF
         2m0nmlRDcL1wQdjWXWw/sAPUNJ992CwQX44nO99VRF9QX5jPW9XRorBSpbzQ53Eh6s64
         2sB3tI4TCDN8sdETG2XHH1o8DmjeWXvJuYmoXJO5v/p0iDCzmO+OEr+zJJCnSdAojwpU
         ltMcX6EBiU2IEdl9GWSyjWyXXEUus4Fh4LtYNqgULni2KsjKUdnTTNs9ctVBuvq/kRtm
         XzAkvnd3pt+nKCfY+nREwMJvM64USlgPyYx1MmAr/r5tuvMqztPh8sHOhqCxHEd9//lv
         IjTg==
X-Gm-Message-State: AOAM530GD3WjXg84HfSpKrfg0Ch1mT3RDU7eRTYSlhZfNGXwHxNu3TZ2
        +vrMCvejtTnw8Ih1CCHorh/4EoLFO4PxlOIQe6Of36Mv5Ig=
X-Google-Smtp-Source: ABdhPJwB2MtVMHKp1kgPnzr9W/wcbFqKVrUBGmBrhpBnZO7r0P1CzeRTxATakJ38UOewG0eV8SedjxRxotVaTubWrhk=
X-Received: by 2002:a92:d250:0:b0:2d0:f240:d5f5 with SMTP id
 v16-20020a92d250000000b002d0f240d5f5mr3213225ilg.252.1652479096525; Fri, 13
 May 2022 14:58:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220512071819.199873-1-liuhangbin@gmail.com> <20220512071819.199873-2-liuhangbin@gmail.com>
In-Reply-To: <20220512071819.199873-2-liuhangbin@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 May 2022 14:58:05 -0700
Message-ID: <CAEf4BzZuj90MFaXci3av2BF+=m-P26Y3Zer8TogBiZ8fYsYP=g@mail.gmail.com>
Subject: Re: [PATCH net 1/2] selftests/bpf: Fix build error with ima_setup.sh
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

On Thu, May 12, 2022 at 12:18 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
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


note that progs/btf_dump_test_case_*.c are not built, they are just
copied over (C source files), so I don't think this fix is necessary.

btw, I tried running `OUTPUT="/tmp/bpf" make test_progs` and it didn't
error out. But tbh, I'd recommend building everything instead of
building individual targets.


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
