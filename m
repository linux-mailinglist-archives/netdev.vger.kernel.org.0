Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944E52061F2
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404122AbgFWUwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403908AbgFWUwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:52:36 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10B2C061573;
        Tue, 23 Jun 2020 13:52:35 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id 80so8351645qko.7;
        Tue, 23 Jun 2020 13:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6jp0ubT0ytXPNlZ+kvpMhbKPSShNoZWoDASuHeV3U4w=;
        b=HeVDeJEedkTT34Y6u0qDxY68f7PJE43gZ9KGfchNkNzJDbI0BlurtccYR2wakUH1sq
         XiOoEPVZCcY//cTh/UXLaQlNGBUs5vxjgXMZNLx1IHQhrT9ZSE071hGoy4AkwGIkvbhv
         5wWcJlNROMPvCve+XQYU6erv1qM54m7f8ojQKs4COxRhfh/LWAok8M3ysxwNqWAhq9z5
         0bSf4iMsuaVunMTxUrXMYjWdtMFciUrmTahRgyttOpf+WhH6xtzXSkVeR7pl3XtCVngn
         o29rDmIJfXqGTw6iOb2tw1G2k/NjyG3KAKA0TYXW41Qhkq9GId4YyhKcCAtSzAyoQool
         R4pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6jp0ubT0ytXPNlZ+kvpMhbKPSShNoZWoDASuHeV3U4w=;
        b=LhcZbjtlAjSlfWGMbiJP26NjdQAl+FoU71XZPD5DKsWCd9l2cbtPQ2ouB4rCn02YGf
         pWKKsCdk/81HCx5s7qhyaadUEv6gE2k+HjJ3ZVQ/5En75yqmBxfPP1YqlofdKhywMHw1
         6pVe0JmEHLYJ1NO743ESsko5QgQ1cWBk1V3eF7Z1A9KWSirqgBNgGIjZpH1W+IqQjM2b
         ZWzp6CQDK/zhsRrnhQeO1ySLTbPRwZnKhqWwVfqqkdguTAXCKQ4v4h2l3jGiCZmq69wV
         3FHpR/4rJiBRkWCgeM7VydMmd2npkgcyn7Dcnj9fU/bfwOJ7aRwJaeVgyMJj8YH/Koxf
         KPig==
X-Gm-Message-State: AOAM532pBGnL0DPOFt7IJORWLCv6pZhuPmyDzbnCL06UtyEM6uMOgZRU
        m0l4VRn+ZJn+CS+rnZVW56MQBiMG6yHyLNZ9F2w=
X-Google-Smtp-Source: ABdhPJyI+9nIuV13mzQT+cdNrzFc6mevg13NB61n79/IEPnHwoiN5Vj16C3X3vAbnosJ/LeVulJEkprhQ4zPSlJNuoA=
X-Received: by 2002:a37:d0b:: with SMTP id 11mr23572611qkn.449.1592945554997;
 Tue, 23 Jun 2020 13:52:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200623032224.4020118-1-andriin@fb.com> <20200623032224.4020118-2-andriin@fb.com>
 <7ed6ada5-2539-3090-0db7-0f65b67e4699@iogearbox.net>
In-Reply-To: <7ed6ada5-2539-3090-0db7-0f65b67e4699@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jun 2020 13:52:24 -0700
Message-ID: <CAEf4BzbsRyt5Y4-oMaKTUNu_ijnRD09+WW3iA+bfGLZcLpd77w@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/3] selftests/bpf: add variable-length data
 concatenation pattern test
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 1:39 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Hey Andrii,
>
> On 6/23/20 5:22 AM, Andrii Nakryiko wrote:
> > Add selftest that validates variable-length data reading and concatentation
> > with one big shared data array. This is a common pattern in production use for
> > monitoring and tracing applications, that potentially can read a lot of data,
> > but overall read much less. Such pattern allows to determine precisely what
> > amount of data needs to be sent over perfbuf/ringbuf and maximize efficiency.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Currently getting the below errors on these tests. My last clang/llvm git build
> is on 4676cf444ea2 ("[Clang] Skip adding begin source location for PragmaLoopHint'd
> loop when[...]"):
>

Yeah, you need 02553b91da5d ("bpf: bpf_probe_read_kernel_str() has to
return amount of data read on success") from bpf tree.

I'm eagerly awaiting bpf being merged into bpf-next :)

> # ./test_progs -t varlen
> test_varlen:PASS:skel_open 0 nsec
> test_varlen:PASS:skel_attach 0 nsec
> test_varlen:FAIL:check got 0 != exp 8
> test_varlen:FAIL:check got 0 != exp 7
> test_varlen:FAIL:check got 0 != exp 15
> test_varlen:FAIL:content_check doesn't match!test_varlen:FAIL:check got 0 != exp 8
> test_varlen:FAIL:check got 0 != exp 7
> test_varlen:FAIL:check got 0 != exp 15
> test_varlen:FAIL:content_check doesn't match!test_varlen:FAIL:check got 0 != exp 8
> test_varlen:FAIL:check got 0 != exp 7
> test_varlen:FAIL:check got 0 != exp 15
> test_varlen:FAIL:content_check doesn't match!test_varlen:FAIL:check got 0 != exp 8
> test_varlen:FAIL:check got 0 != exp 7
> test_varlen:FAIL:check got 0 != exp 15
> test_varlen:FAIL:content_check doesn't match!
> #87 varlen:FAIL
> Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
>
> # ./test_progs-no_alu32 -t varlen
> Switching to flavor 'no_alu32' subdirectory...
> test_varlen:PASS:skel_open 0 nsec
> test_varlen:PASS:skel_attach 0 nsec
> test_varlen:FAIL:check got 0 != exp 8
> test_varlen:FAIL:check got 0 != exp 7
> test_varlen:FAIL:check got 0 != exp 15
> test_varlen:FAIL:content_check doesn't match!test_varlen:FAIL:check got 0 != exp 8
> test_varlen:FAIL:check got 0 != exp 7
> test_varlen:FAIL:check got 0 != exp 15
> test_varlen:FAIL:content_check doesn't match!test_varlen:FAIL:check got 0 != exp 8
> test_varlen:FAIL:check got 0 != exp 7
> test_varlen:FAIL:check got 0 != exp 15
> test_varlen:FAIL:content_check doesn't match!test_varlen:FAIL:check got 0 != exp 8
> test_varlen:FAIL:check got 0 != exp 7
> test_varlen:FAIL:check got 0 != exp 15
> test_varlen:FAIL:content_check doesn't match!
> #87 varlen:FAIL
> Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
>
> Thanks,
> Daniel
