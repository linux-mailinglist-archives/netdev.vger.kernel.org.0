Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 020A790D1A
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 07:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbfHQF1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 01:27:11 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36903 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfHQF1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 01:27:11 -0400
Received: by mail-wr1-f68.google.com with SMTP id z11so3437886wrt.4
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 22:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NU0jLaIKa8KHw29zYo1LVPuYTIdGrh6HxBAHTCKBWGE=;
        b=aBSYceUCX2lyj/GhORNY1qTM//uRZJDPFtFB/m44hgd5S5+7eC5vW1tuTiqBes7D+U
         m9HXSJB7O1C2LtJ8PQmX7jPuCzYf6dA5sN2HE5WJDGssimUrRhzfAfe5EahmI18DXLnl
         Bh3em+yuiXV1ZUIvv6kTZJRpraAkqNgcVZ4M/obfHFelGUGm4CAHkmaB5MrkNWhR22oa
         FMt85sTBlXRHuJwJtl7Xvg2BX/umLNuqm6xHho3JI8L/njjWXnFOeYlsu5/r2TTnFVQj
         ypF/xrfjHYqCY74FTTfyHzxmd5FTmDpMyR1/Mn6QEF7UjI2ryht1eZ5Fi4essb5gjY6u
         9PTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NU0jLaIKa8KHw29zYo1LVPuYTIdGrh6HxBAHTCKBWGE=;
        b=rG1rNJDRipsNx+OqRzW+SHiGKBjpoQ7Vs4eKJUdX0oBVKdoaTG/Pg601+Dp6E1hS+y
         /Adr0ujI1CBcS56Tm34bIVTBTHiBe0zGyT67tK7l6se+0XxFJv8hvXoS9N4UssBz2Fuv
         vdP2ulP/1oyuNFtbRehgQfeW0UflOV/I3OnkESGIFTFKJbbOrlIYXcU3z+rUPwtihHIC
         ogr+Fpp8HG9fbZRJokZVf4upQtfuEnu+/9hZdUVXkfvlA1jcOEVMnQt7Yvfyt6mU3kXy
         YaNG6qww1LkILBzz2BKL0kQ/gm6W7qH4R2pl6oO9bg+EifH57UHqopXvWsWf1uqjfOjc
         oycg==
X-Gm-Message-State: APjAAAU5WKanOLZtlCOVOkk6TXdoInWpoLQWGZtyG6+2jp8yFiC+WhDv
        hzn4xjsJglNA0JFqwo0q3VTaYg==
X-Google-Smtp-Source: APXvYqyX9nWsgVyAsXACQPvXx6OCIojwL7kaucvzWy2RpyTnClnryBYSbve1BuQ4qc5U2M6qMJd8Bg==
X-Received: by 2002:adf:f481:: with SMTP id l1mr14782657wro.123.1566019628120;
        Fri, 16 Aug 2019 22:27:08 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t198sm10776458wmt.39.2019.08.16.22.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 22:27:07 -0700 (PDT)
Date:   Sat, 17 Aug 2019 07:27:06 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        davem@davemloft.net, wenxu@ucloud.cn, pablo@netfilter.org
Subject: Re: [PATCH net-next] net: flow_offload: convert block_ing_cb_list to
 regular list type
Message-ID: <20190817052706.GA2237@nanopsycho>
References: <20190816150654.22106-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816150654.22106-1-vladbu@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 16, 2019 at 05:06:54PM CEST, vladbu@mellanox.com wrote:
>RCU list block_ing_cb_list is protected by rcu read lock in
>flow_block_ing_cmd() and with flow_indr_block_ing_cb_lock mutex in all
>functions that use it. However, flow_block_ing_cmd() needs to call blocking
>functions while iterating block_ing_cb_list which leads to following
>suspicious RCU usage warning:
>
>[  401.510948] =============================
>[  401.510952] WARNING: suspicious RCU usage
>[  401.510993] 5.3.0-rc3+ #589 Not tainted
>[  401.510996] -----------------------------
>[  401.511001] include/linux/rcupdate.h:265 Illegal context switch in RCU read-side critical section!
>[  401.511004]
>               other info that might help us debug this:
>
>[  401.511008]
>               rcu_scheduler_active = 2, debug_locks = 1
>[  401.511012] 7 locks held by test-ecmp-add-v/7576:
>[  401.511015]  #0: 00000000081d71a5 (sb_writers#4){.+.+}, at: vfs_write+0x166/0x1d0
>[  401.511037]  #1: 000000002bd338c3 (&of->mutex){+.+.}, at: kernfs_fop_write+0xef/0x1b0
>[  401.511051]  #2: 00000000c921c634 (kn->count#317){.+.+}, at: kernfs_fop_write+0xf7/0x1b0
>[  401.511062]  #3: 00000000a19cdd56 (&dev->mutex){....}, at: sriov_numvfs_store+0x6b/0x130
>[  401.511079]  #4: 000000005425fa52 (pernet_ops_rwsem){++++}, at: unregister_netdevice_notifier+0x30/0x140
>[  401.511092]  #5: 00000000c5822793 (rtnl_mutex){+.+.}, at: unregister_netdevice_notifier+0x35/0x140
>[  401.511101]  #6: 00000000c2f3507e (rcu_read_lock){....}, at: flow_block_ing_cmd+0x5/0x130
>[  401.511115]
>               stack backtrace:
>[  401.511121] CPU: 21 PID: 7576 Comm: test-ecmp-add-v Not tainted 5.3.0-rc3+ #589
>[  401.511124] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
>[  401.511127] Call Trace:
>[  401.511138]  dump_stack+0x85/0xc0
>[  401.511146]  ___might_sleep+0x100/0x180
>[  401.511154]  __mutex_lock+0x5b/0x960
>[  401.511162]  ? find_held_lock+0x2b/0x80
>[  401.511173]  ? __tcf_get_next_chain+0x1d/0xb0
>[  401.511179]  ? mark_held_locks+0x49/0x70
>[  401.511194]  ? __tcf_get_next_chain+0x1d/0xb0
>[  401.511198]  __tcf_get_next_chain+0x1d/0xb0
>[  401.511251]  ? uplink_rep_async_event+0x70/0x70 [mlx5_core]
>[  401.511261]  tcf_block_playback_offloads+0x39/0x160
>[  401.511276]  tcf_block_setup+0x1b0/0x240
>[  401.511312]  ? mlx5e_rep_indr_setup_tc_cb+0xca/0x290 [mlx5_core]
>[  401.511347]  ? mlx5e_rep_indr_tc_block_unbind+0x50/0x50 [mlx5_core]
>[  401.511359]  tc_indr_block_get_and_ing_cmd+0x11b/0x1e0
>[  401.511404]  ? mlx5e_rep_indr_tc_block_unbind+0x50/0x50 [mlx5_core]
>[  401.511414]  flow_block_ing_cmd+0x7e/0x130
>[  401.511453]  ? mlx5e_rep_indr_tc_block_unbind+0x50/0x50 [mlx5_core]
>[  401.511462]  __flow_indr_block_cb_unregister+0x7f/0xf0
>[  401.511502]  mlx5e_nic_rep_netdevice_event+0x75/0xb0 [mlx5_core]
>[  401.511513]  unregister_netdevice_notifier+0xe9/0x140
>[  401.511554]  mlx5e_cleanup_rep_tx+0x6f/0xe0 [mlx5_core]
>[  401.511597]  mlx5e_detach_netdev+0x4b/0x60 [mlx5_core]
>[  401.511637]  mlx5e_vport_rep_unload+0x71/0xc0 [mlx5_core]
>[  401.511679]  esw_offloads_disable+0x5b/0x90 [mlx5_core]
>[  401.511724]  mlx5_eswitch_disable.cold+0xdf/0x176 [mlx5_core]
>[  401.511759]  mlx5_device_disable_sriov+0xab/0xb0 [mlx5_core]
>[  401.511794]  mlx5_core_sriov_configure+0xaf/0xd0 [mlx5_core]
>[  401.511805]  sriov_numvfs_store+0xf8/0x130
>[  401.511817]  kernfs_fop_write+0x122/0x1b0
>[  401.511826]  vfs_write+0xdb/0x1d0
>[  401.511835]  ksys_write+0x65/0xe0
>[  401.511847]  do_syscall_64+0x5c/0xb0
>[  401.511857]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>[  401.511862] RIP: 0033:0x7fad892d30f8
>[  401.511868] Code: 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 25 96 0d 00 8b 00 85 c0 75 17 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 60 c3 0f 1f 80 00 00 00 00 48 83
> ec 28 48 89
>[  401.511871] RSP: 002b:00007ffca2a9fad8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
>[  401.511875] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fad892d30f8
>[  401.511878] RDX: 0000000000000002 RSI: 000055afeb072a90 RDI: 0000000000000001
>[  401.511881] RBP: 000055afeb072a90 R08: 00000000ffffffff R09: 000000000000000a
>[  401.511884] R10: 000055afeb058710 R11: 0000000000000246 R12: 0000000000000002
>[  401.511887] R13: 00007fad893a8780 R14: 0000000000000002 R15: 00007fad893a3740
>
>To fix the described incorrect RCU usage, convert block_ing_cb_list from
>RCU list to regular list and protect it with flow_indr_block_ing_cb_lock
>mutex in flow_block_ing_cmd().
>
>Fixes: 1150ab0f1b33 ("flow_offload: support get multi-subsystem block")
>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
