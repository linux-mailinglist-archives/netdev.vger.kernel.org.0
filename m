Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14473100F6
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 00:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhBDXqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 18:46:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbhBDXqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 18:46:37 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADFAC061786;
        Thu,  4 Feb 2021 15:45:57 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id j84so5012053ybg.1;
        Thu, 04 Feb 2021 15:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oh1ncce3nSrKC6/DBk1RSRzmFi096ER7UQuf4BEJPSs=;
        b=STelQC2T1O3MtdVzjPN0nriGbjh3qVqu5OuB33OM/E3eGSv0/IXM5PKRRkeFaKZ+45
         yG39m+bNwuCuQLMM6T20/qB2x/TPxi/8hu90Zp1JOTjpE+ao1afqmTYDWHH4bt1P8Xnj
         RqLY3cEso7ZFXSWIhNHZutnteQ07RzkbdQDwUp4LZaCxOlygW7D0+zli085qwLhLgir+
         qF4KtwcIrXJSWBs2cv2LbXVoAGGu1An1dZkPKtCOj2gEX2RhWbnDESTKabRW+3mlTajW
         SEArgvVa26IkrHUgB/tTBbHE7ag2pGc9GG62BOSUk9Scw/YUzKWIlElYfu6MsZxEo1fT
         ZOmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oh1ncce3nSrKC6/DBk1RSRzmFi096ER7UQuf4BEJPSs=;
        b=MbdjYCSimkxLjQUkSyOJeCBGGyyX7ZK8+ZjnfRdE+9bIphEbai5T8Kvs2NGNkxpRly
         CT6V3n8xLRYucsFn1mHu6UfNbh0pUlTFAQ3zZ3/Urj5cfTTLU11hF0XA4N5DihCUsXED
         t2gV949vrHbBgOkjS7SCW0h6ncEx8Opk2/CZgmZXWtzgN3IiCcIokutXtDw4Oh3l5ABi
         ydFxZmKe3SFzp8gRC0dQhfKoeUC8yOjd0lFpdx3X6iJQXkztXFZqSn9NB8jtc7nnim0J
         t1qLbaJGRohTnXiRX16nOjuJj9m3NpDGwVY0PrdmAGSdXKWyF0WJyO/BF1aB85H60BVa
         A5/Q==
X-Gm-Message-State: AOAM530kTUWuKrs88KhBSV/e4oPcW1PeTZ3fWhqcNTroQaLTKiDiLq9u
        5pIgrZMBxGtiFlOFJsO5aEB4o5KHIQPtLHsS3wwpTQVZs6PRbw==
X-Google-Smtp-Source: ABdhPJxGSlEUrzQpWXzKpksokAFRLp33KOiILBEQscQ24DgItagAjvT/n5Kbhp6Et1Ws5yhJhJhT0K65Q4Cw9ut5oio=
X-Received: by 2002:a25:a183:: with SMTP id a3mr2394636ybi.459.1612482356445;
 Thu, 04 Feb 2021 15:45:56 -0800 (PST)
MIME-Version: 1.0
References: <1612438753-30133-1-git-send-email-yangtiezhu@loongson.cn> <CAPhsuW5M-zkFMo=qpQ1_aQe3cfCQHbdyHGxvcsqGPO-5x5q=3w@mail.gmail.com>
In-Reply-To: <CAPhsuW5M-zkFMo=qpQ1_aQe3cfCQHbdyHGxvcsqGPO-5x5q=3w@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 4 Feb 2021 15:45:45 -0800
Message-ID: <CAEf4BzY44erYhkUAv9dCogj54qkQHyHdNViTUK7xm-y6WObE2g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples/bpf: Add hello world sample for newbies
To:     Song Liu <song@kernel.org>
Cc:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Xuefeng Li <lixuefeng@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 4, 2021 at 11:27 AM Song Liu <song@kernel.org> wrote:
>
> On Thu, Feb 4, 2021 at 3:42 AM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
> >
> > The program is made in a way that everytime an execve syscall
> > is executed it prints Hello, BPF World!
> >
> > This is inspired and based on the code example for the book
> > Linux Observability with BPF [1], load_bpf_file() has been
> > removed after commit ceb5dea56543 ("samples: bpf: Remove
> > bpf_load loader completely"), so the old version can not
> > work in the latest mainline kernel.
> >
> > Since it is very simple and useful for newbies, I think it is
> > necessary to be upstreamed.
>
> I wonder how much value we will get from this sample. If the user is
> able to compile and try the hello world, they are sure able to compile
> other code in samples/bpf. Also, this code doesn't use BPF skeleton,
> which is the recommended way to write BPF programs. Maybe an
> minimal example with BPF skeleton will add more value here?
>

I agree with Song. Plus, we already have similar simple examples that
are set up outside of kernel build infrastructure, which is simpler
for newbies to pick up. Please check [0]:

  [0] https://github.com/libbpf/libbpf-bootstrap/tree/master/src


> Thanks,
> Song
>
>
>
> >
> > [1] https://github.com/bpftools/linux-observability-with-bpf/tree/master/code/chapter-2/hello_world
> >
> > Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> > ---
> >  samples/bpf/Makefile     |  3 +++
> >  samples/bpf/hello_kern.c | 14 ++++++++++++++
> >  samples/bpf/hello_user.c | 42 ++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 59 insertions(+)
> >  create mode 100644 samples/bpf/hello_kern.c
> >  create mode 100644 samples/bpf/hello_user.c
> >

[...]
