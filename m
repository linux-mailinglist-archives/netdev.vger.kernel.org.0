Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C664138FAB
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 11:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgAMKx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 05:53:56 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39855 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgAMKx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 05:53:56 -0500
Received: by mail-lj1-f194.google.com with SMTP id l2so9465507lja.6
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 02:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sCLrwv1Cw6cBFxDg6n4pC4wRSyOzBgPiDKs3xxcrCbs=;
        b=MJoyRZBCtxoegdSafLArafzIUZAgRAZmi3Qj1dqPGoTDT4qaij5dk5IK+3xjAX02KV
         FSpkQvH/LL+t5S8CcnTuVpVrn+bKReXBYZaz5S9bv1bwM5a/h6NOLAk8hAclffXVI2I0
         qX5ojsIopxfhSXWtCg23aGC5BVmO+O6bqs020sjxW+QkSXVHSGeml5hZcBi2QhotoW8n
         VwpgxuGl54IRcB+oR48qkI6fKBcxKMtFrT2JZuZtoNzTgd3w1tyRdLRcX1EisPgH+RI5
         o2Y9yPjn7x7VTxP7wmfL89vbOASm3gd3QLDRoT+ytjcsaCps+ezPVusNrJR/iu8q+34+
         5oNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sCLrwv1Cw6cBFxDg6n4pC4wRSyOzBgPiDKs3xxcrCbs=;
        b=n+1yLSDzJqZ0nTVUPjRUfHdTbZIHkRLaWjNUlOIYi2p8Q9Nlvski9hkudwuKjzNU+x
         JcybkBAXR+PrXmdRZyz1fmphALYOU79FfqGbGYPoQ0OUQmAYIrd9bt6qEN2N6pY1J3g2
         kAML0N9t5zjGi4bmJJqIg1W4xahNN78PCqOh00H8Co1nKuVUGjMWPqAEmxG9HDhAHE/J
         ly5y7de3tBBc9aZbzRv24VjNAQz/mffNV4+XWUwBXCwUrtsnYSvArCItkoNTDCDkMBiS
         VjtjOQNKKL++Ysk+GA/10xgFvuXesiL+8L2Qgi2jy4nA0rPnlmWwwgmv8gA7R3+kw2k+
         tNOA==
X-Gm-Message-State: APjAAAV3H9kk5mZex9Ug0ma5lObOTvfZsz/P6/Vt9VirgkQn4lXEmYVo
        WeGbUmzMkyL1vIzV/RaI+x3pDfu6javVcKaf4VY=
X-Google-Smtp-Source: APXvYqzCtDtLkN0/Toe1WNldDLNgsUG0ymPINMMfVWe5ytwadv0CxchY6nyAIA77l3/N74zB+9KGHBqixgfkKFY9CwI=
X-Received: by 2002:a2e:9d90:: with SMTP id c16mr7144037ljj.264.1578912834160;
 Mon, 13 Jan 2020 02:53:54 -0800 (PST)
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
 <CAM_iQpU9EXx7xWAaps2E3DWiZbt25ByCK4sR=njYMHF=KsvLFg@mail.gmail.com> <CAM_iQpUDd6hFrQwb2TkGpbe5AFOtTMyeVg1-OBfY50vC5CEJnQ@mail.gmail.com>
In-Reply-To: <CAM_iQpUDd6hFrQwb2TkGpbe5AFOtTMyeVg1-OBfY50vC5CEJnQ@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Mon, 13 Jan 2020 19:53:42 +0900
Message-ID: <CAMArcTVHj2_yGjsYMoMow0LsAe0cs+Xyz68+TAa6Nb4tQbc6EA@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in sch_direct_xmit
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     syzbot <syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Jan 2020 at 08:28, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sat, Jan 11, 2020 at 1:53 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > The details you provide here are really helpful for me to understand
> > the reasons behind your changes. Let me think about this and see how
> > I could address both problems. This appears to be harder than I originally
> > thought.
>
> Do you think the following patch will make everyone happy?
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 0ad39c87b7fd..7e885d069707 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9177,22 +9177,10 @@ static void
> netdev_unregister_lockdep_key(struct net_device *dev)
>
>  void netdev_update_lockdep_key(struct net_device *dev)
>  {
> -       struct netdev_queue *queue;
> -       int i;
> -
> -       lockdep_unregister_key(&dev->qdisc_xmit_lock_key);
>         lockdep_unregister_key(&dev->addr_list_lock_key);
> -
> -       lockdep_register_key(&dev->qdisc_xmit_lock_key);
>         lockdep_register_key(&dev->addr_list_lock_key);
>
>         lockdep_set_class(&dev->addr_list_lock, &dev->addr_list_lock_key);
> -       for (i = 0; i < dev->num_tx_queues; i++) {
> -               queue = netdev_get_tx_queue(dev, i);
> -
> -               lockdep_set_class(&queue->_xmit_lock,
> -                                 &dev->qdisc_xmit_lock_key);
> -       }
>  }
>  EXPORT_SYMBOL(netdev_update_lockdep_key);
>
> I think as long as we don't take _xmit_lock nestedly, it is fine. And
> most (or all?) of the software netdev's are already lockless, so I can't
> think of any case we take more than one _xmit_lock on TX path.
>
> I tested it with the syzbot reproducer and your set master/nomaster
> commands, I don't get any lockdep splat.
>
> What do you think?
>
> Thanks!

I have tested this approach and I have no found any problem.
As you said, most of virtual interfaces are already lockless.
So, generally lockdep warning will not occur.
I found two virtual interfaces that they don't have LLTX and they also
could be upper interface. Interfaces are "rmnet" and virt_wifi" type.

My test case is here.

[Before]
master0(bond or team or bridge)
    |
slave0(rmnet or virt_wifi)
    |
master1
    |
slave1
    |
master2
    |
veth

[After]
master0(bond or team or bridge)
    |
slave1(rmnet or virt_wifi)
    |
master2
    |
slave0
    |
master1
    |
veth

In this test, the ordering of slave1 and slave0 will be changed.
But, rmnet and virt_wifi type interface couldn't be slave of bond, team,
and bridge type interface. So, This graph will not be made.
So, I agree with this approach.

Thank you so much!
Taehee Yoo
