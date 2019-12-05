Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68A65114386
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 16:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729780AbfLEP2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 10:28:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39676 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfLEP2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 10:28:32 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1ict3M-0005Rk-1A; Thu, 05 Dec 2019 15:28:28 +0000
To:     David Ahern <dsahern@gmail.com>, Shuah Khan <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>
From:   Colin Ian King <colin.king@canonical.com>
Autocrypt: addr=colin.king@canonical.com; prefer-encrypt=mutual; keydata=
 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
Subject: selftests: l2tp tests
Message-ID: <450f5abb-5fe8-158d-d267-4334e15f8e58@canonical.com>
Date:   Thu, 5 Dec 2019 15:28:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

While testing linux 5.4 with the l2tp test I discovered two kernel
issues when running this test:

1. About 10+ seconds after completing the test one can observe periodic
kernel log messages from  netdev_wait_allrefs (in net/core/dev.c) in the
form:

"unregister_netdevice: waiting for eth0 to become free. Usage count = 1"

2. Our regression tests that ran stress-ng after this test picked up
another issue that causes socket() to hang indefinitely.  I've managed
to get this down to a simple reproducer as follows:

sudo modprobe l2tp_core
sudo ./linux/tools/testing/selftests/net/l2tp.sh
sleep 5
./close

Where ./close is an executable compiled from:

#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdio.h>

int main()
{
        int fd;

        printf("calling socket..\n");
        fd = socket(AF_APPLETALK, SOCK_STREAM, 0);
        printf("socket returned: %d\n", fd);
}

The code will hang on the socket() call and won't ever get to the final
print statement.

If one runs the reproducer on earlier kernels we get:

4.6.7 crash (see dmesg below)
4.7.10 crash in xfrm6_dst_ifdown
4.8.17 crash in xfrm6_dst_ifdown
4.12.14 crash (see dmesg below)
4.13.16 reports "unregister_netdevice: waiting for eth0 to become free.
Usage count = 2"
4.14.157 reports "unregister_netdevice: waiting for eth0 to become free.
Usage count = 2""
4.15.18 .. 5.4 hangs on socket() call

Note: functionality for the l2tp test is not available for pre-4.6 kernels.

The crashes I get for older kernels are:

4.6.7:
[ 34.457967] BUG: scheduling while atomic: kworker/u8:0/6/0x00000200
[ 34.458021] Modules linked in: esp6 xfrm6_mode_transport drbg
ansi_cprng seqiv esp4 xfrm4_mode_transport xfrm_user xfrm_algo l2tp_ip6
l2tp_eth l2tp_ip l2tp_netlink veth l2tp_core ip6_udp_tunnel udp_tunnel
squashfs binfmt_misc dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua
ppdev kvm_intel kvm irqbypass joydev input_leds snd_hda_codec_generic
serio_raw snd_hda_intel snd_hda_codec parport_pc 8250_fintek parport
snd_hda_core qemu_fw_cfg snd_hwdep snd_pcm snd_timer mac_hid snd
soundcore sch_fq_codel virtio_rng ip_tables x_tables autofs4 btrfs
raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor
async_tx xor hid_generic usbhid hid raid6_pq libcrc32c raid1 raid0
multipath linear crct10dif_pclmul crc32_pclmul ghash_clmulni_intel qxl
ttm drm_kms_helper syscopyarea sysfillrect aesni_intel sysimgblt
[ 34.458086] fb_sys_fops aes_x86_64 lrw gf128mul glue_helper ablk_helper
cryptd i2c_piix4 drm psmouse pata_acpi floppy
[ 34.458100] CPU: 1 PID: 6 Comm: kworker/u8:0 Not tainted
4.6.7-040607-generic #201608160432
[ 34.458103] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.12.0-1 04/01/2014
[ 34.458131] Workqueue: netns cleanup_net
[ 34.458135] 0000000000000286 000000002fa171e7 ffff88007c8e7ab8
ffffffff813f7594
[ 34.458139] ffff88007fc96b80 7fffffffffffffff ffff88007c8e7ac8
ffffffff810a8f6b
[ 34.458143] ffff88007c8e7b18 ffffffff8184905b 00ff88007c8e7ae8
ffffffff8106463e
[ 34.458147] Call Trace:
[ 34.458161] [<ffffffff813f7594>] dump_stack+0x63/0x8f
[ 34.458166] [<ffffffff810a8f6b>] __schedule_bug+0x4b/0x60
[ 34.458185] [<ffffffff8184905b>] __schedule+0x5eb/0x7a0
[ 34.458191] [<ffffffff8106463e>] ? kvm_sched_clock_read+0x1e/0x30
[ 34.458195] [<ffffffff81849245>] schedule+0x35/0x80
[ 34.458203] [<ffffffff8184c402>] schedule_timeout+0x1b2/0x270
[ 34.458207] [<ffffffff81848d74>] ? __schedule+0x304/0x7a0
[ 34.458212] [<ffffffff81849ca3>] wait_for_completion+0xb3/0x140
[ 34.458217] [<ffffffff810aeed0>] ? wake_up_q+0x70/0x70
[ 34.458226] [<ffffffff810e7f68>] __wait_rcu_gp+0xc8/0xf0
[ 34.458231] [<ffffffff810e9fd8>] synchronize_sched.part.58+0x38/0x50
[ 34.458235] [<ffffffff810ec570>] ? call_rcu_bh+0x20/0x20
[ 34.458239] [<ffffffff810e7e80>] ?
trace_raw_output_rcu_utilization+0x60/0x60
[ 34.458244] [<ffffffff810ec643>] synchronize_sched+0x33/0x40
[ 34.458251] [<ffffffffc0510f71>] __l2tp_session_unhash+0xd1/0xe0
[l2tp_core]
[ 34.458256] [<ffffffffc051101e>] l2tp_tunnel_closeall+0x9e/0x140
[l2tp_core]
[ 34.458261] [<ffffffffc0511219>] l2tp_tunnel_delete+0x19/0x70 [l2tp_core]
[ 34.458265] [<ffffffffc05112bb>] l2tp_exit_net+0x4b/0x80 [l2tp_core]
[ 34.458269] [<ffffffff81732188>] ops_exit_list.isra.4+0x38/0x60
[ 34.458273] [<ffffffff817331e4>] cleanup_net+0x1c4/0x2a0
[ 34.458281] [<ffffffff8109ccfc>] process_one_work+0x1fc/0x490
[ 34.458285] [<ffffffff8109cfdb>] worker_thread+0x4b/0x500
[ 34.458290] [<ffffffff8109cf90>] ? process_one_work+0x490/0x490
[ 34.458293] [<ffffffff810a37c8>] kthread+0xd8/0xf0
[ 34.458298] [<ffffffff8184d522>] ret_from_fork+0x22/0x40
[ 34.458302] [<ffffffff810a36f0>] ? kthread_create_on_node+0x1b0/0x1b0
[ 34.514067] ------------[ cut here ]------------

4.12.14:
[ 20.760253] ------------[ cut here ]------------
[ 20.760256] kernel BUG at
/home/kernel/COD/linux/net/ipv6/xfrm6_policy.c:265!
[ 20.760299] invalid opcode: 0000 [#1] SMP
[ 20.760320] Modules linked in: appletalk psnap llc esp6
xfrm6_mode_transport esp4 xfrm4_mode_transport xfrm_user xfrm_algo
l2tp_ip6 l2tp_eth l2tp_ip l2tp_netlink veth l2tp_core ip6_udp_tunnel
udp_tunnel binfmt_misc dm_multipath scsi_dh_rdac scsi_dh_emc
scsi_dh_alua joydev ppdev snd_hda_codec_generic kvm_intel kvm irqbypass
snd_hda_intel snd_hda_codec snd_hda_core input_leds snd_hwdep serio_raw
snd_pcm snd_timer hid_generic snd soundcore parport_pc parport mac_hid
qemu_fw_cfg sch_fq_codel virtio_rng ip_tables x_tables autofs4 usbhid
hid btrfs raid10 raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel
aes_x86_64 crypto_simd qxl glue_helper ttm cryptd drm_kms_helper psmouse
[ 20.760677] syscopyarea sysfillrect virtio_blk sysimgblt fb_sys_fops
drm floppy virtio_net i2c_piix4 pata_acpi
[ 20.760731] CPU: 3 PID: 49 Comm: kworker/u8:1 Not tainted
4.12.14-041214-generic #201709200843
[ 20.760772] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.12.0-1 04/01/2014
[ 20.760814] Workqueue: netns cleanup_net
[ 20.760836] task: ffff8aa4bcbbad00 task.stack: ffff9dc5804c0000
[ 20.760867] RIP: 0010:xfrm6_dst_ifdown+0xa0/0xb0
[ 20.760890] RSP: 0018:ffff9dc5804c3be0 EFLAGS: 00010246
[ 20.760916] RAX: ffff8aa4b6e6a000 RBX: ffff8aa4bc1b3500 RCX:
0000000000000000
[ 20.760950] RDX: 0000000000000001 RSI: ffff8aa4b6f39000 RDI:
ffff8aa4bc1b3500
[ 20.760984] RBP: ffff9dc5804c3c08 R08: 0000000000000000 R09:
ffffffffb49fd7a0
[ 20.761017] R10: ffff9dc5804c3c70 R11: 0000000000000000 R12:
ffff8aa4b6f39000
[ 20.761050] R13: ffff8aa4b6f39000 R14: ffff8aa4bc1b3500 R15:
0000000000000000
[ 20.761085] FS: 0000000000000000(0000) GS:ffff8aa4bfd80000(0000)
knlGS:0000000000000000
[ 20.761123] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 20.761150] CR2: 00007fa5cd126718 CR3: 000000007c382000 CR4:
00000000001406e0
[ 20.761189] Call Trace:
[ 20.761207] dst_ifdown+0x26/0x80
[ 20.761226] dst_dev_event+0x5c/0x170
[ 20.761247] notifier_call_chain+0x4a/0x70
[ 20.761269] raw_notifier_call_chain+0x16/0x20
[ 20.761293] call_netdevice_notifiers_info+0x35/0x60
[ 20.761318] netdev_run_todo+0xcf/0x300
[ 20.761340] rtnl_unlock+0xe/0x10
[ 20.761359] default_device_exit_batch+0x153/0x180
[ 20.761385] ? do_wait_intr_irq+0x90/0x90
[ 20.761408] ops_exit_list.isra.6+0x52/0x60
[ 20.761430] cleanup_net+0x1ca/0x2b0
[ 20.761451] process_one_work+0x1e7/0x410
[ 20.761472] worker_thread+0x4a/0x410
[ 20.761492] kthread+0x125/0x140
[ 20.761511] ? process_one_work+0x410/0x410
[ 20.761532] ? kthread_create_on_node+0x70/0x70
[ 20.761556] ret_from_fork+0x25/0x30
[ 20.761575] Code: f0 00 00 00 75 05 e8 10 6f 00 00 4c 89 bb 58 01 00 00
f0 41 ff 04 24 48 8b 5b 10 48 83 7b 48 00 75 d4 f0 41 ff 0c 24 eb 8e f3
c3 <0f> 0b 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 55 b9 06 00 00
[ 20.761695] RIP: xfrm6_dst_ifdown+0xa0/0xb0 RSP: ffff9dc5804c3be0
[ 20.762104] ---[ end trace b22472ed4abae541 ]---

So all in all, the test is great for finding bugs. I thought I should
flag these issues up.

Regards,

Colin
