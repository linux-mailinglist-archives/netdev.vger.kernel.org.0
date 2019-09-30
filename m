Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1278AC2A23
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 00:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731914AbfI3W6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 18:58:48 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45382 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731685AbfI3W6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 18:58:47 -0400
Received: by mail-qt1-f194.google.com with SMTP id c21so19167533qtj.12;
        Mon, 30 Sep 2019 15:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cvCTcx43JDg1o6KPY5fDSJTzdGhnKOviIKAIHHSnoeI=;
        b=pvymu7VeESp4BaH6p35MroG5OK7PLwJMqW7vJJx0W8ajfBzAjnZFz1GOe+TtSVWS6Y
         Ft74dgo8akgHikqAMHkRh+dKShlc4GVKBhIg2tBN3ef8pUsE59YAWoq1kCzkqv0eqTmN
         xvSFrYXrKs88bwLf5ZGa2tExHnVmtVG0OiX6eUxAdGwXiBq0BRpemcoKvSpR74EhKvmx
         9sM4yCgwtG8tLL6RVOnpBKShsZ3tudjg5N5KDRsmdQho/QawGWSmETd/B6vfz9G5P1K8
         cAXxItfc4cwjgTGKEwER8D7jhZ9ql+kRPbC4L+sr81iA9yfIzzhv3cjCOtJTyaIi8Wga
         Dg+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cvCTcx43JDg1o6KPY5fDSJTzdGhnKOviIKAIHHSnoeI=;
        b=Zg+cEM8JBcXxtcfLKZOB8TsLE4YBGhyYhd3OPHAWxmeEOvg07a5xzNsQfg1F308olR
         Tm8mu665H4tWyZzC2dCkLiP7H/4WffKovqgPG013dR1J39wk4E8E+3GAHIEFTGmVHonh
         V5VUpwJX9380K9MxEEl6sKZ7DopEt7ebylTdWSk0nzrZEG08NfNIa7SjYXp+8POSxAgG
         1/zgtSbotXMrbpLWxmu2TAfH3VGARE2Ok7/MnKsaOvXdY0GRcYMnEUuh+8pXLCwwGLAs
         Hhq9ShH+jQWVyHu19YMv1uUpwpci+4pY0ioN9Ncz90Z3LM1koAH3GbKSMJs08tlW+uC0
         mRWQ==
X-Gm-Message-State: APjAAAW+XkkLMhRSY4bsQqQRyT1m+FAEUkgNhrQ3K6HGtkE4ngTrME+D
        yvJeSz0s81piMIEFnK+lzNDfmsS3KSxOfBnD/OE=
X-Google-Smtp-Source: APXvYqz8QjXfyMdU7bHG/VQoO+Hok1DHYk+5fo6q/VjSYjeEHG1vou/JweDL+45RxpohymsVQgM+xKYTCZjNtjioAs0=
X-Received: by 2002:a05:6214:114a:: with SMTP id b10mr22523228qvt.150.1569884326168;
 Mon, 30 Sep 2019 15:58:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190930185855.4115372-1-andriin@fb.com> <20190930185855.4115372-3-andriin@fb.com>
 <CAPhsuW6RHaPceOWdqmL1w_rwz8dqq4CrfY43Gg7qVK0w1rA29w@mail.gmail.com>
In-Reply-To: <CAPhsuW6RHaPceOWdqmL1w_rwz8dqq4CrfY43Gg7qVK0w1rA29w@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Sep 2019 15:58:35 -0700
Message-ID: <CAEf4BzaPdA+egnSKveZ_dE=hTU5ZAsOFSRpkBjmEpPsZLM=Y=Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
To:     Song Liu <liu.song.a23@gmail.com>
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

On Mon, Sep 30, 2019 at 3:55 PM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Mon, Sep 30, 2019 at 1:43 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Make bpf_helpers.h and bpf_endian.h official part of libbpf. Ensure they
> > are installed along the other libbpf headers.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Can we merge/rearrange 2/6 and 3/6, so they is a git-rename instead of
> many +++ and ---?

I arranged them that way because of Github sync. We don't sync
selftests/bpf changes to Github, and it causes more churn if commits
have a mix of libbpf and selftests changes.

I didn't modify bpf_helpers.h/bpf_endian.h between those patches, so
don't worry about reviewing contents ;)

>
> Thanks,
> Song
