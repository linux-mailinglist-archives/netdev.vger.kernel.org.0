Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98CBE6F3F0
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 17:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfGUPYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 11:24:46 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50912 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfGUPYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 11:24:46 -0400
Received: by mail-wm1-f68.google.com with SMTP id v15so32842009wml.0
        for <netdev@vger.kernel.org>; Sun, 21 Jul 2019 08:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=A/FayYfEZwclTVLcqb9vLhIigzUPC/ByRmb8yLazSr8=;
        b=AePCHgVCav18/zTnm6IuTcPH3rdItkfgWabnuS2DEl/xMWIygw0bjLbByiR90/Wpv6
         tiQQW8fBe+pa1LQlLD/0UcawxcQr7b8+U+s8/FGSI5i8q+fsVRXlxc++wrrTUvNtEvig
         hbWu92JD3SFxHdKm1W1NiRyYpaJ72bMyS6fMlfvSh/4en7zfoe24GtZp6PLQvZxW+S1K
         IiTcpBKkMOz7Gr5YFGPoks4ALVpE1Sv4afcJTmMQorjiHWGZpwm8J9qG3x/d+/n9lehy
         Ps8bd6hJ13Z7mNgJxMd076569VgGdDgqnMjs+FwYNiivBOsU5zSCo3AmgkPxiuDybyne
         qALg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=A/FayYfEZwclTVLcqb9vLhIigzUPC/ByRmb8yLazSr8=;
        b=T/02RgLjC2Xq9acAqewaP6JdiapyXv9/SOH8JOSDzbQCoBYdM5UqBhy71BsvlsO3nw
         WTcA5md9vSQyj82H0ymt3tYPPSJyYBHNsyHkb0krE1GGBIuc+y1t6ip7rd7E3prWgT+H
         NFGQ+AHoiWtqmpOyG8r/1t+uWR+MtW9mu/fePTk+vCmQUCOjkxyjPcZyZR5iNu1zNkkx
         RJUgV9JbAKnekdVrS3LF5OKUQvk0RNChVLCYNOPwvnn8i13GShN3f13NuN6BekKNIVZj
         4z2OfpH5LWVjjRQ7//LysAm7GX7grCoa3ODN50vKo5SZ6otqlgZYEUa26qBZo1Sibwde
         wurw==
X-Gm-Message-State: APjAAAUMR6h3ZXjL4h8obmfKzrFQTN7/jmRxij0iRiZ149b1um5VT00F
        J3OCIxAJ2EjAGixwfsvVUb1Uhcv0
X-Google-Smtp-Source: APXvYqxUptUsv3S+V4+wy41YGDZk+KZUTTqB3Wq3z66UZ6zw9FfdBaEtBnu5JH8ekne1Ldqo1rvBNA==
X-Received: by 2002:a1c:a6d3:: with SMTP id p202mr60714081wme.26.1563722683181;
        Sun, 21 Jul 2019 08:24:43 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id s63sm31114758wme.17.2019.07.21.08.24.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 21 Jul 2019 08:24:42 -0700 (PDT)
Date:   Sun, 21 Jul 2019 17:24:41 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        davem@davemloft.net
Subject: Re: [PATCH net-next] net: sched: verify that q!=NULL before setting
 q->flags
Message-ID: <20190721152441.GA2365@nanopsycho.orion>
References: <20190721144412.2783-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20190721144412.2783-1-vladbu@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jul 21, 2019 at 04:44:12PM CEST, vladbu@mellanox.com wrote:
>In function int tc_new_tfilter() q pointer can be NULL when adding filter
>on a shared block. With recent change that resets TCQ_F_CAN_BYPASS after
>filter creation, following NULL pointer dereference happens in case parent
>block is shared:
>
>[  212.925060] BUG: kernel NULL pointer dereference, address: 000000000000=
0010
>[  212.925445] #PF: supervisor write access in kernel mode
>[  212.925709] #PF: error_code(0x0002) - not-present page
>[  212.925965] PGD 8000000827923067 P4D 8000000827923067 PUD 827924067 PMD=
 0
>[  212.926302] Oops: 0002 [#1] SMP KASAN PTI
>[  212.926539] CPU: 18 PID: 2617 Comm: tc Tainted: G    B             5.2.=
0+ #512
>[  212.926938] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.=
0b 03/30/2017
>[  212.927364] RIP: 0010:tc_new_tfilter+0x698/0xd40
>[  212.927633] Code: 74 0d 48 85 c0 74 08 48 89 ef e8 03 aa 62 00 48 8b 84=
 24 a0 00 00 00 48 8d 78 10 48 89 44 24 18 e8 4d 0c 6b ff 48 8b 44 24 18 <8=
3> 60 10 f
>b 48 85 ed 0f 85 3d fe ff ff e9 4f fe ff ff e8 81 26 f8
>[  212.928607] RSP: 0018:ffff88884fd5f5d8 EFLAGS: 00010296
>[  212.928905] RAX: 0000000000000000 RBX: 0000000000000000 RCX: dffffc0000=
000000
>[  212.929201] RDX: 0000000000000007 RSI: 0000000000000004 RDI: 0000000000=
000297
>[  212.929402] RBP: ffff88886bedd600 R08: ffffffffb91d4b51 R09: fffffbfff7=
616e4d
>[  212.929609] R10: fffffbfff7616e4c R11: ffffffffbb0b7263 R12: ffff88886b=
c61040
>[  212.929803] R13: ffff88884fd5f950 R14: ffffc900039c5000 R15: ffff88835e=
927680
>[  212.929999] FS:  00007fe7c50b6480(0000) GS:ffff88886f980000(0000) knlGS=
:0000000000000000
>[  212.930235] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>[  212.930394] CR2: 0000000000000010 CR3: 000000085bd04002 CR4: 0000000000=
1606e0
>[  212.930588] Call Trace:
>[  212.930682]  ? tc_del_tfilter+0xa40/0xa40
>[  212.930811]  ? __lock_acquire+0x5b5/0x2460
>[  212.930948]  ? find_held_lock+0x85/0xa0
>[  212.931081]  ? tc_del_tfilter+0xa40/0xa40
>[  212.931201]  rtnetlink_rcv_msg+0x4ab/0x5f0
>[  212.931332]  ? rtnl_dellink+0x490/0x490
>[  212.931454]  ? lockdep_hardirqs_on+0x260/0x260
>[  212.931589]  ? netlink_deliver_tap+0xab/0x5a0
>[  212.931717]  ? match_held_lock+0x1b/0x240
>[  212.931844]  netlink_rcv_skb+0xd0/0x200
>[  212.931958]  ? rtnl_dellink+0x490/0x490
>[  212.932079]  ? netlink_ack+0x440/0x440
>[  212.932205]  ? netlink_deliver_tap+0x161/0x5a0
>[  212.932335]  ? lock_downgrade+0x360/0x360
>[  212.932457]  ? lock_acquire+0xe5/0x210
>[  212.932579]  netlink_unicast+0x296/0x350
>[  212.932705]  ? netlink_attachskb+0x390/0x390
>[  212.932834]  ? _copy_from_iter_full+0xe0/0x3a0
>[  212.932976]  netlink_sendmsg+0x394/0x600
>[  212.937998]  ? netlink_unicast+0x350/0x350
>[  212.943033]  ? move_addr_to_kernel.part.0+0x90/0x90
>[  212.948115]  ? netlink_unicast+0x350/0x350
>[  212.953185]  sock_sendmsg+0x96/0xa0
>[  212.958099]  ___sys_sendmsg+0x482/0x520
>[  212.962881]  ? match_held_lock+0x1b/0x240
>[  212.967618]  ? copy_msghdr_from_user+0x250/0x250
>[  212.972337]  ? lock_downgrade+0x360/0x360
>[  212.976973]  ? rwlock_bug.part.0+0x60/0x60
>[  212.981548]  ? __mod_node_page_state+0x1f/0xa0
>[  212.986060]  ? match_held_lock+0x1b/0x240
>[  212.990567]  ? find_held_lock+0x85/0xa0
>[  212.994989]  ? do_user_addr_fault+0x349/0x5b0
>[  212.999387]  ? lock_downgrade+0x360/0x360
>[  213.003713]  ? find_held_lock+0x85/0xa0
>[  213.007972]  ? __fget_light+0xa1/0xf0
>[  213.012143]  ? sockfd_lookup_light+0x91/0xb0
>[  213.016165]  __sys_sendmsg+0xba/0x130
>[  213.020040]  ? __sys_sendmsg_sock+0xb0/0xb0
>[  213.023870]  ? handle_mm_fault+0x337/0x470
>[  213.027592]  ? page_fault+0x8/0x30
>[  213.031316]  ? lockdep_hardirqs_off+0xbe/0x100
>[  213.034999]  ? mark_held_locks+0x24/0x90
>[  213.038671]  ? do_syscall_64+0x1e/0xe0
>[  213.042297]  do_syscall_64+0x74/0xe0
>[  213.045828]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>[  213.049354] RIP: 0033:0x7fe7c527c7b8
>[  213.052792] Code: 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00=
 f3 0f 1e fa 48 8d 05 65 8f 0c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05 <4=
8> 3d 00 f
>0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 89 54
>[  213.060269] RSP: 002b:00007ffc3f7908a8 EFLAGS: 00000246 ORIG_RAX: 00000=
0000000002e
>[  213.064144] RAX: ffffffffffffffda RBX: 000000005d34716f RCX: 00007fe7c5=
27c7b8
>[  213.068094] RDX: 0000000000000000 RSI: 00007ffc3f790910 RDI: 0000000000=
000003
>[  213.072109] RBP: 0000000000000000 R08: 0000000000000001 R09: 00007fe7c5=
340cc0
>[  213.076113] R10: 0000000000404ec2 R11: 0000000000000246 R12: 0000000000=
000080
>[  213.080146] R13: 0000000000480640 R14: 0000000000000080 R15: 0000000000=
000000
>[  213.084147] Modules linked in: act_gact cls_flower sch_ingress nfsv3 nf=
s_acl nfs lockd grace fscache bridge stp llc sunrpc intel_rapl_msr intel_ra=
pl_common
>=1B[<1;69;32Msb_edac rdma_ucm rdma_cm x86_pkg_temp_thermal iw_cm intel_pow=
erclamp ib_cm coretemp kvm_intel kvm irqbypass mlx5_ib ib_uverbs ib_core cr=
ct10dif_pclmul crc32_pc
>lmul crc32c_intel ghash_clmulni_intel mlx5_core intel_cstate intel_uncore =
iTCO_wdt igb iTCO_vendor_support mlxfw mei_me ptp ses intel_rapl_perf mei p=
cspkr ipmi
>_ssif i2c_i801 joydev enclosure pps_core lpc_ich ioatdma wmi dca ipmi_si i=
pmi_devintf ipmi_msghandler acpi_power_meter acpi_pad ast i2c_algo_bit drm_=
vram_helpe
>r ttm drm_kms_helper drm mpt3sas raid_class scsi_transport_sas
>[  213.112326] CR2: 0000000000000010
>[  213.117429] ---[ end trace adb58eb0a4ee6283 ]---
>
>Verify that q pointer is not NULL before setting the 'flags' field.
>
>Fixes: 3f05e6886a59 ("net_sched: unset TCQ_F_CAN_BYPASS when adding filter=
s")
>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>

Thanks!
