Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C73B369D21
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 01:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbhDWXGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 19:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhDWXGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 19:06:44 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C20C061574;
        Fri, 23 Apr 2021 16:06:05 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id n138so79917420lfa.3;
        Fri, 23 Apr 2021 16:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RGoc0Ay23N9SH4/XeH3vLgN0mODXiUNlMBQyikwRGGQ=;
        b=DxrpuUB8jXixw/IjeFfsQGcX4E7guapt+jit7GnGC4mbt9qYsm56CXOY9j+Tcof21t
         zbN8BYYvOG1hKXhgGV7sJ/E693PiqCTfrULGRfNQVNyKj0dleIduhHUgcgCcJFuK1vcN
         Ko1EgHjv0zAHtEv4T01+q0qxa6NV0lZGsEPqgBdJ8+vDm80plbIuvTRgIyX+JeWxuEjx
         hDRggZSbnYyNmOJxl8cYbIEixBCbunhZvwUBAhevxL9d4or5SMrBIZRzS/fURMCdgPDj
         u/KYRSIUY1L2WpKT3QGCETTQZzHpQoVTlUn+NNzutaUFiqGcsW0OkPFxqm4ZBOJN+IIn
         7VJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RGoc0Ay23N9SH4/XeH3vLgN0mODXiUNlMBQyikwRGGQ=;
        b=XZYs8mz0VlztYBnYBEtLglG24qzXKRnRdfujYJ8vGomXztL6gu7BY+G1O0ai5e90WC
         08a0IOgNXchu+/2UPl9CotLikRuZofIt+hfjtGK0uXofweY/8emFIOfKwiNXKalNUaSf
         YMFgplZMsADerUgeHFV++eXd3hN+qqQMuCBs9JGbK84NBA6OJjyoAl179pCpPlluwjYx
         JcoPcJyYxwkfvP151uzVSyHIrvNTjp7xVtPwUrYBo0g82hEGrhlvK812CAWYxJ5qHqp6
         BFD51JAoPuQ6s7zb/L8269mxkbQ8mcxIGMDHbXSqb8WCmj3/WoyVge3g7qbJzukSzaSi
         Fd1w==
X-Gm-Message-State: AOAM530UdnIzX3NRev+mZHasyk67GCUgwpK9QziviiivCrWMm6d0a/F8
        4bJicjmRuVFWB43a9lUthDOldDC07IBoAOEPfwA=
X-Google-Smtp-Source: ABdhPJxB4HeCrkh6XklsALCyG/YiJ2yQAGn4ULDK5Ra9ZwL+c5ERyJPB2+/xCL74rj14e22By3wUTNlCWPE7kYLBwRI=
X-Received: by 2002:ac2:491a:: with SMTP id n26mr4520326lfi.539.1619219164358;
 Fri, 23 Apr 2021 16:06:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210423185357.1992756-1-andrii@kernel.org> <20210423185357.1992756-3-andrii@kernel.org>
 <2b398ad6-31be-8997-4115-851d79f2d0d2@fb.com> <CAEf4BzYDiuh+OLcRKfcZDSL6esu6dK8js8pudHKvtMvAxS1=WQ@mail.gmail.com>
 <065e8768-b066-185f-48f9-7ca8f15a2547@fb.com>
In-Reply-To: <065e8768-b066-185f-48f9-7ca8f15a2547@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 23 Apr 2021 16:05:53 -0700
Message-ID: <CAADnVQ+h9eS0P9Jb0QZQ374WxNSF=jhFAiBV7czqhnJxV51m6A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/6] libbpf: rename static variables during linking
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 2:56 PM Yonghong Song <yhs@fb.com> wrote:
> >>>
> >>> -static volatile const __u32 print_len;
> >>> -static volatile const __u32 ret1;
> >>> +volatile const __u32 print_len = 0;
> >>> +volatile const __u32 ret1 = 0;
> >>
> >> I am little bit puzzled why bpf_iter_test_kern4.c is impacted. I think
> >> this is not in a static link test, right? The same for a few tests below.
> >
> > All the selftests are passed through a static linker, so it will
> > append obj_name to each static variable. So I just minimized use of
> > static variables to avoid too much code churn. If this variable was
> > static, it would have to be accessed as
> > skel->rodata->bpf_iter_test_kern4__print_len, for example.
>
> Okay this should be fine. selftests/bpf specific. I just feel that
> some people may get confused if they write/see a single program in
> selftest and they have to use obj_varname format and thinking this
> is a new standard, but actually it is due to static linking buried
> in Makefile. Maybe add a note in selftests/README.rst so we
> can point to people if there is confusion.

I'm not sure I understand.
Are you saying that
bpftool gen object out_file.o in_file.o
is no longer equivalent to llvm-strip ?
Since during that step static vars will get their names mangled?
So a good chunk of code that uses skeleton right now should either
1. don't do the linking step
or
2. adjust their code to use global vars
or
3. adjust the usage of skel.h in their corresponding user code
  to accommodate mangled static names?
Did it get it right?
