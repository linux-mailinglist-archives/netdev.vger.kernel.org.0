Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1B23E036A
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 16:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237275AbhHDOgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 10:36:14 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:59512
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236460AbhHDOgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 10:36:12 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 14A0D3F352
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 14:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628087759;
        bh=K5TNPGczlna7cZJ2HSa6Pq+LnWnwehyD5R/FozLlvyo=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=ErV4xZBZbJxdI53OmG7qkNNMcuZhqU52HtLBaRXRHTsyLFy1nKpzV3CAWRmHJLpqq
         BRSjo3ef35HkjJgkHk5LatrWzvCHu1TksXrTDNhGLVJCevzq4n74MklcNDhWMvpxQO
         N4gb3UyODMvRhB4t/YcEt906FJBbVoinZtqfTt2avGoruiIHqibou04iZDqSyrtM0S
         60AH5xvlPS2LZ8PTxp92cq0PIXK/oRp/DgNoK8lRZZaNEiYCuYcqcmfdr844tb/EuY
         9C3jo7/TuXz8s9SXJbs1xxv5aqrzY6FuH2bGmqPxNWKfLxh47q15V+UjPsCiHMdAeI
         5XOD3BmDBsnOg==
Received: by mail-ed1-f70.google.com with SMTP id x1-20020a05640218c1b02903bc7f97f858so1566520edy.2
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 07:35:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K5TNPGczlna7cZJ2HSa6Pq+LnWnwehyD5R/FozLlvyo=;
        b=bw/Gy0cF/FwalsrC3MBmq9pSlvuEnOKiCEVBac6Pe7n0iiPDM2Yxwit5tnRNZbFb8a
         +TuQcBrcd15d/QxWgrlFmhy8Eog0RsfVlia4Za1Qpr50QXsD/aUwHaZEZaBjwv1ceB0v
         /CX2VPwIINAEB5ymqbSP7TBx8AKDCNYu4Hedl+81scIZrJJyjgzuwnFi+/DUjlpZSria
         BmnTCyS0wpPJ55xPLjbhrxmmA2YbFJ+4xmkEtlcBIOscG3FNNiMGf7Z+B1FvSpjfPvRa
         2Cu3dtdGLG1CXaV+1PCPj0YzYegixr4volD+6ozLI5m8sVrmYn3QtZynGxdgMH0EgFwJ
         O3dw==
X-Gm-Message-State: AOAM533bEbLX0eXqVm6xvNAoL/3ZKTUcFUmuFun2HiGurI4/e8K13C3S
        MxWY7jJeR5MlV2K+3KINiH9TPQXfCHYiGig0NIYlLkUFPq63eH0Pw9tl8/b4QGNtm+tNx5/2+YO
        Zf8fCu11W0aRZVKGqV56XI1vH6rwyGhwt4+QhDmcL7fENlS7sgw==
X-Received: by 2002:aa7:c9d8:: with SMTP id i24mr18348edt.79.1628087758605;
        Wed, 04 Aug 2021 07:35:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJySrlECEieDBDFouY+AXeH4RwTrpMkTpPgxc2XCW4494s2y9dDuty2whvMSHK4uGzw1yfptzkYC9y2OHbIM6iM=
X-Received: by 2002:aa7:c9d8:: with SMTP id i24mr18321edt.79.1628087758363;
 Wed, 04 Aug 2021 07:35:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210514071452.25220-1-kai.heng.feng@canonical.com>
 <20210802030538.2023-1-hdanton@sina.com> <CAAd53p4NO3KJkn2Zp=hxQOtR8vynkJpcPmNtwv2R6z=zei056Q@mail.gmail.com>
 <20210803074722.2383-1-hdanton@sina.com>
In-Reply-To: <20210803074722.2383-1-hdanton@sina.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Wed, 4 Aug 2021 22:35:43 +0800
Message-ID: <CAAd53p6wi7pk6yFgTnG-JDd9e4zCn3F40bioYyGbAqYg5kMHZQ@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Shutdown controller after workqueues are
 flushed or cancelled
To:     Hillf Danton <hdanton@sina.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Mattijs Korpershoek <mkorpershoek@baylibre.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "bluez mailin list (linux-bluetooth@vger.kernel.org)" 
        <linux-bluetooth@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 3:47 PM Hillf Danton <hdanton@sina.com> wrote:
>
> On Tue, 3 Aug 2021 14:45:07 +0800 Kai-Heng Feng wrote:
> >On Mon, Aug 2, 2021 at 11:05 AM Hillf Danton <hdanton@sina.com> wrote:
> >>
> >> Given the skb_get in hci_req_sync_complete makes it safe to free skb on
> >> driver side, I doubt this patch is the correct fix as it is.
> >
> >Some workqueues are still active.
> >The shutdown() should be called at least after hci_request_cancel_all().
>
> What is muddy then is how active workqueues prevent skb_get from protecting
> kfree_skb. Can you spot what workqueue it is?

I managed to reproduce the issue with another kernel splat:
------------[ cut here ]------------
kernel BUG at mm/slub.c:321!
invalid opcode: 0000 [#1] SMP NOPTI
CPU: 2 PID: 2208 Comm: kworker/u9:3 Not tainted 5.14.0-rc4+ #16
Hardware name: HP HP ProBook 650 G8 Notebook PC/87ED, BIOS T74 Ver.
01.03.04 01/07/2021
Workqueue: hci0 discov_update [bluetooth]
RIP: 0010:__slab_free+0x20c/0x3a0
Code: 00 44 0f b6 54 24 1a 8b 74 24 14 44 0f b6 4c 24 1b 44 8b 44 24
1c 48 89 44 24 08 48 8b 54 24 20 48 8b 7c 24 28 e9 ad fe ff ff <0f> 0b
49 3b 54 24 28 0f 85 6b ff ff ff 49 89 5c 24 20 49 89 4c 24
RSP: 0018:ffffaa0e4164fc50 EFLAGS: 00010246
RAX: ffff9cc9a217e668 RBX: ffff9cc9a217e600 RCX: ffff9cc9a217e600
RDX: 000000008010000e RSI: ffffd09044885f80 RDI: ffff9cc980e96500
RBP: ffffaa0e4164fd00 R08: 0000000000000001 R09: ffffffff885b3a4e
R10: ffff9cc999aab800 R11: ffff9cc9a217e600 R12: ffffd09044885f80
R13: ffff9cc9a217e600 R14: ffff9cc980e96500 R15: ffff9cc9a217e600
FS:  0000000000000000(0000) GS:ffff9cca2b900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe164d5b98 CR3: 000000013f410002 CR4: 0000000000770ee0
PKRU: 55555554
Call Trace:
 ? psi_task_switch+0xc3/0x1e0
 ? __switch_to_asm+0x36/0x70
 ? skb_free_head+0x67/0x80
 kmem_cache_free+0x370/0x3d0
 ? kfree_skbmem+0x4e/0x90
 kfree_skbmem+0x4e/0x90
 kfree_skb+0x47/0xb0
 __hci_req_sync+0x134/0x2a0 [bluetooth]
 ? wait_woken+0x70/0x70
 discov_update+0x2ae/0x310 [bluetooth]
 process_one_work+0x21d/0x3c0
 worker_thread+0x53/0x420
 ? process_one_work+0x3c0/0x3c0
 kthread+0x127/0x150
 ? set_kthread_struct+0x50/0x50
 ret_from_fork+0x1f/0x30
Modules linked in: rfcomm cmac algif_hash algif_skcipher af_alg bnep
nls_iso8859_1 snd_soc_skl_hda_dsp snd_soc_intel_hda_dsp_common
snd_soc_hdac_hdmi snd_hda_codec_hdmi snd_hda_codec_realtek
snd_hda_codec_generic snd_soc_dmic snd_sof_pci_intel_tgl
snd_sof_intel_hda_common snd_soc_hdac_hda snd_sof_pci snd_sof
snd_sof_xtensa_dsp snd_sof_intel_hda snd_hda_ext_core
snd_soc_acpi_intel_match snd_soc_acpi ledtrig_audio snd_soc_core
snd_hda_intel snd_intel_dspcfg snd_hda_codec snd_hwdep snd_hda_core
snd_pcm snd_seq i915 snd_seq_device snd_timer hp_wmi intel_tcc_cooling
x86_pkg_temp_thermal intel_powerclamp i2c_algo_bit coretemp joydev
kvm_intel ttm mei_hdcp intel_rapl_msr platform_profile wmi_bmof kvm
uvcvideo crct10dif_pclmul btusb videobuf2_vmalloc videobuf2_memops
drm_kms_helper btrtl videobuf2_v4l2 crc32_pclmul btbcm
ghash_clmulni_intel input_leds videobuf2_common btintel snd videodev
syscopyarea sysfillrect sysimgblt aesni_intel mc serio_raw fb_sys_fops
bluetooth crypto_simd
 cec cryptd intel_cstate ecdh_generic efi_pstore ecc rc_core
hid_multitouch processor_thermal_device_pci_legacy mei_me
intel_soc_dts_iosf processor_thermal_device mei soundcore
processor_thermal_rfim ee1004 processor_thermal_mbox
processor_thermal_rapl intel_pmt_telemetry intel_rapl_common
intel_pmt_class ucsi_acpi typec_ucsi typec wmi soc_button_array
int3403_thermal int340x_thermal_zone video int3400_thermal
acpi_thermal_rel acpi_pad mac_hid intel_hid sparse_keymap sch_fq_codel
msr parport_pc ppdev lp drm parport ip_tables x_tables autofs4
hid_generic nvme nvme_core intel_lpss_pci e1000e intel_lpss i2c_i801
idma64 i2c_smbus xhci_pci xhci_pci_renesas vmd intel_pmt i2c_hid_acpi
i2c_hid hid pinctrl_tigerlake
---[ end trace c09445d4697039ed ]---

So hci_request_cancel_all() -> cancel_work_sync(&hdev->discov_update)
and can prevent the race from happening.

And the kernel splat is just one symptom of the issue, most of the
time it's just "Bluetooth: hci0: HCI reset during shutdown failed" in
dmesg.

Kai-Heng
