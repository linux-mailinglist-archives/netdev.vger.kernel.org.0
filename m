Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C452F1A69
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 17:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387755AbhAKQFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 11:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728569AbhAKQFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 11:05:17 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4970AC061786;
        Mon, 11 Jan 2021 08:04:37 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id jx16so299072ejb.10;
        Mon, 11 Jan 2021 08:04:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TBi9AVliylLSBAh5IQu8XXmi3M4dSapAzhq/jOj2QaE=;
        b=TtwK4LPwq2aryJ5SWXsYeHz7NAXWrSEZwpe9xhhn6yUN1qnztLRq9h9WSr1828ut8H
         7LOiJ7g2lvw6YIs3AB46gaME8u8h55MC0yUbajjEmWZgYIbBMbXQbgd6oKkDA0p4QCTJ
         DijkVNGXIOYDiZYPyhijuohk3BgDEMDd1/nmhKKS9CQUkFaCnKwmOS5OvAw4ZXlXkH7I
         Wv4IsOCLpRdWXkY7jAhsZSrfIB1Yr/jaU7YhgLWyj514KCgTcgb43ztGyw22+te69cFt
         k/Ss5eYSj7hej/bWhYerxhgSk7SCfzXWvlqBLpm4tFAYzxmPTeFExLg0J75D7xjfjDiX
         3zBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TBi9AVliylLSBAh5IQu8XXmi3M4dSapAzhq/jOj2QaE=;
        b=Up0EE4u0+eVQmvz61OACcJO3wkxhU4pgQ077TyKpZPNnEZm07vf56JJ/4owBvfq50Q
         8shtMGk/0sooADAh9bFsJda99sJt1wIF2M3UV6V4ueSDwHa46F/KLZ9mzBdwWXt29jRd
         5v/5rJMT6+SZMay22PFR534/LkbVzzOlRoXk+UaI3YSQqmfkyU6VcPDGw8YzMPUAPUwA
         r+27MQ/v+qzfOAtCSZaSmACcpBGQaLIV15aR66KhUf/jTsDFw1+/0d1f2vrI4rnMt9rY
         +mbS6JWS6N8goJIm3HichBSWpK1nZpSl8K0nK3+9XNc1m6zcQ4tGseN8vu0lYEqQY0Fc
         eyng==
X-Gm-Message-State: AOAM533F/m3mc4HMuX4z5MNlKSp+jHMyeSWBbo2Ejl+qsMlfGuS1qCBB
        gApZznG/2fS3LpCEhoxEsYAjoYoddWRAg8Zck1g=
X-Google-Smtp-Source: ABdhPJwicr/8p8Lg8kZ5sBTmM8reppnS5mVWjlgfLmj0pcS+YLyVsBdxIoFMeyYdXvKjec8VVofVkgKK/zGMdrk8xow=
X-Received: by 2002:a17:907:546:: with SMTP id wk6mr129359ejb.238.1610381076001;
 Mon, 11 Jan 2021 08:04:36 -0800 (PST)
MIME-Version: 1.0
References: <20210111153123.GA423936@ubuntu> <17629073-4fab-a922-ecc3-25b019960f44@iogearbox.net>
In-Reply-To: <17629073-4fab-a922-ecc3-25b019960f44@iogearbox.net>
From:   Gilad Reti <gilad.reti@gmail.com>
Date:   Mon, 11 Jan 2021 18:03:58 +0200
Message-ID: <CANaYP3FiB-+Zs3C27VgPW+4Ltg8b9dErYAoX7Gu2WqkczcC8vw@mail.gmail.com>
Subject: Re: [PATCH] Signed-off-by: giladreti <gilad.reti@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021, 17:55 Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Hello Gilad,
>
> On 1/11/21 4:31 PM, giladreti wrote:
> > Added support for pointer to mem register spilling, to allow the verifier
> > to track pointer to valid memory addresses. Such pointers are returned
> > for example by a successful call of the bpf_ringbuf_reserve helper.
> >
> > This patch was suggested as a solution by Yonghong Song.
>
> The SoB should not be in subject line but as part of the commit message instead
> and with proper name, e.g.
>
> Signed-off-by: Gilad Reti <gilad.reti@gmail.com>
>
> For subject line, please use a short summary that fits the patch prefixed with
> the subsystem "bpf: [...]", see also [0] as an example. Thanks.
>
> It would be good if you could also add a BPF selftest for this [1].
>
>    [0] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=e22d7f05e445165e58feddb4e40cc9c0f94453bc
>    [1] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/testing/selftests/bpf/
>        https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/testing/selftests/bpf/verifier/spill_fill.c
>

Sure. Thanks for your guidance. As you can probably tell, I am new to
kernel code contribution (in fact this is a first time for me).
Should I try to submit this patch again?

Sorry in advance for all the overhead I may be causing to you...

> > ---
> >   kernel/bpf/verifier.c | 2 ++
> >   1 file changed, 2 insertions(+)
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 17270b8404f1..36af69fac591 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -2217,6 +2217,8 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
> >       case PTR_TO_RDWR_BUF:
> >       case PTR_TO_RDWR_BUF_OR_NULL:
> >       case PTR_TO_PERCPU_BTF_ID:
> > +     case PTR_TO_MEM:
> > +     case PTR_TO_MEM_OR_NULL:
> >               return true;
> >       default:
> >               return false;
> >
>
