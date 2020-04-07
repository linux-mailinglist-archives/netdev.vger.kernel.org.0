Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF161A0DDD
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 14:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbgDGMkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 08:40:00 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36914 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbgDGMkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 08:40:00 -0400
Received: by mail-qk1-f194.google.com with SMTP id 130so1396164qke.4
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 05:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=REDd9q05KI702EFSQR/cgT2WpH4+rJemrcfJ/MESpiQ=;
        b=KAWILKHjC4U9jPdGMThPZYzHGsdaOtMUPXfBK3RD9JmlOj98NEM4m0KQgCBFHOy4n2
         fz1uocxz1N2G9vMJEeyZholf93xXeY1RNkHv6cTa7zlix8KDMLaEwtOetBNS4xgCG65i
         nl/kidfVBsyDg10Vb6nj662lbRm4o+KQ0OAxYFWRFZmYWbTHnP345h0tsgP/m4ka1MA1
         Y47N+uagOXchGg8ch0blRb8O8a9R0pDqCrK3bvXOzycUe0+e8e0c2zx1cOxvwkqQO6Ad
         iSD3Oz8xgI+cNYoJpa8jDIUY+efa5fjKfgWGE16NzX7q01rSH5gbyz6Uou6p83ih43tR
         g9gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=REDd9q05KI702EFSQR/cgT2WpH4+rJemrcfJ/MESpiQ=;
        b=rlQ4VZriBtRF6aMDsGG3Z6X3NId7OIjjLhvvi50yj1mzpJXNaFleRbWa1BXJWETYbw
         p2bsjGytdwYuKcAlhC0q5nid0RJJxCLVKeT848UeBvEGErEoDz0/3+9EYJRmLneKnsor
         okl3mh7jgPeTpC1VcfE2yYSw47ZGc2GIruA5q6L/cmkxtMjrT7c5jjR5xqipydv9C4eC
         QW/8WyWg8rL3SWsLLBmaGeTxjM53uhaUOgInf0ADUexAWTzGsLEu63wOapA5jf0BWkhG
         z6foS5kB6zJNt5LGnFdSylZMz76ikp5uA2bpY83WmKl0oGHLRvXsqqJcnCE97Aw7OFVX
         fqbg==
X-Gm-Message-State: AGi0PuYx2dw4g1f/QuJVhkNdrSl2uO67tzxsGrBtU9pIf32WiefnJUd6
        fFKLL2edg7r1Ke+b29IJmnDC0/3ujnmSeHoFSCLJ4w==
X-Google-Smtp-Source: APiQypJufCd7AZpci4Y41mZ7FMY2K9lw7Nzb7z1xobj1dlFqbdAhNNzeKkI9NXFd18jF3KT1Xafx0uU+IQkz5xU0O7w=
X-Received: by 2002:a05:620a:348:: with SMTP id t8mr1690858qkm.407.1586263198896;
 Tue, 07 Apr 2020 05:39:58 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000075245205a2997f68@google.com> <20200406172151.GJ80989@unreal>
 <20200406174440.GR20941@ziepe.ca> <CACT4Y+Zv_WXEn6u5a6kRZpkDJnSzeGF1L7JMw4g85TLEgAM7Lw@mail.gmail.com>
 <20200407115548.GU20941@ziepe.ca>
In-Reply-To: <20200407115548.GU20941@ziepe.ca>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 7 Apr 2020 14:39:42 +0200
Message-ID: <CACT4Y+Zy0LwpHkTMTtb08ojOxuEUFo1Z7wkMCYSVCvsVDcxayw@mail.gmail.com>
Subject: Re: WARNING in ib_umad_kill_port
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leon@kernel.org>,
        syzbot <syzbot+9627a92b1f9262d5d30c@syzkaller.appspotmail.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Rafael Wysocki <rafael@kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 7, 2020 at 1:55 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Tue, Apr 07, 2020 at 11:56:30AM +0200, Dmitry Vyukov wrote:
> > > I'm not sure what could be done wrong here to elicit this:
> > >
> > >  sysfs group 'power' not found for kobject 'umad1'
> > >
> > > ??
> > >
> > > I've seen another similar sysfs related trigger that we couldn't
> > > figure out.
> > >
> > > Hard to investigate without a reproducer.
> >
> > Based on all of the sysfs-related bugs I've seen, my bet would be on
> > some races. E.g. one thread registers devices, while another
> > unregisters these.
>
> I did check that the naming is ordered right, at least we won't be
> concurrently creating and destroying umadX sysfs of the same names.
>
> I'm also fairly sure we can't be destroying the parent at the same
> time as this child.
>
> Do you see the above commonly? Could it be some driver core thing? Or
> is it more likely something wrong in umad?

Mmmm... I can't say, I am looking at some bugs very briefly. I've
noticed that sysfs comes up periodically (or was it some other similar
fs?). General observation is that code frequently assumes only the
happy scenario and only, say, a single administrator doing one thing
at a time, slowly and carefully, and it is not really hardened against
armies of monkeys.
But I did not look at code abstractions, bug patterns, contracts, etc.

Greg KH may know better. Greg, as far as I remember you commented on
some of these reports along the lines of, for example, "the warning is
in sysfs code, but the bug is in the callers".
