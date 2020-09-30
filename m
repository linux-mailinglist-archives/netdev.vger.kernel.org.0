Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF78F27DF91
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 06:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725306AbgI3EgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 00:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgI3EgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 00:36:09 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7384C061755;
        Tue, 29 Sep 2020 21:36:07 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id y11so495665lfl.5;
        Tue, 29 Sep 2020 21:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HKYQFlbT5TVenNy6XGzu45AgS2brCmEgRl0H6KKi3w8=;
        b=S5ml0Rgmv9Qyn7nUmfHMVkhCHyhK3Xz66encpUY3sJII8Y4SPyeVrwXfo0uptDn7EE
         6QXr4AfpdyKz7JyvNgdUNDd4SP6IP8jJf2S1uGJQ6aeolQjB9r/Ne10Nowam6alPKc/5
         ZnNMF5JHRnHUMp0FVNSGk7dI3wpDRHUrM9hyNOcdKhN3wfjoa5N90fKKZRjW06AnV6/g
         6STO5Bp+W8NMpv+oFep1zLN9qXSsFuoW1YgvfZie2qpTZ2Ft597Ox37yVWY0+dH23i3x
         ZH3LMo0OuPitDrhBO78e+C0zqamtXGxGLs+OcrDT0gDHAGDxijLGcN9IZdQHIEsZR85h
         CAXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HKYQFlbT5TVenNy6XGzu45AgS2brCmEgRl0H6KKi3w8=;
        b=Qdjwy5vIWkhfj3eakbAlmldNdrD61sT/UnyLPJUlBPgNi6eWJ2C2VKJ0CDmNTESgWe
         OuLkmFVXXYWUHZj9mfA/pVpPWJImQx96NKyJLoBN2Pn0r6VFmsTqf6lAAWNZoDRhQ+8U
         58q85gCkZbT/emAkq+pDnNEKon0C6c5/V3ta/rqtJhc/ZwTZyt4KwXnSQ8cU7vb3nbQ5
         yU1OPdSAAYNtGv7KJKpgMXYaH72lefwroueFvlPoHLlF1Ff9EIpjdwttV+uCZIi860J2
         jk7s3TfMnZBm8cRW+uXhOHAxfZG0WzrXrEmWzUjZl/kSGvlKY2ixhtwnECD0S/sY2q4A
         LLAg==
X-Gm-Message-State: AOAM531cHUlgW/bbaF3mcEdPAujtVm40hW3G+ffHj7Xi9J63FBM8OQgz
        +l0ELTsW1ftn4ElJGMurPGhyElfKNsbCKkds9RQ=
X-Google-Smtp-Source: ABdhPJxNJQYYcO8fOG6G6xY5a3ivJ0Mdpx0biwuXLKjVE7Zyu8fjQB3k64sqMZJQg2nfNV7fOyxmWf0zR2DWjVVikxg=
X-Received: by 2002:a19:8089:: with SMTP id b131mr190567lfd.390.1601440566386;
 Tue, 29 Sep 2020 21:36:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200929235049.2533242-1-haoluo@google.com>
In-Reply-To: <20200929235049.2533242-1-haoluo@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 29 Sep 2020 21:35:55 -0700
Message-ID: <CAADnVQK8XbzDs9hWLYEqkJj+g=1HJ7nrar+0STY5CY8t5nrC=A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 0/6] bpf: BTF support for ksyms
To:     Hao Luo <haoluo@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 4:50 PM Hao Luo <haoluo@google.com> wrote:
>
> v3 -> v4:
>  - Rebasing
>  - Cast bpf_[per|this]_cpu_ptr's parameter to void __percpu * before
>    passing into per_cpu_ptr.

Looks good, but doesn't work:
./test_progs -t ksyms_btf
test_ksyms_btf:PASS:kallsyms_fopen 0 nsec
test_ksyms_btf:PASS:ksym_find 0 nsec
test_ksyms_btf:PASS:kallsyms_fopen 0 nsec
test_ksyms_btf:PASS:ksym_find 0 nsec
test_ksyms_btf:PASS:btf_exists 0 nsec
libbpf: extern (ksym) 'bpf_prog_active': incompatible types, expected
[4] int int, but kernel has [18729] var bpf_user_rnd_state
libbpf: failed to load object 'test_ksyms_btf'
libbpf: failed to load BPF skeleton 'test_ksyms_btf': -22
test_ksyms_btf:FAIL:skel_open failed to open and load skeleton
#43 ksyms_btf:FAIL

I have the latest pahole from master. Any ideas?
