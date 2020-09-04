Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF8425E097
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 19:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgIDROT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 13:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgIDROR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 13:14:17 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF34C061244;
        Fri,  4 Sep 2020 10:14:16 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id h20so4909848ybj.8;
        Fri, 04 Sep 2020 10:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZsYPLVwblcuEmaIyau2OYJj/wD7sHwvaDVgfKuOsMQ0=;
        b=B1q3l07sIL9PRuo6wx6SkHd36fr+M4LfptwD3VejtzlZnZ+zIQbRTzJ2gkOTmXA3Ks
         VSs/1rjC6I5FM2TSF3eHwreHLJDqwTYTR/LoQa0i5hdhZb2XELWTarhqYUggMWpfIBze
         oXECMOlB2F2mWq9gRgeHUplBaaHCXpX0Lp1SSr5G/RxwbvWAsD9suB9epZSP2j1ZZaBd
         Gn3fxWc41fhTiF72db+5v7lcpreBAWaEosh9LipXu030mWwCLm/F0T0HVIec0e6Yp1/I
         wLTkj6zH8MvztnkVrTBM5sP0OM0SP1RMXOX1nh1WpwwDWP0okQXgUlQQe0X8BWXzyzQ7
         vSlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZsYPLVwblcuEmaIyau2OYJj/wD7sHwvaDVgfKuOsMQ0=;
        b=Iqm2HfRrBon9ZhaDkNYtS4HnfN0g95xoRjWXJ+GhfMIQ4Egn+dtQvughwwwmnTT1qb
         QqdUplNUfF0FZiVSIapcozD2boCQNHtBDL6KAFqUbeysnxdZUhpza71SjIVmE3LOTC+h
         kOaP2nbi5UOzoqBfc7qgwBWBSGvm4htYFtLVqFPSPiWlfC/S0v1S0w35OavFGJPYZC0o
         657NhDQxpcVj+EY2nyM+EeZL+njvcE+SEOhL38iMrt818ty0x1tBknyQCdeg+DrANvb4
         B1eCNQgcneSE1c5H2A2mYWcDs99kUH71gMSuJ9zpv0tWoYvjOv1hJl9IOGYl6HKLcxX9
         5fxw==
X-Gm-Message-State: AOAM530u9cF7T1wp37QySf0e9MU/SY1N4UJEB4KVQ+BXq6T2Y/63Gw0J
        6voWY87VrLLcN4HP7mgS601TsMUTYUl9oY1++ZUq3cvNZgY=
X-Google-Smtp-Source: ABdhPJzBZ8oT9LLFnb+A3VFcJNz88uGrI6OhgceFxci9ai4lAcIryynW7izY/fxJdCag7YDWB6o+iuSDkxoGMO4Riq8=
X-Received: by 2002:a25:ad5a:: with SMTP id l26mr10774919ybe.510.1599239654824;
 Fri, 04 Sep 2020 10:14:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200904063434.24963-1-danieltimlee@gmail.com>
In-Reply-To: <20200904063434.24963-1-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Sep 2020 10:14:04 -0700
Message-ID: <CAEf4BzZgvw2zx7SCL5JPb42pDfAnrvVVrF2FZu8xX3gN3htEpQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] samples: bpf: Replace bpf_program__title()
 with bpf_program__section_name()
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 3, 2020 at 11:34 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> From commit 521095842027 ("libbpf: Deprecate notion of BPF program
> "title" in favor of "section name""), the term title has been replaced
> with section name in libbpf.
>
> Since the bpf_program__title() has been deprecated, this commit
> switches this function to bpf_program__section_name(). Due to
> this commit, the compilation warning issue has also been resolved.
>
> Fixes: 521095842027 ("libbpf: Deprecate notion of BPF program "title" in favor of "section name"")
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  samples/bpf/sockex3_user.c          | 6 +++---
>  samples/bpf/spintest_user.c         | 6 +++---
>  samples/bpf/tracex5_user.c          | 6 +++---
>  samples/bpf/xdp_redirect_cpu_user.c | 2 +-
>  4 files changed, 10 insertions(+), 10 deletions(-)
>

[...]
