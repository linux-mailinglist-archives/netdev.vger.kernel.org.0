Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65EA139D78F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 10:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhFGIlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 04:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhFGIlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 04:41:31 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC1AC061766;
        Mon,  7 Jun 2021 01:39:40 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id e20so1339081pgg.0;
        Mon, 07 Jun 2021 01:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=seI9VhZLWITb73hRF+sNSy2Lz+CzoknsjVZsKb1Ga38=;
        b=O7E3S+vRu7hn5GJjj0pCWPL5dnKpVmdC5ZbapPxuVWuxllsv+b8MPNqcKt1vdIqN5f
         aHLz//DdSsQIxt72pZvlIzpComYRDfSCPJ8/97bedGxdoFosI2EXaZFc6448fHr4cMVF
         Ex1hQoUFRQpQfNxBBFtXfZN5Ly42u5VHo/OYzqJNdvOXnTqYeWQK77M/WSyL8DNdR/B3
         Z2M1k8F4h4AMJ2SEX1G7P36b0g2t19/yMDMZB9zfzCAbFUPqEO6RlWYilDdGE1Z+4f4X
         HiVzMg9ZUfjkWzta3Q3A9LB7eQoGbQcS+IFRA+jgUSKvxS6aYaPJPKX5RTSLsMctsNgA
         vpxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=seI9VhZLWITb73hRF+sNSy2Lz+CzoknsjVZsKb1Ga38=;
        b=eTwe7VC+2Zf66MFE2bheUK6y6k23kWBBCD3JqW3t1NAQHyWCtGTBV8tz6KkukfcNnt
         rlPVzRouTXEdhne0d78i4wZA93RyNEhwIeF2IEANloU4STldXCIc8Z7n+JIBa32rXx24
         Piy+gXf4xurz4H05aRpi+w4U3hu39PhUmuwSUG/18Wpnmh+0zxDllLtZQ90etrmoeOLB
         RpmdJL5VgUZTD0XzhjaeJxtkUJs55uIV9gDdsoEPq7NzpQXhNgv0XLPL9Yd7frt6pzc+
         svrJTahsZExlfM/Q9Olw+1kbvKoEEguqR+e4JrrPZsvCZSLxdyoA3K28kWxiQ6FZw4xX
         V7aA==
X-Gm-Message-State: AOAM532tSjMznDLEzVM5oM9IXFGcNdytYtuZUbc0HDZKS/mr+G9f8Uwa
        E+hJIG2j7+0AAPQyk5xLpOfvNbvPkp7qIs7l/cw=
X-Google-Smtp-Source: ABdhPJzq/O0oFw/CaGu48C6AIP65OYI0zjliR7a85XZXOvUqZMcIi7bo7MjHM0TYHjm2HJ9qM6vgKqKL+z4656ZLNwo=
X-Received: by 2002:a05:6a00:a1e:b029:2e2:89d8:5c87 with SMTP id
 p30-20020a056a000a1eb02902e289d85c87mr16205964pfh.73.1623055179249; Mon, 07
 Jun 2021 01:39:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210607031537.12366-1-thunder.leizhen@huawei.com>
In-Reply-To: <20210607031537.12366-1-thunder.leizhen@huawei.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 7 Jun 2021 11:39:23 +0300
Message-ID: <CAHp75VdcCQ_ZxBg8Ot+9k2kPFSTwxG+x0x1C+PBRgA3p8MsbBw@mail.gmail.com>
Subject: Re: [PATCH 1/1] lib/test: Fix spelling mistakes
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 7, 2021 at 6:21 AM Zhen Lei <thunder.leizhen@huawei.com> wrote:

> Fix some spelling mistakes in comments:
> thats ==> that's
> unitialized ==> uninitialized
> panicing ==> panicking
> sucess ==> success
> possitive ==> positive
> intepreted ==> interpreted

Thanks for the fix! Is it done with the help of the codespell tool? If
not, can you run it and check if it suggests more fixes?

-- 
With Best Regards,
Andy Shevchenko
