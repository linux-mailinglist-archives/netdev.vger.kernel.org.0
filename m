Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E5656C208
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237269AbiGHWnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 18:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGHWnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 18:43:07 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1CEF13B471;
        Fri,  8 Jul 2022 15:43:06 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id r6so184654edd.7;
        Fri, 08 Jul 2022 15:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rGYZvcYf47sP+55Vs4UvXXryFfFplfq5QIu85G/+xro=;
        b=UmCsFRzomqWag60HiSO6s7F26oEj/FqCk7eX3SaKMoZj1Owl4dXDJrDU7HgSYmYFBG
         ppkR5X7cbgoKHqK6YkALQdM6mrKQEYZFC12cINZJBgbn+NImcC/yC7qoNoiT/emc4veL
         jt1DZln7jjseWzByF0ub40nUIlUirQWpFSecjApXl7Xm4ZHvy9LAsRc3LIdcoGrl7dkS
         iCgCDUWgla6BwhNlZ9g0u5HdE7DjTthX4R5WNAKRjo2n23oHMoxc6CjcrDTkE0IwTP9e
         2RIfYhAfHYzg2Mmiyqw8CM98caAAZ9WTZfTvl5mrx8wz5NDC0t0c3QCqkdP6j7Dk0Rjw
         nWSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rGYZvcYf47sP+55Vs4UvXXryFfFplfq5QIu85G/+xro=;
        b=CXFZIUtfyR3fEcUypqf8uhC8HlK25gTQOrhYgMB8pXIxN82PiS/KKN7OeV1TLNQd8b
         XCf1sUH1DJVcQt0Q+scGe7qy3LIqTuSPqd+gN/nn2Ums/wI8kUkFJ1aLw3TrnYYQITKQ
         dnJCZhuuDz8CXuUeKTUn4EHR33SftE4hx5YDPmlJTDWee4TFeE9EkhRnObFs2H1DwPyn
         0OhxgRw0Dbb4rJ8cWgnVNtCeSnHqvvoUu/3m64HWFpOJB/CJBwzUfB7HFEO+UEbG1QwG
         Q+Rn58XSvKuSsnkcD5Wpd5X7+XaNQSfTlVytCC9se6HWI8/ZQBRTNrdfOFuj4rfSfSph
         Uqyg==
X-Gm-Message-State: AJIora8h6y3dwiPSD1bvgHqsqhXqUo+RXbr1hb3k+p8qm4VQrcVSO90X
        A5wYFNG0ZyKbomj9Ix8IlKpvC+Zvqle68iTUUz8ANtHMkHQSkw==
X-Google-Smtp-Source: AGRyM1vnGLoGOwdAcO2TdMuO/mhpm1ZA44hl5swMvkyTOkD+uUoojhY8gXcIw9hX3HCbszWx1FslVBL2R2Mf310MvD0=
X-Received: by 2002:a05:6402:5309:b0:435:6431:f9dc with SMTP id
 eo9-20020a056402530900b004356431f9dcmr7718578edb.14.1657320185368; Fri, 08
 Jul 2022 15:43:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220707140811.603590-1-pulehui@huawei.com>
In-Reply-To: <20220707140811.603590-1-pulehui@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Jul 2022 15:42:54 -0700
Message-ID: <CAEf4Bzb_re+o2zALCA+Rf_cJS-31350PjhzRg42bgW0mO-GVbg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples: bpf: Fix cross-compiling error about bpftool
To:     Pu Lehui <pulehui@huawei.com>,
        Quentin Monnet <quentin@isovalent.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
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

On Thu, Jul 7, 2022 at 6:37 AM Pu Lehui <pulehui@huawei.com> wrote:
>
> Currently, when cross compiling bpf samples, the host side
> cannot use arch-specific bpftool to generate vmlinux.h or
> skeleton. We need to compile the bpftool with the host
> compiler.
>
> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> ---

samples/bpf use bpftool for vmlinux.h, skeleton, and static linking
only. All that is supported by lightweight "bootstrap" bpftool
version, so we can build just that. It will be faster, and bootstrap
version should be always host-native even during cross compilation.
See [0] for what I did in libbpf-bootstrap.

Also please cc Quention for bpftool-related changes. Thanks!

   [0] https://github.com/libbpf/libbpf-bootstrap/commit/fc28424eb3f0e39cfb5959296b070389b9a8bd8f

>  samples/bpf/Makefile | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 5002a5b9a7da..fe54a8c8f312 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -1,4 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
> +-include tools/scripts/Makefile.include
>
>  BPF_SAMPLES_PATH ?= $(abspath $(srctree)/$(src))
>  TOOLS_PATH := $(BPF_SAMPLES_PATH)/../../tools
> @@ -283,11 +284,10 @@ $(LIBBPF): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(LIBBPF_OU
>  BPFTOOLDIR := $(TOOLS_PATH)/bpf/bpftool
>  BPFTOOL_OUTPUT := $(abspath $(BPF_SAMPLES_PATH))/bpftool
>  BPFTOOL := $(BPFTOOL_OUTPUT)/bpftool
> -$(BPFTOOL): $(LIBBPF) $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) | $(BPFTOOL_OUTPUT)
> +$(BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) | $(BPFTOOL_OUTPUT)
>             $(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../ \
> -               OUTPUT=$(BPFTOOL_OUTPUT)/ \
> -               LIBBPF_OUTPUT=$(LIBBPF_OUTPUT)/ \
> -               LIBBPF_DESTDIR=$(LIBBPF_DESTDIR)/
> +               ARCH= CROSS_COMPILE= CC=$(HOSTCC) LD=$(HOSTLD) \
> +               OUTPUT=$(BPFTOOL_OUTPUT)/
>
>  $(LIBBPF_OUTPUT) $(BPFTOOL_OUTPUT):
>         $(call msg,MKDIR,$@)
> --
> 2.25.1
>
