Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98725453957
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 19:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239406AbhKPSYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 13:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239400AbhKPSY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 13:24:28 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509C7C061570;
        Tue, 16 Nov 2021 10:21:31 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id y68so54854985ybe.1;
        Tue, 16 Nov 2021 10:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cJYcvBRlxencL1QuT8wtPHz9c1IHoV/swUV2N7c4Fbg=;
        b=Zqfxcye2w4sp8vm8MZzyONAjI6jjTILR2e6urkXZ/yMIbl1K/49BFS43iwRivgNj5S
         g5QEAhMsTH4bSS4IIvdjmOofkWWdeqsbzzQhf7rqW3Q7mPAz9O65Y50iYPe5+YYaYgBL
         0sMmMnUkM53fI1j6ksP38N/wiI6pEuKY7eiAKQ0MDRPK8rRaYPi1vuCz7M8HvdO3st3c
         Ydb/WJJTW39TOERsa/zaUJ7/aoSUGs1Fwd1aBtcjkQSw0N/V2MHr/dSPJ9mo1LAANoAc
         cX15ditnm9Wnlwurr1bXV33d+TMKA0+WCqeEHV17yGm26f+6zKD6Ref1ldVd+YJDG7ys
         4j3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cJYcvBRlxencL1QuT8wtPHz9c1IHoV/swUV2N7c4Fbg=;
        b=50JyASWynmi8lW6oxQ6tcXjlCUnFraKVdlxQjUaHVItzlY5HPZqszWeTtRLPPBPfkE
         dQCff4UiBuCzmb9WBeN3yjCsAC+ARgGhp0+JNicAP6bjfEQVK62IOlNBn79FJzeV8QhF
         1nqCTyEl33vc6hM+LZtKcbxH4VJH+UbjJnuSb3My9Zvzh36BGTGVqAmKDHUYIHsnzvuc
         YxYaE0sGiySwUSekbmh8fKad8vDxb7ay2QGjWcJbCuZgk25xgokO+Rfz91WI/e0J6nKq
         lw2QwR67b2SqLhGvjRb/h1CGQmwnHrndO0RJJjsQ0XpFBMt2Njzcm04/Rt/uolssPBGb
         w4QQ==
X-Gm-Message-State: AOAM533gbWmQ98gt2s2XDT7t67VgaUCoEKhJ1O9702U2/z1x5c3+n+WY
        0gZaZ2W11ZA1MKc0IYsf5JEu2mJkDDScg08BEic=
X-Google-Smtp-Source: ABdhPJx4ORrkmRdky4w3AuasGzVKGGyGqc5szOr+0p/deWht8f7yaVhCy9UHiJm6q95V1Abdbn0bF1mR97gXYiE0BtQ=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr10518308ybj.504.1637086890557;
 Tue, 16 Nov 2021 10:21:30 -0800 (PST)
MIME-Version: 1.0
References: <YZPQ6+u2wTHRfR+W@kernel.org>
In-Reply-To: <YZPQ6+u2wTHRfR+W@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 16 Nov 2021 10:21:19 -0800
Message-ID: <CAEf4BzbOnpL-=2Xi1DOheUtzc-JG5FmHqdvs4B_+0OeaCTgY=w@mail.gmail.com>
Subject: Re: [PATCH 1/1] Documentation: Add minimum pahole version
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@redhat.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 7:40 AM Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
>
> A report was made in https://github.com/acmel/dwarves/issues/26 about
> pahole not being listed in the process/changes.rst file as being needed
> for building the kernel, address that.
>
> Link: https://github.com/acmel/dwarves/issues/26
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: bpf@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  Documentation/process/changes.rst | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/Documentation/process/changes.rst b/Documentation/process/changes.rst
> index e35ab74a0f804b04..c45f167a1b6c02a4 100644
> --- a/Documentation/process/changes.rst
> +++ b/Documentation/process/changes.rst
> @@ -35,6 +35,7 @@ GNU make               3.81             make --version
>  binutils               2.23             ld -v
>  flex                   2.5.35           flex --version
>  bison                  2.0              bison --version
> +pahole                 1.16             pahole --version
>  util-linux             2.10o            fdformat --version
>  kmod                   13               depmod -V
>  e2fsprogs              1.41.4           e2fsck -V
> @@ -108,6 +109,14 @@ Bison
>  Since Linux 4.16, the build system generates parsers
>  during build.  This requires bison 2.0 or later.
>
> +pahole:
> +-------
> +
> +Since Linux 5.2 the build system generates BTF (BPF Type Format) from DWARF in
> +vmlinux, a bit later from kernel modules as well, if CONFIG_DEBUG_INFO_BTF is

I'd probably emphasize a bit more that pahole is required only if
CONFIG_DEBUG_INFO_BTF is selected by moving "If CONFIG_DEBUG_INFO_BTF
is selected, " to the front. But either way looks good.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> +selected.  This requires pahole v1.16 or later. It is found in the 'dwarves' or
> +'pahole' distro packages or from https://fedorapeople.org/~acme/dwarves/.
> +
>  Perl
>  ----
>
> --
> 2.31.1
>
