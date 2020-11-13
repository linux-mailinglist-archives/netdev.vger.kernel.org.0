Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584132B1342
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 01:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgKMAcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 19:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgKMAcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 19:32:22 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683BBC0613D1;
        Thu, 12 Nov 2020 16:32:22 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id t33so7167499ybd.0;
        Thu, 12 Nov 2020 16:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AcGR7/6cTqAEkquhJFlCml6zNS6RnwLFxeSv4GObHxg=;
        b=NFwJPmKQCvOiV4bcOkBUY+h07Su2wkD1RynZvYFkEzcGYZIBGHG3MPUpd8JTpQMEKF
         ydUBU3lTVciUx5N9S9anhvny8feTHEsfpJwDAhk1NjF2aJnfIdOI1pbYVAJ4iNhTT97z
         a+e7h5t48Bj5Cc9yxOaPTke5g5NZfmQ9vsbSQ3yx22RrVYg7bgPt3TSO0AKozZD/hJ3e
         XotfVxdAogwMqvFUoQBCeHx0cQhbQhXNTMHs2YHNzyjo6cgbJF/jp2UVhdRvlotSuW5A
         gDD3f2jvON5MR4Cg2XWmumAbIkJ7o5EXxztsguvQ5VxrviO19Py/bn8zzdVlZlJEuV2J
         lIeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AcGR7/6cTqAEkquhJFlCml6zNS6RnwLFxeSv4GObHxg=;
        b=DEmuHwP3BpLGxs+Kxh3jkrTqatsyWNb9Blzh6UunirBh8ArSUR67PPZhVBR0Syf0Cb
         WfwvSAfFUeyGZv5ph7nczW/xpw44fzsyrQq96dIudm5ot06sxfHXI7OItAKQnV/CrZJe
         21k8hjTemlK+tIHb8SnWAdcQBte4AcjSQ/0pfaZMed6m7iPMdnLVU8qFTxWbo0AQFej0
         3YTEBXgypc8HDqNm3lNYh2oyIfC+k2WEj33118IYo50KuZLxZoGiux2EsfrTh8amZ4aR
         oFeoW46YuCKeLEmj9w5X2vb3YH4J2CPX00UIxGKz8AS7pCPDyMQuw/QWabiXGqp77rgh
         q2EQ==
X-Gm-Message-State: AOAM531bcDJAlWJ7Q4wSJqwmSPQ4i+cJRmPYBDfJO2S8rYgaDdkFEpq+
        H6+0+2Yk0OuU4fp7fdQc9+HR24JrRtqa3As8l1J0Awgshyc=
X-Google-Smtp-Source: ABdhPJxHrgPsxYF5271/uhF+EfEqigwTqsmvRh+vF9BanqB+/I8kEEWROrNbtaDpPmZ0MNViBQZMHZG3F5NkgetW+Fk=
X-Received: by 2002:a25:bdc7:: with SMTP id g7mr3260671ybk.260.1605227541760;
 Thu, 12 Nov 2020 16:32:21 -0800 (PST)
MIME-Version: 1.0
References: <20201112180340.45265-1-alexei.starovoitov@gmail.com>
 <8d6d521d-9ed7-df03-0a9b-d31a0103938c@iogearbox.net> <87lff68hbm.fsf@toke.dk> <CACYkzJ4miC2x4dAyn0N0pSMbVQF+sLNhaHD7ypgjdPzTC5zzkA@mail.gmail.com>
In-Reply-To: <CACYkzJ4miC2x4dAyn0N0pSMbVQF+sLNhaHD7ypgjdPzTC5zzkA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 12 Nov 2020 16:32:10 -0800
Message-ID: <CAEf4BzYnFFgJhvRW6oSa+xCZs0oPH26W7hLofyhk5_v6ip25NQ@mail.gmail.com>
Subject: Re: [PATCH bpf] MAINTAINERS/bpf: Update Andrii's entry.
To:     KP Singh <kpsingh@chromium.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 12:52 PM KP Singh <kpsingh@chromium.org> wrote:
>
> On Thu, Nov 12, 2020 at 9:13 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> >
> > Daniel Borkmann <daniel@iogearbox.net> writes:
> >
> > > On 11/12/20 7:03 PM, Alexei Starovoitov wrote:
> > >> From: Alexei Starovoitov <ast@kernel.org>
> > >>
> > >> Andrii has been a de-facto maintainer for libbpf and other component=
s.
> > >> Update maintainers entry to acknowledge his work de-jure.
> > >>
> > >> The folks with git write permissions will continue to follow the rul=
e
> > >> of not applying their own patches unless absolutely trivial.
> > >>
> > >> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > >
> > > Full ack, thanks for all the hard work, Andrii!
> >
> > +1 :)
> >
> > -Toke
> >
>
> +1 Thanks for all the work Andrii!!

I'm very flattered, thank you, guys!
