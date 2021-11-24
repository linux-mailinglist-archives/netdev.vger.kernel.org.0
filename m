Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0E045CE6E
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 21:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243576AbhKXUyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 15:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243407AbhKXUyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 15:54:11 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6BFC061574;
        Wed, 24 Nov 2021 12:51:01 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id t83so4804281qke.8;
        Wed, 24 Nov 2021 12:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iau6DKRydcsNK1GN6sDDCSnahnogg9ZqD2JSacu9WZ4=;
        b=nPlKl7EQVZKmz+/NgJntktxWSIcIQlj8SXVWiVCQtqHzP6KB8Q3bbJAFFdKgqCAYGs
         s0kikxhBgqbhtA1r4R1KxlbOH7wxIn0ghGwLgvk+gP3nicU4rpmI5BpEBUNf8/DJk1G+
         yEV6pVwbu9CJCq9vgh1Q8yFCV3/bj3sUjzZn7SPqWr95/egMfMghKWm/yy21MPxbYK05
         LZEcdLoZU0hJfw0cLD1v+Np4XQlbapdM4ZGByB3lSupPx01GFwOUGfXfm/pT6KZktKpF
         ++k8qDtBoYBWhYh4w/KupafMBr31J4Nb4RFRFhI40lozAdITEdx7hB3f2m58AU910+jG
         fN0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iau6DKRydcsNK1GN6sDDCSnahnogg9ZqD2JSacu9WZ4=;
        b=nAyTmt1pIWiq4ukSXjYxmo31ilbhurjQGgT9vPIf5922yq+DA48mb3VEEOvi9Cuh8Z
         lGY7cYfidnFM9H/8fXsnekWPp2Wf0aribugyQwa1XEydMWYXTxeJzwnF9Y7y2BVJAI5L
         2eDNUVx+s9HzDEp2AcQ17owVdO5szL1sP9qhCJ6E8jBizndRJY5Nzaja6QxJf7pPt9kN
         1g8NaJqlL2HpfRvu2BmBGe3xMgbyKuO8nPmBzsnIKgTZ53t4Bz6u/wyPUjiPg6EsnTy/
         zcqaEnhYg5E5OuEE2u2M2beBkWAiEvowH2yIu50hA/SFdfefP99BMUQ3YzqLWMqejrBe
         E6Xw==
X-Gm-Message-State: AOAM530vJ6xqb6wm0XD/Bd4bqcJfWdGbnFDTYU4tK8du9RFyi9loRZdV
        wrcDvGC+60Ij8MdhPFHHacUqo3+mZjXo0cmQP/6661qK4V0=
X-Google-Smtp-Source: ABdhPJxKYOfLQLPnsedikbDHOVU4wS+qfwCaPPo84K641EUnQq9HT1XO3bJZ3ph2d83tFh73xMJ8ujkD7agzP5AxQC8=
X-Received: by 2002:a25:cc4c:: with SMTP id l73mr20011466ybf.114.1637787060318;
 Wed, 24 Nov 2021 12:51:00 -0800 (PST)
MIME-Version: 1.0
References: <1637744426-22044-1-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1637744426-22044-1-git-send-email-yangtiezhu@loongson.cn>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 24 Nov 2021 12:50:49 -0800
Message-ID: <CAEf4BzYGHczJ6xejqGnf8LrbCdF1P9dnD6uC5tmJTm+KDRbGGA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf, mips: Fix build errors about __NR_bpf undeclared
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 1:00 AM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
>
> Add the __NR_bpf definitions to fix the following build errors for mips.
>
>  $ cd tools/bpf/bpftool
>  $ make
>  [...]
>  bpf.c:54:4: error: #error __NR_bpf not defined. libbpf does not support =
your arch.
>   #  error __NR_bpf not defined. libbpf does not support your arch.
>      ^~~~~
>  bpf.c: In function =E2=80=98sys_bpf=E2=80=99:
>  bpf.c:66:17: error: =E2=80=98__NR_bpf=E2=80=99 undeclared (first use in =
this function); did you mean =E2=80=98__NR_brk=E2=80=99?
>    return syscall(__NR_bpf, cmd, attr, size);
>                   ^~~~~~~~
>                   __NR_brk
>  [...]
>  In file included from gen_loader.c:15:0:
>  skel_internal.h: In function =E2=80=98skel_sys_bpf=E2=80=99:
>  skel_internal.h:53:17: error: =E2=80=98__NR_bpf=E2=80=99 undeclared (fir=
st use in this function); did you mean =E2=80=98__NR_brk=E2=80=99?
>    return syscall(__NR_bpf, cmd, attr, size);
>                   ^~~~~~~~
>                   __NR_brk
>
> We can see the following generated definitions:
>
>  $ grep -r "#define __NR_bpf" arch/mips
>  arch/mips/include/generated/uapi/asm/unistd_o32.h:#define __NR_bpf (__NR=
_Linux + 355)
>  arch/mips/include/generated/uapi/asm/unistd_n64.h:#define __NR_bpf (__NR=
_Linux + 315)
>  arch/mips/include/generated/uapi/asm/unistd_n32.h:#define __NR_bpf (__NR=
_Linux + 319)
>
> So use the GCC pre-defined macro _ABIO32, _ABIN32 and _ABI64 [1] to defin=
e
> the corresponding __NR_bpf.
>
> This patch is similar with commit bad1926dd2f6 ("bpf, s390: fix build for
> libbpf and selftest suite").
>
> [1] https://gcc.gnu.org/git/?p=3Dgcc.git;a=3Dblob;f=3Dgcc/config/mips/mip=
s.h#l549
>
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>  tools/build/feature/test-bpf.c |  6 ++++++
>  tools/lib/bpf/bpf.c            |  6 ++++++
>  tools/lib/bpf/skel_internal.h  | 10 ++++++++++
>  3 files changed, 22 insertions(+)
>
> diff --git a/tools/build/feature/test-bpf.c b/tools/build/feature/test-bp=
f.c
> index 82070ea..ebc7a2a 100644
> --- a/tools/build/feature/test-bpf.c
> +++ b/tools/build/feature/test-bpf.c
> @@ -14,6 +14,12 @@
>  #  define __NR_bpf 349
>  # elif defined(__s390__)
>  #  define __NR_bpf 351
> +# elif defined(__mips__) && defined(_ABIO32)
> +#  define __NR_bpf (__NR_Linux + 355)
> +# elif defined(__mips__) && defined(_ABIN32)
> +#  define __NR_bpf (__NR_Linux + 319)
> +# elif defined(__mips__) && defined(_ABI64)
> +#  define __NR_bpf (__NR_Linux + 315)

Is it possible to use a final number without __NR_Linux? All the other
cases have final numbers, no relative numbers

>  # else
>  #  error __NR_bpf not defined. libbpf does not support your arch.
>  # endif
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 94560ba..60422404 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -50,6 +50,12 @@
>  #  define __NR_bpf 351
>  # elif defined(__arc__)
>  #  define __NR_bpf 280
> +# elif defined(__mips__) && defined(_ABIO32)
> +#  define __NR_bpf (__NR_Linux + 355)
> +# elif defined(__mips__) && defined(_ABIN32)
> +#  define __NR_bpf (__NR_Linux + 319)
> +# elif defined(__mips__) && defined(_ABI64)
> +#  define __NR_bpf (__NR_Linux + 315)
>  # else
>  #  error __NR_bpf not defined. libbpf does not support your arch.
>  # endif
> diff --git a/tools/lib/bpf/skel_internal.h b/tools/lib/bpf/skel_internal.=
h
> index 9cf6670..6ff4939 100644
> --- a/tools/lib/bpf/skel_internal.h
> +++ b/tools/lib/bpf/skel_internal.h
> @@ -7,6 +7,16 @@
>  #include <sys/syscall.h>
>  #include <sys/mman.h>
>
> +#ifndef __NR_bpf
> +# if defined(__mips__) && defined(_ABIO32)
> +#  define __NR_bpf (__NR_Linux + 355)
> +# elif defined(__mips__) && defined(_ABIN32)
> +#  define __NR_bpf (__NR_Linux + 319)
> +# elif defined(__mips__) && defined(_ABI64)
> +#  define __NR_bpf (__NR_Linux + 315)
> +# endif
> +#endif
> +
>  /* This file is a base header for auto-generated *.lskel.h files.
>   * Its contents will change and may become part of auto-generation in th=
e future.
>   *
> --
> 2.1.0
>
