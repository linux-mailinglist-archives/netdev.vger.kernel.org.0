Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABCD713B30F
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 20:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgANTje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 14:39:34 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:40907 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgANTje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 14:39:34 -0500
Received: by mail-oi1-f195.google.com with SMTP id c77so12987186oib.7
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 11:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bhhtxw+JrnHrg8lJ2wSuNQSOSm1zp+Lhs/m14LRp4H8=;
        b=J43Z3bBf4ZjaENGXL3su9i3GsR1H+Yb00xLdWEQsxGmG+PXc/7NohbucQmrNykg90R
         JhMRtSdDeN9xE74o37nU3BOEzVPZB6jFxbH3iFxIGqIr4CYNck12QtvDEz/kuXWyh3S9
         s1FLz1SR4/ZSb2dUkfvt40IBucaV34m8tDz16l8OFkuZq1blt0WK+0hu/e8iWXxUXStG
         lIpzcJZn410fCDZ20NTzaI1E4PSyhLGQWLlKylLtedgDle0SAcPcuFdEese5BTgOeLJ8
         W3RxFfY4VoxqAsy0pjLGGiURkN1Ji/cV320Ea+Sn3HcylwAzU2AGgNLsu5jTEVCWWkLt
         kF4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bhhtxw+JrnHrg8lJ2wSuNQSOSm1zp+Lhs/m14LRp4H8=;
        b=PFV4OvgNRbDNOz/ztPsICgKCYDzrZTkq9fyXqAs01WNs/tkPxBkvSaL47QcC5qtI/4
         IIUhlZ/Ap8pEYuQwAPV5R0k1k0d+koH4P95/KhoCzk7cER4xaZtAdk2BHp8tfAhb9OHt
         FMdyL4f0OZLbIKksNo0iJM8SsRwcAU9voZJ2eALrGmdpUzwgsq30AfslOmjH2CcZuQ9b
         bPK+iqlCyIlNgEIQB07X8ZQCaL/M39nlBljugT/XLJpHyjvj5EsMMZPmI58nneDZ9e43
         4Y6xEomLbH5hbQL9iLLYyn1LYit2twX7gJeRcFev9mOSNH4ew971O4PPmqyjZiJQhx+P
         lg5g==
X-Gm-Message-State: APjAAAUSYqFuGrR3NmU2Rrsb0izxZwMsY7GucpRHSDriU9Ezdnf/t+X+
        LMpEgnpqd+jL6/QJochjMe1H8/J//xvfzgn6TJlfgHLv
X-Google-Smtp-Source: APXvYqwv0zayXHkKIulg0bHDQpqrAqeySLOYMVVcY2Kd6nNDmxHjbVFcYgAHhIDuXVm0XwEClI5eBcnCzL7jGX1/4OQ=
X-Received: by 2002:aca:3909:: with SMTP id g9mr17178078oia.118.1579030773482;
 Tue, 14 Jan 2020 11:39:33 -0800 (PST)
MIME-Version: 1.0
References: <000000000000ab3f800598cec624@google.com> <000000000000802598059b6c7989@google.com>
 <CAM_iQpX7-BF=C+CAV3o=VeCZX7=CgdscZaazTD6QT-Tw1=XY9Q@mail.gmail.com>
 <CAMArcTXTtJB8WUuJUumP2NHVg_c19m-6EheC3JRGxzseYmHVDw@mail.gmail.com>
 <CAM_iQpVJiYHnhUJKzQpoPzaUhjrd=O4WR6zFJ+329KnWi6jJig@mail.gmail.com>
 <CAMArcTVPrKrhY63P=VgFuTQf0wUNO_9=H2R96p08-xoJ+mbZ5w@mail.gmail.com>
 <CAM_iQpX-S7cPvYTqAMkZF=avaoMi_af70dwQEiC37OoXNWA4Aw@mail.gmail.com>
 <CAMArcTUFK6TUYP+zwD3009m126fz+S-cAT5CN5pZ3C5axErh8g@mail.gmail.com>
 <CAM_iQpUpZLcsC2eYPGO-UCRf047FTvP-0x8hQnDxRZ-w3vL9Tg@mail.gmail.com>
 <CAMArcTV66StxE=Pjiv6zsh0san039tuVvsKNE2Sb=7+jJ3xEdQ@mail.gmail.com>
 <CAM_iQpU9EXx7xWAaps2E3DWiZbt25ByCK4sR=njYMHF=KsvLFg@mail.gmail.com>
 <CAM_iQpUDd6hFrQwb2TkGpbe5AFOtTMyeVg1-OBfY50vC5CEJnQ@mail.gmail.com> <CAMArcTVHj2_yGjsYMoMow0LsAe0cs+Xyz68+TAa6Nb4tQbc6EA@mail.gmail.com>
In-Reply-To: <CAMArcTVHj2_yGjsYMoMow0LsAe0cs+Xyz68+TAa6Nb4tQbc6EA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 14 Jan 2020 11:39:22 -0800
Message-ID: <CAM_iQpWPnOO7KoaADX4rnmZWdspseft4DDE=C21ORboWdUO9Qw@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in sch_direct_xmit
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     syzbot <syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 2:53 AM Taehee Yoo <ap420073@gmail.com> wrote:
>
> On Sun, 12 Jan 2020 at 08:28, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Sat, Jan 11, 2020 at 1:53 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > The details you provide here are really helpful for me to understand
> > > the reasons behind your changes. Let me think about this and see how
> > > I could address both problems. This appears to be harder than I originally
> > > thought.
> >
> > Do you think the following patch will make everyone happy?
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 0ad39c87b7fd..7e885d069707 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -9177,22 +9177,10 @@ static void
> > netdev_unregister_lockdep_key(struct net_device *dev)
> >
> >  void netdev_update_lockdep_key(struct net_device *dev)
> >  {
> > -       struct netdev_queue *queue;
> > -       int i;
> > -
> > -       lockdep_unregister_key(&dev->qdisc_xmit_lock_key);
> >         lockdep_unregister_key(&dev->addr_list_lock_key);
> > -
> > -       lockdep_register_key(&dev->qdisc_xmit_lock_key);
> >         lockdep_register_key(&dev->addr_list_lock_key);
> >
> >         lockdep_set_class(&dev->addr_list_lock, &dev->addr_list_lock_key);
> > -       for (i = 0; i < dev->num_tx_queues; i++) {
> > -               queue = netdev_get_tx_queue(dev, i);
> > -
> > -               lockdep_set_class(&queue->_xmit_lock,
> > -                                 &dev->qdisc_xmit_lock_key);
> > -       }
> >  }
> >  EXPORT_SYMBOL(netdev_update_lockdep_key);
> >
> > I think as long as we don't take _xmit_lock nestedly, it is fine. And
> > most (or all?) of the software netdev's are already lockless, so I can't
> > think of any case we take more than one _xmit_lock on TX path.
> >
> > I tested it with the syzbot reproducer and your set master/nomaster
> > commands, I don't get any lockdep splat.
> >
> > What do you think?
> >
> > Thanks!
>
> I have tested this approach and I have no found any problem.
> As you said, most of virtual interfaces are already lockless.
> So, generally lockdep warning will not occur.
> I found two virtual interfaces that they don't have LLTX and they also
> could be upper interface. Interfaces are "rmnet" and virt_wifi" type.
>
> My test case is here.
>
> [Before]
> master0(bond or team or bridge)
>     |
> slave0(rmnet or virt_wifi)
>     |
> master1
>     |
> slave1
>     |
> master2
>     |
> veth
>
> [After]
> master0(bond or team or bridge)
>     |
> slave1(rmnet or virt_wifi)
>     |
> master2
>     |
> slave0
>     |
> master1
>     |
> veth
>
> In this test, the ordering of slave1 and slave0 will be changed.
> But, rmnet and virt_wifi type interface couldn't be slave of bond, team,
> and bridge type interface. So, This graph will not be made.
> So, I agree with this approach.

Thanks for reviewing it and auditing more network devices.
I will send out the patch formally.
