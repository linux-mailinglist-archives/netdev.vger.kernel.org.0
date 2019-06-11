Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB61F3C741
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 11:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404484AbfFKJdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 05:33:12 -0400
Received: from mout.web.de ([212.227.17.11]:53453 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404197AbfFKJdM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 05:33:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1560245590;
        bh=uWKhF0KKmacpgkeX1RaU3XxrZeH/dM8+/zJCB3AVCMs=;
        h=X-UI-Sender-Class:Date:From:To:Subject;
        b=FSc8dHCZfLlR/Q99YdZo+uKVhUHqOGwFx/TTFTqUyAgfwnOKx6bzH2vK+Xa8V2+EH
         8Mkj3++T6OxKJxKnkxdfmzRdlF67NiiY3IFOLHwlETvub0axVn6MNURj9nqqP8UmXA
         Fw2ds8p1a/5Qq4L8n279QOW1qFLAfpADGxFLRv3Y=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from schienar ([128.141.85.100]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LkPjj-1gyYVp09Yh-00cN7Z for
 <netdev@vger.kernel.org>; Tue, 11 Jun 2019 11:33:10 +0200
Date:   Tue, 11 Jun 2019 11:32:51 +0200
From:   Julian Wollrath <jwollrath@web.de>
To:     netdev@vger.kernel.org
Subject: Kernel v5.2-rc4 trace involving nf_conntrack
Message-ID: <20190611113251.2e3feffe@schienar>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:pp7rD40ZGzEKX86muAwenl21K1g5x5xh0LDbqneFtNHvGgVb0LS
 On7qMCtyUaew+U36UJww/uhqfsASwT4Oe8GyEQBAyQiTDXiqcITgDkVjFFMzezVOE+tDKFb
 9vMGMoYX5Bt/ZLkQF/k75NtqOJiAMb3nOGKvshSqnzDGfVJG5Oe5VnVBmjXvKbZcuC1nkvW
 jLa/u+n4CFtt0bv2d1uAw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:+7zQpDmcErc=:vipNBkDDf2IH76240nrpge
 sm8WQbuuXGpBmB/oDlOoK2AQNaqfzJopntN2hJ7F+cQvnWRjv787/VzAwd2Y0SKO/lHpdH0hw
 +aUwsh7XJCo5TO0AFT58Ad8zaGXXkkLZwt8IYNqB9I8QvZ81Mvx/jUz0tS660BVFm8nn5vpPw
 bkUOHFPP6ePVp6dBJ25jP344UhWHLaHB9+QPIZYqxBOU6VhojXlNj/Yjk1jqr5PUaV0riPCTV
 ZiAM7nK9FMTZZELgNVzOVHWhE45z7klFqJ3cQ86UiW4MSlMzPeHBk5yOCWbK60fVNeP5bXS3G
 ifxMyWNP0Fz5c0bREYdDbjTBgen6Ay2XIMkihgF9bySFEDs9/3qtvdAgsZ4N5zmSxKtDa8rpz
 cRwzfsNPB6bAFBlEGG/bPq/RVjBctqeSfYqeJ7VCH6rPv/67Nl82Ge3JyjDQGKUVItNH53WLQ
 UTR4PbC3X4MqKsf4lqvv3Ep/wuuwzpiqXGPdhQNt6yw68LV3DHGZAT5TWzVbFgW/G0d5dv+a6
 iMs3Osq74wkuDv8BZ6LQmmWW3TxrJpF0XNprKzXwSeA4JSHaErVfHbmQkGZ4ig4rkFDcWu0KK
 llY6b4CUFle1tubO07S9oDiEodh95bJYd1ENl4un7tTgho0+e4HNnh+gCV+8aTUmbwN0gK17e
 rZd5YO5Llfl6fYP4vMquhsIWOL0dBtjBV5UgTSDroooDXfX6quPE8pxo1VRXelVNT9ZYxJ9V4
 v1XvDD1NjEhCLhiVjv79s+LR9pxNvTcDphv3ovgA7COwIc/LSwfDjR7tqBNvp6xUCbfkw5IkE
 RhOnxMKC6w7qmibrlVvivqvUyDKfK3LDesU8zFuJpgXMecw6TQj8tIOk1AyMCe/pNTFPEdQzE
 Y7+Dv2lWgRXa2Avkv4rzI52ND0nSo2mM7JLa3eh/NuMpkHVGdac0J9hguiEsUDeyYjIWf9R00
 O2Zyu2EjNNZfc2gK94HF8j3xsKRO8SPMQuY+o8NS+1Z9d1UTSYQGN
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I got the following trace on v5.2-rc4 involving nf_conntrack:

[  143.193245] general protection fault: 0000 [#1] SMP PTI
[  143.193264] CPU: 3 PID: 201 Comm: kworker/3:2 Tainted: G        W      =
   5.2.0-rc4 #1
[  143.193271] Hardware name: FUJITSU LIFEBOOK U747/FJNB2A5, BIOS Version =
1.17 09/11/2017
[  143.193292] Workqueue: events_power_efficient gc_worker [nf_conntrack]
[  143.193316] RIP: 0010:nf_ct_helper_destroy+0x21/0x40 [nf_conntrack]
[  143.193327] Code: 50 ff ff ff 0f 1f 44 00 00 48 8b 87 b8 00 00 00 48 85=
 c0 74 24 0f b6 50 10 84 d2 74 1d 4
4 0e <48> 8b 40 68 48 85 c0 74 05 e8 a1 b9 d9 e5 c3 c3 c3 66 66 2e 0f 1f
[  143.193335] RSP: 0018:ffffaa9780e9bdc0 EFLAGS: 00010286
[  143.193344] RAX: ff89bb1b62090000 RBX: ffffffffa66ae200 RCX: 0000000000=
000000
[  143.193350] RDX: 00000000000000ff RSI: 0000000000000000 RDI: ffff89bb49=
2b0000
[  143.193356] RBP: 0000000000000000 R08: 0000000000000010 R09: 0000746e65=
696369
[  143.193362] R10: 8080808080808080 R11: 0000000000000018 R12: 0000000000=
004900
[  143.193367] R13: ffff89bb492b0000 R14: ffffffffc0471c54 R15: 0000000000=
000002
[  143.193376] FS:  0000000000000000(0000) GS:ffff89bb5dd80000(0000) knlGS=
:0000000000000000
[  143.193382] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  143.193388] CR2: 00007fc6558b2008 CR3: 00000001b9c0a003 CR4: 0000000000=
3606e0
[  143.193394] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[  143.193400] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000=
000400
[  143.193404] Call Trace:
[  143.193425]  nf_ct_delete_from_lists+0x1d/0x140 [nf_conntrack]
[  143.193441]  ? __switch_to_asm+0x40/0x70
[  143.193451]  ? __switch_to_asm+0x34/0x70
[  143.193466]  nf_ct_delete+0x68/0x160 [nf_conntrack]
[  143.193477]  ? __switch_to_asm+0x34/0x70
[  143.193491]  nf_ct_gc_expired+0x64/0x80 [nf_conntrack]
[  143.193506]  gc_worker+0x24e/0x2e0 [nf_conntrack]
[  143.193525]  process_one_work+0x1f5/0x3f0
[  143.193539]  ? process_one_work+0x3f0/0x3f0
[  143.193551]  worker_thread+0x28/0x3c0
[  143.193564]  ? process_one_work+0x3f0/0x3f0
[  143.193574]  kthread+0x111/0x130
[  143.193586]  ? kthread_create_worker_on_cpu+0x60/0x60
[  143.193596]  ret_from_fork+0x35/0x40
[  143.193605] Modules linked in: kafs dns_resolver fcrypt pcbc rxrpc arc4=
 snd_hda_codec_hdmi iwlmvm snd_hda_
_generic btrtl btbcm mac80211 btintel bluetooth nft_counter iwlwifi uvcvid=
eo videobuf2_vmalloc intel_rapl vid
l videobuf2_v4l2 intel_powerclamp nft_limit videodev coretemp i915 drbg sn=
d_hda_intel videobuf2_common snd_us
t snd_usbmidi_lib snd_hda_core snd_hwdep ansi_cprng drm_kms_helper snd_pcm=
 snd_rawmidi syscopyarea snd_timer
snd soundcore serio_raw cfg80211 sysimgblt ecdh_generic ecc fb_sys_fops rf=
kill crc16 drm idma64 wmi battery b
ag_ipv6 nf_defrag_ipv4 tpm_crb tpm fujitsu_laptop sparse_keymap video acpi=
_pad ac nf_tables_set nf_tables nfn
her af_alg hid_generic usbhid hid dm_crypt dm_mod sd_mod crct10dif_pclmul =
i2c_designware_platform i2c_designw
l
[  143.193713]  ghash_clmulni_intel e1000e psmouse sdhci_pci ptp cqhci pps=
_core sdhci i2c_i801 mmc_core ahci
scsi_mod usbcore intel_lpss_pci intel_lpss usb_common
[  143.193753] ---[ end trace 473de765b5682889 ]---
[  143.193772] RIP: 0010:nf_ct_helper_destroy+0x21/0x40 [nf_conntrack]
[  143.193782] Code: 50 ff ff ff 0f 1f 44 00 00 48 8b 87 b8 00 00 00 48 85=
 c0 74 24 0f b6 50 10 84 d2 74 1d 48 01 d0 74 17 48 8b 00 48 85 c0 74 0e <=
48> 8b 40 68 48 85 c0 74 05 e8 a1 b9 d9 e5 c3 c3 c3 66 66 2e 0f 1f
[  143.193789] RSP: 0018:ffffaa9780e9bdc0 EFLAGS: 00010286
[  143.193796] RAX: ff89bb1b62090000 RBX: ffffffffa66ae200 RCX: 0000000000=
000000
[  143.193801] RDX: 00000000000000ff RSI: 0000000000000000 RDI: ffff89bb49=
2b0000
[  143.193807] RBP: 0000000000000000 R08: 0000000000000010 R09: 0000746e65=
696369
[  143.193812] R10: 8080808080808080 R11: 0000000000000018 R12: 0000000000=
004900
[  143.193817] R13: ffff89bb492b0000 R14: ffffffffc0471c54 R15: 0000000000=
000002
[  143.193825] FS:  0000000000000000(0000) GS:ffff89bb5dd80000(0000) knlGS=
:0000000000000000
[  143.193831] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  143.193837] CR2: 00007fc6558b2008 CR3: 00000001b9c0a003 CR4: 0000000000=
3606e0
[  143.193842] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[  143.193847] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000=
000400


Best regards,
Julian Wollrath

=2D-
 ()  ascii ribbon campaign - against html e-mail
 /\                        - against proprietary attachments
