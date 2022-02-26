Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FE14C5415
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 07:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiBZGJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 01:09:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiBZGJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 01:09:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0786D114FD2;
        Fri, 25 Feb 2022 22:09:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96E8160C11;
        Sat, 26 Feb 2022 06:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5C1C340F2;
        Sat, 26 Feb 2022 06:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645855763;
        bh=heJPHUn7XfYzu7DFZYuil9Qqj8KTMzMdMdnl3ERx3n0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pUfEb1A++U1BmqJ2LV6MbiUF0ATv17WQnB/udPZJCSqnaSR50nbMeURXuqJySyR2X
         +ei5GXwJDYt2K2SMs0ve81dq5UF0RtDhFDhK8miihluN6x5w11fxmTeICmXy7uNW+j
         rbv1PEpdyD1FOZlPVGqGOa5estNLUvpuh/RzprNDqehAqTeMa5285LHrp3FSnZXILV
         WtLvUNO1hs0r+kXIv/PS4W+9Abll/TU4wEpNHuVQA9mTjWC+C5dZX0U9rfuwkDHzKl
         W0bdsl9lqDOTHpCUFz2XMkfNRa4B8+NwV1uOhmcVTHEPDRrCed5SLINbj8ewGlTRKG
         WAUPsATln/FxQ==
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-2d07ae0b1c0so55394387b3.2;
        Fri, 25 Feb 2022 22:09:22 -0800 (PST)
X-Gm-Message-State: AOAM5309VeP4oxyvlOIKcSoPwjM84SFNUn3wnRVrdbl01eIr8SgQaKlt
        NB3GmshSqVYXzTN2diSasHLoIZecTc3SYOLDG9E=
X-Google-Smtp-Source: ABdhPJwEJSBx1AuAkbwrgaXvQ5OpPdVFQ+dHsTQ1QI4eAoqz4maw3zf4pXv2cWgNzYR1XD+ZLqVYF89SjSDFeZm6fbc=
X-Received: by 2002:a81:83d6:0:b0:2ca:93ad:e4d6 with SMTP id
 t205-20020a8183d6000000b002ca93ade4d6mr10756915ywf.472.1645855761917; Fri, 25
 Feb 2022 22:09:21 -0800 (PST)
MIME-Version: 1.0
References: <20220225161507.470763-1-ytcoode@gmail.com>
In-Reply-To: <20220225161507.470763-1-ytcoode@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 25 Feb 2022 22:09:10 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5=mAv4Oa++kSxz4j5imvoGM70Vtk+qqCU3dY2Osf0gYA@mail.gmail.com>
Message-ID: <CAPhsuW5=mAv4Oa++kSxz4j5imvoGM70Vtk+qqCU3dY2Osf0gYA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: Remove redundant slashes
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 8:15 AM Yuntao Wang <ytcoode@gmail.com> wrote:
>
> Since the _OUTPUT variable holds a value ending with a trailing slash,

While the change makes sense, I think the description here is not accurate.
Currently, we require OUTPUT to end with trailing slash. However, if
OUTPUT is not defined, _OUTPUT will not hold a trailing slash. Adding
trailing slash to _OUTPUT is one part of this patch, so I think we should not
say that's the reason of this change.

Thanks,
Song

> there is no need to add another one when defining BOOTSTRAP_OUTPUT and
> LIBBPF_OUTPUT variables.
>
> When defining LIBBPF_INCLUDE and LIBBPF_BOOTSTRAP_INCLUDE, we shouldn't
> add an extra slash either for the same reason.
>
> When building libbpf, the value of the DESTDIR argument should also not
> end with a trailing slash.
>
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
>  tools/bpf/bpftool/Makefile | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index ba647aede0d6..9800f966fd51 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -18,19 +18,19 @@ BPF_DIR = $(srctree)/tools/lib/bpf
>  ifneq ($(OUTPUT),)
>    _OUTPUT := $(OUTPUT)
>  else
> -  _OUTPUT := $(CURDIR)
> +  _OUTPUT := $(CURDIR)/
>  endif
> -BOOTSTRAP_OUTPUT := $(_OUTPUT)/bootstrap/
> +BOOTSTRAP_OUTPUT := $(_OUTPUT)bootstrap/
>
> -LIBBPF_OUTPUT := $(_OUTPUT)/libbpf/
> +LIBBPF_OUTPUT := $(_OUTPUT)libbpf/
>  LIBBPF_DESTDIR := $(LIBBPF_OUTPUT)
> -LIBBPF_INCLUDE := $(LIBBPF_DESTDIR)/include
> +LIBBPF_INCLUDE := $(LIBBPF_DESTDIR)include
>  LIBBPF_HDRS_DIR := $(LIBBPF_INCLUDE)/bpf
>  LIBBPF := $(LIBBPF_OUTPUT)libbpf.a
>
>  LIBBPF_BOOTSTRAP_OUTPUT := $(BOOTSTRAP_OUTPUT)libbpf/
>  LIBBPF_BOOTSTRAP_DESTDIR := $(LIBBPF_BOOTSTRAP_OUTPUT)
> -LIBBPF_BOOTSTRAP_INCLUDE := $(LIBBPF_BOOTSTRAP_DESTDIR)/include
> +LIBBPF_BOOTSTRAP_INCLUDE := $(LIBBPF_BOOTSTRAP_DESTDIR)include
>  LIBBPF_BOOTSTRAP_HDRS_DIR := $(LIBBPF_BOOTSTRAP_INCLUDE)/bpf
>  LIBBPF_BOOTSTRAP := $(LIBBPF_BOOTSTRAP_OUTPUT)libbpf.a
>
> @@ -44,7 +44,7 @@ $(LIBBPF_OUTPUT) $(BOOTSTRAP_OUTPUT) $(LIBBPF_BOOTSTRAP_OUTPUT) $(LIBBPF_HDRS_DI
>
>  $(LIBBPF): $(wildcard $(BPF_DIR)/*.[ch] $(BPF_DIR)/Makefile) | $(LIBBPF_OUTPUT)
>         $(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_OUTPUT) \
> -               DESTDIR=$(LIBBPF_DESTDIR) prefix= $(LIBBPF) install_headers
> +               DESTDIR=$(LIBBPF_DESTDIR:/=) prefix= $(LIBBPF) install_headers
>
>  $(LIBBPF_INTERNAL_HDRS): $(LIBBPF_HDRS_DIR)/%.h: $(BPF_DIR)/%.h | $(LIBBPF_HDRS_DIR)
>         $(call QUIET_INSTALL, $@)
> @@ -52,7 +52,7 @@ $(LIBBPF_INTERNAL_HDRS): $(LIBBPF_HDRS_DIR)/%.h: $(BPF_DIR)/%.h | $(LIBBPF_HDRS_
>
>  $(LIBBPF_BOOTSTRAP): $(wildcard $(BPF_DIR)/*.[ch] $(BPF_DIR)/Makefile) | $(LIBBPF_BOOTSTRAP_OUTPUT)
>         $(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_BOOTSTRAP_OUTPUT) \
> -               DESTDIR=$(LIBBPF_BOOTSTRAP_DESTDIR) prefix= \
> +               DESTDIR=$(LIBBPF_BOOTSTRAP_DESTDIR:/=) prefix= \
>                 ARCH= CROSS_COMPILE= CC=$(HOSTCC) LD=$(HOSTLD) $@ install_headers
>
>  $(LIBBPF_BOOTSTRAP_INTERNAL_HDRS): $(LIBBPF_BOOTSTRAP_HDRS_DIR)/%.h: $(BPF_DIR)/%.h | $(LIBBPF_BOOTSTRAP_HDRS_DIR)
> --
> 2.35.1
>
