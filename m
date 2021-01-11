Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926D42F20FB
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 21:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390553AbhAKUj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 15:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387533AbhAKUj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 15:39:57 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90551C061794;
        Mon, 11 Jan 2021 12:39:16 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id b64so52705ybg.7;
        Mon, 11 Jan 2021 12:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R4z8VuhNyMDL7g096sbikTkm1i+21r0leC/d47KG000=;
        b=ZJeLWXP4rm29LpTASshdqb2QPKHYF7FZlN1CyQCn7y3N5TZAG81UbOkHMEOrTHs/Yp
         Id1Kj+czxOJ3iBhERZDdaVf3lt2WnVkKmaOzb/kUfB4vtjJkB9zzjWpGAG149FOdON8i
         3d8IwdN8Vo8X5ckoqon9dFdRFXgRo2ruGw6acRHduw3klS0YSQQ2dbVvI1LebpvnCQqt
         bMBrWbx0MnvaWTqDseoJOc8dLzXCTcDgU2SSrHfdqSjNA7e4G0VpNXlgBdtXgyUePqKz
         GyHmyZ19FVO8XDuwaflslYk2FoSdh7D1CZE0W0nNYuL2+maaih7gR0RHr+k9g0Zu1c1l
         HI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R4z8VuhNyMDL7g096sbikTkm1i+21r0leC/d47KG000=;
        b=PWUZZqbi504IpmfSJOxME2+frmkIdVCIffV4sMnyCdoQjkmhvMmFzMybtZwtnAR/kE
         ASMpIo5q06Nvne9z5POvRivDa9gE3miqIVusYzcKkE0ALIrfjJWQGNcJV/9RURXIZA53
         zMbS9vcb0D4xGINkkaNHxD+cqzXJpXLhWMQlV+FpyzTgWGElSU0ggD6NjImUxTNzav3h
         Rw6JzX4iPTXrHXm4UC8gmEpIuuDR0augxVcxnsUdGeyP1MhDRBtNg8sOmkWV53fJp9FF
         k/7C9IAry4m/Tb4KmhJ9F1SnKG83VqWQpthYA94aPaQZvFNpgCXjBYDPjTngPSfwfYzi
         +V8w==
X-Gm-Message-State: AOAM530654uW0aPt922cjc3WXVyaXanGxryAbs5n0VZP6RlRrZVPFWDR
        1ziXWABfSYJbF7vFKydAADuWepnxssM8HqQxIF0=
X-Google-Smtp-Source: ABdhPJzy85RUE/nM7uiN77b46n1I1uFND5gf1iCHGJMDBBwXvVmPHE3iNagHqaCJEW2rzJ5Wqkg75zo5lrC4A/x0228=
X-Received: by 2002:a25:d6d0:: with SMTP id n199mr2172909ybg.27.1610397555867;
 Mon, 11 Jan 2021 12:39:15 -0800 (PST)
MIME-Version: 1.0
References: <20210111153123.GA423936@ubuntu> <17629073-4fab-a922-ecc3-25b019960f44@iogearbox.net>
 <CANaYP3FiB-+Zs3C27VgPW+4Ltg8b9dErYAoX7Gu2WqkczcC8vw@mail.gmail.com>
In-Reply-To: <CANaYP3FiB-+Zs3C27VgPW+4Ltg8b9dErYAoX7Gu2WqkczcC8vw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Jan 2021 12:39:05 -0800
Message-ID: <CAEf4BzaG2q-4qFZ0WDhbfPJL70T7z84CE=MoKkT2peOXrx28cw@mail.gmail.com>
Subject: Re: [PATCH] Signed-off-by: giladreti <gilad.reti@gmail.com>
To:     Gilad Reti <gilad.reti@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 8:06 AM Gilad Reti <gilad.reti@gmail.com> wrote:
>
> On Mon, Jan 11, 2021, 17:55 Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > Hello Gilad,
> >
> > On 1/11/21 4:31 PM, giladreti wrote:
> > > Added support for pointer to mem register spilling, to allow the verifier
> > > to track pointer to valid memory addresses. Such pointers are returned
> > > for example by a successful call of the bpf_ringbuf_reserve helper.
> > >
> > > This patch was suggested as a solution by Yonghong Song.
> >
> > The SoB should not be in subject line but as part of the commit message instead
> > and with proper name, e.g.
> >
> > Signed-off-by: Gilad Reti <gilad.reti@gmail.com>
> >
> > For subject line, please use a short summary that fits the patch prefixed with
> > the subsystem "bpf: [...]", see also [0] as an example. Thanks.
> >
> > It would be good if you could also add a BPF selftest for this [1].
> >
> >    [0] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=e22d7f05e445165e58feddb4e40cc9c0f94453bc
> >    [1] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/testing/selftests/bpf/
> >        https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/testing/selftests/bpf/verifier/spill_fill.c
> >
>
> Sure. Thanks for your guidance. As you can probably tell, I am new to
> kernel code contribution (in fact this is a first time for me).
> Should I try to submit this patch again?

In addition to all already mentioned things, also make sure you have
[PATCH bpf] prefix in the subject, to identify that this is a bug fix
for the bpf tree.

Also you missed adding Fixes tag, please add this:

Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier
support for it")

And yes, please re-submit with all the feedback incorporated
(including the selftest).

>
> Sorry in advance for all the overhead I may be causing to you...
>
> > > ---
> > >   kernel/bpf/verifier.c | 2 ++
> > >   1 file changed, 2 insertions(+)
> > >
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index 17270b8404f1..36af69fac591 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -2217,6 +2217,8 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
> > >       case PTR_TO_RDWR_BUF:
> > >       case PTR_TO_RDWR_BUF_OR_NULL:
> > >       case PTR_TO_PERCPU_BTF_ID:
> > > +     case PTR_TO_MEM:
> > > +     case PTR_TO_MEM_OR_NULL:
> > >               return true;
> > >       default:
> > >               return false;
> > >
> >
