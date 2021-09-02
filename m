Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1B93FF7AE
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 01:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbhIBXOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 19:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347637AbhIBXOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 19:14:23 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E5DC061575;
        Thu,  2 Sep 2021 16:13:24 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id k65so6853635yba.13;
        Thu, 02 Sep 2021 16:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6dFKGr/2WluI1Yoat7MTaAsQXMDVWPIUBERS4Y0t7LM=;
        b=Pmvzm7vMO0EeZagBwjpMMvEYxphc8f101uawA4a/bdJcDJnVY5klMN/S9ojmIJnZ+H
         2u1Ij0x53DKjhK8lEogxOvA1GGU9KI9vXbC/aQ0cvU9gipoO+TH9JC7M0zkdoxJJsw/V
         kx6io3KT0aBCWkwFHv/1/SaMKB9lyYylqAUPcaR8ae/k/GqbHhDtewZeOlNV6gCjdEWj
         PGvFzZJo5MoiNqd4F7dJiqNSKtDlYtCkFe1srOc+jE/qcJLknNvd+G25YXpLWHBB4LwB
         wAnqF+sZful0+b+7U9woHGV4TqE6MRiLplRQ0DbKAPL8e8ygJCNDPqbmn9OFmlJk9LRh
         xBsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6dFKGr/2WluI1Yoat7MTaAsQXMDVWPIUBERS4Y0t7LM=;
        b=RflkwWFuzFqnQLMJtw1Wv2bc3EYS2vagCxz1niXZ2xFx5oxMl2ud+li0b6J4W+Nxc1
         ggAfw9TVcChDgzDEM44isolAoUCQqYlODRSBHVyjlfW9rOPlpgqEARz/Vb32Bfg4P9LF
         BKn/9l70u1n4BAFys1FjOmB7rgxM7aAcJgUddQedrTEDSpO7KxqoL9oZ3KPQzoW3bW0l
         wtq0wV9Ho86AdxYI5Y00CLdcwtGiyjYAztQnxX982rMVFgaVkxRI3cQgdWHqgdc5otnZ
         dtYZ+WIYoEBxMkL1Co1FZjXdwUv0s3zsIMWEWhvFpclOLqOzxo+PIXUNsaHcNyGUlsJg
         056Q==
X-Gm-Message-State: AOAM531FE6/hvW3cpAyvJ1HBCDPVvOMGZdNUWjbLrHFCWDN587kNrR3O
        S4ezGSlifkrN/Psdx1VyMqIEEGsArWGQQ63SuYc=
X-Google-Smtp-Source: ABdhPJwh/w451EzUqvqtvv90VaE65ZHD+duYHbMw/DdomRLUpbFAZmKZDaBArcLo0aeMruoLcWCr4/xBgJZXtVC+Dao=
X-Received: by 2002:a25:4941:: with SMTP id w62mr1154271yba.230.1630624404057;
 Thu, 02 Sep 2021 16:13:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210902171929.3922667-1-davemarchevsky@fb.com> <20210902171929.3922667-9-davemarchevsky@fb.com>
In-Reply-To: <20210902171929.3922667-9-davemarchevsky@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 2 Sep 2021 16:13:13 -0700
Message-ID: <CAEf4BzZ-jrjfMZKFt4vrvfgNqFJG3j5HuCKB4zOGJgD6iU7NOA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 8/9] selftests/bpf: add trace_vprintk test prog
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 10:23 AM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> This commit adds a test prog for vprintk which confirms that:
>   * bpf_trace_vprintk is writing to dmesg

But it doesn't write to dmesg, does it? It's writing to
/sys/kernel/debug/tracing/trace_pipe, which is a different thing
entirely, right?

>   * __bpf_vprintk macro works as expected
>   * >3 args are printed
>
> Approach and code are borrowed from trace_printk test.
>
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  tools/testing/selftests/bpf/Makefile          |  3 +-
>  .../selftests/bpf/prog_tests/trace_vprintk.c  | 65 +++++++++++++++++++
>  .../selftests/bpf/progs/trace_vprintk.c       | 25 +++++++
>  3 files changed, 92 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_vprintk.c
>  create mode 100644 tools/testing/selftests/bpf/progs/trace_vprintk.c
>

[...]
