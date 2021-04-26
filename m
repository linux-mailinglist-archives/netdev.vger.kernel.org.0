Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25AE736B760
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234828AbhDZRCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234657AbhDZRCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:02:01 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169F3C061574;
        Mon, 26 Apr 2021 10:01:20 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id l17so25762322oil.11;
        Mon, 26 Apr 2021 10:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j0CZ5f6wGp7F2BPuLi3ZPaUQQSf8QtoA8UUqKFrhtPo=;
        b=fIDGIXkC/AR2c1qyMesS0BIEzD4/RjgsX///v+jD5yPkyoInldgrSsmePd08i+Ou+3
         Ph5eWqpH9QtCXehPtNiv+zlKYJCKHF7KBMMJUoxrm9QZ8zVrNiPXH3EgJDbRoxMURuFi
         Ed1HmjQ6RDWAf8sxUlw+30YDqKGqljnxNyixv+Au433UilmtRiH/dm/RM1WqVK0E9SeB
         f/lOGlTejNQAMqaqWFccRPlG7u+eJSIqWqqzzPPwut73E7l1wT87FA8OQZ7q05Q1s6GA
         hjpspRPVzn5OjkDEj5ODkY6iN6B+YuYusu6EN2hkSGN5VTtqdl7QxkiQJyl+ZwD3Rt+t
         uEPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j0CZ5f6wGp7F2BPuLi3ZPaUQQSf8QtoA8UUqKFrhtPo=;
        b=n2gyo+YlDKPaz/uojOj6yFXNWyoJx5SXMQ3l/RMHe3LPNDP1gYl6oTqs9UGDb0Ycqd
         3CqNKO7V/B5nASTeBVGA5hScZsZrI5waFK/Z9QBYVxn8A8YyC7aZMNwy/KhpIEuyUDQL
         fjBbOW3rduPYJ2GJD15QGqfwTHf98HzBECpIADlqkMiMPcEnd2fHWlvEY6ZHldIueyIk
         giv8rc3BMzBYQyVa8KBWtyRBlVkFZOTUUNWu0N4+saOCgxaBY8yWiHhPtL1AyySQvMHr
         oJKtAhKyX/HzRcpalnSJbMo/ftCD9ZLEK1N/bcd7SZMir/rI7FFAQNhPDJxwgZnv8MPd
         qTMA==
X-Gm-Message-State: AOAM533GPCZEKY3ZpD8FNZTgREi59Vf/1+hJlAPSZAOdIDXQ7c4L7xyu
        qB1QPujsB80t+6xqf2//AFNQnwZby0TJWPy1dST74PH4qBg=
X-Google-Smtp-Source: ABdhPJwkvhRjStvD8uamF0Ub3gxwXUI3Htk0H30ZJBBPj+mR7J5kITKpciuIexqtFAFRKykpX044/ytqHaAs+bfTUfE=
X-Received: by 2002:aca:3446:: with SMTP id b67mr12876471oia.136.1619456479316;
 Mon, 26 Apr 2021 10:01:19 -0700 (PDT)
MIME-Version: 1.0
References: <1618749928154136@kroah.com> <CAPFHKzdKcVDDERr8pmd=65Tf=tWNh_bKar9OLQd0oS2YBVu80Q@mail.gmail.com>
 <YH1xw5s0Uu5i/cRT@kroah.com>
In-Reply-To: <YH1xw5s0Uu5i/cRT@kroah.com>
From:   Jonathon Reinhart <jonathon.reinhart@gmail.com>
Date:   Mon, 26 Apr 2021 13:00:53 -0400
Message-ID: <CAPFHKzfO1+Yw-0rvWSZA62caigjjN=vtbg2a7kCoSV-+pxotUw@mail.gmail.com>
Subject: Re: Patch "net: Make tcp_allowed_congestion_control readonly in
 non-init netns" has been added to the 5.10-stable tree
To:     "David S. Miller" <davem@davemloft.net>,
        Linux Netdev List <netdev@vger.kernel.org>
Cc:     stable-commits@vger.kernel.org, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 8:04 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Sun, Apr 18, 2021 at 10:47:04AM -0400, Jonathon Reinhart wrote:
> > On Sun, Apr 18, 2021 at 8:46 AM <gregkh@linuxfoundation.org> wrote:
> > >
> > >
> > > This is a note to let you know that I've just added the patch titled
> > >
> > >     net: Make tcp_allowed_congestion_control readonly in non-init netns
> > >
> > > to the 5.10-stable tree which can be found at:
> > >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > >
> > > The filename of the patch is:
> > >      net-make-tcp_allowed_congestion_control-readonly-in-non-init-netns.patch
> > > and it can be found in the queue-5.10 subdirectory.
> > >
> > > If you, or anyone else, feels it should not be added to the stable tree,
> > > please let <stable@vger.kernel.org> know about it.
> > >
> > >
> > > From 97684f0970f6e112926de631fdd98d9693c7e5c1 Mon Sep 17 00:00:00 2001
> > > From: Jonathon Reinhart <jonathon.reinhart@gmail.com>
> > > Date: Tue, 13 Apr 2021 03:08:48 -0400
> > > Subject: net: Make tcp_allowed_congestion_control readonly in non-init netns
> > >
> > > From: Jonathon Reinhart <jonathon.reinhart@gmail.com>
> > >
> > > commit 97684f0970f6e112926de631fdd98d9693c7e5c1 upstream.
> >
> > Hi Greg,
> >
> > Thanks for picking this into the stable trees.
> >
> > There's an earlier, somewhat related fix, which is only on net-next:
> >
> > 2671fa4dc010 ("netfilter: conntrack: Make global sysctls readonly in
> > non-init netns")
> >
> > That probably could have been on "net", but it followed this other
> > commit which was not strictly a bug-fix. It's additional logic to
> > detect bugs like the former:
> >
> > 31c4d2f160eb ("net: Ensure net namespace isolation of sysctls")
> >
> > Here's the series on Patchwork:
> > https://patchwork.kernel.org/project/netdevbpf/cover/20210412042453.32168-1-Jonathon.Reinhart@gmail.com/
> >
> > I'm not yet sure where the threshold is for inclusion into "net" or
> > "stable". Could you please take a look and see if the first (or both)
> > of these should be included into the stable trees? If so, please feel
> > free to pick them yourself, or let me know which patches I should send
> > to "stable".
>
> I have to wait until a patch is in Linus's tree before we can add it to
> the stable queue, unless there is some big reason why this is not the
> case.
>
> For something like this, how about just waiting until it hits Linus's
> tree and then email stable@vger.kernel.org saying, "please apply git
> commit <SHA1> to the stable trees." and we can do so then.
>
> thanks,
>
> greg k-h

Dave,

I originally submitted 2671fa4dc010 ("netfilter: conntrack: Make
global sysctls readonly in non-init netns") to next-next as part of
the "Ensuring net sysctl isolation" series. However, I think that may
have been a mistake on my part, and that commit should have been a
bugfix sent to "net". (I submitted it to "net-next" because the other
commit in that series 31c4d2f160eb ("net: Ensure net namespace
isolation of sysctls") was more of a feature than a bugfix.)

I sent the other bugfix "net: Make tcp_allowed_congestion_control
readonly in non-init netns" to "net-next" but you made the right call
and applied to "net"; thanks.

From my perspective, one of the two bugs I discovered is now fixed on
Linus' tree, but the other is on "net-next". Do you think we should
pick that into "net"? Personally, I'd really like to see both of these
fixes in the 5.10 / 5.11 stable trees so Debian 11 can be netns-safe
out of the box, but I understand there may be bigger fish to fry from
your perspective.

Thanks,
Jonathon Reinhart
