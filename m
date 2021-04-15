Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7509C35FEBA
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhDOADg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbhDOADf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 20:03:35 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E229CC061574;
        Wed, 14 Apr 2021 17:03:11 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id p3so3467515ybk.0;
        Wed, 14 Apr 2021 17:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8KXU4sRXR90gaVbh329XNuKBTk28xufevci9teckJjc=;
        b=H0cQHG0RdOXyVmWfIy14AZBjpZjrwC+4/EMeVZxQHqsR3HRTm5CB0W5OP2HBXWDh+6
         oUkpIz+kEwoOlFvyMc8XsgCWVIKgD4XwKYdainmbFBPkvbMm73+AM5NvZuK+WAG4HX6f
         YlQzXKSQuj0lxM9dv6KTYWfxPRJ38tslS1sXHrP6pynqq0ttfkVd1LFjfAi2aYgMRIaH
         gVs9Dd+4giHPY9sV2bXNk+Xih93jcw9OYa0iygss7R0UiYOZE6I4dQ+JE/Zg6+1fpEGs
         Ik99bdhIvMnnEdcpxmwX6yxeDmD9jDeKXaHYZkOqHmm+8wJgCn21JyntvX5n6w2CST5Q
         Px6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8KXU4sRXR90gaVbh329XNuKBTk28xufevci9teckJjc=;
        b=Lucxfn2jkASDGq+DlW3tU7Ohwfk2EhduydlSnROxIZwiDFlnFqTc5RmODhalEXtSxU
         BOvaQtfpnMde9anQdVvQ9PflRdwhGc6TflyYvmTxZYK4dgpR04VU44yISgkOr+9on2aq
         BW0tfj081BsNwKFgotHKhTmWHjDrHHGR99gay1EW1EYM4H5PJ73bl2SkGSlnGspu7YAo
         D+PwdYzRkRCG0MgWCfGf+CUWMb83jSlJ9mkfOS7eartuOHLS8zCjKwSPlL/ExBmCjXvJ
         bTCKuexx46MkM98vDDakkzbmN03aSVF1/jwxR+1IbWXzC4/1WL7esJuFLj6GuMmElaje
         V0fw==
X-Gm-Message-State: AOAM531vnJecbVJj/vnSBD0xlTrhar9tSoIdv7DKh9gKGiu+gXtZbymO
        eKXu6az2KtKEoGfFxAxnC+hv/nqCgAS8dxaJ4o4=
X-Google-Smtp-Source: ABdhPJylOOkDeMO9j3vMleRi9vg9u4aYQ8GJZZNc/Nh0ICvEuSSRTJvZGE+HBlyn/BLT+qcZWE/tAuXo6hQEQS5IG8c=
X-Received: by 2002:a25:5b55:: with SMTP id p82mr773235ybb.510.1618444991240;
 Wed, 14 Apr 2021 17:03:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210414200146.2663044-1-andrii@kernel.org> <20210414200146.2663044-14-andrii@kernel.org>
 <00d978e4cf484fecb907a7035201c975@AcuMS.aculab.com>
In-Reply-To: <00d978e4cf484fecb907a7035201c975@AcuMS.aculab.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 14 Apr 2021 17:03:00 -0700
Message-ID: <CAEf4BzaM8dh6KvTu3TN2vRdpPVWdgWTd5uEF+z05cKQJMCJ3Ag@mail.gmail.com>
Subject: Re: [PATCH bpf-next 13/17] selftests/bpf: use -O0 instead of -Og in
 selftests builds
To:     David Laight <David.Laight@aculab.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@fb.com" <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 3:15 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Andrii Nakryiko
> > Sent: 14 April 2021 21:02
> >
> > While -Og is designed to work well with debugger, it's still inferior to -O0
> > in terms of debuggability experience. It will cause some variables to still be
> > inlined, it will also prevent single-stepping some statements and otherwise
> > interfere with debugging experience. So switch to -O0 which turns off any
> > optimization and provides the best debugging experience.
>
> Surely the selftests need to use the normal compiler options
> so the compiler is generating the same type of code.
> Otherwise you are likely to miss out some instructions completely.
>

I don't know, it's not like I'm trying to validate that GCC is
generating a valid assembly. And there is almost nothing in libbpf and
selftests that relies on delicate timing, so I don't think we should
worry about changing timing characteristics. And there is nothing
performance-critical in libbpf logic itself either, for the most part.
So I don't see much harm in running selftests in debug mode.

> For normal code I actually prefer using -O2 when dubugging.
> If/when you need to look at the generated code you can see
> the wood for the trees, with -O0 the code is typically
> full of memory read/write to/from the stack.

Whenever I try debugging anything in selftest+libbpf+bpftool, if any
of those components are built with -O2, it makes it almost impossible
to figure anything out in debugger. So I always go back and force all
of them to -O0. So that's what this patch is doing, so that I and
others don't have to go through this every single time we need to
debug something.

>
> About the only annoying thing is tail-calls.
> They can get confusing.
>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
>
