Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA535D5B8
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 19:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfGBRyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 13:54:12 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:43685 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfGBRyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 13:54:11 -0400
Received: by mail-io1-f66.google.com with SMTP id k20so12739001ios.10;
        Tue, 02 Jul 2019 10:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4SxTyhIcg3+qLl0diKxGNqrI+DVjZ+HIytvBevQdK5U=;
        b=Y2KEZRxSiW1w+yzwKAx6dWbJE8qZYtTazVd++IzLk/ancCWwbOT54jM+m6I9m927vo
         LvapFQdgY3Xpt3sGN5dXGGqsFpqCgzyQyYKzaNo2CoWtLUU+D0tEbsd8bIko24mq2En9
         CjEA097rW1mTUa6iDmGaq9a53/yJBvrpJqlzWutZvyute8mndrQJKkNnE0DUk3/FufVZ
         wu+wxHeMionfbQxnV+8BZq2G+xY5pWpRG3kc8zAUNP1cgVy8RefIvkZKWgh9t1LImlkU
         EVAbx0g0A3IcVKy2BoVmyAlvMm7xx2haMedqGVB4bGzYvs1B76XtQeEVigIn1fwMX1hg
         K2wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4SxTyhIcg3+qLl0diKxGNqrI+DVjZ+HIytvBevQdK5U=;
        b=nIqjiZMgIq9J7arcBW6XbgUrPwC/giM4ApM1MAjVqMA+v5m2HFth+p6dp17BSs/xzm
         1vqocYD++8GqTr0Jh2ljHCZiq1TgffyBIRcTcq7At6d5hQvAts+hJXU8pM/uaC9As/Pw
         Mha1gmuv3Ut5Ho/M3bCwTW4PRf6hrzyVyosDfzNdMeVOkeVyfvvyHNiGoq19vXuudR4H
         0fxQEOSzQyE59wYYbsmpyedvjJzmpKlJvZeo/deTmZrwYJXs4/yH0juWZ9q5poUS2vb5
         hWdg5rmtkd7KKNCOngiOKt04zo4yxI8gp/nYTLfxnP1nENVLg+9IBKh6VcSApiEvCKK6
         7JDg==
X-Gm-Message-State: APjAAAXnqNsFq8/AVt0DZVs8617uNQVv5dqmnjZmkPW3CcJgF+IYF555
        y73yC++e/If6Pqc8yQIk0LVekBpeajD1xGt8ANFvfSvA
X-Google-Smtp-Source: APXvYqy12ib+QiknsniPWEIIgY9CVXdQwQpzSonBEkQvIzRrbW3iy5WZwl4EufLAsbYdA1blichu/7Z8NNCbWjNBwj8=
X-Received: by 2002:a05:6638:199:: with SMTP id a25mr36733180jaq.18.1562090050662;
 Tue, 02 Jul 2019 10:54:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190702153908.41562-1-iii@linux.ibm.com> <CAH3MdRUk5x2D9yRuKpGpVuDMFF0JbYeB+Y0Qz6chtPgfm-1vxA@mail.gmail.com>
 <1AE29825-8FB2-4682-8822-5F3D16965657@linux.ibm.com>
In-Reply-To: <1AE29825-8FB2-4682-8822-5F3D16965657@linux.ibm.com>
From:   Y Song <ys114321@gmail.com>
Date:   Tue, 2 Jul 2019 10:53:34 -0700
Message-ID: <CAH3MdRXZtsiLNyJ2y3rf2XVfa+j=BJCQktARncgnzFvSAKo=-g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix compiling loop{1,2,3}.c on s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 9:58 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> > Am 02.07.2019 um 18:42 schrieb Y Song <ys114321@gmail.com>:
> >
> > On Tue, Jul 2, 2019 at 8:40 AM Ilya Leoshkevich <iii@linux.ibm.com> wro=
te:
> >>
> >> -#elif defined(__s390x__)
> >> -       #define bpf_target_s930x
> >
> > I see in some other places (e.g., bcc) where
> > macro __s390x__ is also used to indicate a s390 architecture.
> > Could you explain the difference between __s390__ and
> > __s390x__?
>
> __s390__ is defined for 32-bit and 64-bit variants, __s390x__ is defined
> for 64-bit variant only.

Thanks.

>
> >> #if defined(bpf_target_x86)
> >>
> >> +#ifdef __KERNEL__
> >
> > In samples/bpf/,  __KERNEL__ is defined at clang options and
> > in selftests/bpf/, the __KERNEL__ is not defined.
> >
> > I checked x86 pt_regs definition with and without __KERNEL__.
> > They are identical except some register name difference.
> > I am wondering whether we can unify into all without
> > __KERNEL__. Is __KERNEL__ really needed?
>
> Right now removing it causes the build to fail, but the errors look
> fixable. However, I wonder whether there is a plan regarding this:
> should eBPF programs be built with user headers, kernel headers,
> or both? Status quo appears to be "both", so I=E2=80=99ve decided to stic=
k with
> that in this patch.

Your patch is okay in the sense it maintains the current behavor.
I think it is okay since user level and kernel pt_regs layout are the same
except certain names are different.

>
> >> +/* s390 provides user_pt_regs instead of struct pt_regs to userspace =
*/
> >> +struct pt_regs;
> >> +#define PT_REGS_PARM1(x) (((const volatile user_pt_regs *)(x))->gprs[=
2])
> >
> > Is user_pt_regs a recent change or has been there for quite some time?
> > I am asking since bcc did not use user_pt_regs yet.
>
> It was added in late 2017 in commit 466698e654e8 ("s390/bpf: correct
> broken uapi for BPF_PROG_TYPE_PERF_EVENT program type=E2=80=9C).

Thanks.
