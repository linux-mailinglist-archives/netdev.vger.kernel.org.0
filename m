Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B627286B40
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 00:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgJGWuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 18:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgJGWuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 18:50:50 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D475C061755;
        Wed,  7 Oct 2020 15:50:49 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id a2so3089394ybj.2;
        Wed, 07 Oct 2020 15:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8auL7BlLpZwNGFy4TVlksOEwt9gszvZuRk/pdniRQIc=;
        b=K02g3nQInuRSEntRE/EcbNVbhrweWkSgci4CXBtWBJ3tCBwi+ACl3nOrDie6t1FE3H
         O81ZgMSdLgWEpPrblbMaXUVDM00T3cr7xBRkxR17BVRzu5iGAjo5yYuEkXFNtk8ZOgeB
         rVk9d/62E/OgIhqZT1KPnNa2KdKgFrOJaIKHM1PF+FI3h/EorH1/FwIaBLiYXA2QH2c4
         OteUo32f4uOMhH6utjAIS6i8OGZGbqK1GeNjczuH5eWhWAYwzHFI7TieJLqHY4tsZjLg
         u7y1IFwr5DiwXeCtiAuiiUyty9T7h8T5pzmEkP7CMyvb2AM2g8I5ICl8W+yvQfVjCaIf
         edag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8auL7BlLpZwNGFy4TVlksOEwt9gszvZuRk/pdniRQIc=;
        b=q0TIbrHlt68Mw3WzwPxdxCqzsQbSfN7EjFnOYC1caGJtaJD0OYxQun62c94+DI/9D3
         fdPpbKNqIrvH9r6n4otU4rr/GIIg+sGw8wkLpwtYT0sS2rYDzhtXIrCXf/sp/FhCG5M2
         2CsUCxk1CRDV3KytxIXD/r4dURLfgqpcJmMgDK1XQSxDqFo8jx+PNrAjYNZDh7KqshGw
         AKPX8qg1NF6mFvOEnI2jJ6AXPUxst6aW6PrstEucO2o2vBkeZKgWX9g5isfSOiX619/s
         0qudQStwbB0qWFaoJhVF3ut9zaW7n6e976Hq2m7UYpHSYvxdoNrSYJNNTJgkvjKjeL1I
         Vz0A==
X-Gm-Message-State: AOAM532T3flvprRDnFGTaWOpOxnEKm3/NuC0IDGBFONugebKE4df6T4a
        HUFy1M9YCwTbWv1WTZNd1otCH5k5rhT6mVbcu/Q=
X-Google-Smtp-Source: ABdhPJxSuhYfbeyxoKvCvNJG61AnWM/ZK0KHbWNmekd7aP31Xgj25uOGzGm1He32B6wK7cKNZJ8i9NjkFA1Lz8Dlo1Q=
X-Received: by 2002:a25:2596:: with SMTP id l144mr7080323ybl.510.1602111048702;
 Wed, 07 Oct 2020 15:50:48 -0700 (PDT)
MIME-Version: 1.0
References: <20201007222734.93364-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20201007222734.93364-1-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Oct 2020 15:50:37 -0700
Message-ID: <CAEf4BzaHuHAcjfnNvBKzxgdjY3DpSsiVKJUXEjp7mg=WL--Bzw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Additional asm tests for the
 verifier regalloc tracking.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 7, 2020 at 3:28 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Add asm tests for register allocator tracking logic implemented in the patches:
> https://lore.kernel.org/bpf/20201006200955.12350-1-alexei.starovoitov@gmail.com/T/#t
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

I actually read through that assembly :) LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  .../testing/selftests/bpf/verifier/regalloc.c | 159 ++++++++++++++++++
>  1 file changed, 159 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/verifier/regalloc.c
>

[...]
