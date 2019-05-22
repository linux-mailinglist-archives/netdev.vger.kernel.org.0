Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1FA25B36
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 02:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbfEVAiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 20:38:06 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37326 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfEVAiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 20:38:05 -0400
Received: by mail-qt1-f196.google.com with SMTP id o7so379462qtp.4;
        Tue, 21 May 2019 17:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aCN5Z2fbvfWHTkICyJ7D/kcJhAxlIX0lx7NkRbDxURU=;
        b=CMM+B6Uk/j/A12QbPj9IcPA/vkLXIGtxqQgiCkAWIPCmZTBRsbtZY9nYTvKjANO7V1
         jvvCnIxfthNg+VLbkvMlMexGFkRwdlarPgT4RH5xsYOP+8x0cUhRB608HKYIm+5gq1IT
         7ZQHCY4MajgZxkJWFP6cKTk/3G0Oyaj4uFMFF8hRcMXjTyVt96GP0PPDndXtDhNSiTY3
         r5QtDUhhW4hR8kvan0AE0merF8SvQUW81z1bbAm8qMevBU16P5G+Tpq8YAd91OgXgCmM
         3+wVXs7swjGtRi5aC9zv28PS/Pc8CxPepPmJqv+cp+rUwiONZHWZadX1LDuJo6jorYhv
         KXuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aCN5Z2fbvfWHTkICyJ7D/kcJhAxlIX0lx7NkRbDxURU=;
        b=cmb0IYsIEWN7qIRvW06+m+hlIfT9Tai3aBtIYi9XTtGFcogNujBGs2HaYWM3LVLT0q
         SelLXTYDnbImcMlLfq7a8Zj9AnPa6IbxDoEIY3VSKBQpN2+x1Jco9VbPMLziOxfLr2BY
         QuOp7ZjP+/XC9whD7yPI5zvy9X+bM/O7POldQRmzovSzyu+GIAy3TuyrEtPk/wTdbb1N
         mmP0xGOB9alCMevd2TZtIFdRgDKp/lj7gxarQqBr2yFVH8NzBiwjI2NOd8mkUAl9uydb
         OKglXEN+25CfKJMsd4x0BASngDilp+K4WrbeS9YD+uQIJq80Ozvqv/yc/ZyHL4ZPnesc
         QTBQ==
X-Gm-Message-State: APjAAAVNCpcrUE8FNExmHjsk5Q4bHnbMHC32C7R7aHpxM2qwX9ZUcBif
        lrL3qEOxUwCB8pacLCk2I4hhLqznTumNQjfFcnY=
X-Google-Smtp-Source: APXvYqwJydAqZoDpZ2yRpS+PG/4rQhAv3iMma2iiAci+w++T25GVMY3FUFRcoOr3XR5MAKdJFJs31ZyMkigh/b4jlcc=
X-Received: by 2002:ac8:30d3:: with SMTP id w19mr69801997qta.171.1558485484896;
 Tue, 21 May 2019 17:38:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190521230939.2149151-1-ast@kernel.org>
In-Reply-To: <20190521230939.2149151-1-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 21 May 2019 17:37:53 -0700
Message-ID: <CAEf4BzYuQec_Xuni2w-wYt=4HYpGZPVTudHUAQ=-uLiDn7Z_=g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] bpf: increase jmp sequence limit
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     davem@davemloft.net, Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 4:09 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Patch 1 - jmp sequence limit
> Patch 2 - improve existing tests
> Patch 3 - add pyperf-based realistic bpf program that takes advantage
> of higher limit and use it as a stress test

Some minor nits for patch #3, but other than that, for the series:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>
> Alexei Starovoitov (3):
>   bpf: bump jmp sequence limit
>   selftests/bpf: adjust verifier scale test
>   selftests/bpf: add pyperf scale test
>
>  kernel/bpf/verifier.c                         |   7 +-
>  .../bpf/prog_tests/bpf_verif_scale.c          |  31 +-
>  tools/testing/selftests/bpf/progs/pyperf.h    | 268 ++++++++++++++++++
>  tools/testing/selftests/bpf/progs/pyperf100.c |   4 +
>  tools/testing/selftests/bpf/progs/pyperf180.c |   4 +
>  tools/testing/selftests/bpf/progs/pyperf50.c  |   4 +
>  tools/testing/selftests/bpf/test_verifier.c   |  31 +-
>  7 files changed, 319 insertions(+), 30 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/pyperf.h
>  create mode 100644 tools/testing/selftests/bpf/progs/pyperf100.c
>  create mode 100644 tools/testing/selftests/bpf/progs/pyperf180.c
>  create mode 100644 tools/testing/selftests/bpf/progs/pyperf50.c
>
> --
> 2.20.0
>
