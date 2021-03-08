Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D94331552
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 18:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhCHRzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 12:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhCHRzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 12:55:03 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82E7C06174A;
        Mon,  8 Mar 2021 09:55:03 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id u8so10838760ior.13;
        Mon, 08 Mar 2021 09:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DpeV9n0YEBJ6XtFzn7z6lpNmmwQWNflpSoZ0GA3Tyko=;
        b=SXrmlw3QyaQWVSJlj4yycZUndqrZp55/na7AEufseJJ45BgivPx5ULhmKPPbcG33rk
         A48+PKO62WAzAHn6e7jIWamBBfnBTYmn5u9zCgjTEpVWMdZKkz6uC8dRAlgdywASIqyT
         5nw/ip/cUyoCZ7VWJM9C6/eD1aXXRqwqMOVl0/KN0RwZtk3G7BmHiW5RIU9RE61HXeJ+
         TiUGqWKuPTUZAmrBThk15zjpnu89WztVWSox9MkCQdxf4ah7vAPckEPva2mLpjElVzRP
         2PHsmP1yvXjDikKP/SrL7tj3J1uGcrHxZeKFcb1ugmteTKRh7LWDKihRadVVsMcEMPRQ
         5d8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DpeV9n0YEBJ6XtFzn7z6lpNmmwQWNflpSoZ0GA3Tyko=;
        b=lUoC8eef7wZSWXiBeZFoeK+njeyuLtwLbmQdV2ZrcFfrN92WRzSrUUFGaYXkAuJL9s
         ZtZIBeq5ycQjN5Z5fmfmPRxBop5RCtMP2vVRcrJtpkIX8n2jEFtJ4NB/w6QNXE1/+dRl
         zf5KakJ8OfYosSTrnq+UVFE3ZkfXwAT7s/jJ5gq9psv/RFXgsRyNFLJvSO4OrhP2H9Ix
         eWSTGINkivVNz064ey31eEybbhFBdZRPp9DYZ3HeXhktuqs5GDUfh6htoSUo2mdncWXC
         rLjJeFeAaR2PHrE/jL+c3a2f8w8zm9+QmGU9QkvClwlQp1a0Om9EqdZc5EyEkIF/nbxM
         gyTA==
X-Gm-Message-State: AOAM533oTtIdIOtlQ+wGTM7Xguf2sxUNJRMdJlrewDEP0w+13OCzo5R2
        20lqEhrrrfdA22qmzy5H1Pq9zKmLK3WnHip/2mksl9o/Q6Zk/w==
X-Google-Smtp-Source: ABdhPJycFzlAQD5YomxMNjKST8s1OPQ1uoAm1IjuFh+LptP7TdBnaZjT3l1BlEZ5Lka/jYP+gtMRj5hDzVVP0/fb6ow=
X-Received: by 2002:a5d:9e03:: with SMTP id h3mr19804855ioh.94.1615226103062;
 Mon, 08 Mar 2021 09:55:03 -0800 (PST)
MIME-Version: 1.0
References: <20210308032529.435224-1-ztong0001@gmail.com> <CAKgT0UftdTobwgA6hi=CdOfQ+1fdozhPs89fDmapbvcp7jLASw@mail.gmail.com>
In-Reply-To: <CAKgT0UftdTobwgA6hi=CdOfQ+1fdozhPs89fDmapbvcp7jLASw@mail.gmail.com>
From:   Tong Zhang <ztong0001@gmail.com>
Date:   Mon, 8 Mar 2021 12:54:52 -0500
Message-ID: <CAA5qM4BG2PNvvLFDngQRe4kBL5zATUOnaHt_-2s7Y47CcJF+bA@mail.gmail.com>
Subject: Re: [PATCH 0/3] fix a couple of atm->phy_data related issues
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,
attached is the kernel log for zatm(uPD98402) -- I also have
idt77252's log -- which is similar to this one --
I think it makes sense to drop if no one is actually using it --
- Tong

[    5.740774] BUG: KASAN: null-ptr-deref in uPD98402_start+0x5e/0x219
[uPD98402]
[    5.741179] Write of size 4 at addr 000000000000002c by task modprobe/96
[    5.741548]
[    5.741637] CPU: 0 PID: 96 Comm: modprobe Not tainted 5.12.0-rc2-dirty #71
[    5.742017] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
[    5.742635] Call Trace:
[    5.742775]  dump_stack+0x8a/0xb5
[    5.742966]  kasan_report.cold+0x10f/0x111
[    5.743197]  ? uPD98402_start+0x5e/0x219 [uPD98402]
[    5.743473]  uPD98402_start+0x5e/0x219 [uPD98402]
[    5.743739]  zatm_init_one+0x10b5/0x1311 [zatm]
[    5.743998]  ? zatm_int.cold+0x30/0x30 [zatm]
[    5.744246]  ? _raw_write_lock_irqsave+0xd0/0xd0
[    5.744507]  ? __mutex_lock_slowpath+0x10/0x10
[    5.744757]  ? _raw_spin_unlock_irqrestore+0xd/0x20
[    5.745030]  ? zatm_int.cold+0x30/0x30 [zatm]
[    5.745278]  local_pci_probe+0x6f/0xb0
[    5.745492]  pci_device_probe+0x171/0x240
[    5.745718]  ? pci_device_remove+0xe0/0xe0
[    5.745949]  ? kernfs_create_link+0xb6/0x110
[    5.746190]  ? sysfs_do_create_link_sd.isra.0+0x76/0xe0
[    5.746482]  really_probe+0x161/0x420
[    5.746691]  driver_probe_device+0x6d/0xd0
[    5.746923]  device_driver_attach+0x82/0x90
[    5.747158]  ? device_driver_attach+0x90/0x90
[    5.747402]  __driver_attach+0x60/0x100
[    5.747621]  ? device_driver_attach+0x90/0x90
[    5.747864]  bus_for_each_dev+0xe1/0x140
[    5.748075]  ? subsys_dev_iter_exit+0x10/0x10
[    5.748320]  ? klist_node_init+0x61/0x80
[    5.748542]  bus_add_driver+0x254/0x2a0
[    5.748760]  driver_register+0xd3/0x150
[    5.748977]  ? 0xffffffffc0030000
[    5.749163]  do_one_initcall+0x84/0x250
[    5.749380]  ? trace_event_raw_event_initcall_finish+0x150/0x150
[    5.749714]  ? _raw_spin_unlock_irqrestore+0xd/0x20
[    5.749987]  ? create_object+0x395/0x510
[    5.750210]  ? kasan_unpoison+0x21/0x50
[    5.750427]  do_init_module+0xf8/0x350
[    5.750640]  load_module+0x40c5/0x4410
[    5.750854]  ? module_frob_arch_sections+0x20/0x20
[    5.751123]  ? kernel_read_file+0x1cd/0x3e0
[    5.751364]  ? __do_sys_finit_module+0x108/0x170
[    5.751628]  __do_sys_finit_module+0x108/0x170
[    5.751879]  ? __ia32_sys_init_module+0x40/0x40
[    5.752126]  ? file_open_root+0x200/0x200
[    5.752353]  ? do_sys_open+0x85/0xe0
[    5.752556]  ? filp_open+0x50/0x50
[    5.752750]  ? fpregs_assert_state_consistent+0x4d/0x60
[    5.753042]  ? exit_to_user_mode_prepare+0x2f/0x130
[    5.753316]  do_syscall_64+0x33/0x40
[    5.753519]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[    5.753802] RIP: 0033:0x7ff64032dcf7
 ff c3 48 c7 c6 01 00 00 00 e9 a1
[    5.755029] RSP: 002b:00007ffd250ea358 EFLAGS: 00000246 ORIG_RAX:
0000000000000139
[    5.755449] RAX: ffffffffffffffda RBX: 0000000001093a70 RCX: 00007ff64032dcf7
[    5.755847] RDX: 0000000000000000 RSI: 00000000010929e0 RDI: 0000000000000003
[    5.756242] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000001
[    5.756635] R10: 00007ff640391300 R11: 0000000000000246 R12: 00000000010929e0
[    5.757029] R13: 0000000000000000 R14: 0000000001092dd0 R15: 0000000000000001

On Mon, Mar 8, 2021 at 12:47 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Mon, Mar 8, 2021 at 12:39 AM Tong Zhang <ztong0001@gmail.com> wrote:
> >
> > there are two drivers(zatm and idt77252) using PRIV() (i.e. atm->phy_data)
> > to store private data, but the driver happens to populate wrong
> > pointers: atm->dev_data. which actually cause null-ptr-dereference in
> > following PRIV(dev). This patch series attemps to fix those two issues
> > along with a typo in atm struct.
> >
> > Tong Zhang (3):
> >   atm: fix a typo in the struct description
> >   atm: uPD98402: fix incorrect allocation
> >   atm: idt77252: fix null-ptr-dereference
> >
> >  drivers/atm/idt77105.c | 4 ++--
> >  drivers/atm/uPD98402.c | 2 +-
> >  include/linux/atmdev.h | 2 +-
> >  3 files changed, 4 insertions(+), 4 deletions(-)
>
> For the 2 phys you actually seen null pointer dereferences or are your
> changes based on just code review?
>
> I ask because it seems like this code has been this way since 2005 and
> in the case of uPD98402_start the code doesn't seem like it should
> function the way it was as PRIV is phy_data and there being issues
> seems pretty obvious since the initialization of things happens
> immediately after the allocation.
>
> I'm just wondering if it might make more sense to drop the code if it
> hasn't been run in 15+ years rather than updating it?
