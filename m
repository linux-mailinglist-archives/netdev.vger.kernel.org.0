Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D94027BACA
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 04:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727288AbgI2C0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 22:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbgI2C0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 22:26:46 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E72C061755;
        Mon, 28 Sep 2020 19:26:44 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id a22so2679806ljp.13;
        Mon, 28 Sep 2020 19:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=80vsUD7XRT+rdywfaQIBARge/5coTPkk91LpfH8qlnU=;
        b=NWqDoo1ixRdUdGqFzGNat03uVOapJkwM80kz2KdFQewWTNN+EXgicYDUDeWq8gi/xY
         KJUrpBmpKc/583tnI8abSR1AaY1O1AM0AZ+zD9wylRWei6XYJ4dmlhx+SDvFYBVgSg2U
         w1XUcCgpfZINc+BqO93/t1U0v6e9tGaQSqGQvtMtamYtXiTtXpCDyHyP7hI0DVdZJaTu
         C0v/mtUjcY1o44rto8narIGTseboxK7GNiWrXp+jDaU4qsQH3ylqGlQABH3pC6cwcpKV
         IGpKUzeI6axSDpuAnuIsPxvqExcBVkPYRHXpdxRshqC+9UhmAJahxn4clfxhuLru83C0
         V19A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=80vsUD7XRT+rdywfaQIBARge/5coTPkk91LpfH8qlnU=;
        b=XFPdEfK4qVtKkufbVyUmaI4ZBoLJRLi7IVpEXVS2hWgkk289JSZAtCE8dzB3Yv0MeO
         XKMqFuTcpgglcAN2VhnfytpIytBwVcHNttVmGJuvrvOOM7fs0tg+WJmGYHoEE6D6uijm
         Sa7Xtn0FsFAbQYZdxN4RODSkI1F64Pk+883WMRiamEMtM+kunjIlwlAp/Voy6KXtGLht
         mEy5+oEjVhsTC4ZIUTmr17HtXW1VqCYI/oa2z1nKCBK2+ZSkqPOG721jo3DigPIBoDgc
         jBsXf8SIASfo/dFUwz1bcrkG2YsmO80OSimZnEHC5DQgthWNDAZ2sVLk4FzmF1PpxPVv
         HomA==
X-Gm-Message-State: AOAM530mVGzs1wNkFrKH82rw0pmtB7LpxJhMW9MLhVTeYF0+NBZN3DEC
        OsiLaxvMHrs32LG2teld6foNMnASmd28tlSbVFQrYdFV
X-Google-Smtp-Source: ABdhPJzLItEZ0cDm14shGuXkyP3EuYeWHvQE1H+6fgx4o6u/yoa6bDjFzlUj2m9vAYsGq7GtRg/u9Dio4h8NSBYTKww=
X-Received: by 2002:a05:651c:cb:: with SMTP id 11mr468724ljr.2.1601346400853;
 Mon, 28 Sep 2020 19:26:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200929020533.711288-1-andriin@fb.com>
In-Reply-To: <20200929020533.711288-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 28 Sep 2020 19:26:29 -0700
Message-ID: <CAADnVQ+Z5BhbNm9qiWNn7hxo=mgUHt5xOaMG-z15cPJmVZssVw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/3] libbpf: BTF writer APIs
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 7:06 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> This patch set introduces a new set of BTF APIs to libbpf that allow to
> conveniently produce BTF types and strings. These APIs will allow libbpf to do
> more intrusive modifications of program's BTF (by rewriting it, at least as of
> right now), which is necessary for the upcoming libbpf static linking. But
> they are complete and generic, so can be adopted by anyone who has a need to
> produce BTF type information.
>
> One such example outside of libbpf is pahole, which was actually converted to
> these APIs (locally, pending landing of these changes in libbpf) completely
> and shows reduction in amount of custom pahole code necessary and brings nice
> savings in memory usage (about 370MB reduction at peak for my kernel
> configuration) and even BTF deduplication times (one second reduction,
> 23.7s -> 22.7s). Memory savings are due to avoiding pahole's own copy of
> "uncompressed" raw BTF data. Time reduction comes from faster string
> search and deduplication by relying on hashmap instead of BST used by pahole's
> own code. Consequently, these APIs are already tested on real-world
> complicated kernel BTF, but there is also pretty extensive selftest doing
> extra validations.
>
> Selftests in patch #3 add a set of generic ASSERT_{EQ,STREQ,ERR,OK} macros
> that are useful for writing shorter and less repretitive selftests. I decided
> to keep them local to that selftest for now, but if they prove to be useful in
> more contexts we should move them to test_progs.h. And few more (e.g.,
> inequality tests) macros are probably necessary to have a more complete set.
>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> v2->v3:
>   - resending original patches #7-9 as patches #1-3 due to merge conflict;

Applied. Thanks
