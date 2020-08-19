Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C38024A979
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 00:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgHSWhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 18:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgHSWhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 18:37:51 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25D4C061757;
        Wed, 19 Aug 2020 15:37:50 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id e187so74983ybc.5;
        Wed, 19 Aug 2020 15:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X67iRBaKVw9bzFfjGhLxKWPPTMTyIqamnsr23odR9XY=;
        b=ridks66+D20DomaAE6NDp7VT/uEEYhrLIbrZMay+qDXm1H6jkKbkVjGwOFuZUsOTGH
         lyfyTsD6IRAZFbX335feY4X8iK7kFYr4+j/dV+7o7hVETd3tBn6iuFGcb0v0/Z0N/5rL
         6J8guJ3AuUqn8lU49HFJ+Td6ATuIsI+ALotOSvC8Uaw8fRqIHyzUEJavpjs5KOmeLjow
         jMoZXFWpJ2oAofsF8SpI1mu1gyBBtKXRbyyyzm7n/fj/Hr2laYRxPwRI9eGPcpWtufpo
         7mb2Vr1pJ/ZL/+iCdS39cbavJGQthmUuyfrmLryyRd58Us1n7KjylUNwBdp4L7XZq32A
         0USA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X67iRBaKVw9bzFfjGhLxKWPPTMTyIqamnsr23odR9XY=;
        b=K4gGmH59wV7zPFAF1+dmHWAVIG/2BnZFOk+06TOabQHE9ePOrCAkY4YkuWvwqP7zmO
         CDyELNdHqgTw13JXSi+u8mnTyi04tZ4Ob48iIUix/6Jk/v251NSxzpkt9E4pswyiaAWx
         3He5z8JMomkQ7JGR+D6lZbkgzl+iqLZ13/6kM0Km+9hOD6TDREu/mWjt6dIZes7lwjx6
         VCT+NkpLMBZgD1rAXEilIz3HStOHgsCMD5F7K2EWbE+qIeKe1ErxD+DubN+VzqtK2pW5
         yisIaojZ1YIpkCSlDhijBw0IATrQPEPO1FbP0mcF2nWNCTsXt7+ffd45dat7Hb6XvMJi
         m/Xw==
X-Gm-Message-State: AOAM531rvgf5EZvonSWJANwy8613jrgO80rehYzmMts3I/uUZFYtonty
        laSWG+/6srS6wK0J3S16xoMmbJtNVRPpl0xVurQ=
X-Google-Smtp-Source: ABdhPJyy0uhxOjfL5wtIHEY0tWHvCeFZmdyd+s9+I5MhkCx1IRh6+xgO3mGgUfTzq3b+7rQxXwXcz/LAiriUtcZKaYQ=
X-Received: by 2002:a25:2ad3:: with SMTP id q202mr856308ybq.27.1597876670063;
 Wed, 19 Aug 2020 15:37:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200819194519.3375898-1-andriin@fb.com> <20200819215846.frvsnoxu6vv4wamt@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200819215846.frvsnoxu6vv4wamt@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 19 Aug 2020 15:37:39 -0700
Message-ID: <CAEf4BzbOo9OXj0tkv=BGY0fGKxRRONxG9TmKcspbpWnL22rMLA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/5] Add libbpf support for type- and enum
 value-based CO-RE relocations
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 2:58 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Aug 19, 2020 at 12:45:14PM -0700, Andrii Nakryiko wrote:
> >
> > Selftests are added for all the new features. Selftests utilizing new Clang
> > built-ins are designed such that they will compile with older Clangs and will
> > be skipped during test runs. So this shouldn't cause any build and test
> > failures on systems with slightly outdated Clang compiler.
> >
> > LLVM patches adding these relocation in Clang:
> >   - __builtin_btf_type_id() ([0], [1], [2]);
> >   - __builtin_preserve_type_info(), __builtin_preserve_enum_value() ([3], [4]).
> >
> >   [0] https://reviews.llvm.org/D74572
> >   [1] https://reviews.llvm.org/D74668
> >   [2] https://reviews.llvm.org/D85174
> >   [3] https://reviews.llvm.org/D83878
> >   [4] https://reviews.llvm.org/D83242
>
> Applied.

Thanks!

> Thank you for listing the above in the commit log, but please follow up with
> corresponding update to README.rst and mention the same details there: the
> symptoms of missing clang features, which tests are going to be skipped for
> older clang, etc.

Ok, sure.

>
> Also progs/test_core_reloc_type_id.c talks about some bug with
> __builtin_preserve_type_info() please add llvm diff number that fixes
> it to that .c file.

Ok, that's [2] above.
