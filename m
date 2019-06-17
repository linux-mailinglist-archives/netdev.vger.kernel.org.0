Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5161E48F1F
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbfFQTat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:30:49 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33701 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbfFQTat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 15:30:49 -0400
Received: by mail-qt1-f193.google.com with SMTP id x2so12271082qtr.0;
        Mon, 17 Jun 2019 12:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=heHfMI8HvMbjQ3YPPxt4J0OSxlkzKtOLqmUyTJkyUTk=;
        b=L5+RXzt+DaBWpS7NogH46s5f7OPSqzWB4euayWYmQUSa0goTeiL1RGZnnbFBTYrpmT
         wBZKqxv18Y9i2+YPwSc0nj8FIH2nX6KpE4bYWlNQiZan9d9b/MpE4QRcDTrdN+zC58a4
         2XUyonOechzRpJ89J6L1gw9dQvI7tTRhy/mTpQYUBubJYuTj5HKjmIIon+0NpRCTr5wP
         uMtrCnJw2mpuhmLomf1lU1DDKpHFl5oAlcHmmI4jsR3kvG1BBSX8MLkMtBAzpv4042kF
         F1bde6vW0RLcZUnlliOnq1pMI1kDhzgAKOeg7ot2mbjHjLHm8EFdy4EK7TyYQd4Ak5+2
         C6mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=heHfMI8HvMbjQ3YPPxt4J0OSxlkzKtOLqmUyTJkyUTk=;
        b=rg+ozXb05T4198Q+3ZJ6Q8P25X5pUmBeGubMGRjFIXjuBmCRhNOSucnl0fSlHxoxCA
         qz3oHaBufrPOYUf9ZSwJ9pg6ZqtwXaGQ6V7pOc1vld4kt/lJozCdrXBg19KReVlItz0X
         ZArEjjh/f6Ws906rH00D/a8YZh/2UhZu75yKKQ+cr+tncCTl5YZ2pWMe31gt20XmudxB
         592WlLa7qVk1cpQ/wC3/A0ogG/ltuPXQa8ziBN7W462Yj+P3flvxAh8vPidIgFa6MwZh
         9Ifwu4SUTb3KRn9Pgb+kwuMQs9PXzHvqz19AKKOgqhnvLbUOYoQQL6dF3MQM2pZJIV0D
         TgKQ==
X-Gm-Message-State: APjAAAWG5l141jkezO4kQFMsno1qDjGXqMx2TzoiJ2t356+EJKhhuQD3
        hR0VHuDcjSvwBqQX0Yy2DO3iUYU7hS+Ei7IZ7pMUnc6O
X-Google-Smtp-Source: APXvYqzJtpAtMiugSbpg/b2+92DQvI5MTM0cRskk/9imOlranjlFhSQi+qCGSJx1HVMYWF534AJQpfzaZppTYJecFRA=
X-Received: by 2002:ac8:290c:: with SMTP id y12mr7279599qty.141.1560799848510;
 Mon, 17 Jun 2019 12:30:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190611044747.44839-1-andriin@fb.com> <20190611044747.44839-9-andriin@fb.com>
 <20190614232329.GF9636@mini-arch> <CAEf4BzZ5itJ+toa-3Bm3yNxP=CyvNm=CZ5Dg+=nhU=p4CSu=+g@mail.gmail.com>
 <20190615000104.GG9636@mini-arch>
In-Reply-To: <20190615000104.GG9636@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 17 Jun 2019 12:30:37 -0700
Message-ID: <CAEf4BzbV-W1KsuN3AuPas_3dG7MVwZO6RsqohS2uvnEf49M67w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 8/8] selftests/bpf: switch tests to BTF-defined
 map definitions
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 5:01 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 06/14, Andrii Nakryiko wrote:
> > On Fri, Jun 14, 2019 at 4:23 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > >
> > > On 06/10, Andrii Nakryiko wrote:
> > > > Switch test map definition to new BTF-defined format.
> > > Reiterating my concerns on non-RFC version:
> > >
> > > Pretty please, let's not convert everything at once. Let's start
> > > with stuff that explicitly depends on BTF (spinlocks?).
> >
> > How about this approach. I can split last commit into two. One
> > converting all the stuff that needs BTF (spinlocks, etc). Another part
> > - everything else. If it's so important for your use case, you'll be
> > able to just back out my last commit. Or we just don't land last
> > commit.
> I can always rollback or do not backport internally; the issue is that
> it would be much harder to backport any future fixes/extensions to
> those tests. So splitting in two and not landing the last one is
> preferable ;-)

So I just posted v2 and I split all the test conversions into three parts:
1. tests that already rely on BTF
2. tests w/ custom key/value types
3. all the reset

I think we should definitely apply #1. I think #2 would be nice. And
we can probably hold off on #3. I'll let Alexei or Daniel decide, but
it shouldn't be hard for them to do that.

>
> > > One good argument (aside from the one that we'd like to be able to
> > > run tests internally without BTF for a while): libbpf doesn't
> > > have any tests as far as I'm aware. If we don't have 'legacy' maps in the
> > > selftests, libbpf may bit rot.
> >
> > I left few legacy maps exactly for that reason. See progs/test_btf_*.c.
> Damn it, you've destroyed my only good argument.

Heh :)

>
> > > (Andrii, feel free to ignore, since we've already discussed that)
> > >
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > ---
> >
> >
> > <snip>
