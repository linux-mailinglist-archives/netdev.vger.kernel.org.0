Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D26541A709
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 07:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbhI1F0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 01:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234177AbhI1F0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 01:26:23 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB50C061575;
        Mon, 27 Sep 2021 22:24:44 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id u32so8439050ybd.9;
        Mon, 27 Sep 2021 22:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v3NEK8pPEgXFEQ4ELQDWncywX9Rjl1R3L1/HQjl3gew=;
        b=m6752IA5QJA6vatmMChf/VuIfoiGB64b3cz0wfsXyLH8lnN8H/49bCjXaAu4AJGmco
         Em+mx5Cn9bKiC7Sd8o/53y09xrbvo5SkXWik6DxdBY5MiKpC9PHy4nFRJAySuAeyxmH9
         LSb8aR6mPZbSgGKcu4E+1cHDY3JWJ5nyI92I8SbZIR40QmRji/a3/iJyglIryLPhY/z1
         YRg/7JN2A/nV8/fwZif7CkTBiWfwbD5HF3PpI/QSOXGyUi7noJMq421wYuBdXrbtWXtj
         X2oTE0eEgDe3NT4WMdnjcuzy4WaIuY93wqN/QgwiK2snjGctAZ/XyPQyGIXq8SxIQsB5
         EG0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v3NEK8pPEgXFEQ4ELQDWncywX9Rjl1R3L1/HQjl3gew=;
        b=5vseAXFLpiClturVYH5ofNl7BOdflugj77hPHQ1CmM7GKzAmayU07AiMAPGZUJMT2j
         Y7nbCZsrZp2YIAL0mZnS/xmNA7RQaHQoADpK+LQ0io2ohb0yX4j5+/q68kErXujCM4bO
         UrHQ7BSb67vrzuETaPv4UzHYr9tIxvJ052epZPkzxxqL6t0m90kj3U/U3tG9O8v9aM7+
         j2/cO3T2xziRX5zBCFN8i5ZHQNe0NJNEkae9AKNj8vJ2HnQn0U/3Mr/qJiDmiUHV5YM0
         jl66e4QGMKVHWGngCtWLeAcynE514wb2ceyiF87sKVjtShZUgLSRKnw4yC8lCjmjN7mn
         SAXQ==
X-Gm-Message-State: AOAM531PWqsClRlBXs9hyzzeSe40rjQeleN26xn8V9M8oxPPdoHVAedj
        5L/PO22EnsV0hkwkM/QifX7UrVhcHDQD6zxwWhI=
X-Google-Smtp-Source: ABdhPJwAFGx76qmz0A/PqtRX5vtKX0x9+TFOdc1krGsTa3S/Foz/uJUyYGX5DlAO5Yg4MqrMiMMMBZfXe1I9HzvRKpI=
X-Received: by 2002:a25:1dc4:: with SMTP id d187mr2647041ybd.455.1632806683740;
 Mon, 27 Sep 2021 22:24:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210927182700.2980499-1-keescook@chromium.org>
In-Reply-To: <20210927182700.2980499-1-keescook@chromium.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Sep 2021 22:24:32 -0700
Message-ID: <CAEf4Bzb46=-J5Fxc3mMZ8JQPtK1uoE0q6+g6WPz53Cvx=CBEhw@mail.gmail.com>
Subject: Re: [PATCH 0/2] bpf: Build with -Wcast-function-type
To:     Kees Cook <keescook@chromium.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 11:27 AM Kees Cook <keescook@chromium.org> wrote:
>
> Hi,
>
> In order to keep ahead of cases in the kernel where Control Flow Integrity
> (CFI) may trip over function call casts, enabling -Wcast-function-type
> is helpful. To that end, replace BPF_CAST_CALL() as it triggers warnings
> with this option and is now one of the last places in the kernel in need
> of fixing.
>
> Thanks,
>
> -Kees
>
> Kees Cook (2):
>   bpf: Replace "want address" users of BPF_CAST_CALL with BPF_CALL_IMM
>   bpf: Replace callers of BPF_CAST_CALL with proper function typedef
>

Both patches look good to me. For the series:

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  include/linux/bpf.h    |  4 +++-
>  include/linux/filter.h |  7 +++----
>  kernel/bpf/arraymap.c  |  7 +++----
>  kernel/bpf/hashtab.c   | 13 ++++++-------
>  kernel/bpf/helpers.c   |  5 ++---
>  kernel/bpf/verifier.c  | 26 +++++++++-----------------
>  6 files changed, 26 insertions(+), 36 deletions(-)
>
> --
> 2.30.2
>
