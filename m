Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AA538F93E
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 06:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhEYERM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 00:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhEYERL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 00:17:11 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1078C061574;
        Mon, 24 May 2021 21:15:42 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id l16so8262656ybf.0;
        Mon, 24 May 2021 21:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pXZ2v7HjzFFRpB5Yb99oi4UQxO6d/40fj8fo35P19Ms=;
        b=DgxtRCOAPWuq7oo/GmEnOGbuCmw5s+U0hfCs996j87eT+DOj9wGLuF9N7Gv24/r+qv
         sx3sudJIWxmNPmv7+t5mlurtM8u7pcZECnJvdDV8cTChr9kHZNw/bZEb+jGbiHUa1sSF
         S4qqopyqwhnbrGECqiP6lmUFiyNfMfjM2N9Vp61jDRS6AOb73p/EC48M9g6TceXgfS1a
         fl7bK9KiE+0uUmGZg7fykiw6azm90itr25JIEgyPoGGyE2sAmlzoXapFczRDnfmc2WwH
         PslJZ0EtbdELlQMjxEUFRps83Q0YkcvOgqUvdhylvWwIMykt4oxPmFiDkfAHN8GjrAxl
         jl5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pXZ2v7HjzFFRpB5Yb99oi4UQxO6d/40fj8fo35P19Ms=;
        b=Hflp5XMUKNEJ9TVIWcf4LS644ZHXRYBdEXRR/68UfJMw9qlgzrW4qtZpsSMrsqdwqw
         3U7hc32b++C31aCAh+Y6Tq1r+KrFcoAkCV5kIt5uiK/IPhgTh9VSXF0QiZe5IP2KBOMH
         tQ+VmCGBd2/jq9ssw1wvYDjWtHIHdnEDKR/TK8WEd0JDK1xJfVOA8aecxGfu/e1vqr5r
         B3TUlp9m6q9q6pn76/JLBIzJJfumQuNL8TTOBAzxAeLWH+aQ0a+652sgNEpFAiEePOsh
         TlUib+WDnq7p+Hyifqy+OsIALLUEo1Qx4RFP4I7AYP3ZmS9mdDVuinmWVl8YoWgn4H75
         cNcA==
X-Gm-Message-State: AOAM533OXqGa26/rzFSXj09FhykQuwQ583zkhwOUg5QIY+G3sEgfledc
        spW9K+tOcpJ+iGEPpAhZNoRXP07WGQ34C07sfaQ=
X-Google-Smtp-Source: ABdhPJw876iNrPu0yPl1+LWcUsgyypfRV+XCIb2BbGXzeFQlhkDSqhXsL6F2alF6p5KaCSS6skKyPvPeaIMTqUmSoAM=
X-Received: by 2002:a25:9942:: with SMTP id n2mr41061876ybo.230.1621916141856;
 Mon, 24 May 2021 21:15:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210525025659.8898-1-thunder.leizhen@huawei.com> <20210525025659.8898-2-thunder.leizhen@huawei.com>
In-Reply-To: <20210525025659.8898-2-thunder.leizhen@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 24 May 2021 21:15:30 -0700
Message-ID: <CAEf4BzbXtF457D1dj+01Knp6Q6N8bWiHDqEsA10+sQSp-K5jgw@mail.gmail.com>
Subject: Re: [PATCH 1/1] bpf: fix spelling mistakes
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 7:57 PM Zhen Lei <thunder.leizhen@huawei.com> wrote:
>
> Fix some spelling mistakes in comments:
> aother ==> another
> Netiher ==> Neither
> desribe ==> describe
> intializing ==> initializing
> funciton ==> function
> wont ==> won't          //Move the word 'the' at the end to the next line,
>                         //because it's more than 80 columns

commit message is not a code, so I removed this C++ comment and made
it a bit more human-readable. Applied to bpf-next, thanks!

> accross ==> across
> pathes ==> paths
> triggerred ==> triggered
> excute ==> execute
> ether ==> either
> conervative ==> conservative
> convetion ==> convention
> markes ==> marks
> interpeter ==> interpreter
>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  include/linux/bpf_local_storage.h |  2 +-
>  kernel/bpf/bpf_inode_storage.c    |  2 +-
>  kernel/bpf/btf.c                  |  6 +++---
>  kernel/bpf/devmap.c               |  4 ++--
>  kernel/bpf/hashtab.c              |  4 ++--
>  kernel/bpf/reuseport_array.c      |  2 +-
>  kernel/bpf/trampoline.c           |  2 +-
>  kernel/bpf/verifier.c             | 12 ++++++------
>  8 files changed, 17 insertions(+), 17 deletions(-)
>
> diff --git a/include/linux/bpf_local_storage.h b/include/linux/bpf_local_storage.h
> index b902c580c48d..6915ba34d4a2 100644
> --- a/include/linux/bpf_local_storage.h
> +++ b/include/linux/bpf_local_storage.h
> @@ -71,7 +71,7 @@ struct bpf_local_storage_elem {
>         struct bpf_local_storage __rcu *local_storage;
>         struct rcu_head rcu;
>         /* 8 bytes hole */
> -       /* The data is stored in aother cacheline to minimize
> +       /* The data is stored in another cacheline to minimize
>          * the number of cachelines access during a cache hit.

also s/access/accessed/

>          */
>         struct bpf_local_storage_data sdata ____cacheline_aligned;
> diff --git a/kernel/bpf/bpf_inode_storage.c b/kernel/bpf/bpf_inode_storage.c
> index 2921ca39a93e..96ceed0e0fb5 100644
> --- a/kernel/bpf/bpf_inode_storage.c
> +++ b/kernel/bpf/bpf_inode_storage.c
> @@ -72,7 +72,7 @@ void bpf_inode_storage_free(struct inode *inode)
>                 return;
>         }
>

[...]
