Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962073C70A0
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 14:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbhGMMqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 08:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236268AbhGMMq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 08:46:29 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A63AC0613E9;
        Tue, 13 Jul 2021 05:43:39 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id w15so21489615pgk.13;
        Tue, 13 Jul 2021 05:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wy49cRVsEmxIbrbaWFjn3024Zxh1lL5f/THThTGEals=;
        b=hJQMbfKzpLX0uAtSBYI7zS+nKbXgpu39J+Vj7FRwiCYhAeSQ/Jh9U9lOOlUEzjHr0L
         +LVZKNDryppVhvCpSumUiMl8lWKXqxi+i/njw97NHYmqpkWonpDpBjq3HUDnF8wGFr7g
         1ME6Tez5SUQPZ9iSLDutir1oYLX/CQD5p2qFOvrW+O39ZiWcPsDAdM5In6jCbtfiVybK
         bNJtKh4YyS6cmXOwEaHpJB3tTRLf6aixN/W3i/4A1/eJhCY7tNw0e5XI+jWTrJftejdx
         4ZZ3xRUOHqrNFDvperVCTvO1+yuTWecywdJmkU76o5acPDcDrsPKxGwxCYo6Bpo7qykW
         G0Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wy49cRVsEmxIbrbaWFjn3024Zxh1lL5f/THThTGEals=;
        b=Lip//JNBO93vDUFdN43j/MOgNOHzgqxeVzv//4Yl6zXq3OlaWr5XTrcYxLdMbZgItZ
         EnpktZABd31Mu8ev33nxZ86i190OuzEfbIu1DEc0+NtB81Pv1P7hfX0I6PkhqU2yPto/
         JNnMsX6dWX3+ON3cEQ0jdgh9tkvWyammFOKsoZGJm/35+VAE0V59t/2jw0sNSnCAvSOT
         ZSf5M4TwIQcKeNrKdYwrHQ2G5Z0cngNfbPidRMohsTYO0c+WkZiXCf5XuaJF4ZSAdKX7
         UZ0gOnT43VvmNAcKs71DfktP8RyieejAN6GOUdfAJz+C0IwjGOm/NIgZj2Rcd1kz18i6
         g7IQ==
X-Gm-Message-State: AOAM5335YIJlIHH2rlJW2OHj1UXrIX18AfeJEhGPH5fx63+pOalRu8PC
        A7k+xF5kkiI1VVNHb6nq56tkD9kMR5F9qEgZ12Q=
X-Google-Smtp-Source: ABdhPJxXN/EJDXq3VVNsWx8320lVNSE+g21jGRGaBQABdOGA5tTDqb4mnL8tnVlXEE1Z/joNb9dYtYx/3LlC3HE9Xg0=
X-Received: by 2002:a65:434a:: with SMTP id k10mr4172714pgq.4.1626180218824;
 Tue, 13 Jul 2021 05:43:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210713084541.7958-1-andriy.shevchenko@linux.intel.com> <20210713123845.GA4170@worktop.programming.kicks-ass.net>
In-Reply-To: <20210713123845.GA4170@worktop.programming.kicks-ass.net>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 13 Jul 2021 15:42:59 +0300
Message-ID: <CAHp75VdtyeTakC4UgScCD2=yksF6RhwrNVfmuzGUcyaZ6UKtFQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] kernel.h: Don't pollute header with single user macros
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        KUnit Development <kunit-dev@googlegroups.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Thomas Graf <tgraf@suug.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 3:41 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, Jul 13, 2021 at 11:45:39AM +0300, Andy Shevchenko wrote:
> > The COUNT_ARGS() and CONCATENATE() macros are used by a single user.
> > Let move them to it.
>
> That seems to be because people like re-implementing it instead of
> reusing existing ones:
>
> arch/x86/include/asm/efi.h:#define __efi_nargs__(_0, _1, _2, _3, _4, _5, _6, _7, n, ...)        \
> arch/x86/include/asm/rmwcc.h:#define __RMWcc_ARGS(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _n, X...) _n
> include/linux/arm-smccc.h:#define ___count_args(_0, _1, _2, _3, _4, _5, _6, _7, _8, x, ...) x
> include/linux/kernel.h:#define __COUNT_ARGS(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _n, X...) _n

Good catch!

I will redo this, thanks!

-- 
With Best Regards,
Andy Shevchenko
