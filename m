Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281FA2C4893
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 20:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbgKYTjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 14:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729399AbgKYTjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 14:39:17 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC77C0613D4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 11:39:16 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id q4so1076735ual.8
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 11:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=4qSFgONcWxNVuWZJMShq+yX3WI4t0Vf2vL4gOAZxMIg=;
        b=ckJvFxub2jkDZmr6IUI0m0XhS9amAF6H+TDuVi5RnMe9b8FtPHEYKslkW7u1/ZOFxy
         IB5YM45ZYrnz5vfCHkjnYQHi0KZaEsQwEZus/g07+bUc2e9APdWlCFOngza15TklaKq5
         NZc/jI3Vl6lL1bFAqRX7x0BFYhwgTQBMFKN3nSjzbkkUEmAiy+SB9n+u+TjmTbOO+LR4
         RdZRJpSIfng89jPZ/BzhQC1/Na2awOt+wUTPUi3fFzzOdtJK0zUsL1sXJmnfDQ2JheCy
         b5qFICTokADXF68aw7X1uqhvLRisACLwXetxySlvv0FAc2TX8CP5GeSu4CR7ozf8ZoON
         GLvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=4qSFgONcWxNVuWZJMShq+yX3WI4t0Vf2vL4gOAZxMIg=;
        b=Y1lV793gt6ioPZQZ/MLDSc4EIosPEY7gJVlEC37iJVgT7cXbVuga+ASPQWxcliOaVK
         83RfZnzVnurtv/FTpyTNJfEJ9kW54B2m6a0Pm883Nc8Z0F5v94NKp8TPUgqDArkhj+Hc
         pYksM/OXZHJ9os+J6vTpZA6h3ijGhhwqrsL+oGnP4Lvp3UvBSEzm3c7JExk7ea7wKLBP
         Ugq8/aH4Skb1My4MyQ3+Mozci5ERZlkRh7QMrJF0kSVjw9fiqe/JbDzoub9kmsPuKTv8
         0ovAf9srwHOtX/kYVlwUxLnFRwcahijkKJ4md+RfrI8H2Clhb0WJy0iKMHY+LWDg93V6
         BoCg==
X-Gm-Message-State: AOAM5304uvWEkOopi24XInyU35jOX3TX1wcISvEku4EUvSIiN24r4Kbj
        4K5TUlIE63+iAjxV8S1/VrJbB0N8KszH7ALr1/8ve/cxQb8SFw==
X-Google-Smtp-Source: ABdhPJycMMShc/ogYjaGwdx7QBR6rBpR0/LvpIEzcWWaGUnXb1XE6/4hpdk+Lr/0r5BvZCrbfN/YbSE0Tm7gnDwCr30=
X-Received: by 2002:ab0:7846:: with SMTP id y6mr3295110uaq.16.1606333155510;
 Wed, 25 Nov 2020 11:39:15 -0800 (PST)
MIME-Version: 1.0
From:   Marc Smith <msmith626@gmail.com>
Date:   Wed, 25 Nov 2020 14:39:04 -0500
Message-ID: <CAH6h+heNaKFT-xYdbOfYUa0Vp=Ybohb6A0TQ=N1EJDvFE6wbpw@mail.gmail.com>
Subject: NETDEV WATCHDOG: s1p1 (bnxt_en): transmit queue 2 timed out
To:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm using Linux 5.4.69 and observe the following occur occasionally
when my systems are passing a lot of network traffic:
[17879.277842] ------------[ cut here ]------------
[17879.279091] NETDEV WATCHDOG: s1p1 (bnxt_en): transmit queue 2 timed out
[17879.279111] WARNING: CPU: 5 PID: 0 at net/sched/sch_generic.c:447
dev_watchdog+0x121/0x17e
[17879.279112] Modules linked in: ocs_fc_scst(OE) qla2x00tgt(OE)
fcst(OE) scst_changer(OE) scst_tape(OE) scst_vdisk(OE) scst_disk(OE)
ib_srpt(O) isert_s
cst(O) iscsi_scst(O) scst(OE) bcache(E) nvmet_fc(O) nvmet_rdma(O)
nvmet(O) qla2xxx_scst(OE) nvme_fc(O) nvme_fabrics(O) bonding
cls_switchtec(O) qede qed
 mlx5_core(O) mlxfw(O) bna rdmavt(O) ib_umad(O) rdma_ucm(O)
ib_uverbs(O) ib_srp(O) rdma_cm(O) ib_cm(O) iw_cm(O) iw_cxgb4(O)
iw_cxgb3(O) ib_qib(O) mlx4_i
b(O) mlx4_core(O) ib_core(O) ib_mthca(O) nvme(O) nvme_core(O)
mlx_compat(O) [last unloaded: bcache]
[17879.279137] CPU: 5 PID: 0 Comm: swapper/5 Kdump: loaded Tainted: G
         OE     5.4.69-esos.prod #1
[17879.279137] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[17879.279139] RIP: 0010:dev_watchdog+0x121/0x17e
[17879.279140] Code: a8 eb 00 00 75 3c 48 89 ef c6 05 76 a8 eb 00 01
e8 90 68 fc ff 44 89 e9 48 89 ee 48 c7 c7 49 8b 5d 82 48 89 c2 e8 84
ce 51 ff <0f>
0b eb 14 41 ff c5 48 05 40 01 00 00 41 39 f5 0f 85 4b ff ff ff
[17879.279141] RSP: 0018:ffffc90000184e80 EFLAGS: 00010282
[17879.279142] RAX: 0000000000000000 RBX: ffff88861a4a4440 RCX: 00000000000039e1
[17879.279142] RDX: 0000000000000001 RSI: ffffc90000184d6c RDI: ffffffff8309d84c
[17879.279143] RBP: ffff88861a4a4000 R08: 0000000000000001 R09: 000000000003c400
[17879.279143] R10: 0000000000000000 R11: 000000000000005c R12: ffff888590eb01e8
[17879.279144] R13: 0000000000000002 R14: dead000000000122 R15: 0000000000000001
[17879.279148] FS:  0000000000000000(0000) GS:ffff888627b40000(0000)
knlGS:0000000000000000
[17879.279148] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[17879.279149] CR2: 00007f5587732926 CR3: 0000000598caa000 CR4: 0000000000340ee0
[17879.279149] Call Trace:
[17879.279161]  <IRQ>
[17879.279163]  ? netif_carrier_off+0x1f/0x1f
[17879.279166]  call_timer_fn+0x71/0x115
[17879.279167]  __run_timers.part.0+0x154/0x18f
[17879.279169]  ? tick_sched_do_timer+0x39/0x39
[17879.279170]  ? update_process_times+0x3c/0x51
[17879.279171]  ? tick_sched_timer+0x33/0x62
[17879.279173]  ? do_raw_spin_lock+0x2b/0x52
[17879.279176]  run_timer_softirq+0x21/0x43
[17879.279189]  __do_softirq+0x11b/0x26e
[17879.279191]  irq_exit+0x41/0x80
[17879.279193]  smp_apic_timer_interrupt+0xfd/0x10a
[17879.279194]  apic_timer_interrupt+0xf/0x20
[17879.279195]  </IRQ>
[17879.279196] RIP: 0010:default_idle+0x18/0x27
[17879.279197] Code: 48 8d 65 d8 44 89 e0 5b 41 5c 41 5d 41 5e 41 5f
5d c3 bf 01 00 00 00 65 8b 35 24 8a 31 7e e8 b1 8d 32 ff e8 06 8d 32
ff fb f4 <83> cf ff 65 8b 35 0e 8a 31 7e e9 9b 8d 32 ff 53 65 48 8b 1c
25 00
[17879.279198] RSP: 0018:ffffc9000008fee0 EFLAGS: 00000246 ORIG_RAX:
ffffffffffffff13
[17879.279199] RAX: 0000000000000000 RBX: ffff888624660000 RCX: 0000000000000020
[17879.279199] RDX: 0000000000000001 RSI: 0000000000000005 RDI: 0000000000000001
[17879.279199] RBP: 0000000000000000 R08: 000000000009a6a8 R09: 0000000000000000
[17879.279200] R10: ffff888627b680c0 R11: 0000000000001800 R12: 0000000000000000
[17879.279200] R13: 0000000000000005 R14: 0000000000000000 R15: 0000000000000000
[17879.279203]  do_idle+0xcf/0x1fe
[17879.279204]  ? do_idle+0x2/0x1fe
[17879.279205]  cpu_startup_entry+0x18/0x1a
[17879.279207]  start_secondary+0x14b/0x169
[17879.279209]  secondary_startup_64+0xa4/0xb0
[17879.279210] ---[ end trace e7f791208a26e22c ]---
[17879.279213] bnxt_en 0000:01:09.0 s1p1: TX timeout detected,
starting reset task!
[17883.075299] bnxt_en 0000:01:09.0 s1p1: Resp cmpl intr err msg: 0x51
[17883.075302] bnxt_en 0000:01:09.0 s1p1: hwrm_ring_free type 1
failed. rc:fffffff0 err:0
[17886.957100] bnxt_en 0000:01:09.0 s1p1: Resp cmpl intr err msg: 0x51
[17886.957103] bnxt_en 0000:01:09.0 s1p1: hwrm_ring_free type 2
failed. rc:fffffff0 err:0
[17890.843023] bnxt_en 0000:01:09.0 s1p1: Resp cmpl intr err msg: 0x51
[17890.843025] bnxt_en 0000:01:09.0 s1p1: hwrm_ring_free type 2
failed. rc:fffffff0 err:0

I have several of these same machines, and they all experience this --
it's temporary and the NIC seems to recover, but is a nuisance as it
temporarily disrupts traffic

I found a similar post from a few years back
(https://www.spinics.net/lists/netdev/msg519150.html) where the
symptoms sound very similar to this; the user was advised to upgrade
the firmware on their adapters.

I'm up for flashing a new firmware version, but I'm not sure what the
correct/recommended firmware version is for these NICs when using the
in-tree 5.4.69 bnxt_en kernel driver?

c8:00.0 Ethernet controller [0200]: Broadcom Inc. and subsidiaries
BCM57416 NetXtreme-E Dual-Media 10G RDMA Ethernet Controller
[14e4:16d8] (rev 01)
c8:00.1 Ethernet controller [0200]: Broadcom Inc. and subsidiaries
BCM57416 NetXtreme-E Dual-Media 10G RDMA Ethernet Controller
[14e4:16d8] (rev 01)

# ethtool -i s1p1
driver: bnxt_en
version: 1.10.0
firmware-version: 214.0.191.0
expansion-rom-version:
bus-info: 0000:01:09.0
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: no

It's probably worthwhile mentioning that I'm using these adapters with
SR-IOV, and the transmit timeout messages that I receive are displayed
in the guest OS that runs Linux 5.4.69 (using VF's from the host).

I also see the transmit timeout messages on another VM that uses a
RHEL 7 guest OS and uses the upstream driver from Broadcom (using VF's
on the same host as described above):
[49103.695045] ------------[ cut here ]------------
[49103.695717] WARNING: CPU: 5 PID: 0 at net/sched/sch_generic.c:356
dev_watchdog+0x248/0x260
[49103.696101] NETDEV WATCHDOG: p1p2 (bnxt_en): transmit queue 5 timed out
[49103.696392] Modules linked in: ipt_MASQUERADE
nf_nat_masquerade_ipv4 nf_conntrack_netlink nfnetlink iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype xt_conntrack
nf_nat br_netfilter bridge stp llc nfsd auth_rpcgss nfs_acl lockd
grace ip_vs nf_conntrack libcrc32c cvfs(POE) dm_round_robin iscsi_tcp
libiscsi_tcp overlay(T) iptable_filter mpt2sas raid_class
scsi_transport_sas mptctl mptbase ib_isert iscsi_target_mod ib_srpt
target_core_mod ib_srp scsi_transport_srp scsi_tgt ib_ipoib ib_ucm
ib_umad rpcrdma sunrpc dm_mirror dm_region_hash rdma_ucm dm_log
ib_uverbs ib_iser rdma_cm iw_cm ib_cm libiscsi scsi_transport_iscsi
snd_hda_codec_generic ppdev snd_hda_intel snd_hda_codec crc32_pclmul
ghash_clmulni_intel bnxt_re(OE) snd_hda_core aesni_intel snd_hwdep qxl
lrw gf128mul snd_seq glue_helper
[49103.701022]  ttm joydev ablk_helper cryptd snd_seq_device ib_core
sg snd_pcm virtio_balloon drm_kms_helper snd_timer pcspkr snd
syscopyarea sysfillrect soundcore sysimgblt fb_sys_fops drm parport_pc
parport i2c_piix4 i2c_core shpchp dm_multipath dm_mod ip_tables ext4
mbcache jbd2 sd_mod crc_t10dif crct10dif_generic ata_generic pata_acpi
virtio_net virtio_console virtio_scsi crct10dif_pclmul
crct10dif_common crc32c_intel bnxt_en(OE) floppy ata_piix ptp libata
pps_core serio_raw devlink virtio_pci virtio_ring virtio
[49103.705021] CPU: 5 PID: 0 Comm: swapper/5 Kdump: loaded Tainted: P
         OE  ------------ T 3.10.0-862.14.4.1.el7.qtm.x86_64 #1
[49103.706021] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[49103.707018] Call Trace:
[49103.708015]  <IRQ>  [<ffffffffaeb13754>] dump_stack+0x19/0x1b
[49103.709019]  [<ffffffffae4945d8>] __warn+0xd8/0x100
[49103.710015]  [<ffffffffae49465f>] warn_slowpath_fmt+0x5f/0x80
[49103.711014]  [<ffffffffaea1bad8>] dev_watchdog+0x248/0x260
[49103.712013]  [<ffffffffaea1b890>] ?
dev_deactivate_queue.constprop.27+0x60/0x60
[49103.713015]  [<ffffffffae4a4a38>] call_timer_fn+0x38/0x110
[49103.713191]  [<ffffffffaea1b890>] ?
dev_deactivate_queue.constprop.27+0x60/0x60
[49103.714820]  [<ffffffffae4a6f2d>] run_timer_softirq+0x22d/0x310
[49103.715011]  [<ffffffffae49dba5>] __do_softirq+0xf5/0x280
[49103.716258]  [<ffffffffaeb28cec>] call_softirq+0x1c/0x30
[49103.717016]  [<ffffffffae42e625>] do_softirq+0x65/0xa0
[49103.718014]  [<ffffffffae49df25>] irq_exit+0x105/0x110
[49103.719016]  [<ffffffffaeb2a088>] smp_apic_timer_interrupt+0x48/0x60
[49103.720013]  [<ffffffffaeb267b2>] apic_timer_interrupt+0x162/0x170
[49103.720174]  <EOI>  [<ffffffffaeb1ad90>] ? __cpuidle_text_start+0x8/0x8
[49103.721014]  [<ffffffffaeb1af96>] ? native_safe_halt+0x6/0x10
[49103.722018]  [<ffffffffaeb1adae>] default_idle+0x1e/0xc0
[49103.723014]  [<ffffffffae4366e3>] arch_cpu_idle+0x23/0xb0
[49103.724013]  [<ffffffffae4f5dea>] cpu_startup_entry+0x14a/0x1e0
[49103.725013]  [<ffffffffae4571b7>] start_secondary+0x1f7/0x270
[49103.726014]  [<ffffffffae4000d5>] start_cpu+0x5/0x14
[49103.726191] ---[ end trace b238e44727b7f923 ]---
[49103.727014] bnxt_en 0000:01:09.1 p1p2: TX timeout detected,
starting reset task!
[49103.729412] infiniband bnxt_re1: bnxt_re_stop: L2 driver notified
to stop.Attempting to stop and Dispatching event to inform the stack
[49103.730913] ib_srpt srpt_remove_one(bnxt_re1): nothing to do.
[49107.646676] bnxt_en 0000:01:09.1 p1p2: Resp cmpl intr err msg: 0x51
[49107.647543] bnxt_en 0000:01:09.1 p1p2: hwrm_ring_free type 1
failed. rc:fffffff0 err:0

# ethtool -i p1p2
driver: bnxt_en
version: 1.10.1216.0.169.4Q_2
firmware-version: 214.0.191.0
expansion-rom-version:
bus-info: 0000:01:09.1
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: yes
supports-priv-flags: no


I don't observe any messages on the host (hypervisor) when these
events occur in the VM's. So two different VM's using VF's from the
same host adapter running different kernels / drivers; so sounds like
firmware update is needed, just not sure what the best version is for
our use case?

Thanks for your time.


--Marc
