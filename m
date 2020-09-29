Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F73E27BC1B
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 06:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbgI2EfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 00:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgI2EfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 00:35:04 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1567C061755;
        Mon, 28 Sep 2020 21:35:03 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id b12so3888416lfp.9;
        Mon, 28 Sep 2020 21:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gjeJyyE8PC7GfPzcN4PQWzjypUXN1n7OcjUJtTFiY5U=;
        b=uws9czqlJkhrE+bsInmIXL24QeIejlQD4BDubD2OrvM6D982Wr0cotIBBg5clCe2jn
         w1+KF1vwRJ+M6/eBX+N9x+eGe/WJI9GArGiuQjdb77T53zM2ck83vkX18LKzeQLb8C0T
         W703wbGkL/7OwvAsBvcc5n02SmNa15pVeIP2YHsEYdikhg1FNidMgL4VuYQc2667LW0c
         QPY7dM43YUwWBhyc1WZBfQgwlJwoSwcDuTjwVwLYRWk6MDwRe0xqzB9Q3mGsmwxUfqpy
         BxwkpgzuumqHjxoUdTZSAoq5S0oyYMANpFtL3GxivnkQlqMW9XlsJKRjCl0XCkhG2MKx
         3bnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gjeJyyE8PC7GfPzcN4PQWzjypUXN1n7OcjUJtTFiY5U=;
        b=OlaBhTBX0pKrKNhmmpzPlQvNqFaeLZVIyFTZ2KOZoGCVlJfKBaqDgOGXzrsij8i7GP
         B3HKb27rtfSvCd0xyi4Pv561zNf6zG9XRNZlpUssG5Bu4+1ymjrdQVma0TW2j1ck9f+w
         jF5ET8icuNhju92tHS/YkDZe7UBasJO0D6lVQGkWTBJ3SQbp6m8IcnfaLRxOCiJEOr73
         lK8MPhIyhvnodU3O/WpwIvmdtSEiPMqhqW3GsGggUDR6kC1lB3zJOjBUCILtUlT+Q+uC
         o1XYDx5cgNk3ZYVyahKrpSUN9iIQLp+bqyDvTs+PW0hgmIfzdJvGmrBpxKboD5ivRPBa
         xJ3g==
X-Gm-Message-State: AOAM5322cM8yZrIkITdmFKX30TZ7Xte1ufKOlM1YtPsj7bIhsahepe/C
        61b+YArWBQDHvg/O+nTzAXSvVMAEf8pmPuACn1w=
X-Google-Smtp-Source: ABdhPJxrHjpkXLv75U/Xklioz9uKhO5tQ3M+xRO/iodPJ6qNxkuDd4jcochQ6LJ7Dd+BAiIzNWy1kTPATTwFNWAtAEY=
X-Received: by 2002:a19:df53:: with SMTP id q19mr471107lfj.119.1601354101576;
 Mon, 28 Sep 2020 21:35:01 -0700 (PDT)
MIME-Version: 1.0
References: <160134424745.11199.13841922833336698133.stgit@john-Precision-5820-Tower>
In-Reply-To: <160134424745.11199.13841922833336698133.stgit@john-Precision-5820-Tower>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 28 Sep 2020 21:34:50 -0700
Message-ID: <CAADnVQKUmuLU5GDdy7FS-=+no=FhC1u6iCCp6zGnN_X7kAG5uA@mail.gmail.com>
Subject: Re: [bpf-next PATCH] bpf, selftests: Fix cast to smaller integer type
 'int' warning in raw_tp
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 6:51 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Fix warning in bpf selftests,
>
> progs/test_raw_tp_test_run.c:18:10: warning: cast to smaller integer type 'int' from 'struct task_struct *' [-Wpointer-to-int-cast]
>
> Change int type cast to long to fix. Discovered with gcc-9 and llvm-11+
> where llvm was recent main branch.
>
> Fixes: 09d8ad16885ee ("selftests/bpf: Add raw_tp_test_run")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Applied. Thanks
