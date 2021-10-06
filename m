Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038AB4245F7
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 20:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbhJFSZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 14:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbhJFSZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 14:25:21 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F144C061746;
        Wed,  6 Oct 2021 11:23:29 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id r1so7485216ybo.10;
        Wed, 06 Oct 2021 11:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iO3W05XPZ+MNPtsNnxOyy8Sx04BLl+kEBQAdBZLskBQ=;
        b=cilzqsTm5704Jod6F3NRmGZ1/Um4apMwkqJfwmk4J9ET75mjbUG935+IPlYEBXk+JI
         sTFi1/p/84x4qRL9NJYIxct4oYmUkkVzGidEAyE0qCg3tsYsx5LY62bO/HwZc8DhKgQ6
         eYU1o6RXG0pKBnbSIv12BRIrzhXhtbdTZkBCqFK2gVmXeeOBxjU6XkaVokTkdq213ypS
         3KERrhE1kcVA574Wae3EQlA+nbL5QsmCdE1njGGBpf/M2aqSnPizk93gCyvpH69Daf/X
         Mi1gAS1s489qpV3xhrwXJRTLfXFfQbi8pENMVxWQ1geCnimyhv6JwOFoIeoc7aBdjwdq
         N7sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iO3W05XPZ+MNPtsNnxOyy8Sx04BLl+kEBQAdBZLskBQ=;
        b=BgWOfjk634Hs7pqdIwA1SvTQtvSvhbsWJYQL6RlSFU+eXkkPmRTz7/CXIhK8TNYk5N
         3EhelHr7byhBFFjIqGcXdCVCy+B0oQqSjue2MiMPXBY7kyI3wiuk73ez+ZGVrcvdXwJQ
         KQ25i2P7ucX7WI0H6WGnt7T7hGZtY1s5qcrLkxUgKInyfFyKw8c2FWht+9v45SFD4l4l
         uHFmaY+QjBWz8EPaJelBtVKfKg8aUeUlSemiyrHFV2zTCR/MboYyZ8AIHH3IplXxsJhW
         aj4x2FBclEuq6sy0b8S6MujzKtpquD5dFZRP8cuMJWFPCHmZqzeZnv5AKoJTzNVw+AXp
         j1lQ==
X-Gm-Message-State: AOAM530CkU1x8Grtlk6RsVMzY4MKvKmAKF4bBX2xqjz6aYp+aUxJcW45
        5sPMZZwUq7vAJ5MBJftcxfrNWqXY7xrQHtoQzIc=
X-Google-Smtp-Source: ABdhPJyNPbyOjnMbmuJTU4zkk7FgYWxERi7BDlfuCuKUXvQ3kd3Qn7sK5aLJ2lOrTAwPpL0U/SdT2ruxeZUMbwHuRi0=
X-Received: by 2002:a25:afcf:: with SMTP id d15mr28592678ybj.433.1633544608328;
 Wed, 06 Oct 2021 11:23:28 -0700 (PDT)
MIME-Version: 1.0
References: <20211003192208.6297-1-quentin@isovalent.com> <20211003192208.6297-8-quentin@isovalent.com>
In-Reply-To: <20211003192208.6297-8-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 Oct 2021 11:23:17 -0700
Message-ID: <CAEf4BzaCCf7BEbL6MWWFJnThcR0jZ8VxsVvha2KHfzoJZFCzqA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 07/10] samples/bpf: install libbpf headers
 when building
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 3, 2021 at 12:22 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> API headers from libbpf should not be accessed directly from the source
> directory. Instead, they should be exported with "make install_headers".
> Make sure that samples/bpf/Makefile installs the headers properly when
> building.
>
> The object compiled from and exported by libbpf are now placed into a
> subdirectory of sample/bpf/ instead of remaining in tools/lib/bpf/. We
> attempt to remove this directory on "make clean". However, the "clean"
> target re-enters the samples/bpf/ directory from the root of the
> repository ("$(MAKE) -C ../../ M=$(CURDIR) clean"), in such a way that
> $(srctree) and $(src) are not defined, making it impossible to use
> $(LIBBPF_OUTPUT) and $(LIBBPF_DESTDIR) in the recipe. So we only attempt
> to clean $(CURDIR)/libbpf, which is the default value.
>
> Add a dependency on libbpf's headers for the $(TRACE_HELPERS).
>
> We also change the output directory for bpftool, to place the generated
> objects under samples/bpf/bpftool/ instead of building in bpftool's
> directory directly. Doing so, we make sure bpftool reuses the libbpf
> library previously compiled and installed.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  samples/bpf/Makefile | 41 +++++++++++++++++++++++++++++++----------
>  1 file changed, 31 insertions(+), 10 deletions(-)
>

[...]

> +
> +$(LIBBPF_OUTPUT) $(BPFTOOL_OUTPUT):
> +       $(call msg,MKDIR,$@)
> +       $(Q)mkdir -p $@
>
>  $(obj)/syscall_nrs.h:  $(obj)/syscall_nrs.s FORCE
>         $(call filechk,offsets,__SYSCALL_NRS_H__)
> @@ -309,6 +325,11 @@ verify_target_bpf: verify_cmds
>  $(BPF_SAMPLES_PATH)/*.c: verify_target_bpf $(LIBBPF)
>  $(src)/*.c: verify_target_bpf $(LIBBPF)
>
> +libbpf_hdrs: $(LIBBPF)
> +$(obj)/$(TRACE_HELPERS): libbpf_hdrs

same problem

> +
> +.PHONY: libbpf_hdrs
> +
>  $(obj)/xdp_redirect_cpu_user.o: $(obj)/xdp_redirect_cpu.skel.h
>  $(obj)/xdp_redirect_map_multi_user.o: $(obj)/xdp_redirect_map_multi.skel.h
>  $(obj)/xdp_redirect_map_user.o: $(obj)/xdp_redirect_map.skel.h
> @@ -367,7 +388,7 @@ $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/x
>         $(Q)$(CLANG) -g -O2 -target bpf -D__TARGET_ARCH_$(SRCARCH) \
>                 -Wno-compare-distinct-pointer-types -I$(srctree)/include \
>                 -I$(srctree)/samples/bpf -I$(srctree)/tools/include \
> -               -I$(srctree)/tools/lib $(CLANG_SYS_INCLUDES) \
> +               -I$(LIBBPF_INCLUDE) $(CLANG_SYS_INCLUDES) \
>                 -c $(filter %.bpf.c,$^) -o $@
>
>  LINKED_SKELS := xdp_redirect_cpu.skel.h xdp_redirect_map_multi.skel.h \
> @@ -404,7 +425,7 @@ $(obj)/%.o: $(src)/%.c
>         @echo "  CLANG-bpf " $@
>         $(Q)$(CLANG) $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(BPF_EXTRA_CFLAGS) \
>                 -I$(obj) -I$(srctree)/tools/testing/selftests/bpf/ \
> -               -I$(srctree)/tools/lib/ \
> +               -I$(LIBBPF_INCLUDE) \
>                 -D__KERNEL__ -D__BPF_TRACING__ -Wno-unused-value -Wno-pointer-sign \
>                 -D__TARGET_ARCH_$(SRCARCH) -Wno-compare-distinct-pointer-types \
>                 -Wno-gnu-variable-sized-type-not-at-end \
> --
> 2.30.2
>
