Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C4B134E2
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 23:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfECV3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 17:29:18 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45470 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbfECV3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 17:29:18 -0400
Received: by mail-io1-f67.google.com with SMTP id b3so683688iob.12
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 14:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LcrV/3EcJUTi0fs/wwCFty5vr8fef9392FC7BwCRnGY=;
        b=vv4FFOyU4BuHrWauPPfxz85Zahqnvwf098NZknVMs301+eZYA8ard5ymc2QubPvCUM
         envV7KzuETdlg3x2tG55trHRq48E6KBfWVIPajLCw+R9aNRyq+GSK/nCNh7U6Bhk7xen
         i0zsNjDtVz1ogRcUaee86Cr7ZWfJ+i0unfUz1tJo1MnovvA02A81BLpWGFfmw+50zO4x
         +yU+XW3uz2ha3ZyK9pH61BwPdzVPKg7AfxrxCO+NKxQjPo1xQ5kny/rdFyfHeVCyljKR
         rRMvzi6YuijMSA4hQCZJpnwqtYzznViZlMth1pkJr/FEdT8yTPkHmCVSrzwZrl+6b7YF
         ws1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LcrV/3EcJUTi0fs/wwCFty5vr8fef9392FC7BwCRnGY=;
        b=OeOQAQ6cBLtcc3zCrb1uZinznzQBaL1KVg6hN4cHYedl8M4NwN/X4eBcLLfO4vpJyc
         B9T73IK5gaILCweuYV6VnBJlJFWFy4r5DjuRtMSE30wejeCpaYmBVtW5PPrsZ7FrIsVq
         L4BQ11Mc5pWmX7swIdT3WR81XkFtiZuHkwtEjztNDLDV37aR/B9ekJV+JS7/7VohGAtA
         /BFNKacSq0XMvAv3LKRGYaSDefkqBgtjmf+YdP8CPPndwwuVvdFLyUO+XMb+UIGf4KHM
         uEBwHjzntzM16d7EfmISqccanbtjoMaORoULNpZtKFrtQAjYLV2jsd6alFIVHubDwnFq
         pCdA==
X-Gm-Message-State: APjAAAXMMgWjCvwgXCuANM0ey/48EVvq8E/sLwJWavR9co6wC0kjlp4J
        lj2GUcGSSEJx/xH2J2r+KGhmTh6xrYQ=
X-Google-Smtp-Source: APXvYqwcTdcj2DkncRpcWxnAMn617HK6asbSWrZn5M88XFu1pePp+j8UwhUrdAxOhoTObCEZzvK2NQ==
X-Received: by 2002:a5e:8904:: with SMTP id k4mr1473799ioj.264.1556918957096;
        Fri, 03 May 2019 14:29:17 -0700 (PDT)
Received: from x220t ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id x11sm1430976itf.38.2019.05.03.14.29.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 14:29:16 -0700 (PDT)
Date:   Fri, 3 May 2019 17:29:11 -0400
From:   Alexander Aring <aring@mojatatu.com>
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wpan@vger.kernel.org
Subject: Re: [PATCH] ieee802154: hwsim: unregister hw while
 hwsim_subscribe_all_others fails
Message-ID: <20190503212911.dxjf5ceoj2fkj4ij@x220t>
References: <20190428154810.40052-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190428154810.40052-1-yuehaibing@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Apr 28, 2019 at 11:48:10PM +0800, Yue Haibing wrote:
> From: YueHaibing <yuehaibing@huawei.com>
> 
> KASAN report this:
> 
> kernel BUG at net/mac802154/main.c:130!
> invalid opcode: 0000 [#1] PREEMPT SMP
> CPU: 0 PID: 19932 Comm: modprobe Not tainted 5.1.0-rc6+ #22
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
> RIP: 0010:ieee802154_free_hw+0x2a/0x30 [mac802154]
> Code: 55 48 8d 57 38 48 89 e5 53 48 89 fb 48 8b 47 38 48 39 c2 75 15 48 8d 7f 48 e8 82 85 16 e1 48 8b 7b 28 e8 f9 ef 83 e2 5b 5d c3 <0f> 0b 0f 1f 40 00 55 48 89 e5 53 48 89 fb 0f b6 86 80 00 00 00 88
> RSP: 0018:ffffc90001c7b9f0 EFLAGS: 00010206
> RAX: ffff88822df3aa80 RBX: ffff88823143d5c0 RCX: 0000000000000002
> RDX: ffff88823143d5f8 RSI: ffff88822b1fabc0 RDI: ffff88823143d5c0
> RBP: ffffc90001c7b9f8 R08: 0000000000000000 R09: 0000000000000001
> R10: 0000000000000000 R11: 0000000000000000 R12: 00000000fffffff4
> R13: ffff88822dea4f50 R14: ffff88823143d7c0 R15: 00000000fffffff4
> FS: 00007ff52e999540(0000) GS:ffff888237a00000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fdc06dba768 CR3: 000000023160a000 CR4: 00000000000006f0
> Call Trace:
>  hwsim_add_one+0x2dd/0x540 [mac802154_hwsim]
>  hwsim_probe+0x2f/0xb0 [mac802154_hwsim]
>  platform_drv_probe+0x3a/0x90
>  ? driver_sysfs_add+0x79/0xb0
>  really_probe+0x1d4/0x2d0
>  driver_probe_device+0x50/0xf0
>  device_driver_attach+0x54/0x60
>  __driver_attach+0x7e/0xd0
>  ? device_driver_attach+0x60/0x60
>  bus_for_each_dev+0x68/0xc0
>  driver_attach+0x19/0x20
>  bus_add_driver+0x15e/0x200
>  driver_register+0x5b/0xf0
>  __platform_driver_register+0x31/0x40
>  hwsim_init_module+0x74/0x1000 [mac802154_hwsim]
>  ? 0xffffffffa00e9000
>  do_one_initcall+0x6c/0x3cc
>  ? kmem_cache_alloc_trace+0x248/0x3b0
>  do_init_module+0x5b/0x1f1
>  load_module+0x1db1/0x2690
>  ? m_show+0x1d0/0x1d0
>  __do_sys_finit_module+0xc5/0xd0
>  __x64_sys_finit_module+0x15/0x20
>  do_syscall_64+0x6b/0x1d0
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x7ff52e4a2839
> Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1f f6 2c 00 f7 d8 64 89 01 48
> RSP: 002b:00007ffffa7b3c08 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
> RAX: ffffffffffffffda RBX: 00005647560a2a00 RCX: 00007ff52e4a2839
> RDX: 0000000000000000 RSI: 00005647547f3c2e RDI: 0000000000000003
> RBP: 00005647547f3c2e R08: 0000000000000000 R09: 00005647560a2a00
> R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000000
> R13: 00005647560a2c10 R14: 0000000000040000 R15: 00005647560a2a00
> Modules linked in: mac802154_hwsim(+) mac802154 [last unloaded: mac802154_hwsim]
> 
> In hwsim_add_one, if hwsim_subscribe_all_others fails, we
> should call ieee802154_unregister_hw to free resources.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Alexander Aring <aring@mojatatu.com>

Thanks.

- Alex
