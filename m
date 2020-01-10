Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 968A81365A5
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 04:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730970AbgAJDGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 22:06:51 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36130 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730952AbgAJDGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 22:06:51 -0500
Received: by mail-lj1-f196.google.com with SMTP id r19so563916ljg.3
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 19:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d2skWiECcSUnH+OBgH5HRkEgxjJlMcKLGIXnQPltR1U=;
        b=CpA+RkmBOkztugYmDedSzngI4UdETqbBRB7Lf8F2zVyleXoxfKukjUqNiYmx+IzGaK
         FG0dZgXvaTCXEZ2jyurDLvcuTu1qKcqhlkkcqmEs1YM/JOJBXzubXdqpmOYAh4N/aq6D
         v2MMKh5BaNPFdjGN8kRkmxOxKnoEqrXxS9gN6XKo4Aeh/pDbryt0UG9WC7W9qVQVcI68
         gCe8elFv1brRWdOBTrNyUECXr4iDL6gqqcWlYs/2im0qLzNqP+C5vSmxrcu//pFCjcqy
         0kblXFRTFnC5kCzt0mkqWVQS4NkUbjVelAU+wDvJYGZUHhivDY7s/X57j2SLH6w127Wd
         yCYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d2skWiECcSUnH+OBgH5HRkEgxjJlMcKLGIXnQPltR1U=;
        b=BUCQtbu4UhdqjRPIV5MclnmLaHg8cxe6wRcC4qZjNKPGd2O/TBG2E4EFt1mOtaRlXi
         hW2UD7pOvVYkXtuoeZiWkO3Me5SCSO0hOEqBXYbTi/4ciZ8oEl425oYJ92zWKpbvvvU5
         6jrFU2jGjb7nBiIPijQS7tfqUR1an3uz6DsMVqDUmNYWWBDPLR5x0dVprB4GWWUpSt+b
         gNejBA8wNGswdoMsw72xkg5uSeggUD+OubSjycJBXYVM4oGcE3cQbmcbVeDUM5beyswX
         vF6kfOWAfsvkompsnvAFemDv9przObK/HgxRHBHxrz8qR/KN93LBlWq0zW+1FsKzMckw
         H/Sg==
X-Gm-Message-State: APjAAAVXcuthYrO6igqbQUoE4Oa5qu7LIb/2RxisXMPwmKJTiTEnpxON
        zlt4ux1XSbBrfQb8GezbC+U+wi/a3l5OuUPDw0U=
X-Google-Smtp-Source: APXvYqzxSfywxC19wMzp05L9+lWERYkIKUrPK7077PO3pMBRJIJaeM/PujJnK/oHLSgpByUoibxlf5k7TvTIXbdunkY=
X-Received: by 2002:a05:651c:1b3:: with SMTP id c19mr896202ljn.115.1578625609036;
 Thu, 09 Jan 2020 19:06:49 -0800 (PST)
MIME-Version: 1.0
References: <000000000000ab3f800598cec624@google.com> <000000000000802598059b6c7989@google.com>
 <CAM_iQpX7-BF=C+CAV3o=VeCZX7=CgdscZaazTD6QT-Tw1=XY9Q@mail.gmail.com>
 <CAMArcTXTtJB8WUuJUumP2NHVg_c19m-6EheC3JRGxzseYmHVDw@mail.gmail.com>
 <CAM_iQpVJiYHnhUJKzQpoPzaUhjrd=O4WR6zFJ+329KnWi6jJig@mail.gmail.com>
 <CAMArcTVPrKrhY63P=VgFuTQf0wUNO_9=H2R96p08-xoJ+mbZ5w@mail.gmail.com> <CAM_iQpX-S7cPvYTqAMkZF=avaoMi_af70dwQEiC37OoXNWA4Aw@mail.gmail.com>
In-Reply-To: <CAM_iQpX-S7cPvYTqAMkZF=avaoMi_af70dwQEiC37OoXNWA4Aw@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Fri, 10 Jan 2020 12:06:37 +0900
Message-ID: <CAMArcTUFK6TUYP+zwD3009m126fz+S-cAT5CN5pZ3C5axErh8g@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in sch_direct_xmit
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     syzbot <syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jan 2020 at 08:38, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Wed, Jan 8, 2020 at 3:43 AM Taehee Yoo <ap420073@gmail.com> wrote:
> >
> > On Wed, 8 Jan 2020 at 09:34, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Tue, Jan 7, 2020 at 3:31 AM Taehee Yoo <ap420073@gmail.com> wrote:
> > > > After "ip link set team0 master team1", the "team1 -> team0" locking path
> > > > will be recorded in lockdep key of both team1 and team0.
> > > > Then, if "ip link set team1 master team0" is executed, "team0 -> team1"
> > > > locking path also will be recorded in lockdep key. At this moment,
> > > > lockdep will catch possible deadlock situation and it prints the above
> > > > warning message. But, both "team0 -> team1" and "team1 -> team0"
> > > > will not be existing concurrently. so the above message is actually wrong.
> > > > In order to avoid this message, a recorded locking path should be
> > > > removed. So, both lockdep_unregister_key() and lockdep_register_key()
> > > > are needed.
> > > >
> > >
> > > So, after you move the key down to each netdevice, they are now treated
> > > as different locks. Is this stacked device scenario the reason why you
> > > move it to per-netdevice? If so, I wonder why not just use nested locks?
> > > Like:
> > >
> > > netif_addr_nested_lock(upper, 0);
> > > netif_addr_nested_lock(lower, 1);
> > > netif_addr_nested_unlock(lower);
> > > netif_addr_nested_unlock(upper);
> > >
> > > For this case, they could still share a same key.
> > >
> > > Thanks for the details!
> >
> > Yes, the reason for using dynamic lockdep key is to avoid lockdep
> > warning in stacked device scenario.
> > But, the addr_list_lock case is a little bit different.
> > There was a bug in netif_addr_lock_nested() that
> > "dev->netdev_ops->ndo_get_lock_subclass" isn't updated after "master"
> > and "nomaster" command.
> > So, the wrong subclass is used, so lockdep warning message was printed.
>
> Hmm? I never propose netdev_ops->ndo_get_lock_subclass(), and
> the subclasses are always 0,1, no matter which is the master device,
> so it doesn't need a ops.
>

It's just the reason why the dynamic lockdep key was adopted instead of
a nested lock.

>
> > There were some ways to fix this problem, using dynamic key is just one
> > of them. I think using the correct subclass in netif_addr_lock_nested()
> > is also a correct way to fix that problem. Another minor reason was that
> > the subclass is limited by 8. but dynamic key has no limitation.
>
> Yeah, but in practice I believe 8 is sufficient for stacked devices.
>

I agree with this.

>
> >
> > Unfortunately, dynamic key has a problem too.
> > lockdep limits the maximum number of lockdep keys.
>
>
> Right, and also the problem reported by syzbot, that is not safe
> during unregister and register.
>

qdisc_xmit_lock_key has this problem.
But, I'm not sure about addr_list_lock_key.
If addr_list_lock is used outside of RTNL, it has this problem.
If it isn't used outside of RTNL, it doesn't have this problem.

> Anyway, do you think we should revert back to the static keys
> and use subclass to address the lockdep issue instead?
>
> Thanks!

I agree with this to reduce the number of dynamic lockdep keys.

Thanks a lot!
