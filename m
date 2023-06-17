Return-Path: <netdev+bounces-11704-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 294DB733F4D
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 09:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C876628192E
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 07:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EED536FD6;
	Sat, 17 Jun 2023 07:50:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371FC1C33
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 07:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 041F3C433C9;
	Sat, 17 Jun 2023 07:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686988220;
	bh=E5dXCKiqh6iKJlj1dFBtoIZADa6MY6gMwP/enO+Fa4M=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=H8pMOgxtbz2aOiJgdkiL9uCrG5U0byLDMqlTUrr4AMYRMISODH+owN+HSp9Vrriri
	 NuxI5keNgp9uO8QMhnTkaYkEGi9XB8G63m0EuY96pqjHLQOd1XqggXc0RIJ/f97N67
	 Dp4olEK0K581qJJeKWfaWa8P+FSUGKgd1n6IuDCs1sH1gTEfE2BefwWnWBcQCDLnKL
	 WPZdd/oaq+mbpNeXqZqTNNX2pAVleu1OuKWS7MwBAD9B6M/OB3BGkIBz6nHVsatOjQ
	 LqSW5krJpi+yY/LFhUyAnvmI7J09cCYFXStG7dFPyf2e9ToiQgN7ss7o6LUZvMwhhk
	 It+8yiW6s3+eg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CF7BEE21EEA;
	Sat, 17 Jun 2023 07:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] devlink: report devlink_port_type_warn source device
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168698821984.31280.12092809743432224228.git-patchwork-notify@kernel.org>
Date: Sat, 17 Jun 2023 07:50:19 +0000
References: <20230615095447.8259-1-poros@redhat.com>
In-Reply-To: <20230615095447.8259-1-poros@redhat.com>
To: Petr Oros <poros@redhat.com>
Cc: netdev@vger.kernel.org, jiri@resnulli.us, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 15 Jun 2023 11:54:47 +0200 you wrote:
> devlink_port_type_warn is scheduled for port devlink and warning
> when the port type is not set. But from this warning it is not easy
> found out which device (driver) has no devlink port set.
> 
> [ 3709.975552] Type was not set for devlink port.
> [ 3709.975579] WARNING: CPU: 1 PID: 13092 at net/devlink/leftover.c:6775 devlink_port_type_warn+0x11/0x20
> [ 3709.993967] Modules linked in: openvswitch nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nfnetlink bluetooth rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache netfs vhost_net vhost vhost_iotlb tap tun bridge stp llc qrtr intel_rapl_msr intel_rapl_common i10nm_edac nfit libnvdimm x86_pkg_temp_thermal mlx5_ib intel_powerclamp coretemp dell_wmi ledtrig_audio sparse_keymap ipmi_ssif kvm_intel ib_uverbs rfkill ib_core video kvm iTCO_wdt acpi_ipmi intel_vsec irqbypass ipmi_si iTCO_vendor_support dcdbas ipmi_devintf mei_me ipmi_msghandler rapl mei intel_cstate isst_if_mmio isst_if_mbox_pci dell_smbios intel_uncore isst_if_common i2c_i801 dell_wmi_descriptor wmi_bmof i2c_smbus intel_pch_thermal pcspkr acpi_power_meter xfs libcrc32c sd_mod sg nvme_tcp mgag200 i2c_algo_bit nvme_fabrics drm_shmem_helper drm_kms_helper nvme syscopyarea ahci sysfillrect sysimgblt nvme_core fb_sys_fops crct10dif_pclmul libahci mlx5_core sfc crc32_pclmul nvme_common drm
> [ 3709.994030]  crc32c_intel mtd t10_pi mlxfw libata tg3 mdio megaraid_sas psample ghash_clmulni_intel pci_hyperv_intf wmi dm_multipath sunrpc dm_mirror dm_region_hash dm_log dm_mod be2iscsi bnx2i cnic uio cxgb4i cxgb4 tls libcxgbi libcxgb qla4xxx iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse
> [ 3710.108431] CPU: 1 PID: 13092 Comm: kworker/1:1 Kdump: loaded Not tainted 5.14.0-319.el9.x86_64 #1
> [ 3710.108435] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.8.2 09/14/2022
> [ 3710.108437] Workqueue: events devlink_port_type_warn
> [ 3710.108440] RIP: 0010:devlink_port_type_warn+0x11/0x20
> [ 3710.108443] Code: 84 76 fe ff ff 48 c7 03 20 0e 1a ad 31 c0 e9 96 fd ff ff 66 0f 1f 44 00 00 0f 1f 44 00 00 48 c7 c7 18 24 4e ad e8 ef 71 62 ff <0f> 0b c3 cc cc cc cc 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 f6 87
> [ 3710.108445] RSP: 0018:ff3b6d2e8b3c7e90 EFLAGS: 00010282
> [ 3710.108447] RAX: 0000000000000000 RBX: ff366d6580127080 RCX: 0000000000000027
> [ 3710.108448] RDX: 0000000000000027 RSI: 00000000ffff86de RDI: ff366d753f41f8c8
> [ 3710.108449] RBP: ff366d658ff5a0c0 R08: ff366d753f41f8c0 R09: ff3b6d2e8b3c7e18
> [ 3710.108450] R10: 0000000000000001 R11: 0000000000000023 R12: ff366d753f430600
> [ 3710.108451] R13: ff366d753f436900 R14: 0000000000000000 R15: ff366d753f436905
> [ 3710.108452] FS:  0000000000000000(0000) GS:ff366d753f400000(0000) knlGS:0000000000000000
> [ 3710.108453] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3710.108454] CR2: 00007f1c57bc74e0 CR3: 000000111d26a001 CR4: 0000000000773ee0
> [ 3710.108456] PKRU: 55555554
> [ 3710.108457] Call Trace:
> [ 3710.108458]  <TASK>
> [ 3710.108459]  process_one_work+0x1e2/0x3b0
> [ 3710.108466]  ? rescuer_thread+0x390/0x390
> [ 3710.108468]  worker_thread+0x50/0x3a0
> [ 3710.108471]  ? rescuer_thread+0x390/0x390
> [ 3710.108473]  kthread+0xdd/0x100
> [ 3710.108477]  ? kthread_complete_and_exit+0x20/0x20
> [ 3710.108479]  ret_from_fork+0x1f/0x30
> [ 3710.108485]  </TASK>
> [ 3710.108486] ---[ end trace 1b4b23cd0c65d6a0 ]---
> 
> [...]

Here is the summary with links:
  - [net-next] devlink: report devlink_port_type_warn source device
    https://git.kernel.org/netdev/net-next/c/a52305a81d6b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



