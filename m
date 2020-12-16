Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860412DC5F0
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 19:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729288AbgLPSH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 13:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbgLPSH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 13:07:27 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94525C06179C;
        Wed, 16 Dec 2020 10:06:46 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id y128so3610272ybf.10;
        Wed, 16 Dec 2020 10:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VodWZpWl/+uWOhTMN//0IR82qShPVli3GP+B85kzebI=;
        b=HgkKI4G/HgYCipvAAw6VhORa1cxXlRphEmiOOjtS8+2DFX+gWbUH4AgXZu1fKdwTSn
         pSEwp3kHpSA4r7/4NxgDyoYMq0tKm/y85UCWN67D5z6XUY7lDLG22Qdtq6qYxvnvjbww
         vpE5oMNJc7B6/xs9K2YdOq33yJV9YQTkCdIkFNfCYtqUjqu2RcgHZjRislkx1bLKOdB2
         vKCiFImSSimyu3dWk69QIb5gQzSytCf8ye7F1iUMJgLBIAaX58tad+2YxLXOWsY63wv+
         euV/PCLRJ3Ri7H7MY6D5AmdYQsejL4SNlH/xxbqY4xjMgJhgB1qJalD8gL2wA6C0a8Cg
         N7rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VodWZpWl/+uWOhTMN//0IR82qShPVli3GP+B85kzebI=;
        b=WBpr3s+nT07obq2vNyYuYfh8SSiFdX5lUAYG9YpKX7Nt/pYZBJ8r8/9BL1MTk09Nwh
         +Y5D0m8utIxUdYEj6HfhVlsKdDG+vBUnsOVHoVsT73oU5fPIy0LZffOHNzMYJ4k+c1Vy
         4AX/JX7BaVchwO59f6hBUkXkmAkS1ieYsi2DOmSZ3WWWbE2DJqXUokbkg3gs19lyDjjG
         FqKdBF57qucwKoFw5yc6t008eDZCwkIurWI+6e+NVGCs/bKLxiNjQ8B0qTvOxUQybfQY
         gZvjBuFZ843okEnVIATNXlpnOxLEG2/LcFQQtN1pQR+9/noYj8i+5TQ2Azid8LgB4drT
         bFxA==
X-Gm-Message-State: AOAM531ajL0MXaNg7ZM43zUEltXWJ0T0oNKrikzNEFKh4Z8x/+r3UBvJ
        u1vgvhd72kIJ3BYbbn2fHQa/L28AcyYFcmhNJJg=
X-Google-Smtp-Source: ABdhPJy3g5GfYo5WT+IeLrwHD6qpe8ngg3vhanZs6hYwZjszn/hqZ+Z9uHSwjKHHvo6ZnPgPboPTG5wVZW+geoDjMwc=
X-Received: by 2002:a25:aea8:: with SMTP id b40mr52596024ybj.347.1608142005891;
 Wed, 16 Dec 2020 10:06:45 -0800 (PST)
MIME-Version: 1.0
References: <CAEf4BzYBvz4TDayTE=Bc_bjqvOGaavmmw1sJhOCKhq9DwUpd4A@mail.gmail.com>
 <20201215182011.15755-1-kamal@canonical.com>
In-Reply-To: <20201215182011.15755-1-kamal@canonical.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Dec 2020 10:06:35 -0800
Message-ID: <CAEf4BzYgnDWRswYJPnMdtACs7K5mckbfHX2i68YXhha4q=ywFw@mail.gmail.com>
Subject: Re: [PATCH v2] selftests/bpf: clarify build error if no vmlinux
To:     Kamal Mostafa <kamal@canonical.com>
Cc:     linux- stable <stable@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 10:20 AM Kamal Mostafa <kamal@canonical.com> wrote:
>
> If Makefile cannot find any of the vmlinux's in its VMLINUX_BTF_PATHS list,
> it tries to run btftool incorrectly, with VMLINUX_BTF unset:
>
>     bpftool btf dump file $(VMLINUX_BTF) format c
>
> Such that the keyword 'format' is misinterpreted as the path to vmlinux.
> The resulting build error message is fairly cryptic:
>
>       GEN      vmlinux.h
>     Error: failed to load BTF from format: No such file or directory
>
> This patch makes the failure reason clearer by yielding this instead:
>
>     Makefile:...: *** cannot find a vmlinux for VMLINUX_BTF at any of
>     "{paths}".  Stop.
>
> Fixes: acbd06206bbb ("selftests/bpf: Add vmlinux.h selftest exercising tracing of syscalls")
> Cc: stable@vger.kernel.org # 5.7+
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> ---

Applied to bpf tree, thanks. This conflicted with a67079b03165
("selftests/bpf: fix bpf_testmod.ko recompilation logic"), I resolved
the conflict and capitalized "Cannot" in the error message.

>
> [v2] moves the check to right after the VMLINUX_BTF definition.
>
>  tools/testing/selftests/bpf/Makefile | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 542768f5195b..7ba631f495f7 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -146,6 +146,9 @@ VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)                                \
>                      /sys/kernel/btf/vmlinux                            \
>                      /boot/vmlinux-$(shell uname -r)
>  VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
> +ifeq ($(VMLINUX_BTF),)
> +$(error cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
> +endif
>
>  DEFAULT_BPFTOOL := $(SCRATCH_DIR)/sbin/bpftool
>
> --
> 2.17.1
>
