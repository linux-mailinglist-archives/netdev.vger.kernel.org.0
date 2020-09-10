Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C33B2650B5
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgIJU0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgIJUZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:25:08 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862B3C061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 13:25:07 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id q10so4028427qvs.1
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 13:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YkhahZJmcVyE+N6qWWXQFYNHp32pWxDW4FSredXVabk=;
        b=elbc94XM3ceVgQnnBSjGH0KOEfAlih9DKT3WB164JIbH1ngVEN5n0B+q4F69a6JXQn
         IIgxKy/oCmLQn/MFT2gURpv3W5esAD/Y8dLPleaUzAfC81mqTLoAYSXCgJaXWUPN/oUv
         v8jXCzun5km/4A/zVfqszgAEaPl5Mr7YNuTL1tOEy8+tPsYf2KliZHe6HJfJAsrKl+5v
         Sdk0/n5Z4zAmPnl4KCM5oir4KlbbvH66HjL3rTiYunn1+az+WFqRhL//vmVWcDOvjG1I
         /BFTdJ/BGAX+/hDg9QR4IYlkxMomeup+ORC5T4MlIpl8gIn6UNqbDPs8ojCFt8xVfFcK
         v8SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YkhahZJmcVyE+N6qWWXQFYNHp32pWxDW4FSredXVabk=;
        b=dfH/OH9O7I7Fx4mluL30992HA1tEgjtDz+j5jc6kyTMLx7c8m0kdSTLRb4TJsbxMGU
         Ai6Tk41AR9tG1TYxx8V7HpWoe7bdNjpDvBzv/XxSK4MiEYprUGpmAcd1wXGRwMO8f/U+
         GPc+gVUPOkT4G3BH1ZsRQzBDLtEFFfb6/mSe0BRHBV/UwFDHhfJZTcD8scbW9qgI1lmN
         2ikI7H5kPzdTxk5JKoEndDohapGUHixLQOlVT6Qr438xK5I0fSBZnQgdIJ+PkosnBmCl
         Z/vVAnecKtvTmDG0EDx8MRmY/cRXkcn+ypfpjOSgsfWsttRqn8Hw9eu8EstuNP7MQoQT
         TvrQ==
X-Gm-Message-State: AOAM532xcM27IuiRGxOiKaDBrxGyGOaGknSqB4nhzKMv4rC5ludDiRPm
        ozWXUFr+6w/F4xizeLTjj86B3EoDsSqEGhEWSCVzRg==
X-Google-Smtp-Source: ABdhPJxfUjwCVnP2CmMuW0g6X2PvyXN4nGc8maiaODTngttgx/cBIYS/jAj3t6JAy3WXzPpYHoFw6wLHHi3RGU1eq6M=
X-Received: by 2002:a0c:f48e:: with SMTP id i14mr10388494qvm.5.1599769506460;
 Thu, 10 Sep 2020 13:25:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200909162500.17010-1-quentin@isovalent.com> <20200909162500.17010-4-quentin@isovalent.com>
 <CAADnVQ+b3y1LFRppZu5GYW6hZY6nSZc3wQKqpqHbevdNHNSCSA@mail.gmail.com>
In-Reply-To: <CAADnVQ+b3y1LFRppZu5GYW6hZY6nSZc3wQKqpqHbevdNHNSCSA@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Date:   Thu, 10 Sep 2020 21:24:55 +0100
Message-ID: <CACdoK4+1mbhkJ=uGrfhUF3hRnX3-+Ai2FcMfBkgqs6YB++=mkw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/3] tools: bpftool: automate generation for
 "SEE ALSO" sections in man pages
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 at 19:18, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Sep 9, 2020 at 9:25 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >
> > The "SEE ALSO" sections of bpftool's manual pages refer to bpf(2),
> > bpf-helpers(7), then all existing bpftool man pages (save the current
> > one).
> >
> > This leads to nearly-identical lists being duplicated in all manual
> > pages. Ideally, when a new page is created, all lists should be updated
> > accordingly, but this has led to omissions and inconsistencies multiple
> > times in the past.
> >
> > Let's take it out of the RST files and generate the "SEE ALSO" sections
> > automatically in the Makefile when generating the man pages. The lists
> > are not really useful in the RST anyway because all other pages are
> > available in the same directory.
> >
> > v2:
> > - Use "echo -n" instead of "printf" in Makefile, to avoid any risk of
> >   passing a format string directly to the command.
> >
> > Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
>
> This patch failed to git am, but I've applied the first two patches.
> Thanks

Right, there is a conflict with the other patchset passing
$(RST2MAN_OPTS) to rst2man when building the doc. I'll rebase and
repost this one. Thank you Alexei.

Quentin
