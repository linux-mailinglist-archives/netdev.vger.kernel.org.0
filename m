Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB607369DB0
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 02:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237154AbhDXASa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 20:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240146AbhDXASS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 20:18:18 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87E2C061756;
        Fri, 23 Apr 2021 17:12:56 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id b38so16322013ljf.5;
        Fri, 23 Apr 2021 17:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JqEYldf8rH5nK8uqd8hXgk6MXCsNYg+ocZG7CbHu0ws=;
        b=ICycUdOG160t2Rd4RVtyA0ux8qzqKzE7KZGpLRO64qYy1Pac7E4NkoY1dBr1TjRZQs
         jeRUHLqt8xpQ+6BiryLnntA/hNlDQEBIMTV97fk9LNuhgYQwNMLDqYXYfPnF89wGXDod
         KklCyDJVM4cPmx906SJbRSqLcRVQm/dAPfZtG++3266XK0DX+RqFjS6gFvguHEh4CN5y
         cQ0/VfqTQquxwT9qASqE9Wnug6rC0TZODD1FUONxghsMVCdlTo2slsoxthQHPaZ/4tBs
         cQuJ/2HBmFJM1jIr7MGoqcZyWV4HiCkgXy4pr5/Xw8F8dbKmVpJboNzoTnE8Rtdg4+cT
         SUYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JqEYldf8rH5nK8uqd8hXgk6MXCsNYg+ocZG7CbHu0ws=;
        b=C7tuhjzNZ99oLDW9VCBhKe5U7+NUTDR2J0zpwll6SqjLubhzSA6Aqzu1CedfKUGk93
         CBZhAzZXOXAGRnCECfZg+zpUrK+M0kcxxfQo4GuS62ZO0C1hb5igEaQGJOWW6Kp53ceH
         Hj/i/MhErUznf/rgAZWxODC2Q+CuERzslFeUoZlSL8LsY8TnqakHpHa6cSQpM4qtefnK
         TZ+r94lvoK1Ek0eJZqrZ+WAxezTG6wwBZ2N3gRKFlnArTirjv4Rjc5QPhcwsWxthgjjn
         8HtTCP4JmM9Oe1Q17ngbLalfj67+6Tsjd2AgJLlKAMV3PATWOq6LONeBstZ1yPvHo+q+
         gD9w==
X-Gm-Message-State: AOAM530i/6lwaK1O+OEuJ/Z6LO0+orW4hzMJaf0Us80ZBqEcGMlLpklH
        g6kS5U0Jb3I8WYbAcZyRi32xOB5BoRXerL3zV88=
X-Google-Smtp-Source: ABdhPJySXOX+6KNS5l3nzl3RAInlHL041eEhsLf+07F5czwWIRwnCOl+BE4w1KeFQ4MS7npskiMwNXXlP1mYO7Nprng=
X-Received: by 2002:a2e:9f49:: with SMTP id v9mr4186669ljk.44.1619223175355;
 Fri, 23 Apr 2021 17:12:55 -0700 (PDT)
MIME-Version: 1.0
References: <1619141010-12521-1-git-send-email-yangtiezhu@loongson.cn>
 <221ef66a-a7e4-14b7-e085-6062e8547b11@fb.com> <YIMP3flCE6uwYp69@kernel.org>
In-Reply-To: <YIMP3flCE6uwYp69@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 23 Apr 2021 17:12:44 -0700
Message-ID: <CAADnVQJyX718j1FNEDVYVXv2R4Zgm3xPT1wKr-F_Kwe+Pckgqw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Document the pahole release info related to
 libbpf in bpf_devel_QA.rst
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Yonghong Song <yhs@fb.com>, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xuefeng Li <lixuefeng@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 11:20 AM Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
>
> Em Thu, Apr 22, 2021 at 09:12:19PM -0700, Yonghong Song escreveu:
> >
> >
> > On 4/22/21 6:23 PM, Tiezhu Yang wrote:
> > > pahole starts to use libbpf definitions and APIs since v1.13 after the
> > > commit 21507cd3e97b ("pahole: add libbpf as submodule under lib/bpf").
> > > It works well with the git repository because the libbpf submodule will
> > > use "git submodule update --init --recursive" to update.
> > >
> > > Unfortunately, the default github release source code does not contain
> > > libbpf submodule source code and this will cause build issues, the tarball
> > > from https://git.kernel.org/pub/scm/devel/pahole/pahole.git/ is same with
> > > github, you can get the source tarball with corresponding libbpf submodule
> > > codes from
> > >
> > > https://fedorapeople.org/~acme/dwarves
> > >
> > > This change documents the above issues to give more information so that
> > > we can get the tarball from the right place, early discussion is here:
> > >
> > > https://lore.kernel.org/bpf/2de4aad5-fa9e-1c39-3c92-9bb9229d0966@loongson.cn/
> > >
> > > Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> > > ---
> > >   Documentation/bpf/bpf_devel_QA.rst | 13 +++++++++++++
> > >   1 file changed, 13 insertions(+)
> > >
> > > diff --git a/Documentation/bpf/bpf_devel_QA.rst b/Documentation/bpf/bpf_devel_QA.rst
> > > index d05e67e..253496a 100644
> > > --- a/Documentation/bpf/bpf_devel_QA.rst
> > > +++ b/Documentation/bpf/bpf_devel_QA.rst
> > > @@ -449,6 +449,19 @@ from source at
> > >   https://github.com/acmel/dwarves
> > > +pahole starts to use libbpf definitions and APIs since v1.13 after the
> > > +commit 21507cd3e97b ("pahole: add libbpf as submodule under lib/bpf").
> > > +It works well with the git repository because the libbpf submodule will
> > > +use "git submodule update --init --recursive" to update.
> > > +
> > > +Unfortunately, the default github release source code does not contain
> > > +libbpf submodule source code and this will cause build issues, the tarball
> > > +from https://git.kernel.org/pub/scm/devel/pahole/pahole.git/ is same with
> > > +github, you can get the source tarball with corresponding libbpf submodule
> > > +codes from
> > > +
> > > +https://fedorapeople.org/~acme/dwarves
> > > +
> >
> > Arnaldo, could you take a look at this patch? Thanks!
>
> Sure, he documented it as I expected from a previous interaction about
> this. Would be good to add a paragraph stating how to grab libbpf and
> graft it even on a tarball not containing it tho.
>
> Bonus points if the cmake files gets changed in a way that this gets
> notified to the user in the error message.
>
> But these suggestions can come in another patch, for this I can give my:
>
> Reviewed-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Applied. Thanks everyone.
