Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8590832444B
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 20:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235332AbhBXTC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 14:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbhBXTAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 14:00:15 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BE2C061786;
        Wed, 24 Feb 2021 10:59:35 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id x19so2914681ybe.0;
        Wed, 24 Feb 2021 10:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cSsEu65tiotuZe5j8t7xXW3lMRKzi2n9t67tFDg9g/4=;
        b=pPF2Vulep//BS0Ydo5gRPEdPvK1cRlHNXnFh8xJyHqvLYGZ56xVnnbDj8E6XPqsJMg
         XO6OzaplvHeXxkI1U/jpCgm71jkZlaL70R3BqVOQNikjC2yTeyAvtt/tuKa1HdFft773
         qzLxvR8Qa0VoRIH6Uo/iwafmtcTdo63CkXV/6h38atSDc2AKSYkdW2U7jbVUtCy9kaqw
         XGZKiwk3BLNq4L4BHdrPfc5H6TnX3j5o2BXaWSOAupifpRONOfgFEpBkBy0cJ//ryvA1
         WIX1R0cE4dTgT9rY/4b152ZfxVKYfFG5GbdnWIdKqfxmNpONnCgUEBwVahRNbAGZjheu
         ExQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cSsEu65tiotuZe5j8t7xXW3lMRKzi2n9t67tFDg9g/4=;
        b=kUFRnC0JLvm/n5TFQPBslbmzx1esAg4UASl3j4zcMgZzYRNZ0MLLlfX9K9IIluISVo
         zhdFYTi7nwGAehMI5pgjC8lyXfmPVSCvQl0HNDAi+lxUuD91hghtI/kDmcG+iuBH0mzI
         fsZ4k1tOHbcdNQh/8hymTKS4vunRHgH73FMoLeSq8mWVFN9I4lQoHRiE/gQHSqmtP5rH
         sVW5849SNZYwgXuH1Xg7tM+h5VW1K/B8ooDSLs4dhtgr+H5/TxTAommviMOGlUhB3QeE
         bjLYjOXyK1DRn4FTwojCqQWK2nGPV3Wi7YPdWyaizmxv+dnaiWeao1VpRmYImUnSCHW4
         y5Sw==
X-Gm-Message-State: AOAM531t/9fz/U5qn0CAayz7GPYyADvf1syKyEj6SnNoyLsTI8ZiXC5n
        wggaIrNeAyDlE/38+TEWnAiURAm6IOtIaptIU9X6nuDm
X-Google-Smtp-Source: ABdhPJw1N4YCgJ33/I2CNJsZyZ8feAlXSVcd4SPajHaK6HM6DcGMoAGiZPpj7KVlDE/a6y83SSEVBPPWznB2uDp/cfY=
X-Received: by 2002:a25:1e89:: with SMTP id e131mr50076796ybe.459.1614193174807;
 Wed, 24 Feb 2021 10:59:34 -0800 (PST)
MIME-Version: 1.0
References: <20210223124554.1375051-1-liuhangbin@gmail.com>
 <20210223154327.6011b5ee@carbon> <2b917326-3a63-035e-39e9-f63fe3315432@iogearbox.net>
In-Reply-To: <2b917326-3a63-035e-39e9-f63fe3315432@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 24 Feb 2021 10:59:24 -0800
Message-ID: <CAEf4BzaqsyhJvav-GsJkxP7zHvxZQWvEbrcjc0FH2eXXmidKDw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: fix missing * in bpf.h
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 7:55 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 2/23/21 3:43 PM, Jesper Dangaard Brouer wrote:
> > On Tue, 23 Feb 2021 20:45:54 +0800
> > Hangbin Liu <liuhangbin@gmail.com> wrote:
> >
> >> Commit 34b2021cc616 ("bpf: Add BPF-helper for MTU checking") lost a *
> >> in bpf.h. This will make bpf_helpers_doc.py stop building
> >> bpf_helper_defs.h immediately after bpf_check_mtu, which will affect
> >> future add functions.
> >>
> >> Fixes: 34b2021cc616 ("bpf: Add BPF-helper for MTU checking")
> >> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> >> ---
> >>   include/uapi/linux/bpf.h       | 2 +-
> >>   tools/include/uapi/linux/bpf.h | 2 +-
> >>   2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > Thanks for fixing that!
> >
> > Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
>
> Thanks guys, applied!
>
> > I though I had already fix that, but I must have missed or reintroduced
> > this, when I rolling back broken ideas in V13.
> >
> > I usually run this command to check the man-page (before submitting):
> >
> >   ./scripts/bpf_helpers_doc.py | rst2man | man -l -
>
> [+ Andrii] maybe this could be included to run as part of CI to catch such
> things in advance?

We do something like that as part of bpftool build, so there is no
reason we can't add this to selftests/bpf/Makefile as well.

>
> >> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> >> index 4c24daa43bac..46248f8e024b 100644
> >> --- a/include/uapi/linux/bpf.h
> >> +++ b/include/uapi/linux/bpf.h
> >> @@ -3850,7 +3850,7 @@ union bpf_attr {
> >>    *
> >>    * long bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)
> >>    * Description
> >> -
> >> + *
> >>    *         Check ctx packet size against exceeding MTU of net device (based
> >>    *         on *ifindex*).  This helper will likely be used in combination
> >>    *         with helpers that adjust/change the packet size.
> >> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> >> index 4c24daa43bac..46248f8e024b 100644
> >> --- a/tools/include/uapi/linux/bpf.h
> >> +++ b/tools/include/uapi/linux/bpf.h
> >> @@ -3850,7 +3850,7 @@ union bpf_attr {
> >>    *
> >>    * long bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)
> >>    * Description
> >> -
> >> + *
> >>    *         Check ctx packet size against exceeding MTU of net device (based
> >>    *         on *ifindex*).  This helper will likely be used in combination
> >>    *         with helpers that adjust/change the packet size.
> >
> >
> >
>
