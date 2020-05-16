Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFDD1D61F2
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 17:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgEPPWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 11:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbgEPPWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 11:22:15 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C399C061A0C
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 08:22:14 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id u6so5323701ljl.6
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 08:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f7Eq5OpLta2M7bBLcfALB7mK9WUbhA9IrXZfpi09Z0M=;
        b=rzDE+3aB1jhCeST1B48RhoWP+LOCO661gjGAX22jrXcgUUMz1ZHRcboMYRd9YhXTwG
         Xiad1M8YAbxEKupgvEXW6U8L7PoWoPvPihuolnzS3CgLXD+iCJB38kf1bHtcT3hjvERe
         iVGGldEJM35upE4ar0GxCKQHZMrVGepxttsjhzNch2MkjE1bs/0XK3xo1C8wTrfO2RLt
         NhrwUjrL3fNp4xFj68pfhsVMnNOStUJeI2h1DyIGW6Dnc93/QJR/VfDQgZx1L198t6Wp
         9I41z4/Mc7hCY8A2R9VjJpgxL7q1gthzqE2uPLBOr3NYmXU30pd5z1svEHhjTNQ0B+ZQ
         Gshg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f7Eq5OpLta2M7bBLcfALB7mK9WUbhA9IrXZfpi09Z0M=;
        b=qwmb4jYMXyNcp6vKqNt7Dpxc309XoyxpI41KVAu4i65tM0hwriSDkuJNzQrN+PkEYs
         xTlP76A4CQ+HAtoQWtjfEiHuNHwSN7sr4Ex2spjcSKC3TUkdGx0+gu9wnqLON/OC/hQg
         SlUMu04B4LKRTz7GfPalPFJg6ZzxI/UFWYS5eJfYtMv7a+AGWKWqtNluFfSYCvduFF3Q
         n6SOVZIWCh9lyhyAW9AS2jXPlP3tUUXWx1JMCzDJLOp9I4BNMAxpynXY8CrNIjJ5/1YB
         3pSiV7LL+aAOAnW0heEEtv83EnouWvOEcJIH390mlk4ZppnMPJVwm0ox/3c/l0HiC4bi
         PiyA==
X-Gm-Message-State: AOAM533pFZsNulHqJ64SQpPb51bbtajXeCON8lYEnXKt//HKl108RBkw
        jVnJyCnjFebboeSPQ5/Hl/kA15X0a/AVuShXQxg=
X-Google-Smtp-Source: ABdhPJw8uDJYUjD+HfvyOfXsQG/Sv7JWF9MWkEZt19HcV/wm+PaFbaFANBcXSRiSeXjBb5oFzbe92HIGwjxsleLGQVs=
X-Received: by 2002:a2e:9f48:: with SMTP id v8mr5440013ljk.135.1589642532867;
 Sat, 16 May 2020 08:22:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200503052220.4536-1-xiyou.wangcong@gmail.com>
 <20200503052220.4536-2-xiyou.wangcong@gmail.com> <CAMArcTVQO8U_kU1EHxCDsjdfGn-y_keAQ3ScjJmPAeya+B8hHQ@mail.gmail.com>
 <CA+h21hqu=J5RH3UkYBt7=uxWNYvXWegFsbMnf3PoWyVHTpRPrQ@mail.gmail.com>
In-Reply-To: <CA+h21hqu=J5RH3UkYBt7=uxWNYvXWegFsbMnf3PoWyVHTpRPrQ@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sun, 17 May 2020 00:22:01 +0900
Message-ID: <CAMArcTWW+HNqvkh+YwR-HCLMDTq7ckXxWtTyMWRyDLvgYXc7wg@mail.gmail.com>
Subject: Re: [Patch net-next v2 1/2] net: partially revert dynamic lockdep key changes
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        syzbot <syzbot+aaa6fa4949cc5d9b7b25@syzkaller.appspotmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 May 2020 at 00:56, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Cong, Taehee,
>

Hi Vladimir!
Sorry for the late reply.

...

> I have a platform with the following layout:
>
>       Regular NIC
>        |
>        +----> DSA master for switch port
>                |
>                +----> DSA master for another switch port
>
> After changing DSA back to static lockdep class keys, I get this splat:
>
> [   13.361198] ============================================
> [   13.366524] WARNING: possible recursive locking detected
> [   13.371851] 5.7.0-rc4-02121-gc32a05ecd7af-dirty #988 Not tainted
> [   13.377874] --------------------------------------------
> [   13.383201] swapper/0/0 is trying to acquire lock:
> [   13.388004] ffff0000668ff298
> (&dsa_slave_netdev_xmit_lock_key){+.-.}-{2:2}, at:
> __dev_queue_xmit+0x84c/0xbe0
> [   13.397879]
> [   13.397879] but task is already holding lock:
> [   13.403727] ffff0000661a1698
> (&dsa_slave_netdev_xmit_lock_key){+.-.}-{2:2}, at:
> __dev_queue_xmit+0x84c/0xbe0
> [   13.413593]
> [   13.413593] other info that might help us debug this:
> [   13.420140]  Possible unsafe locking scenario:
> [   13.420140]
> [   13.426075]        CPU0
> [   13.428523]        ----
> [   13.430969]   lock(&dsa_slave_netdev_xmit_lock_key);
> [   13.435946]   lock(&dsa_slave_netdev_xmit_lock_key);
> [   13.440924]
> [   13.440924]  *** DEADLOCK ***
> [   13.440924]
> [   13.446860]  May be due to missing lock nesting notation
> [   13.446860]
> [   13.453668] 6 locks held by swapper/0/0:
> [   13.457598]  #0: ffff800010003de0
> ((&idev->mc_ifc_timer)){+.-.}-{0:0}, at: call_timer_fn+0x0/0x400
> [   13.466593]  #1: ffffd4d3fb478700 (rcu_read_lock){....}-{1:2}, at:
> mld_sendpack+0x0/0x560
> [   13.474803]  #2: ffffd4d3fb478728 (rcu_read_lock_bh){....}-{1:2},
> at: ip6_finish_output2+0x64/0xb10
> [   13.483886]  #3: ffffd4d3fb478728 (rcu_read_lock_bh){....}-{1:2},
> at: __dev_queue_xmit+0x6c/0xbe0
> [   13.492793]  #4: ffff0000661a1698
> (&dsa_slave_netdev_xmit_lock_key){+.-.}-{2:2}, at:
> __dev_queue_xmit+0x84c/0xbe0
> [   13.503094]  #5: ffffd4d3fb478728 (rcu_read_lock_bh){....}-{1:2},
> at: __dev_queue_xmit+0x6c/0xbe0
> [   13.512000]
> [   13.512000] stack backtrace:
> [   13.516369] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
> 5.7.0-rc4-02121-gc32a05ecd7af-dirty #988
> [   13.530421] Call trace:
> [   13.532871]  dump_backtrace+0x0/0x1d8
> [   13.536539]  show_stack+0x24/0x30
> [   13.539862]  dump_stack+0xe8/0x150
> [   13.543271]  __lock_acquire+0x1030/0x1678
> [   13.547290]  lock_acquire+0xf8/0x458
> [   13.550873]  _raw_spin_lock+0x44/0x58
> [   13.554543]  __dev_queue_xmit+0x84c/0xbe0
> [   13.558562]  dev_queue_xmit+0x24/0x30
> [   13.562232]  dsa_slave_xmit+0xe0/0x128
> [   13.565988]  dev_hard_start_xmit+0xf4/0x448
> [   13.570182]  __dev_queue_xmit+0x808/0xbe0
> [   13.574200]  dev_queue_xmit+0x24/0x30
> [   13.577869]  neigh_resolve_output+0x15c/0x220
> [   13.582237]  ip6_finish_output2+0x244/0xb10
> [   13.586430]  __ip6_finish_output+0x1dc/0x298
> [   13.590709]  ip6_output+0x84/0x358
> [   13.594116]  mld_sendpack+0x2bc/0x560
> [   13.597786]  mld_ifc_timer_expire+0x210/0x390
> [   13.602153]  call_timer_fn+0xcc/0x400
> [   13.605822]  run_timer_softirq+0x588/0x6e0
> [   13.609927]  __do_softirq+0x118/0x590
> [   13.613597]  irq_exit+0x13c/0x148
> [   13.616918]  __handle_domain_irq+0x6c/0xc0
> [   13.621023]  gic_handle_irq+0x6c/0x160
> [   13.624779]  el1_irq+0xbc/0x180
> [   13.627927]  cpuidle_enter_state+0xb4/0x4d0
> [   13.632120]  cpuidle_enter+0x3c/0x50
> [   13.635703]  call_cpuidle+0x44/0x78
> [   13.639199]  do_idle+0x228/0x2c8
> [   13.642433]  cpu_startup_entry+0x2c/0x48
> [   13.646363]  rest_init+0x1ac/0x280
> [   13.649773]  arch_call_rest_init+0x14/0x1c
> [   13.653878]  start_kernel+0x490/0x4bc
>
> Unfortunately I can't really test DSA behavior prior to patch
> ab92d68fc22f ("net: core: add generic lockdep keys"), because in
> October, some of these DSA drivers were not in mainline.
> Also I don't really have a clear idea of how nesting should be
> signalled to lockdep.
> Do you have any suggestion what might be wrong?
>

This patch was considered that all stackable devices have LLTX flag.
But the dsa doesn't have LLTX, so this splat happened.
After this patch, dsa shares the same lockdep class key.
On the nested dsa interface architecture, which you illustrated,
the same lockdep class key will be used in __dev_queue_xmit() because
dsa doesn't have LLTX.
So that lockdep detects deadlock because the same lockdep class key is
used recursively although actually the different locks are used.
There are some ways to fix this problem.

1. using NETIF_F_LLTX flag.
If possible, using the LLTX flag is a very clear way for it.
But I'm so sorry I don't know whether the dsa could have LLTX or not.

2. using dynamic lockdep again.
It means that each interface uses a separate lockdep class key.
So, lockdep will not detect recursive locking.
But this way has a problem that it could consume lockdep class key
too many.
Currently, lockdep can have 8192 lockdep class keys.
 - you can see this number with the following command.
   cat /proc/lockdep_stats
   lock-classes:                         1251 [max: 8192]
   ...
   The [max: 8192] means that the maximum number of lockdep class keys.
If too many lockdep class keys are registered, lockdep stops to work.
So, using a dynamic(separated) lockdep class key should be considered
carefully.
In addition, updating lockdep class key routine might have to be existing.
(lockdep_register_key(), lockdep_set_class(), lockdep_unregister_key())

3. Using lockdep subclass.
A lockdep class key could have 8 subclasses.
The different subclass is considered different locks by lockdep
infrastructure.
But "lock-classes" is not counted by subclasses.
So, it could avoid stopping lockdep infrastructure by an overflow of
lockdep class keys.
This approach should also have an updating lockdep class key routine.
(lockdep_set_subclass())

4. Using nonvalidate lockdep class key.
The lockdep infrastructure supports nonvalidate lockdep class key type.
It means this lockdep is not validated by lockdep infrastructure.
So, the splat will not happend but lockdep couldn't detect real deadlock
case because lockdep really doesn't validate it.
I think this should be used for really special cases.
(lockdep_set_novalidate_class())

Thanks!
Taehee Yoo

> Thanks,
> -Vladimir
