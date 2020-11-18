Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5302B73D8
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgKRBn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:43:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKRBn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 20:43:29 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01955C061A48;
        Tue, 17 Nov 2020 17:43:28 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id d1so134163ybr.10;
        Tue, 17 Nov 2020 17:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=A0mg8MQgDfS28elA9JqsJHkeWfTEE+rH9xC3HBAsDTg=;
        b=sgphcYh3rXQDQAttlOMBcQeIjjiScpH7D0ffvdbaYtWknDW3gVnBofQGEXkYsePLoA
         2WneqMphHz63xTkANHjzxgE+LsO+i7dbCJ1ZY5WibGiATKWJQyIrgBlgH45ha9EaBgg+
         DxG5hpXeXVk0immvY+4igWB+jJQUClWsGe4wbJxJZc8aew7YKJvnY5WMwcIuTD9u7QP4
         +N0JTl4edTjrFRnRNZw7CBfiMdz3B9vhC2ykyp6NyWQrIjIO0F2oQQpNAxrhB1ytX5V+
         WdnzF1HMVM6O12iZVU4UZYDB8ldRsTk7cnZ/oRhodJsoLx7iKarsITF2tJPBItI8+OF0
         I4lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=A0mg8MQgDfS28elA9JqsJHkeWfTEE+rH9xC3HBAsDTg=;
        b=G/FvpwBrEkCrQl5uH2+C/meUNonktOMJz3BnFF2M/j6LVKcKX4C/zpwW1peOAp69zr
         97mRdkv6ZltKoiYUxx3OSP2+6jgKYu0+OAtpMS/TFSCt9Z6WRori+J3/2b3aH7sfuMxM
         mYEKAethY/iUmORbca73sH1zQeQ9kOWX2qTnA0Pv/BmSriDFz7bWBXoSAR2uYBf5IUxN
         booG0euYvQfgVIgllHztTYjJUDRwmxOFHnCMWP4QCxBDqIax1zsVCiH3lLf41KpR/qTm
         cub3oH4QgV1jTzRQQFf2gLx8DgwbsUNZdHLNqNNZpHoZ6UyW1YoTR0q0oUszWeOz1YeB
         dcBg==
X-Gm-Message-State: AOAM530+sdxeQPZgnUwGf1kKSh9+l8cX10E2vUVBGC0BIvATYyYDrYOH
        yXFI8kKA2jI92540CVkQ/GFL9FgsJ5OOSTWDYmY=
X-Google-Smtp-Source: ABdhPJyPjcvp0eDkEPhJbKd3l8mS5PDRqmOWT3VyTCvQjZogHc/R25npp99td9VnSjQY+Kj50W7IXcvzzGaVmoBpHYk=
X-Received: by 2002:a25:7717:: with SMTP id s23mr4306672ybc.459.1605663807287;
 Tue, 17 Nov 2020 17:43:27 -0800 (PST)
MIME-Version: 1.0
References: <20201117082638.43675-1-bjorn.topel@gmail.com> <20201117082638.43675-2-bjorn.topel@gmail.com>
In-Reply-To: <20201117082638.43675-2-bjorn.topel@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Nov 2020 17:43:16 -0800
Message-ID: <CAEf4BzYJRqf4ho3hSmXWi2oTMts69ix8nODcoePmnUfg+jjdbQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] selftests/bpf: Fix broken riscv build
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        xi.wang@gmail.com, luke.r.nels@gmail.com,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 12:28 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.c=
om> wrote:
>
> The selftests/bpf Makefile includes system include directories from
> the host, when building BPF programs. On RISC-V glibc requires that
> __riscv_xlen is defined. This is not the case for "clang -target bpf",
> which messes up __WORDSIZE (errno.h -> ... -> wordsize.h) and breaks
> the build.
>
> By explicitly defining __risc_xlen correctly for riscv, we can
> workaround this.
>
> Fixes: 167381f3eac0 ("selftests/bpf: Makefile fix "missing" headers on bu=
ild with -idirafter")
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> ---
>  tools/testing/selftests/bpf/Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
> index c1708ffa6b1c..9d48769ad268 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -219,7 +219,8 @@ $(RESOLVE_BTFIDS): $(BPFOBJ) | $(BUILD_DIR)/resolve_b=
tfids  \
>  # build would have failed anyways.
>  define get_sys_includes
>  $(shell $(1) -v -E - </dev/null 2>&1 \
> -       | sed -n '/<...> search starts here:/,/End of search list./{ s| \=
(/.*\)|-idirafter \1|p }')
> +       | sed -n '/<...> search starts here:/,/End of search list./{ s| \=
(/.*\)|-idirafter \1|p }') \
> +       $(shell $(1) -dM -E - </dev/null | grep '#define __riscv_xlen ' |=
sed 's/#define /-D/' | sed 's/ /=3D/')

just nits: second $(shell ) invocation should be at the same
indentation level as the first one

also '|sed' -> '| sed' ?

Otherwise I have no idea what this does and no way to try it on
RISC-V, but it doesn't break my setup, so I'm fine with it. ;)


>  endef
>
>  # Determine target endianness.
> --
> 2.27.0
>
