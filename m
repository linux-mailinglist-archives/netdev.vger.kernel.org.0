Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E81F114524
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 17:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbfLEQv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 11:51:27 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42885 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbfLEQv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 11:51:27 -0500
Received: by mail-qt1-f194.google.com with SMTP id j5so4128279qtq.9;
        Thu, 05 Dec 2019 08:51:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ze+AW9WV7489kQRRdo9Nn0qDTPFmhzU20wg6aaDBPgo=;
        b=SMmatIdUlrJth3B1LSAHv16u6UYRWHxxr+pUDJr42EJQIxNIM1heozAGCUfcpqjZL1
         vSCQPC8hbjk9JnO8bjGqHvt1leen+TALuSMvF+IzMnPNWnd0dEsawIJnDu5rruJ12CTz
         lKW7YQfVPSrDQ/cT0AndvQIs6mj5qe4TqIEtaGQlEKuzsJiyKHb84hN7BxVPMQ2kj4wV
         bKh+poI8xXXJi9MuNc3XoruMyIsRpOVo9eadkcERuMjZAPdaF34Rzup1AO+c3GDksmiH
         JRa0nS41bM9HmtEUAWChHFKBG+4ceAjDcGyKYOQwRWoSebdMzfu0VRX48C+gBlsUVoiS
         QbEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ze+AW9WV7489kQRRdo9Nn0qDTPFmhzU20wg6aaDBPgo=;
        b=Inl0N5Moo8m2uX5EC2BXd566U0W0q97IAcB7eGFJCO8kR+S1Zt+5XpgjD8+jXw57HE
         O1Wil/IfmkqRoCnEEktVI26vZyB634I/cvJ8BtGrFJxyUPQdVhjQhMfg68SG2W/7f9w6
         OhpQJSq8DK7CvgTu627DHjvIt1CEq2C66PxpTYLnLQOgqT1PxiszPchPQx2XdCjGPPh7
         AlZnFCNkTdBN+sMOiTiVgUCFxr3dd0QV/DYJ9aK7xH21QkqkOnKftQw+FEsrm88FkBu0
         dSTtl2IWpJv4aO3CI21Ut9vOkJkotwNae7j7RZT4Rk8qzrf5gbuxGP8UVpHRnFCL5AOk
         G3gQ==
X-Gm-Message-State: APjAAAVKHXxcYPKHElCpJVzDxcLW4DT1KShFEdO3BKxTU1fcLPLJShtN
        wncUcUPs4U80HKjPoGbE4AMSjTRah1M=
X-Google-Smtp-Source: APXvYqz3fM/GNrhm23Z6NG4biyMsl0qqApr+mKV5RVP3YxJW2FLOPYKzu2f7H72oaLoF/xPW5oM5OQ==
X-Received: by 2002:ac8:1828:: with SMTP id q37mr8720449qtj.13.1575564685830;
        Thu, 05 Dec 2019 08:51:25 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:454d:f1aa:c8eb:421a])
        by smtp.googlemail.com with ESMTPSA id z64sm5277816qtc.4.2019.12.05.08.51.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 08:51:24 -0800 (PST)
Subject: Re: selftests: l2tp tests
To:     Colin Ian King <colin.king@canonical.com>,
        Shuah Khan <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>
References: <450f5abb-5fe8-158d-d267-4334e15f8e58@canonical.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d0937c02-1172-45db-8519-c36bdafad89e@gmail.com>
Date:   Thu, 5 Dec 2019 09:51:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <450f5abb-5fe8-158d-d267-4334e15f8e58@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/5/19 8:28 AM, Colin Ian King wrote:
> Hi,
> 
> While testing linux 5.4 with the l2tp test I discovered two kernel
> issues when running this test:
> 
> 1. About 10+ seconds after completing the test one can observe periodic
> kernel log messages from  netdev_wait_allrefs (in net/core/dev.c) in the
> form:
> 
> "unregister_netdevice: waiting for eth0 to become free. Usage count = 1"

That is a known problem; it existed when I submitted the test script:
https://lore.kernel.org/netdev/20190801235421.8344-1-dsahern@kernel.org/

The ipsec test case gives a reproducer for some one with the time to go
figure out the leak.

> 
> 2. Our regression tests that ran stress-ng after this test picked up
> another issue that causes socket() to hang indefinitely.  I've managed
> to get this down to a simple reproducer as follows:
> 
> sudo modprobe l2tp_core
> sudo ./linux/tools/testing/selftests/net/l2tp.sh
> sleep 5
> ./close
> 
> Where ./close is an executable compiled from:
> 
> #include <sys/types.h>
> #include <sys/socket.h>
> #include <unistd.h>
> #include <stdio.h>
> 
> int main()
> {
>         int fd;
> 
>         printf("calling socket..\n");
>         fd = socket(AF_APPLETALK, SOCK_STREAM, 0);
>         printf("socket returned: %d\n", fd);
> }
> 
> The code will hang on the socket() call and won't ever get to the final
> print statement.
> 
> If one runs the reproducer on earlier kernels we get:
> 
> 4.6.7 crash (see dmesg below)
> 4.7.10 crash in xfrm6_dst_ifdown
> 4.8.17 crash in xfrm6_dst_ifdown
> 4.12.14 crash (see dmesg below)
> 4.13.16 reports "unregister_netdevice: waiting for eth0 to become free.
> Usage count = 2"
> 4.14.157 reports "unregister_netdevice: waiting for eth0 to become free.
> Usage count = 2""
> 4.15.18 .. 5.4 hangs on socket() call
> 
> Note: functionality for the l2tp test is not available for pre-4.6 kernels.
> 
> The crashes I get for older kernels are:
> 
> 4.6.7:
> [ 34.457967] BUG: scheduling while atomic: kworker/u8:0/6/0x00000200
> [ 34.458021] Modules linked in: esp6 xfrm6_mode_transport drbg
> ansi_cprng seqiv esp4 xfrm4_mode_transport xfrm_user xfrm_algo l2tp_ip6
> l2tp_eth l2tp_ip l2tp_netlink veth l2tp_core ip6_udp_tunnel udp_tunnel
> squashfs binfmt_misc dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua
> ppdev kvm_intel kvm irqbypass joydev input_leds snd_hda_codec_generic
> serio_raw snd_hda_intel snd_hda_codec parport_pc 8250_fintek parport
> snd_hda_core qemu_fw_cfg snd_hwdep snd_pcm snd_timer mac_hid snd
> soundcore sch_fq_codel virtio_rng ip_tables x_tables autofs4 btrfs
> raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor
> async_tx xor hid_generic usbhid hid raid6_pq libcrc32c raid1 raid0
> multipath linear crct10dif_pclmul crc32_pclmul ghash_clmulni_intel qxl
> ttm drm_kms_helper syscopyarea sysfillrect aesni_intel sysimgblt
> [ 34.458086] fb_sys_fops aes_x86_64 lrw gf128mul glue_helper ablk_helper
> cryptd i2c_piix4 drm psmouse pata_acpi floppy
> [ 34.458100] CPU: 1 PID: 6 Comm: kworker/u8:0 Not tainted
> 4.6.7-040607-generic #201608160432
> [ 34.458103] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.12.0-1 04/01/2014
> [ 34.458131] Workqueue: netns cleanup_net
> [ 34.458135] 0000000000000286 000000002fa171e7 ffff88007c8e7ab8
> ffffffff813f7594
> [ 34.458139] ffff88007fc96b80 7fffffffffffffff ffff88007c8e7ac8
> ffffffff810a8f6b
> [ 34.458143] ffff88007c8e7b18 ffffffff8184905b 00ff88007c8e7ae8
> ffffffff8106463e
> [ 34.458147] Call Trace:
> [ 34.458161] [<ffffffff813f7594>] dump_stack+0x63/0x8f
> [ 34.458166] [<ffffffff810a8f6b>] __schedule_bug+0x4b/0x60
> [ 34.458185] [<ffffffff8184905b>] __schedule+0x5eb/0x7a0
> [ 34.458191] [<ffffffff8106463e>] ? kvm_sched_clock_read+0x1e/0x30
> [ 34.458195] [<ffffffff81849245>] schedule+0x35/0x80
> [ 34.458203] [<ffffffff8184c402>] schedule_timeout+0x1b2/0x270
> [ 34.458207] [<ffffffff81848d74>] ? __schedule+0x304/0x7a0
> [ 34.458212] [<ffffffff81849ca3>] wait_for_completion+0xb3/0x140
> [ 34.458217] [<ffffffff810aeed0>] ? wake_up_q+0x70/0x70
> [ 34.458226] [<ffffffff810e7f68>] __wait_rcu_gp+0xc8/0xf0
> [ 34.458231] [<ffffffff810e9fd8>] synchronize_sched.part.58+0x38/0x50
> [ 34.458235] [<ffffffff810ec570>] ? call_rcu_bh+0x20/0x20
> [ 34.458239] [<ffffffff810e7e80>] ?
> trace_raw_output_rcu_utilization+0x60/0x60
> [ 34.458244] [<ffffffff810ec643>] synchronize_sched+0x33/0x40
> [ 34.458251] [<ffffffffc0510f71>] __l2tp_session_unhash+0xd1/0xe0
> [l2tp_core]
> [ 34.458256] [<ffffffffc051101e>] l2tp_tunnel_closeall+0x9e/0x140
> [l2tp_core]
> [ 34.458261] [<ffffffffc0511219>] l2tp_tunnel_delete+0x19/0x70 [l2tp_core]
> [ 34.458265] [<ffffffffc05112bb>] l2tp_exit_net+0x4b/0x80 [l2tp_core]
> [ 34.458269] [<ffffffff81732188>] ops_exit_list.isra.4+0x38/0x60
> [ 34.458273] [<ffffffff817331e4>] cleanup_net+0x1c4/0x2a0
> [ 34.458281] [<ffffffff8109ccfc>] process_one_work+0x1fc/0x490
> [ 34.458285] [<ffffffff8109cfdb>] worker_thread+0x4b/0x500
> [ 34.458290] [<ffffffff8109cf90>] ? process_one_work+0x490/0x490
> [ 34.458293] [<ffffffff810a37c8>] kthread+0xd8/0xf0
> [ 34.458298] [<ffffffff8184d522>] ret_from_fork+0x22/0x40
> [ 34.458302] [<ffffffff810a36f0>] ? kthread_create_on_node+0x1b0/0x1b0
> [ 34.514067] ------------[ cut here ]------------
> 
> 4.12.14:
> [ 20.760253] ------------[ cut here ]------------
> [ 20.760256] kernel BUG at
> /home/kernel/COD/linux/net/ipv6/xfrm6_policy.c:265!
> [ 20.760299] invalid opcode: 0000 [#1] SMP
> [ 20.760320] Modules linked in: appletalk psnap llc esp6
> xfrm6_mode_transport esp4 xfrm4_mode_transport xfrm_user xfrm_algo
> l2tp_ip6 l2tp_eth l2tp_ip l2tp_netlink veth l2tp_core ip6_udp_tunnel
> udp_tunnel binfmt_misc dm_multipath scsi_dh_rdac scsi_dh_emc
> scsi_dh_alua joydev ppdev snd_hda_codec_generic kvm_intel kvm irqbypass
> snd_hda_intel snd_hda_codec snd_hda_core input_leds snd_hwdep serio_raw
> snd_pcm snd_timer hid_generic snd soundcore parport_pc parport mac_hid
> qemu_fw_cfg sch_fq_codel virtio_rng ip_tables x_tables autofs4 usbhid
> hid btrfs raid10 raid456 async_raid6_recov async_memcpy async_pq
> async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear
> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel
> aes_x86_64 crypto_simd qxl glue_helper ttm cryptd drm_kms_helper psmouse
> [ 20.760677] syscopyarea sysfillrect virtio_blk sysimgblt fb_sys_fops
> drm floppy virtio_net i2c_piix4 pata_acpi
> [ 20.760731] CPU: 3 PID: 49 Comm: kworker/u8:1 Not tainted
> 4.12.14-041214-generic #201709200843
> [ 20.760772] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.12.0-1 04/01/2014
> [ 20.760814] Workqueue: netns cleanup_net
> [ 20.760836] task: ffff8aa4bcbbad00 task.stack: ffff9dc5804c0000
> [ 20.760867] RIP: 0010:xfrm6_dst_ifdown+0xa0/0xb0
> [ 20.760890] RSP: 0018:ffff9dc5804c3be0 EFLAGS: 00010246
> [ 20.760916] RAX: ffff8aa4b6e6a000 RBX: ffff8aa4bc1b3500 RCX:
> 0000000000000000
> [ 20.760950] RDX: 0000000000000001 RSI: ffff8aa4b6f39000 RDI:
> ffff8aa4bc1b3500
> [ 20.760984] RBP: ffff9dc5804c3c08 R08: 0000000000000000 R09:
> ffffffffb49fd7a0
> [ 20.761017] R10: ffff9dc5804c3c70 R11: 0000000000000000 R12:
> ffff8aa4b6f39000
> [ 20.761050] R13: ffff8aa4b6f39000 R14: ffff8aa4bc1b3500 R15:
> 0000000000000000
> [ 20.761085] FS: 0000000000000000(0000) GS:ffff8aa4bfd80000(0000)
> knlGS:0000000000000000
> [ 20.761123] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 20.761150] CR2: 00007fa5cd126718 CR3: 000000007c382000 CR4:
> 00000000001406e0
> [ 20.761189] Call Trace:
> [ 20.761207] dst_ifdown+0x26/0x80
> [ 20.761226] dst_dev_event+0x5c/0x170
> [ 20.761247] notifier_call_chain+0x4a/0x70
> [ 20.761269] raw_notifier_call_chain+0x16/0x20
> [ 20.761293] call_netdevice_notifiers_info+0x35/0x60
> [ 20.761318] netdev_run_todo+0xcf/0x300
> [ 20.761340] rtnl_unlock+0xe/0x10
> [ 20.761359] default_device_exit_batch+0x153/0x180
> [ 20.761385] ? do_wait_intr_irq+0x90/0x90
> [ 20.761408] ops_exit_list.isra.6+0x52/0x60
> [ 20.761430] cleanup_net+0x1ca/0x2b0
> [ 20.761451] process_one_work+0x1e7/0x410
> [ 20.761472] worker_thread+0x4a/0x410
> [ 20.761492] kthread+0x125/0x140
> [ 20.761511] ? process_one_work+0x410/0x410
> [ 20.761532] ? kthread_create_on_node+0x70/0x70
> [ 20.761556] ret_from_fork+0x25/0x30
> [ 20.761575] Code: f0 00 00 00 75 05 e8 10 6f 00 00 4c 89 bb 58 01 00 00
> f0 41 ff 04 24 48 8b 5b 10 48 83 7b 48 00 75 d4 f0 41 ff 0c 24 eb 8e f3
> c3 <0f> 0b 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 55 b9 06 00 00
> [ 20.761695] RIP: xfrm6_dst_ifdown+0xa0/0xb0 RSP: ffff9dc5804c3be0
> [ 20.762104] ---[ end trace b22472ed4abae541 ]---
> 
> So all in all, the test is great for finding bugs. I thought I should
> flag these issues up.

These I am not aware of. I do not do much with l2tp. The script evolved
from discussions for some change and I saved the commands as tests - for
just reasons like this.

