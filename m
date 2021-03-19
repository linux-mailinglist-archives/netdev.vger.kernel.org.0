Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22BFF34140E
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 05:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbhCSEO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 00:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233626AbhCSEOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 00:14:52 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90241C06174A;
        Thu, 18 Mar 2021 21:14:51 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id n195so4862418ybg.9;
        Thu, 18 Mar 2021 21:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nc2/nbDVcnKxsqpAg4H6vpW75+tZ4Zz8eMeHRfHqA7M=;
        b=lgcHZtJKWe6dtfOsj3EY9Cf5U8bhnA5lE2b6zSMOQ0zLt8eLmYKPyFQHag0vg7rGPX
         aYS9y/7bsnKdTUb/rPEBiKeYQj4/1H6dIebyfT0/IaRWT1hy/J1y9Mw8PwpaLNOCNNDn
         RiZQarRUmFMHhzQGQcox2UzEM47IZhLJj2FEUB5nVloqVoeHGTS9/lznhUayewDvmNMS
         wmfNl9qsoxQXcFEfzbDFnFgc7hBvdERAj8+leM6bbdN29Yhmiat9FS6mEl9Mw3scNGEo
         ILK54ppVAPbski5w5fiuwbU8yrC4BxyyJ3ulUZrmPYMUoLoTKFTkLefcRotIh7ydkSb0
         0PjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nc2/nbDVcnKxsqpAg4H6vpW75+tZ4Zz8eMeHRfHqA7M=;
        b=I0Ojkq+fB50hVLiq9Sfv/vaCICsof5g84HyhYeGPmHtFG6YID9O1s8taQ2SouwyOeR
         BPWfHJYYNlrccQCB8ppKOOoEt2EzIfjxl6IjdEU4gAw6OcQsIPayolNsTjZF8pb+d729
         Tvb6Q69l+tk1UmgjZ1MlyW0P+1oj24WhVyDMrfYRMD0mio2suPhZPw5TYMDaMtVx9eJE
         kAwGj7RiczWJ/sRvAco9UQA1YLwFMccX6Ki4E6XyA0hk2xrtX9Ov8hnYZh+VUTERW/Z3
         LtGG32MAEKbw6hFuV+btOja4fYANaofOmSMFNbSfeyr5gBhGwAVUW5kyj7a+RuhApcfE
         /6IQ==
X-Gm-Message-State: AOAM531LOz8zA4MJmA+dLdf0OhvmFbzOmsLrB0GpiptKbbhOn2cWLjbj
        vtgFuaJLokzfftJoAls4pNXWZW+Rmsvth5LAMuU=
X-Google-Smtp-Source: ABdhPJzFS+MFMnvYRYOw2aGOmLF4qoTU3vV0eGgbvmqjyJeO4MgHAX55qmUAQDWzwlwpche6xLrLotlvarv39Lw7inI=
X-Received: by 2002:a25:7d07:: with SMTP id y7mr3643973ybc.425.1616127290976;
 Thu, 18 Mar 2021 21:14:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210316011336.4173585-1-kafai@fb.com> <20210316011457.4180235-1-kafai@fb.com>
In-Reply-To: <20210316011457.4180235-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Mar 2021 21:14:40 -0700
Message-ID: <CAEf4BzbyzdbkpqeYnEaFVu7r+5_2rhQqmvycTD0Zx66tFxaDew@mail.gmail.com>
Subject: Re: [PATCH bpf-next 13/15] bpf: selftests: Rename bictcp to bpf_cubic
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 12:02 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> As a similar chanage in the kernel, this patch gives the proper
> name to the bpf cubic.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/testing/selftests/bpf/progs/bpf_cubic.c | 30 +++++++++----------
>  1 file changed, 15 insertions(+), 15 deletions(-)
>

[...]
