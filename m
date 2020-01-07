Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A58831324E7
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 12:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgAGLbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 06:31:10 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40354 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727882AbgAGLbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 06:31:10 -0500
Received: by mail-lj1-f196.google.com with SMTP id u1so54319136ljk.7
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 03:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FXk+wyBoW+py2Ulpy3cUn5rzl0htu4NzMqChlLNLulc=;
        b=JwSBv10y5/8so7UiCHkrg9rgkcrTXMCU2Irrq1awMNYad9mjthMwNEuOVEyKzPcHEc
         Rsc9EEA4myYKraNb3TI2qITB7Vc4ljFatvc51M1rwBVMSHc+ufVgMJ/zHlAhiDF610WB
         rB53pY6WcnyAz/D+htDiqbYS3y4KN/Y/cVnrFlf2RnUHTjYU293qgtCXolqGh6velgUw
         AfTFN7OIlq0Xda9IEA/ndAYx15/myE7UcfVQCSXVJe8o4qKVQurZTonZypZ8GgKT0MOr
         DSXJvHuIkh+77vkzt6AT08oQROPiilkX8hzi7/7VKNwUoCzGpkKqT/I3x/zsmQERlz3q
         Ne7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FXk+wyBoW+py2Ulpy3cUn5rzl0htu4NzMqChlLNLulc=;
        b=qpqFtoQIdHTfuarcIPOhKL/NuLQoIMijRQt8VR2I/UZHeMdZP4H35wlj+C8ux8WkOe
         pIl26+Sram4jGfdRxVoKiajCwWCJ1/9+vhODZkI28kna3v/h1IbBlkK9aDksifPD5Hxb
         sPYcUJaqjF2ndbFgfRxp9ulhwYrYa+3M1V58IpQgrtIOpZqvdHNkA1q9GohbiXYDxA8c
         KVPmverQVLBPcgnPtb55RFUOp2oNDBozQHh9THfh1k3BHyZobP/z9ItjZYnMd9Yq2Ez3
         8vfVvqbTBy0oKXkszlW7r9eDsDDY4GvTrKsomVlWYKTEq55QmagDa3bLPJnE1PojZjuE
         PQUw==
X-Gm-Message-State: APjAAAXzvnVdrsMUsZVQ1XWoEUXGyQ18ECjVk4aZpTfxAubWIGJRkSjm
        fF2zlCL/9geKTG7opISOgUSbTRmExxxXfhkU89s=
X-Google-Smtp-Source: APXvYqyKMvAjdrVb230SMFbRKdInDeMX5oqybLOTUkKJnNrYXybbPe4u+lXeM9nrb0n2IZeu5FKI1oAy4b/wvDiQRuk=
X-Received: by 2002:a2e:9883:: with SMTP id b3mr61551286ljj.80.1578396667961;
 Tue, 07 Jan 2020 03:31:07 -0800 (PST)
MIME-Version: 1.0
References: <000000000000ab3f800598cec624@google.com> <000000000000802598059b6c7989@google.com>
 <CAM_iQpX7-BF=C+CAV3o=VeCZX7=CgdscZaazTD6QT-Tw1=XY9Q@mail.gmail.com>
In-Reply-To: <CAM_iQpX7-BF=C+CAV3o=VeCZX7=CgdscZaazTD6QT-Tw1=XY9Q@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 7 Jan 2020 20:30:56 +0900
Message-ID: <CAMArcTXTtJB8WUuJUumP2NHVg_c19m-6EheC3JRGxzseYmHVDw@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in sch_direct_xmit
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     syzbot <syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Jan 2020 at 14:36, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> Hi, Taehee
>

Hi, Cong!
Thank you for your diagnosis.

> On Sun, Jan 5, 2020 at 2:59 PM syzbot
> <syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com> wrote:
> >
> > syzbot has bisected this bug to:
> >
> > commit ab92d68fc22f9afab480153bd82a20f6e2533769
> > Author: Taehee Yoo <ap420073@gmail.com>
> > Date:   Mon Oct 21 18:47:51 2019 +0000
> >
> >      net: core: add generic lockdep keys
>
> Why netdev_update_lockdep_key() is needed?
>
> It causes the bug here because the unregister and register are not
> atomic although under RTNL, fast path could still lock with one key
> and unlock with another key after the previous got unregistered.
>
> From my understand of lockdep here, as long as the device itself
> is not changed, it doesn't need to update those keys.
>
> Thanks.

The goal of netdev_update_lockdep_key() is to avoid wrong lockdep splat.

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 02916f43bf63..cea5ef66b813 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2448,7 +2448,7 @@ static int do_set_master(struct net_device *dev,
int ifindex,
                        err = ops->ndo_del_slave(upper_dev, dev);
                        if (err)
                                return err;
-                       netdev_update_lockdep_key(dev);
+                       //netdev_update_lockdep_key(dev);
                } else {
                        return -EOPNOTSUPP;
                }

Test commands:
    ip link add team0 type team
    ip link add team1 type team
    ip link set team0 master team1
    ip link set team0 nomaster
    ip link set team1 master team0

Splats:
[  105.484781][ T1178] ======================================================
[  105.485894][ T1178] WARNING: possible circular locking dependency detected
[  105.486791][ T1178] 5.5.0-rc2+ #264 Not tainted
[  105.487369][ T1178] ------------------------------------------------------
[  105.488130][ T1178] ip/1178 is trying to acquire lock:
[  105.488948][ T1178] ffff8880521d9280
(&dev->addr_list_lock_key#4){+...}, at:
dev_uc_sync_multiple+0x95/0x120
[  105.490336][ T1178]
[  105.490336][ T1178] but task is already holding lock:
[  105.491710][ T1178] ffff88806aa29280
(&dev->addr_list_lock_key#3){+...}, at: team_add_slave+0x165d/0x1972
[team]
[  105.493471][ T1178]
[  105.493471][ T1178] which lock already depends on the new lock.
[  105.493471][ T1178]
[  105.495423][ T1178]
[  105.495423][ T1178] the existing dependency chain (in reverse order) is:
[  105.496809][ T1178]
[  105.496809][ T1178] -> #1 (&dev->addr_list_lock_key#3){+...}:
[  105.497747][ T1178]        _raw_spin_lock+0x30/0x70
[  105.498201][ T1178]        dev_uc_sync_multiple+0x95/0x120
[  105.498733][ T1178]        team_add_slave+0x1668/0x1972 [team]
[  105.499293][ T1178]        do_setlink+0xaab/0x2ef0
[  105.499755][ T1178]        __rtnl_newlink+0x9c5/0x1270
[  105.500239][ T1178]        rtnl_newlink+0x65/0x90
[  105.500713][ T1178]        rtnetlink_rcv_msg+0x4a8/0x890
[  105.501269][ T1178]        netlink_rcv_skb+0x121/0x350
[  105.501799][ T1178]        netlink_unicast+0x421/0x600
[  105.502327][ T1178]        netlink_sendmsg+0x65a/0xb90
[  105.502890][ T1178]        ____sys_sendmsg+0x5ce/0x7a0
[  105.503469][ T1178]        ___sys_sendmsg+0x10f/0x1b0
[  105.504115][ T1178]        __sys_sendmsg+0xc6/0x150
[  105.504746][ T1178]        do_syscall_64+0x99/0x4f0
[  105.505391][ T1178]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  105.506206][ T1178]
[  105.506206][ T1178] -> #0 (&dev->addr_list_lock_key#4){+...}:
[  105.507238][ T1178]        __lock_acquire+0x2d8d/0x3de0
[  105.507907][ T1178]        lock_acquire+0x164/0x3b0
[  105.508536][ T1178]        _raw_spin_lock+0x30/0x70
[  105.509180][ T1178]        dev_uc_sync_multiple+0x95/0x120
[  105.509825][ T1178]        team_add_slave+0x1668/0x1972 [team]
[  105.510451][ T1178]        do_setlink+0xaab/0x2ef0
[  105.510961][ T1178]        __rtnl_newlink+0x9c5/0x1270
[  105.511525][ T1178]        rtnl_newlink+0x65/0x90
[  105.512026][ T1178]        rtnetlink_rcv_msg+0x4a8/0x890
[  105.512618][ T1178]        netlink_rcv_skb+0x121/0x350
[  105.513158][ T1178]        netlink_unicast+0x421/0x600
[  105.513843][ T1178]        netlink_sendmsg+0x65a/0xb90
[  105.514524][ T1178]        ____sys_sendmsg+0x5ce/0x7a0
[  105.515186][ T1178]        ___sys_sendmsg+0x10f/0x1b0
[  105.515852][ T1178]        __sys_sendmsg+0xc6/0x150
[  105.516493][ T1178]        do_syscall_64+0x99/0x4f0
[  105.517190][ T1178]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  105.518005][ T1178]
[  105.518005][ T1178] other info that might help us debug this:
[  105.518005][ T1178]
[  105.519317][ T1178]  Possible unsafe locking scenario:
[  105.519317][ T1178]
[  105.520268][ T1178]        CPU0                    CPU1
[  105.520958][ T1178]        ----                    ----
[  105.521640][ T1178]   lock(&dev->addr_list_lock_key#3);
[  105.522866][ T1178]
lock(&dev->addr_list_lock_key#4);
[  105.523613][ T1178]
lock(&dev->addr_list_lock_key#3);
[  105.524303][ T1178]   lock(&dev->addr_list_lock_key#4);
[  105.524890][ T1178]
[  105.524890][ T1178]  *** DEADLOCK ***
[  105.524890][ T1178]
[  105.525624][ T1178] 3 locks held by ip/1178:
[  105.526010][ T1178]  #0: ffffffffb0cc0b70 (rtnl_mutex){+.+.}, at:
rtnetlink_rcv_msg+0x457/0x890
[  105.526864][ T1178]  #1: ffff88806aa29c80
(team->team_lock_key#2){+.+.}, at: team_add_slave+0x89/0x1972 [team]
[  105.527857][ T1178]  #2: ffff88806aa29280
(&dev->addr_list_lock_key#3){+...}, at: team_add_slave+0x165d/0x1972
[team]
[  105.528914][ T1178]
[  105.528914][ T1178] stack backtrace:
[  105.529505][ T1178] CPU: 3 PID: 1178 Comm: ip Not tainted 5.5.0-rc2+ #264
[  105.530202][ T1178] Hardware name: innotek GmbH
VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  105.531417][ T1178] Call Trace:
[  105.531824][ T1178]  dump_stack+0x96/0xdb
[  105.532333][ T1178]  check_noncircular+0x371/0x450
[  105.532963][ T1178]  ? print_circular_bug.isra.36+0x310/0x310
[  105.533575][ T1178]  ? stack_trace_save+0x82/0xb0
[  105.534058][ T1178]  ? hlock_class+0x130/0x130
[  105.534549][ T1178]  ? __lock_acquire+0x2d8d/0x3de0
[  105.535036][ T1178]  __lock_acquire+0x2d8d/0x3de0
[  105.535545][ T1178]  ? register_lock_class+0x14d0/0x14d0
[  105.536034][ T1178]  ? find_held_lock+0x39/0x1d0
[  105.536469][ T1178]  lock_acquire+0x164/0x3b0
[  105.536958][ T1178]  ? dev_uc_sync_multiple+0x95/0x120
[  105.537736][ T1178]  _raw_spin_lock+0x30/0x70
[  105.538398][ T1178]  ? dev_uc_sync_multiple+0x95/0x120
[  105.539260][ T1178]  dev_uc_sync_multiple+0x95/0x120
[  105.540213][ T1178]  team_add_slave+0x1668/0x1972 [team]
[  105.541113][ T1178]  ? team_init+0x7b0/0x7b0 [team]
[  105.541760][ T1178]  ? mutex_is_locked+0x13/0x50
[  105.542359][ T1178]  ? rtnl_is_locked+0x11/0x20
[  105.542984][ T1178]  ? netdev_master_upper_dev_get+0xf/0x120
[  105.543734][ T1178]  do_setlink+0xaab/0x2ef0
[  105.544296][ T1178]  ? is_bpf_text_address+0x81/0xe0
[ ... ]

After "ip link set team0 master team1", the "team1 -> team0" locking path
will be recorded in lockdep key of both team1 and team0.
Then, if "ip link set team1 master team0" is executed, "team0 -> team1"
locking path also will be recorded in lockdep key. At this moment,
lockdep will catch possible deadlock situation and it prints the above
warning message. But, both "team0 -> team1" and "team1 -> team0"
will not be existing concurrently. so the above message is actually wrong.
In order to avoid this message, a recorded locking path should be
removed. So, both lockdep_unregister_key() and lockdep_register_key()
are needed.

Yes, netdev_update_lockdep_key() is not atomic so
"WARNING: bad unlock balance in sch_direct_xmit"
message could be printed.

Thank you so much!
Taehee Yoo
