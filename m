Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7183FBFE0
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 02:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239173AbhHaAF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 20:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238942AbhHaAF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 20:05:56 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9968C061575;
        Mon, 30 Aug 2021 17:05:02 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id n126so31517835ybf.6;
        Mon, 30 Aug 2021 17:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I92bDn3KIfMyzXSY1mW0u96kduCF2pq8q/XxJ8KMWY8=;
        b=u+Uh0ugNTLRN8YFquwSv+5XclIlxz8/AMGmYyiafni1lPVl+Lu4ZljUMu3CaRXMrFz
         Xwhf4wvyno+0vmX8ylq8FCP85EakOCDRyQH84DLXHOuX5JcVMJDrARsJL34HMfHXNVCh
         mvj1I6RDN71Himy3Qgh4lEqRJEm74Pz4aCuFq0RtJue1ZzMKMrR6F82OI02vbTnnSnLr
         jvENzTxzYUnyoDJ17sI9qSvsDMYqmmx53/emfnH16juQ5iBnKj3gDsc3tysRjS9gEtl1
         yzxjOr339EtEVSGcvYMK1M90S17g4UmCffD5u4BZa/d8gbZPMrU6wn2h3bLkX5VEuNpI
         5Plw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I92bDn3KIfMyzXSY1mW0u96kduCF2pq8q/XxJ8KMWY8=;
        b=fZ8BJCGvyxAFAvQSqBKmD2u04LYMnXhjMcBOXtiiImx3g9raBITMta1boIUba5zX2I
         P9Y3rrWVHwEF1BXK4XLTUYAN796C90ii/PtxhOy9SzaUogDVmU7rxk/a9JaOzVJSfy0m
         CKqi2t+tRLtM3PfRFQIU6LiIjuraNSCRUs8AEy7V1rSh6GvZKgyZ6XWdKiOE4eAVjKvq
         LsA2j1WtlqzgeWr4IrlvAy/sdq6xPr2XyDs7HB2Tm3oOsw2cck9BAn9Q6ClWSe3PHjc7
         sCJOdNDSanuZAhePTUh2FtMUZQvFUBKInylUJDYX4Ltytw5kw75cLphy6REacH0Yefhi
         0RUQ==
X-Gm-Message-State: AOAM531OMmOBj42apQXvq5YBVv4dpLcYlo15qadZpUto8VrUIlh4OaPm
        x04Ol3KqSDp8NeIKAtsiFZX+kA+OX9vEc56JHKo=
X-Google-Smtp-Source: ABdhPJzr3w4Mw+ho8t7ExzR7rist9GGMc9Xzfsz09lAOw2TrVB1P41zqlHezhv3KmyVwyvKbW3Jkj+an5jGkbbSLg00=
X-Received: by 2002:a25:bb13:: with SMTP id z19mr28075920ybg.347.1630368302072;
 Mon, 30 Aug 2021 17:05:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210828052006.1313788-1-davemarchevsky@fb.com> <20210828052006.1313788-8-davemarchevsky@fb.com>
In-Reply-To: <20210828052006.1313788-8-davemarchevsky@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Aug 2021 17:04:51 -0700
Message-ID: <CAEf4BzaZmtmtcS0g36o0CW9MkQ1UQ1qpo_8LWQj_-Tw2gk6qKA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 7/7] selftests/bpf: add trace_vprintk test prog
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 10:20 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> This commit adds a test prog for vprintk which confirms that:
>   * bpf_trace_vprintk is writing to dmesg
>   * __bpf_vprintk macro works as expected
>   * >3 args are printed
>
> Approach and code are borrowed from trace_printk test.
>
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/testing/selftests/bpf/Makefile          |  3 +-
>  .../selftests/bpf/prog_tests/trace_vprintk.c  | 65 +++++++++++++++++++
>  .../selftests/bpf/progs/trace_vprintk.c       | 25 +++++++
>  3 files changed, 92 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_vprintk.c
>  create mode 100644 tools/testing/selftests/bpf/progs/trace_vprintk.c
>

[...]
